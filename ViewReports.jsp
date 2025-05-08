<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LMS Reports Dashboard</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .filters {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            align-items: center;
        }
        .filter-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .date-input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .select-input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            min-width: 150px;
        }
        .export-btn {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .report-section {
            margin-bottom: 30px;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .report-title {
            margin-bottom: 15px;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f5f5f5;
            font-weight: bold;
        }
        .tab-container {
            margin-bottom: 20px;
        }
        .tab-button {
            padding: 10px 20px;
            margin-right: 10px;
            border: none;
            background-color: #f0f0f0;
            cursor: pointer;
            border-radius: 4px;
        }
        .tab-button.active {
            background-color: #2196F3;
            color: white;
        }
        .report-content {
            display: none;
        }
        .report-content.active {
            display: block;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Reports Dashboard</h1>
        </div>

        <div class="filters">
            <div class="filter-item">
                <label>Date Range:</label>
                <input type="date" class="date-input" id="startDate">
                <span>to</span>
                <input type="date" class="date-input" id="endDate">
            </div>
            <div class="filter-item">
                <label>User Type:</label>
                <select class="select-input" id="userType">
                    <option value="">All Users</option>
                    <option value="student">Students</option>
                    <option value="teacher">Teachers</option>
                    <option value="admin">Admins</option>
                </select>
            </div>
            <button class="export-btn" onclick="exportReport()">Export Report</button>
        </div>

        <div class="tab-container">
            <button class="tab-button active" onclick="showReport('activity')">User Activity</button>
            <button class="tab-button" onclick="showReport('submissions')">Assignment Submissions</button>
            <button class="tab-button" onclick="showReport('materials')">Study Materials</button>
            <button class="tab-button" onclick="showReport('usage')">System Usage</button>
        </div>

        <!-- User Activity Report -->
        <div id="activityReport" class="report-content active">
            <div class="report-section">
                <h2 class="report-title">User Activity Report</h2>
                <table>
                    <thead>
                        <tr>
                            <th>User Name</th>
                            <th>User Type</th>
                            <th>Last Login</th>
                            <th>Total Sessions</th>
                            <th>Average Session Duration</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${activityData}" var="activity">
                            <tr>
                                <td>${activity.userName}</td>
                                <td>${activity.userType}</td>
                                <td><fmt:formatDate value="${activity.lastLogin}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>${activity.totalSessions}</td>
                                <td>${activity.avgSessionDuration}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Assignment Submissions Report -->
        <div id="submissionsReport" class="report-content">
            <div class="report-section">
                <h2 class="report-title">Assignment Submissions Report</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Assignment Title</th>
                            <th>Submission Date</th>
                            <th>Status</th>
                            <th>Grade</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${submissionData}" var="submission">
                            <tr>
                                <td>${submission.studentName}</td>
                                <td>${submission.assignmentTitle}</td>
                                <td><fmt:formatDate value="${submission.submissionDate}" pattern="yyyy-MM-dd"/></td>
                                <td>${submission.status}</td>
                                <td>${submission.grade}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Study Materials Report -->
        <div id="materialsReport" class="report-content">
            <div class="report-section">
                <h2 class="report-title">Study Materials Report</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Material Title</th>
                            <th>Uploaded By</th>
                            <th>Upload Date</th>
                            <th>Type</th>
                            <th>Downloads</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${materialData}" var="material">
                            <tr>
                                <td>${material.title}</td>
                                <td>${material.uploadedBy}</td>
                                <td><fmt:formatDate value="${material.uploadDate}" pattern="yyyy-MM-dd"/></td>
                                <td>${material.type}</td>
                                <td>${material.downloads}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- System Usage Report -->
        <div id="usageReport" class="report-content">
            <div class="report-section">
                <h2 class="report-title">System Usage Report</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Total Users</th>
                            <th>Active Sessions</th>
                            <th>Peak Time</th>
                            <th>Resource Usage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${usageData}" var="usage">
                            <tr>
                                <td><fmt:formatDate value="${usage.date}" pattern="yyyy-MM-dd"/></td>
                                <td>${usage.totalUsers}</td>
                                <td>${usage.activeSessions}</td>
                                <td>${usage.peakTime}</td>
                                <td>${usage.resourceUsage}%</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function showReport(reportType) {
            // Hide all reports
            document.querySelectorAll('.report-content').forEach(report => {
                report.classList.remove('active');
            });
           
            // Deactivate all tabs
            document.querySelectorAll('.tab-button').forEach(tab => {
                tab.classList.remove('active');
            });
           
            // Show selected report and activate tab
            document.getElementById(reportType + 'Report').classList.add('active');
            event.target.classList.add('active');
        }

        function exportReport() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const userType = document.getElementById('userType').value;
           
            // Get active report type
            const activeReport = document.querySelector('.report-content.active').id;
           
            // You would typically make an AJAX call to your server here
            alert(`Exporting ${activeReport} for date range: ${startDate} to ${endDate}, User Type: ${userType}`);
        }

        // Initialize date inputs with current date range
        window.onload = function() {
            const today = new Date();
            const thirtyDaysAgo = new Date(today);
            thirtyDaysAgo.setDate(today.getDate() - 30);
           
            document.getElementById('startDate').value = thirtyDaysAgo.toISOString().split('T')[0];
            document.getElementById('endDate').value = today.toISOString().split('T')[0];
        }
    </script>
</body>
</html>
