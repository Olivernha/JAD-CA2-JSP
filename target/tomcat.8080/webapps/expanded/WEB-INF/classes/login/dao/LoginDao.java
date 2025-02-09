package login.dao;

import java.sql.*;
import login.bean.LoginBean;
import login.hashing_algorithm.Bcrypt;

public class LoginDao {
    private String url = "jdbc:postgresql://ep-spring-lake-a114bnaa.ap-southeast-1.aws.neon.tech/jadAssignment1?sslmode=require";
    private String user = "neondb_owner";
    private String password = "TRJNu3Qtckm6";

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(url, user, password);
    }

    public boolean validate(LoginBean loginBean) throws SQLException, ClassNotFoundException {
        boolean status = false;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(
                 "SELECT password FROM users WHERE email = ?")) {
            preparedStatement.setString(1, loginBean.getEmail());
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                status = Bcrypt.checkpw(loginBean.getPassword(), hashedPassword);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return status;
    }

    public String getUsernameByID(int user_id) throws SQLException, ClassNotFoundException {
    	
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "SELECT username FROM users WHERE user_id = ?")) {
            statement.setInt(1, user_id);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getString("username");
            }
        }
        catch(SQLException e) {
        	printSQLException(e);
        }
        return null;
    }

    public String getUserIdByEmail(String email) throws SQLException, ClassNotFoundException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "SELECT user_id FROM users WHERE email = ?")) {
            statement.setString(1, email);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getString("user_id");
            }
        }
        catch(SQLException e) {
        	printSQLException(e);
        }
        return null;
    }
    
    public String getRoleByEmail(String email) throws SQLException, ClassNotFoundException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "SELECT role FROM users WHERE email = ?")) {
            statement.setString(1, email);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getString("role");
            }
        }
        catch(SQLException e) {
        	printSQLException(e);
        }
        return null;
    }
    


    private void printSQLException(SQLException ex) {
        for (Throwable e: ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }

}
