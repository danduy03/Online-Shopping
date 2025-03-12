package controller;

import dao.UserDAO;
import model.User;
import utils.SessionUtil;
import utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        
        // Validate input
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        try {
            // Check if username already exists
            User existingUser = userDAO.findByUsername(username);
            if (existingUser != null) {
                request.setAttribute("error", "Username already exists");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            existingUser = userDAO.findByEmail(email);
            if (existingUser != null) {
                request.setAttribute("error", "Email already exists");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User user = new User();
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setAdmin(false);
            
            // Create user and get back the complete user object
            user = userDAO.create(user);
            
            // Log the user in
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Redirect to home page
            response.sendRedirect(request.getContextPath() + "/");
            
        } catch (RuntimeException e) {
            // Log the error for debugging
            e.printStackTrace();
            
            // Show user-friendly error message
            request.setAttribute("error", "Registration failed. Please try again later.");
            request.setAttribute("username", username); // Preserve the form data
            request.setAttribute("email", email);
            request.setAttribute("first_name", firstName);
            request.setAttribute("last_name", lastName);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
