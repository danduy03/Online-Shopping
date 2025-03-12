<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - E-Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .order-confirmation {
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-top: 2rem;
        }
        .success-icon {
            color: #28a745;
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        .order-details {
            background-color: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-top: 1.5rem;
        }
        .item-list {
            margin-top: 1rem;
        }
        .item {
            padding: 1rem 0;
            border-bottom: 1px solid #dee2e6;
        }
        .item:last-child {
            border-bottom: none;
        }
        .shipping-info {
            background-color: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-top: 1.5rem;
        }
    </style>
    <script src="https://js.stripe.com/v3/"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">E-Shop</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="products">Products</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:if test="${sessionScope.user != null}">
                        <li class="nav-item">
                            <a class="nav-link" href="profile">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout">Logout</a>
                        </li>
                    </c:if>
                    <c:if test="${sessionScope.user == null}">
                        <li class="nav-item">
                            <a class="nav-link" href="login">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="register">Register</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body text-center">
                        <div id="success-message" class="d-none">
                            <i class="fas fa-check-circle text-success fa-4x mb-3"></i>
                            <h2 class="mb-4">Payment Successful!</h2>
                            <p class="mb-4">Your order has been confirmed and will be processed shortly.</p>
                            <div class="order-details mb-4">
                                <h4>Order Details</h4>
                                <p class="mb-2">Order ID: <span id="orderId"></span></p>
                                <p class="mb-2">Amount Paid: <span id="amountPaid"></span></p>
                                <p>Payment Status: <span class="badge bg-success">Completed</span></p>
                            </div>
                            <a href="index.jsp" class="btn btn-primary">Continue Shopping</a>
                        </div>
                        <div id="processing-message">
                            <div class="spinner-border text-primary mb-3" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <h3>Processing Payment...</h3>
                            <p>Please wait while we confirm your payment.</p>
                        </div>
                        <div id="error-message" class="d-none">
                            <i class="fas fa-times-circle text-danger fa-4x mb-3"></i>
                            <h2 class="mb-4">Payment Failed</h2>
                            <p class="mb-4">There was an error processing your payment.</p>
                            <a href="checkout.jsp" class="btn btn-primary">Try Again</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const stripe = Stripe('your_stripe_publishable_key'); // Replace with your Stripe publishable key
        
        // Extract the payment intent client secret from the URL
        const clientSecret = new URLSearchParams(window.location.search).get('payment_intent_client_secret');

        if (clientSecret) {
            // Retrieve the PaymentIntent status
            stripe.retrievePaymentIntent(clientSecret).then(({paymentIntent}) => {
                switch (paymentIntent.status) {
                    case 'succeeded':
                        // Show success message
                        document.getElementById('processing-message').classList.add('d-none');
                        document.getElementById('success-message').classList.remove('d-none');
                        document.getElementById('orderId').textContent = paymentIntent.id;
                        document.getElementById('amountPaid').textContent = 
                            new Intl.NumberFormat('en-US', {
                                style: 'currency',
                                currency: paymentIntent.currency.toUpperCase()
                            }).format(paymentIntent.amount / 100);
                        break;
                    case 'processing':
                        // Payment is still processing
                        // Show processing message
                        break;
                    case 'requires_payment_method':
                        // Payment failed
                        document.getElementById('processing-message').classList.add('d-none');
                        document.getElementById('error-message').classList.remove('d-none');
                        break;
                    default:
                        document.getElementById('processing-message').classList.add('d-none');
                        document.getElementById('error-message').classList.remove('d-none');
                        break;
                }
            });
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
