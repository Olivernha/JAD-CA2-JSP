package servlets.ServiceServlets;



import com.ca1.dao.CustomerDAO;
import com.ca1.models.Category;
import com.ca1.models.Customer;
import com.ca1.models.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/editService")
public class editService extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        
        // Log the id to ensure it's being received
        System.out.println("Received id: " + id);

        if (id == null || id.isEmpty()) {
            request.setAttribute("error", "Service ID is required.");
            request.getRequestDispatcher("/admin/service/index.jsp").forward(request, response);
            return;
        }

        try {
            // Creating the client for RESTful services
            Client client = ClientBuilder.newClient();
            String restUrl = "http://localhost:8081/ca2-ws/services/" + id; // Correct API endpoint
            WebTarget target = client.target(restUrl);
            Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
            Response resp = invocationBuilder.get();

            if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                // Handle the response correctly
                Service service = resp.readEntity(Service.class);  // Fetching a single Service object instead of a list
                System.out.println("Fetched service: " + service);
                request.setAttribute("service", service);  // Setting a single service object instead of a list
            } else {
                request.setAttribute("error", "Failed to fetch service. Please try again later.");
                request.getRequestDispatcher("/admin/service/index.jsp").forward(request, response);
                return;
            }

            // Fetching category data for the dropdown
            String servicesUrl = "http://localhost:8081/ca2-ws/category";
            WebTarget servicesTarget = client.target(servicesUrl);
            Invocation.Builder servicesInvocationBuilder = servicesTarget.request(MediaType.APPLICATION_JSON);
            Response categoryResponse = servicesInvocationBuilder.get();

            if (categoryResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                List<Category> categories = categoryResponse.readEntity(new GenericType<List<Category>>() {});
                request.setAttribute("categories", categories);  // Setting categories for the dropdown
                System.out.println("Fetched categories successfully: " + categories);
            } else {
                request.setAttribute("categoryError", "Failed to fetch categories.");
                System.out.println("Failed to fetch categories");
            }

            // Forward to the edit service page after fetching data
            request.getRequestDispatcher("/admin/service/edit.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching service or categories.");
            request.getRequestDispatcher("/admin/service/index.jsp").forward(request, response);
        }
    }
}
