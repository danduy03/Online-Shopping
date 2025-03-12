package servlet;

import config.OAuthConfig;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login/google")
public class GoogleLoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Generate state parameter to prevent CSRF
        String state = generateState();
        HttpSession session = request.getSession();
        session.setAttribute("oauth2_state", state);
        
        // Build the authorization URL
        String authUrl = OAuthConfig.GOOGLE_AUTH_URL +
                "?client_id=" + OAuthConfig.GOOGLE_CLIENT_ID +
                "&redirect_uri=" + URLEncoder.encode(OAuthConfig.GOOGLE_REDIRECT_URI, StandardCharsets.UTF_8) +
                "&response_type=code" +
                "&scope=" + URLEncoder.encode(OAuthConfig.GOOGLE_SCOPE, StandardCharsets.UTF_8) +
                "&state=" + state +
                "&access_type=offline" + // This allows us to get a refresh token
                "&prompt=consent"; // This forces Google to show the consent screen
        
        // Redirect to Google's authorization page
        response.sendRedirect(authUrl);
    }
    
    private String generateState() {
        // Generate a random string for CSRF protection
        return java.util.UUID.randomUUID().toString();
    }
}
