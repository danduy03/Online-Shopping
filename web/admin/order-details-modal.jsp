<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">Order Details #${order.id}</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
    </div>
    <div class="modal-body">
        <div class="row">
            <!-- Order Information -->
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Order Information</h5>
                    </div>
                    <div class="card-body">
                        <ul class="list-unstyled mb-0">
                            <li class="mb-2">
                                <strong>Order ID:</strong>
                                <span class="float-end">#${order.id}</span>
                            </li>
                            <li class="mb-2">
                                <strong>Order Date:</strong>
                                <span class="float-end">
                                    <fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                                </span>
                            </li>
                            <li class="mb-2">
                                <strong>Status:</strong>
                                <span class="float-end">
                                    <span class="badge bg-${order.status eq 'PENDING' ? 'warning' : 
                                                  order.status eq 'PROCESSING' ? 'primary' :
                                                  order.status eq 'SHIPPED' ? 'info' :
                                                  order.status eq 'DELIVERED' ? 'success' : 
                                                  'danger'}">
                                        ${order.status}
                                    </span>
                                </span>
                            </li>
                            <li class="mb-2">
                                <strong>Total Amount:</strong>
                                <span class="float-end text-primary fw-bold">
                                    $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                                </span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Customer Information -->
            <div class="col-md-6">
    <div class="card mb-4">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0"><i class="fas fa-user me-2"></i>Customer Information</h5>
        </div>
        <div class="card-body">
            <ul class="list-unstyled mb-0">
                <li class="mb-2 d-flex">
                    <strong style="min-width: 80px;">Name:</strong>
                    <span class="ms-2">${order.fullName}</span>
                </li>
                <li class="mb-2 d-flex">
                    <strong style="min-width: 80px;">Email:</strong>
                    <span class="ms-2 text-break">${order.email}</span>
                </li>
                <li class="mb-2 d-flex">
                    <strong style="min-width: 80px;">Phone:</strong>
                    <span class="ms-2">${order.phone}</span>
                </li>
                <li class="mb-2 d-flex">
                    <strong style="min-width: 80px;">Address:</strong>
                    <span class="ms-2 text-wrap" style="word-break: break-word;">
                        ${order.address}<br/>
                        ${order.commune}, ${order.district}<br/>
                        ${order.province}
                    </span>
                </li>
                <li class="d-flex">
                    <strong style="min-width: 80px;">Note:</strong>
                    <span class="ms-2 text-wrap text-muted" style="word-break: break-word;">
                        <!--${not empty order.notes ? order.notes : 'Something for admin know user don\'t write note.'}-->
                        ${not empty order.notes ? order.notes : 'No provide note'}
                    </span>
                </li>
            </ul>
        </div>
    </div>
</div>
        </div>

        <!-- Order Items -->
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>Order Items</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Product</th>
                                <th class="text-end">Price</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-end">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orderItems}" var="item">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/uploads/products/${item.product.imageUrl}" 
                                                 alt="${item.product.name}" 
                                                 class="me-3" 
                                                 style="width: 48px; height: 48px; object-fit: cover;">
                                            <div>
                                                <h6 class="mb-0">${item.product.name}</h6>
                                                <small class="text-muted">#${item.product.id}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-end">
                                        $<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/>
                                    </td>
                                    <td class="text-center">${item.quantity}</td>
                                    <td class="text-end">
                                        $<fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot class="table-light">
                            <tr>
                                <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                                <td class="text-end">
                                    $<fmt:formatNumber value="${order.subtotal}" pattern="#,##0.00"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" class="text-end"><strong>Shipping:</strong></td>
                                <td class="text-end">
                                    $<fmt:formatNumber value="${order.shippingCost}" pattern="#,##0.00"/>
                                </td>
                            </tr>
                            <c:if test="${order.discountAmount gt 0}">
                                <tr>
                                    <td colspan="3" class="text-end">
                                        <strong>Discount:</strong>
                                        <c:if test="${not empty order.discountCode}">
                                            <small class="text-muted">(${order.discountCode})</small>
                                        </c:if>
                                    </td>
                                    <td class="text-end text-danger">
                                        -$<fmt:formatNumber value="${order.discountAmount}" pattern="#,##0.00"/>
                                    </td>
                                </tr>
                            </c:if>
                            <tr>
                                <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                <td class="text-end">
                                    <strong class="text-primary">
                                        $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                                    </strong>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
</div>