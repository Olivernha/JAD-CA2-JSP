<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.CategoryDAO, com.ca1.models.Category" %>
<%@ page import="java.util.List" %>

<%! 
    // Helper method to get category by ID
    public Category getCategoryById(int categoryId) {
        CategoryDAO categoryDAO = new CategoryDAO();
        return categoryDAO.getCategoryById(categoryId);
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
            <h1>Edit Category</h1>
        </div>

        <% 
            // Get category ID from the request
            String categoryIdParam = request.getParameter("id");
            if (categoryIdParam != null) {
                int categoryId = Integer.parseInt(categoryIdParam);
                Category category = getCategoryById(categoryId);
                
                if (category != null) {
        %>

        <form method="POST" action="update.jsp" enctype="multipart/form-data">
            <input type="hidden" name="categoryId" value="<%= category.getId() %>" />
            <div class="form-group">
                <label for="categoryName">Name</label>
                <input type="text" id="categoryName" name="categoryName" value="<%= category.getName() %>" required />
            </div>
            <div class="form-group">
                <label for="categoryDescription">Description</label>
                <textarea id="categoryDescription" name="categoryDescription" required><%= category.getDescription() %></textarea>
            </div>
		               <div class="form-group">
                        <label for="categoryImage">Image</label>
                        <input type="file" id="categoryImage" name="categoryImage" accept="image/*" required>
                    </div>
            <button type="submit" class="btn btn-primary">Update Category</button>
        </form>

        <% 
                } else {
        %>
            <p>Category not found!</p>
        <% 
                }
            }
        %>
    </div>
</body>
</html>
