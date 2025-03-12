<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Products - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .product-card {
            height: 100%;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s, box-shadow 0.2s;
            border-radius: 12px;
            overflow: hidden;
            border: none;
            background: #fff;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .product-image {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }
        .product-info {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            padding: 15px;
        }
        .product-title {
            font-size: 1.1rem;
            font-weight: 500;
            margin: 0 0 10px 0;
            color: #2c3e50;
            height: 2.4em;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .product-description {
            color: #666;
            font-size: 0.9rem;
            flex-grow: 1;
            margin-bottom: 15px;
            height: 3.6em;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .product-price {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
        }
        .product-footer {
            margin-top: auto;
            padding-top: 15px;
            border-top: 1px solid rgba(0,0,0,0.1);
        }
        .cart-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            font-size: 0.7rem;
            padding: 0.25em 0.6em;
            border-radius: 50%;
            min-width: 18px;
            height: 18px;
            display: flex !important;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            border: 2px solid #343a40;
        }
        .cart-link {
            position: relative;
            display: inline-block;
            padding: 0.5rem 0.8rem;
        }
        .logout-link {
        margin-left: 20px; /* Khoảng cách giữa Logout và Cart */
        }
        .cart-link i {
            font-size: 1.2rem;
        }
        .btn-group .btn {
            border-radius: 6px;
        }
        .btn-group .btn:not(:last-child) {
            margin-right: 5px;
        }
        .btn-group .btn i {
            margin-right: 5px;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes fadeOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
        
        .navbar {
            padding: 0.8rem 0;
        }

        .search-container {
            display: flex;
            align-items: center;
            width: 50%;
            margin: 0 30px;
        }
        
        .search-bar {
            width: 100%;
            display: flex;
            align-items: center;
        }
        
        .search-bar input {
            height: 45px;
            border-radius: 25px;
            border: none;
            padding: 0 25px;
            font-size: 15px;
            width: 100%;
            background-color: white;
            color: #495057;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .search-bar input:focus {
            box-shadow: 0 3px 8px rgba(0,0,0,0.15);
            outline: none;
        }

        .search-bar input::placeholder {
            color: #adb5bd;
        }
        
        .search-bar button {
            height: 45px;
            width: 45px;
            min-width: 45px;
            border-radius: 50%;
            margin-left: -50px;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #0d6efd;
            border: none;
            color: white;
            transition: all 0.3s ease;
        }

        .search-bar button:hover {
            background: #0b5ed7;
            color: white;
            transform: scale(1.05);
        }

        body {
            padding-top: 56px;
        }

        .category-container {
            background-color: white;
            padding: 25px 0;
            border-bottom: 1px solid #eee;
            /*position: sticky;*/
            top: 56px;
            z-index: 1000;
        }

        .category-list {
            display: flex;
            justify-content: flex-start;
            gap: 12px;
            padding: 0;
            margin: 0;
            list-style: none;
            flex-wrap: wrap;
        }

        .category-item {
            padding: 6px 16px;
            border-radius: 20px;
            background-color: #f8f9fa;
            cursor: pointer;
            transition: all 0.2s;
        }

        .category-item:hover {
            background-color: #e9ecef;
        }

        .category-item.active {
            background-color: #0d6efd;
            color: white;
        }
        
        .products-container {
            margin-top: 30px;
            padding-bottom: 30px;
        }
        
        .sort-container {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 1010;
        }

        .sort-container .dropdown-toggle {
            padding: 6px 16px;
            border-radius: 20px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
        }

        .sort-container .dropdown-menu {
            min-width: 200px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            z-index: 1010;
        }

        .sort-container .dropdown-item {
            padding: 8px 20px;
            font-size: 0.9rem;
        }

        .sort-container .dropdown-item:hover {
            background-color: #f8f9fa;
        }

        .navbar-nav {
            align-items: center;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">E-Shop</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="products.jsp">Products</a>
                    </li>
                </ul>

                <div class="search-container">
                    <form action="products" method="get" class="search-bar">
                        <input type="text" name="search" class="form-control" 
                               placeholder="Search products..." 
                               value="${param.search}">
                        <button type="submit" class="btn">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>

                <ul class="navbar-nav ms-auto">
                    <% if (session.getAttribute("user") != null) { %>
                        <li class="nav-item">
                            <a class="nav-link cart-link" href="cart">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="badge bg-danger cart-badge">${sessionScope.cartCount != null ? sessionScope.cartCount : '0'}</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link logout-link" href="logout">Logout</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="register.jsp">Register</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <%
        // Clear any session messages
        session.removeAttribute("message");
        session.removeAttribute("error");
    %>

    <div class="category-container">
        <div class="container position-relative">
            <ul class="category-list">
                <li class="category-item ${empty param.category ? 'active' : ''}" 
                    onclick="window.location.href='products'">
                    All Categories
                </li>
                <c:forEach var="category" items="${categories}">
                    <li class="category-item ${param.category eq category.id ? 'active' : ''}" 
                        onclick="window.location.href='products?category=${category.id}'">
                        ${category.name}
                    </li>
                </c:forEach>
            </ul>

            <div class="sort-container">
                <div class="dropdown">
                    <button class="btn dropdown-toggle" type="button" 
                            id="sortDropdown" data-bs-toggle="dropdown">
                        <i class="fas fa-sort-amount-down-alt"></i> Sort by
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="?sort=newest${not empty param.category ? '&category='.concat(param.category) : ''}">Newest First</a></li>
                        <li><a class="dropdown-item" href="?sort=popular${not empty param.category ? '&category='.concat(param.category) : ''}">Most Popular</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="?sort=name${not empty param.category ? '&category='.concat(param.category) : ''}">Name: A to Z</a></li>
                        <li><a class="dropdown-item" href="?sort=price_asc${not empty param.category ? '&category='.concat(param.category) : ''}">Price: Low to High</a></li>
                        <li><a class="dropdown-item" href="?sort=price_desc${not empty param.category ? '&category='.concat(param.category) : ''}">Price: High to Low</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="container products-container">
        <div class="row g-4">
            <c:forEach var="product" items="${products}">
                <div class="col-md-6 col-lg-3">
                    <div class="card product-card">
                        <img src="${product.imageUrl}" class="product-image" alt="${product.name}">
                        <div class="card-body product-info">
                            <h5 class="product-title">${product.name}</h5>
                            <p class="product-description">${product.description}</p>
                            <div class="product-footer">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="product-price">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                                    <div class="btn-group">
                                        <% if (session.getAttribute("user") != null) { %>
                                            <button type="button" class="btn btn-primary" 
                                                    onclick="addToCart(${product.id})">
                                                <i class="fas fa-shopping-cart"></i> Add
                                            </button>
                                        <% } else { %>
                                            <button type="button" class="btn btn-primary" 
                                                    onclick="window.location.href='login.jsp'">
                                                <i class="fas fa-shopping-cart"></i> Add
                                            </button>
                                        <% } %>
                                       <c:if test="${sessionScope.user.admin}">
                                            <button class="btn btn-warning" onclick="editProduct(${product.id})">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-danger" onclick="deleteProduct(${product.id})">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showToast(message, type = 'success') {
            const toast = document.createElement('div');
            const bgColor = type === 'error' ? '#dc3545' : '#28a745';
            const icon = type === 'error' ? 'fa-exclamation-circle' : 'fa-check-circle';
            
            toast.style.cssText = 'position: fixed;' +
                'top: 33%;' +
                'right: 20px;' +
                'padding: 1rem 1.5rem;' +
                'border-radius: 8px;' +
                'box-shadow: 0 4px 12px rgba(0,0,0,0.2);' +
                'z-index: 1000;' +
                'animation: slideIn 0.5s;' +
                'min-width: 300px;' +
                'display: flex;' +
                'align-items: center;' +
                'gap: 12px;' +
                'font-weight: 500;' +
                'font-size: 1rem;' +
                'color: #ffffff;' +
                'background-color: ' + bgColor;
            
            toast.innerHTML = '<i class="fas ' + icon + '" style="font-size: 1.25rem;"></i>' +
                            '<span style="flex-grow: 1;">' + message + '</span>';
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.style.animation = 'fadeOut 0.5s forwards';
                setTimeout(() => toast.remove(), 500);
            }, 3000);
        }

//        function addToCart(productId) {
//            if (!productId) {
//                showToast('Invalid product ID', 'error');
//                return;
//            }
//
//            fetch('cart', {
//                method: 'POST',
//                headers: {
//                    'Content-Type': 'application/json',
//                },
//                body: JSON.stringify({
//                    action: 'add',
//                    productId: productId,
//                    quantity: 1
//                })
//            })
//            .then(response => {
//                if (!response.ok) {
//                    throw new Error('Network response was not ok');
//                }
//                return response.json();
//            })
//            .then(data => {
//                if (data.success) {
//                    showToast('Product added to cart successfully');
//                    // Update cart badge
//                    const badge = document.querySelector('.cart-badge');
//                    if (badge) {
//                        badge.textContent = data.cartCount;
//                        badge.style.display = 'flex';
//                    }
//                } else {
//                    showToast(data.message || 'Failed to add product to cart', 'error');
//                }
//            })
//            .catch(error => {
//                console.error('Error:', error);
//                showToast('Failed to add to cart: ' + error.message, 'error');
//            });
//        }

        
        function addToCart(productId) {
    if (!productId) {
        showToast('Invalid product ID', 'error');
        return;
    }

    // Thay đổi thành form data thay vì JSON
    const formData = new URLSearchParams();
    formData.append('action', 'add');
    formData.append('productId', productId);
    formData.append('quantity', 1);

    fetch('cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showToast('Product added to cart successfully');
            // Update cart badge
            const badge = document.querySelector('.cart-badge');
            if (badge) {
                badge.textContent = data.cartCount;
                badge.style.display = 'flex';
            }
        } else {
            showToast(data.message || 'Failed to add product to cart', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Failed to add to cart: ' + error.message, 'error');
    });
}

        function updateCartCount(count) {
            const cartBadge = document.querySelector('.cart-badge');
            if (cartBadge) {
                cartBadge.textContent = count;
                cartBadge.style.display = count > 0 ? 'inline' : 'none';
            }
        }

        function editProduct(productId) {
            window.location.href = 'admin/products/edit?id=' + productId;
        }

        function deleteProduct(productId) {
            if (confirm('Are you sure you want to delete this product?')) {
                fetch('admin/products/delete?id=' + productId, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.error || 'Failed to delete product');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to delete product');
                });
            }
        }
    </script>
</body>
</html>
