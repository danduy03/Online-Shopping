<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Feedback & Support</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.8rem;
            padding: 0.3rem 0.6rem;
        }
        .priority-badge {
            font-size: 0.8rem;
            padding: 0.2rem 0.5rem;
        }
        .feedback-card {
            transition: transform 0.2s;
        }
        .feedback-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Feedback & Support</h2>
            <a href="#" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createFeedbackModal">
                <i class="fas fa-plus me-2"></i>New Feedback
            </a>
        </div>

        <div class="row">
            <c:forEach items="${feedbacks}" var="feedback">
                <div class="col-md-6 mb-3">
                    <div class="card feedback-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="card-title mb-0">${feedback.subject}</h5>
                                <div>
                                    <span class="badge bg-${feedback.status eq 'PENDING' ? 'warning' : 
                                                         feedback.status eq 'IN_PROGRESS' ? 'info' :
                                                         feedback.status eq 'RESOLVED' ? 'success' : 'secondary'} 
                                           status-badge">
                                        ${feedback.status}
                                    </span>
                                    <span class="badge bg-${feedback.priority eq 'LOW' ? 'success' :
                                                         feedback.priority eq 'MEDIUM' ? 'warning' :
                                                         feedback.priority eq 'HIGH' ? 'danger' : 'dark'}
                                           priority-badge ms-1">
                                        ${feedback.priority}
                                    </span>
                                </div>
                            </div>
                            <p class="card-text text-muted small mb-2">
                                <i class="fas fa-user me-1"></i> ${feedback.userName}
                                <span class="mx-2">•</span>
                                <i class="fas fa-calendar me-1"></i>
                                <fmt:formatDate value="${feedback.createdAt}" pattern="MMM dd, yyyy"/>
                            </p>
                            <p class="card-text mb-3">${feedback.message}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-light text-dark">
                                    <i class="fas fa-comments me-1"></i>
                                    ${feedback.responses.size()} responses
                                </span>
                                <a href="${pageContext.request.contextPath}/feedback/view/${feedback.id}"
                                   class="btn btn-sm btn-outline-primary">
                                    View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Create Feedback Modal -->
    <div class="modal fade" id="createFeedbackModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Submit New Feedback</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/feedback" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Subject</label>
                            <input type="text" class="form-control" name="subject" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Type</label>
                            <select class="form-select" name="type" required>
                                <option value="BUG">Bug Report</option>
                                <option value="FEATURE_REQUEST">Feature Request</option>
                                <option value="SUPPORT">Support Request</option>
                                <option value="GENERAL">General Feedback</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Priority</label>
                            <select class="form-select" name="priority" required>
                                <option value="LOW">Low</option>
                                <option value="MEDIUM" selected>Medium</option>
                                <option value="HIGH">High</option>
                                <option value="URGENT">Urgent</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Message</label>
                            <textarea class="form-control" name="message" rows="5" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Attachments</label>
                            <input type="file" class="form-control" name="attachments" multiple>
                            <div class="form-text">
                                You can upload up to 3 files (max 10MB each)
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit Feedback</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
