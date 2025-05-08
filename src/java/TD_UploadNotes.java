import java.io.*;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Date;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/TD_UploadNotes")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class TD_UploadNotes extends HttpServlet {
    private static final String SAVE_DIR = "uploads/notes";
    private static final String DB_URL = "jdbc:derby://localhost:1527/blms";
    private static final String DB_USER = "akshita";
    private static final String DB_PASSWORD = "akshita";

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    // Redirect to the upload form page
    response.sendRedirect("TD_UploadNotes.jsp");
}
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter outt = response.getWriter();

        
        // Authentication check
        String role = (String) request.getSession().getAttribute("role");
        String userId = (String) request.getSession().getAttribute("userid");
        
        if (role == null || userId == null || !"Teacher".equalsIgnoreCase(role)) {
            response.sendRedirect("LoginPage.jsp?error=unauthorized");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        InputStream fileContent = null;
        FileOutputStream fos = null;

        try {
            // Get form parameters
            String teacherName = request.getParameter("teacherName");
            String subjectCode = request.getParameter("subjectCode");
            String subjectName = request.getParameter("subjectName");
            String topicName = request.getParameter("topicName");
            String courseSemester = request.getParameter("courseSemester");
            String section = request.getParameter("section");
            String notesTitle = request.getParameter("notesTitle");
            String description = request.getParameter("description");

            // New file handling section
            String savePath = "";
            Part filePart = request.getPart("Notes");
            String path = "C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web" + File.separator + SAVE_DIR;
            File file = new File(path);
            file.mkdir();
            String fileName = extractFileName(filePart);

            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("TD_UploadNotes.jsp?error=true&message=" + 
                                    java.net.URLEncoder.encode("No file uploaded.", "UTF-8"));
                return;
            }

            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            fileContent = filePart.getInputStream();

            // Save file to specified path
            File outputFile = new File(path + File.separator + uniqueFileName);
            try (FileOutputStream outputStream = new FileOutputStream(outputFile)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
            
            // Database operations
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            conn.setAutoCommit(false);

            // Get Teacher_id
            String teacherId = getTeacherId(conn, userId);
            
            // Get Class_section_id
            int classSectionId = getClassSectionId(conn, courseSemester, section);

            // Check and insert subject if needed
            checkAndInsertSubject(conn, subjectCode, subjectName);

            // Insert study material
            insertStudyMaterial(conn, teacherId, subjectCode, classSectionId, 
                              fileName, uniqueFileName, description);

            // Check and insert metadata
            checkAndInsertMetadata(conn, subjectCode, notesTitle);

            // Save file to server
            String uploadPath = request.getServletContext().getRealPath("/") + SAVE_DIR;
            saveFileToServer(uploadPath, uniqueFileName, fileContent);

            conn.commit();
            response.sendRedirect("TD_UploadNotes.jsp?success=true");

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            response.sendRedirect("TD_UploadNotes.jsp?error=true&message=" + 
                                java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } finally {
            closeResources(rs, pstmt, conn, fileContent, fos);
        }
    }

    private String extractFileName(Part part) {
    String contentDisp = part.getHeader("content-disposition");
    String[] tokens = contentDisp.split(";");
    for (String token : tokens) {
        if (token.trim().startsWith("filename")) {
            return token.substring(token.indexOf("=") + 2, token.length()-1);
        }
    }
    return "";
}
    
    private String getTeacherId(Connection conn, String userId) throws SQLException {
        String teacherId = null;
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT Teacher_id FROM Teacher_Info WHERE User_id = ?")) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    teacherId = rs.getString("Teacher_id");
                } else {
                    throw new SQLException("Teacher record not found for User ID: " + userId);
                }
            }
        }
        return teacherId;
    }

    private int getClassSectionId(Connection conn, String courseSemester, String section) throws SQLException {
        int classSectionId = -1;
        try (PreparedStatement pstmt = conn.prepareStatement(
                "SELECT Class_section_id FROM Class_Section WHERE Class_name = ? AND Section = ?")) {
            pstmt.setString(1, courseSemester);
            pstmt.setString(2, section);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    classSectionId = rs.getInt("Class_section_id");
                } else {
                    throw new SQLException("Class section not found");
                }
            }
        }
        return classSectionId;
    }

    private void checkAndInsertSubject(Connection conn, String subjectCode, String subjectName) throws SQLException {
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT 1 FROM Subject_Info WHERE Subject_code = ?")) {
            pstmt.setString(1, subjectCode);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    try (PreparedStatement insertPstmt = conn.prepareStatement(
                            "INSERT INTO Subject_Info (Subject_code, Subject_name, Date) VALUES (?, ?, CURRENT_DATE)")) {
                        insertPstmt.setString(1, subjectCode);
                        insertPstmt.setString(2, subjectName);
                        insertPstmt.executeUpdate();
                    }
                }
            }
        }
    }

    private void insertStudyMaterial(Connection conn, String teacherId, String subjectCode, 
                                   int classSectionId, String fileName, String uniqueFileName, 
                                   String description) throws SQLException {
        String filePath = SAVE_DIR + File.separator + uniqueFileName;
        String sql = "INSERT INTO Study_Material (Teacher_id, Subject_code, Class_section_id, " +
                    "File_Name, File_Path, Upload_Date, Material_Type, Description) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 'NOTES', ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, teacherId);
            pstmt.setString(2, subjectCode);
            pstmt.setInt(3, classSectionId);
            pstmt.setString(4, fileName);
            pstmt.setString(5, filePath);
            pstmt.setTimestamp(6, new java.sql.Timestamp(new Date().getTime()));
            pstmt.setString(7, description);
            pstmt.executeUpdate();
        }
    }

    private void checkAndInsertMetadata(Connection conn, String subjectCode, String notesTitle) throws SQLException {
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT 1 FROM Study_Notes_Metadata WHERE Subject_code = ?")) {
            pstmt.setString(1, subjectCode);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    try (PreparedStatement insertPstmt = conn.prepareStatement(
                            "INSERT INTO Study_Notes_Metadata (Subject_code, Handout) VALUES (?, ?)")) {
                        insertPstmt.setString(1, subjectCode);
                        insertPstmt.setString(2, notesTitle);
                        insertPstmt.executeUpdate();
                    }
                }
            }
        }
    }

    private void saveFileToServer(String uploadPath, String uniqueFileName, InputStream fileContent) 
            throws IOException {
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try (FileOutputStream fos = new FileOutputStream(new File(uploadDir, uniqueFileName))) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fileContent.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
        }
    }

    private void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn, 
                              InputStream fileContent, FileOutputStream fos) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
            if (fileContent != null) fileContent.close();
            if (fos != null) fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}