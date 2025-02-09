<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ca1.dao.CustomerDAO, com.ca1.models.Customer" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cleaning Service Admin Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
     <link rel="stylesheet" href="<%= request.getContextPath() %>/admin/index.css">
	<link rel="stylesheet" href="<%= request.getContextPath() %>/admin/customer/index.css">
<body>
    <%@ include file="../sidebar.jsp" %>
    <div class="main-content"> 
  
        <div class="header">
            <h1>Customer Management</h1>
            <button class="btn btn-primary" id="addCategoryBtn" onclick="window.location.href='<%= request.getContextPath() %>/admin/customer/create.jsp'">
                <i class="fas fa-plus"></i> Add New User
            </button>
        </div>
      <div class="filter-section">
    <form action="<%= request.getContextPath() %>/getUsersByPostalCode" method="GET" class="area-filter-form">
        <div class="filter-group">
            <label for="areaCode">Filter by Area Code:</label>
            <input type="text" id="areaCode" name="areaCode" 
                   placeholder="Enter area code"
                   value="<%= request.getParameter("areaCode") != null ? request.getParameter("areaCode") : "" %>">
            <button type="submit" class="btn btn-secondary">
                <i class="fas fa-filter"></i> Filter
            </button>
            <% if (request.getParameter("areaCode") != null && !request.getParameter("areaCode").isEmpty()) { %>
                <a href="<%= request.getContextPath() %>/admin/customer" class="btn btn-clear">
                    <i class="fas fa-times"></i> Clear Filter
                </a>
            <% } %>
        </div>
    </form>
</div>
        <!-- Success or Error Messages -->
        <%
            String successMessage = (String) request.getAttribute("customerSuccess");
            String errorMessage = (String) request.getAttribute("customerError");
            if (successMessage != null) {
        %>
            <div class="notification success">
                <%= successMessage %>
                <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
            </div>
        <%
                request.removeAttribute("customerSuccess");
            } else if (errorMessage != null) {
        %>
            <div class="notification error">
                <%= errorMessage %>
                <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
            </div>
        <%
                request.removeAttribute("customerError");
            }
        %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Address</th>
                    <th>Postal_code</th>
                    <th>Joined Date</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <%
            ArrayList<Customer> customers = (ArrayList<Customer>)request.getAttribute("users");
            %>

            <tbody>
                <% 
                    if (customers != null && !customers.isEmpty()) {
                        for (Customer customer : customers) { 
                %>
                    <tr>
                        <td><%= customer.getId() %></td>
                        <td><%= customer.getName() %></td>
                        <td><%= customer.getEmail() %></td>
                        <td><%= customer.getPhone() %></td>
                        <td>
                            <span class="role <%= "customer".equalsIgnoreCase(customer.getRole()) ? "role-customer" : "role-admin" %>">
                                <%= customer.getRole() %>
                            </span>
                        </td>
                        <td><%= customer.getAddress() %></td>
                        <td><%= customer.getPostalCode() %></td>
                        <td><%= customer.getJoinedDate() != null ? customer.getJoinedDate() : "N/A" %></td>
                        <td class="actions">
                            <button class="icon-button btn-edit" onclick="window.location.href='<%= request.getContextPath() %>/editUser?id=<%= customer.getId() %>'">
                                <i class="fas fa-edit"></i>
                            </button>
                            <% if (!"admin".equalsIgnoreCase(customer.getRole())) { %>
                                <button class="icon-button btn-delete" onclick="showDeleteModal(<%= customer.getId() %>)">
                                    <i class="fas fa-trash"></i>
                                </button>
                            <% } %>
                        </td>
                    </tr>
                <% 
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="8">No customers found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h2>Are you sure you want to delete this customer?</h2>
            <button id="confirmDelete" onclick="deleteCustomer()">Yes, Delete</button>
            <button onclick="closeModal()">Cancel</button>
        </div>
    </div>
    
    <script>
        // Interactive dashboard functionality can be added here
        function showDeleteModal(customerId) {
            document.getElementById('deleteModal').style.display = "block";
            document.getElementById('deleteModal').classList.add('fade-in');
            document.getElementById('confirmDelete').setAttribute('data-customer-id', customerId);
        }

        function closeModal() {
            var modal = document.getElementById('deleteModal');
            modal.classList.add('fade-out');
            setTimeout(function () {
                modal.style.display = "none";
                modal.classList.remove('fade-out');
            }, 300);
        }

        function deleteCustomer() {
            var customerId = document.getElementById('confirmDelete').getAttribute('data-customer-id');
            window.location.href = '<%= request.getContextPath() %>/admin/deleteUser?id=' + customerId;
           
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
    </script>
   
</body>

</html>
