<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .quantity-btn {
            padding: 5px 10px;
            border: 1px solid #dee2e6;
            background: #fff;
            cursor: pointer;
        }
        .quantity-btn:hover {
            background: #f8f9fa;
        }
        .quantity-input {
            width: 50px;
            text-align: center;
            border: 1px solid #dee2e6;
            padding: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/header.jsp" />

    <div class="container mt-4">
        <h2>Shopping Cart</h2>
        
        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="alert alert-info">
                    Your cart is empty. <a href="products">Continue shopping</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                                <th>Action</th>
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
                                    <td class="product-price">$${item.product.price}</td>
                                    <td>
                                        <div class="quantity-control">
                                            <button type="button" class="quantity-btn minus-btn" onclick="updateQuantity(${item.product.id}, -1, ${item.product.price})">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <input type="number" class="quantity-input" value="${item.quantity}" 
                                                   min="1" max="99" readonly data-price="${item.product.price}">
                                            <button type="button" class="quantity-btn plus-btn" onclick="updateQuantity(${item.product.id}, 1, ${item.product.price})">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </td>
                                    <td class="subtotal">$<fmt:formatNumber value="${item.product.price * item.quantity}" pattern="#,##0.00"/></td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-danger" onclick="removeFromCart(${item.product.id})">
                                            <i class="fas fa-trash"></i> Remove
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                <td id="cartTotal"><strong>$<fmt:formatNumber value="${total}" pattern="#,##0.00"/></strong></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <a href="products" class="btn btn-outline-primary">Continue Shopping</a>
                    <a href="checkout" class="btn btn-success">Proceed to Checkout</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function formatPrice(price) {
            return parseFloat(price).toFixed(2);
        }

        function updateQuantity(productId, change, price) {
            const row = document.querySelector(`tr[data-product-id="${productId}"]`);
            const quantityInput = row.querySelector('.quantity-input');
            const currentQuantity = parseInt(quantityInput.value);
            const newQuantity = currentQuantity + change;
            
            if (newQuantity >= 1 && newQuantity <= 99) {
                const xhr = new XMLHttpRequest();
                xhr.open('POST', 'cart', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                // Update quantity
                                quantityInput.value = newQuantity;
                                
                                // Update subtotal
                                const subtotal = price * newQuantity;
                                row.querySelector('.subtotal').textContent = '$' + formatPrice(subtotal);
                                
                                // Update total
                                document.getElementById('cartTotal').innerHTML = 
                                    '<strong>$' + formatPrice(response.total) + '</strong>';
                            }
                        } catch (e) {
                            console.error('Error parsing response:', e);
                        }
                    }
                };
                
                xhr.send(`action=update&productId=${productId}&quantity=${newQuantity}`);
            }
        }

        function removeFromCart(productId) {
            if (confirm('Are you sure you want to remove this item?')) {
                const xhr = new XMLHttpRequest();
                xhr.open('POST', 'cart', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                const row = document.querySelector(`tr[data-product-id="${productId}"]`);
                                row.remove();
                                
                                // Update total
                                document.getElementById('cartTotal').innerHTML = 
                                    '<strong>$' + formatPrice(response.total) + '</strong>';
                                
                                // If cart is empty, refresh the page
                                if (response.total === 0) {
                                    window.location.reload();
                                }
                            }
                        } catch (e) {
                            console.error('Error parsing response:', e);
                        }
                    }
                };
                
                xhr.send(`action=remove&productId=${productId}`);
            }
        }
    </script>
</body>
</html>
