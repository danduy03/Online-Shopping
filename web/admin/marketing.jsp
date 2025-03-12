<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="title" value="Marketing Management" scope="request"/>
<c:set var="active" value="marketing" scope="request"/>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

<!-- Marketing Content -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Marketing Banners</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#bannerModal">
        <i class="fas fa-plus me-2"></i>Add Banner
    </button>
</div>

<!-- Banners Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>Preview</th>
                <th>Title</th>
                <th>Position</th>
                <th>Duration</th>
                <th>Priority</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${banners}" var="banner">
                <tr>
                    <td>
                        <img src="${pageContext.request.contextPath}/${banner.imageUrl}" 
                             alt="${banner.title}"
                             style="width: 40px; height: 40px; object-fit: cover;">
                    </td>
                    <td>
                        <div>${banner.title}</div>
                        <small class="text-muted">${banner.description}</small>
                    </td>
                    <td>${banner.position}</td>
                    <td>
                        <fmt:formatDate value="${banner.startDate}" pattern="MMM dd, yyyy"/> - 
                        <fmt:formatDate value="${banner.endDate}" pattern="MMM dd, yyyy"/>
                    </td>
                    <td>${banner.priority}</td>
                    <td>
                        <span class="badge bg-${banner.active ? 'primary' : 'secondary'}">
                            ${banner.active ? 'Active' : 'Inactive'}
                        </span>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-primary btn-icon me-2" 
                                onclick="editBanner(${banner.id})"
                                data-bs-toggle="modal" data-bs-target="#bannerModal">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-warning btn-icon me-2"
                                onclick="toggleBanner(${banner.id})">
                            <i class="fas fa-${banner.active ? 'pause' : 'play'}"></i>
                        </button>
                        <button class="btn btn-sm btn-danger btn-icon"
                                onclick="if(confirm('Are you sure you want to delete this banner?')) deleteBanner(${banner.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Banner Modal -->
<div class="modal fade" id="bannerModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Add Banner</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="bannerForm" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="id" id="bannerId">
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Title</label>
                            <input type="text" class="form-control" name="title" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Position</label>
                            <select class="form-select" name="position" required>
                                <option value="ABOVE_NAVBAR">Above Navigation Bar</option>
                                <option value="HOME_TOP">Home Page Top</option>
                                <option value="HOME_MIDDLE">Home Page Middle</option>
                                <option value="HOME_BOTTOM">Home Page Bottom</option>
                                <option value="CATEGORY_TOP">Category Page Top</option>
                                <option value="CATEGORY_BOTTOM">Category Page Bottom</option>
                                <option value="SIDEBAR">Sidebar</option>
                                <option value="SIDEBAR_TOP">Sidebar Top</option>
                                <option value="SIDEBAR_BOTTOM">Sidebar Bottom</option>
                                <option value="PRODUCT_PAGE">Product Page</option>
                                <option value="CHECKOUT_PAGE">Checkout Page</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="2"></textarea>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Image</label>
                            <input type="file" class="form-control" name="image" accept="image/*">
                            <div id="currentImage" class="mt-2 d-none">
                                <img src="" alt="Current banner" style="max-height: 100px;">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Link URL</label>
                            <input type="url" class="form-control" name="linkUrl">
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Start Date</label>
                            <input type="datetime-local" class="form-control" name="startDate" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">End Date</label>
                            <input type="datetime-local" class="form-control" name="endDate">
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Priority</label>
                            <input type="number" class="form-control" name="priority" value="0" min="0">
                        </div>
                        <div class="col-md-6">
                            <div class="form-check mt-4">
                                <input class="form-check-input" type="checkbox" name="active" value="true" checked>
                                <label class="form-check-label">Active</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveBanner()">Save Banner</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
let bannerModal;
let currentBanner = null;

document.addEventListener('DOMContentLoaded', function() {
    bannerModal = new bootstrap.Modal(document.getElementById('bannerModal'));
    
    document.getElementById('bannerModal').addEventListener('hidden.bs.modal', function () {
        resetForm();
    });
});

function resetForm() {
    currentBanner = null;
    const form = document.getElementById('bannerForm');
    form.reset();
    form.action.value = 'create';
    form.id.value = '';
    document.getElementById('modalTitle').textContent = 'Add Banner';
    document.getElementById('currentImage').classList.add('d-none');
}

function editBanner(id) {
    fetch('${pageContext.request.contextPath}/admin/marketing/api/list')
        .then(response => response.json())
        .then(banners => {
            currentBanner = banners.find(b => b.id === id);
            if (currentBanner) {
                const form = document.getElementById('bannerForm');
                form.action.value = 'update';
                form.id.value = currentBanner.id;
                form.title.value = currentBanner.title;
                form.description.value = currentBanner.description || '';
                form.position.value = currentBanner.position;
                form.linkUrl.value = currentBanner.linkUrl || '';
                form.priority.value = currentBanner.priority;
                form.active.checked = currentBanner.active;
                
                if (currentBanner.startDate) {
                    form.startDate.value = new Date(currentBanner.startDate).toISOString().slice(0, 16);
                }
                if (currentBanner.endDate) {
                    form.endDate.value = new Date(currentBanner.endDate).toISOString().slice(0, 16);
                }
                
                if (currentBanner.imageUrl) {
                    const imgPreview = document.querySelector('#currentImage img');
                    imgPreview.src = '${pageContext.request.contextPath}/' + currentBanner.imageUrl;
                    document.getElementById('currentImage').classList.remove('d-none');
                }
                
                document.getElementById('modalTitle').textContent = 'Edit Banner';
                bannerModal.show();
            }
        });
}

function saveBanner() {
    const form = document.getElementById('bannerForm');
    const formData = new FormData(form);
    
    fetch('${pageContext.request.contextPath}/admin/marketing', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            window.location.reload();
        } else {
            alert(result.message);
        }
    })
    .catch(error => {
        alert('An error occurred. Please try again.');
    });
}

function toggleBanner(id) {
    if (!confirm('Are you sure you want to change this banner\'s status?')) {
        return;
    }
    
    const formData = new FormData();
    formData.append('action', 'toggle');
    formData.append('id', id);
    
    fetch('${pageContext.request.contextPath}/admin/marketing', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            window.location.reload();
        } else {
            alert(result.message);
        }
    })
    .catch(error => {
        alert('An error occurred. Please try again.');
    });
}

function deleteBanner(id) {
    const formData = new FormData();
    formData.append('action', 'delete');
    formData.append('id', id);
    
    fetch('${pageContext.request.contextPath}/admin/marketing', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            window.location.reload();
        } else {
            alert(result.message);
        }
    })
    .catch(error => {
        alert('An error occurred. Please try again.');
    });
}
</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
