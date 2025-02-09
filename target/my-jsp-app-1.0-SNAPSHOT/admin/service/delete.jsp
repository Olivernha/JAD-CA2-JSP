<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.ServiceDAO" %>
<%@ page import="java.io.*" %>


<%
    String serviceIdStr = request.getParameter("serviceId");
    if (serviceIdStr != null) {
        int serviceId = Integer.parseInt(serviceIdStr);
        ServiceDAO serviceDAO = new ServiceDAO();
        boolean isDeleted = serviceDAO.deleteService(serviceId);

        // Redirect back to the categories page with a success message
        if (isDeleted) {
            session.setAttribute("serviceSuccess", "Service deleted successfully.");
        } else {
            session.setAttribute("serviceError", "Failed to delete service.");
        }
        response.sendRedirect("index.jsp");  // Redirect to the categories page (index.jsp)
    }
%>
