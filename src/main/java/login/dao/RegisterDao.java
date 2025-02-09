package login.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import login.bean.LoginBean;
import login.hashing_algorithm.Bcrypt;

public class RegisterDao {
	
    private String url = "jdbc:postgresql://ep-spring-lake-a114bnaa.ap-southeast-1.aws.neon.tech/jadAssignment1?sslmode=require";
    private String user = "neondb_owner";
    private String password = "TRJNu3Qtckm6";

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(url, user, password);
    }

    public void registerUser(LoginBean user) throws SQLException, ClassNotFoundException {
        try (Connection connection = getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(
                    "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)")) {

        String hashedPassword = Bcrypt.hashpw(user.getPassword(), Bcrypt.gensalt(12));
        preparedStatement.setString(1, user.getUsername());
        preparedStatement.setString(2, user.getEmail());
        preparedStatement.setString(3, hashedPassword);
        preparedStatement.setString(4, user.getRole());
        preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        }
    }
}
