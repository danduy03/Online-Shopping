package controller;

import dao.CartDAO;
import dao.OrderDAO;
import model.Cart;
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
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private static final BigDecimal SHIPPING_COST = new BigDecimal("5.00");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        User user = SessionUtil.getUser(request.getSession());
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Get cart items
        List<Cart> cartItems = cartDAO.findByUserId(user.getId());
        if (cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        // Calculate subtotal
        BigDecimal subtotal = cartItems.stream()
                .map(item -> item.getProduct().getPrice().multiply(new BigDecimal(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Get discount from session if any
        HttpSession session = request.getSession();
        BigDecimal discount = BigDecimal.ZERO;
        if (session.getAttribute("appliedDiscount") != null) {
            discount = new BigDecimal(session.getAttribute("appliedDiscount").toString());
        }

        // Calculate total with shipping and discount
        BigDecimal total = subtotal.add(SHIPPING_COST).subtract(discount);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shipping", SHIPPING_COST);
        request.setAttribute("discount", discount);
        request.setAttribute("total", total);
        
        // Store cart total in session for discount calculation
        session.setAttribute("cartTotal", subtotal.doubleValue());
        
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Set character encoding for request
            request.setCharacterEncoding("UTF-8");
            
            User user = SessionUtil.getUser(request.getSession());
            if (user == null) {
                out.write("{\"success\": false, \"message\": \"Please login to continue.\"}");
                return;
            }

            // Get and validate form data
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String province = request.getParameter("provinceText"); // Get the text value
            String district = request.getParameter("districtText"); // Get the text value
            String commune = request.getParameter("communeText");   // Get the text value
            String address = request.getParameter("address");
            String notes = request.getParameter("notes");
            String discountCode = request.getParameter("discountCode");
            String paymentMethod = request.getParameter("paymentMethod");

            // Debug log all parameters
            System.out.println("\nAll request parameters:");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                System.out.println(paramName + ": " + request.getParameter(paramName));
            }

            // Validate required fields
            StringBuilder missingFields = new StringBuilder();
            if (isNullOrEmpty(fullName)) missingFields.append("Full Name, ");
            if (isNullOrEmpty(phone)) missingFields.append("Phone Number, ");
            if (isNullOrEmpty(province)) missingFields.append("Province, ");
            if (isNullOrEmpty(district)) missingFields.append("District, ");
            if (isNullOrEmpty(commune)) missingFields.append("Commune, ");
            if (isNullOrEmpty(address)) missingFields.append("Address, ");
            if (isNullOrEmpty(paymentMethod)) missingFields.append("Payment Method, ");

            if (missingFields.length() > 0) {
                String fields = missingFields.substring(0, missingFields.length() - 2); // Remove last comma
                out.write("{\"success\": false, \"message\": \"Please fill in all required fields: " + fields + "\"}");
                return;
            }

            // Get cart items
            List<Cart> cartItems = cartDAO.findByUserId(user.getId());
            if (cartItems.isEmpty()) {
                out.write("{\"success\": false, \"message\": \"Your cart is empty.\"}");
                return;
            }

            // Calculate subtotal
            BigDecimal subtotal = cartItems.stream()
                    .map(item -> item.getProduct().getPrice().multiply(new BigDecimal(item.getQuantity())))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Get discount from session
            HttpSession session = request.getSession();
            BigDecimal discount = BigDecimal.ZERO;
            if (session.getAttribute("appliedDiscount") != null) {
                discount = new BigDecimal(session.getAttribute("appliedDiscount").toString());
            }

            // Calculate final total
            BigDecimal total = subtotal.add(SHIPPING_COST).subtract(discount);

            // Create order
            Order order = new Order();
            order.setUserId(user.getId());
            order.setFullName(fullName);
            order.setPhone(phone);
            order.setEmail(email);
            order.setProvince(province);
            order.setDistrict(district);
            order.setCommune(commune);
            order.setAddress(address);
            order.setNotes(notes);
            order.setDiscountCode(discountCode);
            order.setDiscountAmount(discount);
            order.setShippingCost(SHIPPING_COST);
            order.setSubtotal(subtotal);
            order.setTotalAmount(total);
            order.setStatus("PENDING");

            // Debug log order details
            System.out.println("\nOrder details being saved:");
            System.out.println("Full Name: " + order.getFullName());
            System.out.println("Phone: " + order.getPhone());
            System.out.println("Email: " + order.getEmail());
            System.out.println("Province: " + order.getProvince());
            System.out.println("District: " + order.getDistrict());
            System.out.println("Commune: " + order.getCommune());
            System.out.println("Address: " + order.getAddress());
            System.out.println("Payment Method: " + paymentMethod);

            // Create order items
            List<OrderItem> orderItems = new ArrayList<>();
            for (Cart cartItem : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(cartItem.getProductId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getProduct().getPrice());
                orderItems.add(orderItem);
            }

            // Save order and items
            if (orderDAO.createOrder(order, orderItems)) {
                // Clear cart and discount after successful order
                cartDAO.clearCart(user.getId());
                session.removeAttribute("appliedDiscount");
                session.removeAttribute("cartTotal");
                
                out.write("{\"success\": true, \"redirectUrl\": \"order-detail?id=" + order.getId() + "\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Failed to save order to database. Please try again.\"}");
            }
            
        } catch (Exception e) {
            System.err.println("\nError in CheckoutServlet:");
            e.printStackTrace(System.err);
            out.write("{\"success\": false, \"message\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }

    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
