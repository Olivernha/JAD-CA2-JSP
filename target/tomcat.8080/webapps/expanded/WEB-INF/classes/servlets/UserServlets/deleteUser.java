package servlets.UserServlets;

import jakarta.servlet.RequestDispatcher;
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

@WebServlet("/admin/deleteUser")
public class deleteUser extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public deleteUser() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get user id from request parameter
            String userId = request.getParameter("id");
            if (userId == null || userId.isEmpty()) {
                request.setAttribute("error", "User ID is missing.");
                request.getRequestDispatcher("/admin/customer/index.jsp").forward(request, response);
                return;
            }

            // Setup REST client
            Client client = ClientBuilder.newClient();
            String restUrl = "http://localhost:8081/ca2-ws/users/" + userId; // REST endpoint to delete user by id
            WebTarget target = client.target(restUrl);

            // Make DELETE request to the backend API
            Response resp = target
                    .request(MediaType.APPLICATION_JSON)
                    .delete();

            if (resp.getStatus() == Response.Status.NO_CONTENT.getStatusCode()) {
                // Successfully deleted user
                request.setAttribute("success", "User deleted successfully.");
            } else {
                // Failed to delete user
                request.setAttribute("error", "Failed to delete user.");
            }

            // Forward the response to the admin customer page
            request.getRequestDispatcher("/admin/customer").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while deleting the user.");
            request.getRequestDispatcher("/admin/customer").forward(request, response);
        }
    }
}
