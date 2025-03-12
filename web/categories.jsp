<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Categories - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
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
                    <li class="nav-item">
                        <a class="nav-link active" href="categories">Categories</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="cart">Cart</a>
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
                            <li class="nav-item">
                                <a class="nav-link" href="register.jsp">Register</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <!-- Categories Sidebar -->
            <div class="col-md-3">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Categories</h5>
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="categories" class="list-group-item list-group-item-action 
                            ${empty selectedCategory ? 'active' : ''}">
                            All Categories
                        </a>
                        <c:forEach var="category" items="${categories}">
                            <a href="categories?id=${category.id}" 
                               class="list-group-item list-group-item-action
                               ${selectedCategory.id == category.id ? 'active' : ''}">
                                ${category.name}
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="col-md-9">
                <c:if test="${selectedCategory != null}">
                    <h2 class="mb-4">${selectedCategory.name}</h2>
                    <p class="text-muted mb-4">${selectedCategory.description}</p>
                </c:if>

                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:forEach var="product" items="${products}">
                        <div class="col">
                            <div class="card h-100">
                                <img src="${product.imageUrl}" class="card-img-top" alt="${product.name}">
                                <div class="card-body">
                                    <h5 class="card-title">${product.name}</h5>
                                    <p class="card-text">${product.description}</p>
                                    <p class="card-text"><strong>Price: $${product.price}</strong></p>
                                    <c:if test="${product.stockQuantity > 0}">
                                        <form action="cart" method="post">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <button type="submit" class="btn btn-primary">Add to Cart</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${product.stockQuantity <= 0}">
                                        <button class="btn btn-secondary" disabled>Out of Stock</button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty products}">
                    <div class="alert alert-info mt-4">
                        No products found in this category.
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
