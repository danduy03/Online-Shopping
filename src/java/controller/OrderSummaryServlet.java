package controller;

import dao.OrderDAO;
import dao.OrderItemDAO;
import model.Order;
import model.OrderItem;
import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/summary-order")
public class OrderSummaryServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        User user = SessionUtil.getUser(request.getSession());
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Get order ID from request
            String orderId = request.getParameter("id");
            if (orderId == null || orderId.trim().isEmpty()) {
                response.sendRedirect("orders");
                return;
            }

            // Get order details
            Order order = orderDAO.findById(Long.parseLong(orderId));
            
            // Verify order exists and belongs to current user
            if (order == null || !order.getUserId().equals(user.getId())) {
                response.sendRedirect("orders");
                return;
            }

            // Get order items
            List<OrderItem> orderItems = orderItemDAO.findByOrderId(order.getId());
            order.setOrderItems(orderItems);

            // Set attributes for JSP
            request.setAttribute("order", order);
            
            // Forward to summary page
            request.getRequestDispatcher("/order-summary.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("orders");
        }
    }
}
