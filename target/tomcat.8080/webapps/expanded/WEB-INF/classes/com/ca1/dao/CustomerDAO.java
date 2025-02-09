package com.ca1.dao;

import com.ca1.models.Booking;
import com.ca1.models.Customer;
import com.ca1.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ca1.models.Service;

public class CustomerDAO {
	private Connection connection;

    // Constructor that initializes the connection
	 public CustomerDAO() {
	        // Initialize the connection using your DatabaseConnection utility class
	        try {
				this.connection = DatabaseConnection.getConnection();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }


    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String query = "SELECT * FROM users ORDER BY user_id";

        try (PreparedStatement statement = connection.prepareStatement(query);
                ResultSet rs = statement.executeQuery()) {
        		while (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("user_id"));
                customer.setName(rs.getString("username"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setRole(rs.getString("role"));
                customer.setAddress(rs.getString("address"));
                customer.setJoinedDate(rs.getDate("created_at").toLocalDate());
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }
    
    public boolean deleteCustomer(int userId) {
        String sql = "DELETE FROM users WHERE  user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public Customer getCustomerById(int customerId) {
        Customer customer = null;
        String query = "SELECT * FROM users WHERE user_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, customerId);
            try (ResultSet resultSet = pstmt.executeQuery()) {
                if (resultSet.next()) {
                    customer = new Customer();
                    customer.setId(resultSet.getInt("user_id"));
                    customer.setName(resultSet.getString("username"));
                    customer.setEmail(resultSet.getString("email"));
                    customer.setPhone(resultSet.getString("phone"));
                    customer.setAddress(resultSet.getString("address"));
                    customer.setRole(resultSet.getString("role"));
                    customer.setJoinedDate(resultSet.getDate("created_at").toLocalDate());
                    customer.setAvatar(resultSet.getString("avatar"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return customer;
    }
    

        // Update customer in the database
    public boolean updateCustomer(Customer customer, String newPassword) {
        String sql;

        // Decide whether to include the password update
        if (newPassword == null || newPassword.isEmpty()) {
            sql = "UPDATE users SET username = ?, email = ?, phone = ?, address = ? , avatar = ?  WHERE user_id = ?";
        } else {
            sql = "UPDATE users SET username = ?, email = ?, phone = ?, address = ?, avatar = ? , password = ? WHERE user_id = ?";
        }

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            // Set parameters for common fields
            preparedStatement.setString(1, customer.getName());
            preparedStatement.setString(2, customer.getEmail());
            preparedStatement.setString(3, customer.getPhone());
            preparedStatement.setString(4, customer.getAddress());
            preparedStatement.setString(5, customer.getAvatar());
            // Include the password if provided
            if (newPassword != null && !newPassword.isEmpty()) {
                String hashedPassword = login.hashing_algorithm.Bcrypt.hashpw(newPassword, login.hashing_algorithm.Bcrypt.gensalt());
                preparedStatement.setString(6, hashedPassword);
                preparedStatement.setInt(7, customer.getId());
            } else {
                preparedStatement.setInt(6, customer.getId());
            }

            // Execute update
            int rowsUpdated = preparedStatement.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
  
        // Get total bookings for a specific customer
        public int getTotalBookings(int customerId) {
            String query = "SELECT COUNT(*) FROM bookings WHERE customer_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setInt(1, customerId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Return the count of bookings
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return 0;
        }

        // Get total services booked by a specific customer
        public int getTotalServices(int customerId) {
            String query = "SELECT COUNT(DISTINCT service_id) FROM booking_details WHERE booking_id IN (SELECT booking_id FROM bookings WHERE customer_id = ?)";
            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setInt(1, customerId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Return the count of distinct services
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return 0;
        }

        // Get total feedback given by a specific customer
        public int getTotalFeedback(int customerId) {
            String query = "SELECT COUNT(*) FROM feedback WHERE customer_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setInt(1, customerId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Return the count of feedback entries
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return 0;
        }

        public double getTotalSpent(int customerId) {
            // Query to get the total spent by the customer, joining with the services table to get the price
            String query = "SELECT SUM(s.price * bd.quantity) " +
                           "FROM booking_details bd " +
                           "JOIN bookings b ON bd.booking_id = b.booking_id " +
                           "JOIN service s ON bd.service_id = s.service_id " +
                           "WHERE b.customer_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setInt(1, customerId); // Set the customer ID parameter
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getDouble(1); // Return the total spent by the customer
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return 0.0; // If no record
        }
        
        public List<Service> getRecentServices(int userId) {
            List<Service> services = new ArrayList<>();
            String query = "SELECT s.service_id,s.service_name,c.category_name,COALESCE(f.rating, 0) AS rating FROM booking_details bd JOIN bookings b ON bd.booking_id = b.booking_id JOIN service s ON bd.service_id = s.service_id JOIN service_category c ON s.category_id = c.category_id LEFT JOIN feedback f ON s.service_id = f.service_id WHERE b.customer_id = ? AND b.status = 'Completed'  ORDER BY b.booking_date DESC LIMIT 3";
           
            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    Service service = new Service();
                    service.setId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setCategoryName(rs.getString("category_name"));
                    service.setRating(rs.getInt("rating"));
                    services.add(service);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return services;
        }
        public List<Booking> getUpcomingBookings(int userId) {
            List<Booking> bookings = new ArrayList<>();
            String query = "SELECT b.booking_id,b.booking_date,s.service_id,s.service_name FROM bookings b JOIN booking_details bd ON b.booking_id = bd.booking_id JOIN service s ON bd.service_id = s.service_id WHERE b.customer_id = ? AND b.status = 'Pending' AND b.booking_date > CURRENT_DATE ORDER BY b.booking_date ASC";

            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                Map<Integer, Booking> bookingMap = new HashMap<>();
                while (rs.next()) {
                    int bookingId = rs.getInt("booking_id");

                    Booking booking = bookingMap.getOrDefault(bookingId, new Booking());
                    if (!bookingMap.containsKey(bookingId)) {
                        booking.setBookingId(bookingId);
                        booking.setBookingDate(rs.getDate("booking_date"));
                        booking.setServices(new ArrayList<>());
                        bookingMap.put(bookingId, booking);
                    }

                    // Add services to the booking
                    Service service = new Service();
                    service.setId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    booking.getServices().add(service);
                }
                bookings.addAll(bookingMap.values());
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return bookings;
        }
        public List<Booking> getAllBookings(int customerId) {
            List<Booking> bookings = new ArrayList<>();
            String sql = """
                SELECT 
    b.booking_id,
    b.booking_date,
    b.status,
    s.service_id,
    s.service_name,
    s.price,
    f.rating,
    f.comments
FROM bookings b
JOIN booking_details bd ON b.booking_id = bd.booking_id
JOIN service s ON bd.service_id = s.service_id
LEFT JOIN feedback f ON s.service_id = f.service_id 
    AND f.customer_id = ?
WHERE b.customer_id = ?
ORDER BY b.booking_date DESC
            """;
            
            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                
                pstmt.setInt(1, customerId);
                pstmt.setInt(2, customerId);
                
                ResultSet rs = pstmt.executeQuery();
                
                Map<Integer, Booking> bookingMap = new HashMap<>();
                
                while (rs.next()) {
                    int bookingId = rs.getInt("booking_id");
                    
                    Booking booking = bookingMap.computeIfAbsent(bookingId, k -> {
                        Booking b = new Booking();
                        b.setBookingId(bookingId);
                        try {
							b.setBookingDate(rs.getDate("booking_date"));
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
                        try {
							b.setStatus(rs.getString("status"));
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
                        b.setServices(new ArrayList<>());
                        return b;
                    });
                    
                    Service service = new Service();
                    service.setId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setPrice(rs.getDouble("price"));
                    
                    // Set feedback if exists
                    int rating = rs.getInt("rating");
                    if (!rs.wasNull()) {
                        service.setRating(rating);
                        service.setFeedbackComment(rs.getString("comments"));
                        service.setHasFeedback(true); // Feedback exists
                    } else {
                        service.setHasFeedback(false); // No feedback
                    }
                    
                    booking.getServices().add(service);
                }
                
                bookings.addAll(bookingMap.values());
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            return bookings;
        }

        public boolean submitFeedback(int serviceId, int customerId, int rating, String comment) {
            String sql = "INSERT INTO feedback (service_id, customer_id, rating, comment) VALUES (?, ?, ?, ?)";
            
            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                
                pstmt.setInt(1, serviceId);
                pstmt.setInt(2, customerId);
                pstmt.setInt(3, rating);
                pstmt.setString(4, comment);
                
                int rowsAffected = pstmt.executeUpdate();
                return rowsAffected > 0;
                
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
}
