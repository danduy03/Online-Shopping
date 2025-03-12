<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>TechStore - Premium Tech Shopping</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --secondary: #64748b;
            --accent: #dbeafe;
            --dark: #0f172a;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
        }

        /* Navbar Styles */
        .navbar {
            background: rgba(15, 23, 42, 0.98) !important;
            backdrop-filter: blur(10px);
            padding: 1rem 0;
        }

        .nav-link {
            color: #e2e8f0 !important;
            font-weight: 500;
            padding: 0.5rem 1rem !important;
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: var(--primary) !important;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: white !important;
        }

        /* Search Bar */
        .search-container {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 1rem 0;
        }

        .search-bar {
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }

        .search-bar input {
            width: 100%;
            padding: 1rem 1.5rem;
            border-radius: 9999px;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }

        .search-bar input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--accent);
            outline: none;
        }

        .search-bar button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            border-radius: 9999px;
            width: 45px;
            height: 45px;
            background: var(--primary);
            border: none;
            color: white;
            transition: background 0.3s ease;
        }

        .search-bar button:hover {
            background: var(--primary-dark);
        }

        /* Hero Banner */
        .hero-banner {
            height: 600px;
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        }

        .hero-slider {
            height: 100%;
            position: relative;
        }

        .hero-slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 1s ease;
        }

        .hero-slide.active {
            opacity: 1;
        }

        .hero-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: brightness(0.7);
        }

        .hero-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: white;
            width: 80%;
            max-width: 800px;
            z-index: 2;
        }

        .hero-content h1 {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-content p {
            font-size: 1.25rem;
            margin-bottom: 2rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
        }

        /* Categories */
        .category-section {
            padding: 5rem 0;
            background: white;
        }

        .category-card {
            border-radius: 20px;
            overflow: hidden;
            position: relative;
            height: 400px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .category-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
        }

        .category-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .category-card:hover img {
            transform: scale(1.1);
        }

        .category-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 2rem;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            color: white;
        }

        /* Featured Products */
        .featured-section {
            padding: 5rem 0;
            background: #f8fafc;
        }

        .product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
        }

        .product-card img {
            width: 100%;
            height: 250px;
            object-fit: cover;
        }

        .product-content {
            padding: 1.5rem;
        }

        /* Brands Section */
        .brands-section {
            padding: 5rem 0;
            background: white;
        }

        .brand-logo {
            height: 80px;
            object-fit: contain;
            filter: grayscale(1);
            opacity: 0.6;
            transition: all 0.3s ease;
        }

        .brand-logo:hover {
            filter: grayscale(0);
            opacity: 1;
        }

        /* Newsletter Section */
        .newsletter-section {
            padding: 5rem 0;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
        }

        .newsletter-form input {
            height: 60px;
            border-radius: 9999px;
            padding: 0 1.5rem;
            border: none;
            width: 100%;
            margin-bottom: 1rem;
        }

        .newsletter-form button {
            height: 60px;
            border-radius: 9999px;
            background: var(--dark);
            border: none;
            padding: 0 2rem;
            color: white;
            font-weight: 600;
            transition: background 0.3s ease;
        }

        .newsletter-form button:hover {
            background: black;
        }

        /* Footer */
        .footer {
            background: var(--dark);
            color: white;
            padding: 5rem 0 2rem;
        }

        .footer h5 {
            color: var(--primary);
            margin-bottom: 1.5rem;
            font-weight: 600;
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 0.75rem;
        }

        .footer-links a {
            color: #e2e8f0;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--primary);
        }

        .social-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255,255,255,0.1);
            color: white;
            margin-right: 1rem;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: var(--primary);
            transform: translateY(-3px);
        }

        /* Stats Section */
        .stats-section {
            padding: 5rem 0;
            background: #f8fafc;
        }

        .stat-card {
            text-align: center;
            padding: 2rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }

        .stat-card h3 {
            color: var(--primary);
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-card p {
            color: var(--secondary);
            font-weight: 500;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-laptop-code me-2"></i>TechStore
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/categories">Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/deals">Deals</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/articles">Blog</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart me-1"></i>Cart
                        </a>
                    </li>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-user me-1"></i>${sessionScope.user.username}
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                    <i class="fas fa-sign-in-alt me-1"></i>Login
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Search Bar -->
    <div class="search-container">
        <div class="container">
            <div class="search-bar">
                <input type="text" placeholder="Search for products..." aria-label="Search">
                <button type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Hero Banner -->
    <section class="hero-banner">
        <div class="hero-slider">
            <div class="hero-slide active">
                <img src="/api/placeholder/1920/600" alt="Tech Banner">
                <div class="hero-content">
                    <h1>Next-Gen Tech</h1>
                    <p>Discover the future of technology with our premium selection of devices and gadgets</p>
                    <a href="#featured" class="btn btn-light btn-lg">Shop Now</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="category-section">
        <div class="container">
            <h2 class="text-center fw-bold mb-5">Shop by Category</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="category-card">
                        <img src="/api/placeholder/400/600" alt="Smartphones">
                        <div class="category-overlay">
                            <h3 class="fw-bold mb-3">Smartphones</h3>
                            <p class="mb-3">Latest smartphones from top brands</p>
                            <a href="${pageContext.request.contextPath}/products?category=4" class="btn btn-light">Shop Now</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="category-card">
                        <img src="/api/placeholder/400/600" alt="Laptops">
                        <div class="category-overlay">
                            <h3 class="fw-bold mb-3">Laptops</h3>
                            <p class="mb-3">Powerful laptops for work and play</p>
                            <a href="${pageContext.request.contextPath}/products?category=3" class="btn btn-light">Shop Now</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="category-card">
                        <img src="/api/placeholder/400/600" alt="Gaming">
                        <div class="category-overlay">
                            <h3 class="fw-bold mb-3">Gaming</h3>
                            <p class="mb-3">Ultimate gaming gear and accessories</p>
                            <a href="${pageContext.request.contextPath}/products?category=5" class="btn btn-light">Shop Now</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Products Section -->
    <section class="featured-section" id="featured">
        <div class="container">
            <h2 class="text-center fw-bold mb-5">Featured Products</h2>
            <div class="row g-4">
                <c:forEach items="${featuredProducts}" var="product">
                    <div class="col-md-3">
                        <div class="product-card">
                            <img src="${product.imageUrl}" alt="${product.name}">
                            <div class="product-content">
                                <h5 class="fw-bold mb-2">${product.name}</h5>
                                <p class="text-muted mb-3">${product.description}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fw-bold text-primary">$${product.price}</span>
                                    <a href="${pageContext.request.contextPath}/cart/add/${product.id}" class="btn btn-primary">
                                        <i class="fas fa-cart-plus"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <h3>50K+</h3>
                        <p>Happy Customers</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h3>1000+</h3>
                        <p>Products</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h3>24/7</h3>
                        <p>Support</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h3>100%</h3>
                        <p>Secure Payment</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Newsletter Section -->
    <section class="newsletter-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 text-center">
                    <h2 class="fw-bold mb-4">Stay Updated</h2>
                    <p class="mb-5">Subscribe to our newsletter for exclusive deals and tech news</p>
                    <form class="newsletter-form">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <input type="email" class="form-control" placeholder="Enter your email" required>
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn w-100">Subscribe</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <h5>About TechStore</h5>
                    <p class="text-muted">Your premium destination for the latest technology and gadgets. We provide high-quality products and exceptional customer service.</p>
                    <div class="social-links mt-4">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="col-md-2">
                    <h5>Quick Links</h5>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                        <li><a href="${pageContext.request.contextPath}/faq">FAQs</a></li>
                        <li><a href="${pageContext.request.contextPath}/shipping">Shipping</a></li>
                    </ul>
                </div>
                <div class="col-md-2">
                    <h5>Categories</h5>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/products?category=4">Smartphones</a></li>
                        <li><a href="${pageContext.request.contextPath}/products?category=3">Laptops</a></li>
                        <li><a href="${pageContext.request.contextPath}/products?category=5">Gaming</a></li>
                        <li><a href="${pageContext.request.contextPath}/products?category=6">Accessories</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Contact Info</h5>
                    <ul class="footer-links">
                        <li><i class="fas fa-map-marker-alt me-2"></i>123 Tech Street, Silicon Valley, CA</li>
                        <li><i class="fas fa-phone me-2"></i>(555) 123-4567</li>
                        <li><i class="fas fa-envelope me-2"></i>support@techstore.com</li>
                    </ul>
                </div>
            </div>
            <div class="border-top border-secondary mt-5 pt-4">
                <div class="row">
                    <div class="col-md-6">
                        <p class="small text-muted"> 2025 TechStore. All rights reserved.</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <a href="${pageContext.request.contextPath}/privacy" class="text-muted small me-3">Privacy Policy</a>
                        <a href="${pageContext.request.contextPath}/terms" class="text-muted small">Terms of Service</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>