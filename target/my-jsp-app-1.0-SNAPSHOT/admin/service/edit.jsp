<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Service</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
     <link rel="stylesheet" href="<%= request.getContextPath() %>/admin/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/admin/service/index.css">
</head>
<body>
    <%@ include file="../sidebar.jsp" %>
    <div class="main-content">
        <div class="header">
            <h1>Edit Service</h1>
        </div>

        <form id="editServiceForm" method="POST" action="<%= request.getContextPath() %>/admin/updateService"" enctype="multipart/form-data">
            <input type="hidden" name="serviceId" value="${service.id}"> <!-- Use JSTL to access service object -->
            <div class="form-group">
                <label for="categoryId">Category</label>
                <select id="categoryId" name="categoryId" required>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.id}" ${category.id == service.categoryId ? 'selected' : ''}>${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="serviceName">Service Name</label>
                <input type="text" id="serviceName" name="serviceName" value="${service.serviceName}" required>
            </div>
              <div class="form-group">
                <label for="discount">Discount</label>
                <input type="text" id="discount" name="discount" value="${service.discount}" required>
            </div>
            <div class="form-group">
                <label for="serviceDescription">Description</label>
                <textarea id="serviceDescription" name="serviceDescription" required>${service.description}</textarea>
            </div>
            <div class="form-group switch-group">
                <label for="serviceAvailable" style="display:inline;">Service Available</label>
                <label class="switch">
                    <input type="checkbox" id="serviceAvailable" name="serviceAvailable" value="true" ${service.available ? "checked" : ""}>
                    <span class="slider round"></span>
                </label>
            </div>
            <div class="form-group">
                <label for="servicePrice">Price</label>
                <input type="number" id="servicePrice" name="servicePrice" step="0.01" value="${service.price}" required>
            </div>
            <div class="form-group">
                <label for="serviceImage">Image</label>
                <input type="file" id="serviceImage" name="serviceImage" accept="image/*">
                <c:if test="${not empty service.imagePath}">
                    <img src="<%= request.getContextPath() %>/${service.imagePath}" alt="${service.serviceName}" style="width:100px; height:100px; margin-top:10px;">
                </c:if>
            </div>
            <button type="submit" class="btn btn-primary">Update Service</button>
        </form>
    </div>
</body>
</html>
