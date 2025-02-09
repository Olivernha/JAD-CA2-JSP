package servlets.ServiceServlets;

import java.io.IOException;
import java.util.List;

import com.ca1.models.Category;


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
@WebServlet("/admin/service/create")
public class getCategoryForService extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		  try {
	            // Setup REST client
	        	
	            Client client = ClientBuilder.newClient();
	           
	            // Fetch Services
	            String servicesUrl = "http://localhost:8081/ca2-ws/category";
	            WebTarget servicesTarget = client.target(servicesUrl);
	            Invocation.Builder servicesInvocationBuilder = servicesTarget.request(MediaType.APPLICATION_JSON);
	            Response categoryResponse = servicesInvocationBuilder.get();
	            
	            if (categoryResponse.getStatus() == Response.Status.OK.getStatusCode()) {
	                List<Category> ct = categoryResponse.readEntity(new GenericType<List<Category>>() {});
	                request.setAttribute("categories", ct);
	                System.out.println("Fetched category successfully: " + ct);
	            } else {
	                request.setAttribute("serviceError", "Failed to fetch services");
	                System.out.println("Failed to fetch services");
	            }
	            String url = "/admin/service/create.jsp";
	            RequestDispatcher rd = request.getRequestDispatcher(url);
	            rd.forward(request, response);
		  }
		  catch (Exception e) {
	            e.printStackTrace();
	            request.setAttribute("generalError", "An unexpected error occurred while fetching data.");
	            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/service/create.jsp");
	            dispatcher.forward(request, response);
	        }
	  }
}
