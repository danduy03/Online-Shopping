<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Statistics Cards -->
<div class="row">
    <div class="col-xl-3 col-md-6">
        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h5 class="mb-1">Total Sales</h5>
                        <h2 class="mb-0 text-primary">$${totalSales}</h2>
                        <div class="text-muted">Last 30 days</div>
                    </div>
                    <div class="flex-shrink-0 ms-3">
                        <div class="bg-primary bg-opacity-10 rounded-circle p-3">
                            <i class="fas fa-dollar-sign fa-2x text-primary"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h5 class="mb-1">Orders</h5>
                        <h2 class="mb-0 text-success">${totalOrders}</h2>
                        <div class="text-muted">Last 30 days</div>
                    </div>
                    <div class="flex-shrink-0 ms-3">
                        <div class="bg-success bg-opacity-10 rounded-circle p-3">
                            <i class="fas fa-shopping-cart fa-2x text-success"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h5 class="mb-1">Customers</h5>
                        <h2 class="mb-0 text-info">${totalCustomers}</h2>
                        <div class="text-muted">Total registered</div>
                    </div>
                    <div class="flex-shrink-0 ms-3">
                        <div class="bg-info bg-opacity-10 rounded-circle p-3">
                            <i class="fas fa-users fa-2x text-info"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h5 class="mb-1">Products</h5>
                        <h2 class="mb-0 text-warning">${totalProducts}</h2>
                        <div class="text-muted">In stock</div>
                    </div>
                    <div class="flex-shrink-0 ms-3">
                        <div class="bg-warning bg-opacity-10 rounded-circle p-3">
                            <i class="fas fa-box fa-2x text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Charts Row -->
<div class="row">
    <div class="col-12 col-lg-8">
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="card-title mb-0">Sales Overview</h5>
            </div>
            <div class="card-body">
                <canvas id="salesChart" height="300"></canvas>
            </div>
        </div>
    </div>
    <div class="col-12 col-lg-4">
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="card-title mb-0">Top Categories</h5>
            </div>
            <div class="card-body">
                <canvas id="categoriesChart" height="300"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- Recent Orders -->
<div class="card">
    <div class="card-header">
        <h5 class="card-title mb-0">Recent Orders</h5>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${recentOrders}" var="order">
                        <tr>
                            <td>#${order.id}</td>
                            <td>${order.customerName}</td>
                            <td>
                                <span class="badge bg-${order.statusColor}">${order.status}</span>
                            </td>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy"/></td>
                            <td>$<fmt:formatNumber value="${order.total}" pattern="#,##0.00"/></td>
                            <td>
                                <a href="admin/orders/${order.id}" class="btn btn-sm btn-primary">
                                    <i class="fas fa-eye"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Sales Chart
    const salesCtx = document.getElementById('salesChart').getContext('2d');
    new Chart(salesCtx, {
        type: 'line',
        data: {
            labels: ${salesChartLabels},
            datasets: [{
                label: 'Sales ($)',
                data: ${salesChartData},
                fill: false,
                borderColor: 'rgb(75, 192, 192)',
                tension: 0.1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });

    // Categories Chart
    const categoriesCtx = document.getElementById('categoriesChart').getContext('2d');
    new Chart(categoriesCtx, {
        type: 'doughnut',
        data: {
            labels: ${categoryChartLabels},
            datasets: [{
                data: ${categoryChartData},
                backgroundColor: [
                    '#FF6384',
                    '#36A2EB',
                    '#FFCE56',
                    '#4BC0C0',
                    '#9966FF'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
</script>
