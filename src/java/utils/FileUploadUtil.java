package utils;

import jakarta.servlet.http.Part;
import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.*;
import java.util.UUID;

public class FileUploadUtil {
    
    private static final String BASE_UPLOAD_DIR = "d:/EC/Ecomere/web";
    private static final int MAX_WIDTH = 1920;  // Maximum width for banner images
    private static final int MAX_HEIGHT = 600;  // Maximum height for banner images
    
    /**
     * Saves and processes an uploaded file.
     */
    public static String saveFile(Part filePart, String directory) throws IOException {
        // Generate a unique filename
        String originalFilename = getSubmittedFileName(filePart);
        String extension = getFileExtension(originalFilename).toLowerCase();
        String filename = UUID.randomUUID().toString() + extension;
        
        // Create the target directory if it doesn't exist
        Path uploadPath = Paths.get(BASE_UPLOAD_DIR, directory);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // Save and process the image
        Path filePath = uploadPath.resolve(filename);
        
        // For images, resize if necessary
        if (isImageFile(originalFilename)) {
            try (InputStream input = filePart.getInputStream()) {
                BufferedImage originalImage = ImageIO.read(input);
                if (originalImage != null) {
                    BufferedImage resizedImage = resizeImage(originalImage);
                    String formatName = extension.substring(1); // Remove the dot
                    ImageIO.write(resizedImage, formatName, filePath.toFile());
                    return filename;
                }
            }
        }
        
        // For non-image files or if image processing fails, save directly
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        return filename;
    }
    
    /**
     * Resize image while maintaining aspect ratio
     */
    private static BufferedImage resizeImage(BufferedImage originalImage) {
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();
        
        // Calculate new dimensions while maintaining aspect ratio
        double aspectRatio = (double) originalWidth / originalHeight;
        int newWidth = originalWidth;
        int newHeight = originalHeight;
        
        if (originalWidth > MAX_WIDTH) {
            newWidth = MAX_WIDTH;
            newHeight = (int) (MAX_WIDTH / aspectRatio);
        }
        
        if (newHeight > MAX_HEIGHT) {
            newHeight = MAX_HEIGHT;
            newWidth = (int) (MAX_HEIGHT * aspectRatio);
        }
        
        // Create new image
        BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = resizedImage.createGraphics();
        
        // Use better quality algorithm and rendering hints
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        
        g.drawImage(originalImage, 0, 0, newWidth, newHeight, null);
        g.dispose();
        
        return resizedImage;
    }
    
    /**
     * Deletes a file from the specified directory.
     */
    public static boolean deleteFile(String directory, String filename) {
        try {
            Path filePath = Paths.get(BASE_UPLOAD_DIR, directory, filename);
            return Files.deleteIfExists(filePath);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gets the original filename from a Part.
     */
    private static String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) {
            return null;
        }
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
    
    /**
     * Gets the file extension from a filename.
     */
    private static String getFileExtension(String filename) {
        if (filename == null) {
            return "";
        }
        int lastDotIndex = filename.lastIndexOf('.');
        if (lastDotIndex == -1) {
            return "";
        }
        return filename.substring(lastDotIndex).toLowerCase();
    }
    
    /**
     * Validates if a file is an image based on its extension.
     */
    public static boolean isImageFile(String filename) {
        if (filename == null) {
            return false;
        }
        String extension = getFileExtension(filename).toLowerCase();
        return extension.equals(".jpg") || 
               extension.equals(".jpeg") || 
               extension.equals(".png") || 
               extension.equals(".gif") || 
               extension.equals(".webp");
    }
    
    /**
     * Creates a directory if it doesn't exist.
     */
    public static boolean createDirectoryIfNotExists(String directory) {
        Path path = Paths.get(BASE_UPLOAD_DIR, directory);
        try {
            if (!Files.exists(path)) {
                Files.createDirectories(path);
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gets the absolute path of an uploaded file.
     * 
     * @param directory The directory relative to the web root
     * @param filename The filename
     * @return The absolute path to the file
     */
    public static String getAbsolutePath(String directory, String filename) {
        return Paths.get(BASE_UPLOAD_DIR, directory, filename).toString();
    }
}
