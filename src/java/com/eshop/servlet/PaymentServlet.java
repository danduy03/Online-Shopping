package com.eshop.servlet;

import com.eshop.payment.StripePaymentService;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet("/create-payment-intent")
public class PaymentServlet extends HttpServlet {
    private final StripePaymentService paymentService = new StripePaymentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get the order amount from the request
            String amountStr = request.getParameter("amount");
            long amount = Long.parseLong(amountStr);

            // Create a PaymentIntent with the order amount and currency
            PaymentIntent paymentIntent = paymentService.createPaymentIntent(amount, "USD");

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("clientSecret", paymentIntent.getClientSecret());

            response.setContentType("application/json");
            response.getWriter().print(jsonResponse.toString());

        } catch (StripeException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("Error: " + e.getMessage());
        }
    }
}
