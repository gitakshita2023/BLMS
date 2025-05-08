<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Distribution Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body, html {
            height: 100%;
            font-family: 'Arial', sans-serif;
            background-color: #f4f6f9;
        }
        .dashboard-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
            padding: 20px;
            background: linear-gradient(135deg, #f5f7fa 0%, #e9ecef 100%);
        }
        .header {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            text-align: center;
        }
        .header h1 {
            color: #2c3e50;
            font-size: 2rem;
            font-weight: 700;
        }
        .content-wrapper {
            display: flex;
            flex-grow: 1;
            gap: 20px;
        }
        .stats-section {
            display: flex;
            flex-direction: column;
            justify-content: center;
            width: 30%;
            gap: 20px;
        }
        .stat-card {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.08);
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: scale(1.05);
        }
        .stat-card h3 {
            color: #495057;
            margin-bottom: 10px;
            font-size: 1.2rem;
        }
        .stat-card p {
            font-size: 2rem;
            font-weight: bold;
        }
        .teacher-stat { color: #4e73df; }
        .student-stat { color: #1cc88a; }
        .total-stat { color: #36b9cc; }
        .chart-section {
            flex-grow: 1;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.08);
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .chart-container {
            width: 100%;
            height: 100%;
        }
        .back-button-container {
    margin-bottom: 20px;
}

.back-button {
    display: inline-flex;
    align-items: center;
    padding: 8px 15px;
    background-color: #007bff;
    color: white;
    border-radius: 4px;
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s ease;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.back-button:hover {
    background-color: #0069d9;
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    transform: translateY(-2px);
}

.back-button i {
    margin-right: 8px;
}

    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h1>User Distribution Dashboard</h1>
        </div>
        <div class="back-button-container">
    <a href="HomePage.jsp" class="back-button">
        <i class="fas fa-arrow-left"></i> Back
    </a>
    </div>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            int teacherCount = 0;
            int studentCount = 0;
            
            try {
                // Establish database connection
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                String dbURL = "jdbc:derby://localhost:1527/blms";
                String dbUser = "akshita";
                String dbPassword = "akshita";
                
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                
                // Query to count users by role
                String sql = "SELECT User_role, COUNT(*) as count FROM Users GROUP BY User_role";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                
                // Process the result set
                while (rs.next()) {
                    String role = rs.getString("User_role");
                    int count = rs.getInt("count");
                    
                    if (role.equalsIgnoreCase("teacher")) {
                        teacherCount = count;
                    } else if (role.equalsIgnoreCase("student")) {
                        studentCount = count;
                    }
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            
            int totalUsers = teacherCount + studentCount;
        %>
        
        <div class="content-wrapper">
            <div class="stats-section">
                <div class="stat-card">
                    <h3>Teachers</h3>
                    <p class="teacher-stat"><%= teacherCount %></p>
                </div>
                <div class="stat-card">
                    <h3>Students</h3>
                    <p class="student-stat"><%= studentCount %></p>
                </div>
                <div class="stat-card">
                    <h3>Total Users</h3>
                    <p class="total-stat"><%= totalUsers %></p>
                </div>
            </div>
            
            <div class="chart-section">
                <div class="chart-container">
                    <canvas id="userDistributionChart"></canvas>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Data for the pie chart
        const data = {
            labels: ['Teachers', 'Students'],
            datasets: [{
                data: [<%= teacherCount %>, <%= studentCount %>],
                backgroundColor: [
                    '#4e73df', // Blue for teachers
                    '#1cc88a'  // Green for students
                ],
                hoverBackgroundColor: [
                    '#2e59d9',
                    '#17a673'
                ],
                borderWidth: 1
            }]
        };
        
        // Configuration options
        const options = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        font: {
                            size: 14
                        }
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.raw || 0;
                            const total = <%= totalUsers %>;
                            const percentage = Math.round((value / total) * 100);
                            return `${label}: ${value} (${percentage}%)`;
                        }
                    }
                },
                title: {
                    display: true,
                    text: 'User Distribution',
                    font: {
                        size: 18
                    }
                }
            }
        };
        
        // Create the pie chart
        const ctx = document.getElementById('userDistributionChart').getContext('2d');
        new Chart(ctx, {
            type: 'pie',
            data: data,
            options: options
        });
    </script>
</body>
</html>