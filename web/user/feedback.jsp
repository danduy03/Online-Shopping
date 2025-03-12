<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Submit Feedback</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../header.jsp"/>
        
        <div class="container mt-4">
            <h2>Submit Feedback</h2>
            
            <form id="feedbackForm" class="mt-3" enctype="multipart/form-data">
                <div class="mb-3">
                    <label for="subject" class="form-label">Subject</label>
                    <input type="text" class="form-control" id="subject" name="subject" required>
                </div>
                
                <div class="mb-3">
                    <label for="description" class="form-label">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                </div>
                
                <div class="mb-3">
                    <label for="type" class="form-label">Type</label>
                    <select class="form-select" id="type" name="type" required>
                        <option value="">Select type</option>
                        <option value="BUG">Bug Report</option>
                        <option value="FEATURE">Feature Request</option>
                        <option value="IMPROVEMENT">Improvement</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="priority" class="form-label">Priority</label>
                    <select class="form-select" id="priority" name="priority" required>
                        <option value="">Select priority</option>
                        <option value="LOW">Low</option>
                        <option value="MEDIUM">Medium</option>
                        <option value="HIGH">High</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="attachment" class="form-label">Attachment (optional)</label>
                    <input type="file" class="form-control" id="attachment" name="attachment">
                </div>
                
                <button type="submit" class="btn btn-primary">Submit Feedback</button>
                <a href="feedback?action=history" class="btn btn-secondary">View History</a>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.getElementById('feedbackForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                const formData = new FormData(this);
                formData.append('action', 'submit');
                
                fetch('feedback', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.redirect) {
                        window.location.href = data.redirect;
                        return;
                    }
                    
                    if (data.success) {
                        alert(data.message);
                        window.location.href = 'feedback?action=history';
                    } else {
                        alert(data.message || 'Failed to submit feedback');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to submit feedback');
                });
            });
        </script>
    </body>
</html>
