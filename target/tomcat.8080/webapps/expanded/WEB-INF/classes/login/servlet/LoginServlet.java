package login.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Base64;

import login.bean.LoginBean;
import login.dao.LoginDao;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LoginDao loginDao;

    public void init() {
        loginDao = new LoginDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        LoginBean loginBean = new LoginBean();
        loginBean.setEmail(email);
        loginBean.setPassword(password);

        try {
            if (loginDao.validate(loginBean)) {
                HttpSession session = request.getSession();

                Integer userId = Integer.parseInt(loginDao.getUserIdByEmail(email));
                String username = loginDao.getUsernameByID(userId);
                String role = loginDao.getRoleByEmail(email);
                session.setAttribute("username",username);
                session.setAttribute("userID", userId);
                session.setAttribute("role", role);
                session.setMaxInactiveInterval(30 * 60); // Set session timeout

                if ("Admin".equals(role)) {
                    response.sendRedirect("admin/dashboard/index.jsp");
                } else {
                    response.sendRedirect("user/home.jsp");
                }
            } else {
                response.sendRedirect("user/loginRegister.jsp?error=Invalid email or password");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Login failed due to server error.");
        }
    }

    private String generateSecureToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[30];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
