<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ca1.dao.ServiceDAO, com.ca1.models.Service" %>
<%@ page import="jakarta.servlet.http.* ,java.io.File, java.nio.file.Paths" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Processing Service</title>
    <link rel="stylesheet" href="../index.css">
</head>
<body>
    <%@ include file="../sidebar.jsp" %>

    <div class="main-content">
        <div class="header">
            <h1>Processing Service Creation</h1>
        </div>

        <%
        try {
            // Retrieve form data
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String serviceName = request.getParameter("serviceName");
            String serviceDescription = request.getParameter("serviceDescription");
            double servicePrice = Double.parseDouble(request.getParameter("servicePrice"));
            
            // Handle file upload
            Part filePart = request.getPart("serviceImage");  // Get the uploaded file
            if (filePart != null) {
                // Path where the file will be uploaded
                String uploadPath = application.getRealPath("") + "uploads/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();  // Create the directory if it doesn't exist

                // Get the file name and write it to the server
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String filePath = uploadPath + fileName;
                filePart.write(filePath);

                // Create a new service instance
                Service newService = new Service(categoryId, serviceName, serviceDescription, servicePrice, "img/" + fileName);

                // Add service to the database
                ServiceDAO serviceDAO = new ServiceDAO();
                boolean isCreated = serviceDAO.addService(newService);
                if (isCreated) {
                    session.setAttribute("serviceSuccess", "Service created successfully!");
                    response.sendRedirect("./index.jsp");  // Redirect to the service list page after success
                } else {
                    out.println("<p>Error: Unable to create service.</p>");
                }
            } else {
                out.println("<p>Error: No file uploaded. Please select an image.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>

    </div>
</body>
</html>
