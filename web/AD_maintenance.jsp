<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Account Maintenance</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        th {
            background-color: #f4f4f4;
            font-weight: 600;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        .status-active {
            color: #28a745;
            font-weight: bold;
        }
        .status-suspended {
            color: #dc3545;
            font-weight: bold;
        }
        .btn {
            display: inline-block;
            padding: 8px 12px;
            margin: 2px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        .btn-suspend {
            background-color: #dc3545;
            color: white;
        }
        .btn-activate {
            background-color: #28a745;
            color: white;
        }
        .btn-delete {
            background-color: #6c757d;
            color: white;
        }
        .btn-suspend:hover {
            background-color: #c82333;
        }
        .btn-activate:hover {
            background-color: #218838;
        }
        .btn-delete:hover {
            background-color: #5a6268;
        }
        .search-container {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
        .search-container input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            flex-grow: 1;
        }
        .search-container button {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .search-container button:hover {
            background-color: #0069d9;
        }
        .filter-container {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
        .filter-container select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .pagination a {
            color: #007bff;
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #ddd;
            margin: 0 4px;
        }
        .pagination a.active {
            background-color: #007bff;
            color: white;
            border: 1px solid #007bff;
        }
        .pagination a:hover:not(.active) {
            background-color: #ddd;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 400px;
            border-radius: 5px;
        }
        .modal-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
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
    <div class="container">
        <h1><i class="fas fa-user-cog"></i> User Account Maintenance</h1>
        
        <div class="back-button-container">
    <a href="HomePage.jsp" class="back-button">
        <i class="fas fa-arrow-left"></i> Back
    </a>
    </div>
        <%
            // Process account status change or delete if requested
            String actionUserId = request.getParameter("userId");
            String action = request.getParameter("action");
            String message = null;
            String messageType = null;
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                // Database connection
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                String dbURL = "jdbc:derby://localhost:1527/blms";
                String dbUser = "akshita";
                String dbPassword = "akshita";
                
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                
                // Check if we need to alter the Users table to add the status column
                DatabaseMetaData dbm = conn.getMetaData();
                rs = dbm.getColumns(null, null, "USERS", "STATUS");
                if (!rs.next()) {
                    // Status column doesn't exist, so add it
                    Statement stmt = conn.createStatement();
                    stmt.execute("ALTER TABLE USERS ADD COLUMN STATUS VARCHAR(20) DEFAULT 'ACTIVE'");
                    stmt.close();
                    message = "Added Status column to Users table";
                    messageType = "success";
                }
                
                // Process the action if one was requested
                if (actionUserId != null && action != null) {
                    if (action.equals("delete")) {
                        // First check the user's role to determine which related records to delete
                        String userRole = "";
                        pstmt = conn.prepareStatement("SELECT USER_ROLE FROM USERS WHERE USER_ID = ?");
                        pstmt.setString(1, actionUserId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            userRole = rs.getString("USER_ROLE");
                        }
                        pstmt.close();
                        rs.close();
                        
                        try {
                            // Start transaction
                            conn.setAutoCommit(false);
                            
                            if ("teacher".equalsIgnoreCase(userRole)) {
                                // Delete from Teacher_Subject_Mapping
                                pstmt = conn.prepareStatement("DELETE FROM TEACHER_SUBJECT_MAPPING WHERE TEACHER_ID IN (SELECT TEACHER_ID FROM TEACHER_INFO WHERE USER_ID = ?)");
                                pstmt.setString(1, actionUserId);
                                pstmt.executeUpdate();
                                pstmt.close();
                                
                                // Delete from Study_Material
                                pstmt = conn.prepareStatement("DELETE FROM STUDY_MATERIAL WHERE TEACHER_ID IN (SELECT TEACHER_ID FROM TEACHER_INFO WHERE USER_ID = ?)");
                                pstmt.setString(1, actionUserId);
                                pstmt.executeUpdate();
                                pstmt.close();
                                
                                // Delete from Department_Info
                                pstmt = conn.prepareStatement("DELETE FROM DEPARTMENT_INFO WHERE TEACHER_ID IN (SELECT TEACHER_ID FROM TEACHER_INFO WHERE USER_ID = ?)");
                                pstmt.setString(1, actionUserId);
                                pstmt.executeUpdate();
                                pstmt.close();
                                
                                // Delete from Teacher_Info
                                pstmt = conn.prepareStatement("DELETE FROM TEACHER_INFO WHERE USER_ID = ?");
                                pstmt.setString(1, actionUserId);
                                pstmt.executeUpdate();
                                pstmt.close();
                            } else if ("student".equalsIgnoreCase(userRole)) {
                                // Delete from Assignment_Submission
                                pstmt = conn.prepareStatement("DELETE FROM ASSIGNMENT_SUBMISSION WHERE STUDENT_ID IN (SELECT STUDENT_ID FROM STUDENT WHERE USER_ID = ?)");
                                pstmt.setString(1, actionUserId);
                                pstmt.executeUpdate();
                                pstmt.close();
                                
                                // Delete from Student_Class_Mapping
                                pstmt = conn.prepareStatement("DELETE FROM STUDENT_CLASS_MAPPING WHERE STUDENT_ID IN (SELECT STUDENT_ID FROM STUDENT WHERE USER_ID = ?)");
                                pstmt.setString(1, actionUserId);
                                pstmt.executeUpdate();
                                pstmt.close();
                                
                                // Delete from Student
                                pstmt = conn.prepareStatement("DELETE FROM STUDENT WHERE USER_ID = ?");
                                pstmt.setString(1, actionUserId);
                                pstmt.executeUpdate();
                                pstmt.close();
                            }
                            
                            // Finally delete from Users
                            pstmt = conn.prepareStatement("DELETE FROM USERS WHERE USER_ID = ?");
                            pstmt.setString(1, actionUserId);
                            int rowsAffected = pstmt.executeUpdate();
                            
                            if (rowsAffected > 0) {
                                conn.commit();
                                message = "User " + actionUserId + " has been deleted successfully.";
                                messageType = "success";
                            } else {
                                conn.rollback();
                                message = "Failed to delete user. User ID may not exist.";
                                messageType = "danger";
                            }
                            
                            conn.setAutoCommit(true);
                        } catch (SQLException e) {
                            try {
                                conn.rollback();
                            } catch (SQLException ex) {
                                ex.printStackTrace();
                            }
                            message = "Error deleting user: " + e.getMessage();
                            messageType = "danger";
                            e.printStackTrace();
                        }
                    } else {
                        // Suspend or activate user
                        String newStatus = action.equals("suspend") ? "SUSPENDED" : "ACTIVE";
                        String updateSql = "UPDATE USERS SET STATUS = ? WHERE USER_ID = ?";
                        pstmt = conn.prepareStatement(updateSql);
                        pstmt.setString(1, newStatus);
                        pstmt.setString(2, actionUserId);
                        int rowsAffected = pstmt.executeUpdate();
                        
                        if (rowsAffected > 0) {
                            message = "User " + actionUserId + " has been " + (newStatus.equals("SUSPENDED") ? "suspended" : "activated") + " successfully.";
                            messageType = "success";
                        } else {
                            message = "Failed to update user status. User ID may not exist.";
                            messageType = "danger";
                        }
                    }
                    
                    if (pstmt != null) pstmt.close();
                }
                
                // Get search parameters
                String searchTerm = request.getParameter("search") != null ? request.getParameter("search").trim() : "";
                String filterRole = request.getParameter("role") != null ? request.getParameter("role") : "all";
                String filterStatus = request.getParameter("status") != null ? request.getParameter("status") : "all";
                
                // Pagination parameters
                int currentPage = 1;
                int recordsPerPage = 10;
                if (request.getParameter("page") != null) {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                }
                
                // Build the SQL query with filters
                StringBuilder sqlBuilder = new StringBuilder("SELECT u.LOGIN_ID, u.USER_ID, u.USER_ROLE, COALESCE(u.STATUS, 'ACTIVE') as STATUS, ");
                sqlBuilder.append("CASE WHEN t.TEACHER_NAME IS NOT NULL THEN t.TEACHER_NAME ");
                sqlBuilder.append("WHEN s.STUDENT_NAME IS NOT NULL THEN s.STUDENT_NAME ");
                sqlBuilder.append("ELSE 'Unknown' END as NAME ");
                sqlBuilder.append("FROM USERS u ");
                sqlBuilder.append("LEFT JOIN TEACHER_INFO t ON u.USER_ID = t.USER_ID ");
                sqlBuilder.append("LEFT JOIN STUDENT s ON u.USER_ID = s.USER_ID ");
                sqlBuilder.append("WHERE 1=1 ");
                
                if (!searchTerm.isEmpty()) {
                    sqlBuilder.append("AND (u.USER_ID LIKE ? OR t.TEACHER_NAME LIKE ? OR s.STUDENT_NAME LIKE ?) ");
                }
                
                if (!filterRole.equals("all")) {
                    sqlBuilder.append("AND u.USER_ROLE = ? ");
                }
                
                if (!filterStatus.equals("all")) {
                    sqlBuilder.append("AND COALESCE(u.STATUS, 'ACTIVE') = ? ");
                }
                
                // Add ordering
                sqlBuilder.append("ORDER BY u.LOGIN_ID ");
                
                pstmt = conn.prepareStatement(sqlBuilder.toString());
                
                // Set parameters
                int paramIndex = 1;
                if (!searchTerm.isEmpty()) {
                    String searchPattern = "%" + searchTerm + "%";
                    pstmt.setString(paramIndex++, searchPattern);
                    pstmt.setString(paramIndex++, searchPattern);
                   pstmt.setString(paramIndex++, searchPattern);
                }
                
                if (!filterRole.equals("all")) {
                    pstmt.setString(paramIndex++, filterRole);
                }
                
                if (!filterStatus.equals("all")) {
                    pstmt.setString(paramIndex++, filterStatus);
                }
                
                rs = pstmt.executeQuery();
                
                // Count total records for pagination
                StringBuilder countSqlBuilder = new StringBuilder("SELECT COUNT(*) as total FROM USERS u ");
                countSqlBuilder.append("LEFT JOIN TEACHER_INFO t ON u.USER_ID = t.USER_ID ");
                countSqlBuilder.append("LEFT JOIN STUDENT s ON u.USER_ID = s.USER_ID ");
                countSqlBuilder.append("WHERE 1=1 ");
                
                if (!searchTerm.isEmpty()) {
                    countSqlBuilder.append("AND (u.USER_ID LIKE ? OR t.TEACHER_NAME LIKE ? OR s.STUDENT_NAME LIKE ?) ");
                }
                
                if (!filterRole.equals("all")) {
                    countSqlBuilder.append("AND u.USER_ROLE = ? ");
                }
                
                if (!filterStatus.equals("all")) {
                    countSqlBuilder.append("AND COALESCE(u.STATUS, 'ACTIVE') = ? ");
                }
                
                PreparedStatement countStmt = conn.prepareStatement(countSqlBuilder.toString());
                
                // Set parameters for count query
                paramIndex = 1;
                if (!searchTerm.isEmpty()) {
                    String searchPattern = "%" + searchTerm + "%";
                    countStmt.setString(paramIndex++, searchPattern);
                    countStmt.setString(paramIndex++, searchPattern);
                    countStmt.setString(paramIndex++, searchPattern);
                }
                
                if (!filterRole.equals("all")) {
                    countStmt.setString(paramIndex++, filterRole);
                }
                
                if (!filterStatus.equals("all")) {
                    countStmt.setString(paramIndex++, filterStatus);
                }
                
                ResultSet countRs = countStmt.executeQuery();
                int totalRecords = 0;
                if (countRs.next()) {
                    totalRecords = countRs.getInt("total");
                }
                countRs.close();
                countStmt.close();
                
                int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
                
                // Manual pagination since Derby doesn't support LIMIT/OFFSET
                ArrayList userList = new ArrayList();
                while (rs.next()) {
                    Map user = new HashMap();
                    user.put("loginId", rs.getInt("LOGIN_ID"));
                    user.put("userId", rs.getString("USER_ID"));
                    user.put("name", rs.getString("NAME"));
                    user.put("role", rs.getString("USER_ROLE"));
                    user.put("status", rs.getString("STATUS"));
                    userList.add(user);
                }
                
                // Apply pagination manually
                int startIdx = (currentPage - 1) * recordsPerPage;
                int endIdx = Math.min(startIdx + recordsPerPage, userList.size());
                List pagedUserList;
                if (startIdx < userList.size()) {
                    pagedUserList = userList.subList(startIdx, endIdx);
                } else {
                    pagedUserList = new ArrayList();
                }
        %>
        
        <% if (message != null) { %>
            <div class="alert alert-<%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <div class="search-container">
            <form action="AD_maintenance.jsp" method="get">
                <input type="text" name="search" placeholder="Search by ID or name..." value="<%= searchTerm %>">
                <button type="submit"><i class="fas fa-search"></i> Search</button>
            </form>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Login ID</th>
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (int i = 0; i < pagedUserList.size(); i++) { 
                    Map user = (Map)pagedUserList.get(i);
                %>
                    <tr>
                        <td><%= user.get("loginId") %></td>
                        <td><%= user.get("userId") %></td>
                        <td><%= user.get("name") %></td>
                        <td><%= user.get("role") %></td>
                        <td class="<%= user.get("status").equals("ACTIVE") ? "status-active" : "status-suspended" %>">
                            <%= user.get("status") %>
                        </td>
                        <td class="action-buttons">
                            <% if (user.get("status").equals("ACTIVE")) { %>
                                <a href="#" onclick="confirmAction('<%= user.get("userId") %>', 'suspend')" 
                                   class="btn btn-suspend" title="Suspend Account">
                                   <i class="fas fa-ban"></i> Suspend
                                </a>
                            <% } else { %>
                                <a href="#" onclick="confirmAction('<%= user.get("userId") %>', 'activate')" 
                                   class="btn btn-activate" title="Activate Account">
                                   <i class="fas fa-check-circle"></i> Activate
                                </a>
                            <% } %>
                            <a href="#" onclick="confirmAction('<%= user.get("userId") %>', 'delete')" 
                               class="btn btn-delete" title="Delete Account">
                               <i class="fas fa-trash-alt"></i> Delete
                            </a>
                        </td>
                    </tr>
                <% } %>
                
                <% if (totalRecords == 0) { %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 20px;">
                            No users found matching your criteria.
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        
        <!-- Pagination -->
        <% if (totalPages > 1) { %>
            <div class="pagination">
                <% if (currentPage > 1) { %>
                    <a href="AD_maintenance.jsp?page=<%= currentPage-1 %>&search=<%= searchTerm %>&role=<%= filterRole %>&status=<%= filterStatus %>">
                        &laquo; Previous
                    </a>
                <% } %>
                
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="AD_maintenance.jsp?page=<%= i %>&search=<%= searchTerm %>&role=<%= filterRole %>&status=<%= filterStatus %>" 
                       class="<%= currentPage == i ? "active" : "" %>">
                        <%= i %>
                    </a>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <a href="AD_maintenance.jsp?page=<%= currentPage+1 %>&search=<%= searchTerm %>&role=<%= filterRole %>&status=<%= filterStatus %>">
                        Next &raquo;
                    </a>
                <% } %>
            </div>
        <% } %>
        
        <% 
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "danger";
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
        %>
    </div>
    
    <!-- Confirmation Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3 id="modalTitle">Confirm Action</h3>
            <p id="modalMessage">Are you sure you want to perform this action?</p>
            <div class="modal-buttons">
                <button onclick="closeModal()" class="btn" style="background-color: #6c757d; color: white;">Cancel</button>
                <a id="confirmButton" href="#" class="btn btn-suspend">Confirm</a>
            </div>
        </div>
    </div>
    
    <script>
        // Modal functionality
        var modal = document.getElementById("confirmModal");
        var confirmButton = document.getElementById("confirmButton");
        var modalTitle = document.getElementById("modalTitle");
        var modalMessage = document.getElementById("modalMessage");
        
        function confirmAction(userId, action) {
            if (action === 'suspend') {
                modalTitle.innerText = "Suspend User Account";
                modalMessage.innerText = "Are you sure you want to suspend the account for user " + userId + "? The user will no longer be able to log in.";
                confirmButton.className = "btn btn-suspend";
            } else if (action === 'activate') {
                modalTitle.innerText = "Activate User Account";
                modalMessage.innerText = "Are you sure you want to activate the account for user " + userId + "? The user will be able to log in again.";
                confirmButton.className = "btn btn-activate";
            } else if (action === 'delete') {
                modalTitle.innerText = "Delete User Account";
                modalMessage.innerText = "Are you sure you want to delete the account for user " + userId + "? This action cannot be undone and will remove all associated data.";
                confirmButton.className = "btn btn-delete";
            }
            
            confirmButton.href = "AD_maintenance.jsp?userId=" + userId + "&action=" + action;
            modal.style.display = "block";
        }
        
        function closeModal() {
            modal.style.display = "none";
        }
        
        // Close modal when clicking outside of it
        window.onclick = function(event) {
            if (event.target == modal) {
                closeModal();
            }
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.getElementsByClassName('alert');
            for (var i = 0; i < alerts.length; i++) {
                alerts[i].style.display = 'none';
            }
        }, 5000);
    </script>
</body>
</html>