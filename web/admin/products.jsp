<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    
    <!-- SweetAlert2 CSS -->
    
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    

    <style>
        .image-preview {
            display: block !important;
            min-height: 100px;
        }
        .image-preview img {
            display: block;
            max-width: 200px;
            max-height: 200px;
            object-fit: contain;
        }
    </style>
</head>
<body>
    <c:set var="title" value="Products Management" scope="request"/>
    <c:set var="active" value="products" scope="request"/>
    <%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

    <!-- Products Content -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Products Management</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
            <i class="fas fa-plus me-2"></i>Add Product
        </button>
    </div>

<!-- Products Table -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach items="${products}" var="product">
            <tr>
                <td>${product.id}</td>
                <td>
                    <c:choose>
                        <c:when test="${fn:startsWith(product.imageUrl, 'http')}">
                            <img src="${product.imageUrl}" alt="${product.name}" style="max-width: 100px; max-height: 100px;">
                        </c:when>
                        <c:when test="${fn:startsWith(product.imageUrl, 'uploads/')}">
                            <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.name}" style="max-width: 100px; max-height: 100px;">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/uploads/${product.imageUrl}" alt="${product.name}" style="max-width: 100px; max-height: 100px;">
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>${product.name}</td>
                <td>${product.categoryName}</td>
                <td>
                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/>
                </td>
                <td>${product.stockQuantity}</td>
                <td>
                    <button class="btn btn-sm btn-primary btn-icon me-2" 
                            onclick="editProduct({
                                id: '${product.id}',
                                name: '${fn:replace(product.name, "'", "\\'")}',
                                description: '${fn:replace(product.description, "'", "\\'")}',
                                price: '${product.price}',
                                categoryId: '${product.categoryId}',
                                stockQuantity: '${product.stockQuantity}',
                                imageUrl: '${product.imageUrl}'
                            })"
                            data-bs-toggle="modal" 
                            data-bs-target="#editProductModal">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-danger btn-icon"
        onclick="deleteProduct(${product.id})">
    <i class="fas fa-trash"></i>
</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form class="product-form" action="${pageContext.request.contextPath}/admin/products" method="POST" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3" required></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Price</label>
                        <input type="number" class="form-control" name="price" step="0.01" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <select class="form-control" name="categoryId" required>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Stock</label>
                        <input type="number" class="form-control" name="stockQuantity" required>
                    </div>
                    
                    <div class="form-group">
    <label>Product Image</label>
    <div class="d-flex align-items-center mb-2">
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="imageType" value="upload" id="imageTypeUpload" checked>
            <label class="form-check-label" for="imageTypeUpload">Upload Image</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="imageType" value="url" id="imageTypeUrl">
            <label class="form-check-label" for="imageTypeUrl">Image URL</label>
        </div>
    </div>
    
    <div class="upload-input">
        <input type="file" class="form-control" name="productImage" accept="image/*">
    </div>
    
    <div class="url-input d-none">
        <input type="text" class="form-control" name="imageUrl" placeholder="Enter image URL">
    </div>
    
    <div class="image-preview mt-2 d-none">
        <img src="" alt="Preview" style="max-width: 200px; max-height: 200px;">
    </div>
    <div class="text-danger image-error"></div>
</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Product Modal -->
<div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editProductForm" action="${pageContext.request.contextPath}/admin/products" method="POST" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id">
                    
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Price</label>
                        <input type="number" class="form-control" name="price" step="0.01" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <select class="form-control" name="categoryId" required>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Stock</label>
                        <input type="number" class="form-control" name="stockQuantity" required>
                    </div>
                    
                    <div class="form-group">
    <label>Product Image</label>
    <div class="d-flex align-items-center mb-2">
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="imageType" value="current" id="editImageTypeCurrent" checked>
            <label class="form-check-label" for="editImageTypeCurrent">Keep Current Image</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="imageType" value="upload" id="editImageTypeUpload">
            <label class="form-check-label" for="editImageTypeUpload">Upload New Image</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="imageType" value="url" id="editImageTypeUrl">
            <label class="form-check-label" for="editImageTypeUrl">New Image URL</label>
        </div>
    </div>
    
    <div class="current-image">
        <input type="hidden" name="currentImageUrl">
    </div>
    
    <div class="upload-input d-none">
        <input type="file" class="form-control" name="productImage" accept="image/*">
    </div>
    
    <div class="url-input d-none">
        <input type="text" class="form-control" name="imageUrl" placeholder="Enter image URL">
    </div>
    
    <div class="image-preview mt-2">
        <img src="" alt="Preview" style="max-width: 200px; max-height: 200px;">
    </div>
    <div class="text-danger image-error"></div>
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
// Update the image type change handler for edit form:
document.addEventListener('DOMContentLoaded', function() {
    // =============== ADD PRODUCT IMAGE HANDLING ===============
    const addProductForm = document.querySelector('#addProductModal .product-form');
    if (addProductForm) {
        const addImageTypes = addProductForm.querySelectorAll('[name="imageType"]');
        const addUploadInput = addProductForm.querySelector('.upload-input');
        const addUrlInput = addProductForm.querySelector('.url-input');
        const addPreview = addProductForm.querySelector('.image-preview');
        const addErrorDisplay = addProductForm.querySelector('.image-error');

        // Handle image type change in Add Product
        addImageTypes.forEach(radio => {
            radio.addEventListener('change', function() {
                addUploadInput.classList.toggle('d-none', this.value !== 'upload');
                addUrlInput.classList.toggle('d-none', this.value !== 'url');
                
                // Clear inputs and preview when switching
                if (this.value === 'upload') {
                    addUrlInput.querySelector('input').value = '';
                } else {
                    addUploadInput.querySelector('input').value = '';
                }
                addPreview.classList.add('d-none');
                addPreview.querySelector('img').src = '';
                addErrorDisplay.textContent = '';
            });
        });

        // Handle file input in Add Product
        const addFileInput = addUploadInput.querySelector('input[type="file"]');
        if (addFileInput) {
            addFileInput.addEventListener('change', function() {
                if (this.files && this.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const img = addPreview.querySelector('img');
                        img.src = e.target.result;
                        addPreview.classList.remove('d-none');
                        addErrorDisplay.textContent = '';
                    };
                    reader.readAsDataURL(this.files[0]);
                }
            });
        }

        // Handle URL input in Add Product
        const addUrlField = addUrlInput.querySelector('input');
        if (addUrlField) {
            addUrlField.addEventListener('input', function() {
                const img = addPreview.querySelector('img');
                if (this.value.trim()) {
                    img.src = this.value.trim();
                    img.onload = () => {
                        addPreview.classList.remove('d-none');
                        addErrorDisplay.textContent = '';
                    };
                    img.onerror = () => {
                        addPreview.classList.add('d-none');
                        addErrorDisplay.textContent = 'Invalid image URL';
                    };
                } else {
                    addPreview.classList.add('d-none');
                    img.src = '';
                }
            });
        }

        // Add Product form validation
        addProductForm.addEventListener('submit', function(e) {
            const imageType = this.querySelector('[name="imageType"]:checked').value;
            addErrorDisplay.textContent = '';

            if (imageType === 'upload' && (!addFileInput.files || !addFileInput.files[0])) {
                e.preventDefault();
                addErrorDisplay.textContent = 'Please select an image file';
            } else if (imageType === 'url' && !addUrlField.value.trim()) {
                e.preventDefault();
                addErrorDisplay.textContent = 'Please enter an image URL';
            }
        });
    }

    // =============== EDIT PRODUCT IMAGE HANDLING ===============
    const editProductForm = document.querySelector('#editProductForm');
    if (editProductForm) {
        const editImageTypes = editProductForm.querySelectorAll('[name="imageType"]');
        const editUploadInput = editProductForm.querySelector('.upload-input');
        const editUrlInput = editProductForm.querySelector('.url-input');
        const editPreview = editProductForm.querySelector('.image-preview');
        const editErrorDisplay = editProductForm.querySelector('.image-error');

        // Store original image URL when opening edit modal
        let originalImageUrl = '';

        // Update editProduct function
        window.editProduct = function(product) {
            // Store original image URL
            originalImageUrl = product.imageUrl;

            // Set form values
            editProductForm.querySelector('[name="id"]').value = product.id;
            editProductForm.querySelector('[name="name"]').value = product.name;
            editProductForm.querySelector('[name="description"]').value = product.description;
            editProductForm.querySelector('[name="price"]').value = product.price;
            editProductForm.querySelector('[name="categoryId"]').value = product.categoryId;
            editProductForm.querySelector('[name="stockQuantity"]').value = product.stockQuantity;
            editProductForm.querySelector('[name="currentImageUrl"]').value = product.imageUrl;

            // Reset to "Keep Current Image"
            editProductForm.querySelector('#editImageTypeCurrent').checked = true;

            // Show current image in preview
            const previewImg = editPreview.querySelector('img');
            if (product.imageUrl) {
                let displayUrl = product.imageUrl;
                if (!displayUrl.startsWith('http')) {
                    displayUrl = displayUrl.startsWith('/') 
                        ? '${pageContext.request.contextPath}' + displayUrl
                        : displayUrl.startsWith('uploads/') 
                            ? '${pageContext.request.contextPath}/' + displayUrl
                            : '${pageContext.request.contextPath}/uploads/' + displayUrl;
                }
                previewImg.src = displayUrl;
                editPreview.classList.remove('d-none');
            } else {
                previewImg.src = '';
                editPreview.classList.add('d-none');
            }

            // Reset other inputs
            editUploadInput.classList.add('d-none');
            editUrlInput.classList.add('d-none');
            editUploadInput.querySelector('input[type="file"]').value = '';
            editUrlInput.querySelector('input').value = '';
            editErrorDisplay.textContent = '';
        };

        // Handle image type change in Edit Product
        editImageTypes.forEach(radio => {
            radio.addEventListener('change', function() {
                editUploadInput.classList.toggle('d-none', this.value === 'current' || this.value === 'url');
                editUrlInput.classList.toggle('d-none', this.value === 'current' || this.value === 'upload');
                
                if (this.value === 'current') {
                    // Show original image
                    if (originalImageUrl) {
                        let displayUrl = originalImageUrl;
                        if (!originalImageUrl.startsWith('http')) {
                            displayUrl = displayUrl.startsWith('/') 
                                ? '${pageContext.request.contextPath}' + originalImageUrl
                                : displayUrl.startsWith('uploads/') 
                                    ? '${pageContext.request.contextPath}/' + displayUrl
                                    : '${pageContext.request.contextPath}/uploads/' + displayUrl;
                        }
                        editPreview.querySelector('img').src = displayUrl;
                        editPreview.classList.remove('d-none');
                    }
                }
                editErrorDisplay.textContent = '';
            });
        });

        // Handle file input in Edit Product
        const editFileInput = editUploadInput.querySelector('input[type="file"]');
        if (editFileInput) {
            editFileInput.addEventListener('change', function() {
                if (this.files && this.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const img = editPreview.querySelector('img');
                        img.src = e.target.result;
                        editPreview.classList.remove('d-none');
                        editErrorDisplay.textContent = '';
                    };
                    reader.readAsDataURL(this.files[0]);
                }
            });
        }

        // Handle URL input in Edit Product
        const editUrlField = editUrlInput.querySelector('input');
        if (editUrlField) {
            editUrlField.addEventListener('input', function() {
                const img = editPreview.querySelector('img');
                if (this.value.trim()) {
                    img.src = this.value.trim();
                    img.onload = () => {
                        editPreview.classList.remove('d-none');
                        editErrorDisplay.textContent = '';
                    };
                    img.onerror = () => {
                        editPreview.classList.add('d-none');
                        editErrorDisplay.textContent = 'Invalid image URL';
                    };
                } else {
                    editPreview.classList.add('d-none');
                    img.src = '';
                }
            });
        }

        // Edit Product form validation
        editProductForm.addEventListener('submit', function(e) {
            const imageType = this.querySelector('[name="imageType"]:checked').value;
            editErrorDisplay.textContent = '';

            if (imageType === 'upload' && (!editFileInput.files || !editFileInput.files[0])) {
                e.preventDefault();
                editErrorDisplay.textContent = 'Please select an image file';
            } else if (imageType === 'url' && !editUrlField.value.trim()) {
                e.preventDefault();
                editErrorDisplay.textContent = 'Please enter an image URL';
            }
        });
    }
});

// Delete product confirmation
function deleteProduct(id) {
    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
        if (result.isConfirmed) {
            // Create and submit form for deletion
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/products';
            
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

            // Submit form and handle response
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                fetch(form.action, {
                    method: 'POST',
                    body: new FormData(form)
                })
                .then(response => {
                    if (response.ok) {
                        Swal.fire(
                            'Deleted!',
                            'Product has been deleted.',
                            'success'
                        ).then(() => {
                            window.location.reload();
                        });
                    } else {
                        return response.text().then(text => {
                            throw new Error(text);
                        });
                    }
                })
                .catch(error => {
                    Swal.fire(
                        'Error!',
                        error.message || 'Failed to delete product',
                        'error'
                    );
                });
            });
            
            form.submit();
        }
    });
}

// Edit product function
// Thêm biến để lưu trữ URL ảnh gốc
// Khởi tạo biến lưu trữ URL ảnh gốc
let originalImageUrl = '';

// Remove the duplicate editProduct function and keep only one version
function editProduct(product) {
    // Store original image URL
    originalImageUrl = product.imageUrl;

    const form = document.querySelector('#editProductForm');
    if (!form) return;

    // Set basic form values
    form.querySelector('[name="id"]').value = product.id;
    form.querySelector('[name="name"]').value = product.name;
    form.querySelector('[name="description"]').value = product.description;
    form.querySelector('[name="price"]').value = product.price;
    form.querySelector('[name="categoryId"]').value = product.categoryId;
    form.querySelector('[name="stockQuantity"]').value = product.stockQuantity;
    form.querySelector('[name="currentImageUrl"]').value = product.imageUrl;

    // Reset to "Keep Current Image"
    form.querySelector('#editImageTypeCurrent').checked = true;

    // Reset other inputs
    const uploadInput = form.querySelector('.upload-input');
    const urlInput = form.querySelector('.url-input');
    const preview = form.querySelector('.image-preview');
    const previewImg = preview.querySelector('img');
    const errorDisplay = form.querySelector('.image-error');

    // Hide both input sections
    uploadInput.classList.add('d-none');
    urlInput.classList.add('d-none');
    
    // Clear both inputs
    form.querySelector('[name="productImage"]').value = '';
    form.querySelector('[name="imageUrl"]').value = '';
    errorDisplay.textContent = '';

    // Show current image in preview
    if (product.imageUrl) {
        let displayUrl = product.imageUrl;
        if (!displayUrl.startsWith('http')) {
            displayUrl = displayUrl.startsWith('/') 
                ? '${pageContext.request.contextPath}' + displayUrl
                : displayUrl.startsWith('uploads/') 
                    ? '${pageContext.request.contextPath}/' + displayUrl
                    : '${pageContext.request.contextPath}/uploads/' + displayUrl;
        }
        previewImg.src = displayUrl;
        preview.classList.remove('d-none');
    } else {
        previewImg.src = '';
        preview.classList.add('d-none');
    }
}

// Make sure to remove any other editProduct function definitions in your code

// Handle image type change
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('#editProductForm');
    if (!form) return;

    const imageTypes = form.querySelectorAll('[name="imageType"]');
    const uploadInput = form.querySelector('.upload-input');
    const urlInput = form.querySelector('.url-input');
    const preview = form.querySelector('.image-preview');
    const previewImg = preview.querySelector('img');

    imageTypes.forEach(radio => {
        radio.addEventListener('change', function() {
            // Hide both input sections initially
            uploadInput.classList.add('d-none');
            urlInput.classList.add('d-none');

            // Clear both inputs
            form.querySelector('[name="productImage"]').value = '';
            form.querySelector('[name="imageUrl"]').value = '';

            switch(this.value) {
                case 'current':
                    // Show original image
                    if (originalImageUrl) {
                        let displayUrl = originalImageUrl;
                        if (!originalImageUrl.startsWith('http')) {
                            displayUrl = displayUrl.startsWith('/') 
                                ? '${pageContext.request.contextPath}' + originalImageUrl
                                : displayUrl.startsWith('uploads/') 
                                    ? '${pageContext.request.contextPath}/' + displayUrl
                                    : '${pageContext.request.contextPath}/uploads/' + displayUrl;
                        }
                        previewImg.src = displayUrl;
                        preview.classList.remove('d-none');
                    }
                    break;
                case 'upload':
                    // Show upload input and hide preview
                    uploadInput.classList.remove('d-none');
                    preview.classList.add('d-none');
                    previewImg.src = '';
                    break;
                case 'url':
                    // Show URL input and hide preview
                    urlInput.classList.remove('d-none');
                    preview.classList.add('d-none');
                    previewImg.src = '';
                    break;
            }
        });
    });

    // Handle file input change
    const fileInput = form.querySelector('[name="productImage"]');
    fileInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
                preview.classList.remove('d-none');
            };
            reader.readAsDataURL(this.files[0]);
        } else {
            preview.classList.add('d-none');
            previewImg.src = '';
        }
    });

    // Handle URL input change
    const urlField = form.querySelector('[name="imageUrl"]');
    urlField.addEventListener('input', function() {
        if (this.value.trim()) {
            previewImg.src = this.value.trim();
            previewImg.onload = () => {
                preview.classList.remove('d-none');
            };
            previewImg.onerror = () => {
                preview.classList.add('d-none');
                previewImg.src = '';
            };
        } else {
            preview.classList.add('d-none');
            previewImg.src = '';
        }
    });
});

// Update the image type radio change handler
document.querySelectorAll('#editProductForm [name="imageType"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const form = this.closest('form');
        const urlInput = form.querySelector('.url-input');
        const uploadInput = form.querySelector('.upload-input');
        
        // Reset error message when switching image types
        resetImageError(form);
        
        if (this.value === 'url') {
            urlInput.classList.remove('d-none');
            uploadInput.classList.add('d-none');
            form.querySelector('[name="productImage"]').value = '';
            form.querySelector('[name="newImageUrl"]').value = '';
        } else {
            urlInput.classList.add('d-none');
            uploadInput.classList.remove('d-none');
        }
    });
});

</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>