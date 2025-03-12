package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/files/*")
public class FileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the file path from the URL
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Clean the path to prevent directory traversal
        pathInfo = pathInfo.replace("../", "").replace("..\\", "");
        
        // Get the absolute path to the uploads directory
        String uploadPath = getServletContext().getRealPath("/uploads");
        File file = new File(uploadPath, pathInfo);
        
        System.out.println("Requested file path: " + file.getAbsolutePath());
        
        // Check if file exists and is actually a file (not a directory)
        if (!file.exists() || !file.isFile()) {
            System.out.println("File not found: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Set the content type
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        
        // Set headers for file download
        String fileName = file.getName();
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
        response.setHeader("Cache-Control", "public, max-age=31536000");
        
        // Set content length
        response.setContentLength((int) file.length());
        
        // Copy the file to the response output stream
        try {
            Files.copy(file.toPath(), response.getOutputStream());
            System.out.println("File served successfully: " + fileName);
        } catch (IOException e) {
            System.err.println("Error serving file: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
