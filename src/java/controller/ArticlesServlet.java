package controller;

import dao.ArticleDAO;
import model.Article;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "PublicArticlesServlet", urlPatterns = {"/articles", "/articles/*"})
public class ArticlesServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List all published articles
            request.setAttribute("articles", articleDAO.findPublished());
            request.getRequestDispatcher("/articles.jsp").forward(request, response);
        } else {
            // Show single article
            String slug = pathInfo.substring(1);
            Article article = articleDAO.findBySlug(slug);
            
            if (article != null && "published".equals(article.getStatus())) {
                articleDAO.incrementViewCount(article.getId());
                request.setAttribute("article", article);
                request.getRequestDispatcher("/article-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/articles");
            }
        }
    }
}
