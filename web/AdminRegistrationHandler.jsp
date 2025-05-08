<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    String dbURL = "jdbc:derby://localhost:1527/blms";
    String dbUser = "akshita";
    String dbPassword = "akshita";



    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Retrieve form data
        String adminId = request.getParameter("adminId");
        String userId = request.getParameter("userId");
        String adminName = request.getParameter("adminName");
        String adminEmail = request.getParameter("adminEmail");
        String adminPassword = request.getParameter("adminPassword");

        // Load the Derby JDBC driver
        Class.forName("org.apache.derby.jdbc.ClientDriver");

        // Establish connection
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        conn.setAutoCommit(false); // Begin transaction

        // Insert into the Users table
        String insertUserQuery = "INSERT INTO Users (Login_id, User_id, Password, User_role) VALUES " +
                                 "((SELECT COALESCE(MAX(Login_id), 0) + 1 FROM Users), ?, ?, 'ADMIN')";
        pstmt = conn.prepareStatement(insertUserQuery);
        pstmt.setString(1, userId);
        pstmt.setString(2, adminPassword);
        pstmt.executeUpdate();

        // Insert into the Admin table
        String insertAdminQuery = "INSERT INTO Admin (Admin_id, User_id, Admin_name, Admin_Email, Password) " +
                                   "VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(insertAdminQuery);
        pstmt.setString(1, adminId);
        pstmt.setString(2, userId);
        pstmt.setString(3, adminName);
        pstmt.setString(4, adminEmail);
        pstmt.setString(5, adminPassword);
        pstmt.executeUpdate();

        // Commit the transaction
        conn.commit();

        // Set session attributes and redirect to home page
        session.setAttribute("role", "Admin");
        session.setAttribute("userid", userId);
        response.sendRedirect("HomePage.jsp");
    } catch (Exception e) {
        // Rollback the transaction on error
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }

        // Log the error and redirect to the registration page with an error message
        e.printStackTrace();
        response.sendRedirect("RegisterAdmin.jsp?error=failed&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    } finally {
        // Close resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
