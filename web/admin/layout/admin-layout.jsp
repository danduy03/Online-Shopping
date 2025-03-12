<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        
        .sidebar {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            width: 250px;
            z-index: 100;
            padding: 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            background-color: #2d3436;
            color: white;
        }
        
        .sidebar-header {
            padding: 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .sidebar-header h3 {
            margin: 0;
            font-size: 1.25rem;
        }
        
        .sidebar-menu {
            padding: 1rem 0;
        }
        
        .sidebar-menu a {
            display: block;
            padding: 0.75rem 1rem;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .sidebar-menu a:hover {
            background-color: rgba(255,255,255,0.1);
            color: white;
        }
        
        .sidebar-menu a i {
            margin-right: 0.5rem;
            width: 20px;
            text-align: center;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 2rem;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                margin-left: -250px;
            }
            .sidebar.show {
                margin-left: 0;
            }
            .main-content {
                margin-left: 0;
            }
        }
    </style>
    ${param.styles}
</head>
<body>
    <nav class="navbar navbar-dark bg-dark fixed-top flex-md-nowrap p-0">
        <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="${pageContext.request.contextPath}/admin">
            E-Shop Admin
        </a>
        <button class="navbar-toggler position-absolute d-md-none collapsed" type="button" 
                data-bs-toggle="collapse" data-bs-target="#sidebarMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="w-100"></div>
        <div class="navbar-nav">
            <div class="nav-item text-nowrap">
                <a class="nav-link px-3" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i> Sign Out
                </a>
            </div>
        </div>
    </nav>

    <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block sidebar collapse">
        <div class="sidebar-header">
            <h3>Admin Panel</h3>
        </div>
        <div class="sidebar-menu">
            <a href="/Ecomere/admin/dashboard" class="sidebar-link">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
            <a href="/Ecomere/admin/products" class="sidebar-link">
                <i class="fas fa-box"></i> Products
            </a>
            <a href="/Ecomere/admin/categories" class="sidebar-link">
                <i class="fas fa-tags"></i> Categories
            </a>
            <a href="/Ecomere/admin/orders" class="sidebar-link">
                <i class="fas fa-shopping-cart"></i> Orders
            </a>
            <a href="/Ecomere/admin/users" class="sidebar-link">
                <i class="fas fa-users"></i> Users
            </a>
            <a href="/Ecomere/admin/discounts" class="sidebar-link">
                <i class="fas fa-percent"></i> Discounts
            </a>
            <a href="/Ecomere/admin/marketing" class="sidebar-link">
                <i class="fas fa-bullhorn"></i> Marketing
            </a>
            <a href="/Ecomere/admin/articles" class="sidebar-link">
                <i class="fas fa-newspaper"></i> Articles
            </a>
        </div>
        <div class="sidebar-footer">
        </div>
    </nav>

    <main class="main-content">
        ${param.content}
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    ${param.scripts}
</body>
</html>
