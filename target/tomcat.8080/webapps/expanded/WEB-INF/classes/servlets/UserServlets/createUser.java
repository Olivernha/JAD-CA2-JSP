package servlets.UserServlets;

import jakarta.servlet.RequestDispatcher;
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
import com.ca1.models.Customer;

@WebServlet("/createUser")
public class createUser extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public createUser() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String postal_code = request.getParameter("postal_code");

            // Create Customer object
            Customer customer = new Customer();
            customer.setName(name);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);
            customer.setPassword(password);
            customer.setRole(role);
            customer.setPostalCode(postal_code);

            // Setup REST client
            Client client = ClientBuilder.newClient();
            String restUrl = "http://localhost:8081/ca2-ws/users"; // Updated to match your REST endpoint
            WebTarget target = client.target(restUrl);

            // Make POST request with customer data
            Response resp = target
                    .request(MediaType.APPLICATION_JSON)
                    .post(Entity.entity(customer, MediaType.APPLICATION_JSON));

            System.out.println("Status: " + resp.getStatus());

            if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                System.out.println("Customer created successfully");

                // Set success attributes
                request.setAttribute("success", "CustomerCreated");
                request.setAttribute("newCustomerName", name);
                request.setAttribute("newCustomerEmail", email);
                request.setAttribute("newCustomerPhone", phone);
                request.setAttribute("newCustomerAddress", address);
            } else {
                System.out.println("Failed to create customer");
                request.setAttribute("error", "Creation failed. Status code: " + resp.getStatus());
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Creation failed: " + e.getMessage());
        } finally {
            // Forward to the JSP page
        	response.sendRedirect("admin/customer");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For security, redirect GET requests to a form page instead of processing them
    	doPost(request,response);
    }
}