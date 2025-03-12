package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseUtil {
    private static final String URL = "jdbc:sqlserver://localhost:1433;"
            + "databaseName=ec;"
            + "encrypt=true;"
            + "trustServerCertificate=true;"
            + "characterEncoding=UTF-8;"
            + "useUnicode=true;"
            + "sendStringParametersAsUnicode=true";
    private static final String USER = "sa";
    private static final String PASSWORD = "123456";
    private static Connection connection;
    
    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("SQL Server JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("Error loading SQL Server JDBC driver:");
            e.printStackTrace();
            throw new RuntimeException("Failed to load SQL Server JDBC driver", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Database connection established successfully");
            }
            return connection;
        } catch (SQLException e) {
            System.err.println("Error establishing database connection:");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed successfully");
            } catch (SQLException e) {
                System.err.println("Error closing database connection:");
                e.printStackTrace();
            }
        }
    }
    
    public static void closeAll(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
                System.out.println("All database resources closed successfully");
            }
        } catch (SQLException e) {
            System.err.println("Error closing database resources:");
            e.printStackTrace();
        }
    }
    
    // Convenience method for PreparedStatement
    public static void closeAll(Connection conn, PreparedStatement stmt, ResultSet rs) {
        closeAll(conn, (Statement) stmt, rs);
    }
}
