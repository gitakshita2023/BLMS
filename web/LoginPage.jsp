<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Login Form</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            background: linear-gradient(135deg, #00a2d1, #0056b3);
            align-items: center;
            justify-content: center;
        }
        
        .container {
            width: 100%;
            max-width: 450px;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            margin: 20px;
            animation: fadeIn 0.5s ease-out;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        h1 {
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.2em;
            text-align: center;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-size: 0.95em;
            font-weight: 500;
        }
        
        input[type="text"], 
        input[type="password"] {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e1e1;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: white;
        }
        
        input:focus {
            border-color: #00a2d1;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 162, 209, 0.1);
        }
        
        button {
            width: 100%;
            padding: 15px;
            background: #00a2d1;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
        }
        
        button:hover {
            background: #008bb1;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 139, 177, 0.3);
        }
        
        .link {
            color: #00a2d1;
            text-decoration: none;
            font-size: 0.95em;
            transition: color 0.3s ease;
        }
        
        .link:hover {
            color: #008bb1;
            text-decoration: underline;
        }
        
        .forgot-password {
            text-align: right;
            margin: 10px 0 20px;
        }
        
        .register-text {
            text-align: center;
            margin-top: 25px;
            color: #666;
        }
        
        @media (max-width: 480px) {
            .container {
                margin: 10px;
                padding: 20px;
            }
            
            h1 {
                font-size: 1.8em;
            }
        }
    </style>
</head>
<body>
    <div style="position: absolute; top: 20px; left: 20px; z-index: 100;">
    <a href="Start.jsp" class="link" style="display: inline-flex; align-items: center; font-weight: bold; font-size: 1.1em;  color: white; padding: 8px 15px; transition: all 0.3s ease;">
        <span style="font-size: 1.3em; margin-right: 8px;">←</span> Back
    </a>
    </div>
    <div class="container">
        <h1>Login Please!</h1>

        <!-- Login Form -->
        <form action="ProcessLogin.jsp" method="POST">  <%-- Corrected filename --%>
            <div class="form-group">
                <label for="userid">User ID</label>
                <input type="text" id="userid" name="userid" required placeholder="Enter your user ID">
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password">
            </div>
            
            <div class="forgot-password">
                <a href="ResetPassword.jsp" class="link">Forgot password?</a>
            </div>
            
            <button type="submit">Sign In</button>
            
            <div class="register-text">
                Don't have an account? <a href="#" class="link" onclick="redirectToRoleRegistration()">Register here</a>
            </div>
        </form>
    </div>

    <!-- JavaScript to Handle Role-Based Registration Redirection -->
    <script>
        function redirectToRoleRegistration() {
            var role = "<%= session.getAttribute("role") != null ? session.getAttribute("role").toString().trim() : "" %>";
            
            console.log("Current role:", role);

            if (role === "Student") {
                window.location.href = "RegisterStudent.jsp";
            } else if (role === "Teacher") {
                window.location.href = "RegisterTeacher.jsp";
            } else if (role === "Admin") {
                window.location.href = "RegisterAdmin.jsp";
            } else {
                alert("Please select your role first.");
            }
        }
    </script>
</body>
</html>
