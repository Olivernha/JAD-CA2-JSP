package com.ca1.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import com.ca1.utils.DatabaseConnection;
import com.ca1.models.Feedback;

public class FeedBackDAO{
    private Connection connection;

    // Constructor that initializes the connection
    public FeedBackDAO() {
        try {
            this.connection = DatabaseConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<Feedback> getFeedbackByServiceId(int serviceId) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.*, u.username, u.avatar FROM feedback f JOIN users u ON f.customer_id = u.user_id WHERE f.service_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setId(rs.getInt("feedback_id"));
                feedback.setCustomerId(rs.getInt("customer_id"));
                feedback.setServiceId(rs.getInt("service_id"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setComment(rs.getString("comments"));
                feedback.setBookingId(rs.getInt("booking_id"));
                feedback.setFeedbackDate(rs.getDate("submitted_at")); 
                feedback.setAvatar(rs.getString("avatar"));
                feedback.setCustomerName(rs.getString("username"));
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public boolean addFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (customer_id, service_id, booking_id, rating, comments) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, feedback.getCustomerId());
            stmt.setInt(2, feedback.getServiceId());
            stmt.setInt(3, feedback.getBookingId());
            stmt.setInt(4, feedback.getRating());
            stmt.setString(5, feedback.getComment());
            
            // Execute the insert statement
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0; // Return true if feedback was successfully inserted
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Return false if an error occurred
        }
    }

}