package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.Instant;
import utils.DatabaseUtil;
import utils.PasswordUtil;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        System.out.println("Received token: " + token);
        
        if (token == null || token.trim().isEmpty()) {
            System.out.println("Token is null or empty");
            response.sendRedirect("forgot-password.jsp");
            return;
        }
        
        try {
            Connection conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, expiry_time FROM password_reset_tokens " +
                        "WHERE token = ? AND used = 0 AND expiry_time > ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            Timestamp currentTime = Timestamp.from(Instant.now());
            ps.setTimestamp(2, currentTime);
            
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                System.out.println("Token not found or expired");
                request.setAttribute("error", "Invalid or expired reset token.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Store the token in the session to prevent tampering
            request.getSession().setAttribute("reset_token", token);
            
            // Forward to reset password form
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again later.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get token from session instead of parameter to prevent tampering
        String token = (String) request.getSession().getAttribute("reset_token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (token == null) {
            request.setAttribute("error", "Invalid reset token. Please request a new password reset.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        if (password == null || confirmPassword == null) {
            request.setAttribute("error", "Missing required parameters.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }
        
        try {
            Connection conn = DatabaseUtil.getConnection();
            
            // Verify token and get user
            PreparedStatement ps = conn.prepareStatement(
                "SELECT user_id FROM password_reset_tokens " +
                "WHERE token = ? AND used = 0 AND expiry_time > ?"
            );
            ps.setString(1, token);
            ps.setTimestamp(2, Timestamp.from(Instant.now()));
            
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                request.setAttribute("error", "Invalid or expired reset token.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }
            
            long userId = rs.getLong("user_id");
            
            // Update password
            ps = conn.prepareStatement(
                "UPDATE users SET password = ? WHERE id = ?"
            );
            ps.setString(1, PasswordUtil.hashPassword(password));
            ps.setLong(2, userId);
            ps.executeUpdate();
            
            // Mark token as used
            ps = conn.prepareStatement(
                "UPDATE password_reset_tokens SET used = 1 WHERE token = ?"
            );
            ps.setString(1, token);
            ps.executeUpdate();
            
            // Clear the reset token from session
            request.getSession().removeAttribute("reset_token");
            
            // Redirect to login with success message
            request.getSession().setAttribute("success", "Your password has been reset successfully. Please login with your new password.");
            response.sendRedirect("login.jsp");
            
        } catch (Exception e) {
            System.out.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again later.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }
}
