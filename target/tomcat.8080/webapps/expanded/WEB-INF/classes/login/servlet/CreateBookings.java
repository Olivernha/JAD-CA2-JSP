package login.servlet;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
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
import com.ca1.models.Booking;
import com.ca1.models.Service;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.checkout.Session;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CreateBookings")
public class CreateBookings extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CreateBookings() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Set Stripe Secret Key
            Stripe.apiKey = "sk_test_51QqRuBRtcizH9TiQgvEJprKxFacqvCIgyJlRk2jUrktynHVyoCDS76ruooWlyTEulO38QQfHpwuasAgqCvVkqSyE002PXDaa0x";

            // Retrieve session ID from request
            String sessionId = request.getParameter("session_id");
            if (sessionId == null || sessionId.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid session ID");
                return;
            }

            // Retrieve Stripe Session
            Session stripeSession = Session.retrieve(sessionId);
            String userIdStr = stripeSession.getMetadata().get("userId");
            String cartJson = stripeSession.getMetadata().get("cartJson");

            if (userIdStr == null || cartJson == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing metadata");
                return;
            }

            int userId = Integer.parseInt(userIdStr);

            // Convert JSON cart to List<Service>
            Gson gson = new Gson();
            Type serviceListType = new TypeToken<ArrayList<Service>>() {}.getType();
            List<Service> cart = gson.fromJson(cartJson, serviceListType);

            if (cart == null || cart.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cart is empty.");
                return;
            }

            // Create Booking Object
            Booking booking = new Booking();
            booking.setCustomerId(userId);
            booking.setStatus("Confirmed");
            booking.setTotalPrice(cart.stream().mapToDouble(s -> (s.getPrice() * 1.09) * s.getQuantity()).sum());
            booking.setServices(cart);

            // Call API (Spring Boot `BookingController`)
            String bookingJson = gson.toJson(booking);
            Client client = ClientBuilder.newClient();
            String apiUrl = "http://localhost:8081/ca2-ws/createBooking";
            WebTarget target = client.target(apiUrl);

            Response apiResponse = target.request(MediaType.APPLICATION_JSON)
                    .post(Entity.entity(bookingJson, MediaType.APPLICATION_JSON));

            if (apiResponse.getStatus() == Response.Status.OK.getStatusCode()) {
            	request.getSession().removeAttribute("cart");
                response.sendRedirect("http://localhost:8080/CA1/user/bookingConfirmation.jsp?success=Successfully Book!");
            } else {
                response.sendRedirect("http://localhost:8080/CA1/user/bookingFail.jsp");
            }
        } catch (StripeException e) {
            e.printStackTrace();
            response.sendRedirect("http://localhost:8080/CA1/user/bookingFail.jsp");
        }
    }
}

