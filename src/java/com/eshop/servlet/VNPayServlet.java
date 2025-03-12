package com.eshop.servlet;

import com.eshop.payment.VNPayService;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "VNPayServlet", urlPatterns = {"/vnpay-payment", "/vnpay-return"})
public class VNPayServlet extends HttpServlet {
    private final VNPayService vnPayService = new VNPayService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get order information
        String orderInfo = "Payment for Order #" + request.getParameter("orderId");
        long amount = Long.parseLong(request.getParameter("amount"));

        // Create payment URL
        String paymentUrl = vnPayService.createPaymentUrl(request, amount, orderInfo);
        
        // Return payment URL to client
        response.setContentType("application/json");
        response.getWriter().write("{\"paymentUrl\": \"" + paymentUrl + "\"}");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This handles the return URL from VNPay
        Map<String, String> response_params = new HashMap<>();
        Enumeration<String> params = request.getParameterNames();
        
        while (params.hasMoreElements()) {
            String param = params.nextElement();
            response_params.put(param, request.getParameter(param));
        }

        // Validate payment response
        boolean isValidSignature = vnPayService.validatePaymentResponse(response_params);
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        
        if (isValidSignature) {
            if ("00".equals(vnp_ResponseCode)) {
                // Payment successful
                // Update order status in your database
                response.sendRedirect("order-confirmation.jsp?status=success&orderId=" + 
                    request.getParameter("vnp_TxnRef"));
            } else {
                // Payment failed
                response.sendRedirect("order-confirmation.jsp?status=failed&message=" + 
                    request.getParameter("vnp_TransactionStatus"));
            }
        } else {
            // Invalid signature
            response.sendRedirect("order-confirmation.jsp?status=failed&message=invalid_signature");
        }
    }
}
