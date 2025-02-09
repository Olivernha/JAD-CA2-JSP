<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.CustomerDAO, com.ca1.models.Customer" %>

<%! 
    // Helper method to update customer
    public boolean updateCustomer(int customerId, String name, String email, String phone, String address) {
        CustomerDAO customerDAO = new CustomerDAO();
        Customer existingCustomer = customerDAO.getCustomerById(customerId);
        
        if (existingCustomer != null) {
            // Update only allowed fields
            existingCustomer.setName(name);
            existingCustomer.setEmail(email);
            existingCustomer.setPhone(phone);
            existingCustomer.setAddress(address);
            
            return customerDAO.updateCustomer(existingCustomer,"");
        }
        return false;
    }
%>

<%
    // Get form data
    String customerIdParam = request.getParameter("customerId");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    
    if (customerIdParam != null && name != null && email != null && phone != null && address != null) {
        try {
            int customerId = Integer.parseInt(customerIdParam);
            
            // Update the customer
            boolean updateSuccess = updateCustomer(customerId, name, email, phone, address);
            
            if (updateSuccess) {
            	session.setAttribute("userName",name);
            	session.setAttribute("userID",customerId);

                session.setAttribute("customerSuccess", "Customer updated successfully!");
                response.sendRedirect("./index.jsp");
            } else {
                session.setAttribute("customerError", "Error updating customer.");
                response.sendRedirect("./index.jsp");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("customerError", "Invalid customer ID.");
            response.sendRedirect("./index.jsp");
        }
    } else {
        session.setAttribute("customerError", "Invalid data.");
        response.sendRedirect("./index.jsp");
    }
%>
