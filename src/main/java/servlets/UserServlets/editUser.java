package servlets.UserServlets;

import com.ca1.dao.CustomerDAO;
import com.ca1.models.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/editUser")
public class editUser extends HttpServlet {
    private static final long serialVersionUID = 1L;
	private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch customer ID from the request
        String customerIdParam = request.getParameter("id");
        if (customerIdParam == null || customerIdParam.isEmpty()) {
            request.setAttribute("customerError", "Invalid customer ID.");
            request.getRequestDispatcher("/admin/customer").forward(request, response);
            return;
        }

        int customerId = Integer.parseInt(customerIdParam);

        // Retrieve customer details from the database
        Customer customer = customerDAO.getCustomerById(customerId);
        if (customer == null) {
            request.setAttribute("customerError", "Customer not found.");
            request.getRequestDispatcher("/admin/customer/edit.jsp").forward(request, response);
            return;
        }

        // Forward customer details to the edit form
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/admin/customer/edit.jsp").forward(request, response);
    }

   
}