package controller.admin;

import dao.CategoryDAO;
import model.Category;
import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
public class AdminCategoriesServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = SessionUtil.getUser(session);
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        // Get all categories
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = SessionUtil.getUser(session);
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createCategory(request, response);
                    break;
                case "update":
                    updateCategory(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Operation failed: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Category category = new Category();
        category.setName(request.getParameter("name"));
        category.setDescription(request.getParameter("description"));

        if (categoryDAO.insert(category)) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?success=created");
        } else {
            request.setAttribute("error", "Failed to create category");
            doGet(request, response);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Category category = new Category();
        category.setId(Long.parseLong(request.getParameter("id")));
        category.setName(request.getParameter("name"));
        category.setDescription(request.getParameter("description"));

        if (categoryDAO.update(category)) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?success=updated");
        } else {
            request.setAttribute("error", "Failed to update category");
            doGet(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        if (categoryDAO.delete(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?success=deleted");
        } else {
            request.setAttribute("error", "Failed to delete category");
            doGet(request, response);
        }
    }
}
