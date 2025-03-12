package controller.admin;

import dao.DiscountCodeDAO;
import model.DiscountCode;
import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/discounts")
public class AdminDiscountsServlet extends HttpServlet {
    private DiscountCodeDAO discountCodeDAO;
    private SimpleDateFormat dateFormat;

    @Override
    public void init() throws ServletException {
        discountCodeDAO = new DiscountCodeDAO();
        dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
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

        // Get all discounts
        List<DiscountCode> discountCodes = discountCodeDAO.findAll();
        request.setAttribute("discountCodes", discountCodes);
        request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
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
                case "create":
                    createDiscount(request, response);
                    break;
                case "update":
                    updateDiscount(request, response);
                    break;
                case "delete":
                    deleteDiscount(request, response);
                    break;
                case "toggleActive":
                    toggleDiscountStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Operation failed: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void createDiscount(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            DiscountCode discountCode = new DiscountCode();
            
            // Required fields
            String code = request.getParameter("code");
            String discountValueStr = request.getParameter("discountValue");
            
            if (code == null || code.trim().isEmpty() || discountValueStr == null || discountValueStr.trim().isEmpty()) {
                request.setAttribute("error", "Code and discount value are required");
                request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
                return;
            }
            
            // Set required fields
            discountCode.setCode(code.toUpperCase().trim());
            discountCode.setDiscountValue(Double.parseDouble(discountValueStr));
            
            // Optional fields
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            String minPurchaseAmountStr = request.getParameter("minPurchaseAmount");
            String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
            String maxUsesStr = request.getParameter("maxUses");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            
            // Set optional fields if provided
            if (description != null && !description.trim().isEmpty()) {
                discountCode.setDescription(description.trim());
            }
            
            if (discountType != null && !discountType.trim().isEmpty()) {
                discountCode.setDiscountType(discountType.trim());
            }
            
            if (minPurchaseAmountStr != null && !minPurchaseAmountStr.trim().isEmpty()) {
                discountCode.setMinPurchaseAmount(Double.parseDouble(minPurchaseAmountStr));
            }
            
            if (maxDiscountAmountStr != null && !maxDiscountAmountStr.trim().isEmpty()) {
                discountCode.setMaxDiscountAmount(Double.parseDouble(maxDiscountAmountStr));
            }
            
            if (maxUsesStr != null && !maxUsesStr.trim().isEmpty()) {
                discountCode.setMaxUses(Integer.parseInt(maxUsesStr));
            }
            
            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                Date startDate = dateFormat.parse(startDateStr);
                discountCode.setStartDate(new Timestamp(startDate.getTime()));
            }
            
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                Date endDate = dateFormat.parse(endDateStr);
                discountCode.setEndDate(new Timestamp(endDate.getTime()));
            }
            
            // Set default values
            discountCode.setActive(true);
            discountCode.setUsedCount(0);
            
            // Validate discount value based on type
            if ("PERCENTAGE".equals(discountCode.getDiscountType())) {
                double value = discountCode.getDiscountValue();
                if (value < 0 || value > 100) {
                    request.setAttribute("error", "Percentage discount must be between 0 and 100");
                    request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
                    return;
                }
            }
            
            if (discountCodeDAO.create(discountCode)) {
                response.sendRedirect(request.getContextPath() + "/admin/discounts");
            } else {
                request.setAttribute("error", "Failed to create discount code");
                request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
        }
    }

    private void updateDiscount(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            DiscountCode discountCode = discountCodeDAO.findById(id);
            
            if (discountCode == null) {
                request.setAttribute("error", "Discount code not found");
                request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
                return;
            }
            
            // Required fields
            String code = request.getParameter("code");
            String discountValueStr = request.getParameter("discountValue");
            
            if (code == null || code.trim().isEmpty() || discountValueStr == null || discountValueStr.trim().isEmpty()) {
                request.setAttribute("error", "Code and discount value are required");
                request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
                return;
            }
            
            // Set required fields
            discountCode.setCode(code.toUpperCase().trim());
            discountCode.setDiscountValue(Double.parseDouble(discountValueStr));
            
            // Optional fields
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            String minPurchaseAmountStr = request.getParameter("minPurchaseAmount");
            String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
            String maxUsesStr = request.getParameter("maxUses");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            
            // Set optional fields if provided
            if (description != null && !description.trim().isEmpty()) {
                discountCode.setDescription(description.trim());
            }
            
            if (discountType != null && !discountType.trim().isEmpty()) {
                discountCode.setDiscountType(discountType.trim());
            }
            
            if (minPurchaseAmountStr != null && !minPurchaseAmountStr.trim().isEmpty()) {
                discountCode.setMinPurchaseAmount(Double.parseDouble(minPurchaseAmountStr));
            }
            
            if (maxDiscountAmountStr != null && !maxDiscountAmountStr.trim().isEmpty()) {
                discountCode.setMaxDiscountAmount(Double.parseDouble(maxDiscountAmountStr));
            }
            
            if (maxUsesStr != null && !maxUsesStr.trim().isEmpty()) {
                discountCode.setMaxUses(Integer.parseInt(maxUsesStr));
            }
            
            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                Date startDate = dateFormat.parse(startDateStr);
                discountCode.setStartDate(new Timestamp(startDate.getTime()));
            }
            
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                Date endDate = dateFormat.parse(endDateStr);
                discountCode.setEndDate(new Timestamp(endDate.getTime()));
            }
            
            // Validate discount value based on type
            if ("PERCENTAGE".equals(discountCode.getDiscountType())) {
                double value = discountCode.getDiscountValue();
                if (value < 0 || value > 100) {
                    request.setAttribute("error", "Percentage discount must be between 0 and 100");
                    request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
                    return;
                }
            }
            
            if (discountCodeDAO.update(discountCode)) {
                response.sendRedirect(request.getContextPath() + "/admin/discounts");
            } else {
                request.setAttribute("error", "Failed to update discount code");
                request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/admin/discounts.jsp").forward(request, response);
        }
    }

    private void deleteDiscount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (discountCodeDAO.delete(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/discounts?success=deleted");
        } else {
            request.setAttribute("error", "Failed to delete discount code");
            doGet(request, response);
        }
    }

    private void toggleDiscountStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            
            if (discountCodeDAO.updateStatus(id, !isActive)) {
                response.sendRedirect(request.getContextPath() + "/admin/discounts?success=toggled");
            } else {
                request.setAttribute("error", "Failed to toggle discount code status");
                doGet(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            doGet(request, response);
        }
    }
}
