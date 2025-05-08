<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Authentication check
    String role = (String) session.getAttribute("role");
    String userId = (String) session.getAttribute("userid");
    if (role == null || userId == null || !"Student".equalsIgnoreCase(role)) {
        response.sendRedirect("LoginPage.jsp?error=unauthorized");
        return;
    }
    
    // Database connection parameters
    String dbURL = "jdbc:derby://localhost:1527/blms"; // Change to your DB URL
    String dbUser = "akshita"; // Change to your DB username
    String dbPassword = "akshita"; // Change to your DB password
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    List<Map<String, String>> notesList = new ArrayList<Map<String, String>>();
    
    try {
        // Load the JDBC driver
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        
        // Establish connection
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
        // Get student's class section
        String studentQuery = "SELECT sc.Class_section_id, s.Student_id " +
                              "FROM Student s " +
                              "JOIN Student_Class_Mapping sc ON s.Student_id = sc.Student_id " +
                              "JOIN Users u ON s.User_id = u.User_id " +
                              "WHERE u.User_id = ?";
        
        pstmt = conn.prepareStatement(studentQuery);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();
        
        String studentId = "";
        int classSectionId = 0;
        
        if (rs.next()) {
            classSectionId = rs.getInt("Class_section_id");
            studentId = rs.getString("Student_id");
        } else {
            throw new Exception("Student information not found");
        }
        
        rs.close();
        pstmt.close();
        
        // Get study materials for the student's class
        String materialsQuery = "SELECT sm.Material_id, si.Subject_code, si.Subject_name, " +
                                "sm.File_Name, sm.File_Path, sm.Upload_Date, sm.Description " +
                                "FROM Study_Material sm " +
                                "JOIN Subject_Info si ON sm.Subject_code = si.Subject_code " +
                                "WHERE sm.Class_section_id = ? " +
                                "AND sm.Material_Type = 'NOTES' " +
                                "ORDER BY sm.Upload_Date DESC";
        
        pstmt = conn.prepareStatement(materialsQuery);
        pstmt.setInt(1, classSectionId);
        rs = pstmt.executeQuery();
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        
        while (rs.next()) {
            Map<String, String> note = new HashMap<String, String>();
            note.put("materialId", rs.getString("Material_id"));
            note.put("subjectCode", rs.getString("Subject_code"));
            note.put("subjectName", rs.getString("Subject_name"));
            note.put("fileName", rs.getString("File_Name"));
            note.put("filePath", rs.getString("File_Path"));
            note.put("uploadDate", dateFormat.format(rs.getTimestamp("Upload_Date")));
            note.put("description", rs.getString("Description"));
            notesList.add(note);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Database error: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { }
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) { }
        try { if (conn != null) conn.close(); } catch (Exception e) { }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Download Notes | Learning Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <div style="position: absolute; top: 20px; left: 20px; z-index: 100;">
    <a href="javascript:history.back()" class="link" style="display: inline-flex; align-items: center; font-weight: bold; font-size: 1.1em;  color: white; padding: 8px 15px; transition: all 0.3s ease;">
        <span style="font-size: 1.3em; margin-right: 8px;">←</span> Back
    </a>
    </div>
    <!-- Navigation Bar -->
    <nav class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white shadow-lg">
        <div class="container mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center">
                <i class="fas fa-graduation-cap text-2xl mr-3"></i>
                <span class="text-xl font-bold">Learning Portal</span>
            </div>
            <div class="flex items-center">
                <a href="HomePage.jsp" class="mr-4">
                    <i class="fas fa-home mr-2"></i>Home Page
                </a>
                <span class="mr-4">Welcome, <%= userId %></span>
                <a href="Logout.jsp" class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="container mx-auto px-6 py-8">
        <!-- Error message display if any -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                <strong>Error:</strong> <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Study Notes</h2>
            
            <% if (notesList.isEmpty()) { %>
                <div class="py-4 text-center text-gray-500">
                    <i class="fas fa-info-circle mr-2"></i>No study notes are available for your classes at this time.
                </div>
            <% } else { %>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Subject Code</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Subject</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Topic</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Upload Date</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <% for (Map<String, String> note : notesList) { %>
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap"><%= note.get("subjectCode") %></td>
                                    <td class="px-6 py-4 whitespace-nowrap"><%= note.get("subjectName") %></td>
                                    <td class="px-6 py-4 whitespace-nowrap"><%= note.get("fileName") %></td>
                                    <td class="px-6 py-4 whitespace-nowrap"><%= note.get("uploadDate") %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <a href="SD_DownloadNotes?action=download&filePath=<%= note.get("filePath") %>&fileName=<%= note.get("fileName") %>" 
                                           class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
                                            <i class="fas fa-download mr-2"></i>Download
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
        
        <!-- Recently Added Notes Section -->
        <div class="bg-white rounded-lg shadow-md p-6 mt-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Recently Added Notes</h2>
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <% 
                int count = 0;
                for (Map<String, String> note : notesList) {
                    if (count < 3) { // Show only the 3 most recent notes
                %>
                    <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                        <div class="flex items-center mb-3">
                            <i class="fas fa-file-pdf text-red-500 text-xl mr-3"></i>
                            <h3 class="font-semibold text-lg"><%= note.get("subjectCode") %> - <%= note.get("fileName") %></h3>
                        </div>
                        <p class="text-gray-600 mb-3"><%= note.get("description") != null ? note.get("description") : "No description available" %></p>
                        <div class="flex justify-between items-center text-sm">
                            <span class="text-gray-500"><i class="far fa-calendar-alt mr-1"></i> <%= note.get("uploadDate") %></span>
                            <a href="SD_DownloadNotes?action=download&filePath=<%= note.get("filePath") %>&fileName=<%= note.get("fileName") %>" 
                               class="text-blue-500 hover:text-blue-700">
                                <i class="fas fa-download mr-1"></i>Download
                            </a>
                        </div>
                    </div>
                <% 
                        count++;
                    }
                } 
                
                if (count == 0) {
                %>
                    <div class="col-span-3 py-4 text-center text-gray-500">
                        <i class="fas fa-info-circle mr-2"></i>No recent notes available.
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Simple Footer -->
    <footer class="bg-gray-800 text-white py-6 mt-8">
        <div class="container mx-auto px-6 text-center">
            <p>&copy; 2025 Learning Management System. All rights reserved.</p>
        </div>
    </footer>
    
    <!-- JavaScript for additional functionality -->
    <script>
        // Add any client-side functionality here
        function showNotification(message) {
            alert(message);
        }
    </script>
</body>
</html>