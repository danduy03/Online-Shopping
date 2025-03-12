<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="bg-dark text-white mt-5">
    <div class="container py-5">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="mb-4">About Us</h5>
                <p class="mb-4">We are dedicated to providing the best tech products at competitive prices. Our commitment to quality and customer service sets us apart.</p>
                <div class="social-links">
                    <a href="#" class="text-white me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <h5 class="mb-4">Quick Links</h5>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/products" class="text-white text-decoration-none">
                            <i class="fas fa-chevron-right me-2"></i>Products
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/about" class="text-white text-decoration-none">
                            <i class="fas fa-chevron-right me-2"></i>About Us
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/contact" class="text-white text-decoration-none">
                            <i class="fas fa-chevron-right me-2"></i>Contact Us
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/privacy" class="text-white text-decoration-none">
                            <i class="fas fa-chevron-right me-2"></i>Privacy Policy
                        </a>
                    </li>
                </ul>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <h5 class="mb-4">Contact Info</h5>
                <ul class="list-unstyled">
                    <li class="mb-3">
                        <i class="fas fa-map-marker-alt me-2"></i>
                        123 Tech Street, Silicon Valley, CA 94025
                    </li>
                    <li class="mb-3">
                        <i class="fas fa-phone me-2"></i>
                        <a href="tel:+1234567890" class="text-white text-decoration-none">+1 (234) 567-890</a>
                    </li>
                    <li class="mb-3">
                        <i class="fas fa-envelope me-2"></i>
                        <a href="mailto:contact@techstore.com" class="text-white text-decoration-none">contact@techstore.com</a>
                    </li>
                    <li>
                        <i class="fas fa-clock me-2"></i>
                        Mon - Fri: 9:00 AM - 6:00 PM
                    </li>
                </ul>
            </div>
        </div>
    </div>
    
    <div class="bottom-footer py-3 border-top border-secondary">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start">
                    <p class="mb-0">&copy; 2025 Tech Store. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-center text-md-end mt-3 mt-md-0">
                    <img src="https://via.placeholder.com/50x30" alt="Payment Method" class="me-2">
                    <img src="https://via.placeholder.com/50x30" alt="Payment Method" class="me-2">
                    <img src="https://via.placeholder.com/50x30" alt="Payment Method" class="me-2">
                    <img src="https://via.placeholder.com/50x30" alt="Payment Method">
                </div>
            </div>
        </div>
    </div>
</footer>

<style>
.bottom-footer {
    background: rgba(0, 0, 0, 0.2);
}

.social-links a {
    display: inline-block;
    width: 35px;
    height: 35px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    text-align: center;
    line-height: 35px;
    transition: all 0.3s ease;
}

.social-links a:hover {
    background: #0d6efd;
    transform: translateY(-3px);
}

footer a:hover {
    color: #0d6efd !important;
}
</style>

<!-- Bootstrap JS and dependencies -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
