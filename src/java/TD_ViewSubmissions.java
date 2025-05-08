import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/TD_ViewSubmissions")
public class TD_ViewSubmissions extends HttpServlet {
    private static final String DB_URL = "jdbc:derby://localhost:1527/blms;create=true";
    private static final String DB_USER = "akshita";
    private static final String DB_PASSWORD = "akshita";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = (String) request.getSession().getAttribute("userid");
        String role = (String) request.getSession().getAttribute("role");

        if (role == null || userId == null || !"Teacher".equalsIgnoreCase(role)) {
            response.sendRedirect("LoginPage.jsp?error=unauthorized");
            return;
        }

        try {
            List<JSONObject> submissions = getSubmissions(userId);
            request.setAttribute("submissions", submissions);
            request.getRequestDispatcher("TD_ViewSubmissions.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("TD_ViewSubmissions.jsp?error=true&message=" + 
                                java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("download".equals(action)) {
            downloadFile(request, response);
        }
    }

    private List<JSONObject> getSubmissions(String userId) throws SQLException {
    System.out.println("Fetching submissions for teacher: " + userId);
    List<JSONObject> submissions = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        
        String sql = "SELECT DISTINCT " +
                    "st.Student_id, st.Student_name, sm.Subject_code, si.Subject_name, " +
                    "cs.Class_name, cs.Section, sub.File_Name, sub.File_Path, " +
                    "sub.Submission_Date, sub.Submission_id " +
                    "FROM Assignment_Submission sub " +
                    "JOIN Study_Material sm ON sub.Material_id = sm.Material_id " +
                    "JOIN Student st ON sub.Student_id = st.Student_id " +
                    "JOIN Subject_Info si ON sm.Subject_code = si.Subject_code " +
                    "JOIN Teacher_Subject_Mapping tsm ON sm.Subject_code = tsm.Subject_code " +
                    "JOIN Teacher_Info ti ON tsm.Teacher_id = ti.Teacher_id " +
                    "JOIN Class_Section cs ON tsm.Class_section_id = cs.Class_section_id " +
                    "WHERE ti.User_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        
        System.out.println("Executing query...");
        rs = pstmt.executeQuery();
        System.out.println("Query executed successfully");

        while (rs.next()) {
            System.out.println("Found submission for student: " + rs.getString("Student_name"));
            JSONObject submission = new JSONObject();
            submission.put("studentId", rs.getString("Student_id"));
            submission.put("studentName", rs.getString("Student_name"));
            submission.put("subjectCode", rs.getString("Subject_code"));
            submission.put("subjectName", rs.getString("Subject_name"));
            submission.put("className", rs.getString("Class_name"));
            submission.put("section", rs.getString("Section"));
            submission.put("fileName", rs.getString("File_Name"));
            submission.put("filePath", rs.getString("File_Path"));
            submission.put("submissionDate", rs.getTimestamp("Submission_Date").toString());
            submission.put("submissionId", rs.getInt("Submission_id"));
            submissions.add(submission);
        }
    } catch (ClassNotFoundException e) {
        System.out.println("Derby Driver loading failed: " + e.getMessage());
        throw new SQLException("Database driver not found");
    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
        throw e;
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
    
    System.out.println("Total submissions found: " + submissions.size());
    return submissions;
}
    private void downloadFile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filePath = request.getParameter("filePath");
        String fileName = request.getParameter("fileName");

        if (filePath == null || fileName == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File information missing");
            return;
        }

        File file = new File("C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web\\" + filePath);
        
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\"");
        response.setContentLength((int) file.length());

        try (FileInputStream fileInputStream = new FileInputStream(file);
             OutputStream responseOutputStream = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                responseOutputStream.write(buffer, 0, bytesRead);
            }
        }
    }
}