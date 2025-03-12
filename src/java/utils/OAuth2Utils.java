package utils;

import config.OAuthConfig;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import org.json.JSONObject;

public class OAuth2Utils {
    
    public static String getAuthorizationUrl(String provider) {
        switch (provider.toLowerCase()) {
            case "google":
                return OAuthConfig.GOOGLE_AUTH_URL +
                       "?client_id=" + OAuthConfig.GOOGLE_CLIENT_ID +
                       "&redirect_uri=" + URLEncoder.encode(OAuthConfig.GOOGLE_REDIRECT_URI, StandardCharsets.UTF_8) +
                       "&response_type=code" +
                       "&scope=" + URLEncoder.encode("openid email profile", StandardCharsets.UTF_8);
                
            case "facebook":
                return OAuthConfig.FACEBOOK_AUTH_URL +
                       "?client_id=" + OAuthConfig.FACEBOOK_CLIENT_ID +
                       "&redirect_uri=" + URLEncoder.encode(OAuthConfig.FACEBOOK_REDIRECT_URI, StandardCharsets.UTF_8) +
                       "&response_type=code" +
                       "&scope=" + URLEncoder.encode("email public_profile", StandardCharsets.UTF_8);
                
            case "microsoft":
                return OAuthConfig.MICROSOFT_AUTH_URL +
                       "?client_id=" + OAuthConfig.MICROSOFT_CLIENT_ID +
                       "&redirect_uri=" + URLEncoder.encode(OAuthConfig.MICROSOFT_REDIRECT_URI, StandardCharsets.UTF_8) +
                       "&response_type=code" +
                       "&scope=" + URLEncoder.encode("openid email profile", StandardCharsets.UTF_8);
                
            case "apple":
                return OAuthConfig.APPLE_AUTH_URL +
                       "?client_id=" + OAuthConfig.APPLE_CLIENT_ID +
                       "&redirect_uri=" + URLEncoder.encode(OAuthConfig.APPLE_REDIRECT_URI, StandardCharsets.UTF_8) +
                       "&response_type=code" +
                       "&scope=" + URLEncoder.encode("email name", StandardCharsets.UTF_8) +
                       "&response_mode=form_post";
                
            default:
                throw new IllegalArgumentException("Unsupported provider: " + provider);
        }
    }
    
    public static JSONObject getAccessToken(String code, String provider) throws IOException {
        String tokenUrl;
        Map<String, String> params = new HashMap<>();
        
        switch (provider.toLowerCase()) {
            case "google":
                tokenUrl = OAuthConfig.GOOGLE_TOKEN_URL;
                params.put("client_id", OAuthConfig.GOOGLE_CLIENT_ID);
                params.put("client_secret", OAuthConfig.GOOGLE_CLIENT_SECRET);
                params.put("redirect_uri", OAuthConfig.GOOGLE_REDIRECT_URI);
                break;
                
            case "facebook":
                tokenUrl = OAuthConfig.FACEBOOK_TOKEN_URL;
                params.put("client_id", OAuthConfig.FACEBOOK_CLIENT_ID);
                params.put("client_secret", OAuthConfig.FACEBOOK_CLIENT_SECRET);
                params.put("redirect_uri", OAuthConfig.FACEBOOK_REDIRECT_URI);
                break;
                
            case "microsoft":
                tokenUrl = OAuthConfig.MICROSOFT_TOKEN_URL;
                params.put("client_id", OAuthConfig.MICROSOFT_CLIENT_ID);
                params.put("client_secret", OAuthConfig.MICROSOFT_CLIENT_SECRET);
                params.put("redirect_uri", OAuthConfig.MICROSOFT_REDIRECT_URI);
                break;
                
            case "apple":
                tokenUrl = OAuthConfig.APPLE_TOKEN_URL;
                params.put("client_id", OAuthConfig.APPLE_CLIENT_ID);
                params.put("client_secret", generateAppleClientSecret());
                params.put("redirect_uri", OAuthConfig.APPLE_REDIRECT_URI);
                break;
                
            default:
                throw new IllegalArgumentException("Unsupported provider: " + provider);
        }
        
        params.put("code", code);
        params.put("grant_type", "authorization_code");
        
        return makeTokenRequest(tokenUrl, params);
    }
    
    public static JSONObject getUserInfo(String accessToken, String provider) throws IOException {
        String userInfoUrl;
        switch (provider.toLowerCase()) {
            case "google":
                userInfoUrl = OAuthConfig.GOOGLE_USER_INFO_URL;
                break;
            case "facebook":
                userInfoUrl = OAuthConfig.FACEBOOK_USER_INFO_URL;
                break;
            case "microsoft":
                userInfoUrl = OAuthConfig.MICROSOFT_USER_INFO_URL;
                break;
            case "apple":
                // Apple doesn't have a user info endpoint, user info is included in the ID token
                return new JSONObject(decodeJWT(accessToken));
            default:
                throw new IllegalArgumentException("Unsupported provider: " + provider);
        }
        
        URL url = new URL(userInfoUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String response = reader.lines().collect(Collectors.joining());
            return new JSONObject(response);
        }
    }
    
    private static JSONObject makeTokenRequest(String tokenUrl, Map<String, String> params) throws IOException {
        URL url = new URL(tokenUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);
        
        String postData = params.entrySet().stream()
                .map(e -> e.getKey() + "=" + URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8))
                .collect(Collectors.joining("&"));
        
        try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream())) {
            writer.write(postData);
        }
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String response = reader.lines().collect(Collectors.joining());
            return new JSONObject(response);
        }
    }
    
    private static String generateAppleClientSecret() {
        // Implementation for generating Apple client secret using JWT
        // This is a placeholder - you'll need to implement the actual JWT generation
        return "generated-apple-client-secret";
    }
    
    private static Map<String, String> decodeJWT(String jwt) {
        // Implementation for decoding JWT
        // This is a placeholder - you'll need to implement actual JWT decoding
        return new HashMap<>();
    }
}
