<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Discount Codes List -->
<div class="card">
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
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-${code.active ? 'danger' : 'success'} toggle-status"
                                            data-id="${code.id}"
                                            data-active="${!code.active}">
                                        <i class="fas fa-power-off"></i>
                                    </button>
                                    <button class="btn btn-sm btn-info view-usage" 
                                            data-id="${code.id}" 
                                            title="View Usage History">
                                        <i class="fas fa-chart-line"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger delete-code" 
                                            data-id="${code.id}" 
                                            title="Delete Code">
                                        <i class="fas fa-trash"></i>
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
                location.reload();
                bootstrap.Modal.getInstance(document.getElementById('createDiscountModal')).hide();
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
            if (!confirm('Are you sure you want to change the status of this discount code?')) {
                return;
            }
            
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

    document.querySelectorAll('.delete-code').forEach(button => {
        button.addEventListener('click', function() {
            if (!confirm('Are you sure you want to delete this discount code? This action cannot be undone.')) {
                return;
            }
            
            const id = this.dataset.id;
            
            fetch('discounts', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=delete&id=${id}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Error deleting discount code');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting discount code');
            });
        });
    });

    document.querySelectorAll('.view-usage').forEach(button => {
        button.addEventListener('click', function() {
            const id = this.dataset.id;
            // Implement view usage history functionality
            alert('Usage history feature coming soon!');
        });
    });
</script>
