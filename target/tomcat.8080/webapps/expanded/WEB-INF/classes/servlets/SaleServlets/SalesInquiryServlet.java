package servlets.SaleServlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

@WebServlet("/api/sales/*")
public class SalesInquiryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String apiUrl = "http://localhost:8081/ca2-ws"; // Replace with your API base URL

        if (pathInfo.startsWith("/date/")) {
            String date = pathInfo.substring("/date/".length());
            apiUrl += "/sale/date/" + date;
        } else if (pathInfo.startsWith("/period/")) {
            String[] parts = pathInfo.substring("/period/".length()).split("/");
            String startDate = parts[0];
            String endDate = parts[1];
            apiUrl += "/period/" + startDate + "/" + endDate;
        } else if (pathInfo.startsWith("/monthYear/")) {
            String[] parts = pathInfo.substring("/monthYear/".length()).split("/");
            int month = Integer.parseInt(parts[0]);
            int year = Integer.parseInt(parts[1]);
            apiUrl += "/monthYear/" + month + "/" + year;
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
            return;
        }

        // Fetch data from the API
        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            if (conn.getResponseCode() == 200) {
                Scanner scanner = new Scanner(conn.getInputStream());
                StringBuilder result = new StringBuilder();
                while (scanner.hasNext()) {
                    result.append(scanner.nextLine());
                }
                scanner.close();

                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(result.toString());
                out.flush();
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching data from API");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }
}