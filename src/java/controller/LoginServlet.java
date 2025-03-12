package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            // Validate input
            if (username == null || username.trim().isEmpty() || 
                password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Username and password are required");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Find user
            User user = userDAO.findByUsername(username.trim());
            if (user == null) {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Verify password (simple comparison for now)
            if (!password.equals(user.getPassword())) {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Store user in session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Check if there's a requested URL to redirect to
            String requestedUrl = (String) session.getAttribute("requestedUrl");
            
            // Clear the stored URL
            session.removeAttribute("requestedUrl");
            
            // Redirect based on role and requested URL
            if (requestedUrl != null && requestedUrl.contains("/admin/")) {
                if (user.isAdmin()) {
                    response.sendRedirect(requestedUrl);
                } else {
                    // If non-admin tries to access admin page, redirect to home
                    request.setAttribute("error", "You do not have admin privileges");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            
        } catch (Exception e) {
            // Log the error
            System.err.println("Login error: " + e.getMessage());
            e.printStackTrace();
            
            // Set error message
            request.setAttribute("error", "An error occurred during login");
            request.setAttribute("username", username); // Preserve username
            
            // Forward back to login page
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            return;
        }
        
        // Show login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
