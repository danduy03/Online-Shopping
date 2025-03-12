package dao;

import model.Order;
import model.OrderItem;
import model.Product;
import utils.DatabaseUtil;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.time.LocalDateTime;

public class OrderDAO {
    
    public boolean createOrder(Order order, List<OrderItem> orderItems) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Insert order
            String orderSql = "INSERT INTO orders (user_id, full_name, phone, email, province, " +
                            "district, commune, address, notes, discount_code, discount_amount, " +
                            "shipping_cost, subtotal, total_amount, status, created_at) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
            
            stmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            
            // Debug log the values being inserted
            System.out.println("Inserting order with values:");
            System.out.println("user_id: " + order.getUserId());
            System.out.println("full_name: " + order.getFullName());
            System.out.println("phone: " + order.getPhone());
            System.out.println("email: " + order.getEmail());
            System.out.println("province: " + order.getProvince());
            System.out.println("district: " + order.getDistrict());
            System.out.println("commune: " + order.getCommune());
            System.out.println("address: " + order.getAddress());
            
            stmt.setLong(1, order.getUserId());
            stmt.setString(2, order.getFullName());
            stmt.setString(3, order.getPhone());
            stmt.setString(4, order.getEmail());
            stmt.setString(5, order.getProvince());
            stmt.setString(6, order.getDistrict());
            stmt.setString(7, order.getCommune());
            stmt.setString(8, order.getAddress());
            stmt.setString(9, order.getNotes());
            stmt.setString(10, order.getDiscountCode());
            stmt.setBigDecimal(11, order.getDiscountAmount() != null ? order.getDiscountAmount() : BigDecimal.ZERO);
            stmt.setBigDecimal(12, order.getShippingCost());
            stmt.setBigDecimal(13, order.getSubtotal());
            stmt.setBigDecimal(14, order.getTotalAmount());
            stmt.setString(15, order.getStatus());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                order.setId(rs.getLong(1));
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }
            
            // Insert order items
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(itemSql);
            
            for (OrderItem item : orderItems) {
                stmt.setLong(1, order.getId());
                stmt.setLong(2, item.getProductId());
                stmt.setInt(3, item.getQuantity());
                stmt.setBigDecimal(4, item.getPrice());
                stmt.addBatch();
            }
            
            stmt.executeBatch();
            conn.commit();
            return true;
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error during rollback: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
            System.err.println("Error creating order: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.closeAll(conn, stmt, rs);
        }
    }
    
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
    Order order = new Order();
    order.setId(rs.getLong("id"));
    order.setUserId(rs.getLong("user_id"));
    order.setFullName(rs.getString("full_name"));
    order.setPhone(rs.getString("phone")); 
    order.setEmail(rs.getString("email"));
    order.setProvince(rs.getString("province"));
    order.setDistrict(rs.getString("district"));
    order.setCommune(rs.getString("commune"));
    order.setAddress(rs.getString("address"));
    order.setNotes(rs.getString("notes"));
    order.setDiscountCode(rs.getString("discount_code"));
    order.setDiscountAmount(rs.getBigDecimal("discount_amount"));
    order.setShippingCost(rs.getBigDecimal("shipping_cost"));
    order.setSubtotal(rs.getBigDecimal("subtotal")); 
    order.setTotalAmount(rs.getBigDecimal("total_amount"));
    order.setStatus(rs.getString("status"));
    
    // Set orderDate và createdAt 
    Timestamp createdAt = rs.getTimestamp("created_at");
    order.setCreatedAt(createdAt);
    order.setOrderDate(createdAt); // Set orderDate = createdAt
    
    return order;
}
    
    public Order findById(Long id) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Load order items
                order.setOrderItems(findOrderItems(order.getId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private List<OrderItem> findOrderItems(Long orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name as product_name, p.image_url as product_image " +
                    "FROM order_items oi " +
                    "JOIN products p ON oi.product_id = p.id " +
                    "WHERE oi.order_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getLong("id"));
                item.setOrderId(rs.getLong("order_id"));
                item.setProductId(rs.getLong("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                
                // Initialize product object
                Product product = new Product();
                product.setId(rs.getLong("product_id"));
                product.setName(rs.getString("product_name"));
                product.setImageUrl(rs.getString("product_image"));
                item.setProduct(product);
                
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    
    public List<Order> findByUserId(Long userId) {
    List<Order> orders = new ArrayList<>();
    String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
    
    try (Connection conn = DatabaseUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setLong(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            Order order = new Order();
            order.setId(rs.getLong("id"));
            order.setUserId(rs.getLong("user_id"));
            order.setTotalAmount(rs.getBigDecimal("total_amount"));
            order.setStatus(rs.getString("status"));
            // Ghép các trường địa chỉ thành shipping_address
            String shippingAddress = String.format("%s, %s, %s, %s",
                rs.getString("address"),
                rs.getString("commune"),
                rs.getString("district"),
                rs.getString("province"));
            order.setShippingAddress(shippingAddress);
            order.setCreatedAt(rs.getTimestamp("created_at"));
            order.setUpdatedAt(rs.getTimestamp("updated_at"));
            orders.add(order);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return orders;
}
    
    public List<Order> findRecentByUserId(Long userId, int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM orders o " +
                    "JOIN users u ON o.user_id = u.id " +
                    "WHERE o.user_id = ? " +
                    "ORDER BY o.created_at DESC " +
                    "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                orders.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong("id"));
        order.setUserId(rs.getLong("user_id"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        order.setUsername(rs.getString("username"));
        return order;
    }
    
    public List<Order> getRecentOrders(int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name " +
                    "FROM orders o " +
                    "LEFT JOIN users u ON o.user_id = u.id " +
                    "ORDER BY o.created_at DESC LIMIT ?";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getLong("id"));
                order.setUserId(rs.getLong("user_id"));
                order.setFullName(rs.getString("full_name"));
                order.setStatus(rs.getString("status"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public int getTotalOrdersLast30Days() {
        String sql = "SELECT COUNT(*) FROM orders WHERE created_at >= DATEADD(day, -30, GETDATE())";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public BigDecimal getTotalRevenueLast30Days() {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE created_at >= DATEADD(day, -30, GETDATE())";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name, u.email " +
                    "FROM orders o " +
                    "LEFT JOIN users u ON o.user_id = u.id " +
                    "ORDER BY o.created_at DESC";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getLong("id"));
                order.setUserId(rs.getLong("user_id"));
                order.setFullName(rs.getString("full_name"));
                order.setEmail(rs.getString("email"));
                order.setStatus(rs.getString("status"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setPhone(rs.getString("phone"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setOrderItems(findOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public boolean delete(Long id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // First delete all order items
            String deleteItemsSql = "DELETE FROM order_items WHERE order_id = ?";
            stmt = conn.prepareStatement(deleteItemsSql);
            stmt.setLong(1, id);
            stmt.executeUpdate();
            
            // Then delete the order
            String deleteOrderSql = "DELETE FROM orders WHERE id = ?";
            stmt = conn.prepareStatement(deleteOrderSql);
            stmt.setLong(1, id);
            int affectedRows = stmt.executeUpdate();
            
            conn.commit();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error during rollback: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
            System.err.println("Error deleting order: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.closeAll(conn, stmt, null);
        }
    }
    
    public boolean update(Order order) {
        String sql = "UPDATE orders SET status = ?, shipping_cost = ?, discount_code = ?, " +
                    "discount_amount = ?, subtotal = ?, total_amount = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, order.getStatus());
            stmt.setBigDecimal(2, order.getShippingCost());
            stmt.setString(3, order.getDiscountCode());
            stmt.setBigDecimal(4, order.getDiscountAmount());
            stmt.setBigDecimal(5, order.getSubtotal());
            stmt.setBigDecimal(6, order.getTotalAmount());
            stmt.setLong(7, order.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateStatus(Long orderId, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Update order status
            String updateSql = "UPDATE orders SET status = ?, updated_at = GETDATE() WHERE id = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setString(1, status.toUpperCase());
            stmt.setLong(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            
            // If status is DELIVERED, update revenue
            if (status.equalsIgnoreCase("DELIVERED")) {
                String revenueSql = "INSERT INTO revenue (order_id, amount, date) " +
                                  "SELECT id, total_amount, GETDATE() " +
                                  "FROM orders WHERE id = ? AND id NOT IN (SELECT order_id FROM revenue)";
                stmt = conn.prepareStatement(revenueSql);
                stmt.setLong(1, orderId);
                stmt.executeUpdate();
            }
            
            conn.commit();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error during rollback: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
            System.err.println("Error updating order status: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.closeAll(conn, stmt, null);
        }
    }
    
    public int getTotalOrdersByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE created_at BETWEEN ? AND ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total orders by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    public BigDecimal getTotalRevenueByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM Orders WHERE created_at BETWEEN ? AND ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total revenue by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getAverageOrderValueByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT COALESCE(AVG(total_amount), 0) FROM Orders WHERE created_at BETWEEN ? AND ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting average order value by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getTotalRevenueByDate(LocalDateTime date) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM Orders " +
                    "WHERE DATE(created_at) = DATE(?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(date));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total revenue by date: " + e.getMessage());
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    public Map<String, BigDecimal> getRevenueByCategoryByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT c.name, COALESCE(SUM(oi.price * oi.quantity), 0) as revenue " +
                    "FROM Categories c " +
                    "LEFT JOIN Products p ON p.category_id = c.id " +
                    "LEFT JOIN OrderItems oi ON oi.product_id = p.id " +
                    "LEFT JOIN Orders o ON o.id = oi.order_id " +
                    "WHERE o.created_at BETWEEN ? AND ? " +
                    "GROUP BY c.name";
                    
        Map<String, BigDecimal> categoryRevenue = new HashMap<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                categoryRevenue.put(rs.getString("name"), rs.getBigDecimal("revenue"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting revenue by category by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return categoryRevenue;
    }
    
    public List<Order> getOrdersByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE created_at BETWEEN ? AND ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting orders by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }
    
    public int count() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("Error counting orders: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
}
