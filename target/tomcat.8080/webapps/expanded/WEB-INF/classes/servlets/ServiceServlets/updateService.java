package servlets.ServiceServlets;

import com.ca1.models.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/admin/updateService")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class updateService extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String REST_URL = "http://localhost:8081/ca2-ws/services/";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get parameters from the request (the form data)
            String serviceId = request.getParameter("serviceId");
            String serviceName = request.getParameter("serviceName");
            String serviceDescription = request.getParameter("serviceDescription");
            String serviceCategoryId = request.getParameter("categoryId");
            String servicePrice = request.getParameter("servicePrice");
            String serviceAvailable = request.getParameter("serviceAvailable");
            boolean available = serviceAvailable != null && serviceAvailable.equals("true");

            // Fetch the current service data to get the old image path
            Client client = ClientBuilder.newClient();
            WebTarget target = client.target(REST_URL + serviceId);
            Response apiResponse = target.request(MediaType.APPLICATION_JSON).get();

            Service currentService = apiResponse.readEntity(Service.class);
            String oldImagePath = currentService.getImagePath(); // Keep the old image by default

            // Get the uploaded file
            Part filePart = request.getPart("serviceImage");
            String newImagePath = oldImagePath; // Default to the old image

            if (filePart != null && filePart.getSize() > 0) {
                // Define the upload directory
                String uploadPath = getServletContext().getRealPath("") + "img/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                // Save the uploaded file
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String filePath = uploadPath + fileName;
                filePart.write(filePath);

                // Update the image path
                newImagePath = "img/" + fileName;
            }

            // Create an updated Service object
            Service updatedService = new Service();
            updatedService.setId(Integer.parseInt(serviceId));
            updatedService.setServiceName(serviceName);
            updatedService.setDescription(serviceDescription);
            updatedService.setCategoryId(Integer.parseInt(serviceCategoryId));
            updatedService.setPrice(Double.parseDouble(servicePrice));
            updatedService.setAvailable(available);
            updatedService.setImagePath(newImagePath); // Keep old image if no new image is uploaded

            // Send the updated service data to the API
            WebTarget updateTarget = client.target(REST_URL + serviceId);
            Response updateResponse = updateTarget.request(MediaType.APPLICATION_JSON)
                    .put(Entity.entity(updatedService, MediaType.APPLICATION_JSON));

            if (updateResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                request.setAttribute("success", "Service updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update service.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/service");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating service.");
            response.sendRedirect("/admin/service"); // Redirect even in case of error
        }
    }
}
