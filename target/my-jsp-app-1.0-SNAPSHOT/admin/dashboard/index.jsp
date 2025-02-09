<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.DashboardDAO" %>

<%
    DashboardDAO dashboardDAO = new DashboardDAO();
    int totalCustomers = dashboardDAO.getTotalCustomers();
    int confirmBookings = dashboardDAO.getActiveBookings();
    double averageRating = dashboardDAO.getAverageRating();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cleaning Service Admin Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./index.css">
    <link rel="stylesheet" href="../index.css">
</head>
<body>
    <%@ include file="../sidebar.jsp" %>
    <div class="main-content">
        <div class="header">
            <h1>Dashboard Management</h1>
        </div>
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <i class="fas fa-users card-icon"></i>
                <div class="card-value"><%= totalCustomers %></div>
                <p>Total Customers</p>
            </div>
            <div class="dashboard-card">
                <i class="fas fa-calendar-check card-icon"></i>
                <div class="card-value"><%= confirmBookings %></div>
                <p>Confirmed Bookings</p>
            </div>

            <div class="dashboard-card">
                <i class="fas fa-star card-icon"></i>
                <div class="card-value"><%= String.format("%.1f", averageRating) %></div>
                <p>Average Rating</p>
            </div>
        </div>
    </div>
</body>
</html>
