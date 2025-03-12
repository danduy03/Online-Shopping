package controller.admin;

import dao.ArticleDAO;
import model.Article;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.Normalizer;
import java.util.regex.Pattern;

@WebServlet(name = "AdminArticleServlet", urlPatterns = {"/admin/articles", "/admin/articles/*"})
public class ArticleServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        
        // Check if user is logged in and has admin role
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List all articles
            request.setAttribute("articles", articleDAO.findAll());
            request.getRequestDispatcher("/admin/articles.jsp").forward(request, response);
        } else if (pathInfo.equals("/create")) {
            // Show create form
            request.getRequestDispatcher("/admin/article-form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show edit form
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                Article article = articleDAO.findById(id);
                if (article != null) {
                    request.setAttribute("article", article);
                    request.getRequestDispatcher("/admin/article-form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID format
            }
            response.sendRedirect(request.getContextPath() + "/admin/articles");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in and has admin role
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("create".equals(action) || "update".equals(action)) {
            Article article = new Article();
            if ("update".equals(action)) {
                article.setId(Long.parseLong(request.getParameter("id")));
            }
            
            article.setTitle(request.getParameter("title"));
            article.setContent(request.getParameter("content"));
            article.setThumbnail(request.getParameter("thumbnail"));
            article.setSummary(request.getParameter("summary"));
            article.setAuthor(request.getParameter("author"));
            article.setStatus(request.getParameter("status"));
            article.setSlug(generateSlug(article.getTitle()));
            
            boolean success;
            if ("create".equals(action)) {
                success = articleDAO.create(article);
            } else {
                success = articleDAO.update(article);
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/articles");
                return;
            }
        } else if ("delete".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                articleDAO.delete(id);
            } catch (NumberFormatException e) {
                // Invalid ID format
            }
            response.sendRedirect(request.getContextPath() + "/admin/articles");
            return;
        }
        
        // If we get here, something went wrong
        response.sendRedirect(request.getContextPath() + "/admin/articles?error=1");
    }
    
    private String generateSlug(String title) {
        String normalized = Normalizer.normalize(title, Normalizer.Form.NFD)
            .replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
            .toLowerCase();
        
        // Replace spaces and special characters with hyphens
        Pattern pattern = Pattern.compile("[^a-z0-9]+");
        String slug = pattern.matcher(normalized).replaceAll("-");
        
        // Remove leading/trailing hyphens
        slug = slug.replaceAll("^-+|-+$", "");
        
        return slug;
    }
}
