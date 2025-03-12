<!DOCTYPE html>
<html>
<head>
    <title>Login - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #3b82f6;
            --success-color: #10b981;
            --error-color: #ef4444;
        }

        body {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            min-height: 100vh;
        }

        .navbar {
            background: rgba(17, 24, 39, 0.95) !important;
            backdrop-filter: blur(10px);
        }

        .login-container {
            min-height: calc(100vh - 56px);
            display: flex;
            align-items: center;
            padding: 2rem 0;
        }

        .card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border-radius: 20px 20px 0 0 !important;
            padding: 2rem;
            border: none;
        }

        .card-header h3 {
            color: white;
            font-weight: 700;
            font-size: 1.75rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .card-body {
            padding: 2.5rem;
        }

        .social-login-btn {
            width: 100%;
            padding: 0.875rem;
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: 500;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .social-login-btn i {
            font-size: 1.25rem;
        }

        .btn-google {
            background-color: #ea4335;
        }

        .btn-facebook {
            background-color: #1877f2;
        }

        .btn-apple {
            background-color: #000000;
        }

        .btn-microsoft {
            background-color: #05a6f0;
        }

        .social-login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            color: white;
            opacity: 0.95;
        }

        .divider {
            margin: 2rem 0;
            text-align: center;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .divider:before,
        .divider:after {
            content: "";
            flex: 1;
            height: 1px;
            background: linear-gradient(to right, transparent, #e5e7eb, transparent);
        }

        .divider span {
            color: #6b7280;
            font-size: 0.875rem;
            padding: 0 1rem;
            background: white;
        }

        .form-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .input-group {
            margin-bottom: 0.5rem;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .input-group-text {
            background-color: #f3f4f6;
            border: 1px solid #e5e7eb;
            border-right: none;
            padding: 0.75rem;
        }

        .form-control {
            padding: 0.75rem;
            border: 1px solid #e5e7eb;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .forgot-password {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.875rem;
            transition: color 0.3s ease;
        }

        .forgot-password:hover {
            color: var(--secondary-color);
            text-decoration: underline;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            padding: 1rem;
            font-weight: 600;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        .alert-danger {
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border: none;
            background-color: #fee2e2;
            color: var(--error-color);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        @media (max-width: 768px) {
            .card-body {
                padding: 1.5rem;
            }
            
            .login-container {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <i class="fas fa-shopping-cart me-2"></i>E-Shop
            </a>
        </div>
    </nav>

    <div class="login-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-7">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="text-center mb-0">Welcome Back</h3>
                        </div>
                        <div class="card-body">
                            <%
                            String error = (String) request.getAttribute("error");
                            if (error != null && !error.isEmpty()) {
                            %>
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <%= error %>
                                </div>
                            <%
                            }
                            %>
                            
                            <button onclick="window.location.href='login/google'" class="social-login-btn btn-google">
                                <i class="fab fa-google"></i>Continue with Google
                            </button>
                            <button onclick="window.location.href='<%= utils.OAuth2Utils.getAuthorizationUrl("facebook") %>'" class="social-login-btn btn-facebook">
                                <i class="fab fa-facebook-f"></i>Continue with Facebook
                            </button>
                            <button onclick="window.location.href='<%= utils.OAuth2Utils.getAuthorizationUrl("apple") %>'" class="social-login-btn btn-apple">
                                <i class="fab fa-apple"></i>Continue with Apple
                            </button>
                            <button onclick="window.location.href='<%= utils.OAuth2Utils.getAuthorizationUrl("microsoft") %>'" class="social-login-btn btn-microsoft">
                                <i class="fab fa-microsoft"></i>Continue with Microsoft
                            </button>

                            <div class="divider">
                                <span>or sign in with email</span>
                            </div>

                            <form action="login" method="post">
                                <div class="mb-4">
                                    <label for="username" class="form-label">Username</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-user"></i>
                                        </span>
                                        <input type="text" class="form-control" id="username" name="username" 
                                               placeholder="Enter your username" required>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label for="password" class="form-label">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                        <input type="password" class="form-control" id="password" name="password" 
                                               placeholder="Enter your password" required>
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="mb-4 d-flex justify-content-between align-items-center">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="remember" name="remember">
                                        <label class="form-check-label" for="remember">Remember me</label>
                                    </div>
                                    <a href="forgot-password.jsp" class="forgot-password">Forgot Password?</a>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-sign-in-alt me-2"></i>Sign In
                                    </button>
                                </div>
                            </form>
                            <div class="text-center mt-4">
                                <p class="mb-0">Don't have an account? 
                                    <a href="register.jsp" class="text-primary fw-bold">Register here</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const password = document.getElementById('password');
            const togglePassword = document.getElementById('togglePassword');
            
            // Toggle password visibility
            togglePassword.addEventListener('click', function() {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                this.querySelector('i').classList.toggle('fa-eye');
                this.querySelector('i').classList.toggle('fa-eye-slash');
            });

            // Handle return URL
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                const returnUrl = document.referrer;
                if (returnUrl && returnUrl.includes('products')) {
                    const hiddenInput = document.createElement('input');
                    hiddenInput.type = 'hidden';
                    hiddenInput.name = 'returnUrl';
                    hiddenInput.value = returnUrl;
                    form.appendChild(hiddenInput);
                }
            });
        });
    </script>
</body>
</html>