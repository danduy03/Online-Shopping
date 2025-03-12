<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Feedback - E-commerce Store</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .feedback-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .form-control, .form-select {
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        .submit-btn {
            width: 100%;
            padding: 12px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
        }
        .submit-btn:hover {
            background: #45a049;
            transform: translateY(-2px);
        }
        .header-icon {
            font-size: 2em;
            color: #4CAF50;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="feedback-container">
            <div class="text-center mb-4">
                <div class="header-icon">
                    <i class="fas fa-comment-dots"></i>
                </div>
                <h2>Submit Feedback</h2>
                <p class="text-muted">We value your feedback and are committed to improving your experience</p>
            </div>

            <form action="${pageContext.request.contextPath}/feedback" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="submit">
                
                <div class="mb-3">
                    <label for="type" class="form-label">Type of Feedback</label>
                    <select class="form-select" id="type" name="type" required>
                        <option value="">Select feedback type</option>
                        <option value="General">General Feedback</option>
                        <option value="Bug">Bug Report</option>
                        <option value="Feature">Feature Request</option>
                        <option value="Support">Support Request</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="subject" class="form-label">Subject</label>
                    <input type="text" class="form-control" id="subject" name="subject" required
                           placeholder="Brief summary of your feedback">
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="5" required
                              placeholder="Please provide detailed information about your feedback"></textarea>
                    <div class="form-text">
                        <i class="fas fa-info-circle me-1"></i>
                        The more details you provide, the better we can assist you
                    </div>
                </div>

                <div class="mb-3">
                    <label for="priority" class="form-label">Priority Level</label>
                    <select class="form-select" id="priority" name="priority">
                        <option value="Low">Low</option>
                        <option value="Medium">Medium</option>
                        <option value="High">High</option>
                    </select>
                </div>

                <div class="mb-4">
                    <label for="attachment" class="form-label">
                        <i class="fas fa-paperclip me-1"></i>
                        Attachment (Optional)
                    </label>
                    <input type="file" class="form-control" id="attachment" name="attachment">
                    <div class="form-text">Maximum file size: 5MB</div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-paper-plane me-2"></i>Submit Feedback
                </button>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // File upload validation
        document.getElementById('attachment').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file && file.size > 5 * 1024 * 1024) {
                alert('File size must be less than 5MB');
                this.value = '';
            }
        });
    </script>
</body>
</html>
