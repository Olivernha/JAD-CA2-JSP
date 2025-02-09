package servlets.ServiceServlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;

@WebServlet("/admin/deleteService")
public class deleteService extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String REST_URL = "http://localhost:8081/ca2-ws/services/";

   
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String serviceId = request.getParameter("id");
        
        if (serviceId == null || serviceId.isEmpty()) {
        	   request.setAttribute("error", "Service ID is missing.");
               request.getRequestDispatcher("/admin/service").forward(request, response);
               return;
        }

        try {
            // Create REST client
            Client client = ClientBuilder.newClient();
            WebTarget target = client.target(REST_URL + serviceId);

            // Send DELETE request
            Response apiResponse = target.request(MediaType.APPLICATION_JSON).delete();

            if (apiResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                request.setAttribute("success", "Service deleted successfully.");
            } else {
                request.setAttribute("error", "Failed to delete service.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error deleting service.");
        }

        // Redirect back to the service list
        request.getRequestDispatcher("/admin/service").forward(request, response);
    }
    
}
