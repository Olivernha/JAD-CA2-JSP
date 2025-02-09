package login.servlet;

import com.ca1.dao.CustomerDAO;
import com.ca1.models.Customer;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
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
import java.io.PrintWriter;
import java.nio.file.Paths;
/**
 * Servlet implementation class UpdateCustomerProfile
 */
@WebServlet("/UpdateCustomerProfile")
public class UpdateCustomerProfile extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve input parameters
    	Integer userId = (Integer) request.getSession().getAttribute("userID");
    	System.out.println("Received update request for User ID: " + userId);
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        
        // Validate input
        if (name == null || email == null || phone == null || address == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || phone.trim().isEmpty() || address.trim().isEmpty()) {
            response.sendRedirect("user/profile/index.jsp?error=Invalid input fields");
            return;
        }

        try {
            // Construct API URL
            String apiUrl = "http://localhost:8081/ca2-ws/updateCustomerProfile/"+userId;

            // Prepare JSON payload
            JsonObject jsonRequest = new JsonObject();
            jsonRequest.addProperty("name", name);
            jsonRequest.addProperty("email", email);
            jsonRequest.addProperty("phone", phone);
            jsonRequest.addProperty("address", address);
            jsonRequest.addProperty("password", password);

            String jsonPayload = new Gson().toJson(jsonRequest);

            // Make API request
            Client client = ClientBuilder.newClient();
            WebTarget target = client.target(apiUrl);

            Response apiResponse = target.request(MediaType.APPLICATION_JSON)
                .post(Entity.entity(jsonPayload, MediaType.APPLICATION_JSON));

            // Handle API response
            if (apiResponse.getStatus() == 200) {
                response.sendRedirect("user/profile/index.jsp?success=Profile updated successfully");
            } else {
                response.sendRedirect("user/profile/index.jsp?error=Failed to update profile");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user/profile/index.jsp?error=Error updating profile");
        }
    }
}
