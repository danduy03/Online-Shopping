<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="title" value="Articles Management" scope="request"/>
<c:set var="active" value="articles" scope="request"/>
<%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

<!-- Articles Content -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Articles Management</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addArticleModal">
        <i class="fas fa-plus me-2"></i>Add Article
    </button>
</div>

<!-- Articles Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Thumbnail</th>
                <th>Title</th>
                <th>Author</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${articles}" var="article">
                <tr data-article-id="${article.id}">
                    <td>${article.id}</td>
                    <td>
                        <img src="${article.thumbnail}" 
                             alt="${article.title}"
                             style="width: 40px; height: 40px; object-fit: cover;">
                    </td>
                    <td data-title="${article.title}">
                        ${article.title}
                        <div class="small text-muted">${article.summary}</div>
                    </td>
                    <td data-author="${article.author}">${article.author}</td>
                    <td>
                        <span class="badge bg-${article.status == 'published' ? 'primary' : 'secondary'}">
                            ${article.status}
                        </span>
                    </td>
                    <td>
                        <fmt:formatDate value="${article.createdAt}" 
                                      pattern="MMM dd, yyyy HH:mm"/>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-primary btn-icon me-2" 
                                onclick="editArticle(${article.id})"
                                data-bs-toggle="modal" data-bs-target="#editArticleModal">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger btn-icon"
                                onclick="if(confirmDelete('article', ${article.id})) deleteArticle(${article.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Add Article Modal -->
<div class="modal fade" id="addArticleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Article</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/articles" 
                  method="POST" 
                  enctype="multipart/form-data"
                  onsubmit="return validateForm('addArticleForm')"
                  id="addArticleForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" class="form-control" name="title" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Summary</label>
                        <textarea class="form-control" name="summary" rows="2"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Content</label>
                        <textarea class="form-control" name="content" rows="5" required></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Thumbnail</label>
                        <input type="file" class="form-control" name="thumbnail" accept="image/*" required>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" 
                                   name="published" id="addArticlePublished">
                            <label class="form-check-label" for="addArticlePublished">
                                Publish immediately
                            </label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Article</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Article Modal -->
<div class="modal fade" id="editArticleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Article</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/articles" 
                  method="POST"
                  enctype="multipart/form-data"
                  onsubmit="return validateForm('editArticleForm')"
                  id="editArticleForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editArticleId">
                    
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" class="form-control" name="title" 
                               id="editArticleTitle" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Summary</label>
                        <textarea class="form-control" name="summary" 
                                  id="editArticleSummary" rows="2"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Content</label>
                        <textarea class="form-control" name="content" 
                                  id="editArticleContent" rows="5" required></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Thumbnail</label>
                        <input type="file" class="form-control" name="thumbnail" 
                               accept="image/*">
                        <small class="form-text text-muted">
                            Leave empty to keep current thumbnail
                        </small>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" 
                                   name="published" id="editArticlePublished">
                            <label class="form-check-label" for="editArticlePublished">
                                Published
                            </label>
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
// Delete article
function deleteArticle(id) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/admin/articles';
    
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

// Edit article
function editArticle(id) {
    const row = document.querySelector(`tr[data-article-id="${id}"]`);
    if (!row) return;
    
    document.getElementById('editArticleId').value = id;
    document.getElementById('editArticleTitle').value = row.querySelector('[data-title]').dataset.title;
    document.getElementById('editArticleAuthor').value = row.querySelector('[data-author]').dataset.author;
    
    // Additional fields would need to be populated via AJAX since they're not stored in data attributes
    fetch(`${pageContext.request.contextPath}/admin/articles/${id}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('editArticleSummary').value = data.summary;
            document.getElementById('editArticleContent').value = data.content;
            document.getElementById('editArticlePublished').checked = data.status === 'published';
        });
}
</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>