package com.ca1.controller;

import com.ca1.dao.CategoryDAO;
import com.ca1.dao.ServiceDAO;
import com.ca1.models.Category;
import com.ca1.models.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/services")
public class ServiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
	private ServiceDAO serviceDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        serviceDAO = new ServiceDAO();
        categoryDAO = new CategoryDAO();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sortOrder = request.getParameter("sortOrder");
        String filter = request.getParameter("filter");
        String keyword = request.getParameter("keyword");
        Integer categoryId = null;
        String categoryIdParam = request.getParameter("categoryId");
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            categoryId = Integer.parseInt(categoryIdParam);
        }
       

        // Handle minPrice and maxPrice safely by checking if they are non-empty before parsing
        Double minPrice = null;
        Double maxPrice = null;

        if (request.getParameter("minPrice") != null && !request.getParameter("minPrice").isEmpty()) {
            minPrice = Double.parseDouble(request.getParameter("minPrice"));
        }

        if (request.getParameter("maxPrice") != null && !request.getParameter("maxPrice").isEmpty()) {
            maxPrice = Double.parseDouble(request.getParameter("maxPrice"));
        }

        List<Service> services = serviceDAO.getAllServices();
        CategoryDAO categoryDAO = new CategoryDAO(); // Ensure it's properly initialized

        for (Service service : services) {
            Category category = categoryDAO.getCategoryById(service.getCategoryId());
            if (category != null) {
                service.setCategoryName(category.getName()); // Store category name in Service object
            }
        }

        if ("ASC".equalsIgnoreCase(sortOrder)) {
            services = serviceDAO.getServicesByRating("ASC");
        } else if ("DESC".equalsIgnoreCase(sortOrder)) {
            services = serviceDAO.getServicesByRating("DESC");
        } else if ("highDemand".equalsIgnoreCase(filter)) {
            services = serviceDAO.getServicesByAvailabilityAndDemand();
        } else if (keyword != null || categoryId != null || minPrice != null || maxPrice != null) {
            services = serviceDAO.searchServices(keyword, categoryId, minPrice, maxPrice);
        }

        // Fetch categories and statistics
        List<Category> categories = categoryDAO.getCategories();
        Map<String, Object> stats = serviceDAO.getServiceStatistics();
        Map<String, Integer> priceRanges = serviceDAO.getPriceRangeDistribution();

        // Attach data to the request
        request.setAttribute("services", services);
        request.setAttribute("categories", categories);
        request.setAttribute("stats", stats);
        request.setAttribute("priceRanges", priceRanges);

        // Forward to the View
        request.getRequestDispatcher("/admin/service/index.jsp").forward(request, response);
    }

}