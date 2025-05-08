<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Uploaded Materials</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f5f7ff;
        margin: 0;
        padding: 0;
    }
    /* Header styles */
    .header {
        background-color: #6c5ce7;
        color: white;
        padding: 15px 0;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        margin: 0;
        width: 100%;
        position: relative;
    }
    /* Fix for the white box appearing at the top */
    .container:empty,
    .container:first-of-type:not(:has(h2)) {
        display: none;
    }
    /* Logo styling */
    .logo {
        font-size: 24px;
        font-weight: bold;
        display: flex;
        align-items: center;
    }
    .logo i {
        margin-right: 10px;
        font-size: 28px;
    }
    /* Navigation links */
    .nav-links {
        display: flex;
        align-items: center;
        justify-content: flex-end;
    }
    .nav-links a, .nav-links span {
        color: white;
        text-decoration: none;
        margin-left: 20px;
        font-weight: 500;
        transition: color 0.3s;
    }
    .nav-links a:hover {
        color: #ffd700;
    }
    /* Container styling */
    .container {
        width: 90%;
        max-width: 1200px;
        margin: 30px auto;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        padding: 25px;
    }
    /* Heading styles */
    h2 {
        color: #6c5ce7;
        text-align: center;
        margin: 30px 0;
        font-size: 28px;
        position: relative;
    }
    h2:after {
        content: '';
        display: block;
        width: 100px;
        height: 4px;
        background-color: #6c5ce7;
        margin: 10px auto 0;
        border-radius: 2px;
    }
    /* Table styles */
    .data-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
    }
    .data-table th {
        background-color: #6c5ce7;
        color: white;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        padding: 15px;
        font-size: 14px;
        text-align: left;
        border: none;
    }
    .data-table td {
        padding: 15px;
        border: none;
        border-bottom: 1px solid #f0f0f0;
        color: #333;
    }
    .data-table tr:nth-child(even) {
        background-color: #f9f9ff;
    }
    .data-table tr:hover {
        background-color: #f0f2ff;
    }
    .data-table tr:last-child td {
        border-bottom: none;
    }
    /* Button styles */
    .btn {
        padding: 10px 20px;
        border-radius: 50px;
        font-weight: 600;
        transition: all 0.3s;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        border: none;
        cursor: pointer;
        text-decoration: none;
        color: white;
    }
    .btn i {
        margin-right: 5px;
    }
    .btn-download {
        background-color: #6c5ce7 !important;
    }
    .btn-download:hover {
        background-color: #5649c0 !important;
        transform: translateY(-2px);
                box-shadow: 0 6px 10px rgba(108, 92, 231, 0.3);
    }
    .btn-delete {
        background-color: #e74c3c !important;
        color: white;
    }
    .btn-delete:hover {
        background-color: #c0392b !important;
        transform: translateY(-2px);
        box-shadow: 0 6px 10px rgba(231, 76, 60, 0.3);
    }
    /* Back button styling */
    div[style*="position: absolute"] {
        top: 20px;
        left: 20px;
        z-index: 100;
    }
    div[style*="position: absolute"] a.link {
        background-color: rgba(255, 255, 255, 0.2);
        color: blue !important;
        font-weight: bold;
        padding: 10px 20px;
        border-radius: 50px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        transition: all 0.3s ease;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    div[style*="position: absolute"] a.link:hover {
        background-color: rgba(255, 255, 255, 0.3);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }
    /* Fix any empty divs */
    div:empty {
        display: none;
    }
    /* Responsive adjustments */
    @media (max-width: 768px) {
        .container {
            width: 95%;
            padding: 15px;
        }
        
        .data-table th, .data-table td {
            padding: 10px;
            font-size: 14px;
        }
        
        .btn {
            padding: 8px 12px;
            font-size: 13px;
        }
        
        h2 {
            font-size: 24px;
        }
    }
    /* Make the table responsive */
    @media (max-width: 992px) {
        .data-table {
            display: block;
            overflow-x: auto;
            white-space: nowrap;
        }
    }
    /* Empty state styling */
    tbody tr td[colspan] {
        text-align: center;
        padding: 30px;
        font-style: italic;
        color: #777;
    }
    /* Alert message styling */
    .alert {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: space-between;
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
    .alert-icon {
        margin-right: 10px;
        font-size: 18px;
    }
    .alert-close {
        background: none;
        border: none;
        color: inherit;
        font-size: 20px;
        cursor: pointer;
        opacity: 0.7;
    }
    .alert-close:hover {
        opacity: 1;
    }
    /* Modal styles */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
    }
    .modal-content {
        background-color: white;
        margin: 15% auto;
        padding: 20px;
        border-radius: 10px;
        width: 400px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }
    .modal-title {
        color: #e74c3c;
        margin-top: 0;
    }
    .modal-buttons {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 20px;
    }
    .modal-cancel {
        padding: 8px 16px;
        background-color: #6c757d;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    .modal-delete {
        padding: 8px 16px;
        background-color: #e74c3c;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    </style>
</head>
<body>
    <div style="position: absolute; top: 20px; left: 20px; z-index: 100;">
    <a href="javascript:history.back()" class="link" style="display: inline-flex; align-items: center; font-weight: bold; font-size: 1.1em;  color: blue; padding: 8px 15px; transition: all 0.3s ease;">
        <span style="font-size: 1.3em; margin-right: 8px;">←</span> Back
    </a>
    
    </div>
    <header class="header">
        <div class="container">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
                <span>Learning Portal</span>
            </div>
            <div class="nav-links">
                <a href="HomePage.jsp">Home</a>
                <span>Welcome, <%= session.getAttribute("userid") %></span>
                <a href="Logout.jsp">Logout</a>
            </div>
        </div>
    </header>
    <div class="container">
        <h2>Your Uploaded Materials</h2>
        
        <% 
        // Display success message if present
        String successMessage = request.getParameter("success");
        String errorMessage = request.getParameter("error");
        String message = request.getParameter("message");
        
        if ("true".equals(successMessage) && message != null && !message.isEmpty()) {
        %>
            <div class="alert alert-success" id="successAlert">
                <div>
                    <i class="fas fa-check-circle alert-icon"></i>
                    <%= message %>
                </div>
                <button class="alert-close" onclick="document.getElementById('successAlert').style.display='none';">&times;</button>
            </div>
        <% 
        } else if ("true".equals(errorMessage) && message != null && !message.isEmpty()) {
        %>
            <div class="alert alert-danger" id="errorAlert">
                <div>
                    <i class="fas fa-exclamation-circle alert-icon"></i>
                    <%= message %>
                </div>
                <button class="alert-close" onclick="document.getElementById('errorAlert').style.display='none';">&times;</button>
            </div>
        <% 
        }
        %>
        
        <table class="data-table">
            <thead>
                <tr>
                    <th>Subject</th>
                    <th>Class</th>
                    <th>Section</th>
                    <th>File Name</th>
                    <th>Type</th>
                    <th>Upload Date</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<JSONObject> uploads = (List<JSONObject>) request.getAttribute("uploads");
                    if (uploads != null && !uploads.isEmpty()) {
                        for (JSONObject upload : uploads) {
                %>
                    <tr>
                        <td><%= upload.getString("subjectName") %> (<%= upload.getString("subjectCode") %>)</td>
                        <td><%= upload.getString("className") %></td>
                        <td><%= upload.getString("section") %></td>
                        <td><%= upload.getString("fileName") %></td>
                        <td><%= upload.getString("materialType") %></td>
                        <td><%= upload.getString("uploadDate").substring(0, 19) %></td>
                        <td><%= upload.optString("description", "N/A") %></td>
                        <td>
                            <a href="TD_ViewUploads?action=download&filePath=<%= java.net.URLEncoder.encode(upload.getString("filePath"), "UTF-8") %>&fileName=<%= java.net.URLEncoder.encode(upload.getString("fileName"), "UTF-8") %>" 
                               class="btn btn-download">
                                <i class="fas fa-download"></i> Download
                            </a>
                            <button type="button" class="btn btn-delete" 
                                    onclick="confirmDelete(<%= upload.getInt("materialId") %>, '<%= java.net.URLEncoder.encode(upload.getString("filePath"), "UTF-8") %>', '<%= upload.getString("fileName") %>')">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="8" style="text-align: center;">No uploads found.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title">Confirm Deletion</h3>
            <p id="deleteMessage">Are you sure you want to delete this file?</p>
            <div class="modal-buttons">
                <button class="modal-cancel" onclick="closeDeleteModal()">Cancel</button>
                <form id="deleteForm" action="TD_ViewUploads" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" id="materialIdInput" name="materialId" value="">
                    <input type="hidden" id="filePathInput" name="filePath" value="">
                    <button type="submit" class="modal-delete">Delete</button>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            var successAlert = document.getElementById('successAlert');
            var errorAlert = document.getElementById('errorAlert');
            
            if (successAlert) successAlert.style.display = 'none';
            if (errorAlert) errorAlert.style.display = 'none';
        }, 5000);
        
        // Delete confirmation functions
        function confirmDelete(materialId, filePath, fileName) {
            document.getElementById('deleteMessage').textContent = 'Are you sure you want to delete "' + fileName + '"?';
            document.getElementById('materialIdInput').value = materialId;
            document.getElementById('filePathInput').value = filePath;
            document.getElementById('deleteModal').style.display = 'block';
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }
        
        // Close modal when clicking outside of it
        window.onclick = function(event) {
            var modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                closeDeleteModal();
            }
        }
    </script>
</body>
</html>

