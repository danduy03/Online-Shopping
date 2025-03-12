<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Summary - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        .order-summary {
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
    </style>
</head>
<body>
    <%@ include file="components/navbar.jsp" %>

    <div class="container mt-4">
        <div class="order-summary">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading"><i class="fas fa-check-circle"></i> Order Placed Successfully!</h4>
                <p>Thank you for your order. Your order details are below.</p>
            </div>

            <div class="order-info">
                <h3>Order #${order.id}</h3>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Order Date:</strong> <fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy HH:mm"/></p>
                        <p><strong>Name:</strong> ${order.customerName}</p>
                        <p><strong>Phone:</strong> ${order.phone}</p>
                        <p><strong>Email:</strong> ${sessionScope.user.email}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Shipping Address:</strong></p>
                        <p>${order.shippingAddress}</p>
                        <p><strong>Note:</strong></p>
                        <p>${order.note}</p>
                    </div>
                </div>
            </div>

            <div class="order-items">
                <h4>Order Items</h4>
                <div class="table-responsive">
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
                            <c:forEach var="item" items="${order.orderItems}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="images/products/${item.product.imageUrl}" alt="${item.product.name}" 
                                                 class="item-image me-3">
                                            <span>${item.product.name}</span>
                                        </div>
                                    </td>
                                    <td>$${item.price}</td>
                                    <td>${item.quantity}</td>
                                    <td class="text-end">$${item.price * item.quantity}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                <td class="text-end"><strong>$${order.totalAmount}</strong></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>

            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Continue Shopping</a>
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-primary ms-2">View All Orders</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
