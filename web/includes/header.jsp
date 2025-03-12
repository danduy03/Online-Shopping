<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .banner {
        height: 200px;
        overflow: hidden;
        position: relative;
        margin-bottom: 0;
    }

    .banner-slider {
        display: flex;
        height: 100%;
        animation: slideImages 30s linear infinite;
    }

    .banner-slide {
        min-width: 100%;
        height: 100%;
        position: relative;
    }

    .banner-slide img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .banner-content {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        text-align: center;
        color: white;
        z-index: 2;
        width: 80%;
    }

    .banner-content h1 {
        font-size: 3rem;
        margin-bottom: 1rem;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
    }

    .banner-content p {
        font-size: 1.2rem;
        margin-bottom: 2rem;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
    }

    .banner-overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0,0,0,0.4);
        z-index: 1;
    }

    @keyframes slideImages {
        0% {
            transform: translateX(0);
        }
        33.33% {
            transform: translateX(-100%);
        }
        66.66% {
            transform: translateX(-200%);
        }
        100% {
            transform: translateX(-300%);
        }
    }

    .navbar {
        background: rgba(33, 37, 41, 0.95) !important;
    }

    .search-container {
        background: white;
        padding: 15px 0;
        border-bottom: 1px solid #eee;
    }

    .search-bar {
        max-width: 600px;
        margin: 0 auto;
        display: flex;
        align-items: center;
    }

    .search-bar input {
        height: 45px;
        border-radius: 25px;
        border: 1px solid #ddd;
        padding: 0 25px;
        font-size: 15px;
        width: 100%;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }

    .search-bar button {
        height: 45px;
        width: 45px;
        border-radius: 50%;
        margin-left: 10px;
        padding: 0;
        display: flex;
        align-items: center;
        justify-content: center;
    }
</style>

<%
    String currentPage = request.getRequestURI();
    boolean isHomePage = currentPage.endsWith("index.jsp") || currentPage.equals(request.getContextPath() + "/");
%>

<% if (isHomePage) { %>
<!-- Banner Section -->
<div class="banner">
    <div class="banner-overlay"></div>
    <div class="banner-slider">
        <!-- Default Banner -->
        <div class="banner-slide">
            <img src="https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=2071&auto=format&fit=crop" alt="Tech Banner">
            <div class="banner-content">
                <h1>Welcome to E-Shop</h1>
                <p>Discover the latest in technology and electronics</p>
            </div>
        </div>

        <!-- Category-specific banners -->
        <c:if test="${not empty param.category}">
            <c:choose>
                <c:when test="${param.category eq '1'}"> <!-- Audio -->
                    <div class="banner-slide">
                        <img src="https://images.unsplash.com/photo-1546435770-a3e426bf472b?q=80&w=2065&auto=format&fit=crop" alt="Audio Banner">
                        <div class="banner-content">
                            <h1>Premium Audio</h1>
                            <p>Experience sound like never before</p>
                        </div>
                    </div>
                </c:when>
                <c:when test="${param.category eq '2'}"> <!-- Gaming -->
                    <div class="banner-slide">
                        <img src="https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070&auto=format&fit=crop" alt="Gaming Banner">
                        <div class="banner-content">
                            <h1>Gaming Zone</h1>
                            <p>Level up your gaming experience</p>
                        </div>
                    </div>
                </c:when>
                <c:when test="${param.category eq '3'}"> <!-- Laptops -->
                    <div class="banner-slide">
                        <img src="https://images.unsplash.com/photo-1516387938699-a93567ec168e?q=80&w=2071&auto=format&fit=crop" alt="Laptops Banner">
                        <div class="banner-content">
                            <h1>Professional Laptops</h1>
                            <p>Power and portability in perfect harmony</p>
                        </div>
                    </div>
                </c:when>
                <c:when test="${param.category eq '4'}"> <!-- Smartphones -->
                    <div class="banner-slide">
                        <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=2080&auto=format&fit=crop" alt="Smartphones Banner">
                        <div class="banner-content">
                            <h1>Smart Phones</h1>
                            <p>Stay connected with the latest technology</p>
                        </div>
                    </div>
                </c:when>
                <c:when test="${param.category eq '5'}"> <!-- TVs -->
                    <div class="banner-slide">
                        <img src="https://images.unsplash.com/photo-1593784991095-a205069470b6?q=80&w=2070&auto=format&fit=crop" alt="TVs Banner">
                        <div class="banner-content">
                            <h1>Smart TVs</h1>
                            <p>Immerse yourself in stunning visuals</p>
                        </div>
                    </div>
                </c:when>
            </c:choose>
        </c:if>
    </div>
</div>
<% } %>

<!-- Navigation -->
<header class="bg-dark text-white">
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/products">E-commerce Store</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">Cart</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/orders">Orders</a>
                    </li>
                    <c:if test="${not empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/orders">My Orders</a>
                        </li>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart"></i> Cart
                            <span class="badge bg-primary">${cartSize}</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/feedback">
                            <i class="fas fa-comments"></i> Feedback & Support
                        </a>
                    </li>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-user"></i> ${sessionScope.user.username}
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">
                                    <i class="fas fa-sign-in-alt"></i> Login
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
</header>
