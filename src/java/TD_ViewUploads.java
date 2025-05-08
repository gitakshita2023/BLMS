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

@WebServlet("/TD_ViewUploads")
public class TD_ViewUploads extends HttpServlet {
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

        if (role == null || userId == null || !"Teacher".equalsIgnoreCase(role)) {
            response.sendRedirect("LoginPage.jsp?error=unauthorized");
            return;
        }

        try {
            List<JSONObject> uploads = getUploads(userId);
            request.setAttribute("uploads", uploads);
            request.getRequestDispatcher("TD_ViewUploads.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in doGet: " + e.getMessage());
            response.sendRedirect("TD_ViewUploads.jsp?error=true&message=" + 
                                java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private List<JSONObject> getUploads(String userId) throws SQLException {
        System.out.println("Fetching uploads for teacher: " + userId);
        List<JSONObject> uploads = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connected successfully");

            String sql = "SELECT DISTINCT sm.*, si.Subject_name, cs.Class_name, cs.Section " +
                        "FROM Study_Material sm " +
                        "JOIN Teacher_Info ti ON sm.Teacher_id = ti.Teacher_id " +
                        "JOIN Subject_Info si ON sm.Subject_code = si.Subject_code " +
                        "JOIN Class_Section cs ON sm.Class_section_id = cs.Class_section_id " +
                        "WHERE ti.User_id = ? " +
                        "ORDER BY sm.Upload_Date DESC";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            
            System.out.println("Executing query...");
            rs = pstmt.executeQuery();
            System.out.println("Query executed successfully");

            while (rs.next()) {
                System.out.println("Found upload: " + rs.getString("File_Name"));
                JSONObject upload = new JSONObject();
                upload.put("materialId", rs.getInt("Material_id"));
                upload.put("subjectCode", rs.getString("Subject_code"));
                upload.put("subjectName", rs.getString("Subject_name"));
                upload.put("className", rs.getString("Class_name"));
                upload.put("section", rs.getString("Section"));
                upload.put("fileName", rs.getString("File_Name"));
                upload.put("filePath", rs.getString("File_Path"));
                upload.put("uploadDate", rs.getTimestamp("Upload_Date").toString());
                upload.put("materialType", rs.getString("Material_Type"));
                upload.put("description", rs.getString("Description"));
                uploads.add(upload);
            }
            
            System.out.println("Total uploads found: " + uploads.size());
        } catch (ClassNotFoundException e) {
            System.out.println("Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found");
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return uploads;
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String action = request.getParameter("action");
    
    if ("delete".equals(action)) {
        deleteFile(request, response);
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
    
    // 3. Try in notes folder
    possiblePaths.add(BASE_UPLOAD_PATH + "notes\\" + fileName);
    
    // 4. Try in assignments folder
    possiblePaths.add(BASE_UPLOAD_PATH + "assignments\\" + fileName);
    
    // 5. Try with web context path
    possiblePaths.add("C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web\\uploads\\notes\\" + fileName);
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
    
    // Stream file content
    try (FileInputStream in = new FileInputStream(file);
         OutputStream out = response.getOutputStream()) {
        
        byte[] buffer = new byte[4096];
        int bytesRead;
        
        while ((bytesRead = in.read(buffer)) != -1) {
            out.write(buffer, 0, bytesRead);
        }
        
        out.flush();
        System.out.println("File downloaded successfully: " + fileName);
    } catch (IOException e) {
        System.out.println("Error downloading file: " + e.getMessage());
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error downloading file");
    }
}

    
    private void deleteFile(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    System.out.println("Delete file method called");
    
    String materialId = request.getParameter("materialId");
    String filePath = request.getParameter("filePath");
    
    if (materialId == null || filePath == null) {
        System.out.println("File information missing");
        response.sendRedirect("TD_ViewUploads?error=true&message=File information missing");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        // First delete the record from the database
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        
        // Delete the record from the database
        String deleteSql = "DELETE FROM Study_Material WHERE Material_id = ?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setInt(1, Integer.parseInt(materialId));
        int rowsAffected = pstmt.executeUpdate();
        
        System.out.println("Rows affected by delete: " + rowsAffected);
        
        if (rowsAffected > 0) {
            // Then delete the physical file
            File file = new File("C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web\\" + filePath);
            if (file.exists()) {
                boolean deleted = file.delete();
                if (deleted) {
                    System.out.println("File deleted successfully: " + filePath);
                } else {
                    System.out.println("Failed to delete file: " + filePath);
                }
            } else {
                System.out.println("File not found: " + filePath);
            }
            
            response.sendRedirect("TD_ViewUploads?success=true&message=Material deleted successfully");
        } else {
            System.out.println("Failed to delete material from database");
            response.sendRedirect("TD_ViewUploads?error=true&message=Failed to delete material from database");
        }
        
    } catch (Exception e) {
        System.out.println("Error deleting file: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("TD_ViewUploads?error=true&message=" + 
                            java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
}
