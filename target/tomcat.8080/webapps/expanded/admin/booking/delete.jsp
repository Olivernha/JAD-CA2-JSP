<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.BookingDAO" %>
<%@ page import="java.io.*" %>


<%
    String bookingIdStr = request.getParameter("bookingId");
    if (bookingIdStr != null) {
        int bookingId = Integer.parseInt(bookingIdStr);
        BookingDAO bookingDAO = new BookingDAO();
        boolean isDeleted = bookingDAO.deleteBooking(bookingId);

        // Redirect back to the categories page with a success message
        if (isDeleted) {
            session.setAttribute("statusSuccess", "Booking deleted successfully.");
        } else {
            session.setAttribute("statusError", "Failed to delete booking.");
        }
        response.sendRedirect("index.jsp");  // Redirect to the booking page (index.jsp)
    }
%>
