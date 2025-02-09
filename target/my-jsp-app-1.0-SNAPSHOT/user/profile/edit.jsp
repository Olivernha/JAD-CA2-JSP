<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.CustomerDAO, com.ca1.models.Customer" %>
<%@ page import="java.io.File, java.nio.file.Paths, jakarta.servlet.http.Part" %>
<%!
    // Helper method to update customer
    public boolean updateCustomer(int customerId, String name, String email, String phone, String address, String password, String avatar) {
        CustomerDAO customerDAO = new CustomerDAO();
        Customer existingCustomer = customerDAO.getCustomerById(customerId);
        
        if (existingCustomer != null) {
            // Update only allowed fields
            existingCustomer.setName(name);
            existingCustomer.setEmail(email);
            existingCustomer.setPhone(phone);
            existingCustomer.setAddress(address);
            existingCustomer.setAvatar(avatar);  // Added missing avatar update
            
            // Call DAO update method
            return customerDAO.updateCustomer(existingCustomer, password);
        }
        return false;
    }
%>

<%
    try {
        // Get form data
        String customerIdParam = request.getParameter("customerId");
        if (customerIdParam == null || customerIdParam.trim().isEmpty()) {
            session.setAttribute("customerError", "Customer ID is required.");
            response.sendRedirect("./index.jsp");
            return;
        }

        int customerId = Integer.parseInt(customerIdParam);
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        // Validate required fields
        if (name == null || email == null || phone == null || address == null || 
            name.trim().isEmpty() || email.trim().isEmpty() || phone.trim().isEmpty() || address.trim().isEmpty()) {
            session.setAttribute("customerError", "All fields are required.");
            response.sendRedirect("./index.jsp");
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        Customer existingCustomer = customerDAO.getCustomerById(customerId);
        
        if (existingCustomer == null) {
            session.setAttribute("customerError", "Customer not found.");
            response.sendRedirect("./index.jsp");
            return;
        }

        // Handle file upload
        String uploadPath = application.getRealPath("") + "user/profile/img/";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String newImagePath = existingCustomer.getAvatar(); // Keep the old image by default
        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String filePath = uploadPath + fileName;
            filePart.write(filePath);
            newImagePath = "img/" + fileName;
        }

        // Update the customer
        boolean updateSuccess = updateCustomer(customerId, name, email, phone, address, password, newImagePath);

        if (updateSuccess) {
            session.setAttribute("customerSuccess", "Customer updated successfully!");
        } else {
            session.setAttribute("customerError", "Error updating customer.");
        }
        
    } catch (NumberFormatException e) {
        session.setAttribute("customerError", "Invalid customer ID format.");
    } catch (Exception e) {
        session.setAttribute("customerError", "An error occurred: " + e.getMessage());
    } finally {
        response.sendRedirect("./index.jsp");
    }
%>