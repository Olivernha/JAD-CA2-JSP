<%@ page import="com.ca1.models.Service, com.ca1.models.Booking, com.ca1.dao.CustomerDAO, java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking History</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
     <link rel="stylesheet" href="./history.css">
</head>
<style>
	 .notification {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 24px;
    margin: 20px 0;
    border-radius: 8px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 16px;
    width: 100%;
    max-width: 600px;
    margin: 15px auto;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    transition: opacity 0.5s ease-in-out, transform 0.5s ease-in-out;
    background-color: #fff;
}

/* Success notification */
.notification.success {
    background-color: #4CAF50; /* Green */
    color: white;
    border-left: 8px solid #388E3C; /* Darker green left border */
}

/* Error notification */
.notification.error {
    background-color: #f44336; /* Red */
    color: white;
    border-left: 8px solid #d32f2f; /* Darker red left border */
}

/* Info notification */
.notification.info {
    background-color: #2196F3; /* Blue */
    color: white;
    border-left: 8px solid #1976D2; /* Darker blue left border */
}

/* Close button style */
.notification .close-btn {
    background: none;
    border: none;
    color: white;
    font-size: 20px;
    cursor: pointer;
    margin-left: 20px;
    padding: 0;
    font-weight: bold;
    transition: color 0.3s ease-in-out;
}

/* Hover effect for close button */
.notification .close-btn:hover {
    color: #ddd;
}

/* Fade-out effect */
.notification.fade-out {
    opacity: 0;
    transform: translateX(100%);  /* Slide out to the right */
    transition: opacity 0.5s ease-in-out, transform 0.5s ease-in-out;
}

/* Icon and text layout */
.notification .icon {
    margin-right: 15px;
    font-size: 22px;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Optional animation for notification appearance */
@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateX(100%);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

.notification {
    animation: slideIn 0.5s ease-in-out;
}
.back-btn {
  position: absolute;
  top: 2rem;
  right: 11rem;
  background: red;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  z-index: 2;
}

.back-btn:hover {
    background: #d72f2f;
    transform: translateX(-2px);
}
</style>
<body>
<%
          String successMessage = (String) session.getAttribute("feedbackSuccess");
            String errorMessage = (String) session.getAttribute("feedbackError");
            if (successMessage != null) {
        %>
            <div class="notification success">
                <%= successMessage %>
                <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
            </div>
        <%
                session.removeAttribute("feedbackSuccess");
            } else if (errorMessage != null) {
        %>
            <div class="notification error">
                <%= errorMessage %>
                <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
            </div>
        <%
                session.removeAttribute("feedbackSuccess");
            }
        %>
    <div class="booking-history">
    	 <button class="back-btn" onclick="window.history.back();">
	        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
	          <path d="M19 12H5M12 19l-7-7 7-7"></path>
	        </svg>
	        Back
	      </button>
        <h1>Booking History</h1>
        <%
            String userIdParam = request.getParameter("userId");
            
            List<Booking> bookings = null;

            try {
             int userId = Integer.parseInt(userIdParam);
                CustomerDAO customerDAO = new CustomerDAO();
                bookings = customerDAO.getAllBookings(userId);
            } catch (NumberFormatException e) {
                out.println("<p class='error-message'>Error: Invalid or missing userId.</p>");
            }

            if (bookings == null || bookings.isEmpty()) {
        %>
            <div class="empty-state">
                <i class="fas fa-calendar-times"></i>
                <p>No booking history found for this user.</p>
            </div>
        <%
            } else {
                for (Booking booking : bookings) {
        %>
            <div class="booking-card">
                <div class="booking-header">
                    <div>
                        <h3 class="booking-id">
                            <i class="fas fa-bookmark"></i>
                            Booking #<%= booking.getBookingId() %>
                        </h3>
                        <!--  -->
                        <p class="booking-date">
                            <i class="far fa-calendar-alt"></i>
                            <%= booking.getBookingDate() %>
                        </p>
                    </div>
                    <span class="booking-status status-<%= booking.getStatus().toLowerCase() %>">
                        <i class="fas fa-circle"></i>
                        <%= booking.getStatus() %>
                    </span>
                </div>

                <div class="service-list">
                    <%
                        List<Service> services = booking.getServices();
                        if (services == null || services.isEmpty()) {
                    %>
                        <p class="no-services">No services found for this booking.</p>
                    <%
                        } else {
                            for (Service service : services) {
                    %>
                        <div class="service-item">
                            <div class="service-info">
                                <span class="service-name">
                                    <i class="fas fa-concierge-bell"></i>
                                    <%= service.getServiceName() %>
                                </span>
                                <span class="service-price">$<%= service.getPrice() %></span>
                            </div>
                            <% if (booking.getStatus().equalsIgnoreCase("Completed") && !service.isHasFeedback()) { %>
                           
                                <button 
                                    class="feedback-btn"
                                    onclick="openFeedbackModal('<%= service.getId() %>', '<%= service.getServiceName() %>', '<%= booking.getBookingId() %>')"
                                >
                                    <i class="far fa-comment-dots"></i>
                                    Give Feedback
                                </button>
                            <% } else if (service.isHasFeedback()) { %>
                                <div class="feedback-display">
                                    <div class="stars">
                                        <% for (int i = 0; i < service.getRating(); i++) { %>
                                            <i class="fas fa-star"></i>
                                        <% } %>
                                        <% for (int i = service.getRating() ; i < 5; i++) { %>
                                            <i class="far fa-star"></i>
                                        <% } %>
                                    </div>
                                    <p><%= service.getFeedbackComment() %></p>
                                </div>
                            <% } %>
                        </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>

    <!-- Feedback Modal -->
    <div class="modal-overlay" id="feedback-modal">
        <div class="modal">
            <h2><i class="fas fa-star"></i> Leave Feedback</h2>
            <form id="feedback-form" action="submitFeedback.jsp" method="POST">
                <input type="hidden" id="service-id" name="serviceId" >
                <input type="hidden" id="booking-id" name="bookingId" >
                  <input type="hidden" name="rating" id="rating">
             	   <input type="hidden" id="userId" name="userId" value="<%= request.getParameter("userId") %>">
                <p id="service-name" class="service-name"></p>
                
                <div class="star-rating">
                    <% for (int i = 1; i <= 5; i++) { %>
                        <span class="star" data-rating="<%= i %>" onclick="setRating(<%= i %>)">
                            <i class="fas fa-star"></i>
                        </span>
                    <% } %>
                </div>
                
                <textarea 
                    name="comment" 
                    id="feedback-comment" 
                    placeholder="Share your experience..."
                    required
                ></textarea>
                
                <div class="modal-buttons">
                    <button type="button" onclick="closeFeedbackModal()" class="btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-paper-plane"></i> Submit
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="./history.js">
    </script>
</body>
</html>
