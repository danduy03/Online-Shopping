<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="title" value="Dashboard" scope="request"/>
<c:set var="active" value="dashboard" scope="request"/>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

<!-- Dashboard Content -->
<div class="container-fluid px-4">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Dashboard Overview</h2>
        <div class="btn-group">
            <button class="btn btn-outline-primary" onclick="exportDashboardData('pdf')">
                <i class="fas fa-file-pdf"></i> Export PDF
            </button>
            <button class="btn btn-outline-success" onclick="exportDashboardData('excel')">
                <i class="fas fa-file-excel"></i> Export Excel
            </button>
        </div>
    </div>

    <!-- Date Range Filter -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row align-items-center">
                <div class="col-md-4">
                    <label class="form-label">Date Range</label>
                    <select class="form-select" id="dateRange" onchange="updateDashboard()">
                        <option value="7">Last 7 Days</option>
                        <option value="30" selected>Last 30 Days</option>
                        <option value="90">Last 90 Days</option>
                        <option value="365">Last Year</option>
                        <option value="custom">Custom Range</option>
                    </select>
                </div>
                <div class="col-md-8" id="customDateRange" style="display: none;">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="form-label">Start Date</label>
                            <input type="date" class="form-control" id="startDate">
                        </div>
                        <div class="col-md-5">
                            <label class="form-label">End Date</label>
                            <input type="date" class="form-control" id="endDate">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn btn-primary w-100" onclick="updateDashboard()">Apply</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row">
        <div class="col-xl-3 col-md-6">
            <div class="card bg-primary text-white mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${totalOrders}</h3>
                            <div class="small">Total Orders</div>
                        </div>
                        <div class="small">
                            <i class="fas fa-shopping-cart fa-2x"></i>
                        </div>
                    </div>
                    <div class="small mt-2">
                        <span class="${orderGrowth >= 0 ? 'text-success' : 'text-danger'}">
                            <i class="fas fa-${orderGrowth >= 0 ? 'arrow-up' : 'arrow-down'}"></i>
                            ${Math.abs(orderGrowth)}%
                        </span>
                        vs previous period
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card bg-success text-white mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/>
                            </h3>
                            <div class="small">Total Revenue</div>
                        </div>
                        <div class="small">
                            <i class="fas fa-dollar-sign fa-2x"></i>
                        </div>
                    </div>
                    <div class="small mt-2">
                        <span class="${revenueGrowth >= 0 ? 'text-success' : 'text-danger'}">
                            <i class="fas fa-${revenueGrowth >= 0 ? 'arrow-up' : 'arrow-down'}"></i>
                            ${Math.abs(revenueGrowth)}%
                        </span>
                        vs previous period
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card bg-info text-white mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${averageOrderValue}</h3>
                            <div class="small">Avg. Order Value</div>
                        </div>
                        <div class="small">
                            <i class="fas fa-chart-line fa-2x"></i>
                        </div>
                    </div>
                    <div class="small mt-2">
                        <span class="${aovGrowth >= 0 ? 'text-success' : 'text-danger'}">
                            <i class="fas fa-${aovGrowth >= 0 ? 'arrow-up' : 'arrow-down'}"></i>
                            ${Math.abs(aovGrowth)}%
                        </span>
                        vs previous period
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="card bg-warning text-white mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${conversionRate}%</h3>
                            <div class="small">Conversion Rate</div>
                        </div>
                        <div class="small">
                            <i class="fas fa-percentage fa-2x"></i>
                        </div>
                    </div>
                    <div class="small mt-2">
                        <span class="${conversionGrowth >= 0 ? 'text-success' : 'text-danger'}">
                            <i class="fas fa-${conversionGrowth >= 0 ? 'arrow-up' : 'arrow-down'}"></i>
                            ${Math.abs(conversionGrowth)}%
                        </span>
                        vs previous period
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row mb-4">
        <div class="col-xl-8">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-chart-line me-1"></i>
                    Revenue Trends
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" width="100%" height="40"></canvas>
                </div>
            </div>
        </div>
        <div class="col-xl-4">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-chart-pie me-1"></i>
                    Sales by Category
                </div>
                <div class="card-body">
                    <canvas id="categoryChart" width="100%" height="50"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Orders and Top Products -->
    <div class="row">
        <div class="col-xl-8">
            <div class="card mb-4">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div><i class="fas fa-table me-1"></i> Recent Orders</div>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-primary">
                            View All Orders
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentOrders}" var="order">
                                    <tr>
                                        <td>#${order.id}</td>
                                        <td>${order.customerName}</td>
                                        <td>
                                            <fmt:formatNumber value="${order.totalAmount}" 
                                                            type="currency" currencySymbol="$"/>
                                        </td>
                                        <td>
                                            <span class="badge bg-${order.status eq 'PENDING' ? 'warning' : 
                                                               order.status eq 'PROCESSING' ? 'primary' :
                                                               order.status eq 'SHIPPED' ? 'info' :
                                                               order.status eq 'DELIVERED' ? 'success' :
                                                               order.status eq 'CANCELLED' ? 'danger' :
                                                               'secondary'}">
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${order.createdAt}" 
                                                          pattern="MMM dd, yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="${pageContext.request.contextPath}/admin/orders?id=${order.id}" 
                                                   class="btn btn-sm btn-primary">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <button class="btn btn-sm btn-success" 
                                                        onclick="updateOrderStatus(${order.id})">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-4">
            <div class="card mb-4">
                <div class="card-header">
                    <i class="fas fa-crown me-1"></i> Top Products
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Sales</th>
                                    <th>Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${topProducts}" var="product">
                                    <tr>
                                        <td>${product.name}</td>
                                        <td>${product.totalSales}</td>
                                        <td>
                                            <fmt:formatNumber value="${product.revenue}" 
                                                            type="currency" currencySymbol="$"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Dashboard Scripts -->
<script>
// Initialize date range picker
document.getElementById('dateRange').addEventListener('change', function() {
    const customRange = document.getElementById('customDateRange');
    customRange.style.display = this.value === 'custom' ? 'block' : 'none';
});

// Export dashboard data
function exportDashboardData(format) {
    const dateRange = document.getElementById('dateRange').value;
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    
    window.location.href = `${pageContext.request.contextPath}/admin/dashboard/export?` + 
                          `format=${format}&range=${dateRange}&` +
                          `start=${startDate}&end=${endDate}`;
}

// Update dashboard data
function updateDashboard() {
    const dateRange = document.getElementById('dateRange').value;
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    
    fetch(`${pageContext.request.contextPath}/admin/dashboard/data?` +
          `range=${dateRange}&start=${startDate}&end=${endDate}`)
        .then(response => response.json())
        .then(data => {
            updateCharts(data);
            updateStats(data);
        });
}

// Initialize Revenue Chart
const revenueCtx = document.getElementById('revenueChart');
new Chart(revenueCtx, {
    type: 'line',
    data: {
        labels: ${revenueChartLabels},
        datasets: [{
            label: 'Revenue',
            data: ${revenueChartData},
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

// Initialize Category Chart
const categoryCtx = document.getElementById('categoryChart');
new Chart(categoryCtx, {
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

// Function to update order status
function updateOrderStatus(orderId) {
    if (!confirm('Are you sure you want to update this order\'s status?')) return;
    
    fetch(`${pageContext.request.contextPath}/admin/orders/status`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ orderId: orderId })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            window.location.reload();
        } else {
            alert('Failed to update order status');
        }
    });
}
</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
