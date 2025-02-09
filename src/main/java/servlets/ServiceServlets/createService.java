package servlets.ServiceServlets;

import jakarta.servlet.RequestDispatcher;
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
import com.ca1.models.Service;

@WebServlet("/admin/createService")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
public class createService extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String API_URL = "http://localhost:8081/ca2-ws/services";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fileName = "";
        try {
            // Parse and validate form data first
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String serviceName = request.getParameter("serviceName");
            String serviceDescription = request.getParameter("serviceDescription");
            double servicePrice = Double.parseDouble(request.getParameter("servicePrice"));
            double discount = Double.parseDouble(request.getParameter("discount"));
            boolean available = request.getParameter("available") != null;

            // Handle file upload
            Part filePart = request.getPart("serviceImage");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + "img" + File.separator;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();  // Create directories recursively
                }

                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (!fileName.isEmpty()) {
                    String filePath = uploadPath + fileName;
                    filePart.write(filePath);
                }
            }

            // Create and populate Service object
            Service service = new Service();
            service.setCategoryId(categoryId);
            service.setServiceName(serviceName);
            service.setDescription(serviceDescription);
            service.setPrice(servicePrice);
            service.setDiscount(discount);
            service.setAvailable(available);
            
            if (!fileName.isEmpty()) {
                service.setImagePath("img/" + fileName);
            }

            // Setup REST client and make request
            Client client = ClientBuilder.newClient();
            try {
                WebTarget target = client.target(API_URL);
                Response apiResponse = target
                        .request(MediaType.APPLICATION_JSON)
                        .post(Entity.entity(service, MediaType.APPLICATION_JSON));

                if (apiResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                	 response.sendRedirect(request.getContextPath() + "/admin/service?message=Created service successfully");
                } else {
                	 response.sendRedirect(request.getContextPath() + "/admin/service?error=Failed to create service");
                }
            } finally {
                client.close();  // Always close the client
            }

        } catch (NumberFormatException e) {
        	 response.sendRedirect(request.getContextPath() + "/admin/service?error=Invalid number format: Please check price and discount values");
           
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/service?error="+e.getMessage());

        }
        	
       

    
}
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to POST
        doPost(request, response);
    }
}