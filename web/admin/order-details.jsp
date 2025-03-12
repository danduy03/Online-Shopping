<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="title" value="Order Details" scope="request"/>
<c:set var="active" value="orders" scope="request"/>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

<!-- Order Details Content -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Order #${order.id} Details</h2>
    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">
        <i class="fas fa-arrow-left me-2"></i>Back to Orders
    </a>
</div>

<!-- Order Information -->
<div class="row">
    <div class="col-md-6">
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="card-title mb-0">Order Information</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <strong>Order Date:</strong>
                    <fmt:formatDate value="${order.createdAt}" 
                                  pattern="MMM dd, yyyy HH:mm"/>
                </div>
                <div class="mb-3">
                    <strong>Status:</strong>
                    <span class="badge bg-${order.status eq 'COMPLETED' ? 'success' : 
                                         order.status eq 'PENDING' ? 'warning' : 
                                         order.status eq 'CANCELLED' ? 'danger' : 
                                         'primary'}">
                        ${order.status}
                    </span>
                </div>
                <div class="mb-3">
                    <strong>Total Amount:</strong>
                    <fmt:formatNumber value="${order.totalAmount}" 
                                    type="currency" currencySymbol="$"/>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="card-title mb-0">Customer Information</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <strong>Name:</strong> ${order.username}
                </div>
                <div class="mb-3">
                    <strong>Email:</strong> ${order.email}
                </div>
                <div class="mb-3">
                    <strong>Phone:</strong> ${order.phone}
                </div>
                <div class="mb-3">
                    <strong>Shipping Address:</strong><br>
                    ${order.shippingAddress}
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Order Items -->
<div class="card">
    <div class="card-header">
        <h5 class="card-title mb-0">Order Items</h5>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orderItems}" var="item">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="${item.product.imageUrl}" 
                                         alt="${item.product.name}"
                                         style="width: 50px; height: 50px; object-fit: cover;"
                                         class="me-3">
                                    <div>
                                        <div class="fw-bold">${item.product.name}</div>
                                        <small class="text-muted">#${item.product.id}</small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <fmt:formatNumber value="${item.price}" 
                                                type="currency" currencySymbol="$"/>
                            </td>
                            <td>${item.quantity}</td>
                            <td>
                                <fmt:formatNumber value="${item.price * item.quantity}" 
                                                type="currency" currencySymbol="$"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                        <td>
                            <fmt:formatNumber value="${order.subtotal}" 
                                            type="currency" currencySymbol="$"/>
                        </td>
                    </tr>
                    <c:if test="${order.discount > 0}">
                        <tr>
                            <td colspan="3" class="text-end"><strong>Discount:</strong></td>
                            <td>
                                -<fmt:formatNumber value="${order.discount}" 
                                                type="currency" currencySymbol="$"/>
                            </td>
                        </tr>
                    </c:if>
                    <tr>
                        <td colspan="3" class="text-end"><strong>Total:</strong></td>
                        <td>
                            <strong>
                                <fmt:formatNumber value="${order.totalAmount}" 
                                                type="currency" currencySymbol="$"/>
                            </strong>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
