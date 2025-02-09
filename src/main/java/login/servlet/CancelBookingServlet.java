package login.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.Response;

import java.io.BufferedReader;
import java.io.IOException;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@WebServlet("/CancelBooking")
public class CancelBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Read JSON request body
        BufferedReader reader = request.getReader();
        StringBuilder jsonBuffer = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            jsonBuffer.append(line);
        }

        // Parse JSON
        JsonObject jsonObject = JsonParser.parseString(jsonBuffer.toString()).getAsJsonObject();
        String bookingId = jsonObject.get("bookingId").getAsString();

        System.out.println("Received Booking ID: " + bookingId);

        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid booking ID");
            return;
        }

        try {
            // Construct API URL
            String apiUrl = "http://localhost:8081/ca2-ws/cancelBooking/" + bookingId;

            // Create REST client
            Client client = ClientBuilder.newClient();
            WebTarget target = client.target(apiUrl);

            // Send DELETE request
            Response apiResponse = target.request().delete();

            if (apiResponse.getStatus() == 200) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Booking cancelled successfully");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Error cancelling booking");
            }

            apiResponse.close(); // Close API response

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Internal server error");
        }
    }
}

