<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.ca1.models.Service" %> <!-- Assuming `Service` is your model class -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Booking Authorization</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
    .swal2-popup {
        font-family: 'Urbanist', sans-serif;
    }
</style>
</head>
<body>
<script>
<%
    Integer loggedIn = (Integer) session.getAttribute("userID");
    String specialRequest = request.getParameter("specialRequest");
    String serviceId = request.getParameter("serviceId");
    String quantity = request.getParameter("quantity");
    String serviceName = request.getParameter("serviceName");
    String servicePrice = request.getParameter("servicePrice");
    String serviceImage = request.getParameter("serviceImage");
    String slotId = request.getParameter("slotId");

    if (loggedIn == null) {
%>
    Swal.fire({
        title: 'Unauthorized!',
        text: 'You must be logged in to proceed.',
        icon: 'error',
        confirmButtonText: 'Login',
        confirmButtonColor: '#3085d6'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = "user/loginRegister.jsp";
        }
    });
<%
    } else {
        // Retrieve or initialize the cart (ArrayList of Service objects) in the session
        ArrayList<Service> cart = (ArrayList<Service>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // Check if the service is already in the cart
        boolean serviceExists = false;
        for (Service existingService : cart) {
            if (existingService.getId() == Integer.parseInt(serviceId)) {
                // If service exists, update its quantity
                existingService.setQuantity(existingService.getQuantity() + Integer.parseInt(quantity));
                serviceExists = true;
                break;
            }
        }

        // If service does not exist, add it to the cart
        if (!serviceExists) {
            Service service = new Service();
            service.setId(Integer.parseInt(serviceId));
            service.setQuantity(Integer.parseInt(quantity));
            service.setServiceName(serviceName);
            service.setPrice(Double.parseDouble(servicePrice));
            service.setImagePath(serviceImage);
            cart.add(service);
        }

        // Update the session attribute
        session.setAttribute("cart", cart);
%>
    Swal.fire({
        title: 'Added to Cart!',
        text: 'Service has been successfully added to your cart.',
        icon: 'success',
        confirmButtonText: 'OK',
        confirmButtonColor: '#3085d6'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = "user/home.jsp";
        }
    });
<%
    }
%>
</script>
</body>
</html>
