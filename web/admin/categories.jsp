<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="title" value="Categories Management" scope="request"/>
<c:set var="active" value="categories" scope="request"/>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

<!-- Categories Content -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Categories Management</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
        <i class="fas fa-plus me-2"></i>Add Category
    </button>
</div>

<!-- Categories Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Products Count</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${categories}" var="category">
                <tr data-category-id="${category.id}">
                    <td>${category.id}</td>
                    <td data-name="${category.name}">${category.name}</td>
                    <td data-description="${category.description}">
                        ${category.description}
                    </td>
                    <td>${category.productsCount}</td>
                    <td>
                        <button class="btn btn-sm btn-primary btn-icon me-2" 
                                onclick="editCategory(${category.id})"
                                data-bs-toggle="modal" data-bs-target="#editCategoryModal">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger btn-icon"
                                onclick="if(confirmDelete('category', ${category.id})) deleteCategory(${category.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories" 
                  method="POST" 
                  onsubmit="return validateForm('addCategoryForm')"
                  id="addCategoryForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Category Modal -->
<div class="modal fade" id="editCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories" 
                  method="POST"
                  onsubmit="return validateForm('editCategoryForm')"
                  id="editCategoryForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editCategoryId">
                    
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" 
                               id="editCategoryName" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" 
                                  id="editCategoryDescription" rows="3"></textarea>
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
// Delete category
function deleteCategory(id) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/admin/categories';
    
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

// Edit category
function editCategory(id) {
    // Find the category in the table
    const row = document.querySelector(`tr[data-category-id="${id}"]`);
    if (!row) return;
    
    // Populate the edit form
    document.getElementById('editCategoryId').value = id;
    document.getElementById('editCategoryName').value = row.querySelector('[data-name]').dataset.name;
    document.getElementById('editCategoryDescription').value = row.querySelector('[data-description]').dataset.description;
}
</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
