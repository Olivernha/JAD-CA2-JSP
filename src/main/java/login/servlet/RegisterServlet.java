package login.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import login.bean.LoginBean;
import login.dao.LoginDao;
import login.dao.RegisterDao;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RegisterDao registerDao;

    public void init() {
        registerDao = new RegisterDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Create a LoginBean object
        LoginBean newUser = new LoginBean();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setRole("Customer");
        newUser.setPassword(password);

        try {
            registerDao.registerUser(newUser);
            HttpSession session = request.getSession();
            session.setAttribute("status", true);
            response.sendRedirect("user/loginRegister.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("status_err", true);
            response.sendRedirect("user/loginRegister.jsp");
        }
    }
}
	