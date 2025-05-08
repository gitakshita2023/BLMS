<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    // Database Connection Variables
    String dbURL = "jdbc:derby://localhost:1527/blms";  // Ensure Derby is running
    String dbUser = "akshita";
    String dbPassword = "akshita";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Get User Input
        String userId = request.getParameter("userid").trim();
        String password = request.getParameter("password").trim();

        // Validate Input
        if (userId == null || userId.isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect("LoginPage.jsp?error=empty");
            return;
        }

        // Load the Derby JDBC driver
        Class.forName("org.apache.derby.jdbc.ClientDriver");

        // Establish Connection
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        if (conn == null) {
            out.println("<h3 style='color:red;'>Database connection failed!</h3>");
            return;
        }

        // Debugging: Check if database is connected
        out.println("<h3 style='color:green;'>Connected to Database Successfully</h3>");

        // SQL Query to Validate Credentials
        String query = "SELECT User_role FROM Users WHERE User_id = ? AND Password = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, userId);
        pstmt.setString(2, password);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // Retrieve the Role
            String role = rs.getString("User_role");

            // Store in Session
            session.setAttribute("role", role);
            session.setAttribute("userid", userId);

            // Redirect to Home Page
            response.sendRedirect("HomePage.jsp");
        } else {
            // Invalid Credentials
            response.sendRedirect("LoginPage.jsp?error=invalid");
        }
    } catch (ClassNotFoundException e) {
        out.println("<h3 style='color:red;'>JDBC Driver not found!</h3>");
        e.printStackTrace();
        response.sendRedirect("LoginPage.jsp?error=driver");
    } catch (SQLException e) {
        out.println("<h3 style='color:red;'>SQL Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
        response.sendRedirect("LoginPage.jsp?error=sql");
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Unexpected Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
        response.sendRedirect("LoginPage.jsp?error=unexpected");
    } finally {
        // Close Resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
