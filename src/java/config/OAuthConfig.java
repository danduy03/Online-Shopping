package config;

public class OAuthConfig {
    // Google OAuth2 settings
    public static final String GOOGLE_CLIENT_ID = "845437712738-af1igi6mjv1tr8pgc510sjqv965bp1bq.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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";
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:9999/Ecomere/oauth2/google/callback";
    public static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    public static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";
    public static final String GOOGLE_SCOPE = "email profile openid";

    // Facebook OAuth2 settings
    public static final String FACEBOOK_CLIENT_ID = "your-facebook-client-id";
    public static final String FACEBOOK_CLIENT_SECRET = "your-facebook-client-secret";
    public static final String FACEBOOK_REDIRECT_URI = "http://localhost:9999/Ecomere/oauth2/facebook/callback";
    public static final String FACEBOOK_AUTH_URL = "https://www.facebook.com/v12.0/dialog/oauth";
    public static final String FACEBOOK_TOKEN_URL = "https://graph.facebook.com/v12.0/oauth/access_token";
    public static final String FACEBOOK_USER_INFO_URL = "https://graph.facebook.com/me?fields=id,name,email";

    // Microsoft OAuth2 settings
    public static final String MICROSOFT_CLIENT_ID = "your-microsoft-client-id";
    public static final String MICROSOFT_CLIENT_SECRET = "your-microsoft-client-secret";
    public static final String MICROSOFT_REDIRECT_URI = "http://localhost:9999/Ecomere/oauth2/microsoft/callback";
    public static final String MICROSOFT_AUTH_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize";
    public static final String MICROSOFT_TOKEN_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
    public static final String MICROSOFT_USER_INFO_URL = "https://graph.microsoft.com/v1.0/me";

    // Apple OAuth2 settings
    public static final String APPLE_CLIENT_ID = "your-apple-client-id";
    public static final String APPLE_TEAM_ID = "your-apple-team-id";
    public static final String APPLE_KEY_ID = "your-apple-key-id";
    public static final String APPLE_PRIVATE_KEY = "your-apple-private-key";
    public static final String APPLE_REDIRECT_URI = "http://localhost:9999/Ecomere/oauth2/apple/callback";
    public static final String APPLE_AUTH_URL = "https://appleid.apple.com/auth/authorize";
    public static final String APPLE_TOKEN_URL = "https://appleid.apple.com/auth/token";

    // Email settings for password reset
    public static final String SMTP_HOST = "smtp.gmail.com";
    public static final int SMTP_PORT = 587;
    public static final String SMTP_USERNAME = "luongdanduy03@gmail.com"; // Replace with your Gmail address
    public static final String SMTP_PASSWORD = "uckl chmh njvj wwzw"; // Replace with your App Password
}
