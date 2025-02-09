<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.CategoryDAO" %>
<%@ page import="java.io.*" %>


<%
    String categoryIdStr = request.getParameter("categoryId");
    if (categoryIdStr != null) {
        int categoryId = Integer.parseInt(categoryIdStr);
        CategoryDAO categoryDAO = new CategoryDAO();
        boolean isDeleted = categoryDAO.deleteCategory(categoryId);

        // Redirect back to the categories page with a success message
        if (isDeleted) {
            session.setAttribute("categorySuccess", "Category deleted successfully.");
        } else {
            session.setAttribute("categoryError", "Failed to delete category.");
        }
        response.sendRedirect("index.jsp");  // Redirect to the categories page (index.jsp)
    }
%>
