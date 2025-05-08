<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    String userId = (String) session.getAttribute("userid");
    if (role == null || userId == null || !"Student".equalsIgnoreCase(role)) {
        response.sendRedirect("LoginPage.jsp?error=unauthorized");
        return;
    }
    
    // Check for success message parameter
    String successMessage = request.getParameter("success");
    // Check for error message
    String errorMessage = request.getParameter("error");
    String errorDetails = request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Submit Assignment | Learning Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <div style="position: absolute; top: 20px; left: 20px; z-index: 100;">
    <a href="HomePage.jsp" class="link" style="display: inline-flex; align-items: center; font-weight: bold; font-size: 1.1em;  color: white; padding: 8px 15px; transition: all 0.3s ease;">
        <span style="font-size: 1.3em; margin-right: 8px;">←</span> Back
    </a>
    </div>
    <!-- Navigation Bar (same as main page) -->
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
        <!-- Success Message (will only show if success parameter exists) -->
        <% if (successMessage != null && successMessage.equals("true")) { %>
            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6" role="alert">
                <p class="font-bold">Success!</p>
                <p>Your assignment has been submitted successfully.</p>
            </div>
        <% } %>
        
        <!-- Error Message (will only show if error parameter exists) -->
        <% if (errorMessage != null && errorMessage.equals("true")) { %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
                <p class="font-bold">Error!</p>
                <p>There was a problem submitting your assignment.</p>
                <% if (errorDetails != null) { %>
                    <p class="text-sm">Details: <%= errorDetails %></p>
                <% } %>
            </div>
        <% } %>
        
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Submit Assignment</h2>
            <form action="SD_SubmitAssignments" method="POST" enctype="multipart/form-data" class="space-y-4">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Student Name</label>
                        <input
                            type="text"
                            name="studentName"
                            placeholder="e.g., AYUSHI GOEL"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Smart Card ID</label>
                        <input
                            type="text"
                            name="smartCardId"
                            placeholder="e.g., BTBTCXXXXX"
                            pattern="BTBTC[0-9]{5}"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Exam Roll Number</label>
                        <input
                            type="text"
                            name="examRollNumber"
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
                        <label class="block text-sm font-medium text-gray-700">Class</label>
                        <input
                            type="text"
                            name="class"
                            placeholder="e.g., BtechCS6sem"
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
                        <label class="block text-sm font-medium text-gray-700">Submitted To</label>
                        <input
                            type="text"
                            name="submittedTo"
                            placeholder="Teacher's Name"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Upload Assignment</label>
                        <input
                            type="file"
                            name="assignmentFile"
                            accept=".doc,.docx"
                            class="mt-1 block w-full"
                            required
                        />
                        <p class="mt-1 text-sm text-gray-500">File should be named as: BTBTXXXXXX_MATH305_secA</p>
                    </div>
                </div>
                <div class="flex justify-end mt-6">
                    <button
                        type="submit"
                        class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                    >
                        <i class="fas fa-upload mr-2"></i>Submit
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

    <!-- JavaScript for form validation -->
    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
    const fileInput = document.querySelector('input[type="file"]');
    const fileName = fileInput.files[0].name.toLowerCase(); // Get just the filename, not the path
    const smartCardId = document.querySelector('input[name="smartCardId"]').value.toLowerCase();
    const subjectCode = document.querySelector('input[name="subjectCode"]').value.toLowerCase();
    const section = document.querySelector('input[name="section"]').value.toLowerCase();
    
    // Check if file is selected
    if (fileInput.files.length === 0) {
        e.preventDefault();
        alert('Please select a file to upload.');
        return;
    }
    
    // Check file extension
    if (!fileName.endsWith('.doc') && !fileName.endsWith('.docx')) {
        e.preventDefault();
        alert('Please upload only .doc or .docx files.');
        return;
    }
    
    // Create the expected pattern
    const expectedPattern = `${smartCardId}_${subjectCode}_sec${section}`;
    
    // More flexible matching approach
    if (!fileName.includes(smartCardId) || 
        !fileName.includes(subjectCode) || 
        !fileName.includes(`sec${section}`)) {
        e.preventDefault();
        alert(`Please rename your file according to the format: ${smartCardId.toUpperCase()}_${subjectCode.toUpperCase()}_sec${section}`);
    }
});
    </script>
</body>
</html>