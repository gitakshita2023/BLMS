<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LMS Admin Dashboard</title>
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
        }
        .search-box {
            padding: 8px;
            width: 200px;
        }
        .role-filter {
            padding: 8px;
        }
        .add-user-btn {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f5f5f5;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
        }
        .status-active {
            background-color: #e7f7ed;
            color: #1d6f42;
        }
        .status-inactive {
            background-color: #fbe9e7;
            color: #c62828;
        }
        .action-btn {
            padding: 5px 10px;
            margin-right: 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .edit-btn {
            background-color: #2196F3;
            color: white;
        }
        .delete-btn {
            background-color: #f44336;
            color: white;
        }
        .toggle-btn {
            background-color: #757575;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>User Management</h1>
            <button class="add-user-btn" onclick="showAddUserModal()">Add User</button>
        </div>

        <div class="filters">
            <input type="text" id="searchInput" class="search-box" placeholder="Search by name..." onkeyup="filterUsers()">
            <select id="roleFilter" class="role-filter" onchange="filterUsers()">
                <option value="">All Roles</option>
                <option value="Student">Student</option>
                <option value="Teacher">Teacher</option>
                <option value="Admin">Admin</option>
            </select>
        </div>

        <table id="usersTable">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${users}" var="user">
                    <tr>
                        <td>${user.name}</td>
                        <td>${user.role}</td>
                        <td>${user.email}</td>
                        <td>
                            <span class="status-badge ${user.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                ${user.status}
                            </span>
                        </td>
                        <td>
                            <button class="action-btn edit-btn" onclick="editUser(${user.id})">Edit</button>
                            <button class="action-btn delete-btn" onclick="deleteUser(${user.id})">Delete</button>
                            <button class="action-btn toggle-btn" onclick="toggleStatus(${user.id})">
                                ${user.status == 'Active' ? 'Deactivate' : 'Activate'}
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script>
        function filterUsers() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const roleFilter = document.getElementById('roleFilter').value;
            const table = document.getElementById('usersTable');
            const rows = table.getElementsByTagName('tr');

            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const name = row.cells[0].textContent.toLowerCase();
                const role = row.cells[1].textContent;
                const matchesSearch = name.includes(searchText);
                const matchesRole = roleFilter === '' || role === roleFilter;
                row.style.display = matchesSearch && matchesRole ? '' : 'none';
            }
        }

        function showAddUserModal() {
            // Implement add user modal functionality
            alert('Add user modal will be shown here');
        }

        function editUser(userId) {
            // Implement edit user functionality
            alert('Edit user ' + userId);
        }

        function deleteUser(userId) {
            if (confirm('Are you sure you want to delete this user?')) {
                // Implement delete user functionality
                alert('Delete user ' + userId);
            }
        }

        function toggleStatus(userId) {
            // Implement toggle status functionality
            alert('Toggle status for user ' + userId);
        }
    </script>
</body>
</html>