package dao;

import model.Cart;
import model.Product;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    private ProductDAO productDAO = new ProductDAO();
    
    public List<Cart> findByUserId(Long userId) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM cart WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Cart cartItem = mapResultSetToCart(rs);
                Product product = productDAO.findById(cartItem.getProductId());
                cartItem.setProduct(product);
                cartItems.add(cartItem);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
    
    public Cart findCartItem(Long userId, Long productId) {
        String sql = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            stmt.setLong(2, productId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Cart cartItem = mapResultSetToCart(rs);
                Product product = productDAO.findById(cartItem.getProductId());
                cartItem.setProduct(product);
                return cartItem;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addToCart(Cart cart) {
        String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, cart.getUserId());
            stmt.setLong(2, cart.getProductId());
            stmt.setInt(3, cart.getQuantity());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    cart.setId(generatedKeys.getLong(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateQuantity(Long cartId, int quantity) {
        String sql = "UPDATE cart SET quantity = ?, updated_at = GETDATE() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setLong(2, cartId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean removeFromCart(Long cartId) {
        String sql = "DELETE FROM cart WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cartId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean clearCart(Long userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getTotalQuantity(Long userId) {
        if (userId == null) {
            return 0;
        }
        
        String sql = "SELECT SUM(quantity) FROM cart WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int total = rs.getInt(1);
                return rs.wasNull() ? 0 : total;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setId(rs.getLong("id"));
        cart.setUserId(rs.getLong("user_id"));
        cart.setProductId(rs.getLong("product_id"));
        cart.setQuantity(rs.getInt("quantity"));
        cart.setCreatedAt(rs.getTimestamp("created_at"));
        cart.setUpdatedAt(rs.getTimestamp("updated_at"));
        return cart;
    }
}
