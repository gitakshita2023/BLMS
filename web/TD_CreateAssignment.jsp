<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    String userId = (String) session.getAttribute("userid");
    if (role == null || userId == null || !"Teacher".equalsIgnoreCase(role)) {
        response.sendRedirect("LoginPage.jsp?error=unauthorized");
        return;
    }
    
    // Check for success message from previous submission
    String successMessage = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Create Assignment | Learning Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <div style="position: absolute; top: 20px; left: 20px; z-index: 100;">
    <a href="javascript:history.back()" class="link" style="display: inline-flex; align-items: center; font-weight: bold; font-size: 1.1em;  color: white; padding: 8px 15px; transition: all 0.3s ease;">
        <span style="font-size: 1.3em; margin-right: 8px;">←</span> Back
    </a>
    </div>
    <!-- Navigation Bar -->
    <nav class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white shadow-lg">
        <div class="container mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center">
                <i class="fas fa-graduation-cap text-2xl mr-3"></i>
                <span class="text-xl font-bold">Learning Portal</span>
            </div>
            <div class="flex items-center">
                <a href="HomePage.jsp" class="mr-4">
                    <i class="fas fa-home mr-2"></i>Home Page
                </a>
                <span class="mr-4">Welcome, <%= userId %></span>
                <a href="Logout.jsp" class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mx-auto px-6 py-8">
        <% if (successMessage != null && successMessage.equals("true")) { %>
            <div class="mb-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
                <strong class="font-bold">Success!</strong>
                <span class="block sm:inline"> Assignment created successfully.</span>
                <span class="absolute top-0 bottom-0 right-0 px-4 py-3">
                    <svg onclick="this.parentElement.parentElement.remove()" class="fill-current h-6 w-6 text-green-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Close</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
                </span>
            </div>
        <% } %>
        
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Create New Assignment</h2>
            <form action="TD_CreateAssignment" method="POST" enctype="multipart/form-data" class="space-y-4">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Teacher Name</label>
                        <input
                            type="text"
                            name="teacherName"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Subject Code</label>
                        <input
                            type="text"
                            name="subjectCode"
                            placeholder="e.g., MATH305"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Subject Name</label>
                        <input
                            type="text"
                            name="subjectName"
                            placeholder="e.g., Advanced Mathematics"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Course and Semester</label>
                        <input
                            type="text"
                            name="courseSemester"
                            placeholder="e.g., BTech6sem"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Section</label>
                        <input
                            type="text"
                            name="section"
                            placeholder="e.g., A"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Submission Date</label>
                        <input
                            type="date"
                            name="submissionDate"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700">Assignment Title</label>
                        <input
                            type="text"
                            id="assignmentTitle"
                            name="assignmentTitle"
                            placeholder="e.g., MATH305-Btech6sem-seca"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                        <p class="mt-1 text-sm text-gray-500">Format: subjectCode-courseAndSemester-section</p>
                        
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700">Upload Assignment File</label>
                        <input
                            type="file"
                            name="assignmentFile"
                            accept=".doc,.docx"
                            class="mt-1 block w-full"
                            required
                        />
                        <p class="mt-1 text-sm text-gray-500">Only .doc or .docx files are accepted</p>
                    </div>
                </div>
                <div class="flex justify-end space-x-4 mt-6">
                    <button
                        type="button"
                        onclick="window.location.href='Dashboard.jsp'"
                        class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                    >
                        <i class="fas fa-times mr-2"></i>Cancel
                    </button>
                    <button
                        type="submit"
                        class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                    >
                        <i class="fas fa-paper-plane mr-2"></i>Submit
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white mt-12">
        <div class="container mx-auto px-6 py-4">
            <div class="flex justify-between items-center">
                <div>
                    <p class="text-sm">&copy; 2025 Learning Portal. All rights reserved.</p>
                </div>
                <div class="flex space-x-4">
                    <a href="#" class="hover:text-gray-300">
                        <i class="fas fa-question-circle"></i> Help
                    </a>
                    <a href="#" class="hover:text-gray-300">
                        <i class="fas fa-envelope"></i> Contact
                    </a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Form validation -->
    <script>
        // Auto-generate assignment title
        document.getElementById('generateTitle').addEventListener('click', function() {
            const subjectCode = document.querySelector('input[name="subjectCode"]').value.toLowerCase().trim();
            const courseSemester = document.querySelector('input[name="courseSemester"]').value
                .toLowerCase()
                .trim()
                .replace(/\s+/g, ''); // Remove spaces
            const section = document.querySelector('input[name="section"]').value.toLowerCase().trim();
            
            if(subjectCode && courseSemester && section) {
                const generatedTitle = ${subjectCode}-${courseSemester}-sec${section};
                document.getElementById('assignmentTitle').value = generatedTitle;
            } else {
                alert('Please fill in Subject Code, Course and Semester, and Section fields first.');
            }
        });

        // Less strict validation for assignment title
        document.querySelector('form').addEventListener('submit', function(e) {
            const assignmentTitle = document.querySelector('input[name="assignmentTitle"]').value.trim();
            
            // Basic format check - should contain the three parts with hyphens
            if (!assignmentTitle.includes('-')) {
                e.preventDefault();
                alert('Assignment title should contain hyphens to separate parts (e.g., math305-btech6sem-seca)');
            }
        });

        // Set minimum date as today
        const submissionDateInput = document.querySelector('input[name="submissionDate"]');
        const today = new Date().toISOString().split('T')[0];
        submissionDateInput.min = today;
    </script>
</body>
</html>