package utils;

import model.User;
import jakarta.servlet.http.HttpSession;

// javax move to jakarata from version ...

public class SessionUtil {
    private static final String USER_SESSION_KEY = "user";
    
    public static void setUser(HttpSession session, User user) {
        session.setAttribute(USER_SESSION_KEY, user);
    }
    
    public static User getUser(HttpSession session) {
        return (User) session.getAttribute(USER_SESSION_KEY);
    }
    
    public static boolean isLoggedIn(HttpSession session) {
        return getUser(session) != null;
    }
    
    public static boolean isAdmin(HttpSession session) {
        User user = getUser(session);
        return user != null && user.isAdmin();
    }
    
    public static void clearSession(HttpSession session) {
        session.invalidate();
    }
}
