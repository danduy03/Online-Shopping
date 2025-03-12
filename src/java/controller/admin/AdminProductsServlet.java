package controller.admin;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;
import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/admin/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class AdminProductsServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "uploads";
    private static final String PRODUCT_IMAGES_DIRECTORY = "products";
    private static String UPLOAD_PATH;
    private static String PRODUCT_IMAGES_PATH;
    
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        
        // Get the project's root directory (outside of build/web)
        String webappPath = getServletContext().getRealPath("/");
        String projectRoot = webappPath.substring(0, webappPath.indexOf("build"));
        
        // Set up permanent upload directories
        UPLOAD_PATH = projectRoot + "web" + File.separator + UPLOAD_DIRECTORY;
        PRODUCT_IMAGES_PATH = UPLOAD_PATH + File.separator + PRODUCT_IMAGES_DIRECTORY;
        
        // Create the upload directories if they don't exist
        createDirectory(UPLOAD_PATH);
        createDirectory(PRODUCT_IMAGES_PATH);
        
        // Also create the directories in build/web for development
        String buildUploadPath = webappPath + UPLOAD_DIRECTORY;
        String buildProductImagesPath = buildUploadPath + File.separator + PRODUCT_IMAGES_DIRECTORY;
        createDirectory(buildUploadPath);
        createDirectory(buildProductImagesPath);
        
        // Log the upload paths
        System.out.println("Product images directory: " + PRODUCT_IMAGES_PATH);
    }
    
    private void createDirectory(String path) {
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    private String handleFileUpload(Part filePart, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String originalFileName = getSubmittedFileName(filePart);
        String fileExtension = "";
        int i = originalFileName.lastIndexOf('.');
        if (i > 0) {
            fileExtension = originalFileName.substring(i);
        }
        
        String fileName = System.currentTimeMillis() + fileExtension;
        
        // Save to permanent product images directory
        File uploadDir = new File(PRODUCT_IMAGES_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save to permanent location
        String permanentPath = PRODUCT_IMAGES_PATH + File.separator + fileName;
        try (InputStream input = filePart.getInputStream();
             OutputStream output = new FileOutputStream(permanentPath)) {
            byte[] buffer = new byte[8192];
            int length;
            while ((length = input.read(buffer)) > 0) {
                output.write(buffer, 0, length);
            }
        }
        
        // Copy to development location
        String buildWebPath = getServletContext().getRealPath("/");
        String developmentPath = buildWebPath + UPLOAD_DIRECTORY + File.separator + 
                               PRODUCT_IMAGES_DIRECTORY + File.separator + fileName;
        
        File developmentDir = new File(buildWebPath + UPLOAD_DIRECTORY + 
                                     File.separator + PRODUCT_IMAGES_DIRECTORY);
        if (!developmentDir.exists()) {
            developmentDir.mkdirs();
        }
        
        Files.copy(new File(permanentPath).toPath(), new File(developmentPath).toPath(), 
                  StandardCopyOption.REPLACE_EXISTING);
        
        // Log the file paths for debugging
        System.out.println("Product image saved to: " + permanentPath);
        System.out.println("Web accessible path: /uploads/products/" + fileName);
        
        // Return the relative path from web root
        return UPLOAD_DIRECTORY + "/" + PRODUCT_IMAGES_DIRECTORY + "/" + fileName;
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all products
            List<Product> products = productDAO.findAll();
            request.setAttribute("products", products);
            
            // Get all categories for the form
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);
            
            // Log the number of products found
            System.out.println("Found " + products.size() + " products");
            
            // Forward to the JSP page
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminProductsServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error loading products page", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }

    private void createProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get the current user from the session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                throw new ServletException("User not found in session");
            }

            // Validate required parameters
            String name = request.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                throw new ServletException("Product name is required");
            }

            String priceStr = request.getParameter("price");
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new ServletException("Price is required");
            }
            BigDecimal price;
            try {
                price = new BigDecimal(priceStr.trim());
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    throw new ServletException("Price must be greater than 0");
                }
            } catch (NumberFormatException e) {
                throw new ServletException("Invalid price format");
            }

            String stockStr = request.getParameter("stockQuantity");
            if (stockStr == null || stockStr.trim().isEmpty()) {
                throw new ServletException("Stock quantity is required");
            }
            int stockQuantity;
            try {
                stockQuantity = Integer.parseInt(stockStr.trim());
                if (stockQuantity < 0) {
                    throw new ServletException("Stock quantity cannot be negative");
                }
            } catch (NumberFormatException e) {
                throw new ServletException("Invalid stock quantity format");
            }

            String categoryIdStr = request.getParameter("categoryId");
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                throw new ServletException("Category is required");
            }
            Long categoryId;
            try {
                categoryId = Long.parseLong(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                throw new ServletException("Invalid category");
            }

            // Create product with validated data
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(request.getParameter("description"));
            product.setPrice(price);
            product.setStockQuantity(stockQuantity);
            product.setCategoryId(categoryId);
            product.setCreatedBy(currentUser.getId());

            // Handle image
            String imageType = request.getParameter("imageType");
            if ("url".equals(imageType)) {
                String imageUrl = request.getParameter("imageUrl");
                if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    product.setImageUrl(imageUrl.trim());
                }
            } else {
                Part filePart = request.getPart("productImage");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = handleFileUpload(filePart, request);
                    if (fileName != null && !fileName.isEmpty()) {
                        product.setImageUrl(fileName);
                    }
                }
            }
            
            // Insert the product
            if (productDAO.insert(product)) {
                response.sendRedirect(request.getContextPath() + "/admin/products?success=created");
            } else {
                throw new ServletException("Failed to insert product");
            }
        } catch (ServletException e) {
            // Log and forward servlet exceptions directly
            System.err.println("Validation error: " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.setAttribute("formData", request.getParameterMap());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        } catch (Exception e) {
            // Log and forward other exceptions with a generic message
            System.err.println("Error creating product: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to create product: " + e.getMessage());
            request.setAttribute("formData", request.getParameterMap());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    try {
        // Validate ID
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new ServletException("Product ID is required");
        }
        Long id;
        try {
            id = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid product ID");
        }

        // Get existing product
        Product product = productDAO.findById(id);
        if (product == null) {
            throw new ServletException("Product not found");
        }

        // Validate other required fields
        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            throw new ServletException("Product name is required");
        }

        String priceStr = request.getParameter("price");
        if (priceStr == null || priceStr.trim().isEmpty()) {
            throw new ServletException("Price is required");
        }
        BigDecimal price;
        try {
            price = new BigDecimal(priceStr.trim());
            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                throw new ServletException("Price must be greater than 0");
            }
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid price format");
        }

        // Update basic information
        product.setName(name.trim());
        product.setDescription(request.getParameter("description"));
        product.setPrice(price);
        product.setCategoryId(Long.parseLong(request.getParameter("categoryId")));
        product.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        
        // Handle image update
        String imageType = request.getParameter("imageType");
        String originalImageUrl = product.getImageUrl(); // Lưu lại URL ảnh gốc
        if (imageType != null) {
            switch (imageType) {
                case "url":
                    // Handle URL image
                    String imageUrl = request.getParameter("imageUrl");
                    if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                        product.setImageUrl(imageUrl.trim());
                    }
                    break;
                    
                case "upload":
                    String newImageType = request.getParameter("newImageType");
                    if ("url".equals(newImageType)) {
                        // Handle new URL image
                        String newImageUrl = request.getParameter("newImageUrl");
                        if (newImageUrl != null && !newImageUrl.trim().isEmpty()) {
                            // Delete old image file if it was an uploaded file
                            if (originalImageUrl != null && originalImageUrl.startsWith(UPLOAD_DIRECTORY)) {
                                deleteOldImage(originalImageUrl);
                            }
                            product.setImageUrl(newImageUrl.trim());
                        }
                    } else {
                        // Handle file upload
                        Part filePart = request.getPart("productImage");
                        if (filePart != null && filePart.getSize() > 0) {
                            String fileName = handleFileUpload(filePart, request);
                            if (fileName != null && !fileName.isEmpty()) {
                                // Delete old image file if it was an uploaded file
                                if (originalImageUrl != null && originalImageUrl.startsWith(UPLOAD_DIRECTORY)) {
                                    deleteOldImage(originalImageUrl);
                                }
                                product.setImageUrl(fileName);
                            }
                        } else {
                            // Nếu không có file mới được upload, giữ nguyên ảnh cũ
                            product.setImageUrl(originalImageUrl);
                        }
                    }
                    break;
                    
                default:
                    // Keep existing image
                    product.setImageUrl(originalImageUrl);
                    break;
            }
        }

        // Update the product
        if (productDAO.update(product)) {
            response.sendRedirect(request.getContextPath() + "/admin/products?success=updated");
        } else {
            throw new ServletException("Failed to update product");
        }
        
    } catch (ServletException e) {
        // Log and forward servlet exceptions
        System.err.println("Validation error in updateProduct: " + e.getMessage());
        request.setAttribute("error", e.getMessage());
        doGet(request, response);
    } catch (Exception e) {
        // Log and forward other exceptions
        System.err.println("Error updating product: " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("error", "Failed to update product: " + e.getMessage());
        doGet(request, response);
    }
}

// Helper method to delete old image file
private void deleteOldImage(String imagePath) {
    try {
        if (imagePath != null && imagePath.startsWith(UPLOAD_DIRECTORY)) {
            // Get filename from path
            String fileName = imagePath.substring(imagePath.lastIndexOf('/') + 1);
            
            // Delete from permanent storage
            String fullPath = PRODUCT_IMAGES_PATH + File.separator + fileName;
            Files.deleteIfExists(Paths.get(fullPath));
            
            // Delete from development location
            String webappPath = getServletContext().getRealPath("/");
            String devPath = webappPath + UPLOAD_DIRECTORY + File.separator + 
                           PRODUCT_IMAGES_DIRECTORY + File.separator + fileName;
            Files.deleteIfExists(Paths.get(devPath));
            
            System.out.println("Deleted old image: " + fileName);
        }
    } catch (IOException e) {
        System.err.println("Error deleting old image: " + e.getMessage());
    }
}

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Validate ID
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new ServletException("Product ID is required");
        }
        
        Long id;
        try {
            id = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid product ID");
        }

        // Get product to check existence and get image URL
        Product product = productDAO.findById(id);
        if (product == null) {
            throw new ServletException("Product not found");
        }

        // Delete product image if exists
        String imageUrl = product.getImageUrl();
        if (imageUrl != null && imageUrl.startsWith(UPLOAD_DIRECTORY)) {
            deleteOldImage(imageUrl);
        }

        // Delete the product
        if (productDAO.delete(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/products?success=deleted");
        } else {
            throw new ServletException("Database error: Failed to delete product");
        }
        
    } catch (ServletException e) {
        System.err.println("Error deleting product: " + e.getMessage());
        request.setAttribute("error", e.getMessage());
        doGet(request, response);
    } catch (Exception e) {
        System.err.println("Unexpected error deleting product: " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("error", "An unexpected error occurred while deleting the product");
        doGet(request, response);
    }
}
}
