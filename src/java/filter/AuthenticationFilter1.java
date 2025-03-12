package filter;

import utils.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthenticationFilter1 implements Filter {
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
        "/login", "/register", "/", "/index.jsp", 
        "/products", "/categories",
        "/css/", "/js/", "/images/"
    );
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String path = httpRequest.getServletPath();
        
        // Allow public paths
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        if (!SessionUtil.isLoggedIn(httpRequest.getSession())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        // Check admin paths
        if (path.startsWith("/admin") && !SessionUtil.isAdmin(httpRequest.getSession())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
    }
    
    private boolean isPublicPath(String path) {
        return PUBLIC_PATHS.stream().anyMatch(publicPath -> 
            path.equals(publicPath) || path.startsWith(publicPath));
    }
}
