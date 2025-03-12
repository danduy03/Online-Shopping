package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String categoryId = request.getParameter("id");
        
        if (categoryId != null && !categoryId.isEmpty()) {
            // Show products in specific category
            List<Product> products = productDAO.findByCategory(Long.parseLong(categoryId));
            Category category = categoryDAO.findById(Long.parseLong(categoryId));
            request.setAttribute("selectedCategory", category);
            request.setAttribute("products", products);
        }
        
        // Get all categories for the sidebar
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/categories.jsp").forward(request, response);
    }
}

