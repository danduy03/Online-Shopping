package controller.admin;

import com.google.gson.Gson;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.UserDAO;
import model.Order;
import model.Product;
import utils.SessionUtil;
import model.DashboardStats;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(urlPatterns = {"/admin/dashboard", "/admin/dashboard/data", "/admin/dashboard/export"})
public class AdminDashboardServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        if (!SessionUtil.isAdmin(request.getSession())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getServletPath();
        if (pathInfo.endsWith("/data")) {
            handleDataRequest(request, response);
        } else if (pathInfo.endsWith("/export")) {
            handleExportRequest(request, response);
        } else {
            handleDashboardRequest(request, response);
        }
    }
    
    private void handleDashboardRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get date range (default to last 30 days)
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = endDate.minusDays(30);
        
        // Get statistics
        DashboardStats stats = getDashboardStats(startDate, endDate);
        
        // Set attributes
        request.setAttribute("totalOrders", stats.getTotalOrders());
        request.setAttribute("totalRevenue", stats.getTotalRevenue());
        request.setAttribute("averageOrderValue", stats.getAverageOrderValue());
        request.setAttribute("conversionRate", stats.getConversionRate());
        
        // Set growth percentages
        request.setAttribute("orderGrowth", stats.getOrderGrowth());
        request.setAttribute("revenueGrowth", stats.getRevenueGrowth());
        request.setAttribute("aovGrowth", stats.getAovGrowth());
        request.setAttribute("conversionGrowth", stats.getConversionGrowth());
        
        // Get recent orders
        List<Order> recentOrders = orderDAO.getRecentOrders(10);
        request.setAttribute("recentOrders", recentOrders);
        
        // Get top products
        List<Product> topProducts = productDAO.getTopSellingProducts(5);
        request.setAttribute("topProducts", topProducts);
        
        // Set chart data
        Map<String, Object> chartData = getChartData(startDate, endDate);
        request.setAttribute("revenueChartLabels", gson.toJson(chartData.get("revenueLabels")));
        request.setAttribute("revenueChartData", gson.toJson(chartData.get("revenueData")));
        request.setAttribute("categoryChartLabels", gson.toJson(chartData.get("categoryLabels")));
        request.setAttribute("categoryChartData", gson.toJson(chartData.get("categoryData")));
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    private void handleDataRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Parse date range
        String range = request.getParameter("range");
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate;
        
        if ("custom".equals(range)) {
            DateTimeFormatter formatter = DateTimeFormatter.ISO_DATE;
            startDate = LocalDateTime.parse(request.getParameter("start"), formatter);
            endDate = LocalDateTime.parse(request.getParameter("end"), formatter);
        } else {
            int days = Integer.parseInt(range);
            startDate = endDate.minusDays(days);
        }
        
        // Get dashboard data
        DashboardStats stats = getDashboardStats(startDate, endDate);
        Map<String, Object> chartData = getChartData(startDate, endDate);
        
        // Combine all data
        Map<String, Object> dashboardData = new HashMap<>();
        dashboardData.put("stats", stats);
        dashboardData.put("chartData", chartData);
        
        // Send JSON response
        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(dashboardData));
    }
    
    private void handleExportRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String format = request.getParameter("format");
        String range = request.getParameter("range");
        
        // Get date range
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate;
        
        if ("custom".equals(range)) {
            DateTimeFormatter formatter = DateTimeFormatter.ISO_DATE;
            startDate = LocalDateTime.parse(request.getParameter("start"), formatter);
            endDate = LocalDateTime.parse(request.getParameter("end"), formatter);
        } else {
            int days = Integer.parseInt(range);
            startDate = endDate.minusDays(days);
        }
        
        // Get data for export
        DashboardStats stats = getDashboardStats(startDate, endDate);
        List<Order> orders = orderDAO.getOrdersByDateRange(startDate, endDate);
        List<Product> topProducts = productDAO.getTopSellingProducts(10);
        
        // Export functionality temporarily disabled
        response.setContentType("text/plain");
        response.getWriter().write("Export functionality is currently under maintenance.");
    }
    
    private DashboardStats getDashboardStats(LocalDateTime startDate, LocalDateTime endDate) {
        DashboardStats stats = new DashboardStats();
        
        // Current period stats
        stats.setTotalOrders(orderDAO.getTotalOrdersByDateRange(startDate, endDate));
        stats.setTotalRevenue(orderDAO.getTotalRevenueByDateRange(startDate, endDate));
        stats.setAverageOrderValue(orderDAO.getAverageOrderValueByDateRange(startDate, endDate));
        stats.setConversionRate(calculateConversionRate(startDate, endDate));
        
        // Calculate previous period dates
        long daysBetween = ChronoUnit.DAYS.between(startDate, endDate);
        LocalDateTime previousStart = startDate.minusDays(daysBetween);
        LocalDateTime previousEnd = startDate;
        
        // Previous period stats for growth calculation
        int previousOrders = orderDAO.getTotalOrdersByDateRange(previousStart, previousEnd);
        BigDecimal previousRevenue = orderDAO.getTotalRevenueByDateRange(previousStart, previousEnd);
        BigDecimal previousAOV = orderDAO.getAverageOrderValueByDateRange(previousStart, previousEnd);
        double previousConversion = calculateConversionRate(previousStart, previousEnd);
        
        // Calculate growth percentages
        stats.setOrderGrowth(calculateGrowth(previousOrders, stats.getTotalOrders()));
        stats.setRevenueGrowth(calculateGrowth(previousRevenue, stats.getTotalRevenue()));
        stats.setAovGrowth(calculateGrowth(previousAOV, stats.getAverageOrderValue()));
        stats.setConversionGrowth(calculateGrowth(previousConversion, stats.getConversionRate()));
        
        return stats;
    }
    
    private Map<String, Object> getChartData(LocalDateTime startDate, LocalDateTime endDate) {
        Map<String, Object> chartData = new HashMap<>();
        
        // Revenue trend data
        List<LocalDateTime> dates = new ArrayList<>();
        List<BigDecimal> revenues = new ArrayList<>();
        LocalDateTime current = startDate;
        
        while (!current.isAfter(endDate)) {
            dates.add(current);
            revenues.add(orderDAO.getTotalRevenueByDate(current));
            current = current.plusDays(1);
        }
        
        // Format dates for chart labels
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd");
        List<String> revenueLabels = dates.stream()
                .map(date -> date.format(formatter))
                .toList();
        
        // Category data
        Map<String, BigDecimal> categoryRevenue = orderDAO.getRevenueByCategoryByDateRange(startDate, endDate);
        List<String> categoryLabels = new ArrayList<>(categoryRevenue.keySet());
        List<BigDecimal> categoryData = categoryLabels.stream()
                .map(categoryRevenue::get)
                .toList();
        
        chartData.put("revenueLabels", revenueLabels);
        chartData.put("revenueData", revenues);
        chartData.put("categoryLabels", categoryLabels);
        chartData.put("categoryData", categoryData);
        
        return chartData;
    }
    
    private double calculateConversionRate(LocalDateTime startDate, LocalDateTime endDate) {
        int totalVisitors = userDAO.getTotalVisitorsByDateRange(startDate, endDate);
        int totalOrders = orderDAO.getTotalOrdersByDateRange(startDate, endDate);
        return totalVisitors > 0 ? (double) totalOrders / totalVisitors * 100 : 0;
    }
    
    private double calculateGrowth(Number previous, Number current) {
        double prev = previous.doubleValue();
        double curr = current.doubleValue();
        return prev > 0 ? ((curr - prev) / prev) * 100 : 0;
    }
}
