<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/includes/header.jsp" />

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Profile Information</h5>
                        <div class="mb-3">
                            <strong>Username:</strong> ${user.username}
                        </div>
                        <div class="mb-3">
                            <strong>Email:</strong> ${user.email}
                        </div>
                        <a href="#" class="btn btn-primary" onclick="alert('Feature coming soon!')">Edit Profile</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Recent Orders</h5>
                        <c:choose>
                            <c:when test="${empty recentOrders}">
                                <p class="text-muted">No orders yet.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Date</th>
                                                <th>Total</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${recentOrders}">
                                                <tr>
                                                    <td>#${order.id}</td>
                                                    <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                                    <td>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                                    <td>
                                                        <span class="badge bg-success">${order.status}</span>
                                                    </td>
                                                    <td>
                                                        <a href="order?id=${order.id}" class="btn btn-sm btn-outline-primary">View Details</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="text-end">
                                    <a href="orders" class="btn btn-link">View All Orders</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
