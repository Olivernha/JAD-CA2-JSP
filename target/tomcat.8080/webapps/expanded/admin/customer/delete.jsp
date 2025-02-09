<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.CustomerDAO" %>
<%@ page import="java.io.*" %>


<%
    String customerIdStr = request.getParameter("customerId");
    if (customerIdStr != null) {
        int customerId = Integer.parseInt(customerIdStr);
        CustomerDAO customerDAO = new CustomerDAO();
        boolean isDeleted = customerDAO.deleteCustomer(customerId);

        // Redirect back to the categories page with a success message
        if (isDeleted) {
            session.setAttribute("customerSuccess", "Service deleted successfully.");
        } else {
            session.setAttribute("customerError", "Failed to delete service.");
        }
        response.sendRedirect("index.jsp");  // Redirect to the categories page (index.jsp)
    }
%>
