<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.ca1.dao.CategoryDAO, com.ca1.dao.ServiceDAO, com.ca1.models.Category, com.ca1.models.Service, java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Category</title>
 <link rel="shortcut icon" href="../img/favicon.svg" type="image/svg+xml">
<link rel="stylesheet" href="../css/home.css">
<link rel="stylesheet" href="../css/viewCategory.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>
    <section class="category" id="Category">
        <div class="container">
            <div class="row">
                <div class="section-title text-center">
                    <h1>Categories</h1>
                </div>
            </div>
            <div class="row">
                <div class="filter-buttons">
                    <ul id="filter-btns">
                        <li class="active" data-target="all">ALL</li>
                        <% 
                            CategoryDAO categoryDAO = new CategoryDAO();
                            List<Category> categories = categoryDAO.getCategories();
                            for (Category category : categories) {
                        %>
                        <li data-target="<%= category.getName().replaceAll(" ", "") %>"><%= category.getName() %></li>
                        <% 
                            }
                        %>
                    </ul>
                </div>
            </div>
            <div class="row">
                <div class="categories">
                   <% ServiceDAO serviceDAO = new ServiceDAO();
                       List<Service> services = serviceDAO.getAllServices(); %>
                    <ul class="has-scrollbar">
                    <% for (Service service : services) { 
                    	int service_id = service.getId();%>
                        <li class="scrollbar-item item" data-id="<%= categoryDAO.getCategoryNameByServiceId(service_id).replaceAll(" ","") %>">
                            <div class="shop-card">
                                <div class="card-banner img-holder" style="--width: 540; --height: 720;">
                                    <img src="../<%= service.getImagePath() %>" width="540" height="720" loading="lazy" alt="<%= service.getServiceName() %>" class="img-cover">
                                    <% if(service.getDiscount() > 0) { %>
                                        <span class="badge" aria-label="<%= service.getDiscount() %> off">-<%= service.getDiscount() %>%</span>
                                    <% } %>
                                    <div class="card-actions">
                                        <a href="viewServiceDetails.jsp?serviceId=<%= service.getId() %>" class="action-btn" aria-label="view details">
                                            <ion-icon name="eye-outline"></ion-icon>
                                        </a>
                                    </div>
                                </div>
                                <div class="card-content">
                                    <div class="price">
                                        <% if(service.getDiscount() > 0) { %>
                                            <del class="del">$<%= service.getPrice() %></del>
                                        <% } %>
                                        <span class="span">$<%= service.getPrice() * (1 - (service.getDiscount() / 100.0)) %></span>
                                    </div>
                                    <h3><a href="#" class="card-title"><%= service.getServiceName() %></a></h3>
                                </div>
                            </div>
                        </li>
                    <% } %>
                    </ul>
                </div>
            </div>
        </div>
    </section>
    <script src="../js/viewCategory.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
  	<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
</body>
</html>
