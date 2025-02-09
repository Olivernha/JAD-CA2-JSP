<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.BookingDAO, com.ca1.models.Booking" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bookings</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../index.css">
    <link rel="stylesheet" href="./index.css">
</head>
<body>
    <%@ include file="../sidebar.jsp" %>
    <div class="main-content">
        <div class="header">
            <h1>Bookings</h1>
        </div>
       <%
            String successMessage = (String) session.getAttribute("statusSuccess");
            String errorMessage = (String) session.getAttribute("statusError");
            if (successMessage != null) {
        %>
            <div class="notification success">
                <%= successMessage %>
                <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
            </div>
        <%
                session.removeAttribute("statusSuccess");
            } else if (errorMessage != null) {
        %>
            <div class="notification error">
                <%= errorMessage %>
                <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
            </div>
        <%
                session.removeAttribute("statusSuccess");
            }
        %>
        <table>
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Customer ID</th>
                    <th>Booking Date</th>
                    <th>Status</th>
                    <th>Special Request</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    BookingDAO bookingDAO = new BookingDAO();
                    List<Booking> bookings = bookingDAO.getAllBookings();

                    for (Booking booking : bookings) {
                %>
                <tr>
                    <td><%= booking.getBookingId() %></td>
                    <td><%= booking.getCustomerId() %></td>
                    <td><%= booking.getBookingDate() %></td>
                    <td><%= booking.getStatus() %></td>
                    <td><%= booking.getSpecialRequest() %></td>
                    <td>
                        <button class="btn btn-primary" onclick="window.location.href='../bookingdetail/index.jsp?bookingId=<%= booking.getBookingId() %>'">
                            View Details
                        </button>
                        <button class="btn btn-edit" onclick="window.location.href='edit.jsp?bookingId=<%= booking.getBookingId() %>'">
                            Update
                        </button>
                         <button class="btn btn-delete" onclick="showDeleteModal(<%= booking.getBookingId() %>)">
                                 Delete
                         </button>
 
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
        <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h2>Are you sure you want to delete this category?</h2>
            <button id="confirmDelete" onclick="deleteBooking()">Yes, Delete</button>
            <button onclick="closeModal()">Cancel</button>
        </div>
    </div>
    <script>
    // Show the delete confirmation modal
    function showDeleteModal(bookingId) {
        document.getElementById('deleteModal').style.display = "block";
        document.getElementById('deleteModal').classList.add('fade-in');
        document.getElementById('confirmDelete').setAttribute('data-booking-id', bookingId);
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
    function deleteBooking() {
        var bookingId = document.getElementById('confirmDelete').getAttribute('data-booking-id');
        window.location.href = 'delete.jsp?bookingId=' + bookingId;
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