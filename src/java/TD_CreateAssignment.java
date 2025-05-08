import java.io.*;
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

@WebServlet("/TD_CreateAssignment")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class TD_CreateAssignment extends HttpServlet {
    private static final String SAVE_DIR = "uploads/assignments";
    private static final String DB_URL = "jdbc:derby://localhost:1527/blms";
    private static final String DB_USER = "akshita";
    private static final String DB_PASSWORD = "akshita";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("TD_CreateAssignment.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

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
            String courseSemester = request.getParameter("courseSemester");
            String section = request.getParameter("section");
            String submissionDate = request.getParameter("submissionDate");
            String assignmentTitle = request.getParameter("assignmentTitle");

            // File handling
            Part filePart = request.getPart("assignmentFile");
            String path = "C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web" + File.separator + SAVE_DIR;
            File file = new File(path);
            file.mkdirs();

            String fileName = extractFileName(filePart);
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("TD_CreateAssignment.jsp?error=true&message=" + 
                                    java.net.URLEncoder.encode("No file uploaded.", "UTF-8"));
                return;
            }

            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            fileContent = filePart.getInputStream();

            // Save file
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

            // Insert assignment into Study_Material table
            String filePath = SAVE_DIR + File.separator + uniqueFileName;
            String description = "Assignment due on " + submissionDate + " for " + subjectName;

            String sql = "INSERT INTO Study_Material (Teacher_id, Subject_code, Class_section_id, " +
                        "File_Name, File_Path, Upload_Date, Material_Type, Description) " +
                        "VALUES (?, ?, ?, ?, ?, ?, 'ASSIGNMENT', ?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, teacherId);
            pstmt.setString(2, subjectCode);
            pstmt.setInt(3, classSectionId);
            pstmt.setString(4, fileName);
            pstmt.setString(5, filePath);
            pstmt.setTimestamp(6, new java.sql.Timestamp(new Date().getTime()));
            pstmt.setString(7, description);
            pstmt.executeUpdate();

            conn.commit();
            response.sendRedirect("TD_CreateAssignment.jsp?success=true");

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            response.sendRedirect("TD_CreateAssignment.jsp?error=true&message=" + 
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