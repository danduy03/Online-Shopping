package dao;

import model.User;
import utils.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

public class UserDAO {
    
    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public User findById(Long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("Error finding user by email '%s': %s", email, e.getMessage());
            System.err.println(errorMsg);
            e.printStackTrace();
            throw new RuntimeException(errorMsg, e);
        }
        return null;
    }
    
    public User create(User user) {
        String sql = "INSERT INTO users (username, email, password, first_name, last_name, "
                + "full_name, role, is_admin, address, phone, oauth_provider, oauth_id, "
                + "profile_picture, last_login, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), GETDATE())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Calculate full name with proper spacing for Unicode
            String firstName = user.getFirstName();
            String lastName = user.getLastName();
            String fullName = "";
            
            if (firstName != null) {
                firstName = firstName.trim();
            }
            if (lastName != null) {
                lastName = lastName.trim();
            }
            
            if (firstName != null && !firstName.isEmpty()) {
                fullName = firstName;
                if (lastName != null && !lastName.isEmpty()) {
                    fullName += " " + lastName;
                }
            } else if (lastName != null && !lastName.isEmpty()) {
                fullName = lastName;
            }
            
            // Store role with first letter capitalized
            String role = user.getRole();
            if (role != null && !role.isEmpty()) {
                role = Character.toUpperCase(role.charAt(0)) + role.substring(1).toLowerCase();
            } else {
                role = "User";  // Default role with capital U
            }
            
            // Set parameters in the correct order
            ps.setNString(1, user.getUsername());
            ps.setNString(2, user.getEmail());
            ps.setNString(3, user.getPassword());
            ps.setNString(4, firstName);
            ps.setNString(5, lastName);
            ps.setNString(6, fullName);
            ps.setNString(7, role);
            ps.setBoolean(8, user.isAdmin());
            ps.setNString(9, user.getAddress());
            ps.setNString(10, user.getPhone());
            ps.setNString(11, user.getOauthProvider());
            ps.setNString(12, user.getOauthId());
            ps.setNString(13, user.getProfilePicture());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getLong(1));
                    return user;
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error creating user: " + e.getMessage(), e);
        }
    }
    
    public void update(User user) {
        String sql = "UPDATE users SET username=?, email=?, password=?, first_name=?, "
                + "last_name=?, full_name=?, role=?, is_admin=?, address=?, phone=?, "
                + "oauth_provider=?, oauth_id=?, profile_picture=?, updated_at=GETDATE() "
                + "WHERE id=?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Calculate full name with proper spacing for Unicode
            String firstName = user.getFirstName();
            String lastName = user.getLastName();
            String fullName = "";
            
            if (firstName != null) {
                firstName = firstName.trim();
            }
            if (lastName != null) {
                lastName = lastName.trim();
            }
            
            if (firstName != null && !firstName.isEmpty()) {
                fullName = firstName;
                if (lastName != null && !lastName.isEmpty()) {
                    fullName += " " + lastName;
                }
            } else if (lastName != null && !lastName.isEmpty()) {
                fullName = lastName;
            }
            
            // Store role with first letter capitalized
            String role = user.getRole();
            if (role != null && !role.isEmpty()) {
                role = Character.toUpperCase(role.charAt(0)) + role.substring(1).toLowerCase();
            } else {
                role = "User";  // Default role with capital U
            }
            
            // Set parameters in the correct order
            ps.setNString(1, user.getUsername());
            ps.setNString(2, user.getEmail());
            ps.setNString(3, user.getPassword());
            ps.setNString(4, firstName);
            ps.setNString(5, lastName);
            ps.setNString(6, fullName);
            ps.setNString(7, role);
            ps.setBoolean(8, user.isAdmin());
            ps.setNString(9, user.getAddress());
            ps.setNString(10, user.getPhone());
            ps.setNString(11, user.getOauthProvider());
            ps.setNString(12, user.getOauthId());
            ps.setNString(13, user.getProfilePicture());
            ps.setLong(14, user.getId());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected by update: " + rowsAffected);
            
            if (rowsAffected == 0) {
                throw new SQLException("Update failed, no rows affected. User ID: " + user.getId());
            }
        } catch (SQLException e) {
            System.err.println("SQL Error updating user with ID " + user.getId() + ": " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            throw new RuntimeException("Error updating user: " + e.getMessage(), e);
        }
    }
    
    public boolean delete(Long id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public int getTotalUsers() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public int getTotalVisitorsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT COUNT(DISTINCT session_id) FROM UserVisits WHERE visit_time BETWEEN ? AND ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int count() {
        String sql = "SELECT COUNT(*) FROM users";
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
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        try {
            User user = new User();
            user.setId(rs.getLong("id"));
            user.setUsername(rs.getNString("username"));
            user.setEmail(rs.getNString("email"));
            user.setPassword(rs.getNString("password"));
            user.setFirstName(rs.getNString("first_name"));
            user.setLastName(rs.getNString("last_name"));
            user.setFullName(rs.getNString("full_name"));
            
            // Get role directly since it's already capitalized in database
            String role = rs.getNString("role");
            user.setRole(role != null ? role : "User");
            
            user.setAdmin(rs.getBoolean("is_admin"));
            user.setAddress(rs.getNString("address"));
            user.setPhone(rs.getNString("phone"));
            user.setOauthProvider(rs.getNString("oauth_provider"));
            user.setOauthId(rs.getNString("oauth_id"));
            user.setProfilePicture(rs.getNString("profile_picture"));
            user.setLastLogin(rs.getTimestamp("last_login"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
            return user;
        } catch (SQLException e) {
            String errorMsg = "Error mapping ResultSet to User: " + e.getMessage();
            System.err.println(errorMsg);
            e.printStackTrace();
            throw new SQLException(errorMsg, e);
        }
    }
}
