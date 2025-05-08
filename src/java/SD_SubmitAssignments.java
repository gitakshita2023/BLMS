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

@WebServlet("/SD_SubmitAssignments")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class SD_SubmitAssignments extends HttpServlet {
    private static final String SAVE_DIR = "uploads/submissions";
    private static final String DB_URL = "jdbc:derby://localhost:1527/blms";
    private static final String DB_USER = "akshita";
    private static final String DB_PASSWORD = "akshita";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("SD_SubmitAssignments.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Authentication check
        String role = (String) request.getSession().getAttribute("role");
        String userId = (String) request.getSession().getAttribute("userid");
        if (role == null || userId == null || !"Student".equalsIgnoreCase(role)) {
            response.sendRedirect("LoginPage.jsp?error=unauthorized");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        InputStream fileContent = null;
        FileOutputStream fos = null;

        try {
            
            String studentName = request.getParameter("studentName");
            String smartCardId = request.getParameter("smartCardId");
            String examRollNumber = request.getParameter("examRollNumber");
            String subjectCode = request.getParameter("subjectCode");
            String className = request.getParameter("class");
            String section = request.getParameter("section");
            String submittedTo = request.getParameter("submittedTo");

            
            Part filePart = request.getPart("assignmentFile");
            String path = "C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web" + File.separator + SAVE_DIR;
            File file = new File(path);
            file.mkdirs();

            String fileName = extractFileName(filePart);
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("SD_SubmitAssignments.jsp?error=true&message=" + 
                                    java.net.URLEncoder.encode("No file uploaded.", "UTF-8"));
                return;
            }

            String uniqueFileName = smartCardId + "_" + subjectCode + "_sec" + section + "_" + 
                                  System.currentTimeMillis() + fileName.substring(fileName.lastIndexOf("."));
            fileContent = filePart.getInputStream();

            
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

            // Get Student_id
            String studentId = getStudentId(conn, userId);

            // Get Material_id
            int materialId = getMaterialId(conn, subjectCode);

            // Insert submission into Assignment_Submission table
            String filePath = SAVE_DIR + File.separator + uniqueFileName;
            String sql = "INSERT INTO Assignment_Submission (Student_id, Material_id, File_Name, " +
                        "File_Path, Submission_Date) VALUES (?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            pstmt.setInt(2, materialId);
            pstmt.setString(3, uniqueFileName);
            pstmt.setString(4, filePath);
            pstmt.setTimestamp(5, new java.sql.Timestamp(new Date().getTime()));
            pstmt.executeUpdate();

            conn.commit();
            response.sendRedirect("SD_SubmitAssignments.jsp?success=true");

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            response.sendRedirect("SD_SubmitAssignments.jsp?error=true&message=" + 
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

    private String getStudentId(Connection conn, String userId) throws SQLException {
        String studentId = null;
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT Student_id FROM Student WHERE User_id = ?")) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    studentId = rs.getString("Student_id");
                } else {
                    throw new SQLException("Student record not found for User ID: " + userId);
                }
            }
        }
        return studentId;
    }

    private int getMaterialId(Connection conn, String subjectCode) throws SQLException {
        int materialId = -1;
        try (PreparedStatement pstmt = conn.prepareStatement(
                "SELECT Material_id FROM Study_Material WHERE Subject_code = ? AND Material_Type = 'ASSIGNMENT'")) {
            pstmt.setString(1, subjectCode);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    materialId = rs.getInt("Material_id");
                } else {
                    throw new SQLException("Assignment not found for subject code: " + subjectCode);
                }
            }
        }
        return materialId;
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