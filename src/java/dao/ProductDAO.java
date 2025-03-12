package dao;

import model.Product;
import utils.DatabaseUtil;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, u.username as creator_name " +
                    "FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.id " +
                    "LEFT JOIN users u ON p.created_by = u.id " +
                    "ORDER BY p.created_at DESC";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                // Set additional fields from joins
                product.setCategoryName(rs.getString("category_name"));
                String creatorName = rs.getString("creator_name");
                if (creatorName != null) {
                    product.setCreatorName(creatorName);
                }
                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("Error finding all products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    public Product findById(Long id) {
        String sql = "SELECT p.*, c.name as category_name, u.username as creator_name " +
                    "FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.id " +
                    "LEFT JOIN users u ON p.created_by = u.id " +
                    "WHERE p.id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                // Set additional fields from joins
                product.setCategoryName(rs.getString("category_name"));
                String creatorName = rs.getString("creator_name");
                if (creatorName != null) {
                    product.setCreatorName(creatorName);
                }
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Product> findByCategory(Long categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, u.username as creator_name " +
                    "FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.id " +
                    "LEFT JOIN users u ON p.created_by = u.id " +
                    "WHERE p.category_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                // Set additional fields from joins
                product.setCategoryName(rs.getString("category_name"));
                String creatorName = rs.getString("creator_name");
                if (creatorName != null) {
                    product.setCreatorName(creatorName);
                }
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public List<Product> search(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, u.username as creator_name " +
                    "FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.id " +
                    "LEFT JOIN users u ON p.created_by = u.id " +
                    "WHERE LOWER(p.name) LIKE ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword.toLowerCase() + "%";
            stmt.setString(1, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                // Set additional fields from joins
                product.setCategoryName(rs.getString("category_name"));
                String creatorName = rs.getString("creator_name");
                if (creatorName != null) {
                    product.setCreatorName(creatorName);
                }
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public boolean insert(Product product) {
        String sql = "INSERT INTO products (name, description, price, stock_quantity, image_url, " +
                    "category_id, created_by, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Validate required fields
            if (product.getName() == null || product.getName().trim().isEmpty()) {
                throw new SQLException("Product name is required");
            }
            if (product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
                throw new SQLException("Valid price is required");
            }
            if (product.getStockQuantity() < 0) {
                throw new SQLException("Stock quantity cannot be negative");
            }
            if (product.getCategoryId() == null) {
                throw new SQLException("Category is required");
            }
            
            // Set parameters
            int paramIndex = 1;
            stmt.setString(paramIndex++, product.getName().trim());
            stmt.setString(paramIndex++, product.getDescription() != null ? product.getDescription().trim() : "");
            stmt.setBigDecimal(paramIndex++, product.getPrice());
            stmt.setInt(paramIndex++, product.getStockQuantity());
            stmt.setString(paramIndex++, product.getImageUrl() != null ? product.getImageUrl().trim() : null);
            stmt.setLong(paramIndex++, product.getCategoryId());
            
            // Set created_by (can be null)
            if (product.getCreatedBy() != null) {
                stmt.setLong(paramIndex++, product.getCreatedBy());
            } else {
                stmt.setNull(paramIndex++, Types.BIGINT);
            }
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    product.setId(generatedKeys.getLong(1));
                    return true;
                }
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error inserting product: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to insert product: " + e.getMessage());
        }
    }
    
    public boolean update(Product product) {
        String sql = "UPDATE products SET name=?, description=?, price=?, " +
                    "stock_quantity=?, image_url=?, category_id=? WHERE id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStockQuantity());
            stmt.setString(5, product.getImageUrl());
            stmt.setLong(6, product.getCategoryId());
            stmt.setLong(7, product.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(Long id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateStock(Long productId, int quantity) {
        String sql = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setLong(2, productId);
            stmt.setInt(3, quantity);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> findAllByNewest() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, u.username as creator_name " +
                    "FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.id " +
                    "LEFT JOIN users u ON p.created_by = u.id " +
                    "ORDER BY p.created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                // Set additional fields from joins
                product.setCategoryName(rs.getString("category_name"));
                String creatorName = rs.getString("creator_name");
                if (creatorName != null) {
                    product.setCreatorName(creatorName);
                }
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> findAllByPopularity() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, u.username as creator_name, " +
                    "COUNT(o.id) as purchase_count " +
                    "FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.id " +
                    "LEFT JOIN users u ON p.created_by = u.id " +
                    "LEFT JOIN order_items o ON p.id = o.product_id " +
                    "WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 2 WEEK) " +
                    "GROUP BY p.id " +
                    "ORDER BY purchase_count DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                // Set additional fields from joins
                product.setCategoryName(rs.getString("category_name"));
                String creatorName = rs.getString("creator_name");
                if (creatorName != null) {
                    product.setCreatorName(creatorName);
                }
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> getTopSellingProducts(int limit) {
        String sql = "SELECT p.*, " +
                    "COUNT(oi.product_id) as total_sales, " +
                    "SUM(oi.price * oi.quantity) as revenue " +
                    "FROM Products p " +
                    "LEFT JOIN OrderItems oi ON p.id = oi.product_id " +
                    "LEFT JOIN Orders o ON o.id = oi.order_id " +
                    "GROUP BY p.id " +
                    "ORDER BY total_sales DESC " +
                    "LIMIT ?";
                    
        List<Product> products = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                product.setTotalSales(rs.getInt("total_sales"));
                product.setRevenue(rs.getBigDecimal("revenue"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getLong("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setImageUrl(rs.getString("image_url"));
        product.setCategoryId(rs.getLong("category_id"));
        
        // Handle nullable created_by
        long createdBy = rs.getLong("created_by");
        if (!rs.wasNull()) {
            product.setCreatedBy(createdBy);
        }
        
        // Handle timestamps
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            product.setCreatedAt(createdAt);
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            product.setUpdatedAt(updatedAt);
        }
        
        return product;
    }

    public int count() {
        String sql = "SELECT COUNT(*) FROM products";
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
}
