<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    // Get form data
    String adminId = request.getParameter("adminId");
    String userId = request.getParameter("userId");
    String adminName = request.getParameter("adminName");
    String adminEmail = request.getParameter("adminEmail");
    String adminPassword = request.getParameter("adminPassword");
    
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/blms", "akshita", "akshita");
        
        // Check if admin already exists
        PreparedStatement checkAdmin = conn.prepareStatement("SELECT COUNT(*) FROM Admin");
        ResultSet rs = checkAdmin.executeQuery();
        
        if (rs.next() && rs.getInt(1) > 0) {
            rs.close();
            checkAdmin.close();
            conn.close();
            response.sendRedirect("RegisterAdmin.jsp?error=failed&message=An+admin+already+exists.+Only+one+admin+is+allowed.");
            return;
        }
        
        // Insert into Users table first
        PreparedStatement insertUser = conn.prepareStatement(
            "INSERT INTO Users (Login_id, User_id, Password, User_role) VALUES (?, ?, ?, 'ADMIN')"
        );
        
        // Generate a unique Login_id (you might want to implement your own logic)
        Statement stmt = conn.createStatement();
        ResultSet maxIdRs = stmt.executeQuery("SELECT MAX(Login_id) FROM Users");
        int loginId = 1;
        if (maxIdRs.next()) {
            loginId = maxIdRs.getInt(1) + 1;
        }
        
        insertUser.setInt(1, loginId);
        insertUser.setString(2, userId);
        insertUser.setString(3, adminPassword);
        insertUser.executeUpdate();
        
        // Insert into Admin table
        PreparedStatement insertAdmin = conn.prepareStatement(
            "INSERT INTO Admin (Admin_id, User_id, Admin_name, Admin_email, Password) VALUES (?, ?, ?, ?, ?)"
        );
        
        insertAdmin.setString(1, adminId);
        insertAdmin.setString(2, userId);
        insertAdmin.setString(3, adminName);
        insertAdmin.setString(4, adminEmail);
        insertAdmin.setString(5, adminPassword);
        insertAdmin.executeUpdate();
        
        // Close resources
        insertAdmin.close();
        insertUser.close();
        conn.close();
        
        // Redirect to success page
        response.sendRedirect("RegisterAdmin.jsp?status=success");
        
    } catch (Exception e) {
        // Handle errors
        response.sendRedirect("RegisterAdmin.jsp?error=failed&message=" + e.getMessage());
    }
%>