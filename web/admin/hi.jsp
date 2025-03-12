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
<!--    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    -->
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>


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
                            onclick="if (confirmDelete('product', ${product.id}))
                                        deleteProduct(${product.id})">
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
                                <input class="form-check-input" type="radio" name="imageType" value="url" id="imageTypeUrl" checked>
                                <label class="form-check-label" for="imageTypeUrl">Image URL</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="imageType" value="upload" id="imageTypeUpload">
                                <label class="form-check-label" for="imageTypeUpload">Upload Image</label>
                            </div>
                        </div>
                        
                        <div class="url-input">
                            <input type="text" class="form-control" name="imageUrl" placeholder="Enter image URL">
                        </div>
                        
                        <div class="upload-input d-none">
                            <div class="mb-2">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="newImageType" value="file" id="newImageTypeFile" checked>
                                    <label class="form-check-label" for="newImageTypeFile">Upload File</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="newImageType" value="url" id="newImageTypeUrl">
                                    <label class="form-check-label" for="newImageTypeUrl">From URL</label>
                                </div>
                            </div>
                            <div class="file-upload-input">
                                <input type="file" class="form-control" name="productImage" accept="image/*">
                            </div>
                            <div class="new-url-input d-none">
                                <input type="text" class="form-control" name="newImageUrl" placeholder="Enter image URL">
                            </div>
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
                                <input class="form-check-input" type="radio" name="imageType" value="url" id="editImageTypeUrl" checked>
                                <label class="form-check-label" for="editImageTypeUrl">Keep Current Image</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="imageType" value="upload" id="editImageTypeUpload">
                                <label class="form-check-label" for="editImageTypeUpload">New Image</label>
                            </div>
                        </div>
                        
                        <div class="url-input">
                            <input type="hidden" class="form-control" name="imageUrl">
                        </div>
                        
                        <div class="upload-input d-none">
                            <div class="mb-2">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="newImageType" value="file" id="newImageTypeFile" checked>
                                    <label class="form-check-label" for="newImageTypeFile">Upload File</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="newImageType" value="url" id="newImageTypeUrl">
                                    <label class="form-check-label" for="newImageTypeUrl">From URL</label>
                                </div>
                            </div>
                            <div class="file-upload-input">
                                <input type="file" class="form-control" name="productImage" accept="image/*">
                            </div>
                            <div class="new-url-input d-none">
                                <input type="text" class="form-control" name="newImageUrl" placeholder="Enter image URL">
                            </div>
                        </div>
                        
                        <div class="image-preview mt-3">
                            <img src="" alt="Product preview" style="max-width: 200px; max-height: 200px; object-fit: contain;" class="border">
                        </div>
                        <div class="image-error text-danger mt-1"></div>
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
document.addEventListener('DOMContentLoaded', function() {
    // Handle image type selection
    document.querySelectorAll('[name="imageType"]').forEach(radio => {
        radio.addEventListener('change', function() {
            const form = this.closest('form');
            const urlInput = form.querySelector('.url-input');
            const uploadInput = form.querySelector('.upload-input');
            const preview = form.querySelector('.image-preview');
            
            if (this.value === 'url') {
                urlInput.classList.remove('d-none');
                uploadInput.classList.add('d-none');
                form.querySelector('[name="productImage"]').value = '';
                
                // Check if there's a URL already entered
                const imageUrl = form.querySelector('[name="imageUrl"]').value;
                if (imageUrl) {
                    showImagePreview(preview, imageUrl);
                } else {
                    hideImagePreview(preview);
                }
            } else {
                urlInput.classList.add('d-none');
                uploadInput.classList.remove('d-none');
                form.querySelector('[name="imageUrl"]').value = '';
                hideImagePreview(preview);
            }
        });
    });

    // Handle URL input
    document.querySelectorAll('[name="imageUrl"]').forEach(input => {
        input.addEventListener('input', function() {
            const form = this.closest('form');
            const preview = form.querySelector('.image-preview');
            
            if (this.value) {
                showImagePreview(preview, this.value);
            } else {
                hideImagePreview(preview);
            }
        });
    });

    // Handle file input
    document.querySelectorAll('[name="productImage"]').forEach(input => {
        input.addEventListener('change', function() {
            const form = this.closest('form');
            const preview = form.querySelector('.image-preview');
            
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    showImagePreview(preview, e.target.result);
                };
                
                reader.readAsDataURL(this.files[0]);
            } else {
                hideImagePreview(preview);
            }
        });
    });

    // Helper functions
    function showImagePreview(previewDiv, src) {
        const img = previewDiv.querySelector('img');
        img.src = src;
        previewDiv.classList.remove('d-none');
        
        // Handle image load error
        img.onerror = function() {
            hideImagePreview(previewDiv);
            const form = previewDiv.closest('form');
            form.querySelector('.image-error').textContent = 'Invalid image URL or file';
        };
        
        img.onload = function() {
            previewDiv.closest('form').querySelector('.image-error').textContent = '';
        };
    }

    function hideImagePreview(previewDiv) {
        previewDiv.classList.add('d-none');
        const img = previewDiv.querySelector('img');
        img.src = '';
    }

    // Form validation
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function(e) {
            let isValid = true;
            const imageType = form.querySelector('[name="imageType"]:checked').value;
            const imageUrl = form.querySelector('[name="imageUrl"]');
            const imageFile = form.querySelector('[name="productImage"]');
            const newImageUrl = form.querySelector('[name="newImageUrl"]');
            const imageError = form.querySelector('.image-error');
            
            // Clear previous errors
            imageError.textContent = '';
            
            if (imageType === 'upload') {
                const newImageType = form.querySelector('[name="newImageType"]:checked').value;
                if (newImageType === 'file') {
                    if (!imageFile.files || !imageFile.files[0]) {
                        imageError.textContent = 'Please select an image file';
                        isValid = false;
                    }
                    // Clear URL inputs
                    imageUrl.value = '';
                    newImageUrl.value = '';
                } else {
                    if (!newImageUrl.value || !newImageUrl.value.trim()) {
                        imageError.textContent = 'Please enter an image URL';
                        isValid = false;
                    }
                    // Clear file input
                    imageFile.value = '';
                    imageUrl.value = '';
                }
            } else if (imageType === 'url') {
                if (!imageUrl.value || !imageUrl.value.trim()) {
                    imageError.textContent = 'Please enter an image URL';
                    isValid = false;
                }
                // Clear new image inputs
                imageFile.value = '';
                newImageUrl.value = '';
            }
            
            if (!isValid) {
                e.preventDefault();
            }
        });
    });
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
            form.submit();
        }
    });
}

// Edit product function
// Thêm biến để lưu trữ URL ảnh gốc
let originalImageUrl = '';

function editProduct(product) {
    const form = document.querySelector('#editProductForm');
    if (!form) return;

    // Lưu URL ảnh gốc khi mở modal
    originalImageUrl = product.imageUrl;

    // Set basic form values
    form.querySelector('[name="id"]').value = product.id;
    form.querySelector('[name="name"]').value = product.name;
    form.querySelector('[name="description"]').value = product.description;
    form.querySelector('[name="price"]').value = product.price;
    form.querySelector('[name="categoryId"]').value = product.categoryId;
    form.querySelector('[name="stockQuantity"]').value = product.stockQuantity;
    
    // Set image URL and preview
    const imageUrlInput = form.querySelector('[name="imageUrl"]');
    const previewContainer = form.querySelector('.image-preview');
    const previewImg = previewContainer.querySelector('img');
    
    // Reset form state
    form.querySelector('#editImageTypeUrl').checked = true;
    form.querySelector('.url-input').classList.remove('d-none');
    form.querySelector('.upload-input').classList.add('d-none');
    form.querySelector('[name="productImage"]').value = '';
    form.querySelector('[name="newImageUrl"]').value = '';
    
    if (product.imageUrl) {
        imageUrlInput.value = product.imageUrl;
        
        // Construct the correct image URL
        let imageUrl = product.imageUrl;
        if (!imageUrl.startsWith('http')) {
            imageUrl = imageUrl.startsWith('/') ? imageUrl : '/' + imageUrl;
            imageUrl = '${pageContext.request.contextPath}' + imageUrl;
        }
        
        // Set image preview
        previewImg.src = imageUrl;
        previewContainer.classList.remove('d-none');
    }
}


// Xử lý khi thay đổi loại input ảnh
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('#editProductForm');
    if (!form) return;

    const urlRadio = form.querySelector('#editImageTypeUrl');
    const uploadRadio = form.querySelector('#editImageTypeUpload');
    const urlInput = form.querySelector('.url-input');
    const uploadInput = form.querySelector('.upload-input');
    const previewImg = form.querySelector('.image-preview img');

    // Xử lý khi chọn giữ ảnh cũ
    urlRadio.addEventListener('change', function() {
        if (this.checked) {
            urlInput.classList.remove('d-none');
            uploadInput.classList.add('d-none');
            const imageUrl = form.querySelector('[name="imageUrl"]').value;
            if (imageUrl) {
                if (imageUrl.startsWith('http')) {
                    previewImg.src = imageUrl;
                } else {
                    previewImg.src = '${pageContext.request.contextPath}/uploads/' + imageUrl;
                }
                previewImg.style.display = 'block';
            }
        }
    });

    // Xử lý khi chọn upload ảnh mới
    uploadRadio.addEventListener('change', function() {
        if (this.checked) {
            urlInput.classList.add('d-none');
            uploadInput.classList.remove('d-none');
            form.querySelector('[name="productImage"]').value = '';
        }
    });

    // Xử lý preview khi chọn file mới
    form.querySelector('[name="productImage"]').addEventListener('change', function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                previewImg.src = e.target.result;
                previewImg.style.display = 'block';
            };
            
            reader.readAsDataURL(file);
        }
    });
});

/// Cập nhật xử lý sự kiện thay đổi imageType
document.querySelectorAll('#editProductForm [name="imageType"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const form = this.closest('form');
        const urlInput = form.querySelector('.url-input');
        const uploadInput = form.querySelector('.upload-input');
        const preview = form.querySelector('.image-preview');
        const previewImg = preview.querySelector('img');
        const imageUrlInput = form.querySelector('[name="imageUrl"]');
        
        if (this.value === 'url') {
            // Khi chuyển về "Keep Current Image"
            urlInput.classList.remove('d-none');
            uploadInput.classList.add('d-none');
            
            // Reset các input upload
            form.querySelector('[name="productImage"]').value = '';
            form.querySelector('[name="newImageUrl"]').value = '';
            
            // Khôi phục lại ảnh preview gốc
            if (originalImageUrl) {
                imageUrlInput.value = originalImageUrl;
                let displayUrl = originalImageUrl;
                if (!originalImageUrl.startsWith('http')) {
                    displayUrl = originalImageUrl.startsWith('/') 
                        ? '${pageContext.request.contextPath}' + originalImageUrl
                        : '${pageContext.request.contextPath}/uploads/' + originalImageUrl;
                }
                previewImg.src = displayUrl;
                preview.classList.remove('d-none');
            }
        } else {
            // Khi chuyển sang "New Image"
            urlInput.classList.add('d-none');
            uploadInput.classList.remove('d-none');
            
            // Vẫn giữ nguyên preview ảnh hiện tại cho đến khi có ảnh mới
            if (previewImg.src) {
                preview.classList.remove('d-none');
            }
        }
    });
});

// Handle new image type selection (file/url) within upload section
document.querySelectorAll('[name="newImageType"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const form = this.closest('form');
        const fileUploadInput = form.querySelector('.file-upload-input');
        const newUrlInput = form.querySelector('.new-url-input');
        const preview = form.querySelector('.image-preview');
        
        if (this.value === 'file') {
            fileUploadInput.classList.remove('d-none');
            newUrlInput.classList.add('d-none');
            form.querySelector('[name="newImageUrl"]').value = '';
            form.querySelector('[name="productImage"]').value = '';
            preview.classList.add('d-none');
        } else {
            fileUploadInput.classList.add('d-none');
            newUrlInput.classList.remove('d-none');
            form.querySelector('[name="productImage"]').value = '';
        }
    });
});

// Handle new URL input in upload section
document.querySelectorAll('[name="newImageUrl"]').forEach(input => {
    input.addEventListener('input', function() {
        const form = this.closest('form');
        const preview = form.querySelector('.image-preview');
        const previewImg = preview.querySelector('img');
        
        if (this.value.trim()) {
            previewImg.src = this.value.trim();
            preview.classList.remove('d-none');
            
            // Add error handling for preview image
            previewImg.onerror = function() {
                preview.classList.add('d-none');
                form.querySelector('.image-error').textContent = 'Invalid image URL';
            };
            
            previewImg.onload = function() {
                preview.classList.remove('d-none');
                form.querySelector('.image-error').textContent = '';
            };
        } else {
            preview.classList.add('d-none');
            previewImg.src = '';
        }
    });
});

// Handle file input change
// Cập nhật xử lý khi chọn file mới
document.querySelector('#editProductForm [name="productImage"]').addEventListener('change', function(e) {
    const file = this.files[0];
    const form = this.closest('form');
    const preview = form.querySelector('.image-preview');
    const previewImg = preview.querySelector('img');
    
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            preview.classList.remove('d-none');
        };
        reader.readAsDataURL(file);
    }
});

// Cập nhật xử lý khi nhập URL mới
document.querySelector('#editProductForm [name="newImageUrl"]').addEventListener('input', function() {
    const form = this.closest('form');
    const preview = form.querySelector('.image-preview');
    const previewImg = preview.querySelector('img');
    
    if (this.value.trim()) {
        previewImg.src = this.value.trim();
        preview.classList.remove('d-none');
    }
});

// Add form validation for image URL and handle form submission
document.querySelector('#editProductForm').addEventListener('submit', function(e) {
    const form = this;
    const imageType = form.querySelector('[name="imageType"]:checked').value;
    const imageUrlInput = form.querySelector('[name="imageUrl"]');
    
    if (imageType === 'upload') {
        const newImageType = form.querySelector('[name="newImageType"]:checked').value;
        if (newImageType === 'url') {
            const newImageUrl = form.querySelector('[name="newImageUrl"]').value.trim();
            if (!newImageUrl) {
                e.preventDefault();
                form.querySelector('.image-error').textContent = 'Please enter an image URL';
                return;
            }
            // Set the new URL to the main imageUrl field
            imageUrlInput.value = newImageUrl;
        } else if (newImageType === 'file') {
            const fileInput = form.querySelector('[name="productImage"]');
            if (!fileInput.files || !fileInput.files[0]) {
                e.preventDefault();
                form.querySelector('.image-error').textContent = 'Please select a file';
                return;
            }
        }
    }
});

// Update the image type radio change handler
document.querySelectorAll('#editProductForm [name="imageType"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const form = this.closest('form');
        const urlInput = form.querySelector('.url-input');
        const uploadInput = form.querySelector('.upload-input');
        const imageUrlInput = form.querySelector('[name="imageUrl"]');
        
        if (this.value === 'url') {
            urlInput.classList.remove('d-none');
            uploadInput.classList.add('d-none');
            // Reset upload inputs
            form.querySelector('[name="productImage"]').value = '';
            form.querySelector('[name="newImageUrl"]').value = '';
        } else {
            urlInput.classList.add('d-none');
            uploadInput.classList.remove('d-none');
            // Store the current URL temporarily
            const currentUrl = imageUrlInput.value;
            imageUrlInput.setAttribute('data-previous-url', currentUrl);
        }
    });
});

</script>

<%@ include file="/WEB-INF/jspf/admin-footer.jspf" %>
