<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
    <head>
        <title>Student Registration</title>
        <style>
            :root {
                --primary-color: #2563eb;
                --primary-hover: #1d4ed8;
                --background: #f8fafc;
                --card-background: #ffffff;
                --text-color: #1e293b;
                --border-color: #e2e8f0;
            }
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Inter', system-ui, -apple-system, sans-serif;
                text-align: center;
                background-color: var(--background);
                background-image: 
                    radial-gradient(at 40% 20%, hsla(215,98%,61%,0.1) 0px, transparent 50%),
                    radial-gradient(at 80% 0%, hsla(189,100%,56%,0.1) 0px, transparent 50%),
                    radial-gradient(at 0% 50%, hsla(355,100%,93%,0.1) 0px, transparent 50%);
                color: var(--text-color);
                margin: 0;
                padding: 2rem;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .container {
                padding: 2.5rem;
                width: 90%;
                max-width: 800px;
                background: var(--card-background);
                border-radius: 1rem;
                box-shadow: 
                    0 4px 6px -1px rgba(0, 0, 0, 0.1),
                    0 2px 4px -1px rgba(0, 0, 0, 0.06);
                overflow: hidden;
            }
            h1 {
                font-size: 1.875rem;
                font-weight: 700;
                color: var(--text-color);
                margin-bottom: 2rem;
                position: relative;
                display: inline-block;
            }
            h1::after {
                content: '';
                position: absolute;
                bottom: -0.5rem;
                left: 50%;
                transform: translateX(-50%);
                width: 50%;
                height: 3px;
                background: var(--primary-color);
                border-radius: 2px;
            }
            .form-row {
                display: flex;
                flex-wrap: wrap;
                gap: 1.5rem;
                margin-bottom: 1.5rem;
            }
            .form-row div {
                flex: 1 1 calc(50% - 0.75rem);
                min-width: 250px;
            }
            label {
                display: block;
                text-align: left;
                margin-bottom: 0.5rem;
                font-weight: 500;
                font-size: 0.875rem;
                color: var(--text-color);
            }
            input[type="text"],
            input[type="email"],
            input[type="password"],
            input[type="tel"],
            textarea,
            select {
                width: 100%;
                padding: 0.75rem 1rem;
                border: 1px solid var(--border-color);
                border-radius: 0.5rem;
                font-size: 0.875rem;
                transition: all 0.2s ease;
                background-color: #f8fafc;
            }
            input:focus,
            textarea:focus,
            select:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            }
            textarea {
                height: 100px;
                resize: vertical;
            }
            input[type="submit"] {
                width: 100%;
                padding: 0.875rem;
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 0.5rem;
                font-size: 1rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
                margin-top: 1rem;
            }
            input[type="submit"]:hover {
                background-color: var(--primary-hover);
                transform: translateY(-1px);
            }
            input[type="submit"]:active {
                transform: translateY(0);
            }
            .error-message {
                color: #dc2626;
                background-color: #fee2e2;
                padding: 0.75rem;
                border-radius: 0.5rem;
                margin-bottom: 1.5rem;
                text-align: left;
                font-size: 0.875rem;
            }
            @media (max-width: 640px) {
                .container {
                    padding: 1.5rem;
                }
                .form-row div {
                    flex: 1 1 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="RoleBasedPage.jsp" style="position: absolute; top: 1rem; left: 1rem; color: #3b82f6; font-weight: 500; text-decoration: none; font-size: 1rem; display: flex; align-items: center;">
    <span style="margin-right: 0.25rem;">&#8592;</span> Back
</a>

            <h1>Student Registration</h1>
            
            <% if(request.getParameter("error") != null) { %>
                <div class="error-message">
                    <%= request.getParameter("message") %>
                </div>
            <% } %>
            
            <form action="StudentRegistrationHandler.jsp" method="POST">
                <div class="form-row">
                    <div>
                        <label for="studentId">Student ID:</label>
                        <input type="text" id="studentId" name="studentId" required>
                    </div>
                    <div>
                        <label for="userId">User ID:</label>
                        <input type="text" id="userId" name="userId" required>
                    </div>
                </div>
                <div class="form-row">
                    <div>
                        <label for="studentName">Name:</label>
                        <input type="text" id="studentName" name="studentName" required>
                    </div>
                    <div>
                        <label for="studentPhoneNo">Phone Number:</label>
                        <input type="tel" id="studentPhoneNo" name="studentPhoneNo" required>
                    </div>
                </div>
                <div class="form-row">
                    <div>
                        <label for="studentEmail">Email:</label>
                        <input type="email" id="studentEmail" name="studentEmail" required>
                    </div>
                    <div>
                        <label for="studentPassword">Password:</label>
                        <input type="password" id="studentPassword" name="studentPassword" required>
                    </div>
                </div>
                <div class="form-row">
                    <div>
                        <label for="classSectionId">Class Section ID:</label>
                        <input type="text" id="classSectionId" name="classSectionId" required>
                    </div>
                    <div>
                        <label for="semester">Semester:</label>
                        <input type="text" id="semester" name="semester" required>
                    </div>
                </div>
                <div class="form-row">
                    <div>
                        <label for="studentAddress">Address:</label>
                        <textarea id="studentAddress" name="studentAddress" required></textarea>
                    </div>
                </div>
                <input type="submit" value="Register">
            </form>
        </div>
    </body>
</html>