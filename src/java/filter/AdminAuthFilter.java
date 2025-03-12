package filter;

import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in and is admin
        boolean isLoggedIn = session != null && session.getAttribute("user") != null;
        boolean isAdmin = false;
        
        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            isAdmin = user.isAdmin();
        }
        
        // If user is not logged in or is not admin, redirect to login
        if (!isLoggedIn || !isAdmin) {
            // Store the requested URL for redirect after login
            if (session != null) {
                String requestedUrl = httpRequest.getRequestURI();
                if (httpRequest.getQueryString() != null) {
                    requestedUrl += "?" + httpRequest.getQueryString();
                }
                session.setAttribute("requestedUrl", requestedUrl);
            }
            
            // Set error message
            request.setAttribute("error", "Admin access required. Please log in with an admin account.");
            
            // Redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        // User is admin, proceed with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
    }
}
