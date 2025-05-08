<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LMS System Configuration</title>
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            margin-bottom: 30px;
        }
        .config-section {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .section-title {
            font-size: 1.2em;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
        }
        .input-field {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 5px;
        }
        .help-text {
            font-size: 0.85em;
            color: #666;
            margin-top: 4px;
        }
        .save-btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
        }
        .save-btn:hover {
            background-color: #45a049;
        }
        .success-message {
            background-color: #e7f7ed;
            color: #1d6f42;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }
        .error-message {
            background-color: #fbe9e7;
            color: #c62828;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>System Configuration</h1>
        </div>

        <div id="statusMessage" class="success-message"></div>
        <div id="errorMessage" class="error-message"></div>

        <form id="configForm" onsubmit="return saveConfiguration(event)">
            <!-- File Upload Configuration -->
            <div class="config-section">
                <h2 class="section-title">File Upload Settings</h2>
               
                <div class="form-group">
                    <label for="maxFileSize">Maximum File Size (MB)</label>
                    <input type="number"
                           id="maxFileSize"
                           name="maxFileSize"
                           class="input-field"
                           value="${config.maxFileSize}"
                           min="1"
                           max="100"
                           required>
                    <div class="help-text">Maximum allowed file size for uploads (1-100 MB)</div>
                </div>

                <div class="form-group">
                    <label for="allowedFileTypes">Allowed File Types</label>
                    <input type="text"
                           id="allowedFileTypes"
                           name="allowedFileTypes"
                           class="input-field"
                           value="${config.allowedFileTypes}"
                           placeholder="pdf,doc,docx,ppt,pptx"
                           required>
                    <div class="help-text">Comma-separated list of allowed file extensions</div>
                </div>
            </div>

            <!-- Assignment Configuration -->
            <div class="config-section">
                <h2 class="section-title">Assignment Settings</h2>
               
                <div class="form-group">
                    <label for="defaultDeadlineDays">Default Assignment Duration (Days)</label>
                    <input type="number"
                           id="defaultDeadlineDays"
                           name="defaultDeadlineDays"
                           class="input-field"
                           value="${config.defaultDeadlineDays}"
                           min="1"
                           max="30"
                           required>
                    <div class="help-text">Default number of days students have to complete assignments</div>
                </div>

                <div class="form-group">
                    <label for="lateSubmissionDays">Late Submission Window (Days)</label>
                    <input type="number"
                           id="lateSubmissionDays"
                           name="lateSubmissionDays"
                           class="input-field"
                           value="${config.lateSubmissionDays}"
                           min="0"
                           max="7"
                           required>
                    <div class="help-text">Number of days allowed for late submissions (0-7 days)</div>
                </div>
            </div>

            <button type="submit" class="save-btn">Save Changes</button>
        </form>
    </div>

    <script>
        function saveConfiguration(event) {
            event.preventDefault();
           
            // Get form data
            const formData = {
                maxFileSize: document.getElementById('maxFileSize').value,
                allowedFileTypes: document.getElementById('allowedFileTypes').value,
                defaultDeadlineDays: document.getElementById('defaultDeadlineDays').value,
                lateSubmissionDays: document.getElementById('lateSubmissionDays').value
            };

            // Validate form data
            if (!validateConfig(formData)) {
                return false;
            }

            // Show success message (in real implementation, this would happen after successful API call)
            showMessage('Configuration saved successfully!', 'success');

            return false; // Prevent form submission
        }

        function validateConfig(data) {
            // Validate file size
            if (data.maxFileSize < 1 || data.maxFileSize > 100) {
                showMessage('File size must be between 1 and 100 MB', 'error');
                return false;
            }

            // Validate file types
            if (!data.allowedFileTypes.match(/^[a-zA-Z0-9,]+$/)) {
                showMessage('Invalid file types format', 'error');
                return false;
            }

            // Validate deadline days
            if (data.defaultDeadlineDays < 1 || data.defaultDeadlineDays > 30) {
                showMessage('Default deadline must be between 1 and 30 days', 'error');
                return false;
            }

            // Validate late submission window
            if (data.lateSubmissionDays < 0 || data.lateSubmissionDays > 7) {
                showMessage('Late submission window must be between 0 and 7 days', 'error');
                return false;
            }

            return true;
        }

        function showMessage(message, type) {
            const successMsg = document.getElementById('statusMessage');
            const errorMsg = document.getElementById('errorMessage');
           
            successMsg.style.display = 'none';
            errorMsg.style.display = 'none';
           
            if (type === 'success') {
                successMsg.textContent = message;
                successMsg.style.display = 'block';
            } else {
                errorMsg.textContent = message;
                errorMsg.style.display = 'block';
            }

            // Hide message after 3 seconds
            setTimeout(() => {
                if (type === 'success') {
                    successMsg.style.display = 'none';
                } else {
                    errorMsg.style.display = 'none';
                }
            }, 3000);
        }
    </script>
</body>
</html>
