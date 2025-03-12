package com.eshop.servlet;

import com.eshop.payment.PayPalService;
import com.paypal.api.payments.Payment;
import com.paypal.base.rest.PayPalRESTException;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "PayPalServlet", urlPatterns = {"/paypal-payment", "/paypal-execute"})
public class PayPalServlet extends HttpServlet {
    private final PayPalService payPalService = new PayPalService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();
        
        if ("/paypal-payment".equals(pathInfo)) {
            createPayment(request, response);
        } else if ("/paypal-execute".equals(pathInfo)) {
            executePayment(request, response);
        }
    }

    private void createPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String baseURL = String.format("%s://%s:%s%s",
                    request.getScheme(), request.getServerName(), request.getServerPort(), request.getContextPath());
            
            double amount = Double.parseDouble(request.getParameter("amount"));
            String currency = request.getParameter("currency");
            String cancelUrl = baseURL + "/checkout.jsp";
            String successUrl = baseURL + "/paypal-execute";

            Payment payment = payPalService.createPayment(
                    amount,
                    currency,
                    cancelUrl,
                    successUrl);

            response.setContentType("application/json");
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("paymentUrl", payment.getLinks().get(1).getHref());
            response.getWriter().write(jsonResponse.toString());

        } catch (PayPalRESTException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void executePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String paymentId = request.getParameter("paymentId");
            String payerId = request.getParameter("PayerID");

            Payment payment = payPalService.executePayment(paymentId, payerId);

            if ("approved".equals(payment.getState())) {
                response.sendRedirect("order-confirmation.jsp?status=success");
            } else {
                response.sendRedirect("order-confirmation.jsp?status=failed");
            }

        } catch (PayPalRESTException e) {
            response.sendRedirect("order-confirmation.jsp?status=error&message=" + e.getMessage());
        }
    }
}
