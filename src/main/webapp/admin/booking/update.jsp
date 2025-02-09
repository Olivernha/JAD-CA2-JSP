<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.BookingDAO" %>

    <%
    
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
 
        String status = request.getParameter("status");
 
        BookingDAO bookingDAO = new BookingDAO();
        boolean isUpdated = bookingDAO.updateBooking(bookingId, status);

        if (isUpdated) {
                session.setAttribute("statusSuccess", "BookingStatus updated successfully!");
                response.sendRedirect("./index.jsp");
         } else {
                session.setAttribute("statusError", "Error updating BookingStatus.");
                response.sendRedirect("./index.jsp");
         }
    
    %>
   

