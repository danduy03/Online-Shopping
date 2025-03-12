<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
         /* Loại bỏ mũi tên spinners cho tất cả các trình duyệt */
    /* Chrome, Safari, Edge, Opera */
    input[type="number"]::-webkit-outer-spin-button,
    input[type="number"]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }

    /* Firefox */
    input[type="number"] {
        -moz-appearance: textfield;
        appearance: textfield;
    }
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
    </style>
</head>
<body>
    <div class="toast-container"></div>
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
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
                        <a class="nav-link" href="products">Products</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link active" href="cart">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="badge bg-danger cart-badge">${sessionScope.cartCount}</span>
                        </a>
                    </li>
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <li class="nav-item">
                                <a class="nav-link" href="profile.jsp">Profile</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="logout">Logout</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="login.jsp">Login</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2>Shopping Cart</h2>
        
        <c:if test="${empty cartItems}">
            <div class="alert alert-info">
                Your cart is empty. <a href="products">Continue shopping</a>
            </div>
        </c:if>
        
        <c:if test="${not empty cartItems}">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${cartItems}">
                            <tr data-product-id="${item.product.id}">
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${item.product.imageUrl}" alt="${item.product.name}" 
                                             style="width: 50px; height: 50px; object-fit: cover; margin-right: 10px;">
                                        <span>${item.product.name}</span>
                                    </div>
                                </td>
                                <td class="price" data-price="${item.product.price}">
                                    $<fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/>
                                </td>
                                <td>
                                    <div class="quantity-control">
                                        <button class="btn btn-sm btn-outline-secondary decrease-qty" 
                                                onclick="updateQuantity(${item.product.id}, -1)">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input type="number" class="form-control quantity-input" 
                                               value="${item.quantity}" min="1"
                                               onchange="updateQuantity(${item.product.id}, 0)">
                                        <button class="btn btn-sm btn-outline-secondary increase-qty" 
                                                onclick="updateQuantity(${item.product.id}, 1)">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </div>
                                </td>
                                <td class="subtotal">
                                    $<fmt:formatNumber value="${item.product.price * item.quantity}" pattern="#,##0.00"/>
                                </td>
                                <td>
                                    <button class="btn btn-danger btn-sm remove-item" 
                                            onclick="removeFromCart(${item.product.id})">
                                        <i class="fas fa-trash"></i> Remove
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" class="text-end"><strong>Total:</strong></td>
                            <td id="total">
                                <strong>$<fmt:formatNumber value="${total}" pattern="#,##0.00"/></strong>
                            </td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
            
            <div class="d-flex justify-content-between mt-4">
                <a href="products" class="btn btn-secondary">Continue Shopping</a>
                <a href="checkout" class="btn btn-primary">Proceed to Checkout</a>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
function removeFromCart(productId) {
    fetch('cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=remove&productId=' + productId
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
        if (data.success) {
            var row = document.querySelector('tr[data-product-id="' + productId + '"]');
            if (row) {
                row.remove();
            }
            updateCartBadge(data.cartCount);
            updateTotal(data.total);
            
            // Refresh if cart is empty
            if (document.querySelectorAll('tr[data-product-id]').length === 0) {
                location.reload();
            }
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
    });
}

function updateQuantity(productId, change) {
    var row = document.querySelector('tr[data-product-id="' + productId + '"]');
    var quantityInput = row.querySelector('.quantity-input');
    var newQuantity;
    
    if (change === 0) {
        // Direct input change
        newQuantity = parseInt(quantityInput.value) || 1;
    } else {
        // Button click
        newQuantity = parseInt(quantityInput.value) + change;
    }
    
    // Ensure minimum quantity is 1
    newQuantity = Math.max(1, newQuantity);
    quantityInput.value = newQuantity;
    
    fetch('cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=update&productId=' + productId + '&quantity=' + newQuantity
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
        if (data.success) {
            updateSubtotal(productId);
            updateTotal(data.total);
            updateCartBadge(data.cartCount);
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
    });
}

function updateSubtotal(productId) {
    var row = document.querySelector('tr[data-product-id="' + productId + '"]');
    var priceElement = row.querySelector('.price');
    var quantityInput = row.querySelector('.quantity-input');
    var subtotalElement = row.querySelector('.subtotal');
    
    var price = parseFloat(priceElement.getAttribute('data-price'));
    var quantity = parseInt(quantityInput.value);
    var subtotal = price * quantity;
    
    subtotalElement.textContent = '$' + subtotal.toFixed(2);
}

function updateTotal(newTotal) {
    var totalElement = document.querySelector('#total strong');
    if (totalElement) {
        totalElement.textContent = '$' + parseFloat(newTotal).toFixed(2);
    }
}

function updateCartBadge(count) {
    var badge = document.querySelector('.cart-badge');
    if (badge) {
        badge.textContent = count;
        badge.style.display = count > 0 ? 'inline' : 'none';
    }
}

// Add event listener for quantity inputs to only allow numbers
document.querySelectorAll('.quantity-input').forEach(function(input) {
    input.addEventListener('input', function(e) {
        this.value = this.value.replace(/[^0-9]/g, '');
        if (this.value === '' || this.value === '0') {
            this.value = '1';
        }
    });
});
</script>
</body>
</html>