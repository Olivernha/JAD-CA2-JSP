package com.ca1.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:postgresql://ep-spring-lake-a114bnaa.ap-southeast-1.aws.neon.tech/jadAssignment1";
    private static final String USER = "neondb_owner";
    private static final String PASSWORD = "TRJNu3Qtckm6";

    public static Connection getConnection() throws SQLException {
        try {
            // Load the PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC driver not found", e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
