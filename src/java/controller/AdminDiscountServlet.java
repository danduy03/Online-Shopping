package controller;

import com.google.gson.Gson;
import dao.DiscountCodeDAO;
import model.DiscountCode;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/discount")
public class AdminDiscountServlet extends HttpServlet {
    private DiscountCodeDAO discountCodeDAO;
    private Gson gson;
    private SimpleDateFormat dateFormat;

    @Override
    public void init() throws ServletException {
        discountCodeDAO = new DiscountCodeDAO();
        gson = new Gson();
        dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/discounts.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Map<String, Object> jsonResponse = new HashMap<>();

        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        try {
            switch (action.toLowerCase()) {
                case "create":
                    handleCreate(request, jsonResponse);
                    break;
                case "update":
                    handleUpdate(request, jsonResponse);
                    break;
                case "delete":
                    handleDelete(request, jsonResponse);
                    break;
                case "toggle":
                    handleToggle(request, jsonResponse);
                    break;
                default:
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Invalid action");
            }
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
    }

    private void handleCreate(HttpServletRequest request, Map<String, Object> jsonResponse) throws Exception {
        String code = request.getParameter("code");
        String discountValueStr = request.getParameter("discountValue");
        
        if (code == null || code.trim().isEmpty() || discountValueStr == null || discountValueStr.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Code and discount value are required");
            return;
        }
        
        DiscountCode discountCode = new DiscountCode();
        discountCode.setCode(code.toUpperCase().trim());
        
        // Parse and set discount value
        double discountValue = Double.parseDouble(discountValueStr);
        discountCode.setDiscountValue(discountValue);
        
        // Set discount type and validate value
        String discountType = request.getParameter("discountType");
        discountCode.setDiscountType(discountType != null ? discountType : "PERCENTAGE");
        
        if ("PERCENTAGE".equals(discountCode.getDiscountType()) && (discountValue < 0 || discountValue > 100)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Percentage discount must be between 0 and 100");
            return;
        }
        
        // Optional fields
        String description = request.getParameter("description");
        if (description != null && !description.trim().isEmpty()) {
            discountCode.setDescription(description.trim());
        }
        
        String minPurchaseAmountStr = request.getParameter("minPurchaseAmount");
        if (minPurchaseAmountStr != null && !minPurchaseAmountStr.trim().isEmpty()) {
            discountCode.setMinPurchaseAmount(Double.parseDouble(minPurchaseAmountStr));
        }
        
        String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
        if (maxDiscountAmountStr != null && !maxDiscountAmountStr.trim().isEmpty()) {
            discountCode.setMaxDiscountAmount(Double.parseDouble(maxDiscountAmountStr));
        }
        
        String maxUsesStr = request.getParameter("maxUses");
        if (maxUsesStr != null && !maxUsesStr.trim().isEmpty()) {
            discountCode.setMaxUses(Integer.parseInt(maxUsesStr));
        }
        
        // Parse dates
        String startDateStr = request.getParameter("startDate");
        if (startDateStr != null && !startDateStr.trim().isEmpty()) {
            Date startDate = dateFormat.parse(startDateStr);
            discountCode.setStartDate(new Timestamp(startDate.getTime()));
        }
        
        String endDateStr = request.getParameter("endDate");
        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
            Date endDate = dateFormat.parse(endDateStr);
            discountCode.setEndDate(new Timestamp(endDate.getTime()));
        }
        
        // Set default values
        discountCode.setActive(true);
        discountCode.setUsedCount(0);
        
        if (discountCodeDAO.create(discountCode)) {
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Discount code created successfully");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Failed to create discount code");
        }
    }

    private void handleUpdate(HttpServletRequest request, Map<String, Object> jsonResponse) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        DiscountCode existingDiscount = discountCodeDAO.findById(id);
        
        if (existingDiscount == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Discount code not found");
            return;
        }
        
        String code = request.getParameter("code");
        String discountValueStr = request.getParameter("discountValue");
        
        if (code == null || code.trim().isEmpty() || discountValueStr == null || discountValueStr.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Code and discount value are required");
            return;
        }
        
        existingDiscount.setCode(code.toUpperCase().trim());
        
        // Parse and set discount value
        double discountValue = Double.parseDouble(discountValueStr);
        existingDiscount.setDiscountValue(discountValue);
        
        // Set discount type and validate value
        String discountType = request.getParameter("discountType");
        existingDiscount.setDiscountType(discountType != null ? discountType : "PERCENTAGE");
        
        if ("PERCENTAGE".equals(existingDiscount.getDiscountType()) && (discountValue < 0 || discountValue > 100)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Percentage discount must be between 0 and 100");
            return;
        }
        
        // Optional fields
        String description = request.getParameter("description");
        if (description != null && !description.trim().isEmpty()) {
            existingDiscount.setDescription(description.trim());
        }
        
        String minPurchaseAmountStr = request.getParameter("minPurchaseAmount");
        if (minPurchaseAmountStr != null && !minPurchaseAmountStr.trim().isEmpty()) {
            existingDiscount.setMinPurchaseAmount(Double.parseDouble(minPurchaseAmountStr));
        }
        
        String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
        if (maxDiscountAmountStr != null && !maxDiscountAmountStr.trim().isEmpty()) {
            existingDiscount.setMaxDiscountAmount(Double.parseDouble(maxDiscountAmountStr));
        }
        
        String maxUsesStr = request.getParameter("maxUses");
        if (maxUsesStr != null && !maxUsesStr.trim().isEmpty()) {
            existingDiscount.setMaxUses(Integer.parseInt(maxUsesStr));
        }
        
        // Parse dates
        String startDateStr = request.getParameter("startDate");
        if (startDateStr != null && !startDateStr.trim().isEmpty()) {
            Date startDate = dateFormat.parse(startDateStr);
            existingDiscount.setStartDate(new Timestamp(startDate.getTime()));
        }
        
        String endDateStr = request.getParameter("endDate");
        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
            Date endDate = dateFormat.parse(endDateStr);
            existingDiscount.setEndDate(new Timestamp(endDate.getTime()));
        }
        
        if (discountCodeDAO.update(existingDiscount)) {
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Discount code updated successfully");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Failed to update discount code");
        }
    }

    private void handleDelete(HttpServletRequest request, Map<String, Object> jsonResponse) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (discountCodeDAO.delete(id)) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Discount code deleted successfully");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Failed to delete discount code");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Invalid discount code ID");
        }
    }

    private void handleToggle(HttpServletRequest request, Map<String, Object> jsonResponse) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean active = Boolean.parseBoolean(request.getParameter("active"));
            
            if (discountCodeDAO.updateStatus(id, active)) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Discount code status updated successfully");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Failed to update discount code status");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Invalid discount code ID");
        }
    }
}