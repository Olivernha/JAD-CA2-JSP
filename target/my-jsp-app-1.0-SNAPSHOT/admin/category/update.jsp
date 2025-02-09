<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.CategoryDAO, com.ca1.models.Category" %>
<%@ page import="java.io.File, java.nio.file.Paths, jakarta.servlet.http.Part" %>


<%
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
       
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
		String categoryName = request.getParameter("categoryName");
		String categoryDescription = request.getParameter("categoryDescription");

        CategoryDAO categoryDAO = new CategoryDAO();
        Category category = categoryDAO.getCategoryById(categoryId);

        if (category == null) {
            session.setAttribute("serviceError", "Service not found.");
            response.sendRedirect("./index.jsp");
            return;
        }

        // Handle image upload
        String uploadPath = application.getRealPath("") + "img/";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String newImagePath = category.getImagePath(); // Keep the old image by default
        Part filePart = request.getPart("categoryImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String filePath = uploadPath + fileName;
            filePart.write(filePath);

            // Update the image path
            newImagePath = "img/" + fileName;
        }

        // Update the category details
        category.setName(categoryName);
        category.setDescription(categoryDescription);
        category.setImagePath(newImagePath);
        

        boolean isUpdated = categoryDAO.updateCategory(category);

        if (isUpdated) {
            session.setAttribute("categorySuccess", "Category updated successfully!");
            response.sendRedirect("./index.jsp");
        } else {
            session.setAttribute("categoryError", "Failed to update category.");
            response.sendRedirect("./edit.jsp?id=" + categoryId);
        }
    } catch (Exception e) {
        session.setAttribute("serviceError", "An error occurred while updating the service: " + e.getMessage());
        response.sendRedirect("./index.jsp");
    }
}
%>
 