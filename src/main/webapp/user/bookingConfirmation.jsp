<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation</title>
    <link rel="stylesheet" href="../css/home.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f9;
            font-family: 'Urbanist', sans-serif;
            text-align: center;
        }
        .confirmation-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            max-width: 500px;
        }
        .confirmation-title {
            font-size: 1.8rem;
            font-weight: bold;
            color: #2d3436;
            margin-bottom: 15px;
        }
        .confirmation-message {
            font-size: 1.2rem;
            color: #6c5ce7;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .redirect-message {
            font-size: 1rem;
            color: #444;
            margin-top: 10px;
        }
        .redirect-timer {
            font-weight: bold;
            color: #d63031;
        }
        .home-btn {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 15px;
            font-size: 1rem;
            font-weight: bold;
            color: white;
            background: #6c5ce7;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .home-btn:hover {
            background: #5849c4;
        }
    </style>
</head>
<body>

<div class="confirmation-container">
    <h1 class="confirmation-title"> Booking Confirmed! </h1>
    <p class="confirmation-message">Your booking has been successfully created.</p>
    
    <p class="redirect-message">Redirecting to the homepage in <span id="countdown" class="redirect-timer">5</span> seconds...</p>
    <button class="home-btn" onclick="redirectHome()">Go to Homepage</button>
</div>

<script>
    let countdown = 5;
    function updateTimer() {
        if (countdown > 0) {
            document.getElementById("countdown").innerText = countdown;
            countdown--;
            setTimeout(updateTimer, 1000);
        } else {
            window.location.href = "http://localhost:8080/CA2/user/home.jsp";
        }
    }
    function redirectHome() {
        window.location.href = "http://localhost:8080/CA2/user/home.jsp";
    }
    updateTimer();
</script>

</body>
</html>
