<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Details - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
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
                    <li class="nav-item">
                        <a class="nav-link" href="categories">Categories</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="cart">Cart</a>
                    </li>
                    <c:if test="${sessionScope.user != null}">
                        <li class="nav-item">
                            <a class="nav-link" href="profile.jsp">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout">Logout</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Order #${order.id}</h2>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">Back to Orders</a>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Order Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Order Date:</strong> <fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy HH:mm"/></p>
                                <p><strong>Status:</strong> <span class="badge bg-${order.status == 'Pending' ? 'warning' : 'success'}">${order.status}</span></p>
                                <p><strong>Payment Method:</strong> ${order.paymentMethod}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Shipping Address:</strong></p>
                                <p class="text-muted">${order.shippingAddress}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Order Items</h5>
                    </div>
                    <div class="card-body">
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
                                                         class="me-2" style="width: 50px; height: 50px; object-fit: cover;">
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
                                        <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                        <td class="text-end"><strong>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
