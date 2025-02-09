<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/admin/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/admin/service/index.css">
</head>
<body>
    <%@ include file="../sidebar.jsp" %>
    <div class="main-content">
        <!-- Header -->
        <div class="header">
            <h1>Services Management</h1>
            <div class="header-actions">
                <button class="btn btn-secondary" onclick="toggleReports()">
                    <i class="fas fa-chart-bar"></i> View Reports
                </button>
                <button class="btn btn-primary" onclick="window.location.href='<%= request.getContextPath() %>/admin/service/create'">
                    <i class="fas fa-plus"></i> Add New Service
                </button>
           
            </div>
        </div>

        <!-- Search and Filter Section -->
        <div class="search-section">
            <form id="advancedSearchForm" action="<%= request.getContextPath() %>/admin/services" method="GET">
                <div class="search-container">
                    <input type="text" name="keyword" placeholder="Search services..." value="${param.keyword}">
                    <select name="categoryId">
                        <option value="">All Categories</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.id}" ${param.categoryId == category.id ? 'selected' : ''}>
                                ${category.name}
                            </option>
                        </c:forEach>
                    </select>
                    <input type="number" name="minPrice" placeholder="Min Price" value="${param.minPrice}">
                    <input type="number" name="maxPrice" placeholder="Max Price" value="${param.maxPrice}">
                    <button type="submit" class="btn btn-primary">Search</button>
                </div>
            </form>
        </div>

        <!-- Reports Section (Hidden by default) -->
        <div id="reportsSection" class="reports-section" style="display: none;">
            <div class="report-cards">
                <!-- Service Statistics -->
                <div class="report-card">
                    <h3>Service Statistics</h3>
                    <div class="stat-item">
                        <span>Total Services:</span>
                        <strong>${stats.totalServices}</strong>
                    </div>
                    <div class="stat-item">
                        <span>Average Price:</span>
                        <strong>$${stats.averagePrice}</strong>
                    </div>
                    <div class="stat-item">
                        <span>Most Popular Category:</span>
                        <strong>${stats.popularCategory}</strong>
                    </div>
                </div>

                <!-- Price Range Distribution -->
                <div class="report-card">
                    <h3>Price Range Distribution</h3>
                    <div class="price-distribution">
                        <div class="stat-item">
                            <span>Under $50:</span>
                            <strong>${priceRanges.under50}</strong>
                        </div>
                        <div class="stat-item">
                            <span>$50 - $100:</span>
                            <strong>${priceRanges['50to100']}</strong>
                        </div>
                        <div class="stat-item">
                            <span>Over $100:</span>
                            <strong>${priceRanges.over100}</strong>
                        </div>
                    </div>
                </div>

                <!-- Best Rated Services -->
                <div class="report-card">
                    <h3>Best Rated Services</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Service Name</th>
                                <th>Rating</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="service" items="${bestRatedServices}">
                                <tr>
                                    <td>${service.serviceName}</td>
                                    <td>${service.serviceRating}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Lowest Rated Services -->
                <div class="report-card">
                    <h3>Lowest Rated Services</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Service Name</th>
                                <th>Rating</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="service" items="${lowestRatedServices}">
                                <tr>
                                    <td>${service.serviceName}</td>
                                    <td>${service.serviceRating}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- High Demand/Low Availability Services -->
                <div class="report-card">
                    <h3>High Demand/Low Availability Services</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Service Name</th>
                                <th>Price</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="service" items="${highDemandServices}">
                                <tr>
                                    <td>${service.serviceName}</td>
                                    <td>${service.price}</td>
                                    <td>
                                        <span class="status-badge ${service.available ? 'available' : 'unavailable'}">
                                            ${service.available ? 'Available' : 'Unavailable'}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
 
        <!-- Services Table -->
        <table class="styled-table">
            <thead>
                <tr>
                    <th>Service ID / Demand</th>
                    <th>Service Name</th>
                    <th>Category</th>
                    <th>Description</th>
                    <th>Rating</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Image</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="servicesTableBody">
                <c:forEach var="service" items="${services}">
                    <tr>
                        <td>
                            <div class="demand-indicator">
                                <h4>${service.id}&nbsp&nbsp</h4>
                                <!-- Add logic to show demand level -->
                                <i class="fas fa-fire ${service.getServiceRating() >= 4 ? 'high-demand' : ''}"></i>
                            </div>
                        </td>
                        <td>${service.serviceName}</td>
                        <td>${service.categoryName}</td>
                        <td>${service.description}</td>
                        <td>
                            <div class="rating-display ${service.getServiceRating() >= 4 ? 'high' : service.getServiceRating() >= 3 ? 'medium' : 'low'}">
                                <i class="fas fa-star"></i>
                                <span class="rating-number">${service.getServiceRating()}</span>
                            </div>
                        </td>
                        <td>$${service.price}</td>
                        <td>
                            <span class="status-badge ${service.available ? 'available' : 'unavailable'}">
                                ${service.available ? 'Available' : 'Unavailable'}
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty service.imagePath}">
                                    <img src="<%= request.getContextPath() %>/${service.imagePath}" alt="${service.serviceName}" style="width:50px; height:50px; border-radius:5px;">
                                </c:when>
                                <c:otherwise>
                                    No Image
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <button class="icon-button btn-edit" onclick="window.location.href='<%= request.getContextPath() %>/admin/editService?id=${service.id}'">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="icon-button btn-delete" onclick="showDeleteModal(${service.id})">
                                <i class="fas fa-trash"></i>
                            </button>
                           
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h2>Are you sure you want to delete this service?</h2>
            <button id="confirmDelete" onclick="deleteService()">Yes, Delete</button>
            <button onclick="closeModal()">Cancel</button>
        </div>
    </div>

    <!-- Service Details Modal -->
    <div id="serviceDetailsModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeServiceDetails()">&times;</span>
            <h2>Service Details</h2>
            <div id="serviceDetailsContent">
                <!-- Service details will be dynamically loaded here -->
            </div>
        </div>
    </div>

    <script>
    function showDeleteModal(serviceId) {
        document.getElementById('deleteModal').style.display = "block";
        document.getElementById('deleteModal').classList.add('fade-in');

        // Properly set the service ID for deletion
        document.getElementById('confirmDelete').setAttribute('data-service-id', serviceId);
    }

    function closeModal() {
        var modal = document.getElementById('deleteModal');
        modal.classList.add('fade-out');
        setTimeout(function () {
            modal.style.display = "none";
            modal.classList.remove('fade-out');
        }, 300);
    }

    // Delete Service
    function deleteService() {
        const serviceId = document.getElementById('confirmDelete').getAttribute('data-service-id');
        console.log(serviceId);
        window.location.href = '<%= request.getContextPath() %>/admin/deleteService?id=' + serviceId;
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
    }, 5000);
        // Toggle Reports Section
        function toggleReports() {
            const reportsSection = document.getElementById('reportsSection');
            reportsSection.style.display = reportsSection.style.display === 'none' ? 'block' : 'none';
        }

        // Fetch Best Rated Services
        function fetchBestRatedServices() {
            window.location.href = 'service?sortOrder=DESC';
        }

        // Fetch Lowest Rated Services
        function fetchLowestRatedServices() {
            window.location.href = 'service?sortOrder=ASC';
        }

       

        // Close Service Details Modal
        function closeServiceDetails() {
            document.getElementById('serviceDetailsModal').style.display = 'none';
        }

     

      
    </script>
</body>
</html>