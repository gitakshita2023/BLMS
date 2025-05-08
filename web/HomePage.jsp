<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    String userId = (String) session.getAttribute("userid");
    if (role == null || userId == null) {
        response.sendRedirect("LoginPage.jsp?error=sessionExpired");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard | Learning Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
    body {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }
    .full-screen-container {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }
    .content-area {
        flex: 1;
    }
    .dashboard-card {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .dashboard-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }
    .gradient-bg {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    
</style>

</head>
<body class="bg-gray-50">
    <div class="full-screen-container">
    <div style="position: absolute; top: 20px; left: 20px; z-index: 100;">
    <a href="Start.jsp" class="link" style="display: inline-flex; align-items: center; font-weight: bold; font-size: 1.1em;  color: white; padding: 8px 15px; transition: all 0.3s ease;">
        <span style="font-size: 1.3em; margin-right: 8px;">←</span> Back
    </a>
    </div>
    <!-- Navigation Bar -->
    <nav class="gradient-bg text-white shadow-lg">
        <div class="container mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center">
                <i class="fas fa-graduation-cap text-2xl mr-3"></i>
                <span class="text-xl font-bold">Learning Portal</span>
            </div>
            <div class="flex items-center">
                <span class="mr-4">Welcome, <%= role %></span>
                <span class="mr-4 text-sm opacity-75">ID: <%= userId %></span>
                <a href="Logout.jsp" class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="content-area container mx-auto px-6 py-8" style="min-height: calc(100vh - 200px);">
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-2"><%= role %> Dashboard</h1>
            <div class="h-1 w-20 bg-purple-500 rounded"></div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% if ("Student".equalsIgnoreCase(role)) { %>
                <!-- Student Cards -->
                <a href="SD_ViewAssignments" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl">
                    <div class="text-purple-500 mb-4">
                        <i class="fas fa-tasks text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">View Assignments</h3>
                    <p class="text-gray-600">Check your pending and completed assignments</p>
                </a>
                <a href="SD_DownloadNotes.jsp" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl">
                    <div class="text-blue-500 mb-4">
                        <i class="fas fa-book-reader text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Download Notes</h3>
                    <p class="text-gray-600">Access study materials and resources</p>
                </a>
                <a href="SD_SubmitAssignments.jsp" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl">
                    <div class="text-green-500 mb-4">
                        <i class="fas fa-upload text-4xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Submit Assignments</h3>
                    <p class="text-gray-600">Upload your completed assignments</p>
                </a>
            <% } else if ("Admin".equalsIgnoreCase(role)) { %>
                <!-- Student Cards -->
                <a href="AD_Register.jsp" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition duration-300">
            <div class="text-purple-500 mb-4">
                <svg class="w-12 h-12" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="20" cy="14" r="8" stroke="currentColor" stroke-width="2"/>
                    <path d="M20 26c-8 0-16 4-16 12h32c0-8-8-12-16-12z" stroke="currentColor" stroke-width="2"/>
                    <rect x="4" y="6" width="32" height="32" rx="4" stroke="currentColor" stroke-width="2"/>
                    <path d="M32 16h4m-4 8h4m-4 8h4" stroke="currentColor" stroke-width="2"/>
                </svg>
            </div>
            <h3 class="text-xl font-semibold mb-2">Approve Faculty Registration</h3>
            <p class="text-gray-600">Add, edit or remove faculty</p>
        </a>

                <a href="AD_Reports.jsp" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition duration-300">
            <div class="text-blue-500 mb-4">
                <svg class="w-12 h-12" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <rect x="8" y="4" width="24" height="32" rx="2" stroke="currentColor" stroke-width="2"/>
                    <path d="M14 12h12M14 18h12M14 24h8" stroke="currentColor" stroke-width="2"/>
                    <path d="M12 8h16M12 28h16" stroke="currentColor" stroke-width="2"/>
                    <path d="M16 32h8" stroke="currentColor" stroke-width="2"/>
                </svg>
            </div>
            <h3 class="text-xl font-semibold mb-2">Reports & Analytics</h3>
            <p class="text-gray-600">Visualize users using pie chart</p>
        </a>
                <a href="AD_maintenance.jsp" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition duration-300">
            <div class="text-green-500 mb-4">
                <svg class="w-12 h-12" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="20" cy="20" r="12" stroke="currentColor" stroke-width="2"/>
                    <path d="M20 8v4m0 16v4M32 20h4M4 20h4m4.4-11.6l2.8 2.8m11.6 11.6l2.8 2.8M8.4 31.6l2.8-2.8m11.6-11.6l2.8-2.8" stroke="currentColor" stroke-width="2"/>
                    <circle cx="20" cy="20" r="4" stroke="currentColor" stroke-width="2"/>
                </svg>
            </div>
            <h3 class="text-xl font-semibold mb-2">User Maintenance</h3>
            <p class="text-gray-600">Suspend or deactivate accounts</p>
        </a>
            <% }
            else if ("Teacher".equalsIgnoreCase(role)) { %>
            
                <a href="TD_UploadNotes.jsp" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl">
    <div class="text-blue-500 mb-4">
        <svg class="w-12 h-12" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9 16h6v-6h4l-7-7-7 7h4v6zm-4 2h14v2H5v-2z"/>
        </svg>
    </div>
    <h3 class="text-xl font-semibold mb-2">Upload Study Notes</h3>
    <p class="text-gray-600">Share learning materials with students</p>
</a>

<a href="TD_ViewUploads" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl">
    <div class="text-green-500 mb-4">
        <svg class="w-12 h-12" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
        </svg>
    </div>
    <h3 class="text-xl font-semibold mb-2">View Uploaded files</h3>
    <p class="text-gray-600">Collection of all previously uploaded files</p>
</a>

<a href="TD_ViewSubmissions" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl">
    <div class="text-blue-500 mb-4">
        <svg class="w-12 h-12" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V5h14v14zM7 10h2v7H7v-7zm4-3h2v10h-2V7zm4 6h2v4h-2v-4z"/>
        </svg>
    </div>
    <h3 class="text-xl font-semibold mb-2">View Assignment Submission</h3>
    <p class="text-gray-600">Review submitted assignments</p>
</a>
                
<a href="TD_CreateAssignment.jsp" class="dashboard-card bg-white rounded-lg shadow-md p-6 hover:shadow-xl">
    <div class="text-purple-500 mb-4">
        <svg class="w-12 h-12" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
        </svg>
    </div>
    <h3 class="text-xl font-semibold mb-2">Create Assignments</h3>
    <p class="text-gray-600">Create new tasks for students</p>
</a>
            <% } %>
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
                    <a href="Help.jsp" class="hover:text-gray-300"><i class="fas fa-question-circle"></i> Help</a>
                    <a href="Contact.jsp" class="hover:text-gray-300"><i class="fas fa-envelope"></i> Contact</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script>
        // Modal functions
        function showModal(modalId) {
            document.getElementById(modalId).classList.remove('hidden');
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.add('hidden');
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modals = document.querySelectorAll('.fixed.inset-0');
            modals.forEach(modal => {
                if (event.target === modal) {
                    modal.classList.add('hidden');
                }
            });
        }

        // Form submission handling with validation
        document.getElementById('assignmentForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Basic form validation
            const form = this;
            const inputs = form.querySelectorAll('input[required]');
            let isValid = true;

            inputs.forEach(input => {
                if (!input.value.trim()) {
                    isValid = false;
                    input.classList.add('border-red-500');
                } else {
                    input.classList.remove('border-red-500');
                }
            });

            if (isValid) {
                // You would typically send this to your server
                alert('Assignment submitted successfully!');
                closeModal('createAssignmentModal');
                form.reset();
            } else {
                alert('Please fill in all required fields.');
            }
        });

        document.getElementById('notesForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Basic form validation
            const form = this;
            const inputs = form.querySelectorAll('input[required]');
            let isValid = true;

            inputs.forEach(input => {
                if (!input.value.trim()) {
                    isValid = false;
                    input.classList.add('border-red-500');
                } else {
                    input.classList.remove('border-red-500');
                }
            });

            if (isValid) {
                // You would typically send this to your server
                alert('Notes uploaded successfully!');
                closeModal('uploadNotesModal');
                form.reset();
            } else {
                alert('Please fill in all required fields.');
            }
        });

        // File deletion confirmation
        function confirmDelete(fileId) {
            if (confirm('Are you sure you want to delete this file?')) {
                // Add your delete logic here
                alert('File deleted successfully!');
            }
        }

        // Add escape key listener to close modals
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                const modals = document.querySelectorAll('.fixed.inset-0');
                modals.forEach(modal => {
                    if (!modal.classList.contains('hidden')) {
                        modal.classList.add('hidden');
                    }
                });
            }
        });
    </script>
    </div>
</body>
</html>