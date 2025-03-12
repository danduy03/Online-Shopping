<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - E-Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.css" rel="stylesheet">
    <script src="https://www.paypal.com/sdk/js?client-id=test&currency=USD"></script>
    <style>
        .form-control:focus, .form-select:focus {
            border-color: #80bdff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        .form-select:disabled {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        .discount-section {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .order-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            position: sticky;
            top: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .order-summary .item {
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .order-summary .item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }
        .payment-methods {
            margin-top: 20px;
            padding: 20px;
            border-radius: 8px;
            background-color: #fff;
        }
        .payment-details {
            margin-top: 15px;
            padding: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            display: none;
            background-color: #fff;
        }
        .form-check-label {
            display: flex;
            flex-direction: column;
            padding: 10px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .form-check-input:checked + .form-check-label {
            border-color: #0d6efd;
            background-color: #f8f9fa;
        }
        .section-heading {
            color: #2c3e50;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }
        #stripe-payment-form {
            display: none;
            margin-top: 20px;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
        }
        #payment-message {
            color: rgb(105, 115, 134);
            font-size: 16px;
            line-height: 20px;
            padding-top: 12px;
            text-align: center;
        }
        .payment-methods img {
            margin-right: 10px;
            border-radius: 4px;
            padding: 5px;
            background: #f8f9fa;
        }
        .payment-methods-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .payment-method-option {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            transition: all 0.3s ease;
        }
        .payment-method-option:hover {
            border-color: #0d6efd;
            box-shadow: 0 0 0 1px #0d6efd;
        }
        .payment-method-option input[type="radio"] {
            margin-right: 10px;
        }
        .supported-payments {
            display: flex;
            align-items: center;
            border-top: 1px solid #dee2e6;
            padding-top: 1rem;
        }
        .payment-icons {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-top: 0.5rem;
        }
        .payment-icons i {
            transition: all 0.3s ease;
            opacity: 0.7;
        }
        .payment-icons i:hover {
            opacity: 1;
            transform: translateY(-2px);
        }
        .payment-methods-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .payment-method-option {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1.25rem;
            transition: all 0.3s ease;
            background: #fff;
        }
        .payment-method-option:hover {
            border-color: #0d6efd;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .payment-method-option input[type="radio"] {
            margin-right: 10px;
        }
        .payment-icon {
            font-size: 24px;
            color: #6c757d;
        }
        @media (max-width: 992px) {
            .payment-methods-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 576px) {
            .payment-methods-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
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
                    <li class="nav-item">
                        <a class="nav-link" href="cart">Cart</a>
                    </li>
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

    <div class="container py-5">
        <div class="row">
            <!-- Left Column - Form -->
            <div class="col-md-8">
                <form id="checkoutForm" action="checkout" method="post">
                    <!-- Shipping Information -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <h3 class="section-heading">Shipping Information</h3>
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label">Full Name *</label>
                                    <input type="text" class="form-control" name="fullName" required>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Phone Number *</label>
                                    <input type="tel" class="form-control" name="phone" 
                                           pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number" required>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Email (Optional)</label>
                                    <input type="email" class="form-control" name="email">
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Province</label>
                                    <select class="form-select" id="province" name="province" required>
                                        <option value="">Select Province</option>
                                    </select>
                                    <input type="hidden" id="provinceText" name="provinceText">
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">District</label>
                                    <select class="form-select" id="district" name="district" required>
                                        <option value="">Select District</option>
                                    </select>
                                    <input type="hidden" id="districtText" name="districtText">
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Commune</label>
                                    <select class="form-select" id="commune" name="commune" required>
                                        <option value="">Select Commune</option>
                                    </select>
                                    <input type="hidden" id="communeText" name="communeText">
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label">Village/Hamlet</label>
                                    <select class="form-select" name="village" id="village" disabled>
                                        <option value="">--Select Village/Hamlet--</option>
                                    </select>
                                </div>

                                <div class="col-12">
                                    <label class="form-label required-label">Street Address *</label>
                                    <textarea class="form-control" name="address" rows="2" required 
                                              placeholder="House number, street name"></textarea>
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Order Notes (Optional - Max 100 characters)</label>
                                    <textarea class="form-control" name="notes" rows="3" 
                                              maxlength="100" id="noteTextarea"
                                              placeholder="Notes about your order, e.g. special notes for delivery"></textarea>
                                    <div class="form-text text-end"><span id="charCount">0</span>/100 characters</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <h3 class="section-heading">Payment Method</h3>
                            <div class="payment-methods-container">
                                <div class="payment-method-option">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="cod" checked>
                                    <label class="form-check-label" for="cod">
                                        <strong>Cash on Delivery (COD)</strong>
                                        <div class="text-muted small">Pay when you receive your package</div>
                                        <div class="mt-2">
                                            <i class="fas fa-money-bill-wave payment-icon"></i>
                                        </div>
                                    </label>
                                </div>

                                <div class="payment-method-option">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="bankTransfer" value="bankTransfer">
                                    <label class="form-check-label" for="bankTransfer">
                                        <strong>Bank Transfer</strong>
                                        <div class="text-muted small">Make payment directly to our bank account</div>
                                        <div class="mt-2">
                                            <i class="fas fa-university payment-icon"></i>
                                        </div>
                                    </label>
                                </div>

                                <div class="payment-method-option">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="creditCard" value="creditCard">
                                    <label class="form-check-label" for="creditCard">
                                        <strong>Credit/Debit Card</strong>
                                        <div class="text-muted small">Pay securely with your credit/debit card</div>
                                        <div class="mt-2">
                                            <i class="fas fa-credit-card payment-icon"></i>
                                        </div>
                                    </label>
                                </div>

                                <div class="payment-method-option">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="vnpay" value="vnpay">
                                    <label class="form-check-label" for="vnpay">
                                        <strong>VNPay</strong>
                                        <div class="text-muted small">Pay with VNPay (ATM/Credit Card/QR Code)</div>
                                        <div class="mt-2">
                                            <img src="https://sandbox.vnpayment.vn/paymentv2/Images/brands/logo.svg" alt="VNPay Logo" style="height: 35px;">
                                        </div>
                                    </label>
                                </div>

                                <div class="payment-method-option">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="paypal" value="paypal">
                                    <label class="form-check-label" for="paypal">
                                        <strong>PayPal</strong>
                                        <div class="text-muted small">Pay securely with PayPal</div>
                                        <div class="mt-2">
                                            <img src="https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_37x23.jpg" alt="PayPal Logo" style="height: 35px;">
                                        </div>
                                    </label>
                                </div>

                                <div class="payment-method-option">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="momo" value="momo">
                                    <label class="form-check-label" for="momo">
                                        <strong>Momo</strong>
                                        <div class="text-muted small">Pay with Momo e-wallet</div>
                                        <div class="mt-2">
                                            <img src="https://static.mservice.io/img/logo-momo.png" alt="Momo Logo" style="height: 35px;">
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <div class="supported-payments mt-4">
                                <span class="text-muted me-3">Supported Payment Methods:</span>
                                <div class="payment-icons">
                                    <i class="fab fa-cc-visa fa-2x" style="color: #1A1F71;"></i>
                                    <i class="fab fa-cc-mastercard fa-2x" style="color: #EB001B;"></i>
                                    <i class="fab fa-cc-amex fa-2x" style="color: #006FCF;"></i>
                                    <i class="fab fa-google-pay fa-2x" style="color: #3C4043;"></i>
                                    <i class="fab fa-apple-pay fa-2x" style="color: #000000;"></i>
                                </div>
                            </div>

                            <!-- Bank Transfer Details -->
                            <div id="bankDetails" class="payment-details">
                                <h5 class="mb-3">Bank Transfer Information</h5>
                                <div class="bg-light p-3 rounded">
                                    <p class="mb-2"><strong>Bank:</strong> Example Bank</p>
                                    <p class="mb-2"><strong>Account Number:</strong> 1234567890</p>
                                    <p class="mb-2"><strong>Account Name:</strong> E-Shop Company</p>
                                    <p class="mb-0 text-muted"><i class="fas fa-info-circle me-2"></i>Please include your order number in the transfer description.</p>
                                </div>
                            </div>

                            <!-- Stripe Payment Form -->
                            <div id="stripe-payment-form" class="payment-details">
                                <div id="payment-element"></div>
                                <button id="submit-payment" class="btn btn-primary w-100 mt-4">
                                    <span id="button-text">Pay now</span>
                                    <span id="spinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                                </button>
                                <div id="payment-message" class="hidden"></div>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg w-100 mb-3" id="placeOrderBtn">
                        <i class="fas fa-truck me-2"></i>Place Order (COD)
                    </button>
                </form>
            </div>

            <!-- Right Column - Order Summary -->
            <div class="col-md-4">
                <div class="order-summary">
                    <h3 class="section-heading">Order Summary</h3>
                    <div class="items-container mb-4">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="item">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="mb-1">${item.product.name}</h6>
                                        <small class="text-muted">Quantity: ${item.quantity}</small>
                                    </div>
                                    <span class="ms-2 fw-bold">$<fmt:formatNumber value="${item.product.price * item.quantity}" pattern="#,##0.00"/></span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Discount Code Section -->
                    <div class="mb-4">
                        <label class="form-label fw-bold">Have a Discount Code?</label>
                        <form id="discountForm" onsubmit="return false;">
                            <div class="input-group">
                                <input type="text" class="form-control" id="discountCode" name="discountCode" 
                                       placeholder="Enter your code">
                                <button class="btn btn-outline-primary" type="button" onclick="applyDiscount()">
                                    Apply
                                </button>
                            </div>
                            <div id="discountMessage" class="alert mt-2" style="display: none;"></div>
                        </form>
                        <input type="hidden" id="appliedDiscount" name="appliedDiscount" value="0" form="checkoutForm">
                    </div>

                    <!-- Order Totals -->
                    <div class="totals bg-white p-3 rounded">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal:</span>
                            <span class="fw-bold">$<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping:</span>
                            <span class="fw-bold">$<fmt:formatNumber value="${shipping}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2" id="discountRow" style="display: none;">
                            <span>Discount:</span>
                            <span id="discountAmount" class="text-success fw-bold">-$0.00</span>
                        </div>
                        <hr class="my-3">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="mb-0">Final Total:</h5>
                            <h4 class="text-primary mb-0" id="orderTotal">$<fmt:formatNumber value="${total}" pattern="#,##0.00"/></h4>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <a href="cart" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>
                                Return to Cart
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
    <script src="js/location.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded');
            const form = document.getElementById('checkoutForm');
            const placeOrderBtn = document.getElementById('placeOrderBtn');
            
            // Restore discount code handling
            const discountForm = document.getElementById('discountForm');
            const discountInput = document.getElementById('discountCode');
            const applyDiscountBtn = document.getElementById('applyDiscount');
            
            if (discountForm) {
                discountForm.addEventListener('submit', async function(event) {
                    event.preventDefault();
                    
                    if (!discountInput || !discountInput.value.trim()) {
                        showMessage('Please enter a discount code', 'error');
                        return;
                    }
                    
                    try {
                        const response = await fetch('apply-discount', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: `discountCode=${discountInput.value.trim()}`
                        });
                        
                        const data = await response.json();
                        
                        if (data.success) {
                            showMessage('Discount applied successfully!', 'success');
                            // Update the order total
                            const orderTotal = document.querySelector('.order-total');
                            if (orderTotal) {
                                orderTotal.textContent = data.newTotal;
                            }
                            // Update discount amount
                            const discountAmount = document.querySelector('.discount-amount');
                            if (discountAmount) {
                                discountAmount.textContent = data.discountAmount;
                            }
                        } else {
                            showMessage(data.message || 'Invalid discount code', 'error');
                        }
                    } catch (error) {
                        console.error('Error applying discount:', error);
                        showMessage('Error applying discount. Please try again.', 'error');
                    }
                });
            }

            if (form) {
                console.log('Form found');
                form.addEventListener('submit', async function(event) {
                    event.preventDefault();
                    console.log('Form submitted');

                    const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
                    if (!paymentMethod) {
                        showMessage('Please select a payment method', 'error');
                        return;
                    }

                    // Validate required fields
                    const fullName = document.querySelector('input[name="fullName"]');
                    const phone = document.querySelector('input[name="phone"]');
                    const address = document.querySelector('textarea[name="address"]');
                    const province = document.querySelector('select[name="province"]');
                    const district = document.querySelector('select[name="district"]');
                    const commune = document.querySelector('select[name="commune"]');

                    if (!fullName || !fullName.value.trim()) {
                        showMessage('Please enter your full name', 'error');
                        fullName?.focus();
                        return;
                    }

                    if (!phone || !phone.value.trim()) {
                        showMessage('Please enter your phone number', 'error');
                        phone?.focus();
                        return;
                    }

                    if (!address || !address.value.trim()) {
                        showMessage('Please enter your address', 'error');
                        address?.focus();
                        return;
                    }

                    if (!province || !province.value) {
                        showMessage('Please select your province', 'error');
                        province?.focus();
                        return;
                    }

                    if (!district || !district.value) {
                        showMessage('Please select your district', 'error');
                        district?.focus();
                        return;
                    }

                    if (!commune || !commune.value) {
                        showMessage('Please select your commune', 'error');
                        commune?.focus();
                        return;
                    }

                    // Disable the button and show loading state
                    if (placeOrderBtn) {
                        placeOrderBtn.disabled = true;
                        placeOrderBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Processing...';
                    }

                    try {
                        const orderTotal = document.querySelector('.order-total')?.textContent || '0';
                        console.log('Processing payment method:', paymentMethod.value);

                        switch (paymentMethod.value) {
                            case 'vnpay':
                                console.log('Processing VNPay payment');
                                const vnpayAmount = parseFloat(orderTotal.replace(/[^0-9.-]+/g, ''));
                                const vnpayOrderId = Math.floor(Math.random() * 1000000);
                                
                                const vnpayResponse = await fetch('vnpay-payment', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: `amount=${vnpayAmount * 23000}&orderId=${vnpayOrderId}`
                                });

                                const vnpayData = await vnpayResponse.json();
                                console.log('VNPay response:', vnpayData);
                                
                                if (vnpayData.paymentUrl) {
                                    window.location.href = vnpayData.paymentUrl;
                                } else {
                                    throw new Error('Error creating VNPay payment URL');
                                }
                                break;

                            case 'paypal':
                                console.log('Processing PayPal payment');
                                const paypalAmount = parseFloat(orderTotal.replace(/[^0-9.-]+/g, ''));
                                const paypalOrderId = Math.floor(Math.random() * 1000000);
                                
                                const paypalResponse = await fetch('paypal-payment', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: `amount=${paypalAmount}&currency=USD&orderId=${paypalOrderId}`
                                });

                                const paypalData = await paypalResponse.json();
                                console.log('PayPal response:', paypalData);
                                
                                if (paypalData.error) {
                                    throw new Error(paypalData.error);
                                }
                                if (paypalData.paymentUrl) {
                                    window.location.href = paypalData.paymentUrl;
                                } else {
                                    throw new Error('Error creating PayPal payment URL');
                                }
                                break;

                            case 'cod':
                                console.log('Processing COD order');
                                showMessage('Order placed successfully! We will contact you soon.', 'success');
                                setTimeout(() => {
                                    form.submit();
                                }, 2000);
                                break;

                            case 'bankTransfer':
                                console.log('Processing Bank Transfer order');
                                showMessage('Order placed successfully! Please complete the bank transfer.', 'success');
                                setTimeout(() => {
                                    form.submit();
                                }, 2000);
                                break;

                            default:
                                throw new Error('Invalid payment method');
                        }
                    } catch (error) {
                        console.error('Error processing order:', error);
                        showMessage(error.message || 'Payment processing failed. Please try again.', 'error');
                        if (placeOrderBtn) {
                            placeOrderBtn.disabled = false;
                            updateButtonText(paymentMethod.value);
                        }
                    }
                });
            } else {
                console.error('Checkout form not found!');
            }

            // Handle payment method selection
            const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
            const bankDetails = document.getElementById('bankDetails');

            paymentMethods.forEach(method => {
                method.addEventListener('change', function() {
                    console.log('Payment method changed:', this.value);
                    if (placeOrderBtn) {
                        placeOrderBtn.disabled = false;
                        updateButtonText(this.value);
                    }
                    
                    if (bankDetails) {
                        bankDetails.style.display = this.value === 'bankTransfer' ? 'block' : 'none';
                    }
                });
            });
        });

        function showMessage(message, type) {
            console.log(`Showing message: ${message} (${type})`);
            Swal.fire({
                title: type === 'error' ? 'Error!' : 'Success!',
                text: message,
                icon: type,
                confirmButtonText: 'OK'
            });
        }

        function updateButtonText(paymentMethod) {
            const placeOrderBtn = document.getElementById('placeOrderBtn');
            const subtotal = parseFloat(document.querySelector('.subtotal-amount')?.textContent?.replace(/[^0-9.-]+/g, '') || '0');
            const shipping = parseFloat(document.querySelector('.shipping-amount')?.textContent?.replace(/[^0-9.-]+/g, '') || '0');
            const discount = parseFloat(document.querySelector('.discount-amount')?.textContent?.replace(/[^0-9.-]+/g, '') || '0');
            
            // Calculate final total
            const finalTotal = (subtotal + shipping - discount).toFixed(2);
            
            if (placeOrderBtn) {
                switch(paymentMethod) {
                    case 'cod':
                        placeOrderBtn.innerHTML = `<i class="fas fa-truck me-2"></i>Place Order (COD) - $${finalTotal}`;
                        break;
                    case 'bankTransfer':
                        placeOrderBtn.innerHTML = `<i class="fas fa-university me-2"></i>Place Order (Bank Transfer) - $${finalTotal}`;
                        break;
                    case 'vnpay':
                        placeOrderBtn.innerHTML = `<i class="fas fa-credit-card me-2"></i>Pay with VNPay - $${finalTotal}`;
                        break;
                    case 'paypal':
                        placeOrderBtn.innerHTML = `<i class="fab fa-paypal me-2"></i>Pay with PayPal - $${finalTotal}`;
                        break;
                }
            }
        }

        // Add this function to update totals
        function updateOrderTotals() {
            const subtotal = parseFloat(document.querySelector('.subtotal-amount')?.textContent?.replace(/[^0-9.-]+/g, '') || '0');
            const shipping = parseFloat(document.querySelector('.shipping-amount')?.textContent?.replace(/[^0-9.-]+/g, '') || '0');
            const discount = parseFloat(document.querySelector('.discount-amount')?.textContent?.replace(/[^0-9.-]+/g, '') || '0');
            
            // Calculate final total
            const finalTotal = (subtotal + shipping - discount).toFixed(2);
            
            // Update the final total display
            const finalTotalElement = document.querySelector('.final-total');
            if (finalTotalElement) {
                finalTotalElement.textContent = `$${finalTotal}`;
            }
            
            // Update button text with current payment method
            const selectedPaymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
            if (selectedPaymentMethod) {
                updateButtonText(selectedPaymentMethod.value);
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded');
            const form = document.getElementById('checkoutForm');
            const placeOrderBtn = document.getElementById('placeOrderBtn');
            
            // Initial update of totals
            updateOrderTotals();
            
            // Restore discount code handling
            const discountForm = document.getElementById('discountForm');
            const discountInput = document.getElementById('discountCode');
            
            if (discountForm) {
                discountForm.addEventListener('submit', async function(event) {
                    event.preventDefault();
                    
                    if (!discountInput || !discountInput.value.trim()) {
                        showMessage('Please enter a discount code', 'error');
                        return;
                    }
                    
                    try {
                        const response = await fetch('apply-discount', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: `discountCode=${discountInput.value.trim()}`
                        });
                        
                        const data = await response.json();
                        
                        if (data.success) {
                            showMessage('Discount applied successfully!', 'success');
                            // Update the discount amount
                            const discountAmount = document.querySelector('.discount-amount');
                            if (discountAmount) {
                                discountAmount.textContent = data.discountAmount;
                            }
                            // Update all totals
                            updateOrderTotals();
                        } else {
                            showMessage(data.message || 'Invalid discount code', 'error');
                        }
                    } catch (error) {
                        console.error('Error applying discount:', error);
                        showMessage('Error applying discount. Please try again.', 'error');
                    }
                });
            }
        });
    </script>
</body>
</html>