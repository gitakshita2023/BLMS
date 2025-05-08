<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Assignments</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <div style="position: absolute; top: 20px; left: 20px; z-index: 100;">
    <a href="javascript:history.back()" class="link" style="display: inline-flex; align-items: center; font-weight: bold; font-size: 1.1em;  color: white; padding: 8px 15px; transition: all 0.3s ease;">
        <span style="font-size: 1.3em; margin-right: 8px;">←</span> Back
    </a>
    
    </div>
    <nav class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white shadow-lg">
        <div class="container mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center">
                <i class="fas fa-graduation-cap text-2xl mr-3"></i>
                <span class="text-xl font-bold">Learning Portal</span>
            </div>
            <div class="flex items-center">
                <a href="HomePage.jsp" class="mr-4">
                    <i class="fas fa-home mr-2"></i>Home
                </a>
                <span class="mr-4">Welcome, <%= session.getAttribute("userid") %></span>
                <a href="Logout.jsp" class="bg-red-500 hover:bg-red-600 px-4 py-2 rounded-lg">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto px-6 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Your Assignments</h2>
            
            <div class="overflow-x-auto">
                <table class="min-w-full table-auto">
                    <thead class="bg-gray-100">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Teacher</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Subject</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Class</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Upload Date</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Description</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <%
                            List<JSONObject> assignments = (List<JSONObject>) request.getAttribute("assignments");
                            if (assignments != null && !assignments.isEmpty()) {
                                for (JSONObject assignment : assignments) {
                        %>
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap"><%= assignment.getString("teacherName") %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <%= assignment.getString("subjectName") %> (<%= assignment.getString("subjectCode") %>)
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <%= assignment.getString("className") %> - <%= assignment.getString("section") %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= assignment.getString("uploadDate") %></td>
                            <td class="px-6 py-4"><%= assignment.getString("description") %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
    <a href="SD_ViewAssignments?action=download&filePath=<%= java.net.URLEncoder.encode(assignment.getString("filePath"), "UTF-8") %>&fileName=<%= java.net.URLEncoder.encode(assignment.getString("fileName"), "UTF-8") %>" 
       class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded inline-flex items-center">
        <i class="fas fa-download mr-2"></i>Download
    </a>
</td>

                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6" class="px-6 py-4 text-center text-gray-500">No assignments found.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>