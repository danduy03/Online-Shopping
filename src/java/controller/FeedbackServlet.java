package controller;

import dao.FeedbackDAO;
import model.Feedback;
import model.FeedbackResponse;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

/**
 * Servlet handling user feedback operations.
 * 
 * User Functions:
 * - Submit new feedback (POST - action=submit)
 * - View feedback history (GET - action=history)
 * - View specific feedback (GET - action=view)
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = {"/feedback"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 20 // 20 MB
)
public class FeedbackServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/feedback";
    private final FeedbackDAO feedbackDAO;
    private final Gson gson;
    private Path storageDirectory;

    public FeedbackServlet() {
        this.feedbackDAO = new FeedbackDAO();
        this.gson = new Gson();
    }

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            String userHome = System.getProperty("user.home");
            storageDirectory = Paths.get(userHome, "ecommerce_uploads", "feedback");
            Files.createDirectories(storageDirectory);
        } catch (IOException e) {
            throw new ServletException("Could not create upload directory", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = validateUser(request, response);
        if (user == null) return;

        // Redirect admins to admin feedback panel
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("history".equals(action)) {
                handleFeedbackHistory(request, response, user);
            } else if ("view".equals(action)) {
                handleViewFeedback(request, response, user);
            } else {
                request.getRequestDispatcher("feedback.jsp").forward(request, response);
            }
        } catch (Exception e) {
            handleException(response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = validateUser(request, response);
        if (user == null) return;

        // Prevent admins from submitting feedback
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            sendError(response, "Action parameter is required");
            return;
        }

        try {
            if ("submit".equals(action)) {
                handleSubmitFeedback(request, response, user);
            } else {
                sendError(response, "Invalid action");
            }
        } catch (Exception e) {
            handleException(response, e);
        }
    }

    private void handleFeedbackHistory(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Feedback> feedbacks = feedbackDAO.getUserFeedbackHistory(user.getId());
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("feedback-history.jsp").forward(request, response);
    }

    private void handleViewFeedback(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            Long feedbackId = Long.parseLong(request.getParameter("id"));
            Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
            
            if (feedback == null || !feedback.getUserId().equals(user.getId())) {
                sendError(response, "Feedback not found or access denied", HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            JsonObject jsonResponse = createFeedbackJson(feedback);
            sendJsonResponse(response, jsonResponse);
        } catch (NumberFormatException e) {
            sendError(response, "Invalid feedback ID", HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleSubmitFeedback(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        String priority = request.getParameter("priority");
        
        if (subject == null || subject.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            type == null || type.trim().isEmpty() ||
            priority == null || priority.trim().isEmpty()) {
            sendError(response, "All fields are required");
            return;
        }

        Feedback feedback = new Feedback();
        feedback.setUserId(user.getId());
        feedback.setUserName(user.getUsername());
        feedback.setSubject(subject.trim());
        feedback.setDescription(description.trim());
        feedback.setType(type.trim());
        feedback.setPriority(priority.trim());
        
        // Handle file upload
        Part filePart = request.getPart("attachment");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = getUniqueFileName(filePart);
            String uploadPath = getUploadPath(request, fileName);
            feedback.setAttachmentPath(UPLOAD_DIR + "/" + fileName);
            saveFile(filePart, uploadPath);
        }

        boolean created = feedbackDAO.create(feedback);
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", created);
        jsonResponse.addProperty("message", created ? "Feedback submitted successfully" : "Failed to submit feedback");
        
        sendJsonResponse(response, jsonResponse);
    }

    private String getUniqueFileName(Part part) {
        String originalFileName = part.getSubmittedFileName();
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        return UUID.randomUUID().toString() + extension;
    }

    private String getUploadPath(HttpServletRequest request, String fileName) {
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        return uploadFilePath + File.separator + fileName;
    }

    private void saveFile(Part filePart, String filePath) throws IOException {
        filePart.write(filePath);
    }

    private JsonObject createFeedbackJson(Feedback feedback) {
        JsonObject json = new JsonObject();
        json.addProperty("id", feedback.getId());
        json.addProperty("userId", feedback.getUserId());
        json.addProperty("userName", feedback.getUserName());
        json.addProperty("subject", feedback.getSubject());
        json.addProperty("message", feedback.getDescription());
        json.addProperty("type", feedback.getType());
        json.addProperty("status", feedback.getStatus());
        json.addProperty("priority", feedback.getPriority());
        json.addProperty("attachmentPath", feedback.getAttachmentPath());
        json.addProperty("createdAt", feedback.getCreatedAt().toString());
        json.addProperty("updatedAt", feedback.getUpdatedAt() != null ? feedback.getUpdatedAt().toString() : null);

        // Add responses
        JsonArray responsesArray = new JsonArray();
        if (feedback.getResponses() != null) {
            for (FeedbackResponse response : feedback.getResponses()) {
                JsonObject responseJson = new JsonObject();
                responseJson.addProperty("id", response.getId());
                responseJson.addProperty("message", response.getMessage());
                responseJson.addProperty("adminName", response.getAdminName());
                responseJson.addProperty("createdAt", response.getCreatedAt().toString());
                responsesArray.add(responseJson);
            }
        }
        json.add("responses", responsesArray);
        
        return json;
    }

    private User validateUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);
        
        if (user == null) {
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("message", "Authentication required");
            error.addProperty("redirect", request.getContextPath() + "/login");
            sendJsonResponse(response, error);
            return null;
        }
        
        return user;
    }

    private void sendJsonResponse(HttpServletResponse response, JsonObject json) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }

    private void sendError(HttpServletResponse response, String message) 
            throws IOException {
        sendError(response, message, HttpServletResponse.SC_BAD_REQUEST);
    }

    private void sendError(HttpServletResponse response, String message, int statusCode) 
            throws IOException {
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("message", message);
        response.setStatus(statusCode);
        sendJsonResponse(response, error);
    }

    private void handleException(HttpServletResponse response, Exception e) 
            throws IOException {
        e.printStackTrace();
        sendError(response, "An internal error occurred", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
}