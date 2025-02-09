<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.ca1.dao.FeedBackDAO" %>
<%@ page import="com.ca1.models.Feedback" %>
<%
    // Get the submitted form data
    String rating = request.getParameter("rating");
    String comment = request.getParameter("comment");
    String serviceId = request.getParameter("serviceId");
    String bookingId = request.getParameter("bookingId");

    // Get customer ID from the session
    Integer customerId = Integer.parseInt(request.getParameter("userId"));

    // Validate the inputs
    if (rating == null || rating.isEmpty()) {
        // If rating is missing, show error
     	session.setAttribute("feedbackError", "Rating is missing");
    	response.sendRedirect("./history.jsp"); 
    } 
    else {

        try {
            // Create Feedback object
            FeedBackDAO feedbackDAO = new FeedBackDAO();
            Feedback feedback = new Feedback(customerId, Integer.parseInt(serviceId), Integer.parseInt(bookingId), Integer.parseInt(rating), comment);

            // Save feedback in the database
            boolean isCreated = feedbackDAO.addFeedback(feedback);

            if (isCreated) {
                session.setAttribute("feedbackSuccess", "Feeback given successfully!");
                response.sendRedirect("./history.jsp?userId="+ customerId);  // Redirect to the service list page after success
            } else{
            	session.setAttribute("feedbackError", "Error occurred when feedback!");
            	response.sendRedirect("./history.jsp"); 
        	}
        }
        catch (Exception e) {
            // Handle any errors that might occur
        	session.setAttribute("feedbackError", e.getMessage());
        	response.sendRedirect("./history.jsp"); 
       	 }
        }
   
    %>