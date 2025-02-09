package login.servlet;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/UpdateUserAddressServlet")
public class UpdateUserAddressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateUserAddressServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userID");
        String newAddress = request.getParameter("newAddress");

        System.out.println("Received update request for User ID: " + userId);
        System.out.println("New Address: " + newAddress);

        if (userId == null) {
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
            return;
        }

        if (newAddress == null || newAddress.trim().isEmpty()) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Address cannot be empty.");
            return;
        }

        try {
            // Construct the API URL correctly
            String apiUrl = "http://localhost:8081/ca2-ws/updateUserAddress/" + userId;
            
            // Create JSON payload
            JsonObject jsonRequest = new JsonObject();
            jsonRequest.addProperty("newAddress", newAddress);
            String jsonPayload = new Gson().toJson(jsonRequest);
            
            System.out.println("Sending JSON Request: " + jsonPayload);

            // Call the API
            Client client = ClientBuilder.newClient();
            WebTarget target = client.target(apiUrl);
            String apiResponse = target.request(MediaType.APPLICATION_JSON)
                .post(Entity.entity(jsonPayload, MediaType.APPLICATION_JSON), String.class);

            System.out.println("API Response: " + apiResponse);
            
            response.sendRedirect("user/checkout.jsp");
            
        } catch (Exception e) {
            System.err.println("Error updating address: " + e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update address.");
        }
    }

    private void sendErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"error\": \"" + message + "\"}");
        out.flush();
    }
}
