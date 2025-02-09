<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Clear all session data
    if (session != null) {
        session.invalidate();
    }

    // Prevent browser caching of this page
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Redirect to login page
    response.sendRedirect("../user/loginRegister.jsp");
%>