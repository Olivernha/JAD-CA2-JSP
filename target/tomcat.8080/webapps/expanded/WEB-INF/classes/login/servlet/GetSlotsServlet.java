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

@WebServlet("/GetSlotsServlet")
public class GetSlotsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GetSlotsServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("Fetching slots from API...");

            // Call API to get slot data
            Client client = ClientBuilder.newClient();
            String apiUrl = "http://localhost:8081/ca2-ws/getSlots";
            WebTarget target = client.target(apiUrl);
            String jsonSlots = target.request(MediaType.APPLICATION_JSON).get(String.class);

            System.out.println("Slots received: " + jsonSlots);

            // Send JSON back to JSP
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(jsonSlots);
            out.flush();
        } catch (Exception e) {
            System.out.println("❌ Error fetching slots: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch slots");
        }
    }
}
