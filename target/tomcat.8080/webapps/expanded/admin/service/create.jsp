<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List , java.io.File, java.io.IOException, jakarta.servlet.http.* ,java.nio.file.Paths" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Service</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../index.css">
    <link rel="stylesheet" href="./index.css">
</head>
<body>
    <%@ include file="../sidebar.jsp" %>

    <div class="main-content">
        <div class="header">
            <h1>Add New Service</h1>
        </div>
        <div id="serviceContainer" class="service-container">
            <div class="service-content">
                <h2 id="modalTitle">Add Service</h2>
                <!-- Use enctype for file uploads -->
                <form id="serviceForm" method="POST" action="<%= request.getContextPath() %>/admin/createService" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="categoryId">Category</label>
                        <select id="categoryId" name="categoryId" required>
                            
                        	<c:forEach var="category" items="${categories}">
                            <option value="${category.id}" ${param.categoryId == category.id ? 'selected' : ''}>
                                ${category.name}
                            </option>
                        </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="serviceName">Service Name</label>
                        <input type="text" id="serviceName" name="serviceName" required>
                    </div>
                    <div class="form-group">
                        <label for="serviceDescription">Description</label>
                        <textarea id="serviceDescription" rows="3" name="serviceDescription" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="servicePrice">Price</label>
                        <input type="number" id="servicePrice" name="servicePrice" step="0.01" required>
                    </div>
                      <div class="form-group">
                        <label for="discount">Discount</label>
                        <input type="number" id="discount" name="discount" step="0.01" required>
                    </div>
                    <div class="form-group">
					    <label for="available">Service Availability</label>
					    <div class="toggle-container">
					        <label class="switch">
					            <input type="checkbox" id="available" name="available" checked>
					            <span class="slider round"></span>
					        </label>
					        <span class="toggle-label">Available</span>
					    </div>
					</div>
                    <div class="form-group">
                        <label for="serviceImage">Image</label>
                        <input type="file" id="serviceImage" name="serviceImage" accept="image/*" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>

            </div>
        </div>
    </div>
    <script>
    	
    </script>
</body>
</html>
