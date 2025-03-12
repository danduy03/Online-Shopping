<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .forgot-password-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 20px 0;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
            border-radius: 15px 15px 0 0 !important;
            padding: 25px;
            border: none;
        }
        .card-header h3 {
            color: white;
            margin: 0;
            font-weight: 600;
        }
        .card-body {
            padding: 30px;
        }
        .instruction-text {
            color: #6c757d;
            font-size: 15px;
            text-align: center;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        .form-control {
            padding: 12px;
            border-radius: 8px;
        }
        .form-control:focus {
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.15);
        }
        .btn-primary {
            padding: 12px;
            border-radius: 8px;
            font-weight: 500;
            background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
            border: none;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
        }
        .alert {
            border: none;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .alert-danger {
            background-color: #fff2f2;
            color: #dc3545;
        }
        .alert-success {
            background-color: #f0fff4;
            color: #198754;
        }
        .back-to-login {
            color: #6c757d;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        .back-to-login:hover {
            color: #0d6efd;
        }
        .input-group-text {
            background-color: #f8f9fa;
            border-right: none;
        }
        .input-group .form-control {
            border-left: none;
        }
        .input-group .form-control:focus {
            border-left: none;
            border-color: #dee2e6;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <i class="fas fa-shopping-cart me-2"></i>E-Shop
            </a>
        </div>
    </nav>

    <div class="forgot-password-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-5">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="text-center">Reset Password</h3>
                        </div>
                        <div class="card-body">
                            <% if(request.getAttribute("error") != null) { %>
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    <%= request.getAttribute("error") %>
                                </div>
                            <% } %>
                            <% if(request.getAttribute("success") != null) { %>
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <%= request.getAttribute("success") %>
                                </div>
                            <% } %>

                            <div class="instruction-text">
                                <i class="fas fa-envelope-open-text mb-3 d-block" style="font-size: 2rem; color: #0d6efd;"></i>
                                Enter your email address and we'll send you instructions to reset your password.
                            </div>

                            <form action="forgot-password" method="post">
                                <div class="mb-4">
                                    <label for="email" class="form-label">Email address</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-envelope"></i>
                                        </span>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               placeholder="Enter your registered email" required>
                                    </div>
                                </div>
                                <div class="d-grid mb-4">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane me-2"></i>Send Reset Link
                                    </button>
                                </div>
                            </form>

                            <div class="text-center">
                                <a href="login.jsp" class="back-to-login">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Login
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>