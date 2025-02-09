<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.BookingDAO, com.ca1.models.Booking" %>
<%@ page import="java.util.List" %>

<%! 
    // Helper method to get category by ID
    public Booking getBookingById(int bookingId) {
		BookingDAO bookingDAO = new BookingDAO();
     	return bookingDAO.getBookingById(bookingId);
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Category</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../index.css">
    <link rel="stylesheet" href="./index.css">
</head>
<body>
    <%@ include file="../sidebar.jsp" %>

    <div class="main-content">
        <div class="header">
            <h1>Approve Decision</h1>
        </div>

        <% 
            // Get category ID from the request
            String bookingIdParam = request.getParameter("bookingId");
            if (bookingIdParam != null) {
                int bookingId = Integer.parseInt(bookingIdParam);
                Booking booking = getBookingById(bookingId);
                System.out.print(booking.getSpecialRequest());
                if (booking != null) {
                	String currentStatus = booking.getStatus().toLowerCase();
        %>

        <form method="POST" action="update.jsp">
            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />
       
           <div class="form-group">
                <label for="bookingStatus">Status</label>
                <select id="bookingStatus" name="status" required class="form-control">
                    <option value="Pending" <%= currentStatus.equals("pending") ? "selected" : "" %>>Pending</option>
                    <option value="Confirmed" <%= currentStatus.equals("confirmed") ? "selected" : "" %>>Confirmed</option>
                    <option value="Cancelled" <%= currentStatus.equals("cancelled") ? "selected" : "" %>>Cancelled</option>
                <option value="Completed" <%= currentStatus.equals("completed") ? "selected" : "" %>>Completed</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">Update Status</button>
        </form>
        <% 
      	} else {
        %>
            <p>Booking not found!</p>
        <% 
                }
            }
        %>
    </div>
</body>
</html>
