package controller;

import dao.CartDAO;
import dao.ProductDAO;
import model.Cart;
import model.Product;
import model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;
    private ProductDAO productDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Cart> cartItems = cartDAO.findByUserId(user.getId());
        BigDecimal total = calculateTotal(cartItems);

        session.setAttribute("cartTotal", total.doubleValue());
        session.setAttribute("cartCount", calculateTotalItems(cartItems));

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total.doubleValue());
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("success", false);
                responseMap.put("message", "Please log in to modify your cart");
                responseMap.put("requireLogin", true);
                out.print(gson.toJson(responseMap));
                return;
            }

            String action = request.getParameter("action");
            Long productId = Long.parseLong(request.getParameter("productId"));

            Map<String, Object> jsonResponse = new HashMap<>();

            switch (action) {
                case "add":
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    Product addProduct = productDAO.findById(productId);
                    if (addProduct == null) {
                        throw new IllegalStateException("Product not found");
                    }
                    addToCart(user.getId(), productId, quantity);
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Product added to cart successfully");
                    break;

                case "update":
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                    Product updatedProduct = productDAO.findById(productId);
                    if (updatedProduct == null) {
                        throw new IllegalStateException("Product not found");
                    }
                    updateCartItem(user.getId(), productId, quantity);
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Cart updated successfully");
                    break;

                case "remove":
                    Product removedProduct = productDAO.findById(productId);
                    if (removedProduct == null) {
                        throw new IllegalStateException("Product not found");
                    }
                    removeFromCart(user.getId(), productId);
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Item removed from cart");
                    break;

                default:
                    sendErrorResponse(out, "Invalid action");
                    return;
            }

            // Update cart count and total
            List<Cart> cartItems = cartDAO.findByUserId(user.getId());
            int cartCount = calculateTotalItems(cartItems);
            BigDecimal total = calculateTotal(cartItems);

            session.setAttribute("cartCount", cartCount);
            session.setAttribute("cartTotal", total.doubleValue());

            jsonResponse.put("cartCount", cartCount);
            jsonResponse.put("total", total.doubleValue());

            out.print(gson.toJson(jsonResponse));

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(out, e.getMessage());
        }
    }

    private void sendErrorResponse(PrintWriter out, String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        out.print(gson.toJson(response));
    }

    private void addToCart(Long userId, Long productId, int quantity) {
        if (quantity < 1) {
            throw new IllegalArgumentException("Quantity must be at least 1");
        }

        Product product = productDAO.findById(productId);
        if (product == null) {
            throw new IllegalStateException("Product not found");
        }

        Cart existingItem = cartDAO.findCartItem(userId, productId);
        if (existingItem != null) {
            // Update quantity if item already exists
            cartDAO.updateQuantity(existingItem.getId(), existingItem.getQuantity() + quantity);
        } else {
            // Create new cart item
            Cart newItem = new Cart();
            newItem.setUserId(userId);
            newItem.setProductId(productId);
            newItem.setQuantity(quantity);
            if (!cartDAO.addToCart(newItem)) {
                throw new IllegalStateException("Failed to add item to cart");
            }
        }
    }

    private void updateCartItem(Long userId, Long productId, int quantity) {
        if (quantity < 1) {
            throw new IllegalArgumentException("Quantity must be at least 1");
        }

        Cart item = cartDAO.findCartItem(userId, productId);
        if (item != null) {
            if (!cartDAO.updateQuantity(item.getId(), quantity)) {
                throw new IllegalStateException("Failed to update cart item");
            }
        } else {
            throw new IllegalStateException("Item not found in cart");
        }
    }

    private void removeFromCart(Long userId, Long productId) {
        Cart item = cartDAO.findCartItem(userId, productId);
        if (item != null) {
            if (!cartDAO.removeFromCart(item.getId())) {
                throw new IllegalStateException("Failed to remove item from cart");
            }
        } else {
            throw new IllegalStateException("Item not found in cart");
        }
    }

    private int calculateTotalItems(List<Cart> cartItems) {
        return cartItems.stream()
                .mapToInt(Cart::getQuantity)
                .sum();
    }

    private BigDecimal calculateTotal(List<Cart> cartItems) {
        BigDecimal total = BigDecimal.ZERO;
        for (Cart item : cartItems) {
            Product product = productDAO.findById(item.getProductId());
            if (product != null) {
                BigDecimal itemTotal = product.getPrice()
                        .multiply(BigDecimal.valueOf(item.getQuantity()))
                        .setScale(2, RoundingMode.HALF_UP);
                total = total.add(itemTotal);
            }
        }
        return total.setScale(2, RoundingMode.HALF_UP);
    }
}