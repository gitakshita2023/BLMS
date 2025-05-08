<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Store the role in session when it's received
    String role = request.getParameter("role");
    if (role != null && !role.trim().isEmpty()) {
        session.setAttribute("role", role);
    }
%>
<html>
<head>
    <title>Role Based Page</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            height: 100vh;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .back-button {
            position: fixed;
            top: 20px;
            left: 20px;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.9);
            border: none;
            border-radius: 50px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .back-button:hover {
            transform: translateX(-5px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
        }

        .wrapper {
            width: 100%;
            max-width: 1200px;
            height: calc(100vh - 40px);
            max-height: 800px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            height: 100%;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            display: flex;
            flex-direction: column;
        }

        .header-section {
            flex: 0 0 auto;
            margin-bottom: 20px;
        }

        h1 {
            color: #2d3436;
            font-size: 2.2em;
            margin-bottom: 10px;
            text-align: center;
        }

        h2 {
            color: #00a2d1;
            font-size: 1.6em;
            margin: 10px 0;
            text-align: center;
        }

        .role-message {
            flex: 0 0 auto;
            text-align: center;
            font-size: 1.1em;
            color: #636e72;
            margin: 15px 0;
            padding: 15px;
            background: rgba(0, 162, 209, 0.1);
            border-radius: 10px;
            line-height: 1.6;
        }

        .divider {
            flex: 0 0 auto;
            height: 2px;
            background: linear-gradient(to right, transparent, #00a2d1, transparent);
            margin: 20px 0;
            border: none;
        }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-around;
            min-height: 0;
        }

        .section {
            text-align: center;
            padding: 15px 0;
        }

        .section h2 {
            font-size: 1.4em;
            color: #2d3436;
            margin-bottom: 15px;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 30px;
            background: #00a2d1;
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1.1em;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(0, 162, 209, 0.2);
        }

        .button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 162, 209, 0.3);
            background: #008bb1;
        }

        .button.secondary {
            background: #6c5ce7;
        }

        .button.secondary:hover {
            background: #5f3dc4;
        }

        .button.help {
            background: #00b894;
        }

        .button.help:hover {
            background: #00a885;
        }

        .icon {
            margin-right: 8px;
        }

        @media (max-height: 600px) {
            .container {
                padding: 15px;
            }

            h1 {
                font-size: 1.8em;
            }

            h2 {
                font-size: 1.3em;
            }

            .role-message {
                font-size: 1em;
                padding: 10px;
            }

            .button {
                padding: 8px 20px;
                font-size: 1em;
            }
        }

        @media (max-width: 768px) {
            .button-group {
                flex-direction: column;
            }

            .button {
                width: 80%;
                margin: 5px auto;
            }
        }
    </style>
</head>
<body>
    <button class="back-button" onclick="location.href='Start.jsp'">
    <i class="fas fa-arrow-left"></i> Back
</button>

    <div class="wrapper">
        <div class="container">
            <div class="header-section">
                <h1>Welcome to Banasthali LMS</h1>
                <h2><i class="fas fa-user-circle"></i> Role: <%= role %></h2>
            </div>

            <div class="role-message">
                <% if ("Admin".equals(role)) { %>
                    <i class="fas fa-user-shield icon"></i>
                    <p>As an Admin, you have complete access to manage the system, users, and maintain the platform's integrity.</p>
                <% } else if ("Teacher".equals(role)) { %>
                    <i class="fas fa-chalkboard-teacher icon"></i>
                    <p>As a Teacher, you can upload Notes, create and manage Assignments.</p>
                <% } else if ("Student".equals(role)) { %>
                    <i class="fas fa-user-graduate icon"></i>
                    <p>As a Student, you have access to course materials, assignments, and assignment submission.</p>
                <% } else { %>
                    <i class="fas fa-info-circle icon"></i>
                    <p>Please register or log in to proceed with your learning journey.</p>
                <% } %>
            </div>

            <div class="main-content">
                <div class="section">
                    <h2>Account Access</h2>
                    <div class="button-group">
                        <button onclick="location.href='LoginPage.jsp'" class="button">
                            <i class="fas fa-sign-in-alt icon"></i>Login
                        </button>
                        <button onclick="redirectToRegistration()" class="button secondary">
                            <i class="fas fa-user-plus icon"></i>Register
                        </button>
                    </div>
                </div>

                <div class="section">
                    <h2>Need Assistance?</h2>
                    <button onclick="location.href='Help.jsp'" class="button help">
                        <i class="fas fa-question-circle icon"></i>Get Help
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function redirectToRegistration() {
            var role = '<%= session.getAttribute("role") %>';
            if (role === 'Student') {
                window.location.href = 'RegisterStudent.jsp';
            } else if (role === 'Teacher') {
                window.location.href = 'RegisterTeacher.jsp';
            } else if (role === 'Admin') {
                window.location.href = 'RegisterAdmin.jsp';
            } else {
                alert('Please select your role first.');
                window.location.href = 'Start.jsp';
            }
        }
    </script>
</body>
</html>