package dao;

import model.Discount;
import utils.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiscountDAO {
    private final DatabaseUtil db;

    public DiscountDAO() {
        db = new DatabaseUtil();
    }

    public List<Discount> findAll() {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM discounts ORDER BY created_at DESC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                discounts.add(mapResultSetToDiscount(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discounts;
    }

    public Discount findById(Long id) {
        String sql = "SELECT * FROM discounts WHERE id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscount(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Discount findByCode(String code) {
        String sql = "SELECT * FROM discounts WHERE code = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscount(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Discount discount) {
        String sql = "INSERT INTO discounts (code, description, discount_type, discount_value, " +
                    "min_purchase_amount, max_discount_amount, start_date, end_date, max_uses, " +
                    "used_count, active, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            setDiscountParameters(ps, discount);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        discount.setId(generatedKeys.getLong(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Discount discount) {
        String sql = "UPDATE discounts SET code = ?, description = ?, discount_type = ?, " +
                    "discount_value = ?, min_purchase_amount = ?, max_discount_amount = ?, " +
                    "start_date = ?, end_date = ?, max_uses = ?, used_count = ?, active = ?, " +
                    "updated_at = ? WHERE id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setDiscountParameters(ps, discount);
            ps.setLong(13, discount.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(Long id) {
        String sql = "DELETE FROM discounts WHERE id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean incrementUsedCount(Long id) {
        String sql = "UPDATE discounts SET used_count = used_count + 1, " +
                    "updated_at = ? WHERE id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, new Timestamp(new java.util.Date().getTime()));
            ps.setLong(2, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Discount mapResultSetToDiscount(ResultSet rs) throws SQLException {
        Discount discount = new Discount();
        discount.setId(rs.getLong("id"));
        discount.setCode(rs.getString("code"));
        discount.setDescription(rs.getString("description"));
        discount.setDiscountType(rs.getString("discount_type"));
        discount.setDiscountValue(rs.getBigDecimal("discount_value"));
        discount.setMinPurchaseAmount(rs.getBigDecimal("min_purchase_amount"));
        discount.setMaxDiscountAmount(rs.getBigDecimal("max_discount_amount"));
        discount.setStartDate(rs.getTimestamp("start_date"));
        discount.setEndDate(rs.getTimestamp("end_date"));
        discount.setMaxUses(rs.getInt("max_uses"));
        discount.setUsedCount(rs.getInt("used_count"));
        discount.setActive(rs.getBoolean("active"));
        discount.setCreatedAt(rs.getTimestamp("created_at"));
        discount.setUpdatedAt(rs.getTimestamp("updated_at"));
        return discount;
    }

    private void setDiscountParameters(PreparedStatement ps, Discount discount) throws SQLException {
        ps.setString(1, discount.getCode());
        ps.setString(2, discount.getDescription());
        ps.setString(3, discount.getDiscountType());
        ps.setBigDecimal(4, discount.getDiscountValue());
        ps.setBigDecimal(5, discount.getMinPurchaseAmount());
        ps.setBigDecimal(6, discount.getMaxDiscountAmount());
        ps.setTimestamp(7, new Timestamp(discount.getStartDate().getTime()));
        ps.setTimestamp(8, new Timestamp(discount.getEndDate().getTime()));
        ps.setInt(9, discount.getMaxUses());
        ps.setInt(10, discount.getUsedCount());
        ps.setBoolean(11, discount.isActive());
        ps.setTimestamp(12, new Timestamp(discount.getCreatedAt().getTime()));
        ps.setTimestamp(13, new Timestamp(discount.getUpdatedAt().getTime()));
    }
}
