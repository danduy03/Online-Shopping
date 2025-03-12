package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        String sortBy = request.getParameter("sort");
        String categoryId = request.getParameter("category");
        
        // Update cart count in session for logged-in users
        jakarta.servlet.http.HttpSession session = request.getSession();
        model.User user = (model.User) session.getAttribute("user");
        
        // Only update cart count if user is logged in
        if (user != null && user.getId() != null) {
            dao.CartDAO cartDAO = new dao.CartDAO();
            int cartCount = cartDAO.getTotalQuantity(user.getId());
            session.setAttribute("cartCount", cartCount);
        } else {
            session.setAttribute("cartCount", 0);
        }
        
        List<Product> products;
        
        try {
            // Get all categories for the category section
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);

            if (categoryId != null && !categoryId.trim().isEmpty()) {
                // Filter by category
                products = productDAO.findByCategory(Long.parseLong(categoryId));
            } else if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                products = productDAO.search(searchQuery.trim());
            } else if (sortBy != null) {
                switch (sortBy) {
                    case "newest":
                        products = productDAO.findAllByNewest();
                        break;
                    case "popular":
                        products = productDAO.findAllByPopularity();
                        break;
                    default:
                        products = productDAO.findAll();
                }
            } else {
                products = productDAO.findAll();
            }
            
            // Additional in-memory sorting if needed
            if (sortBy != null && products != null) {
                switch (sortBy) {
                    case "name":
                        products.sort((p1, p2) -> p1.getName().compareToIgnoreCase(p2.getName()));
                        break;
                    case "price_asc":
                        products.sort((p1, p2) -> p1.getPrice().compareTo(p2.getPrice()));
                        break;
                    case "price_desc":
                        products.sort((p1, p2) -> p2.getPrice().compareTo(p1.getPrice()));
                        break;
                }
            }
            
            request.setAttribute("products", products);
            request.getRequestDispatcher("/products.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
