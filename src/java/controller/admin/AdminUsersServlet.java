package controller.admin;

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
import java.util.List;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User currentUser = SessionUtil.getUser(session);
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        // Get all users except the current admin
        List<User> users = userDAO.findAll();
        users.removeIf(user -> user.getId().equals(currentUser.getId()));
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User currentUser = SessionUtil.getUser(session);
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createUser(request, response);
                    break;
                case "update":
                    updateUser(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                case "toggleAdmin":
                    toggleAdminStatus(request, response);
                    break;
                case "resetPassword":
                    resetPassword(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Operation failed: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(PasswordUtil.hashPassword(request.getParameter("password")));
        user.setFirstName(request.getParameter("firstName"));
        user.setLastName(request.getParameter("lastName"));
        user.setAdmin(Boolean.parseBoolean(request.getParameter("isAdmin")));

        try {
            userDAO.create(user);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=created");
        } catch (Exception e) {
            request.setAttribute("error", "Failed to create user: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        User user = userDAO.findById(userId);
        
        if (user != null) {
            user.setUsername(request.getParameter("username"));
            user.setEmail(request.getParameter("email"));
            
            String newPassword = request.getParameter("password");
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                user.setPassword(PasswordUtil.hashPassword(newPassword));
            }

            try {
                userDAO.update(user);
                response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
            } catch (RuntimeException e) {
                request.setAttribute("error", "Failed to update user: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        if (userDAO.delete(userId)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
        } else {
            request.setAttribute("error", "Failed to delete user");
            doGet(request, response);
        }
    }

    private void toggleAdminStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        User user = userDAO.findById(userId);
        
        if (user != null) {
            user.setAdmin(!user.isAdmin());
            try {
                userDAO.update(user);
                response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
            } catch (RuntimeException e) {
                request.setAttribute("error", "Failed to update admin status: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
        }
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        User user = userDAO.findById(userId);
        
        if (user != null) {
            // Generate a random password
            String newPassword = PasswordUtil.generateRandomPassword();
            user.setPassword(PasswordUtil.hashPassword(newPassword));
            
            try {
                userDAO.update(user);
                // Send the new password to the view
                request.setAttribute("newPassword", newPassword);
                request.setAttribute("success", "Password reset successful");
                doGet(request, response);
            } catch (RuntimeException e) {
                request.setAttribute("error", "Failed to reset password: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
        }
    }
}
