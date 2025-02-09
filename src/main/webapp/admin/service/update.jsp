<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ca1.dao.ServiceDAO, com.ca1.models.Service" %>
<%@ page import="java.io.File, java.nio.file.Paths, jakarta.servlet.http.Part" %>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String serviceName = request.getParameter("serviceName");
            String serviceDescription = request.getParameter("serviceDescription");
            double servicePrice = Double.parseDouble(request.getParameter("servicePrice"));
            boolean serviceAvailable = request.getParameter("serviceAvailable") != null;
            ServiceDAO serviceDAO = new ServiceDAO();
            Service service = serviceDAO.getServiceById(serviceId);

            if (service == null) {
                session.setAttribute("serviceError", "Service not found.");
                response.sendRedirect("./index.jsp");
                return;
            }

            // Handle image upload
            String uploadPath = application.getRealPath("") + "img/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String newImagePath = service.getImagePath(); // Keep the old image by default
            Part filePart = request.getPart("serviceImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String filePath = uploadPath + fileName;
                filePart.write(filePath);

                // Update the image path
                newImagePath = "img/" + fileName;
            }

            // Update the service details
            service.setCategoryId(categoryId);
            service.setServiceName(serviceName);
            service.setDescription(serviceDescription);
            service.setPrice(servicePrice);
            service.setImagePath(newImagePath);
            service.setAvailable(serviceAvailable);

            boolean isUpdated = serviceDAO.updateService(service);

            if (isUpdated) {
                session.setAttribute("serviceSuccess", "Service updated successfully!");
                response.sendRedirect("./index.jsp");
            } else {
                session.setAttribute("serviceError", "Failed to update service.");
                response.sendRedirect("./edit.jsp?id=" + serviceId);
            }
        } catch (Exception e) {
            session.setAttribute("serviceError", "An error occurred while updating the service: " + e.getMessage());
            response.sendRedirect("./index.jsp");
        }
    }
%>
