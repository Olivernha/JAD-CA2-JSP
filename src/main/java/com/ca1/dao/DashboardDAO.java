package com.ca1.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.ca1.utils.DatabaseConnection;

public class DashboardDAO {
    private Connection connection;

    // Constructor that initializes the connection
    public DashboardDAO() {
        try {
            this.connection = DatabaseConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Method to get total customers
    public int getTotalCustomers() {
        String query = "SELECT COUNT(*) FROM users";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Default value if query fails
    }

    // Method to get total active bookings
    public int getActiveBookings() {
        String query = "SELECT COUNT(*) FROM bookings WHERE status = 'Confirmed'";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

 
    // Method to get average rating
    public double getAverageRating() {
        String query = "SELECT AVG(rating) FROM feedback";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
