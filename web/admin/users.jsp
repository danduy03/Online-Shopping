<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="title" value="Users Management" scope="request"/>
<c:set var="active" value="users" scope="request"/>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

<!-- Users Content -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Users Management</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
        <i class="fas fa-plus me-2"></i>Add User
    </button>
</div>

<!-- Password Reset Success Modal -->
<c:if test="${not empty newPassword}">
    <div class="modal fade" id="passwordResetModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Password Reset Successful</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>The new password is: <strong>${newPassword}</strong></p>
                    <p class="text-warning">Please make sure to copy this password and send it to the user securely.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            new bootstrap.Modal(document.getElementById('passwordResetModal')).show();
        });
    </script>
</c:if>

<!-- Users Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Role</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${users}" var="user">
                <tr data-user-id="${user.id}">
                    <td>${user.id}</td>
                    <td data-username="${user.username}">${user.username}</td>
                    <td data-email="${user.email}">${user.email}</td>
                    <td>
                        <span class="badge bg-${user.admin ? 'danger' : 'primary'}">
                            ${user.admin ? 'Admin' : 'User'}
                        </span>
                        <button class="btn btn-sm btn-link p-0 ms-2" 
                                onclick="toggleAdminStatus(${user.id}, ${user.admin})">
                            ${user.admin ? 'Remove Admin' : 'Make Admin'}
                        </button>
                    </td>
                    <td>
                        <fmt:formatDate value="${user.createdAt}" 
                                      pattern="MMM dd, yyyy HH:mm"/>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-warning btn-icon me-2"
                                onclick="if(confirm('Are you sure you want to reset the password for this user?')) resetPassword(${user.id})">
                            <i class="fas fa-key"></i>
                        </button>
                        <button class="btn btn-sm btn-primary btn-icon me-2" 
                                onclick="editUser(${user.id})"
                                data-bs-toggle="modal" data-bs-target="#editUserModal">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger btn-icon"
                                onclick="if(confirmDelete('user', ${user.id})) deleteUser(${user.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users" 
                  method="POST" 
                  onsubmit="return validateForm('addUserForm')"
                  id="addUserForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control" name="username" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" 
                                   name="isAdmin" id="addUserIsAdmin">
                            <label class="form-check-label" for="addUserIsAdmin">
                                Admin User
                            </label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div class="modal fade" id="editUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users" 
                  method="POST"
                  onsubmit="return validateForm('editUserForm')"
                  id="editUserForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editUserId">
                    
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control" name="username" 
                               id="editUserUsername" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" 
                               id="editUserEmail" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">New Password (leave blank to keep current)</label>
                        <input type="password" class="form-control" name="password">
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
// Toggle admin status
function toggleAdminStatus(id, currentStatus) {
    if (confirm(`Are you sure you want to ${currentStatus ? 'remove' : 'grant'} admin privileges for this user?`)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/users';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'toggleAdmin';
        
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'id';
        idInput.value = id;
        
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
}

// Reset password
function resetPassword(id) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/admin/users';
    
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'resetPassword';
    
    const idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = 'id';
    idInput.value = id;
    
    form.appendChild(actionInput);
    form.appendChild(idInput);
    document.body.appendChild(form);
    form.submit();
}

// Delete user
function deleteUser(id) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/admin/users';
    
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

// Edit user
function editUser(id) {
    const row = document.querySelector(`tr[data-user-id="${id}"]`);
    if (!row) return;
    
    document.getElementById('editUserId').value = id;
    document.getElementById('editUserUsername').value = row.querySelector('[data-username]').dataset.username;
    document.getElementById('editUserEmail').value = row.querySelector('[data-email]').dataset.email;
}
</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
