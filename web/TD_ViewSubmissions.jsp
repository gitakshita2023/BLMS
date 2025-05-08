<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    
    <title>View Assignments</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Your existing CSS styles remain the same -->
    <style>
        /* Global Styles */
        :root {
          --primary-color: #3a6ea5;
          --secondary-color: #ff6b6b;
          --accent-color: #6dbb63;
          --dark-color: #383838;
          --light-color: #f8f9fa;
          --border-radius: 8px;
          --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
          --transition: all 0.3s ease;
        }
        
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
          background-color: #f4f7f9;
          color: var(--dark-color);
          line-height: 1.6;
        }
        
        .container {
          width: 90%;
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 20px;
        }
        
        /* Header Styles */
        .header {
          background-color: var(--primary-color);
          color: white;
          padding: 15px 0;
          box-shadow: var(--box-shadow);
          position: sticky;
          top: 0;
          z-index: 100;
        }
        
        .header-content {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        
        .logo {
          display: flex;
          align-items: center;
          gap: 10px;
          font-size: 1.5rem;
          font-weight: bold;
        }
        
        .logo i {
          font-size: 1.8rem;
          color: #ffde59;
        }
        
        .nav-links {
          display: flex;
          align-items: center;
          gap: 20px;
        }
        
        .nav-link {
          display: flex;
          align-items: center;
          gap: 6px;
          color: white;
          text-decoration: none;
          transition: var(--transition);
          padding: 8px 12px;
          border-radius: var(--border-radius);
        }
        
        .nav-link:hover {
          background-color: rgba(255, 255, 255, 0.1);
        }
        
        .btn {
          cursor: pointer;
          font-weight: 600;
          padding: 8px 16px;
          border: none;
          border-radius: var(--border-radius);
          transition: var(--transition);
          display: inline-flex;
          align-items: center;
          gap: 8px;
          background-color: var(--primary-color);
          color: white;
        }
        
        .btn:hover {
          opacity: 0.9;
          transform: translateY(-2px);
        }
        
        .btn-danger {
          background-color: var(--secondary-color);
        }
        
        /* Page Content Styles */
        .page-title {
          color: var(--primary-color);
          margin: 30px 0;
          font-size: 2rem;
          text-align: center;
          position: relative;
          padding-bottom: 10px;
        }
        
        .page-title::after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 50%;
          transform: translateX(-50%);
          width: 100px;
          height: 3px;
          background-color: var(--accent-color);
        }
        
        /* Data Table Styles */
        .data-table-container {
          background-color: white;
          border-radius: var(--border-radius);
          overflow: hidden;
          box-shadow: var(--box-shadow);
          margin-bottom: 30px;
        }
        
        .data-table {
          width: 100%;
          border-collapse: collapse;
          overflow: hidden;
        }
        
        .data-table th {
          background-color: var(--primary-color);
          color: white;
          text-align: left;
          padding: 15px;
          font-size: 1rem;
        }
        
        .data-table td {
          padding: 15px;
          border-bottom: 1px solid #e0e0e0;
          color: var(--dark-color);
        }
        
        .data-table tr:last-child td {
          border-bottom: none;
        }
        
        .data-table tr:hover {
          background-color: rgba(106, 161, 228, 0.05);
        }
        
        .data-table button {
          background-color: var(--primary-color);
          color: white;
          padding: 8px 12px;
          border: none;
          border-radius: var(--border-radius);
          cursor: pointer;
          transition: var(--transition);
          display: flex;
          align-items: center;
          gap: 6px;
        }
        
        .data-table button:hover {
          background-color: #2c5282;
          transform: translateY(-2px);
        }
        
        .data-table button i {
          font-size: 0.9rem;
        }
        
        /* Message Styles */
        .message {
          padding: 15px;
          border-radius: var(--border-radius);
          margin: 20px 0;
          display: flex;
          align-items: center;
          gap: 10px;
        }
        
        .message-error {
          background-color: #ffe5e5;
          color: #d63031;
          border-left: 4px solid #d63031;
        }
        
        .message i {
          font-size: 1.2rem;
        }
        
        /* Responsive Styles */
        @media (max-width: 768px) {
          .header-content {
            flex-direction: column;
            gap: 15px;
          }
          
          .nav-links {
            width: 100%;
            justify-content: space-between;
          }
          
          .data-table {
            display: block;
            overflow-x: auto;
          }
          
          .page-title {
            font-size: 1.5rem;
          }
        }
        
        @media (max-width: 576px) {
          .nav-links {
            flex-direction: column;
            gap: 10px;
          }
          
          .nav-link span {
            display: none;
          }
          
          .nav-link i {
            font-size: 1.2rem;
          }
          
          .data-table th,
          .data-table td {
            padding: 10px;
            font-size: 0.9rem;
          }
        }
    </style>
    
</head>
<body>
    <div style="
    position: absolute; 
    top: 20px; 
    left: 20px; 
    z-index: 200;
">
    <a href="HomePage.jsp" style="
        text-decoration: none;
        color: white;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 8px;
    ">
        <span style="font-size: 1.5em;">←</span>
        <span>Back</span>
    </a>
</div>
    <!-- Header Component remains the same -->
    <header class="header">
        <div class="container header-content">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
                <span>Learning Portal</span>
            </div>
            <div class="nav-links">
                <a href="HomePage.jsp" class="nav-link">
                    <i class="fas fa-home"></i>
                    <span>Home</span>
                </a>
                <span class="nav-link">
                    <i class="fas fa-user"></i>
                    <span>Welcome, <%= session.getAttribute("userid") %></span>
                </span>
                <a href="Logout.jsp" class="nav-link btn btn-danger">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>
    </header>

    <div class="container">
        <h2 class="page-title">Submitted Assignments</h2>
        
        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Subject</th>
                        <th>Class</th>
                        <th>Section</th>
                        <th>File Name</th>
                        <th>Submission Date</th>
                        <th>Download</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    List<JSONObject> submissions = (List<JSONObject>) request.getAttribute("submissions");
                    if (submissions != null && !submissions.isEmpty()) {
                        for (JSONObject submission : submissions) {
                %>
                    <tr>
                        <td><%= submission.getString("studentName") %></td>
                        <td><%= submission.getString("subjectName") %> (<%= submission.getString("subjectCode") %>)</td>
                        <td><%= submission.getString("className") %></td>
                        <td><%= submission.getString("section") %></td>
                        <td><%= submission.getString("fileName") %></td>
                        <td><%= submission.getString("submissionDate") %></td>
                        <td>
                            <form action="TD_ViewSubmissions" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="download">
                                <input type="hidden" name="filePath" value="<%= submission.getString("filePath") %>">
                                <input type="hidden" name="fileName" value="<%= submission.getString("fileName") %>">
                                <button type="submit" class="btn">
                                    <i class="fas fa-download"></i> Download
                                </button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" style="text-align: center;">No submissions found.</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <% if (request.getParameter("error") != null) { %>
            <div class="message message-error">
                <i class="fas fa-exclamation-circle"></i>
                Error: <%= request.getParameter("message") %>
            </div>
        <% } %>
    </div>
</body>
</html>