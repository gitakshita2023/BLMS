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

@WebServlet("/SD_ViewAssignments")
public class SD_ViewAssignments extends HttpServlet {
    private static final String DB_URL = "jdbc:derby://localhost:1527/blms;create=true";
    private static final String DB_USER = "akshita";
    private static final String DB_PASSWORD = "akshita";
    private static final String BASE_UPLOAD_PATH = "C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web\\uploads\\";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("download".equals(action)) {
            downloadFile(request, response);
            return;
        }
        
        String userId = (String) request.getSession().getAttribute("userid");
        String role = (String) request.getSession().getAttribute("role");
        if (role == null || userId == null || !"Student".equalsIgnoreCase(role)) {
            response.sendRedirect("LoginPage.jsp?error=unauthorized");
            return;
        }
        
        try {
            List<JSONObject> assignments = getAssignments(userId);
            request.setAttribute("assignments", assignments);
            request.getRequestDispatcher("SD_ViewAssignments.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in doGet: " + e.getMessage());
            response.sendRedirect("SD_ViewAssignments.jsp?error=true&message=" + 
                                java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private List<JSONObject> getAssignments(String userId) throws SQLException {
        List<JSONObject> assignments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String sql = "SELECT DISTINCT sm.*, si.Subject_name, ti.Teacher_name, cs.Class_name, cs.Section " +
                        "FROM Study_Material sm " +
                        "JOIN Teacher_Info ti ON sm.Teacher_id = ti.Teacher_id " +
                        "JOIN Subject_Info si ON sm.Subject_code = si.Subject_code " +
                        "JOIN Class_Section cs ON sm.Class_section_id = cs.Class_section_id " +
                        "JOIN Student_Class_Mapping scm ON cs.Class_section_id = scm.Class_section_id " +
                        "JOIN Student s ON scm.Student_id = s.Student_id " +
                        "WHERE s.User_id = ? " +
                        "AND sm.Material_Type = 'ASSIGNMENT' " +
                        "AND scm.Class_section_id = sm.Class_section_id " +
                        "ORDER BY sm.Upload_Date DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            System.out.println("Executing query for user: " + userId);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                JSONObject assignment = new JSONObject();
                assignment.put("materialId", rs.getInt("Material_id"));
                assignment.put("teacherName", rs.getString("Teacher_name"));
                assignment.put("subjectCode", rs.getString("Subject_code"));
                assignment.put("subjectName", rs.getString("Subject_name"));
                assignment.put("className", rs.getString("Class_name"));
                assignment.put("section", rs.getString("Section"));
                assignment.put("fileName", rs.getString("File_Name"));
                assignment.put("filePath", rs.getString("File_Path"));
                assignment.put("uploadDate", rs.getTimestamp("Upload_Date").toString());
                assignment.put("description", rs.getString("Description"));
                assignments.add(assignment);
                
                System.out.println("Found assignment: " + assignment.getString("fileName"));
            }
            
            System.out.println("Total assignments found: " + assignments.size());
            
        } catch (ClassNotFoundException e) {
            System.out.println("Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return assignments;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("download".equals(action)) {
            downloadFile(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void downloadFile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Download file method called");
        
        String filePath = request.getParameter("filePath");
        String fileName = request.getParameter("fileName");
        
        System.out.println("Requested file: " + fileName);
        System.out.println("File path from database: " + filePath);
        
        if (filePath == null || fileName == null) {
            System.out.println("File information missing");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File information missing");
            return;
        }
        
        // Try different possible file locations
        File file = null;
        boolean fileFound = false;
        
        // List of possible file locations to check
        List<String> possiblePaths = new ArrayList<>();
        
        // 1. Try the exact path from the database
        possiblePaths.add("C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web\\" + filePath);
        
        // 2. Try with BASE_UPLOAD_PATH
        possiblePaths.add(BASE_UPLOAD_PATH + filePath);
        
        // 3. Try in assignments folder
        possiblePaths.add(BASE_UPLOAD_PATH + "assignments\\" + fileName);
        
        // 4. Try with web context path
        possiblePaths.add(getServletContext().getRealPath("/uploads/assignments/") + File.separator + fileName);
        
        // 5. Try other combinations
        possiblePaths.add(BASE_UPLOAD_PATH + "assignments" + File.separator + filePath);
        possiblePaths.add("C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web\\uploads\\assignments\\" + fileName);
        
        // Log all paths we're checking
        System.out.println("Checking the following paths for file:");
        for (String path : possiblePaths) {
            System.out.println(" - " + path);
        }
        
        // Check each path
        for (String path : possiblePaths) {
            file = new File(path);
            if (file.exists() && file.isFile()) {
                fileFound = true;
                System.out.println("File found at: " + path);
                break;
            }
        }
        
        if (!fileFound) {
            System.out.println("File not found in any of the checked locations");
            
            // Log directory contents for debugging
            File uploadsDir = new File(BASE_UPLOAD_PATH);
            if (uploadsDir.exists() && uploadsDir.isDirectory()) {
                System.out.println("Contents of " + BASE_UPLOAD_PATH + ":");
                File[] files = uploadsDir.listFiles();
                if (files != null) {
                    for (File f : files) {
                        System.out.println(" - " + f.getName() + (f.isDirectory() ? " (directory)" : ""));
                        
                        if (f.isDirectory()) {
                            File[] subFiles = f.listFiles();
                            if (subFiles != null) {
                                for (File sf : subFiles) {
                                    System.out.println("   - " + sf.getName());
                                }
                            }
                        }
                    }
                }
            }
            
            // Check assignments directory specifically
            File assignmentsDir = new File(BASE_UPLOAD_PATH + "assignments");
            if (assignmentsDir.exists() && assignmentsDir.isDirectory()) {
                System.out.println("Contents of assignments directory:");
                File[] files = assignmentsDir.listFiles();
                if (files != null) {
                    for (File f : files) {
                        System.out.println(" - " + f.getName());
                    }
                }
            }
            
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found: " + fileName);
            return;
        }
        
        // Set content type based on file extension
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        // Set response headers
        response.setContentType(contentType);
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        
        // Stream file content
        try (BufferedInputStream inStream = new BufferedInputStream(new FileInputStream(file));
             BufferedOutputStream outStream = new BufferedOutputStream(response.getOutputStream())) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
            
            outStream.flush();
            System.out.println("File downloaded successfully: " + fileName);
        } catch (IOException e) {
            System.out.println("Error downloading file: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error downloading file");
        }
    }
}