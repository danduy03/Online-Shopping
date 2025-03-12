package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order-confirmation")
public class OrderConfirmationServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get the order details from session
        Object orderDetails = session.getAttribute("orderDetails");
        if (orderDetails == null) {
            // If no order details found, redirect to home
            response.sendRedirect("index.jsp");
            return;
        }
        
        // Set order details as request attribute
        request.setAttribute("order", orderDetails);
        
        // Clear the cart and order details from session
        session.removeAttribute("cart");
        session.removeAttribute("orderDetails");
        
        // Forward to confirmation page
        request.getRequestDispatcher("/order-confirmation.jsp").forward(request, response);
    }
}
