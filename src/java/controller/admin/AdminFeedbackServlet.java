package controller.admin;

import dao.FeedbackDAO;
import model.Feedback;
import model.FeedbackResponse;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet handling admin-specific feedback operations.
 * 
 * Admin Functions:
 * - View all feedback (GET - no action)
 * - View specific feedback details (GET - action=view)
 * - Update feedback status (POST - action=update_status)
 * - Respond to feedback (POST - action=respond)
 */
@WebServlet(name = "AdminFeedbackServlet", urlPatterns = {"/admin/feedback"})
public class AdminFeedbackServlet extends HttpServlet {
    private final FeedbackDAO feedbackDAO;
    private final Gson gson;

    public AdminFeedbackServlet() {
        this.feedbackDAO = new FeedbackDAO();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User admin = validateAdmin(request, response);
        if (admin == null) return;

        String action = request.getParameter("action");
        
        try {
            if (action == null || action.isEmpty()) {
                handleDashboard(request, response);
            } else if ("view".equals(action)) {
                handleViewFeedback(request, response);
            } else {
                sendError(response, "Invalid action", HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            handleException(response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User admin = validateAdmin(request, response);
        if (admin == null) return;

        String action = request.getParameter("action");
        if (action == null) {
            sendError(response, "Action parameter is required");
            return;
        }

        try {
            switch (action) {
                case "update_status":
                    handleUpdateStatus(request, response);
                    break;
                case "respond":
                    handleAddResponse(request, response, admin);
                    break;
                default:
                    sendError(response, "Invalid action");
            }
        } catch (Exception e) {
            handleException(response, e);
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Feedback> feedbacks = feedbackDAO.getAllFeedback();
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/admin/feedback.jsp").forward(request, response);
    }

    private void handleViewFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long feedbackId = Long.parseLong(request.getParameter("id"));
            Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
            
            if (feedback == null) {
                sendError(response, "Feedback not found", HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            JsonObject jsonResponse = createFeedbackJson(feedback);
            sendJsonResponse(response, jsonResponse);
        } catch (NumberFormatException e) {
            sendError(response, "Invalid feedback ID", HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long feedbackId = Long.parseLong(request.getParameter("feedbackId"));
            String status = request.getParameter("status");
            
            if (status == null || status.trim().isEmpty()) {
                sendError(response, "Status is required");
                return;
            }
            
            boolean updated = feedbackDAO.updateStatus(feedbackId, status.trim());
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", updated);
            jsonResponse.addProperty("message", updated ? "Status updated successfully" : "Failed to update status");
            
            sendJsonResponse(response, jsonResponse);
        } catch (NumberFormatException e) {
            sendError(response, "Invalid feedback ID format");
        }
    }

    private void handleAddResponse(HttpServletRequest request, HttpServletResponse response, User admin)
            throws ServletException, IOException {
        try {
            Long feedbackId = Long.parseLong(request.getParameter("feedbackId"));
            String message = request.getParameter("message");
            
            if (message == null || message.trim().isEmpty()) {
                sendError(response, "Response message is required");
                return;
            }
            
            FeedbackResponse feedbackResponse = new FeedbackResponse();
            feedbackResponse.setFeedbackId(feedbackId);
            feedbackResponse.setUserId(admin.getId());
            feedbackResponse.setMessage(message.trim());
            feedbackResponse.setAdminName(admin.getUsername());
            
            boolean added = feedbackDAO.addResponse(feedbackResponse);
            if (added) {
                feedbackDAO.updateStatus(feedbackId, "IN_PROGRESS");
            }
            
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", added);
            jsonResponse.addProperty("message", added ? "Response added successfully" : "Failed to add response");
            
            sendJsonResponse(response, jsonResponse);
        } catch (NumberFormatException e) {
            sendError(response, "Invalid feedback ID format");
        }
    }

    private JsonObject createFeedbackJson(Feedback feedback) {
        JsonObject json = new JsonObject();
        json.addProperty("id", feedback.getId());
        json.addProperty("subject", feedback.getSubject());
        json.addProperty("message", feedback.getDescription());
        json.addProperty("type", feedback.getType());
        json.addProperty("priority", feedback.getPriority());
        json.addProperty("status", feedback.getStatus());
        json.addProperty("createdAt", feedback.getCreatedAt().toString());
        json.addProperty("userName", feedback.getUserName());
        
        if (feedback.getAttachmentPath() != null) {
            json.addProperty("attachmentPath", feedback.getAttachmentPath());
        }
        
        JsonArray responsesArray = new JsonArray();
        List<FeedbackResponse> responses = feedbackDAO.getFeedbackResponses(feedback.getId());
        for (FeedbackResponse response : responses) {
            JsonObject responseJson = new JsonObject();
            responseJson.addProperty("id", response.getId());
            responseJson.addProperty("message", response.getMessage());
            responseJson.addProperty("adminName", response.getAdminName());
            responseJson.addProperty("createdAt", response.getCreatedAt().toString());
            responsesArray.add(responseJson);
        }
        json.add("responses", responsesArray);
        
        return json;
    }

    private User validateAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);
        
        if (user == null || !user.isAdmin()) {
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("message", "Administrator access required");
            error.addProperty("redirect", "login.jsp");
            sendJsonResponse(response, error);
            return null;
        }
        
        return user;
    }

    private void sendJsonResponse(HttpServletResponse response, JsonObject json)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }

    private void sendError(HttpServletResponse response, String message)
            throws IOException {
        sendError(response, message, HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }

    private void sendError(HttpServletResponse response, String message, int statusCode)
            throws IOException {
        response.setStatus(statusCode);
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("message", message);
        sendJsonResponse(response, error);
    }

    private void handleException(HttpServletResponse response, Exception e)
            throws IOException {
        e.printStackTrace();
        sendError(response, "An error occurred: " + e.getMessage());
    }
}
