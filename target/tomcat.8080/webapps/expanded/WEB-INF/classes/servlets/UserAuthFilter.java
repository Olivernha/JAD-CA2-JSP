package servlets;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UserAuthFilter implements Filter{
    // Initialization if needed
	  @Override
	public void init(FilterConfig filterConfig) throws ServletException {
	        // Initialization if needed
	    }
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession();
        Object user = session.getAttribute("userID");
        // Check if the user is logged in and has the "admin" role
        if (user != null) {
            // Allow the request to proceed
            chain.doFilter(request, response);
        } else {
            // Redirect to login or unauthorized page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/unauthorized.jsp");
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
