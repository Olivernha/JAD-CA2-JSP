<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.CategoryDAO , com.ca1.models.Category" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Categories</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../index.css">
    <link rel="stylesheet" href="./index.css">


</head>
<body>
    <%@ include file="../sidebar.jsp" %>
    <div class="main-content">
        <div class="header">
            <h1>Service Categories</h1>
            <button class="btn btn-primary" id="addCategoryBtn" onclick="window.location.href='./create.jsp'">
                <i class="fas fa-plus"></i> Add New Category
            </button>
        </div>
 <% 
            // Check if the form submission was successful and display the success message
            String successMessage = (String) session.getAttribute("categorySuccess");
            if (successMessage != null) {
        %>
            <div class="notification success">
                <%= successMessage %>
                <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
            </div>
        <%
                session.removeAttribute("categorySuccess");
            }
        %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="categoryTable">
                <%
                    CategoryDAO categoryDAO = new CategoryDAO();
                    List<Category> categories = categoryDAO.getCategories();
                    for (Category category : categories) {
                %>
                    <tr>
                        <td><%= category.getId() %></td>
                        <td><%= category.getName() %></td>
                        <td><%= category.getDescription() %></td>
                         <td>
                            <% if (category.getImagePath() != null && !category.getImagePath().isEmpty()) { %>
                                <img src="../../<%= category.getImagePath() %>" alt="<%= category.getName() %>" style="width:50px; height:50px; border-radius:5px;">
                            <% } else { %>
                                No Image
                            <% } %>
                        </td>
                        <td>
                            <button class="icon-button btn-edit" onclick="window.location.href='./edit.jsp?id=<%= category.getId() %>'">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="icon-button btn-delete" onclick="showDeleteModal(<%= category.getId() %>)">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h2>Are you sure you want to delete this category?</h2>
            <button id="confirmDelete" onclick="deleteCategory()">Yes, Delete</button>
            <button onclick="closeModal()">Cancel</button>
        </div>
    </div>

    <script>
        // Show the delete confirmation modal
        function showDeleteModal(categoryId) {
            document.getElementById('deleteModal').style.display = "block";
            document.getElementById('deleteModal').classList.add('fade-in');
            document.getElementById('confirmDelete').setAttribute('data-category-id', categoryId);
        }

        // Close the modal
        function closeModal() {
            var modal = document.getElementById('deleteModal');
            modal.classList.add('fade-out');
            setTimeout(function() {
                modal.style.display = "none";
                modal.classList.remove('fade-out');
            }, 300); // Match the fade-out transition time
        }

        // Handle delete action
        function deleteCategory() {
            var categoryId = document.getElementById('confirmDelete').getAttribute('data-category-id');
            window.location.href = 'delete.jsp?categoryId=' + categoryId;
        }

        // Close the modal if clicked outside of the modal content
        window.onclick = function(event) {
            var modal = document.getElementById('deleteModal');
            if (event.target === modal) {
                closeModal();
            }
        }
      
        setTimeout(function() {
            var notification = document.querySelector('.notification');
            if (notification) {
                // Add fade-out class for opacity transition
                notification.classList.add('fade-out');

                // After the fade-out transition ends, completely remove the notification
                notification.addEventListener('transitionend', function() {
                    notification.style.display = 'none';  // Remove from layout
                });
            }
        }, 5000); // Fade out after 5 seconds

     
    </script>
</body>
</html>
