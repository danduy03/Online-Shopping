package controller.admin;

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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrdersServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        orderItemDAO = new OrderItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = SessionUtil.getUser(session);
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        String action = request.getParameter("action");
        String orderId = request.getParameter("id");

        if ("view".equals(action) && orderId != null) {
            try {
                // Show order details in modal
                Order order = orderDAO.findById(Long.parseLong(orderId));
                if (order != null) {
                    // Load order items with product details
                    List<OrderItem> orderItems = orderItemDAO.findByOrderId(order.getId());
                    
                    // Debug information
                    System.out.println("Order found: #" + order.getId());
                    System.out.println("Customer: " + order.getFullName());
                    System.out.println("Items count: " + (orderItems != null ? orderItems.size() : 0));
                    
                    request.setAttribute("order", order);
                    request.setAttribute("orderItems", orderItems);
                    request.getRequestDispatcher("/admin/order-details-modal.jsp")
                          .include(request, response);
                    return;
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                                 "Error loading order details: " + e.getMessage());
                return;
            }
        } else {
            // Show orders list
            List<Order> orders = orderDAO.findAll();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = SessionUtil.getUser(session);
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "updateStatus":
                    updateOrderStatus(request, response);
                    break;
                case "delete":
                    deleteOrder(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Operation failed: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long orderId = Long.parseLong(request.getParameter("id"));
            String status = request.getParameter("status");
            
            if (orderId == null || status == null || status.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Order ID and status are required");
                return;
            }
            
            Order order = orderDAO.findById(orderId);
            if (order == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Order not found");
                return;
            }
            
            // Check if trying to mark as delivered without previous processing/shipped status
            if (status.equalsIgnoreCase("DELIVERED") && 
                !order.getStatus().equalsIgnoreCase("PROCESSING") && 
                !order.getStatus().equalsIgnoreCase("SHIPPED")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Order must be processed or shipped before marking as delivered");
                return;
            }
            
            // Check if trying to process a cancelled order
            if (order.getStatus().equalsIgnoreCase("CANCELLED") && 
                !status.equalsIgnoreCase("CANCELLED")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Cannot update status of cancelled order");
                return;
            }
            
            if (orderDAO.updateStatus(orderId, status)) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Order status updated successfully");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Failed to update order status");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid order ID format");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long orderId = Long.parseLong(request.getParameter("id"));
        if (orderDAO.delete(orderId)) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?success=deleted");
        } else {
            request.setAttribute("error", "Failed to delete order");
            doGet(request, response);
        }
    }
}
