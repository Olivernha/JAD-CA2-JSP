package servlets.UserServlets;

import jakarta.servlet.RequestDispatcher;
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

import com.ca1.models.Customer;
@WebServlet("/getUsersByPostalCode")

public class getUsersByPostalCode extends HttpServlet {

    private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String postalCode = request.getParameter("areaCode");
        System.out.print(postalCode);
        // Validate postal code
        if (postalCode == null || postalCode.isEmpty()) {
            request.setAttribute("customerError", "Postal code is required.");
            request.getRequestDispatcher("/admin/customer/index.jsp").forward(request, response);
            return;
        }
        
        // Proceed with the client request as before
        try {
            Client client = ClientBuilder.newClient();
            String restUrl = "http://localhost:8081/ca2-ws/users/area/" + postalCode;
            WebTarget target = client.target(restUrl);
            Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
            Response resp = invocationBuilder.get();

            if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                ArrayList<Customer> customers = resp.readEntity(new GenericType<ArrayList<Customer>>() {});
                System.out.print(customers);
                request.setAttribute("users", customers);
                request.getRequestDispatcher("/admin/customer/index.jsp").forward(request, response);
            } else {
                request.setAttribute("customerError", "Failed to fetch customers. Please try again later.");
                request.getRequestDispatcher("/admin/customer/index.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("customerError", "Error fetching customers.");
            request.getRequestDispatcher("/admin/customer/index.jsp").forward(request, response);
        }
    }
}
