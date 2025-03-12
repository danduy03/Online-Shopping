<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Feedback - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .feedback-form {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .form-control, .form-select {
            border-radius: 8px;
            padding: 12px;
            border: 1px solid #ddd;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #4CAF50;
            box-shadow: 0 0 0 0.2rem rgba(76, 175, 80, 0.25);
        }
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        .btn-submit {
            background: #4CAF50;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            width: 100%;
            font-size: 16px;
            transition: all 0.3s;
        }
        .btn-submit:hover {
            background: #45a049;
            transform: translateY(-2px);
        }
        .form-header {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        .form-header h2 {
            font-weight: 700;
            margin-bottom: 15px;
            color: #2c3e50;
        }
        .form-header p {
            color: #666;
            font-size: 1.1em;
        }
        .file-upload {
            border: 2px dashed #ddd;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            background: #f8f9fa;
        }
        .file-upload:hover {
            border-color: #4CAF50;
            background: #f1f8f1;
        }
        .nav-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .btn-nav {
            padding: 8px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-nav:hover {
            transform: translateY(-2px);
        }
        .btn-home {
            background-color: #f8f9fa;
            color: #2c3e50;
            border: 1px solid #dee2e6;
        }
        .btn-home:hover {
            background-color: #e9ecef;
        }
        .btn-history {
            background-color: #e3f2fd;
            color: #1976d2;
            border: 1px solid #bbdefb;
        }
        .btn-history:hover {
            background-color: #bbdefb;
        }
        .help-text {
            font-size: 0.9em;
            color: #666;
            margin-top: 5px;
        }
        .loading-overlay {
            background: rgba(255,255,255,0.8);
            z-index: 1050;
        }
        
        .btn-submit:disabled {
            background: #45a049;
            cursor: not-allowed;
        }

        /* Enhanced Alert Styles */
        #alertMessage {
            margin: 0;
            padding: 1.25rem;
            border-radius: 12px;
            font-size: 1.1em;
            display: flex;
            align-items: center;
            gap: 15px;
            transform: translateY(-20px);
            opacity: 0;
            transition: all 0.5s ease;
            border: none;
            position: relative;
            margin-bottom: 30px;
        }

        .alert-container {
            position: relative;
            width: 100%;
            margin-bottom: 30px;
        }

        #alertMessage.show {
            transform: translateY(0);
            opacity: 1;
        }

        #alertMessage .message-content {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-grow: 1;
        }

        #alertMessage .message-text {
            font-weight: 500;
            margin-right: 20px;
        }

        #alertMessage .fas {
            font-size: 1.5em;
            min-width: 24px;
            text-align: center;
        }

        #alertMessage.alert-success {
            background-color: #e8f5e9;
            color: #1b5e20;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.2);
        }

        #alertMessage.alert-danger {
            background-color: #fbe9e7;
            color: #c62828;
            box-shadow: 0 4px 15px rgba(239, 83, 80, 0.2);
        }

        #alertMessage .btn-close {
            padding: 1.25rem;
            position: absolute;
            right: 0;
            top: 0;
            bottom: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background: none;
            border: none;
            transition: all 0.3s ease;
            cursor: pointer;
            opacity: 0.6;
        }

        #alertMessage .btn-close:hover {
            opacity: 1;
        }

        #alertMessage .btn-close::before {
            content: '×';
            font-size: 1.5em;
            line-height: 1;
        }

        #alertMessage.alert-success .fas {
            color: #43a047;
        }

        #alertMessage.alert-danger .fas {
            color: #e53935;
        }

        .validation-message {
            color: #dc3545;
            font-size: 0.9em;
            margin-top: 5px;
            display: none;
        }

        .validation-message.show {
            display: block;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-10px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="feedback-form">
            <div class="nav-buttons">
                <a href="${pageContext.request.contextPath}/home" class="btn-nav btn-home">
                    <i class="fas fa-home"></i>Back to Home
                </a>
                <a href="${pageContext.request.contextPath}/feedback?action=history" class="btn-nav btn-history">
                    <i class="fas fa-history"></i>View History
                </a>
            </div>
            
            <!-- Enhanced Alert Messages -->
            <div class="alert-container">
                <div id="alertMessage" class="alert d-none alert-dismissible fade" role="alert">
                    <div class="message-content">
                        <i class="fas"></i>
                        <span class="message-text"></span>
                    </div>
                    <button type="button" class="btn-close" aria-label="Close"></button>
                </div>
            </div>

            <div class="form-header">
                <h2><i class="fas fa-comment-dots me-2"></i>Submit Feedback</h2>
                <p>We value your feedback and are committed to improving your experience</p>
            </div>

            <form id="feedbackForm" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="submit">
                
                <div class="mb-4">
                    <label for="feedbackType" class="form-label">Type of Feedback</label>
                    <select class="form-select" id="feedbackType" name="type" required>
                        <option value="">Select feedback type</option>
                        <option value="General Feedback">General Feedback</option>
                        <option value="Bug Report">Bug Report</option>
                        <option value="Feature Request">Feature Request</option>
                        <option value="Support Request">Support Request</option>
                    </select>
                    <div class="invalid-feedback">Please select a feedback type.</div>
                </div>

                <div class="mb-4">
                    <label for="subject" class="form-label">Subject</label>
                    <input type="text" class="form-control" id="subject" name="subject" required minlength="5" maxlength="100">
                    <div class="invalid-feedback">Please provide a subject (minimum 5 characters).</div>
                </div>

                <div class="mb-4">
                    <label for="description" class="form-label">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="5" required minlength="10"></textarea>
                    <div class="invalid-feedback">Please provide a detailed description (minimum 10 characters).</div>
                </div>

                <div class="mb-4">
                    <label for="priority" class="form-label">Priority</label>
                    <select class="form-select" id="priority" name="priority" required>
                        <option value="">Select priority</option>
                        <option value="Low">Low</option>
                        <option value="Medium">Medium</option>
                        <option value="High">High</option>
                    </select>
                    <div class="invalid-feedback">Please select a priority level.</div>
                </div>

                <div class="mb-4">
                    <label for="attachment" class="form-label">Attachment (Optional)</label>
                    <div class="file-upload">
                        <input type="file" class="form-control" id="attachment" name="attachment" accept=".jpg,.jpeg,.png,.pdf,.doc,.docx">
                        <p class="help-text mt-2">Supported formats: Images (JPG, PNG), Documents (PDF, DOC, DOCX)</p>
                    </div>
                </div>

                <button type="submit" class="btn btn-submit" id="submitButton">
                    <span class="normal-state">
                        <i class="fas fa-paper-plane me-2"></i>Submit Feedback
                    </span>
                    <span class="loading-state d-none">
                        <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                        Submitting...
                    </span>
                </button>
            </form>

            <!-- Loading Overlay -->
            <div id="loadingOverlay" class="position-fixed top-0 start-0 w-100 h-100 d-none">
                <div class="position-absolute top-50 start-50 translate-middle text-center">
                    <div class="spinner-border text-primary mb-2" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <div>Processing your feedback...</div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Store the context path for use in JavaScript
        const contextPath = '<%=request.getContextPath()%>';
        
        // Enhanced function to show alert messages
        function showAlert(message, type) {
            const alertElement = document.getElementById('alertMessage');
            const messageText = alertElement.querySelector('.message-text');
            const icon = alertElement.querySelector('.fas');
            
            // Remove existing classes
            alertElement.classList.remove('d-none', 'alert-success', 'alert-danger');
            
            // Set icon and class based on alert type
            if (type === 'success') {
                icon.classList.add('fa-check-circle');
                alertElement.classList.add('alert-success');
            } else {
                icon.classList.add('fa-exclamation-circle');
                alertElement.classList.add('alert-danger');
            }
            
            // Set message
            messageText.textContent = message;
            
            // Show alert with animation
            setTimeout(() => {
                alertElement.classList.add('show');
                // Smooth scroll to alert
                window.scrollTo({
                    top: alertElement.offsetTop - 100,
                    behavior: 'smooth'
                });
            }, 100);
            
            // Auto hide after 5 seconds
            setTimeout(() => {
                if (alertElement.classList.contains('show')) {
                    alertElement.classList.remove('show');
                    setTimeout(() => {
                        alertElement.classList.add('d-none');
                    }, 500);
                }
            }, 5000);
        }

        document.getElementById('feedbackForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            console.log('Form submission started');

            // Scroll to top of form first
            window.scrollTo({
                top: document.querySelector('.feedback-form').offsetTop - 50,
                behavior: 'smooth'
            });

            // Form validation
            if (!this.checkValidity()) {
                e.stopPropagation();
                this.classList.add('was-validated');
                showAlert('Please fill in all required fields correctly.', 'danger');
                return;
            }

            const submitButton = document.getElementById('submitButton');
            const loadingOverlay = document.getElementById('loadingOverlay');
            const normalState = submitButton.querySelector('.normal-state');
            const loadingState = submitButton.querySelector('.loading-state');

            try {
                // Show loading state
                submitButton.disabled = true;
                normalState.classList.add('d-none');
                loadingState.classList.remove('d-none');
                loadingOverlay.classList.remove('d-none');

                const formData = new FormData(this);
                
                // Log form data for debugging
                for (let pair of formData.entries()) {
                    console.log(pair[0] + ': ' + pair[1]);
                }

                console.log('Sending request to:', contextPath + '/feedback');
                
                const response = await fetch(contextPath + '/feedback', {
                    method: 'POST',
                    body: formData
                });

                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers);

                const contentType = response.headers.get('content-type');
                console.log('Content-Type:', contentType);

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                let result;
                try {
                    const text = await response.text();
                    console.log('Raw response:', text);
                    result = JSON.parse(text);
                } catch (e) {
                    console.error('Error parsing response:', e);
                    throw new Error('Invalid response from server');
                }

                console.log('Parsed result:', result);

                if (result.success) {
                    showAlert(result.message || 'Feedback submitted successfully!', 'success');
                    this.reset();
                    this.classList.remove('was-validated');
                    
                    // Redirect to feedback list if specified
                    if (result.redirect) {
                        window.location.href = contextPath + '/' + result.redirect;
                    }
                } else {
                    if (result.redirect) {
                        // If not logged in, redirect to login page
                        window.location.href = contextPath + '/' + result.redirect;
                    } else {
                        throw new Error(result.message || 'Failed to submit feedback');
                    }
                }
            } catch (error) {
                console.error('Error:', error);
                showAlert(error.message || 'An error occurred while submitting feedback. Please try again.', 'danger');
            } finally {
                // Hide loading states
                submitButton.disabled = false;
                normalState.classList.remove('d-none');
                loadingState.classList.add('d-none');
                loadingOverlay.classList.add('d-none');
            }
        });

        // Real-time validation feedback
        const inputs = document.querySelectorAll('input[required], select[required], textarea[required]');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                if (this.checkValidity()) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                }
            });
        });
    </script>
</body>
</html>