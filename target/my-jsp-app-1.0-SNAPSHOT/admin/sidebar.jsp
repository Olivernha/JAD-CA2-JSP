<%
// Get the current URI path
String currentPath = request.getRequestURI();
// Assuming you have a user object or session attribute for user details
String username = (String) session.getAttribute("username");
String userRole = (String) session.getAttribute("role");
int userID = (int) session.getAttribute("userID");
%>
<div class="sidebar">
    <div class="sidebar-logo">Zen.Home Cleaning Admin</div>
    <ul class="sidebar-menu">
        <li>
            <a href="<%= request.getContextPath() %>/admin/dashboard/index.jsp" class="<%= currentPath.contains("/dashboard.jsp") ? "active" : "" %>">
                <i class="fas fa-home"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/customer" class="<%= currentPath.contains("/customer/") ? "active" : "" %>">
                <i class="fas fa-users"></i> Customers
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/booking/index.jsp" class="<%= currentPath.contains("/booking/") ? "active" : "" %>">
                <i class="fas fa-book"></i> Bookings
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/category/index.jsp" class="<%= currentPath.contains("/category/") ? "active" : "" %>">
                <i class="fas fa-tags"></i> Service Categories
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/service" class="<%= currentPath.contains("/service/") ? "active" : "" %>">
                <i class="fas fa-list"></i> Services
            </a>
        </li>
        <!-- Add Sales Management Tab -->
        <li>
            <a href="<%= request.getContextPath() %>/admin/sale/index.jsp" class="<%= currentPath.contains("/sale/") ? "active" : "" %>">
                <i class="fas fa-chart-bar"></i> Sales Management
            </a>
        </li>
    </ul>
    <div class="sidebar-bottom">
        <div class="sidebar-profile">
            <div class="profile-info">
                <strong><%= username != null ? username : "Admin User" %></strong>
                <span class="text-muted"><%= userRole != null ? userRole : "Administrator" %></span>
            </div>
            <div class="profile-actions">
                <a href="../../user/profile/" class="btn btn-profile">
                    <i class="fas fa-user"></i>
                </a>
                <a href="../logout.jsp" class="btn btn-logout">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
        </div>
    </div>
</div>