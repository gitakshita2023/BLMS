<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    String message = "";
    String messageType = "";
    
    // Process form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String role = request.getParameter("role");
        String userId = request.getParameter("userid");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newpassword");
        String confirmPassword = request.getParameter("confirmpassword");
        
        // Validate passwords match
        if (!newPassword.equals(confirmPassword)) {
            message = "Passwords do not match!";
            messageType = "error";
        } else {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                // Load the Derby JDBC driver
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                
                // Establish connection
                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/blms", "akshita", "akshita");
                
                boolean validUser = false;
                
                // Verify user exists with the provided email
                if ("Student".equals(role)) {
                    pstmt = conn.prepareStatement("SELECT * FROM Student WHERE User_id = ? AND Student_Email = ?");
                    pstmt.setString(1, userId);
                    pstmt.setString(2, email);
                    rs = pstmt.executeQuery();
                    validUser = rs.next();
                } else if ("Teacher".equals(role)) {
                    pstmt = conn.prepareStatement("SELECT * FROM Teacher_Info WHERE User_id = ? AND Teacher_Email = ?");
                    pstmt.setString(1, userId);
                    pstmt.setString(2, email);
                    rs = pstmt.executeQuery();
                    validUser = rs.next();
                } else if ("Admin".equals(role)) {
                    pstmt = conn.prepareStatement("SELECT * FROM Admin WHERE User_id = ? AND Admin_email = ?");
                    pstmt.setString(1, userId);
                    pstmt.setString(2, email);
                    rs = pstmt.executeQuery();
                    validUser = rs.next();
                }
                
                if (validUser) {
                    // Update password in the specific role table
                    if ("Student".equals(role)) {
                        pstmt = conn.prepareStatement("UPDATE Student SET Password = ? WHERE User_id = ?");
                        pstmt.setString(1, newPassword);
                        pstmt.setString(2, userId);
                        pstmt.executeUpdate();
                    } else if ("Teacher".equals(role)) {
                        pstmt = conn.prepareStatement("UPDATE Teacher_Info SET Password = ? WHERE User_id = ?");
                        pstmt.setString(1, newPassword);
                        pstmt.setString(2, userId);
                        pstmt.executeUpdate();
                    } else if ("Admin".equals(role)) {
                        pstmt = conn.prepareStatement("UPDATE Admin SET Password = ? WHERE User_id = ?");
                        pstmt.setString(1, newPassword);
                        pstmt.setString(2, userId);
                        pstmt.executeUpdate();
                    }
                    
                    // Also update password in Users table
                    pstmt = conn.prepareStatement("UPDATE Users SET Password = ? WHERE User_id = ?");
                    pstmt.setString(1, newPassword);
                    pstmt.setString(2, userId);
                    pstmt.executeUpdate();
                    
                    message = "Password has been reset successfully!";
                    messageType = "success";
                } else {
                    message = "Invalid user ID or email. Please check your credentials.";
                    messageType = "error";
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "error";
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    // Handle closing errors
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --background: #f8fafc;
            --card-background: #ffffff;
            --text-color: #1e293b;
            --border-color: #e2e8f0;
            --error-color: #dc2626;
            --success-color: #16a34a;
        }
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            background-color: var(--background);
            color: var(--text-color);
            line-height: 1.5;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            background-image: 
                radial-gradient(at 40% 20%, hsla(215,98%,61%,0.1) 0px, transparent 50%),
                radial-gradient(at 80% 0%, hsla(189,100%,56%,0.1) 0px, transparent 50%),
                radial-gradient(at 0% 50%, hsla(355,100%,93%,0.1) 0px, transparent 50%);
        }
        
        .container {
            width: 100%;
            max-width: 500px;
            background-color: var(--card-background);
            border-radius: 1rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            padding: 2.5rem;
        }
        
        h1 {
            font-size: 1.875rem;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 2rem;
            text-align: center;
            position: relative;
            display: inline-block;
            left: 50%;
            transform: translateX(-50%);
        }
        
        h1::after {
            content: '';
            position: absolute;
            bottom: -0.5rem;
            left: 50%;
            transform: translateX(-50%);
            width: 50%;
            height: 3px;
            background: var(--primary-color);
            border-radius: 2px;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            font-size: 0.875rem;
        }
        
        input, select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border-color);
            border-radius: 0.5rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            background-color: #f8fafc;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        button {
            width: 100%;
            padding: 0.875rem;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 0.5rem;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        button:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }
        
        button:active {
            transform: translateY(0);
        }
        
        .message {
            padding: 0.75rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
        }
        
        .success {
            background-color: #dcfce7;
            color: var(--success-color);
            border: 1px solid #bbf7d0;
        }
        
        .error {
            background-color: #fee2e2;
            color: var(--error-color);
            border: 1px solid #fecaca;
        }
        
        @media (max-width: 640px) {
            .container {
                padding: 1.5rem;
            }
        }
    </style>
    <script>
        function validateForm() {
            var newPassword = document.getElementById("newpassword").value;
            var confirmPassword = document.getElementById("confirmpassword").value;
            
            if (newPassword !== confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <a href="LoginPage.jsp" style="position: absolute; top: 1rem; left: 1rem; color: #3b82f6; font-weight: 500; text-decoration: none; font-size: 0.9rem; display: flex; align-items: center;">
    <span style="margin-right: 0.25rem;">&#8592;</span> Back
</a>

        <h1>Reset Password</h1>
        
        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <form action="ResetPassword.jsp" method="POST" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="role">Select User Role</label>
                <select id="role" name="role" required>
                    <option value="">Select Your Role</option>
                    <option value="Student">Student</option>
                    <option value="Teacher">Teacher</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="userid">User ID</label>
                <input type="text" id="userid" name="userid" required placeholder="Enter your User ID">
            </div>
            
            <div class="form-group">
                <label for="email">Registered Email</label>
                <input type="text" id="email" name="email" required placeholder="Enter your registered email">
            </div>
            
            <div class="form-group">
                <label for="newpassword">New Password</label>
                <input type="password" id="newpassword" name="newpassword" required placeholder="Enter new password" minlength="8">
            </div>
            
            <div class="form-group">
                <label for="confirmpassword">Confirm New Password</label>
                <input type="password" id="confirmpassword" name="confirmpassword" required placeholder="Confirm new password" minlength="8">
            </div>
            
            <button type="submit">Reset Password</button>
        </form>
        
    </div>
</body>
</html>