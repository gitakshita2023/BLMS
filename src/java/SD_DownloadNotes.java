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

@WebServlet("/SD_DownloadNotes")
public class SD_DownloadNotes extends HttpServlet {
    private static final String DB_URL = "jdbc:derby://localhost:1527/blms";
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
        
        // Debug session attributes
        System.out.println("User ID from session: " + userId);
        System.out.println("Role from session: " + role);
        
      if (role == null || userId == null || !"Student".equalsIgnoreCase(role)) {
            response.sendRedirect("LoginPage.jsp?error=unauthorized");
            return;
        }
        
        try {
            List<JSONObject> notes = getNotes(userId);
            System.out.println("Number of notes retrieved: " + notes.size()); // Debug count
            
            request.setAttribute("notes", notes);
            request.getRequestDispatcher("SD_DownloadNotes.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // More detailed error logging
            response.sendRedirect("SD_DownloadNotes.jsp?error=true&message=" + 
                                java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
    
    private List<JSONObject> getNotes(String userId) throws SQLException {
        List<JSONObject> notes = new ArrayList<>();
    
        String sql = "SELECT DISTINCT sm.*, si.Subject_name, ti.Teacher_name, cs.Class_name, cs.Section " +
                    "FROM Study_Material sm " +
                  "JOIN Teacher_Info ti ON sm.Teacher_id = ti.Teacher_id " +
                    "JOIN Subject_Info si ON sm.Subject_code = si.Subject_code " +
                "JOIN Class_Section cs ON sm.Class_section_id = cs.Class_section_id " +
                    "JOIN Student_Class_Mapping scm ON cs.Class_section_id = scm.Class_section_id " +
                    "JOIN Student s ON scm.Student_id = s.Student_id " +
                "WHERE s.User_id = ? AND sm.Material_Type = 'NOTES' " +
                    "ORDER BY sm.Upload_Date DESC";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, userId);

            System.out.println("Executing SQL for user: " + userId);
            System.out.println("SQL Query: " + sql);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    JSONObject note = new JSONObject();
                    note.put("materialId", rs.getInt("Material_id"));
                    note.put("teacherName", rs.getString("Teacher_name"));
                    note.put("subjectCode", rs.getString("Subject_code"));
                    note.put("subjectName", rs.getString("Subject_name"));
                    note.put("className", rs.getString("Class_name"));
                    note.put("section", rs.getString("Section"));
                    note.put("fileName", rs.getString("File_Name"));
                    note.put("filePath", rs.getString("File_Path"));
                    note.put("uploadDate", rs.getTimestamp("Upload_Date").toString());
                    note.put("description", rs.getString("Description"));
                    notes.add(note);
                    
                    System.out.println("Found note: " + note.toString());
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            throw e;
        }
        return notes;
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
        
       
        File file = null;
        boolean fileFound = false;
    
        List<String> possiblePaths = new ArrayList<>();
        
       
        possiblePaths.add("C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web\\" + filePath);
        
        possiblePaths.add(BASE_UPLOAD_PATH + filePath);
        
        
        possiblePaths.add(BASE_UPLOAD_PATH + "notes\\" + fileName);
        
        
        possiblePaths.add("C:\\Users\\akshi\\OneDrive\\Documents\\NetBeansProjects\\BLMS\\web\\uploads\\notes\\" + fileName);
        
      
        System.out.println("Checking the following paths for file:");
        for (String path : possiblePaths) {
            System.out.println(" - " + path);
        }
        
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
        
        response.setContentType(contentType);
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        
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
}