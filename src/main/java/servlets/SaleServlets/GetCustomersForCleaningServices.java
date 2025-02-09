package servlets.SaleServlets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.io.IOException;
import java.io.PrintWriter;
@WebServlet("/GetCustomersForCleaningServices")

public class GetCustomersForCleaningServices extends HttpServlet {
    private static final long serialVersionUID = 1L;
  
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
     
            String apiUrl = "http://localhost:8081/ca2-ws/getCustomersForCleaningServices";
            Client client = ClientBuilder.newClient();
            WebTarget target = client.target(apiUrl);
            Response apiResponse = target.request(MediaType.APPLICATION_JSON).get();
            
            if (apiResponse.getStatus() == 200) {
                String jsonResponse = apiResponse.readEntity(String.class);
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(jsonResponse);
                out.flush();
            } else {
                response.sendError(apiResponse.getStatus(), "Error fetching recent services");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
}
