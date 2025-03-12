package dao;

import model.DiscountCode;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiscountCodeDAO {
    public DiscountCode findByCode(String code) {
        String sql = "SELECT * FROM discount_codes WHERE code = ? AND is_active = true";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDiscountCode(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<DiscountCode> findAll() {
        List<DiscountCode> discountCodes = new ArrayList<>();
        String sql = "SELECT * FROM discount_codes ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                discountCodes.add(mapResultSetToDiscountCode(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discountCodes;
    }

    public DiscountCode findById(int id) {
        String sql = "SELECT * FROM discount_codes WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDiscountCode(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(DiscountCode discountCode) {
        String sql = "INSERT INTO discount_codes (code, description, discount_type, discount_value, " +
                    "min_purchase_amount, max_discount_amount, start_date, end_date, " +
                    "max_uses, used_count, is_active, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, discountCode.getCode());
            ps.setString(2, discountCode.getDescription());
            ps.setString(3, discountCode.getDiscountType());
            ps.setDouble(4, discountCode.getDiscountValue());
            ps.setDouble(5, discountCode.getMinPurchaseAmount());
            ps.setDouble(6, discountCode.getMaxDiscountAmount());
            ps.setTimestamp(7, discountCode.getStartDate());
            ps.setTimestamp(8, discountCode.getEndDate());
            ps.setInt(9, discountCode.getMaxUses());
            ps.setInt(10, discountCode.getUsedCount());
            ps.setBoolean(11, discountCode.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error creating discount code: " + e.getMessage());
            return false;
        }
    }

    public boolean update(DiscountCode discountCode) {
        String sql = "UPDATE discount_codes SET code = ?, description = ?, discount_type = ?, " +
                    "discount_value = ?, min_purchase_amount = ?, max_discount_amount = ?, " +
                    "start_date = ?, end_date = ?, max_uses = ?, used_count = ?, " +
                    "is_active = ?, updated_at = GETDATE() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, discountCode.getCode());
            ps.setString(2, discountCode.getDescription());
            ps.setString(3, discountCode.getDiscountType());
            ps.setDouble(4, discountCode.getDiscountValue());
            ps.setDouble(5, discountCode.getMinPurchaseAmount());
            ps.setDouble(6, discountCode.getMaxDiscountAmount());
            ps.setTimestamp(7, discountCode.getStartDate());
            ps.setTimestamp(8, discountCode.getEndDate());
            ps.setInt(9, discountCode.getMaxUses());
            ps.setInt(10, discountCode.getUsedCount());
            ps.setBoolean(11, discountCode.isActive());
            ps.setInt(12, discountCode.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean incrementUses(String code) {
        String sql = "UPDATE discount_codes SET used_count = used_count + 1 WHERE code = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, code);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int id, boolean isActive) {
        String sql = "UPDATE discount_codes SET is_active = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM discount_codes WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private DiscountCode mapResultSetToDiscountCode(ResultSet rs) throws SQLException {
        DiscountCode discountCode = new DiscountCode();
        discountCode.setId(rs.getInt("id"));
        discountCode.setCode(rs.getString("code"));
        discountCode.setDescription(rs.getString("description"));
        discountCode.setDiscountType(rs.getString("discount_type"));
        discountCode.setDiscountValue(rs.getDouble("discount_value"));
        discountCode.setMinPurchaseAmount(rs.getDouble("min_purchase_amount"));
        discountCode.setMaxDiscountAmount(rs.getDouble("max_discount_amount"));
        discountCode.setStartDate(rs.getTimestamp("start_date"));
        discountCode.setEndDate(rs.getTimestamp("end_date"));
        discountCode.setMaxUses(rs.getInt("max_uses"));
        discountCode.setUsedCount(rs.getInt("used_count"));
        discountCode.setActive(rs.getBoolean("is_active"));
        discountCode.setCreatedAt(rs.getTimestamp("created_at"));
        discountCode.setUpdatedAt(rs.getTimestamp("updated_at"));
        return discountCode;
    }
}
