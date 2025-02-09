<%@ page import="com.ca1.models.Customer" %>
<%@ page import="com.ca1.dao.CustomerDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");
    Integer userID = (Integer) session.getAttribute("userID");

    if (username == null || userRole == null || userID == null) {
        response.sendRedirect("../../unauthorized.jsp");
        return;
    }

    CustomerDAO customerDAO = new CustomerDAO();
    Customer customer = customerDAO.getCustomerById(userID);

    int totalBookings = customerDAO.getTotalBookings(userID);
    int totalServices = customerDAO.getTotalServices(userID);
    int totalReviews = customerDAO.getTotalFeedback(userID);
    double totalSpent = customerDAO.getTotalSpent(userID);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Profile</title>
    <link rel="stylesheet" href="./index.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
<div class="dashboard">
    <!-- Success or Error Messages -->
    <%
        String successMessage = request.getParameter("success");
        String errorMessage = request.getParameter("error");

        if (successMessage != null) {
    %>
    <div class="notification success">
        <%= successMessage %>
        <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
    </div>
    <% } else if (errorMessage != null) { %>
    <div class="notification error">
        <%= errorMessage %>
        <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
    </div>
    <% } %>

    <div class="header">
        <button class="back-btn" onclick="window.history.back();">Back</button>
        <button class="edit-btn" onclick="openModal()">Edit Profile</button>
        <button class="view-history-btn" onclick="window.location.href='history.jsp?userId=<%= customer.getId()%>'">
            View Order History
        </button>
        <button class="logout-btn" onclick="window.location.href='logout.jsp'">Log out</button>
        <div class="profile">
            <div class="avatar">
                <img src="<%= customer.getAvatar() %>" alt="Profile Picture" id="profile-image">
                <div class="avatar-overlay" onclick="document.getElementById('avatar-input').click()"></div>
            </div>
            <div class="profile-info">
                <h1 id="user-name"><%= customer.getName() %></h1>
                <p id="member-since">Member since <%=customer.getJoinedDate() %></p>
            </div>
        </div>
    </div>

    <div class="stats">
        <div class="stat-card"><div class="stat-value"><%= totalBookings %></div> <div class="stat-label">Total Bookings</div></div>
        <div class="stat-card"><div class="stat-value"><%= totalServices %></div> <div class="stat-label">Different Services Used</div></div>
        <div class="stat-card"><div class="stat-value"><%= totalReviews %></div> <div class="stat-label">Average Rating</div></div>
        <div class="stat-card"><div class="stat-value">$<%= totalSpent %></div> <div class="stat-label">Total Spent</div></div>
    </div>

    <div class="sections">
        <div class="section">
            <h2>Recent Services</h2>
            <div id="services-list">Loading recent services...</div>
        </div>
        <div class="section">
            <h2>Upcoming Bookings</h2>
            <div id="bookings-list">Loading upcoming bookings...</div>
        </div>
    </div>
</div>

<!-- Edit Modal -->
  <div class="modal-overlay" id="edit-modal">
    <div class="modal">
      <h2>Edit Profile</h2>
      <form id="edit-form" method="POST" action="../../UpdateCustomerProfile">
       <input type="hidden" name="customerId" value="<%= customer.getId() %>" />
        <div class="form-group">
          <label for="name">Full Name</label>
          <input type="text" id="name" name="name" value="<%= customer.getName() %>" required>
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" value="<%= customer.getEmail() %>" required>
        </div>
        <div class="form-group">
          <label for="phone">Phone Number</label>
          <input type="tel" id="phone" name="phone" value="<%= customer.getPhone() %>" required>
        </div>
         <input type="file" id="avatar-input" name="avatar" hidden accept="image/*" onchange="handleAvatarChange(event)">
        <div class="form-group">
          <label for="address">Address</label>
            <textarea id="address" name="address" required><%= customer.getAddress() %></textarea>
        </div>
         <div class="form-group">
          <label for="newPassword">New Password (leave blank to keep current password):</label>
          <input type="text" id="password" name="password">
        </div>
        <div class="modal-buttons">
          <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
          <button type="submit" class="btn btn-primary">Save Changes</button>
        </div>
      </form>
    </div>
  </div>

<!-- JavaScript -->
<script>
document.addEventListener("DOMContentLoaded", function() {
    const userId = "<%= userID %>"; // Ensure userID is set
    if (!userId || userId === "null") {
        console.error("User ID is null, API requests skipped.");
        return;
    }

    fetch(`<%=request.getContextPath()%>/GetRecentServices`)
        .then(response => response.json())
        .then(data => {
            const servicesList = document.getElementById("services-list");
            servicesList.innerHTML = "";
            if (data.length > 0) {
                data.forEach(service => {
                    const serviceDiv = document.createElement("div");
                    serviceDiv.classList.add("service-item");

                    const name = document.createElement("strong");
                    name.textContent = service.serviceName;

                    const category = document.createElement("div");
                    category.style.color = "#64748b";
                    category.textContent = service.categoryName;

                    const feedback = document.createElement("div");
                    feedback.classList.add("feedback");

                    const stars = document.createElement("span");
                    stars.classList.add("stars");
                    stars.textContent = "★".repeat(service.rating); // Add star rating

                    feedback.appendChild(stars);
                    serviceDiv.appendChild(name);
                    serviceDiv.appendChild(category);
                    serviceDiv.appendChild(feedback);

                    servicesList.appendChild(serviceDiv);
                });
            } else {
                servicesList.textContent = "No recent services booked.";
            }
        }).catch(error => console.error("Error fetching recent services:", error));

    fetch(`<%=request.getContextPath()%>/GetUpcomingBookings`)
        .then(response => response.json())
        .then(data => {
            const bookingsList = document.getElementById("bookings-list");
            bookingsList.innerHTML = "";

            if (data.length > 0) {
                data.forEach(booking => {
                    const bookingDiv = document.createElement("div");
                    bookingDiv.classList.add("booking-item");

                    const serviceName = document.createElement("strong");
                    serviceName.textContent = booking.services.map(s => s.serviceName).join(", ");

                    const date = document.createElement("div");
                    date.style.color = "#64748b";
                    date.textContent = new Date(booking.bookingDate).toLocaleDateString();

                    const cancelButton = document.createElement("button");
                    cancelButton.textContent = "Cancel";
                    cancelButton.classList.add("cancel-btn");
          
                    cancelButton.style.backgroundColor = "#d9534f";
                    cancelButton.style.color = "white";
                    cancelButton.style.border = "none";
                    cancelButton.style.padding = "8px 12px";
                    cancelButton.style.marginTop = "8px";
                    cancelButton.style.cursor = "pointer";
                    cancelButton.style.borderRadius = "5px";
                    cancelButton.style.fontSize = "14px";

                    cancelButton.onmouseover = function() {
                        cancelButton.style.backgroundColor = "#c9302c";
                    };
                    cancelButton.onmouseout = function() {
                        cancelButton.style.backgroundColor = "#d9534f";
                    };
                    cancelButton.onclick = () => cancelBooking(booking.bookingId);

                    bookingDiv.appendChild(serviceName);
                    bookingDiv.appendChild(date);
                    bookingDiv.appendChild(cancelButton);
                    bookingsList.appendChild(bookingDiv);
                });
            } else {
                bookingsList.textContent = "No upcoming bookings available.";
            }
        }).catch(error => console.error("Error fetching upcoming bookings:", error));
});

function cancelBooking(bookingId) {
	console.log(bookingId);
    Swal.fire({
        title: "Are you sure?",
        text: "You will not be able to recover this booking!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Yes, cancel it!"
    }).then((result) => {
        if (result.isConfirmed) {
            fetch("<%=request.getContextPath()%>/CancelBooking", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({bookingId : bookingId})
            })
            .then(response => {
                if (response.ok) {
                    Swal.fire("Cancelled!", "Your booking has been cancelled.", "success").then(() => {
                        location.reload();
                    });
                } else {
                    Swal.fire("Error!", "Failed to cancel the booking.", "error");
                }
            })
            .catch(error => console.error("Error cancelling booking:", error));
        }
    });
}

function handleAvatarChange(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function(e) {
        document.getElementById('profile-image').src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

function openModal() { document.getElementById('edit-modal').classList.add('active'); }
function closeModal() { document.getElementById('edit-modal').classList.remove('active'); }
</script>

</body>
</html>

