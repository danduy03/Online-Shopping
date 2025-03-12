package servlet;

import utils.EmailUtils;
import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DatabaseUtil;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email address is required.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        try {
            Connection conn = DatabaseUtil.getConnection();
            
            // Check if email exists
            PreparedStatement ps = conn.prepareStatement(
                "SELECT id FROM users WHERE email = ?"
            );
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (!rs.next()) {
                request.setAttribute("error", "Email address not found.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }
            
            long userId = rs.getLong("id");
            
            // Delete any existing unused tokens for this user
            ps = conn.prepareStatement(
                "UPDATE password_reset_tokens SET used = 1 WHERE user_id = ? AND used = 0"
            );
            ps.setLong(1, userId);
            ps.executeUpdate();
            
            // Generate reset token
            String token = generateToken();
            Timestamp expiryTime = Timestamp.from(Instant.now().plusSeconds(3600)); // 1 hour expiry
            
            // Save reset token
            ps = conn.prepareStatement(
                "INSERT INTO password_reset_tokens (user_id, token, expiry_time, used) VALUES (?, ?, ?, 0)"
            );
            ps.setLong(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiryTime);
            ps.executeUpdate();
            
            System.out.println("Generated token: " + token); // Debug log
            
            // Send reset email with just the token
            EmailUtils.sendPasswordResetEmail(email, token);
            
            request.setAttribute("success", "Password reset instructions have been sent to your email.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in ForgotPasswordServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again later.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
    
    private String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
