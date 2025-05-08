<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Invalidate the session and remove user data
    session.invalidate();

    // Clear the role from sessionStorage using JavaScript
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logging Out...</title>
    <script>
        // Remove role from sessionStorage
        sessionStorage.removeItem('userRole');
        
        // Redirect to the login page after a short delay
        setTimeout(function() {
            window.location.href = "LoginPage.jsp"; // Change this to your login page
        }, 1500);
    </script>
</head>
<body>
    <p style="text-align: center; font-size: 18px;">Logging out... Please wait.</p>
</body>
</html>

