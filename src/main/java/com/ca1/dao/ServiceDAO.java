package com.ca1.dao;

import com.ca1.utils.DatabaseConnection;
import com.ca1.models.Category;
import com.ca1.models.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ServiceDAO {
    private Connection connection;

    public ServiceDAO() {
        try {
            this.connection = DatabaseConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Fetch all services
    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM service ORDER BY service_id";
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    // Fetch services by category
    public List<Service> getServicesByCategory(int categoryId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM service WHERE category_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSetToService(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    // Add a new service
    public boolean addService(Service service) {
        String sql = "INSERT INTO service (category_id, service_name, description, price, image_path, is_available) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, service.getCategoryId());
            stmt.setString(2, service.getServiceName());
            stmt.setString(3, service.getDescription());
            stmt.setDouble(4, service.getPrice());
            stmt.setString(5, service.getImagePath());
            stmt.setBoolean(6, service.isAvailable());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a service
    public boolean deleteService(int serviceId) {
        String sql = "DELETE FROM service WHERE service_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get a service by ID
    public Service getServiceById(int serviceId) {
        String sql = "SELECT * FROM service WHERE service_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToService(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update an existing service
    public boolean updateService(Service service) {
        String sql = "UPDATE service SET category_id = ?, service_name = ?, description = ?, price = ?, image_path = ?, is_available = ? WHERE service_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, service.getCategoryId());
            stmt.setString(2, service.getServiceName());
            stmt.setString(3, service.getDescription());
            stmt.setDouble(4, service.getPrice());
            stmt.setString(5, service.getImagePath());
            stmt.setBoolean(6, service.isAvailable());
            stmt.setInt(7, service.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Toggle service availability
    public boolean toggleServiceAvailability(int serviceId) {
        String sql = "UPDATE service SET is_available = NOT is_available WHERE service_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get service statistics
    public Map<String, Object> getServiceStatistics() {
        Map<String, Object> stats = new HashMap<>();
        String sql = """
            SELECT 
                COUNT(*) as total_services,
                AVG(price) as avg_price,
                AVG(service_rating) as avg_rating,
                (
                    SELECT category_id 
                    FROM service 
                    GROUP BY category_id 
                    ORDER BY COUNT(*) DESC 
                    LIMIT 1
                ) as popular_category_id
            FROM service
            """;
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                stats.put("totalServices", rs.getInt("total_services"));
                stats.put("averagePrice", rs.getDouble("avg_price"));
                stats.put("averageRating", rs.getDouble("avg_rating"));
                int popularCategoryId = rs.getInt("popular_category_id");
                CategoryDAO categoryDAO = new CategoryDAO();
                Category popularCategory = categoryDAO.getCategoryById(popularCategoryId);
                stats.put("popularCategory", popularCategory != null ? popularCategory.getName() : "Uncategorized");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // Get price range distribution
    public Map<String, Integer> getPriceRangeDistribution() {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = """
            SELECT 
                COUNT(CASE WHEN price < 50 THEN 1 END) as under50,
                COUNT(CASE WHEN price >= 50 AND price < 100 THEN 1 END) as range50to100,
                COUNT(CASE WHEN price >= 100 THEN 1 END) as over100
            FROM service
            """;
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                distribution.put("under50", rs.getInt("under50"));
                distribution.put("50to100", rs.getInt("range50to100"));
                distribution.put("over100", rs.getInt("over100"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distribution;
    }

    // Get services sorted by rating
    public List<Service> getServicesByRating(String sortOrder) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM service ORDER BY service_rating " + (sortOrder.equalsIgnoreCase("DESC") ? "DESC" : "ASC");
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    // Get services by availability and demand
    public List<Service> getServicesByAvailabilityAndDemand() {
        List<Service> services = new ArrayList<>();
        String sql = """
        	    SELECT s.service_id, s.category_id, s.service_name, s.description, s.price, s.image_path, s.discount, s.service_rating, s.is_available
FROM service s 
LEFT JOIN booking_details b ON s.service_id = b.service_id 
WHERE s.is_available = TRUE 
GROUP BY s.service_id 
HAVING COUNT(b.booking_id) >= 2
ORDER BY COUNT(b.booking_id) DESC

        	    """;
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    // Search services by various criteria
    public List<Service> searchServices(String keyword, Integer categoryId, Double minPrice, Double maxPrice) {
        List<Service> services = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM service WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(service_name) LIKE ? OR LOWER(description) LIKE ?)");
            String searchTerm = "%" + keyword.toLowerCase() + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }
        if (categoryId != null) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }

        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSetToService(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    // Helper method to map ResultSet to Service object
    private Service mapResultSetToService(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setId(rs.getInt("service_id"));
        service.setCategoryId(rs.getInt("category_id"));
        service.setServiceName(rs.getString("service_name"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getDouble("price"));
        service.setImagePath(rs.getString("image_path"));
        service.setDiscount(rs.getDouble("discount"));
        service.setServiceRating(rs.getInt("service_rating"));
        service.setAvailable(rs.getBoolean("is_available"));
        return service;
    }

}