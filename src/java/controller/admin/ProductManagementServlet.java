//package controller.admin;
//
//import dao.ProductDAO;
//import model.Product;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import com.google.gson.JsonObject;
//
//import java.io.IOException;
//import java.math.BigDecimal;
//
//@WebServlet("/admin/products/*")
//public class ProductManagementServlet extends HttpServlet {
//    private ProductDAO productDAO;
//
//    @Override
//    public void init() throws ServletException {
//        productDAO = new ProductDAO();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String pathInfo = request.getPathInfo();
//        
//        if (pathInfo == null || pathInfo.equals("/")) {
//            // List all products for admin
//            request.setAttribute("products", productDAO.getAllProducts());
//            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
//        } else if (pathInfo.equals("/edit")) {
//            // Show edit form
//            Long productId = Long.parseLong(request.getParameter("id"));
//            Product product = productDAO.getProductById(productId);
//            request.setAttribute("product", product);
//            request.getRequestDispatcher("/admin/edit-product.jsp").forward(request, response);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String pathInfo = request.getPathInfo();
//        
//        if (pathInfo.equals("/delete")) {
//            handleDelete(request, response);
//        } else if (pathInfo.equals("/update")) {
//            handleUpdate(request, response);
//        } else if (pathInfo.equals("/add")) {
//            handleAdd(request, response);
//        }
//    }
//
//    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
//            throws IOException {
//        Long productId = Long.parseLong(request.getParameter("productId"));
//        JsonObject jsonResponse = new JsonObject();
//        
//        boolean success = productDAO.delete(productId);
//        jsonResponse.addProperty("success", success);
//        
//        if (!success) {
//            jsonResponse.addProperty("error", "Failed to delete product");
//        }
//        
//        response.setContentType("application/json");
//        response.getWriter().write(jsonResponse.toString());
//    }
//
//    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
//            throws IOException {
//        Product product = new Product();
//        product.setId(Long.parseLong(request.getParameter("id")));
//        product.setName(request.getParameter("name"));
//        product.setDescription(request.getParameter("description"));
//        product.setPrice(new BigDecimal(request.getParameter("price")));
//        product.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
//        product.setCategory(request.getParameter("category"));
//        product.setImagePath(request.getParameter("imagePath"));
//
//        boolean success = productDAO.update(product);
//        
//        JsonObject jsonResponse = new JsonObject();
//        jsonResponse.addProperty("success", success);
//        
//        if (!success) {
//            jsonResponse.addProperty("error", "Failed to update product");
//        }
//        
//        response.setContentType("application/json");
//        response.getWriter().write(jsonResponse.toString());
//    }
//
//    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
//            throws IOException {
//        Product product = new Product();
//        product.setName(request.getParameter("name"));
//        product.setDescription(request.getParameter("description"));
//        product.setPrice(new BigDecimal(request.getParameter("price")));
//        product.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
//        product.setCategory(request.getParameter("category"));
//        product.setImagePath(request.getParameter("imagePath"));
//
//        boolean success = productDAO.insert(product);
//        
//        JsonObject jsonResponse = new JsonObject();
//        jsonResponse.addProperty("success", success);
//        
//        if (!success) {
//            jsonResponse.addProperty("error", "Failed to add product");
//        }
//        
//        response.setContentType("application/json");
//        response.getWriter().write(jsonResponse.toString());
//    }
//}
