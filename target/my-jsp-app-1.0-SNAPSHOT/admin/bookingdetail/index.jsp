<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.BookingDetailDAO, com.ca1.models.BookingDetail" %>
<%@ page import="com.ca1.dao.ServiceDAO, com.ca1.models.Service" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Details</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../index.css">
    <link rel="stylesheet" href="./index.css">
    <style>
        .booking-detail-card {
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 20px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .booking-detail-card h3 {
            margin: 0 0 10px;
        }
        .booking-detail-card p {
            margin: 5px 0;
            line-height: 1.5;
        }
        .total-price {
            font-weight: bold;
            font-size: 1.2em;
            margin-top: 20px;
            text-align: right;
        }
    </style>
</head>
<body>
    <%@ include file="../sidebar.jsp" %>
    <div class="main-content">
        <div class="header">
            <h1>Booking Details</h1>
        </div>
        <%
            String bookingIdParam = request.getParameter("bookingId");
            if (bookingIdParam != null) {
                try {
                    int bookingId = Integer.parseInt(bookingIdParam);
                    BookingDetailDAO bookingDetailDAO = new BookingDetailDAO();
                    ServiceDAO serviceDAO = new ServiceDAO();
                    List<BookingDetail> bookingDetails = bookingDetailDAO.getBookingDetailsByBookingId(bookingId);

                    double totalPrice = 0.0;

                    for (BookingDetail detail : bookingDetails) {
                        Service service = serviceDAO.getServiceById(detail.getServiceId());
                        double itemTotal = detail.getQuantity() * service.getPrice();  // Use service price instead of price in BookingDetail
                        totalPrice += itemTotal;
        %>
        <div class="booking-detail-card">
            <h3>Service Name: <%= service.getServiceName() %></h3>
            <p><strong>Service ID:</strong> <%= detail.getServiceId() %></p>
            <p><strong>Quantity:</strong> <%= detail.getQuantity() %></p>
            <p><strong>Unit Price:</strong> $<%= service.getPrice() %></p>  <!-- Use price from service -->
            <p><strong>Total for this service:</strong> $<%= itemTotal %></p>
        </div>
        <% 
                    } 
        %>
        <div class="total-price">
            <p>Total Price for Booking: $<%= totalPrice %></p>
        </div>
        <% 
                } catch (NumberFormatException e) { 
        %>
            <p>Invalid booking ID.</p>
        <% 
                }
            } else { 
        %>
            <p>No booking ID provided.</p>
        <% } %>
    </div>
</body>
</html>
