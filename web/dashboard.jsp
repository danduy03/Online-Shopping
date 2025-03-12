<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
    <style>
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            margin-bottom: 1.5rem;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stat-card {
            padding: 1.5rem;
            border-radius: 10px;
            color: white;
        }
        .stat-card.orders {
            background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
        }
        .stat-card.users {
            background: linear-gradient(135deg, #FF6B6B 0%, #FF0000 100%);
        }
        .stat-card.revenue {
            background: linear-gradient(135deg, #6BFF6B 0%, #00FF00 100%);
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
        }
        .chart-container {
            height: 300px;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/header.jsp" />

    <div class="container mt-4">
        <h2 class="mb-4">Admin Dashboard</h2>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stat-card orders">
                    <h3>Total Orders</h3>
                    <div class="stat-number">${totalOrders}</div>
                    <p>Last 30 days</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card users">
                    <h3>Total Users</h3>
                    <div class="stat-number">${totalUsers}</div>
                    <p>Active accounts</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card revenue">
                    <h3>Total Revenue</h3>
                    <div class="stat-number">$${totalRevenue}</div>
                    <p>Last 30 days</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-body">
                        <h4>Quick Actions</h4>
                        <div class="btn-group">
                            <a href="products/new" class="btn btn-primary">Add Product</a>
                            <a href="orders" class="btn btn-info">View Orders</a>
                            <a href="users" class="btn btn-success">Manage Users</a>
                            <a href="reports" class="btn btn-warning">Generate Reports</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="card dashboard-card">
            <div class="card-body">
                <h4>Recent Orders</h4>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>${order.customerName}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                    <td><span class="badge bg-${order.status == 'COMPLETED' ? 'success' : 'warning'}">${order.status}</span></td>
                                    <td>
                                        <a href="orders/view?id=${order.id}" class="btn btn-sm btn-primary">View</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>
