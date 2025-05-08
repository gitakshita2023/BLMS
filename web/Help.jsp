<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #00a2d1;
            --secondary-color: #008bb1;
            --background-color: #f0f4f8;
            --text-color: #333;
            --white: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
        }

        .help-container {
            display: flex;
            min-height: 100vh;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .help-card {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            padding: 40px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .help-card:hover {
            transform: translateY(-10px);
        }

        .help-icon {
            font-size: 4rem;
            color: var(--primary-color);
            margin-bottom: 20px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .help-title {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 20px;
            font-weight: 600;
        }

        .help-description {
            font-size: 1.1rem;
            margin-bottom: 30px;
            color: #666;
        }

        .contact-info {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .contact-method {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 10px 0;
            gap: 10px;
        }

        .contact-method i {
            color: var(--primary-color);
            font-size: 1.2rem;
        }

        .help-button {
            display: inline-block;
            background-color: var(--primary-color);
            color: var(--white);
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .help-button:hover {
            background-color: var(--secondary-color);
            transform: translateY(-3px);
        }

        @media (max-width: 600px) {
            .help-card {
                padding: 20px;
                margin: 20px 0;
            }

            .help-title {
                font-size: 2rem;
            }

            .help-description {
                font-size: 1rem;
            }
            
        }
        .back-button {
    position: fixed;
    top: 20px;
    left: 20px;
    padding: 10px 20px;
    background: #3b82f6; /* Changed to blue */
    color: white; /* Changed text color to white for better contrast */
    border: none;
    border-radius: 50px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    transition: all 0.3s ease;
    z-index: 1000;
}

    </style>
</head>
<body>
    <button class="back-button" onclick="history.back()" style="background: #3b82f6;">
    <i class="fas fa-arrow-left"></i> Back
</button>

    <div class="help-container">
        <div class="help-card">
            <i class="fas fa-life-ring help-icon"></i>
            <h1 class="help-title">Help Center</h1>
            
            <div class="contact-info">
                <div class="contact-method">
                    <i class="fas fa-envelope"></i>
                    <span>support@akshita.com</span>
                </div>
                <div class="contact-method">
                    <i class="fas fa-phone"></i>
                    <span>1800-123-456</span>
                </div>
            </div>

            <p class="help-description">
                Need assistance? Our support team is ready to help you resolve any issues 
                you may encounter. Reach out to us via email or phone.
            </p>

            <a href="mailto:support@akshita.com" class="help-button">
                Contact Support
            </a>
        </div>
    </div>
</body>
</html>