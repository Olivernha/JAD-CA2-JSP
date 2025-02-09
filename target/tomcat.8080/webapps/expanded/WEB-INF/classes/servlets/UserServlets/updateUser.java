package servlets.UserServlets;

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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ca1.models.Customer;

import java.io.IOException;

@WebServlet("/updateUser")
public class updateUser extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(updateUser.class);

    public updateUser() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Retrieve form parameters
            String customerId = request.getParameter("id");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            // Validate required fields
            if (customerId == null || customerId.isEmpty()) {
                throw new IllegalArgumentException("Customer ID is required.");
            }

            // Create Customer object
            Customer customer = new Customer();
            customer.setId(Integer.parseInt(customerId));
            customer.setName(name);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);
            customer.setPassword(password); // Ensure password is hashed before saving
            customer.setRole(role);

            // Setup REST client
            try (Client client = ClientBuilder.newClient()) {
                String restUrl = "http://localhost:8081/ca2-ws/users/" + customerId;
                WebTarget target = client.target(restUrl);

                // Make PUT request
                Response resp = target
                        .request(MediaType.APPLICATION_JSON)
                        .put(Entity.entity(customer, MediaType.APPLICATION_JSON));

                if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                    logger.info("Customer updated successfully");
                    request.setAttribute("customerSuccess", "Customer updated successfully.");
                } else {
                    logger.error("Failed to update customer. Status code: {}", resp.getStatus());
                    request.setAttribute("error", "Update failed. Status code: " + resp.getStatus());
                }
            }
        } catch (Exception e) {
           
            request.setAttribute("customerError", "Update failed: " + e.getMessage());
        } finally {
            // Redirect to avoid duplicate submissions
            response.sendRedirect(request.getContextPath() + "/admin/customer");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the appropriate page
        response.sendRedirect(request.getContextPath() + "/admin/customer");
    }
}