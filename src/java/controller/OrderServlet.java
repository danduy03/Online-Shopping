package controller;

import dao.OrderDAO;
import model.Order;
import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        User user = SessionUtil.getUser(request.getSession());
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        
        // If no path info or root path, show order list
        if (pathInfo == null || "/".equals(pathInfo)) {
            List<Order> orders = orderDAO.findByUserId(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/orders.jsp").forward(request, response);
            return;
        }
        
        // If path contains ID, show order details
        try {
            String orderId = pathInfo.substring(1); // Remove leading slash
            Order order = orderDAO.findById(Long.parseLong(orderId));
            
            // Verify order belongs to current user
            if (order == null || !order.getUserId().equals(user.getId())) {
                response.sendRedirect("products");
                return;
            }
            
            request.setAttribute("order", order);
            request.getRequestDispatcher("/order-details.jsp").forward(request, response);
        } catch (NumberFormatException | IndexOutOfBoundsException e) {
            response.sendRedirect("products");
        }
    }
}
