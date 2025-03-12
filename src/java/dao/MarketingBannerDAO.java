package dao;

import model.MarketingBanner;
import utils.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MarketingBannerDAO {
    
    public List<MarketingBanner> findAll() {
        List<MarketingBanner> banners = new ArrayList<>();
        String sql = "SELECT * FROM marketing_banners ORDER BY priority DESC, created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                banners.add(mapResultSetToBanner(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return banners;
    }
    
    public List<MarketingBanner> getActiveBannersByPosition(String position) {
        List<MarketingBanner> banners = new ArrayList<>();
        String sql = """
            SELECT * FROM marketing_banners 
            WHERE position = ? 
            AND is_active = 1 
            AND (start_date IS NULL OR start_date <= GETDATE()) 
            AND (end_date IS NULL OR end_date >= GETDATE()) 
            ORDER BY priority DESC, created_at DESC
        """;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, position);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                banners.add(mapResultSetToBanner(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return banners;
    }
    
    public MarketingBanner getById(int id) {
        String sql = "SELECT * FROM marketing_banners WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToBanner(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean save(MarketingBanner banner) {
        String sql = """
            INSERT INTO marketing_banners (title, description, image_url, link_url, 
            start_date, end_date, position, priority, is_active) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, banner.getTitle());
            ps.setString(2, banner.getDescription());
            ps.setString(3, banner.getImageUrl());
            ps.setString(4, banner.getLinkUrl());
            ps.setTimestamp(5, banner.getStartDate() != null ? Timestamp.valueOf(banner.getStartDate()) : null);
            ps.setTimestamp(6, banner.getEndDate() != null ? Timestamp.valueOf(banner.getEndDate()) : null);
            ps.setString(7, banner.getPosition());
            ps.setInt(8, banner.getPriority());
            ps.setBoolean(9, banner.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean update(MarketingBanner banner) {
        String sql = """
            UPDATE marketing_banners 
            SET title = ?, description = ?, image_url = ?, link_url = ?, 
                start_date = ?, end_date = ?, position = ?, priority = ?, 
                is_active = ?, updated_at = GETDATE() 
            WHERE id = ?
        """;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, banner.getTitle());
            ps.setString(2, banner.getDescription());
            ps.setString(3, banner.getImageUrl());
            ps.setString(4, banner.getLinkUrl());
            ps.setTimestamp(5, banner.getStartDate() != null ? Timestamp.valueOf(banner.getStartDate()) : null);
            ps.setTimestamp(6, banner.getEndDate() != null ? Timestamp.valueOf(banner.getEndDate()) : null);
            ps.setString(7, banner.getPosition());
            ps.setInt(8, banner.getPriority());
            ps.setBoolean(9, banner.isActive());
            ps.setInt(10, banner.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM marketing_banners WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private MarketingBanner mapResultSetToBanner(ResultSet rs) throws SQLException {
        MarketingBanner banner = new MarketingBanner();
        banner.setId(rs.getInt("id"));
        banner.setTitle(rs.getString("title"));
        banner.setDescription(rs.getString("description"));
        banner.setImageUrl(rs.getString("image_url"));
        banner.setLinkUrl(rs.getString("link_url"));
        banner.setStartDate(rs.getTimestamp("start_date") != null ? 
            rs.getTimestamp("start_date").toLocalDateTime() : null);
        banner.setEndDate(rs.getTimestamp("end_date") != null ? 
            rs.getTimestamp("end_date").toLocalDateTime() : null);
        banner.setPosition(rs.getString("position"));
        banner.setPriority(rs.getInt("priority"));
        banner.setActive(rs.getBoolean("is_active"));
        return banner;
    }
}
