<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    String userId = (String) session.getAttribute("userid");
    if (role == null || userId == null || !"Teacher".equalsIgnoreCase(role)) {
        response.sendRedirect("LoginPage.jsp?error=unauthorized");
        return;
    }
        
    // Check for success message
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Study Notes | Learning Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <div style="position: absolute; top: 20px; left: 20px; z-index: 100;">
    <a href="HomePage.jsp" class="link" style="display: inline-flex; align-items: center; font-weight: bold; font-size: 1.1em;  color: white; padding: 8px 15px; transition: all 0.3s ease;">
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

    <!-- Success/Error Messages -->
    <% if (successMessage != null && successMessage.equals("true")) { %>
    <div class="container mx-auto px-6 mt-4">
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-4" role="alert">
            <p class="font-bold">Success!</p>
            <p>Your study notes were uploaded successfully.</p>
        </div>
    </div>
    <% } else if (errorMessage != null && errorMessage.equals("true")) { %>
    <div class="container mx-auto px-6 mt-4">
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-4" role="alert">
            <p class="font-bold">Error!</p>
            <p>There was an error uploading your study notes: <%= request.getParameter("message") %></p>
        </div>
    </div>
    <% } %>

    <!-- Main Content -->
    <div class="container mx-auto px-6 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Upload Study Notes</h2>
            <!-- Fixed multipart form enctype attribute and added the @MultipartConfig annotation equivalent for JSP -->
            <form action="TD_UploadNotes" method="POST" enctype="multipart/form-data" class="space-y-4">
                
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
                        <label class="block text-sm font-medium text-gray-700">Topic Name</label>
                        <input
                            type="text"
                            name="topicName"
                            placeholder="e.g., Differential_Equations"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                        <p class="mt-1 text-sm text-gray-500">Use underscore instead of spaces</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Course and Semester</label>
                        <input
                            type="text"
                            name="courseSemester"
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
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700">Notes Title</label>
                        <input
                            type="text"
                            name="notesTitle"
    
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            required
                        />
                        <p class="mt-1 text-sm text-gray-500">Preferrable Format: subjectCode-topicName-courseAndSemester-secSection</p>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700">Description</label>
                        <textarea
                            name="description"
                            rows="3"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                            placeholder="Brief description of the study notes content"
                            required
                        ></textarea>
                    </div>
                    <div class="md:col-span-2">
    <label class="block text-sm font-medium text-gray-700">Upload Study Notes</label>
    <input 
        type="file" 
        name="Notes" 
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
                        onclick="window.location.href='HomePage.jsp'"
                        class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                    >
                        <i class="fas fa-times mr-2"></i>Cancel
                    </button>
                    <input 
    type="submit" 
    value="Upload Notes"
    class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
/>
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

    <!-- Scripts -->
    <script>
        function updateNotesTitle() {
            const subjectCode = document.querySelector('input[name="subjectCode"]').value.trim();
            const topicName = document.querySelector('input[name="topicName"]').value.trim();
            const courseSemester = document.querySelector('input[name="courseSemester"]').value.trim().replace(/\s+/g, '');
            const section = document.querySelector('input[name="section"]').value.trim().toUpperCase();
            
            if (subjectCode && topicName && courseSemester && section) {
                const notesTitle = `${subjectCode}-${topicName}-${courseSemester}-sec${section}`;
                document.querySelector('input[name="notesTitle"]').value = notesTitle;
            }
        }

        // Add event listeners to input fields
        ['subjectCode', 'topicName', 'courseSemester', 'section'].forEach(fieldName => {
            document.querySelector(`input[name="${fieldName}"]`).addEventListener('input', updateNotesTitle);
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
    const notesTitle = document.querySelector('input[name="notesTitle"]').value.trim();
    const subjectCode = document.querySelector('input[name="subjectCode"]').value.trim();
    const topicName = document.querySelector('input[name="topicName"]').value.trim();
    const courseSemester = document.querySelector('input[name="courseSemester"]').value.trim().replace(/\s+/g, '');
    const section = document.querySelector('input[name="section"]').value.trim().toUpperCase();
    
    const expectedFormat = `${subjectCode}-${topicName}-${courseSemester}-sec${section}`;
    
    if (notesTitle !== expectedFormat) {
        e.preventDefault();
        alert(`Please use the following format for notes title: ${expectedFormat}`);
        document.querySelector('input[name="notesTitle"]').value = expectedFormat;
    } else {
        window.location.href = 'HomePage.jsp';
    }
});

    </script>
</body>
</html>