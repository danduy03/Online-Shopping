package dao;

import model.Feedback;
import model.FeedbackResponse;
import utils.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    
    //==========================================================================
    // TABLE CREATION METHODS
    //==========================================================================
    
    private void createFeedbackTableIfNotExists() {
        String sql = "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND type in (N'U'))\n" +
                    "BEGIN\n" +
                    "    CREATE TABLE feedback (\n" +
                    "        id BIGINT IDENTITY(1,1) PRIMARY KEY,\n" +
                    "        user_id BIGINT NOT NULL,\n" +
                    "        user_name NVARCHAR(255),\n" +
                    "        subject NVARCHAR(255) NOT NULL,\n" +
                    "        description NVARCHAR(MAX) NOT NULL,\n" +
                    "        type NVARCHAR(50) NOT NULL,\n" +
                    "        status NVARCHAR(50) NOT NULL DEFAULT 'OPEN',\n" +
                    "        priority NVARCHAR(50) NOT NULL DEFAULT 'Medium',\n" +
                    "        attachment_path NVARCHAR(255),\n" +
                    "        created_at DATETIME DEFAULT GETDATE(),\n" +
                    "        updated_at DATETIME DEFAULT GETDATE(),\n" +
                    "        CONSTRAINT CK_feedback_type CHECK (type IN ('Bug Report', 'Feature Request', 'General Feedback', 'Support Request')),\n" +
                    "        CONSTRAINT CK_feedback_status CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),\n" +
                    "        CONSTRAINT CK_feedback_priority CHECK (priority IN ('Low', 'Medium', 'High'))\n" +
                    "    )\n" +
                    "END;\n" +
                    "\n" +
                    "-- Drop existing constraints if they exist\n" +
                    "IF EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_feedback_type]') AND parent_object_id = OBJECT_ID(N'[dbo].[feedback]'))\n" +
                    "BEGIN\n" +
                    "    ALTER TABLE feedback DROP CONSTRAINT CK_feedback_type;\n" +
                    "END;\n" +
                    "\n" +
                    "IF EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_feedback_status]') AND parent_object_id = OBJECT_ID(N'[dbo].[feedback]'))\n" +
                    "BEGIN\n" +
                    "    ALTER TABLE feedback DROP CONSTRAINT CK_feedback_status;\n" +
                    "END;\n" +
                    "\n" +
                    "IF EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_feedback_priority]') AND parent_object_id = OBJECT_ID(N'[dbo].[feedback]'))\n" +
                    "BEGIN\n" +
                    "    ALTER TABLE feedback DROP CONSTRAINT CK_feedback_priority;\n" +
                    "END;\n" +
                    "\n" +
                    "-- Add the updated constraints\n" +
                    "IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND type in (N'U'))\n" +
                    "BEGIN\n" +
                    "    ALTER TABLE feedback ADD CONSTRAINT CK_feedback_type \n" +
                    "    CHECK (type IN ('Bug Report', 'Feature Request', 'General Feedback', 'Support Request'));\n" +
                    "\n" +
                    "    ALTER TABLE feedback ADD CONSTRAINT CK_feedback_status \n" +
                    "    CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED'));\n" +
                    "\n" +
                    "    ALTER TABLE feedback ADD CONSTRAINT CK_feedback_priority \n" +
                    "    CHECK (priority IN ('Low', 'Medium', 'High'));\n" +
                    "END;";

        executeTableCreation(sql, "feedback");
    }

    private void createFeedbackResponsesTableIfNotExists() {
        String sql = "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[feedback_responses]') AND type in (N'U'))\n" +
                    "BEGIN\n" +
                    "    CREATE TABLE feedback_responses (\n" +
                    "        id BIGINT IDENTITY(1,1) PRIMARY KEY,\n" +
                    "        feedback_id BIGINT NOT NULL,\n" +
                    "        user_id BIGINT NOT NULL,\n" +
                    "        message NVARCHAR(MAX) NOT NULL,\n" +
                    "        created_at DATETIME DEFAULT GETDATE(),\n" +
                    "        FOREIGN KEY (feedback_id) REFERENCES feedback(id)\n" +
                    "    )\n" +
                    "END";

        executeTableCreation(sql, "feedback_responses");
    }

    private void executeTableCreation(String sql, String tableName) {
        Connection conn = null;
        Statement stmt = null;
        
        try {
            System.out.println("\nChecking/creating " + tableName + " table...");
            conn = DatabaseUtil.getConnection();
            if (conn == null) {
                System.err.println("Failed to get database connection while creating " + tableName + " table");
                return;
            }

            stmt = conn.createStatement();
            stmt.execute(sql);
            System.out.println(tableName + " table checked/created successfully");
        } catch (SQLException e) {
            System.err.println("Error creating " + tableName + " table:");
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseUtil.closeAll(conn, stmt, null);
        }
    }

    //==========================================================================
    // USER SECTION - Methods for regular users to submit and view their feedback
    //==========================================================================

    public boolean create(Feedback feedback) {
        if (feedback == null) {
            System.err.println("Cannot create null feedback");
            return false;
        }

        // First, check if the tables exist
        createFeedbackTableIfNotExists();
        createFeedbackResponsesTableIfNotExists();

        String sql = "INSERT INTO feedback (user_id, user_name, subject, description, type, status, priority, attachment_path, created_at) "
                  + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            System.out.println("\n=== Creating new feedback ===");
            conn = DatabaseUtil.getConnection();
            if (conn == null) {
                System.err.println("Failed to get database connection");
                return false;
            }

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            ps.setLong(1, feedback.getUserId());
            ps.setString(2, feedback.getUserName());
            ps.setString(3, feedback.getSubject());
            ps.setString(4, feedback.getDescription());
            ps.setString(5, feedback.getType());
            ps.setString(6, "OPEN"); // Always set to OPEN for new feedback
            ps.setString(7, feedback.getPriority() != null ? feedback.getPriority() : "Medium");
            ps.setString(8, feedback.getAttachmentPath());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    feedback.setId(rs.getLong(1));
                    return true;
                }
            }
            return false;
        } catch (SQLException e) {
            System.err.println("\nSQL Error in create feedback:");
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.closeAll(conn, ps, rs);
        }
    }

    public List<Feedback> getUserFeedbackHistory(Long userId) {
        return findByUserId(userId);
    }

    //==========================================================================
    // ADMIN SECTION - Methods for administrators to manage feedback
    //==========================================================================

    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.*, u.username as user_name FROM feedback f " +
                    "LEFT JOIN users u ON f.user_id = u.id " +
                    "ORDER BY f.created_at DESC";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                feedbackList.add(mapFeedback(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all feedback: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseUtil.closeAll(conn, ps, rs);
        }
        
        return feedbackList;
    }

    public Feedback getFeedbackById(Long id) {
        return findById(id);
    }

    public List<FeedbackResponse> getFeedbackResponses(Long feedbackId) {
        List<FeedbackResponse> responses = new ArrayList<>();
        String sql = "SELECT r.*, u.username as admin_name FROM feedback_responses r "
                  + "JOIN users u ON r.user_id = u.id "
                  + "WHERE r.feedback_id = ? ORDER BY r.created_at ASC";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            if (conn == null) {
                System.err.println("Failed to get database connection");
                return responses;
            }

            ps = conn.prepareStatement(sql);
            ps.setLong(1, feedbackId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                responses.add(mapFeedbackResponse(rs));
            }
        } catch (SQLException e) {
            System.err.println("\nSQL Error in get feedback responses:");
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseUtil.closeAll(conn, ps, rs);
        }
        return responses;
    }

    public boolean addResponse(FeedbackResponse response) {
        String sql = "INSERT INTO feedback_responses (feedback_id, user_id, message) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            if (conn == null) {
                System.err.println("Failed to get database connection");
                return false;
            }

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, response.getFeedbackId());
            ps.setLong(2, response.getUserId());  
            ps.setString(3, response.getMessage());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    response.setId(rs.getLong(1));
                    // Update feedback status to IN_PROGRESS when admin responds
                    updateStatus(response.getFeedbackId(), "IN_PROGRESS");
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("\nSQL Error in add feedback response:");
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseUtil.closeAll(conn, ps, rs);
        }
        return false;
    }

    public boolean updateStatus(Long id, String status) {
        String sql = "UPDATE feedback SET status = ?, updated_at = GETDATE() WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setLong(2, id);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating feedback status: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.closeAll(conn, ps, null);
        }
    }

    //==========================================================================
    // HELPER METHODS - Internal methods for database operations
    //==========================================================================

    private Feedback findById(Long id) {
        String sql = "SELECT f.*, u.username as user_name FROM feedback f "
                  + "LEFT JOIN users u ON f.user_id = u.id WHERE f.id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            if (conn == null) {
                System.err.println("Failed to get database connection");
                return null;
            }

            ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapFeedback(rs);
            }
        } catch (SQLException e) {
            System.err.println("\nSQL Error in find feedback by ID:");
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseUtil.closeAll(conn, ps, rs);
        }
        return null;
    }

    
                private List<Feedback> findByUserId(Long userId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, u.username as user_name FROM feedback f " +
                    "LEFT JOIN users u ON f.user_id = u.id " +
                    "WHERE f.user_id = ? " +
                    "ORDER BY f.created_at DESC";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            if (conn == null) {
                System.err.println("Failed to get database connection");
                return feedbacks;
            }

            ps = conn.prepareStatement(sql);
            ps.setLong(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                feedbacks.add(mapFeedback(rs));
            }
        } catch (SQLException e) {
            System.err.println("\nSQL Error in find feedback by user ID:");
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseUtil.closeAll(conn, ps, rs);
        }
        return feedbacks;
    }

    private Feedback mapFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getLong("id"));
        feedback.setUserId(rs.getLong("user_id"));
        feedback.setUserName(rs.getString("user_name"));
        feedback.setSubject(rs.getString("subject"));
        feedback.setDescription(rs.getString("description"));
        feedback.setType(rs.getString("type"));
        feedback.setStatus(rs.getString("status"));
        feedback.setPriority(rs.getString("priority"));
        feedback.setAttachmentPath(rs.getString("attachment_path"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        feedback.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Load responses for this feedback
        feedback.setResponses(getFeedbackResponses(feedback.getId()));
        
        return feedback;
    }

    private FeedbackResponse mapFeedbackResponse(ResultSet rs) throws SQLException {
        FeedbackResponse response = new FeedbackResponse();
        response.setId(rs.getLong("id"));
        response.setFeedbackId(rs.getLong("feedback_id"));
        response.setUserId(rs.getLong("user_id")); 
        response.setMessage(rs.getString("message"));
        response.setCreatedAt(rs.getTimestamp("created_at"));
        response.setAdminName(rs.getString("admin_name"));
        return response;
    }
}