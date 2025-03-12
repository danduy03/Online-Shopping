package utils;

import config.OAuthConfig;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtils {

    public static void sendPasswordResetEmail(String toEmail, String resetToken) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", OAuthConfig.SMTP_HOST);
        props.put("mail.smtp.port", OAuthConfig.SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(OAuthConfig.SMTP_USERNAME, OAuthConfig.SMTP_PASSWORD);
            }
        });
        
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(OAuthConfig.SMTP_USERNAME));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Password Reset Request");
        
        String resetLink = "http://localhost:9999/Ecomere/reset-password?token=" + resetToken;
        String emailContent = String.format("""
            <html>
            <body style='font-family: Arial, sans-serif; padding: 20px;'>
                <h2 style='color: #333;'>Password Reset Request</h2>
                <p>Hello,</p>
                <p>We received a request to reset your password. Click the button below to reset it:</p>
                <p style='margin: 25px 0;'>
                    <a href='%s' style='background-color: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>
                        Reset Password
                    </a>
                </p>
                <p>If you didn't request this, please ignore this email.</p>
                <p>This link will expire in 1 hour.</p>
                <br>
                <p>Best regards,<br>Your E-Shop Team</p>
                <hr>
                <p style='font-size: 12px; color: #666;'>
                    If the button doesn't work, copy and paste this link into your browser:<br>
                    %s
                </p>
            </body>
            </html>
            """, resetLink, resetLink);
        
        message.setContent(emailContent, "text/html; charset=utf-8");
        Transport.send(message);
        System.out.println("Password reset email sent successfully!");
    }
}
