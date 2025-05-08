<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Authentication check
    String role = (String) session.getAttribute("role");
    if (role == null || !"Admin".equalsIgnoreCase(role)) {
        response.sendRedirect("LoginPage.jsp?error=unauthorized");
        return;
    }
    
    // Database connection parameters
    String dbURL = "jdbc:derby://localhost:1527/blms";
    String dbUser = "akshita";
    String dbPassword = "akshita";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String message = "";
    String messageType = "";
    
    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        
        if (email != null && !email.trim().isEmpty()) {
            try {
                // Load the JDBC driver
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                
                // Establish connection
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                
                // Check if email already exists
                String checkSql = "SELECT email FROM Authorized_Users WHERE email = ?";
                pstmt = conn.prepareStatement(checkSql);
                pstmt.setString(1, email);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    message = "Email " + email + " is already authorized.";
                    messageType = "warning";
                } else {
                    // Insert new authorized email
                    String insertSql = "INSERT INTO Authorized_Users (email, Is_registered) VALUES (?, FALSE)";
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, email);
                    int rowsAffected = pstmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        message = "Teacher email " + email + " has been successfully authorized.";
                        messageType = "success";
                    } else {
                        message = "Failed to authorize teacher email.";
                        messageType = "error";
                    }
                }
            } catch (Exception e) {
                message = "Database error: " + e.getMessage();
                messageType = "error";
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) { }
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) { }
                try { if (conn != null) conn.close(); } catch (Exception e) { }
            }
        } else {
            message = "Email cannot be empty.";
            messageType = "error";
        }
    }
    
    // Get list of authorized emails
    List authorizedUsers = new ArrayList();
    
    try {
        // Load the JDBC driver
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        
        // Establish connection
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
        // Get all authorized users
        String sql = "SELECT Auth_id, email, Is_registered, Created_at FROM Authorized_Users ORDER BY Created_at DESC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        
        while (rs.next()) {
            Map user = new HashMap();
            user.put("id", rs.getString("Auth_id"));
            user.put("email", rs.getString("email"));
            user.put("isRegistered", rs.getBoolean("Is_registered") ? "Yes" : "No");
            user.put("createdAt", dateFormat.format(rs.getTimestamp("Created_at")));
            authorizedUsers.add(user);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { }
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) { }
        try { if (conn != null) conn.close(); } catch (Exception e) { }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Authorize Teacher Registration | Admin Panel</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .gradient-custom {
            background: linear-gradient(to right, #4776E6, #8E54E9);
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">
    
    <!-- Navigation Bar -->
<nav class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white shadow-lg">
    <div class="container mx-auto px-6 py-4 flex justify-between items-center">
        <div class="flex items-center">
            <i class="fas fa-user-shield text-2xl mr-3"></i>
            <span class="text-xl font-bold">Admin Dashboard</span>
        </div>
        <div class="flex items-center">
            <a href="HomePage.jsp" class="mr-4 flex items-center">
                <i class="fas fa-arrow-left mr-2"></i>
                Back
            </a>
            <a href="HomePage.jsp" class="mr-4">
                <i class="fas fa-home mr-2"></i>Home Page
            </a>
            <a href="Logout.jsp" class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200">
                <i class="fas fa-sign-out-alt mr-2"></i>Logout
            </a>
        </div>
    </div>
</nav>
    
    <!-- Main Content -->
    <div class="container mx-auto px-4 py-8">
        <div class="flex flex-col md:flex-row gap-8">
            <!-- Left Column - Form -->
            <div class="w-full md:w-1/3">
                <div class="bg-white rounded-lg shadow-md p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6">
                        <i class="fas fa-user-plus mr-2 text-indigo-600"></i>
                        Authorize Teacher
                    </h2>
                    
                    <% if (!message.isEmpty()) { %>
                        <div class="mb-4 p-4 rounded-md <%= messageType.equals("success") ? "bg-green-100 text-green-700" : messageType.equals("warning") ? "bg-yellow-100 text-yellow-700" : "bg-red-100 text-red-700" %>">
                            <p><%= message %></p>
                        </div>
                    <% } %>
                    
                    <form method="post" action="AD_Register.jsp" class="space-y-4">
                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Teacher Email ID</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-envelope text-gray-400"></i>
                                </div>
                                <input type="email" id="email" name="email" required
                                    class="pl-10 block w-full rounded-md border-gray-300 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    placeholder="teacher@example.com">
                            </div>
                            <p class="mt-1 text-xs text-gray-500">Only authorized emails can register as teachers</p>
                        </div>
                        
                        <div>
                            <button type="submit" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                                <i class="fas fa-plus-circle mr-2"></i> Authorize Teacher
                            </button>
                        </div>
                    </form>
                </div>
                
                <div class="bg-white rounded-lg shadow-md p-6 mt-6">
                    <h3 class="text-lg font-semibold text-gray-800 mb-4">
                        <i class="fas fa-info-circle mr-2 text-blue-500"></i>
                        Instructions
                    </h3>
                    <ul class="space-y-2 text-sm text-gray-600">
                        <li class="flex items-start">
                            <i class="fas fa-check-circle text-green-500 mt-1 mr-2"></i>
                            <span>Enter the teacher's email address to authorize them for registration.</span>
                        </li>
                        <li class="flex items-start">
                            <i class="fas fa-check-circle text-green-500 mt-1 mr-2"></i>
                            <span>Only teachers with authorized emails will be able to register in the system.</span>
                        </li>
                        <li class="flex items-start">
                            <i class="fas fa-check-circle text-green-500 mt-1 mr-2"></i>
                            <span>The system will automatically update the registration status when a teacher registers.</span>
                        </li>
                        <li class="flex items-start">
                            <i class="fas fa-exclamation-triangle text-yellow-500 mt-1 mr-2"></i>
                            <span>Make sure to verify the email address before authorization.</span>
                        </li>
                    </ul>
                </div>
            </div>
            
            <!-- Right Column - Table -->
            <div class="w-full md:w-2/3">
                <div class="bg-white rounded-lg shadow-md p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6">
                        <i class="fas fa-list-alt mr-2 text-indigo-600"></i>
                        Authorized Teachers
                    </h2>
                    
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Registered</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Created At</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <% if (authorizedUsers.isEmpty()) { %>
                                    <tr>
                                        <td colspan="4" class="px-6 py-4 text-center text-sm text-gray-500">
                                            No authorized teachers found.
                                        </td>
                                    </tr>
                                <% } else { %>
                                    <% 
                                    for (int i = 0; i < authorizedUsers.size(); i++) { 
                                        Map user = (Map)authorizedUsers.get(i);
                                    %>
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= user.get("id") %></td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= user.get("email") %></td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= user.get("isRegistered").equals("Yes") ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800" %>">
                                                    <%= user.get("isRegistered") %>
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= user.get("createdAt") %></td>
                                        </tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    
                    <% if (!authorizedUsers.isEmpty()) { %>
                        <div class="mt-4 text-sm text-gray-500">
                            Total authorized teachers: <%= authorizedUsers.size() %>
                        </div>
                    <% } %>
                </div>
                
                <div class="bg-gradient-to-r from-blue-500 to-indigo-600 rounded-lg shadow-md p-6 mt-6 text-white">
                    <h3 class="text-xl font-bold mb-3">Teacher Registration Process</h3>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
                        <div class="bg-white bg-opacity-20 p-4 rounded-lg">
                            <div class="text-center mb-2">
                                <i class="fas fa-envelope-open-text text-3xl"></i>
                            </div>
                            <h4 class="font-semibold text-center mb-2">Step 1</h4>
                            <p class="text-sm text-center">Authorize teacher email in the system</p>
                        </div>
                        <div class="bg-white bg-opacity-20 p-4 rounded-lg">
                            <div class="text-center mb-2">
                                <i class="fas fa-user-edit text-3xl"></i>
                            </div>
                            <h4 class="font-semibold text-center mb-2">Step 2</h4>
                            <p class="text-sm text-center">Teacher registers using authorized email</p>
                        </div>
                        <div class="bg-white bg-opacity-20 p-4 rounded-lg">
                            <div class="text-center mb-2">
                                <i class="fas fa-check-circle text-3xl"></i>
                            </div>
                            <h4 class="font-semibold text-center mb-2">Step 3</h4>
                            <p class="text-sm text-center">Teacher account is activated and ready to use</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white mt-12 py-6">
        <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row justify-between items-center">
                <div class="mb-4 md:mb-0">
                    <h3 class="text-xl font-bold">Blended Learning Management System</h3>
                    <p class="text-gray-400 text-sm mt-1">Admin Portal - Teacher Authorization</p>
                </div>
                <div class="flex space-x-4">
                    <a href="#" class="text-gray-400 hover:text-white transition duration-200">
                        <i class="fas fa-question-circle mr-1"></i> Help
                    </a>
                    
                </div>
            </div>
            <div class="mt-4 text-center text-gray-400 text-sm">
                &copy; <%= new java.util.Date().getYear() + 1900 %> Blended Learning Management System. All rights reserved.
            </div>
        </div>
    </footer>

    <!-- JavaScript for notifications -->
    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.bg-green-100, .bg-yellow-100, .bg-red-100');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 1s ease-out';
                alert.style.opacity = '0';
                setTimeout(function() { alert.style.display = 'none'; }, 1000);
            });
        }, 5000);
    </script>
</body>
</html>

