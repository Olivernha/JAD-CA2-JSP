<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Access Denied</title>
    <style>
        :root {
            --gradient-start: #667eea;
            --gradient-end: #764ba2;
            --white-translucent: rgba(255, 255, 255, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
		a{
		text-decoration:none;
		}
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            font-family: 'Arial', sans-serif;
            perspective: 1000px;
            overflow: hidden;
        }

        .error-container {
            text-align: center;
            background: var(--white-translucent);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            transform-style: preserve-3d;
            animation: float 4s ease-in-out infinite;
        }

        .lock-icon {
            font-size: 100px;
            margin-bottom: 20px;
            display: inline-block;
            transform: translateZ(50px);
            animation: pulse 2s infinite;
        }

        .unauthorized-title {
            font-size: 4rem;
            color: white;
            margin-bottom: 20px;
            position: relative;
            text-shadow: 0 0 10px rgba(255,255,255,0.5);
        }

        .unauthorized-title::before, 
        .unauthorized-title::after {
            content: attr(data-text);
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .unauthorized-title::before {
            left: 2px;
            text-shadow: -2px 0 red;
            clip-path: polygon(0 0, 100% 0, 100% 35%, 0 35%);
            animation: glitch-anim 3s infinite linear alternate-reverse;
        }

        .unauthorized-title::after {
            left: -2px;
            text-shadow: -2px 0 blue;
            clip-path: polygon(0 65%, 100% 65%, 100% 100%, 0 100%);
            animation: glitch-anim2 3s infinite linear alternate-reverse;
        }

        .error-message {
            color: white;
            font-size: 1.25rem;
            margin-bottom: 30px;
            opacity: 0.75;
        }

        .access-button {
            background-color: #6b46c1;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 50px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .access-button:hover {
            background-color: #805ad5;
            transform: scale(1.05);
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotateX(10deg) rotateY(-10deg); }
            50% { transform: translateY(-20px) rotateX(-10deg) rotateY(10deg); }
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1) translateZ(50px); }
            50% { transform: scale(1.1) translateZ(70px); }
        }

        @keyframes glitch-anim {
            0% { clip-path: polygon(0 0, 100% 0, 100% 35%, 0 35%); }
            100% { clip-path: polygon(0 0, 100% 0, 100% 0, 0 0); }
        }

        @keyframes glitch-anim2 {
            0% { clip-path: polygon(0 65%, 100% 65%, 100% 100%, 0 100%); }
            100% { clip-path: polygon(0 100%, 100% 100%, 100% 100%, 0 100%); }
        }
    </style>
</head>
<body>

    <div class="error-container">
        <div class="lock-icon">&#128274;</div>
        <h1 class="unauthorized-title" data-text="UNAUTHORIZED">UNAUTHORIZED</h1>
        <p class="error-message">You do not have permission to access this resource.</p>
        
      
   		<%
    // Get session attributes
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");
    Integer userID = (Integer) session.getAttribute("userID");
	
    // Check if the user is logged in and has a customer role
    boolean isLoggedIn = (username != null && userRole != null && userID != null);
    boolean isCustomer = isLoggedIn && userRole.equals("Customer");
%>

<%-- Button for public users or logged-in customers --%>
<%
    if (!isLoggedIn) {  // If user is not logged in, show the login button
%>
        <button onclick="window.location.href='./user/loginRegister.jsp'" class="access-button">Go to login page</button>
<%
    } else if (isCustomer) {  // If user is logged in and is a customer, show the back button
%>
        <button onclick="window.history.back()" class="access-button">Go Back</button>
<%
    }
%>
   		
    </div>
</body>
</html>