<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="layout/admin-layout.jsp">
    <jsp:param name="title" value="Discount Codes" />
    <jsp:param name="active" value="discounts" />
    <jsp:param name="content" value="/WEB-INF/admin/discounts-content.jsp" />
    <jsp:param name="headerContent">
        <div class="row align-items-center">
            <div class="col">
                <div class="mb-4">
                    <h6 class="card-subtitle text-muted">Manage discount codes</h6>
                </div>
            </div>
            <div class="col-auto">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createDiscountModal">
                    <i class="fas fa-plus"></i> Create New Code
                </button>
            </div>
        </div>
    </jsp:param>
</jsp:include>

<!-- Create Discount Modal -->
<div class="modal fade" id="createDiscountModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Create New Discount Code</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="createDiscountForm">
                    <div class="mb-3">
                        <label for="code" class="form-label">Code</label>
                        <input type="text" class="form-control" id="code" name="code" required>
                    </div>
                    <div class="mb-3">
                        <label for="discount" class="form-label">Discount Percentage</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="discount" name="discount" 
                                   min="0" max="100" required>
                            <span class="input-group-text">%</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="maxUses" class="form-label">Maximum Uses</label>
                        <input type="number" class="form-control" id="maxUses" name="maxUses" 
                               min="-1" value="-1">
                        <div class="form-text">Set to -1 for unlimited uses</div>
                    </div>
                    <div class="mb-3">
                        <label for="expiryDate" class="form-label">Expiry Date</label>
                        <input type="datetime-local" class="form-control" id="expiryDate" name="expiryDate">
                        <div class="form-text">Leave empty for no expiry date</div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" form="createDiscountForm" class="btn btn-primary">Create</button>
            </div>
        </div>
    </div>
</div>

<div class="container py-5">
    <div class="card">
        <div class="card-header">
            <h5 class="card-title mb-0">Existing Discount Codes</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Discount</th>
                            <th>Uses</th>
                            <th>Max Uses</th>
                            <th>Expiry Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${discountCodes}" var="code">
                            <tr>
                                <td>${code.code}</td>
                                <td><fmt:formatNumber value="${code.discountPercentage * 100}" />%</td>
                                <td>${code.currentUses}</td>
                                <td>${code.maxUses == -1 ? 'Unlimited' : code.maxUses}</td>
                                <td>
                                    <c:if test="${code.expiryDate != null}">
                                        <fmt:formatDate value="${code.expiryDate}" 
                                                      pattern="yyyy-MM-dd HH:mm"/>
                                    </c:if>
                                    <c:if test="${code.expiryDate == null}">
                                        Never
                                    </c:if>
                                </td>
                                <td>
                                    <span class="badge bg-${code.active ? 'success' : 'danger'}">
                                        ${code.active ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-${code.active ? 'danger' : 'success'} toggle-status"
                                            data-id="${code.id}"
                                            data-active="${!code.active}">
                                        ${code.active ? 'Deactivate' : 'Activate'}
                                    </button>
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
<script>
    document.getElementById('createDiscountForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const formData = new FormData(this);
        const searchParams = new URLSearchParams();
        for (const pair of formData) {
            searchParams.append(pair[0], pair[1]);
        }
        
        fetch('discounts', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: searchParams.toString()
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert(data.message);
                location.reload();
            } else {
                alert(data.message || 'Error creating discount code');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error creating discount code');
        });
    });

    document.querySelectorAll('.toggle-status').forEach(button => {
        button.addEventListener('click', function() {
            const id = this.dataset.id;
            const active = this.dataset.active;
            
            fetch('discounts', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=toggle&id=${id}&active=${active}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Error updating discount code');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating discount code');
            });
        });
    });
</script>
