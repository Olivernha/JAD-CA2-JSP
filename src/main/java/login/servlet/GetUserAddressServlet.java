package login.servlet;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/GetUserAddressServlet")
public class GetUserAddressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GetUserAddressServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userID");

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        try {
            System.out.println("Fetching user address for User ID: " + userId);

            // Call API to fetch user address
            Client client = ClientBuilder.newClient();
            String apiUrl = "http://localhost:8081/ca2-ws/getUserAddress?userId=" + userId;
            WebTarget target = client.target(apiUrl);
            String userAddress = target.request(MediaType.APPLICATION_JSON).get(String.class);

            System.out.println("User Address Received: " + userAddress);

            // Convert to valid JSON format
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(userAddress);

            response.setContentType("application/json");
            response.getWriter().write("{\"address\": " + jsonResponse + "}");

        } catch (Exception e) {
            System.out.println("Error fetching user address: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch user address");
        }
    }
}
