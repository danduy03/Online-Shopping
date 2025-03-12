<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Feedback History - E-commerce Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .feedback-container {
            max-width: 1000px;
            margin: 40px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .table th {
            font-weight: 600;
            color: #333;
        }
        .badge {
            padding: 8px 12px;
            font-weight: 500;
        }
        .btn-view {
            padding: 5px 10px;
            border-radius: 6px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="feedback-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary me-2">
                        <i class="fas fa-home me-2"></i>Home
                    </a>
                    <a href="${pageContext.request.contextPath}/feedback" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Form
                    </a>
                </div>
                <a href="${pageContext.request.contextPath}/feedback" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>New Feedback
                </a>
            </div>

            <h2 class="mb-4"><i class="fas fa-history me-2"></i>My Feedback History</h2>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Type</th>
                            <th>Subject</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Responses</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${feedbacks}" var="feedback">
                            <tr>
                                <td>${feedback.id}</td>
                                <td>
                                    <span class="badge bg-${feedback.type == 'Bug Report' ? 'danger' : 
                                        feedback.type == 'Feature Request' ? 'primary' : 
                                        feedback.type == 'Support Request' ? 'warning' : 'info'}">
                                        ${feedback.type}
                                    </span>
                                </td>
                                <td>${feedback.subject}</td>
                                <td>
                                    <span class="badge bg-${feedback.priority == 'High' ? 'danger' : 
                                        feedback.priority == 'Medium' ? 'warning' : 'success'}">
                                        ${feedback.priority}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-${feedback.status == 'OPEN' ? 'primary' : 
                                        feedback.status == 'IN_PROGRESS' ? 'warning' : 
                                        feedback.status == 'RESOLVED' ? 'success' : 'secondary'}">
                                        ${feedback.status}
                                    </span>
                                </td>
                                <td>${feedback.createdAt}</td>
                                <td>
                                    <c:if test="${not empty feedback.responses}">
                                        <button class="btn btn-sm btn-success" onclick="viewResponses(${feedback.id})">
                                            ${feedback.responses.size()} Response(s)
                                        </button>
                                    </c:if>
                                    <c:if test="${empty feedback.responses}">
                                        <span class="badge bg-secondary">No Responses</span>
                                    </c:if>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="viewFeedback(${feedback.id})">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- View Feedback Modal -->
    <div class="modal fade" id="viewFeedbackModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Feedback Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="feedbackDetails">
                        <div class="feedback-content"></div>
                        <div class="feedback-responses mt-4">
                            <h6>Admin Responses</h6>
                            <div class="responses-list"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let feedbackModal;
        
        document.addEventListener('DOMContentLoaded', function() {
            feedbackModal = new bootstrap.Modal(document.getElementById('viewFeedbackModal'));
        });

        function viewFeedback(id) {
            fetch('${pageContext.request.contextPath}/feedback?action=view&id=' + id, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.redirect) {
                    window.location.href = data.redirect;
                    return;
                }
                
                // Update modal content
                const feedbackContent = document.querySelector('#feedbackDetails .feedback-content');
                const responsesList = document.querySelector('#feedbackDetails .responses-list');
                
                // Clear previous content
                feedbackContent.innerHTML = '';
                responsesList.innerHTML = '';
                
                // Add feedback details
                let content = '';
                content += '<div class="mb-3">' +
                        '<h6>Subject</h6>' +
                        '<p>' + data.subject + '</p>' +
                    '</div>' +
                    '<div class="mb-3">' +
                        '<h6>Message</h6>' +
                        '<p>' + data.message + '</p>' +
                    '</div>' +
                    '<div class="mb-3">' +
                        '<h6>Type</h6>' +
                        '<span class="badge bg-' + getBadgeClassForType(data.type) + '">' + data.type + '</span>' +
                    '</div>' +
                    '<div class="mb-3">' +
                        '<h6>Priority</h6>' +
                        '<span class="badge bg-' + getBadgeClassForPriority(data.priority) + '">' + data.priority + '</span>' +
                    '</div>' +
                    '<div class="mb-3">' +
                        '<h6>Status</h6>' +
                        '<span class="badge bg-' + getBadgeClassForStatus(data.status) + '">' + data.status + '</span>' +
                    '</div>';

                if (data.attachmentPath) {
                    content += '<div class="mb-3">' +
                        '<h6>Attachment</h6>' +
                        '<a href="' + '${pageContext.request.contextPath}/files/' + data.attachmentPath + '" target="_blank" class="btn btn-sm btn-outline-primary">' +
                            '<i class="fas fa-download"></i> Download Attachment' +
                        '</a>' +
                    '</div>';
                }

                content += '<div class="mb-3">' +
                        '<h6>Submitted On</h6>' +
                        '<p>' + formatDate(data.createdAt) + '</p>' +
                    '</div>';

                feedbackContent.innerHTML = content;
                
                // Add responses
                if (data.responses && data.responses.length > 0) {
                    data.responses.forEach(response => {
                        responsesList.innerHTML += 
                            '<div class="card mb-2">' +
                                '<div class="card-body">' +
                                    '<p class="mb-1">' + response.message + '</p>' +
                                    '<small class="text-muted">' +
                                        'Responded by ' + response.adminName + ' on ' + formatDate(response.createdAt) +
                                    '</small>' +
                                '</div>' +
                            '</div>';
                    });
                } else {
                    responsesList.innerHTML = '<p class="text-muted">No responses yet.</p>';
                }
                
                // Show modal
                feedbackModal.show();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error loading feedback details. Please try again.');
            });
        }

        function getBadgeClassForType(type) {
            switch(type) {
                case 'Bug Report': return 'danger';
                case 'Feature Request': return 'primary';
                case 'Support Request': return 'warning';
                default: return 'info';
            }
        }

        function getBadgeClassForPriority(priority) {
            switch(priority) {
                case 'High': return 'danger';
                case 'Medium': return 'warning';
                default: return 'success';
            }
        }

        function getBadgeClassForStatus(status) {
            switch(status) {
                case 'OPEN': return 'primary';
                case 'IN_PROGRESS': return 'warning';
                case 'RESOLVED': return 'success';
                case 'CLOSED': return 'secondary';
                default: return 'secondary';
            }
        }

        function formatDate(dateStr) {
            if (!dateStr) return '';
            const options = {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            };
            return new Date(dateStr).toLocaleString('en-US', options);
        }
    </script>
</body>
</html>
