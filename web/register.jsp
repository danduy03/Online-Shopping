<!DOCTYPE html>
<html>
<head>
    <title>Register - E-commerce Store</title>
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

        .register-container {
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

        .password-requirements {
            background-color: #f8fafc;
            padding: 1rem;
            border-radius: 12px;
            margin-top: 1rem;
        }

        .requirement-item {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }

        .requirement-item i {
            margin-right: 0.5rem;
            font-size: 0.75rem;
        }

        .requirement-item.valid {
            color: var(--success-color);
        }

        .requirement-item.valid i {
            color: var(--success-color);
        }

        .requirement-item.invalid {
            color: #64748b;
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

        .form-check-label {
            font-size: 0.875rem;
            color: #4b5563;
        }

        .alert {
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border: none;
            background-color: #fee2e2;
            color: var(--error-color);
        }

        .alert i {
            color: var(--error-color);
        }

        @media (max-width: 768px) {
            .card-body {
                padding: 1.5rem;
            }
            
            .register-container {
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

    <div class="register-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="text-center mb-0">Create Your Account</h3>
                        </div>
                        <div class="card-body">
                            <% if(request.getAttribute("error") != null) { %>
                                <div class="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    <%= request.getAttribute("error") %>
                                </div>
                            <% } %>
                            
                            <form action="register" method="post" class="needs-validation" novalidate>
                                <div class="row">
                                    <div class="col-md-6 mb-4">
                                        <label for="firstName" class="form-label">First Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-user"></i>
                                            </span>
                                            <input type="text" class="form-control" id="firstName" 
                                                   name="first_name" placeholder="John" required>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6 mb-4">
                                        <label for="lastName" class="form-label">Last Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fas fa-user"></i>
                                            </span>
                                            <input type="text" class="form-control" id="lastName" 
                                                   name="last_name" placeholder="Doe" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="username" class="form-label">Username</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-at"></i>
                                        </span>
                                        <input type="text" class="form-control" id="username" name="username" 
                                               placeholder="johndoe123" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="email" class="form-label">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-envelope"></i>
                                        </span>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               placeholder="john@example.com" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="password" class="form-label">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                        <input type="password" class="form-control" id="password" name="password" 
                                               required>
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="password-requirements">
                                        <div class="requirement-item" id="length-check">
                                            <i class="fas fa-circle"></i>
                                            At least 8 characters
                                        </div>
                                        <div class="requirement-item" id="number-check">
                                            <i class="fas fa-circle"></i>
                                            Contains a number
                                        </div>
                                        <div class="requirement-item" id="case-check">
                                            <i class="fas fa-circle"></i>
                                            Contains uppercase & lowercase letters
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                        <input type="password" class="form-control" id="confirmPassword" 
                                               name="confirm_password" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="terms" required>
                                        <label class="form-check-label" for="terms">
                                            I agree to the <a href="#" class="text-primary">Terms of Service</a> and 
                                            <a href="#" class="text-primary">Privacy Policy</a>
                                        </label>
                                    </div>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-user-plus me-2"></i>Create Account
                                    </button>
                                </div>
                            </form>
                            
                            <div class="text-center mt-4">
                                <p class="mb-0">Already have an account? 
                                    <a href="login.jsp" class="text-primary fw-bold">Sign in</a>
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
            const lengthCheck = document.getElementById('length-check');
            const numberCheck = document.getElementById('number-check');
            const caseCheck = document.getElementById('case-check');

            // Toggle password visibility
            togglePassword.addEventListener('click', function() {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                this.querySelector('i').classList.toggle('fa-eye');
                this.querySelector('i').classList.toggle('fa-eye-slash');
            });

            function validatePassword(value) {
                // Check length
                if(value.length >= 8) {
                    lengthCheck.classList.remove('invalid');
                    lengthCheck.classList.add('valid');
                } else {
                    lengthCheck.classList.remove('valid');
                    lengthCheck.classList.add('invalid');
                }

                // Check for numbers
                if(/\d/.test(value)) {
                    numberCheck.classList.remove('invalid');
                    numberCheck.classList.add('valid');
                } else {
                    numberCheck.classList.remove('valid');
                    numberCheck.classList.add('invalid');
                }

                // Check for case
                if(/[a-z]/.test(value) && /[A-Z]/.test(value)) {
                    caseCheck.classList.remove('invalid');
                    caseCheck.classList.add('valid');
                } else {
                    caseCheck.classList.remove('valid');
                    caseCheck.classList.add('invalid');
                }
            }

            // Initialize requirement states
            document.querySelectorAll('.requirement-item').forEach(item => {
                item.classList.add('invalid');
            });

            // Monitor password input
            password.addEventListener('input', function(e) {
                validatePassword(e.target.value);
            });

            // Form validation
            const form = document.querySelector('form');
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            });
        });
    </script>
</body>
</html>