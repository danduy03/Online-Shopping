<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="title" value="Orders Management" scope="request"/>
<c:set var="active" value="orders" scope="request"/>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

<!-- Orders Content -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Orders Management</h2>
</div>

<!-- Orders Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Customer</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Total</th>
                <th>Status</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${orders}" var="order">
                <tr data-order-id="${order.id}">
                    <td>${order.id}</td>
                    <td>${order.fullName}</td>
                    <td>${order.email}</td>
                    <td>${order.phone}</td>
                    <td>
                        <fmt:formatNumber value="${order.totalAmount}" 
                                        type="currency" currencySymbol="$"/>
                    </td>
                    <td>
                        <span class="badge bg-${order.status eq 'PENDING' ? 'warning' : 
                                               order.status eq 'PROCESSING' ? 'primary' :
                                               order.status eq 'SHIPPED' ? 'info' :
                                               order.status eq 'DELIVERED' ? 'success' : 
                                               'danger'}">
                            ${order.status}
                        </span>
                    </td>
                    <td>
                        <fmt:formatDate value="${order.createdAt}" 
                                      pattern="MMM dd, yyyy HH:mm"/>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-primary btn-icon me-2" 
                                onclick="viewOrder(${order.id})"
                                data-bs-toggle="modal" data-bs-target="#viewOrderModal">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-success btn-icon me-2" 
                                onclick="updateStatus(${order.id})"
                                data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                            <i class="fas fa-edit"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- View Order Modal -->
<div class="modal fade" id="viewOrderModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title">
                    <i class="fas fa-shopping-bag me-2"></i>Order Details
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <!-- Order details will be loaded here -->
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Order Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="updateStatusForm" method="POST" action="${pageContext.request.contextPath}/admin/orders">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="id" id="updateOrderId">
                    <div class="mb-3">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" name="status" id="status" required>
                            <option value="PENDING">Pending</option>
                            <option value="PROCESSING">Processing</option>
                            <option value="SHIPPED">Shipped</option>
                            <option value="DELIVERED">Delivered</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                    <div class="alert alert-success d-none" id="updateSuccess">
                        Status updated successfully!
                    </div>
                    <div class="alert alert-danger d-none" id="updateError">
                        Failed to update status. 
                        <span id="errorMessage"></span>
                    </div>
                    <button type="submit" class="btn btn-primary">Update Status</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function viewOrder(id) {
    fetch(`${pageContext.request.contextPath}/admin/orders?action=view&id=\${id}`)
        .then(response => response.text())
        .then(html => {
            document.querySelector('#viewOrderModal .modal-body').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading order details:', error);
            document.querySelector('#viewOrderModal .modal-body').innerHTML = 
                '<div class="alert alert-danger">Error loading order details. Please try again.</div>';
        });
}

function updateStatus(id) {
    document.getElementById('updateOrderId').value = id;
    const statusBadge = document.querySelector(`tr[data-order-id="\${id}"] .badge`);
    const currentStatus = statusBadge.textContent.trim();
    document.getElementById('status').value = currentStatus;
    
    document.getElementById('updateSuccess').classList.add('d-none');
    document.getElementById('updateError').classList.add('d-none');
}

// Handle form submission
document.getElementById('updateStatusForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    
    fetch('${pageContext.request.contextPath}/admin/orders', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        return response.text().then(text => ({
            ok: response.ok,
            status: response.status,
            text: text
        }));
    })
    .then(result => {
        if (result.ok) {
            // Update the status badge in the table
            const orderId = document.getElementById('updateOrderId').value;
            const newStatus = document.getElementById('status').value;
            const statusBadge = document.querySelector(`tr[data-order-id="\${orderId}"] .badge`);
            
            // Update badge color
            statusBadge.className = `badge bg-\${
                newStatus === 'PENDING' ? 'warning' :
                newStatus === 'PROCESSING' ? 'primary' :
                newStatus === 'SHIPPED' ? 'info' :
                newStatus === 'DELIVERED' ? 'success' :
                'danger'
            }`;
            
            // Update badge text
            statusBadge.textContent = newStatus;
            
            // Show success message
            document.getElementById('updateSuccess').classList.remove('d-none');
            document.getElementById('updateError').classList.add('d-none');
            
            // If status is DELIVERED, refresh the page to update revenue
            if (newStatus === 'DELIVERED') {
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                // Close modal after 1 second
                setTimeout(() => {
                    const modal = bootstrap.Modal.getInstance(document.getElementById('updateStatusModal'));
                    modal.hide();
                    // Reset success message
                    document.getElementById('updateSuccess').classList.add('d-none');
                }, 1000);
            }
        } else {
            // Show error message
            document.getElementById('updateError').classList.remove('d-none');
            document.getElementById('updateSuccess').classList.add('d-none');
            document.getElementById('errorMessage').textContent = result.text || 'An error occurred';
        }
    })
    .catch(error => {
        console.error('Error:', error);
        document.getElementById('updateError').classList.remove('d-none');
        document.getElementById('updateSuccess').classList.add('d-none');
        document.getElementById('errorMessage').textContent = 'Network error occurred';
    });
});
</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
