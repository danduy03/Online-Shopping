package controller.admin;

import com.google.gson.Gson;
import dao.MarketingBannerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.MarketingBanner;
import utils.FileUploadUtil;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import model.User;

@WebServlet("/admin/marketing/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class AdminMarketingServlet extends HttpServlet {
    private final MarketingBannerDAO bannerDAO = new MarketingBannerDAO();
    private final Gson gson = new Gson();
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            request.setAttribute("banners", bannerDAO.findAll());
            request.getRequestDispatcher("/admin/marketing.jsp").forward(request, response);
        } else if (pathInfo.equals("/api/list")) {
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(bannerDAO.findAll()));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        
        if (action == null) {
            createBanner(request, response);
        } else {
            switch (action) {
                case "update":
                    updateBanner(request, response);
                    break;
                case "delete":
                    deleteBanner(request, response);
                    break;
                case "toggle":
                    toggleBannerStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }

    private void createBanner(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            MarketingBanner banner = new MarketingBanner();
            banner.setTitle(request.getParameter("title"));
            banner.setDescription(request.getParameter("description"));
            banner.setLinkUrl(request.getParameter("linkUrl"));
            banner.setPosition(request.getParameter("position"));
            banner.setPriority(Integer.parseInt(request.getParameter("priority")));
            banner.setActive(request.getParameter("active") != null);

            // Handle dates
            String startDateStr = request.getParameter("startDate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                banner.setStartDate(LocalDateTime.parse(startDateStr, formatter));
            }
            
            String endDateStr = request.getParameter("endDate");
            if (endDateStr != null && !endDateStr.isEmpty()) {
                banner.setEndDate(LocalDateTime.parse(endDateStr, formatter));
            }

            // Handle file upload
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = FileUploadUtil.saveFile(filePart, "uploads/banners");
                banner.setImageUrl("uploads/banners/" + fileName);
            } else {
                sendJsonResponse(response, false, "Image is required", null);
                return;
            }

            if (bannerDAO.save(banner)) {
                sendJsonResponse(response, true, "Banner created successfully", banner);
            } else {
                sendJsonResponse(response, false, "Failed to create banner", null);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            sendJsonResponse(response, false, "Error creating banner: " + e.getMessage(), null);
        }
    }

    private void updateBanner(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            MarketingBanner banner = bannerDAO.getById(id);
            
            if (banner == null) {
                sendJsonResponse(response, false, "Banner not found", null);
                return;
            }

            banner.setTitle(request.getParameter("title"));
            banner.setDescription(request.getParameter("description"));
            banner.setLinkUrl(request.getParameter("linkUrl"));
            banner.setPosition(request.getParameter("position"));
            banner.setPriority(Integer.parseInt(request.getParameter("priority")));
            banner.setActive(request.getParameter("active") != null);

            // Handle dates
            String startDateStr = request.getParameter("startDate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                banner.setStartDate(LocalDateTime.parse(startDateStr, formatter));
            }
            
            String endDateStr = request.getParameter("endDate");
            if (endDateStr != null && !endDateStr.isEmpty()) {
                banner.setEndDate(LocalDateTime.parse(endDateStr, formatter));
            }

            // Handle file upload if new image is provided
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                // Delete old image if exists
                String oldImageUrl = banner.getImageUrl();
                if (oldImageUrl != null) {
                    String oldFileName = oldImageUrl.substring(oldImageUrl.lastIndexOf('/') + 1);
                    FileUploadUtil.deleteFile("uploads/banners", oldFileName);
                }
                
                // Save new image
                String fileName = FileUploadUtil.saveFile(filePart, "uploads/banners");
                banner.setImageUrl("uploads/banners/" + fileName);
            }

            if (bannerDAO.update(banner)) {
                sendJsonResponse(response, true, "Banner updated successfully", banner);
            } else {
                sendJsonResponse(response, false, "Failed to update banner", null);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            sendJsonResponse(response, false, "Error updating banner: " + e.getMessage(), null);
        }
    }

    private void deleteBanner(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            MarketingBanner banner = bannerDAO.getById(id);
            
            if (banner == null) {
                sendJsonResponse(response, false, "Banner not found", null);
                return;
            }

            // Delete image file
            String imageUrl = banner.getImageUrl();
            if (imageUrl != null) {
                String fileName = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
                FileUploadUtil.deleteFile("uploads/banners", fileName);
            }

            if (bannerDAO.delete(id)) {
                sendJsonResponse(response, true, "Banner deleted successfully", null);
            } else {
                sendJsonResponse(response, false, "Failed to delete banner", null);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            sendJsonResponse(response, false, "Error deleting banner: " + e.getMessage(), null);
        }
    }

    private void toggleBannerStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            MarketingBanner banner = bannerDAO.getById(id);
            
            if (banner == null) {
                sendJsonResponse(response, false, "Banner not found", null);
                return;
            }

            banner.setActive(!banner.isActive());
            
            if (bannerDAO.update(banner)) {
                sendJsonResponse(response, true, "Banner status updated successfully", banner);
            } else {
                sendJsonResponse(response, false, "Failed to update banner status", null);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            sendJsonResponse(response, false, "Error toggling banner status: " + e.getMessage(), null);
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) 
            throws IOException {
        response.setContentType("application/json");
        Map<String, Object> jsonMap;
        if (data != null) {
            jsonMap = Map.of(
                "success", success,
                "message", message,
                "data", data
            );
        } else {
            jsonMap = Map.of(
                "success", success,
                "message", message
            );
        }
        response.getWriter().write(gson.toJson(jsonMap));
    }
}
