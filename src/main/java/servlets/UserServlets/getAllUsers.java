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
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import com.ca1.models.Customer;
@WebServlet("/admin/customer")
public class getAllUsers extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public getAllUsers() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Setup REST client
        	 
             Client client = ClientBuilder.newClient();
             String restUrl = "http://localhost:8081/ca2-ws/users";
             WebTarget target = client.target(restUrl);
             Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
             Response resp = invocationBuilder.get();
             System.out.println("status: " + resp.getStatus());

             if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                 System.out.println("success");

                 ArrayList<Customer> al = resp.readEntity(new GenericType<ArrayList<Customer>>() {}); // needs empty body to preserve generic type
                 
         
                 // Write to request object for forwarding to target page
                 request.setAttribute("users", al);
                 System.out.println(al);
                 System.out.println("......request obj set... forwarding...");
                 request.setAttribute("customerSucess", "Fetched successfully");
                 String url = "/admin/customer/index.jsp";
                 RequestDispatcher rd = request.getRequestDispatcher(url);
                 rd.forward(request, response);
             } else {
                 System.out.println("failed");
                 String url = "/admin/customer/index.jsp";
                 request.setAttribute("customerError", "Failed to fetch users");
                 RequestDispatcher rd = request.getRequestDispatcher(url);
                  rd.forward(request, response);
             }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("customerError", "Failed to fetch users");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/customer/index.jsp");
            dispatcher.forward(request, response);
        }
    }
}
