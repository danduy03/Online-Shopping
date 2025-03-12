package filter;

import dao.MarketingBannerDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import model.MarketingBanner;
import java.io.IOException;
import java.util.List;

@WebFilter(urlPatterns = {"/", "/index.jsp"})
public class MarketingBannerFilter implements Filter {
    private MarketingBannerDAO bannerDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        bannerDAO = new MarketingBannerDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI();
        
        // Load banners based on page context
        loadBannersForPage(httpRequest, requestURI);
        
        chain.doFilter(request, response);
    }

    private void loadBannersForPage(HttpServletRequest request, String requestURI) {
        // Above Navbar banners (global)
        List<MarketingBanner> aboveNavbarBanners = bannerDAO.getActiveBannersByPosition("ABOVE_NAVBAR");
        request.setAttribute("aboveNavbarBanners", aboveNavbarBanners);

        // Home page banners
        if (isHomePage(requestURI)) {
            request.setAttribute("topBanners", bannerDAO.getActiveBannersByPosition("HOME_TOP"));
            request.setAttribute("middleBanners", bannerDAO.getActiveBannersByPosition("HOME_MIDDLE"));
            request.setAttribute("bottomBanners", bannerDAO.getActiveBannersByPosition("HOME_BOTTOM"));
        }

        // Category page banners
        if (isCategoryPage(requestURI)) {
            request.setAttribute("categoryTopBanners", bannerDAO.getActiveBannersByPosition("CATEGORY_TOP"));
            request.setAttribute("categoryBottomBanners", bannerDAO.getActiveBannersByPosition("CATEGORY_BOTTOM"));
        }

        // Sidebar banners (global)
        request.setAttribute("sidebarTopBanners", bannerDAO.getActiveBannersByPosition("SIDEBAR_TOP"));
        request.setAttribute("sidebarBottomBanners", bannerDAO.getActiveBannersByPosition("SIDEBAR_BOTTOM"));

        // Product page banners
        if (isProductPage(requestURI)) {
            request.setAttribute("productPageBanners", bannerDAO.getActiveBannersByPosition("PRODUCT_PAGE"));
        }

        // Checkout page banners
        if (isCheckoutPage(requestURI)) {
            request.setAttribute("checkoutPageBanners", bannerDAO.getActiveBannersByPosition("CHECKOUT_PAGE"));
        }
    }

    private boolean isHomePage(String uri) {
        return uri.endsWith("/") || uri.endsWith("/index.jsp");
    }

    private boolean isCategoryPage(String uri) {
        return uri.contains("/category/") || uri.contains("/products");
    }

    private boolean isProductPage(String uri) {
        return uri.contains("/product/");
    }

    private boolean isCheckoutPage(String uri) {
        return uri.contains("/checkout");
    }

    @Override
    public void destroy() {
    }
}
