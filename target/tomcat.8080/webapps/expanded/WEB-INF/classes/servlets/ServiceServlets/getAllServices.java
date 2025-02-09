package servlets.ServiceServlets;

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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ca1.models.Category;
import com.ca1.models.Service;

@WebServlet("/admin/service")
public class getAllServices extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public getAllServices() {
        super();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Setup REST client
        	
            Client client = ClientBuilder.newClient();
           
            // Fetch Services
            String servicesUrl = "http://localhost:8081/ca2-ws/services";
            WebTarget servicesTarget = client.target(servicesUrl);
            Invocation.Builder servicesInvocationBuilder = servicesTarget.request(MediaType.APPLICATION_JSON);
            Response servicesResponse = servicesInvocationBuilder.get();

            if (servicesResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                List<Service> services = servicesResponse.readEntity(new GenericType<List<Service>>() {});
                request.setAttribute("services", services);
                System.out.println("Fetched services successfully: " + services);
            } else {
                request.setAttribute("serviceError", "Failed to fetch services");
                System.out.println("Failed to fetch services");
            }

            // Fetch Categories
            String categoriesUrl = "http://localhost:8081/ca2-ws/category";
            WebTarget categoriesTarget = client.target(categoriesUrl);
            Invocation.Builder categoriesInvocationBuilder = categoriesTarget.request(MediaType.APPLICATION_JSON);
            Response categoriesResponse = categoriesInvocationBuilder.get();

            if (categoriesResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                List<Category> categories = categoriesResponse.readEntity(new GenericType<List<Category>>() {});
                request.setAttribute("categories", categories);
                System.out.println("Fetched categories successfully: " + categories);
            } else {
                request.setAttribute("categoryError", "Failed to fetch categories");
                System.out.println("Failed to fetch categories");
            }

            // Fetch Service Statistics
            String statsUrl = "http://localhost:8081/ca2-ws/services/stats";
            WebTarget statsTarget = client.target(statsUrl);
            Invocation.Builder statsInvocationBuilder = statsTarget.request(MediaType.APPLICATION_JSON);
            Response statsResponse = statsInvocationBuilder.get();

            if (statsResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                Map<String, Object> stats = statsResponse.readEntity(new GenericType<Map<String, Object>>() {});
                request.setAttribute("stats", stats);
                System.out.println("Fetched service statistics successfully: " + stats);
            } else {
                request.setAttribute("statsError", "Failed to fetch service statistics");
                System.out.println("Failed to fetch service statistics");
            }

            // Fetch Price Range Distribution
            String priceRangeUrl = "http://localhost:8081/ca2-ws/services/price-distribution";
            WebTarget priceRangeTarget = client.target(priceRangeUrl);
            Invocation.Builder priceRangeInvocationBuilder = priceRangeTarget.request(MediaType.APPLICATION_JSON);
            Response priceRangeResponse = priceRangeInvocationBuilder.get();

            if (priceRangeResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                Map<String, Integer> priceRanges = priceRangeResponse.readEntity(new GenericType<Map<String, Integer>>() {});
                request.setAttribute("priceRanges", priceRanges);
                System.out.println("Fetched price range distribution successfully: " + priceRanges);
            } else {
                request.setAttribute("priceRangeError", "Failed to fetch price range distribution");
                System.out.println("Failed to fetch price range distribution");
            }

            // Fetch Best-Rated Services
            String bestRatedUrl = "http://localhost:8081/ca2-ws/services/best-rated";
            WebTarget bestRatedTarget = client.target(bestRatedUrl);
            Invocation.Builder bestRatedInvocationBuilder = bestRatedTarget.request(MediaType.APPLICATION_JSON);
            Response bestRatedResponse = bestRatedInvocationBuilder.get();

            if (bestRatedResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                List<Service> bestRatedServices = bestRatedResponse.readEntity(new GenericType<List<Service>>() {});
                request.setAttribute("bestRatedServices", bestRatedServices);
                System.out.println("Fetched best-rated services successfully: " + bestRatedServices);
            } else {
                request.setAttribute("bestRatedError", "Failed to fetch best-rated services");
                System.out.println("Failed to fetch best-rated services");
            }

            // Fetch Lowest-Rated Services
            String lowestRatedUrl = "http://localhost:8081/ca2-ws/services/lowest-rated";
            WebTarget lowestRatedTarget = client.target(lowestRatedUrl);
            Invocation.Builder lowestRatedInvocationBuilder = lowestRatedTarget.request(MediaType.APPLICATION_JSON);
            Response lowestRatedResponse = lowestRatedInvocationBuilder.get();

            if (lowestRatedResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                List<Service> lowestRatedServices = lowestRatedResponse.readEntity(new GenericType<List<Service>>() {});
                request.setAttribute("lowestRatedServices", lowestRatedServices);
                System.out.println("Fetched lowest-rated services successfully: " + lowestRatedServices);
            } else {
                request.setAttribute("lowestRatedError", "Failed to fetch lowest-rated services");
                System.out.println("Failed to fetch lowest-rated services");
            }

            // Fetch High-Demand/Low-Availability Services
            String highDemandUrl = "http://localhost:8081/ca2-ws/services/high-demand";
            WebTarget highDemandTarget = client.target(highDemandUrl);
            Invocation.Builder highDemandInvocationBuilder = highDemandTarget.request(MediaType.APPLICATION_JSON);
            Response highDemandResponse = highDemandInvocationBuilder.get();

            if (highDemandResponse.getStatus() == Response.Status.OK.getStatusCode()) {
                List<Service> highDemandServices = highDemandResponse.readEntity(new GenericType<List<Service>>() {});
                request.setAttribute("highDemandServices", highDemandServices);
                System.out.println("Fetched high-demand services successfully: " + highDemandServices);
            } else {
                request.setAttribute("highDemandError", "Failed to fetch high-demand services");
                System.out.println("Failed to fetch high-demand services");
            }

            // Forward to JSP
            String url = "/admin/service/index.jsp";
            RequestDispatcher rd = request.getRequestDispatcher(url);
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("generalError", "An unexpected error occurred while fetching data.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/service/index.jsp");
            dispatcher.forward(request, response);
        }
    }
}