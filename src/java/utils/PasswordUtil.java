package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int SALT_LENGTH = 16;
    private static final String ALLOWED_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";

    public static String hashPassword(String password) {
        try {
            // Generate a random salt
            byte[] salt = new byte[SALT_LENGTH];
            RANDOM.nextBytes(salt);

            // Create MessageDigest instance for SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            
            // Add salt to digest
            md.update(salt);
            
            // Get the hash's bytes
            byte[] bytes = md.digest(password.getBytes());
            
            // Combine salt and password hash
            byte[] combined = new byte[salt.length + bytes.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(bytes, 0, combined, salt.length, bytes.length);
            
            // Convert to base64 for storage
            return Base64.getEncoder().encodeToString(combined);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean verifyPassword(String password, String hashedPassword) {
        try {
            // Decode the stored hash
            byte[] combined = Base64.getDecoder().decode(hashedPassword);
            
            // Extract salt and hash
            byte[] salt = new byte[SALT_LENGTH];
            byte[] hash = new byte[combined.length - SALT_LENGTH];
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);
            System.arraycopy(combined, SALT_LENGTH, hash, 0, hash.length);
            
            // Generate new hash with the same salt
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] newHash = md.digest(password.getBytes());
            
            // Compare the hashes
            return MessageDigest.isEqual(hash, newHash);
        } catch (NoSuchAlgorithmException | IllegalArgumentException e) {
            return false;
        }
    }

    public static String generateRandomPassword() {
        StringBuilder password = new StringBuilder();
        
        // Generate a random password of length 12
        for (int i = 0; i < 12; i++) {
            int index = RANDOM.nextInt(ALLOWED_CHARACTERS.length());
            password.append(ALLOWED_CHARACTERS.charAt(index));
        }
        
        return password.toString();
    }
}
