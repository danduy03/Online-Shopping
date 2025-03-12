package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {
    private static final String DEFAULT_IMAGE = "/images/products/placeholder.jpg";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String imagePath = request.getPathInfo();
        String realPath = getServletContext().getRealPath(imagePath);
        File file = new File(realPath);
        
        if (!file.exists()) {
            // If requested image doesn't exist, use default image
            realPath = getServletContext().getRealPath(DEFAULT_IMAGE);
            file = new File(realPath);
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }
        
        String contentType = getServletContext().getMimeType(realPath);
        response.setContentType(contentType);
        Files.copy(file.toPath(), response.getOutputStream());
    }
}
