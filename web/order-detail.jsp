<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Details - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        .order-details {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .order-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .order-items {
            margin-top: 20px;
        }
        .item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }
        .success-banner {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
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
                        <a class="nav-link" href="products.jsp">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="cart.jsp">Cart</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link" href="login.jsp">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="register.jsp">Register</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="profile.jsp">Profile</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="logout">Logout</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="order-details">
            <div class="success-banner">
                <h4><i class="fas fa-check-circle"></i> Order Placed Successfully!</h4>
                <p>Thank you for your order. Below are your order details.</p>
            </div>

            <div class="order-info">
                <div class="row">
                    <div class="col-md-6">
                        <h5>Order Information</h5>
                        <p><strong>Order #:</strong> ${order.id}</p>
                        <p><strong>Order Date:</strong> <fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy HH:mm"/></p>
                        <p><strong>Status:</strong> <span class="badge bg-${order.status eq 'PENDING' ? 'warning' : 'success'}">${order.status}</span></p>
                    </div>
                    <div class="col-md-6">
                        <h5>Customer Information</h5>
                        <p><strong>Name:</strong> ${order.fullName != null ? order.fullName : 'N/A'}</p>
<p><strong>Phone:</strong> ${order.phone != null ? order.phone : 'N/A'}</p>
<p><strong>Email:</strong> ${order.email != null ? order.email : 'N/A'}</p>

                    </div>
                </div>
                
                <div class="mt-4">
    <h5>Shipping Address</h5>
    <p>
        ${order.address != null ? order.address : ''}<br>
        ${order.commune != null ? order.commune : ''}, 
        ${order.district != null ? order.district : ''}<br>
        ${order.province != null ? order.province : ''}
    </p>
</div>

<div class="mt-4">
    <h5>Note Order</h5>
    <p>${not empty order.notes ? (fn:length(order.notes) > 100 ? fn:substring(order.notes, 0, 100) : order.notes) : 'No notes provide'}</p>
</div>

                <div class="order-items mt-4">
                    <h5>Order Items</h5>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th class="text-end">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${order.orderItems}" var="item">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${item.product.imageUrl}" alt="${item.product.name}" class="item-image me-3">
                                            <span>${item.product.name}</span>
                                        </div>
                                    </td>
                                    <td>$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                    <td>${item.quantity}</td>
                                    <td class="text-end">$<fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                                <td class="text-end">$<fmt:formatNumber value="${order.subtotal}" pattern="#,##0.00"/></td>
                            </tr>
                            <tr>
                                <td colspan="3" class="text-end"><strong>Shipping:</strong></td>
                                <td class="text-end">$<fmt:formatNumber value="${order.shippingCost}" pattern="#,##0.00"/></td>
                            </tr>
                            <tr>
                                <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                <td class="text-end"><strong>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <a href="index.jsp" class="btn btn-primary">Continue Shopping</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/your-fontawesome-kit.js"></script>
</body>
</html>
