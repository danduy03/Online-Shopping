package dao;

import model.Article;
import utils.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {
    
    public List<Article> findAll() {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT * FROM articles ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                articles.add(mapResultSetToArticle(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articles;
    }
    
    public Article findById(Long id) {
        String sql = "SELECT * FROM articles WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToArticle(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Article findBySlug(String slug) {
        String sql = "SELECT * FROM articles WHERE slug = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, slug);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToArticle(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean create(Article article) {
        String sql = "INSERT INTO articles (title, content, thumbnail, summary, author, status, slug) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, article.getTitle());
            stmt.setString(2, article.getContent());
            stmt.setString(3, article.getThumbnail());
            stmt.setString(4, article.getSummary());
            stmt.setString(5, article.getAuthor());
            stmt.setString(6, article.getStatus());
            stmt.setString(7, article.getSlug());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    article.setId(generatedKeys.getLong(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(Article article) {
        String sql = "UPDATE articles SET title = ?, content = ?, thumbnail = ?, " +
                    "summary = ?, status = ?, slug = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, article.getTitle());
            stmt.setString(2, article.getContent());
            stmt.setString(3, article.getThumbnail());
            stmt.setString(4, article.getSummary());
            stmt.setString(5, article.getStatus());
            stmt.setString(6, article.getSlug());
            stmt.setLong(7, article.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(Long id) {
        String sql = "DELETE FROM articles WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalArticles() {
        String sql = "SELECT COUNT(*) FROM articles";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    public List<Article> findPublished() {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT * FROM articles WHERE status = 'published' ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                articles.add(mapResultSetToArticle(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articles;
    }
    
    public boolean incrementViewCount(Long id) {
        String sql = "UPDATE articles SET view_count = view_count + 1 WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Article mapResultSetToArticle(ResultSet rs) throws SQLException {
        Article article = new Article();
        article.setId(rs.getLong("id"));
        article.setTitle(rs.getString("title"));
        article.setContent(rs.getString("content"));
        article.setThumbnail(rs.getString("thumbnail"));
        article.setSummary(rs.getString("summary"));
        article.setAuthor(rs.getString("author"));
        article.setCreatedAt(rs.getTimestamp("created_at"));
        article.setUpdatedAt(rs.getTimestamp("updated_at"));
        article.setStatus(rs.getString("status"));
        article.setSlug(rs.getString("slug"));
        article.setViewCount(rs.getInt("view_count"));
        return article;
    }
}
