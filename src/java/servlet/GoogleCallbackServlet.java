package servlet;

import config.OAuthConfig;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Arrays;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import utils.DatabaseUtil;
import dao.UserDAO;
import model.User;
import java.util.Date;

@WebServlet("/oauth2/google/callback")
public class GoogleCallbackServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set character encoding for request and response
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        String error = request.getParameter("error");
        
        HttpSession session = request.getSession();
        String savedState = (String) session.getAttribute("oauth2_state");
        
        // Remove the state from session
        session.removeAttribute("oauth2_state");
        
        // Check for errors or invalid state
        if (error != null) {
            request.setAttribute("error", "Google authentication error: " + error);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        if (state == null || !state.equals(savedState)) {
            request.setAttribute("error", "Invalid state parameter. Possible CSRF attack.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Exchange code for access token
            JSONObject tokenResponse = getAccessToken(code);
            String accessToken = tokenResponse.getString("access_token");
            
            // Get user info from Google
            JSONObject userInfo = getUserInfo(accessToken);
            
            String email = new String(userInfo.getString("email").getBytes("UTF-8"), "UTF-8");
            String picture = new String(userInfo.getString("picture").getBytes("UTF-8"), "UTF-8");
            String fullName = new String(userInfo.getString("name").getBytes("UTF-8"), "UTF-8");
            
            // Try to get first and last name, fallback to splitting full name
            String firstName, lastName;
            if (userInfo.has("given_name") && userInfo.has("family_name")) {
                firstName = new String(userInfo.getString("given_name").getBytes("UTF-8"), "UTF-8");
                lastName = new String(userInfo.getString("family_name").getBytes("UTF-8"), "UTF-8");
            } else {
                // Split the full name into first and last name
                String[] nameParts = fullName.split(" ", 2);
                firstName = nameParts[0];
                lastName = nameParts.length > 1 ? nameParts[1] : "";
            }
            
            // Use email as username (without domain)
            String username = email.substring(0, email.indexOf("@"));
            
            // Find or create user
            UserDAO userDAO = new UserDAO();
            User user = null;
            try {
                user = userDAO.findByEmail(email);
            } catch (RuntimeException e) {
                throw new ServletException("Error finding user by email: " + e.getMessage(), e);
            }
            
            if (user == null) {
                try {
                    user = new User();
                    user.setUsername(username);
                    user.setEmail(email);
                    user.setFirstName(firstName);
                    user.setLastName(lastName);
                    user.setProfilePicture(picture);
                    user.setOauthProvider("google");
                    user.setOauthId(userInfo.getString("sub"));
                    user.setAdmin(false);
                    user.setRole("user");  // Explicitly set role to lowercase
                    user.setLastLogin(new Date());
                    user = userDAO.create(user);
                } catch (RuntimeException e) {
                    throw new ServletException("Error creating new user: " + e.getMessage(), e);
                }
            } else {
                // Update existing user's info
                try {
                    System.out.println("Found existing user with ID: " + user.getId());
                    System.out.println("Current user state: " + user.toString());
                    
                    // Keep existing values for fields we don't want to change
                    String existingUsername = user.getUsername();
                    String existingEmail = user.getEmail();
                    boolean isAdmin = user.isAdmin();
                    String existingAddress = user.getAddress();
                    String existingPhone = user.getPhone();
                    String existingPassword = user.getPassword();
                    
                    System.out.println("Preserved values:");
                    System.out.println("Username: " + existingUsername);
                    System.out.println("Email: " + existingEmail);
                    System.out.println("Is Admin: " + isAdmin);
                    
                    // Update with new Google information
                    user.setUsername(existingUsername); // Preserve existing username
                    user.setEmail(existingEmail); // Preserve existing email
                    user.setPassword(existingPassword); // Preserve existing password
                    user.setFirstName(firstName);
                    user.setLastName(lastName);
                    user.setAddress(existingAddress); // Preserve existing address
                    user.setPhone(existingPhone); // Preserve existing phone
                    user.setAdmin(isAdmin); // Preserve admin status
                    user.setProfilePicture(picture);
                    user.setOauthProvider("google");
                    user.setOauthId(userInfo.getString("sub"));
                    user.setLastLogin(new Date());
                    
                    System.out.println("Updated user state before update: " + user.toString());
                    
                    userDAO.update(user);
                    
                    System.out.println("User update completed successfully");
                } catch (RuntimeException e) {
                    throw new ServletException("Error updating existing user: " + e.getMessage(), e);
                }
            }
            
            // Store user in session (using the same session from above)
            session.setAttribute("user", user);
            
            // Redirect to appropriate page based on role
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Check if there's a requested URL to redirect to
                String requestedUrl = (String) session.getAttribute("requestedUrl");
                if (requestedUrl != null) {
                    session.removeAttribute("requestedUrl");
                    response.sendRedirect(requestedUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to authenticate with Google: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private JSONObject getAccessToken(String code) throws IOException {
        URL url = new URL(OAuthConfig.GOOGLE_TOKEN_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);
        
        String postData = String.format("code=%s&client_id=%s&client_secret=%s&redirect_uri=%s&grant_type=authorization_code",
                URLEncoder.encode(code, StandardCharsets.UTF_8),
                URLEncoder.encode(OAuthConfig.GOOGLE_CLIENT_ID, StandardCharsets.UTF_8),
                URLEncoder.encode(OAuthConfig.GOOGLE_CLIENT_SECRET, StandardCharsets.UTF_8),
                URLEncoder.encode(OAuthConfig.GOOGLE_REDIRECT_URI, StandardCharsets.UTF_8));
        
        try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream())) {
            writer.write(postData);
        }
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String response = reader.lines().collect(Collectors.joining());
            return new JSONObject(response);
        }
    }
    
    private JSONObject getUserInfo(String accessToken) throws IOException {
        URL url = new URL(OAuthConfig.GOOGLE_USER_INFO_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String response = reader.lines().collect(Collectors.joining());
            return new JSONObject(response);
        }
    }
}
