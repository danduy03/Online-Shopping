package controller;

import com.google.gson.Gson;
import dao.DiscountCodeDAO;
import model.DiscountCode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/discount")
public class DiscountServlet extends HttpServlet {
    private DiscountCodeDAO discountCodeDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        discountCodeDAO = new DiscountCodeDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Map<String, Object> jsonResponse = new HashMap<>();
        
        try {
            String code = request.getParameter("code");
            if (code == null || code.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Please enter a discount code");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            HttpSession session = request.getSession();
            Object cartTotalObj = session.getAttribute("cartTotal");
            
            if (cartTotalObj == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "No items in cart");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            double cartTotal = Double.parseDouble(cartTotalObj.toString());
            DiscountCode discountCode = discountCodeDAO.findByCode(code.toUpperCase());
            
            if (discountCode == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Invalid discount code");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Check if discount code is active
            if (!discountCode.isActive()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "This discount code is no longer active");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Check start date
            Date now = new Date();
            if (discountCode.getStartDate() != null && now.before(discountCode.getStartDate())) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "This discount code is not yet active");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Check end date
            if (discountCode.getEndDate() != null && now.after(discountCode.getEndDate())) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "This discount code has expired");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Check max uses
            if (discountCode.getMaxUses() > 0 && 
                discountCode.getUsedCount() >= discountCode.getMaxUses()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "This discount code has reached its maximum uses");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Check minimum purchase amount
            if (discountCode.getMinPurchaseAmount() > 0 && 
                cartTotal < discountCode.getMinPurchaseAmount()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Cart total must be at least $" + 
                    String.format("%.2f", discountCode.getMinPurchaseAmount()) + 
                    " to use this code");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            // Calculate discount amount
            double discountAmount;
            if ("PERCENTAGE".equals(discountCode.getDiscountType())) {
                discountAmount = cartTotal * (discountCode.getDiscountValue() / 100.0);
                // Check max discount amount if set
                if (discountCode.getMaxDiscountAmount() > 0 && 
                    discountAmount > discountCode.getMaxDiscountAmount()) {
                    discountAmount = discountCode.getMaxDiscountAmount();
                }
            } else {
                // Fixed amount discount
                discountAmount = Math.min(cartTotal, discountCode.getDiscountValue());
            }
            
            // Store discount info in session
            session.setAttribute("discountCode", discountCode);
            session.setAttribute("discountAmount", discountAmount);
            
            // Increment uses count
            discountCodeDAO.incrementUses(code);
            
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Discount applied successfully");
            jsonResponse.put("discountAmount", discountAmount);
            jsonResponse.put("finalTotal", cartTotal - discountAmount);
            
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
}
