<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us | Learning Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex flex-col h-screen">
    <!-- Navigation - Reduced padding -->
    <nav class="bg-purple-600 text-white shadow-md">
        <div class="container mx-auto px-4 py-2 flex justify-between items-center">
            <div class="flex items-center">
                <i class="fas fa-graduation-cap text-xl mr-2"></i>
                <span class="text-lg font-bold">Learning Portal</span>
            </div>
            <div>
                <a href="HomePage.jsp" class="hover:text-purple-200 transition duration-300">
                    <i class="fas fa-home mr-1"></i>Dashboard
                </a>
            </div>
        </div>
    </nav>

    <!-- Contact Section - Main content with flex-grow to take available space -->
    <div class="flex-grow container mx-auto px-4 py-3">
        <div class="max-w-4xl mx-auto bg-white rounded-lg shadow-md overflow-hidden md:flex">
            <!-- Contact Information - Reduced padding -->
            <div class="md:w-1/2 bg-purple-600 text-white p-4">
                <h2 class="text-xl font-bold mb-3">Contact Information</h2>
                <div class="space-y-2">
                    <div class="flex items-center">
                        <i class="fas fa-map-marker-alt text-lg mr-2"></i>
                        <span class="text-sm">123 Learning Street, Education City</span>
                    </div>
                    <div class="flex items-center">
                        <i class="fas fa-phone text-lg mr-2"></i>
                        <span class="text-sm">+1 (555) 123-4567</span>
                    </div>
                    <div class="flex items-center">
                        <i class="fas fa-envelope text-lg mr-2"></i>
                        <span class="text-sm">support@learningportal.com</span>
                    </div>
                    <div class="flex items-center">
                        <i class="fas fa-clock text-lg mr-2"></i>
                        <span class="text-sm">Mon-Fri: 9 AM - 5 PM</span>
                    </div>
                </div>
            </div>

            <!-- Contact Form - Reduced padding and spacing -->
            <div class="md:w-1/2 p-4">
                <h2 class="text-xl font-bold mb-3 text-gray-800">Send us a Message</h2>
                <form id="contactForm" action="SubmitContact" method="post" class="space-y-2">
                    <div>
                        <label for="name" class="block text-gray-700 text-sm mb-1">Full Name</label>
                        <input type="text" id="name" name="name" required 
                               class="w-full px-3 py-1 text-sm border rounded-lg focus:outline-none focus:ring-1 focus:ring-purple-500">
                    </div>
                    <div>
                        <label for="email" class="block text-gray-700 text-sm mb-1">Email Address</label>
                        <input type="email" id="email" name="email" required 
                               class="w-full px-3 py-1 text-sm border rounded-lg focus:outline-none focus:ring-1 focus:ring-purple-500">
                    </div>
                    <div>
                        <label for="subject" class="block text-gray-700 text-sm mb-1">Subject</label>
                        <select id="subject" name="subject" required 
                                class="w-full px-3 py-1 text-sm border rounded-lg focus:outline-none focus:ring-1 focus:ring-purple-500">
                            <option value="">Select a Subject</option>
                            <option value="support">Technical Support</option>
                            <option value="feedback">General Feedback</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    <div>
                        <label for="message" class="block text-gray-700 text-sm mb-1">Your Message</label>
                        <textarea id="message" name="message" rows="2" required 
                                  class="w-full px-3 py-1 text-sm border rounded-lg focus:outline-none focus:ring-1 focus:ring-purple-500"></textarea>
                    </div>
                    <button type="submit" 
                            class="w-full bg-purple-600 text-white py-1 rounded-lg hover:bg-purple-700 transition duration-300 text-sm">
                        Send Message
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer - Reduced padding -->
    <footer class="bg-gray-800 text-white py-2 text-sm">
        <div class="container mx-auto px-4 text-center">
            <p>&copy; 2025 Learning Portal. All rights reserved.</p>
        </div>
    </footer>

    <script>
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Basic form validation
            const form = this;
            const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
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
                alert('Message sent successfully! We will get back to you soon.');
                form.reset();
            } else {
                alert('Please fill in all required fields.');
            }
        });
    </script>
</body>
</html>
