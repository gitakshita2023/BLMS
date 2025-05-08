<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Banasthali Learning Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            width: 100%;
            height: 100vh;
            padding: 20px;
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .header {
            margin-bottom: 20px;
        }
        .logo {
            max-width: 100px;
            margin-bottom: 15px;
        }
        .description {
            color: #666;
            font-size: 16px;
            margin-bottom: 20px;
        }
        .role-cards {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .role-card {
            width: 150px;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
        }
        .role-card:hover {
            border-color: #00a2d1;
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 162, 209, 0.2);
        }
        .role-icon {
            font-size: 36px;
            margin-bottom: 10px;
            color: #00a2d1;
        }
        .role-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        .role-description {
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="image/logo.png" alt="Banasthali Logo" class="logo">
            <h1 style="font-size: 24px;">Banasthali LMS</h1>
            <p class="description">
                Welcome to Banasthali Vidyapith's Learning Management System
            </p>
        </div>
        
        <div class="role-cards">
            <div class="role-card" onclick="selectRole('Student')">
                <i class="fas fa-user-graduate role-icon"></i>
                <div class="role-title">Student</div>
                <div class="role-description">Access course materials</div>
            </div>
            <div class="role-card" onclick="selectRole('Teacher')">
                <i class="fas fa-chalkboard-teacher role-icon"></i>
                <div class="role-title">Teacher</div>
                <div class="role-description">Upload notes and manage Assignments</div>
            </div>
            <div class="role-card" onclick="selectRole('Admin')">
                <i class="fas fa-user-shield role-icon"></i>
                <div class="role-title">Admin</div>
                <div class="role-description">System administration and management</div>
            </div>
        </div>
    </div>

    <script>
        function selectRole(role) {
            // Save the role to session storage
            sessionStorage.setItem('userRole', role);
            
            // Redirect to the next page with the role as a parameter
            window.location.href = "RoleBasedPage.jsp?role=" + role;
        }
    </script>
</body>
</html>

