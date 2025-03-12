<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="title" value="Discounts Management" scope="request"/>
<c:set var="active" value="discounts" scope="request"/>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

<!-- Discounts Content -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Discounts Management</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDiscountModal">
        <i class="fas fa-plus me-2"></i>Add Discount
    </button>
</div>

<!-- Discounts Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>Code</th>
                <th>Type</th>
                <th>Value</th>
                <th>Min Purchase</th>
                <th>Max Discount</th>
                <th>Validity</th>
                <th>Uses</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${discounts}" var="discount">
                <tr data-discount-id="${discount.id}">
                    <td data-code="${discount.code}">
                        ${discount.code}
                        <div class="small text-muted">${discount.description}</div>
                    </td>
                    <td data-type="${discount.discountType}">
                        ${discount.discountType eq 'PERCENTAGE' ? 'Percentage' : 'Fixed Amount'}
                    </td>
                    <td data-value="${discount.discountValue}">
                        <c:choose>
                            <c:when test="${discount.discountType eq 'PERCENTAGE'}">
                                ${discount.discountValue}%
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${discount.discountValue}" 
                                                type="currency" currencySymbol="$"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td data-min-purchase="${discount.minPurchaseAmount}">
                        <fmt:formatNumber value="${discount.minPurchaseAmount}" 
                                        type="currency" currencySymbol="$"/>
                    </td>
                    <td data-max-discount="${discount.maxDiscountAmount}">
                        <fmt:formatNumber value="${discount.maxDiscountAmount}" 
                                        type="currency" currencySymbol="$"/>
                    </td>
                    <td>
                        <div data-start-date="${discount.startDate}">
                            From: <fmt:formatDate value="${discount.startDate}" 
                                                pattern="MMM dd, yyyy HH:mm"/>
                        </div>
                        <div data-end-date="${discount.endDate}">
                            To: <fmt:formatDate value="${discount.endDate}" 
                                              pattern="MMM dd, yyyy HH:mm"/>
                        </div>
                    </td>
                    <td data-max-uses="${discount.maxUses}">
                        ${discount.usedCount} / ${discount.maxUses}
                    </td>
                    <td>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" 
                                   ${discount.active ? 'checked' : ''} 
                                   onchange="toggleDiscountStatus(${discount.id}, this.checked)"
                                   id="status_${discount.id}">
                            <label class="form-check-label" for="status_${discount.id}">
                                ${discount.active ? 'Active' : 'Inactive'}
                            </label>
                        </div>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-primary btn-icon me-2" 
                                onclick="editDiscount(${discount.id})"
                                data-bs-toggle="modal" data-bs-target="#editDiscountModal">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger btn-icon"
                                onclick="if(confirmDelete('discount', ${discount.id})) deleteDiscount(${discount.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Add Discount Modal -->
<div class="modal fade" id="addDiscountModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Discount</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/discounts" 
                  method="POST" 
                  onsubmit="return validateForm('addDiscountForm')"
                  id="addDiscountForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Discount Code</label>
                                <input type="text" class="form-control" name="code" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" rows="2"></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Discount Type</label>
                                <select class="form-select" name="discountType" required>
                                    <option value="PERCENTAGE">Percentage</option>
                                    <option value="FIXED">Fixed Amount</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Discount Value</label>
                                <input type="number" class="form-control" name="discountValue" 
                                       step="0.01" min="0" required>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Minimum Purchase Amount</label>
                                <input type="number" class="form-control" name="minPurchaseAmount" 
                                       step="0.01" min="0" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Maximum Discount Amount</label>
                                <input type="number" class="form-control" name="maxDiscountAmount" 
                                       step="0.01" min="0" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Start Date</label>
                                <input type="datetime-local" class="form-control" 
                                       name="startDate" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">End Date</label>
                                <input type="datetime-local" class="form-control" 
                                       name="endDate" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Maximum Uses</label>
                                <input type="number" class="form-control" name="maxUses" 
                                       min="1" required>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Discount</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Discount Modal -->
<div class="modal fade" id="editDiscountModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Discount</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/discounts" 
                  method="POST"
                  onsubmit="return validateForm('editDiscountForm')"
                  id="editDiscountForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editDiscountId">
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Discount Code</label>
                                <input type="text" class="form-control" name="code" 
                                       id="editDiscountCode" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" 
                                          id="editDiscountDescription" rows="2"></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Discount Type</label>
                                <select class="form-select" name="discountType" 
                                        id="editDiscountType" required>
                                    <option value="PERCENTAGE">Percentage</option>
                                    <option value="FIXED">Fixed Amount</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Discount Value</label>
                                <input type="number" class="form-control" name="discountValue" 
                                       id="editDiscountValue" step="0.01" min="0" required>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Minimum Purchase Amount</label>
                                <input type="number" class="form-control" name="minPurchaseAmount" 
                                       id="editMinPurchaseAmount" step="0.01" min="0" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Maximum Discount Amount</label>
                                <input type="number" class="form-control" name="maxDiscountAmount" 
                                       id="editMaxDiscountAmount" step="0.01" min="0" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Start Date</label>
                                <input type="datetime-local" class="form-control" 
                                       name="startDate" id="editStartDate" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">End Date</label>
                                <input type="datetime-local" class="form-control" 
                                       name="endDate" id="editEndDate" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Maximum Uses</label>
                                <input type="number" class="form-control" name="maxUses" 
                                       id="editMaxUses" min="1" required>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// Toggle discount status
function toggleDiscountStatus(id, active) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/admin/discounts';
    
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'toggleActive';
    
    const idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = 'id';
    idInput.value = id;
    
    form.appendChild(actionInput);
    form.appendChild(idInput);
    document.body.appendChild(form);
    form.submit();
}

// Delete discount
function deleteDiscount(id) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/admin/discounts';
    
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'delete';
    
    const idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = 'id';
    idInput.value = id;
    
    form.appendChild(actionInput);
    form.appendChild(idInput);
    document.body.appendChild(form);
    form.submit();
}

// Format datetime string for input
function formatDateTimeForInput(dateString) {
    const date = new Date(dateString);
    return date.toISOString().slice(0, 16);
}

// Edit discount
function editDiscount(id) {
    const row = document.querySelector(`tr[data-discount-id="${id}"]`);
    if (!row) return;
    
    document.getElementById('editDiscountId').value = id;
    document.getElementById('editDiscountCode').value = row.querySelector('[data-code]').dataset.code;
    document.getElementById('editDiscountDescription').value = row.querySelector('[data-code]').querySelector('.text-muted').textContent;
    document.getElementById('editDiscountType').value = row.querySelector('[data-type]').dataset.type;
    document.getElementById('editDiscountValue').value = row.querySelector('[data-value]').dataset.value;
    document.getElementById('editMinPurchaseAmount').value = row.querySelector('[data-min-purchase]').dataset.minPurchase;
    document.getElementById('editMaxDiscountAmount').value = row.querySelector('[data-max-discount]').dataset.maxDiscount;
    document.getElementById('editStartDate').value = formatDateTimeForInput(row.querySelector('[data-start-date]').dataset.startDate);
    document.getElementById('editEndDate').value = formatDateTimeForInput(row.querySelector('[data-end-date]').dataset.endDate);
    document.getElementById('editMaxUses').value = row.querySelector('[data-max-uses]').dataset.maxUses;
}

// Additional form validation
document.querySelectorAll('#addDiscountForm, #editDiscountForm').forEach(form => {
    form.addEventListener('submit', function(e) {
        const startDate = new Date(this.querySelector('[name="startDate"]').value);
        const endDate = new Date(this.querySelector('[name="endDate"]').value);
        
        if (endDate <= startDate) {
            e.preventDefault();
            alert('End date must be after start date');
            return false;
        }
        
        const discountType = this.querySelector('[name="discountType"]').value;
        const discountValue = parseFloat(this.querySelector('[name="discountValue"]').value);
        
        if (discountType === 'PERCENTAGE' && discountValue > 100) {
            e.preventDefault();
            alert('Percentage discount cannot be greater than 100%');
            return false;
        }
        
        return true;
    });
});
</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>