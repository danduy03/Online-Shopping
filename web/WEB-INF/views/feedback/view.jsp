<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>View Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .attachment-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
        }
        .response-card {
            border-left: 4px solid #007bff;
            background-color: #f8f9fa;
            padding: 15px;
            margin-bottom: 15px;
        }
        .admin-response {
            border-left-color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/feedback">Feedback & Support</a>
                </li>
                <li class="breadcrumb-item active">View Feedback</li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-md-8">
                <!-- Feedback Details -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <h3 class="card-title">${feedback.subject}</h3>
                            <div>
                                <span class="badge bg-${feedback.status eq 'PENDING' ? 'warning' : 
                                                     feedback.status eq 'IN_PROGRESS' ? 'info' :
                                                     feedback.status eq 'RESOLVED' ? 'success' : 'secondary'}">
                                    ${feedback.status}
                                </span>
                                <span class="badge bg-${feedback.priority eq 'LOW' ? 'success' :
                                                     feedback.priority eq 'MEDIUM' ? 'warning' :
                                                     feedback.priority eq 'HIGH' ? 'danger' : 'dark'}">
                                    ${feedback.priority}
                                </span>
                            </div>
                        </div>
                        <p class="text-muted mb-3">
                            <i class="fas fa-user me-1"></i> ${feedback.userName}
                            <span class="mx-2">•</span>
                            <i class="fas fa-calendar me-1"></i>
                            <fmt:formatDate value="${feedback.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                            <span class="mx-2">•</span>
                            <i class="fas fa-tag me-1"></i> ${feedback.type}
                        </p>
                        <p class="card-text">${feedback.message}</p>

                        <!-- Attachments -->
                        <c:if test="${not empty feedback.attachments}">
                            <div class="mt-4">
                                <h5 class="mb-3">Attachments</h5>
                                <div class="row">
                                    <c:forEach items="${feedback.attachments}" var="attachment">
                                        <div class="col-md-6 mb-3">
                                            <div class="attachment-card">
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-paperclip me-2"></i>
                                                    <div class="flex-grow-1">
                                                        <div class="fw-bold">${attachment.fileName}</div>
                                                        <small class="text-muted">
                                                            ${attachment.fileSize / 1024} KB
                                                        </small>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/${attachment.filePath}"
                                                       class="btn btn-sm btn-outline-primary"
                                                       download>
                                                        <i class="fas fa-download"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Responses -->
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title mb-4">Responses</h5>
                        
                        <c:forEach items="${feedback.responses}" var="response">
                            <div class="response-card ${response.responderName eq 'Admin' ? 'admin-response' : ''}">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <span class="fw-bold">${response.responderName}</span>
                                        <c:if test="${response.responderName eq 'Admin'}">
                                            <span class="badge bg-primary ms-2">Staff</span>
                                        </c:if>
                                    </div>
                                    <small class="text-muted">
                                        <fmt:formatDate value="${response.createdAt}"
                                                      pattern="MMM dd, yyyy HH:mm"/>
                                    </small>
                                </div>
                                <p class="mb-0">${response.response}</p>
                            </div>
                        </c:forEach>

                        <!-- Response Form -->
                        <c:if test="${sessionScope.user.admin}">
                            <form action="${pageContext.request.contextPath}/feedback" method="post" class="mt-4">
                                <input type="hidden" name="action" value="respond">
                                <input type="hidden" name="feedbackId" value="${feedback.id}">
                                <div class="mb-3">
                                    <label class="form-label">Add Response</label>
                                    <textarea class="form-control" name="response" rows="3" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">Submit Response</button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-md-4">
                <!-- Status Update (Admin Only) -->
                <c:if test="${sessionScope.user.admin}">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Update Status</h5>
                            <form action="${pageContext.request.contextPath}/feedback" method="post">
                                <input type="hidden" name="action" value="update-status">
                                <input type="hidden" name="feedbackId" value="${feedback.id}">
                                <div class="mb-3">
                                    <select class="form-select" name="status" required>
                                        <option value="PENDING" ${feedback.status eq 'PENDING' ? 'selected' : ''}>
                                            Pending
                                        </option>
                                        <option value="IN_PROGRESS" ${feedback.status eq 'IN_PROGRESS' ? 'selected' : ''}>
                                            In Progress
                                        </option>
                                        <option value="RESOLVED" ${feedback.status eq 'RESOLVED' ? 'selected' : ''}>
                                            Resolved
                                        </option>
                                        <option value="CLOSED" ${feedback.status eq 'CLOSED' ? 'selected' : ''}>
                                            Closed
                                        </option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary w-100">Update Status</button>
                            </form>
                        </div>
                    </div>
                </c:if>

                <!-- Timeline -->
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Timeline</h5>
                        <div class="timeline">
                            <div class="timeline-item">
                                <i class="fas fa-circle text-primary"></i>
                                <div class="ms-3">
                                    <div class="fw-bold">Feedback Created</div>
                                    <small class="text-muted">
                                        <fmt:formatDate value="${feedback.createdAt}"
                                                      pattern="MMM dd, yyyy HH:mm"/>
                                    </small>
                                </div>
                            </div>
                            <c:forEach items="${feedback.responses}" var="response">
                                <div class="timeline-item mt-3">
                                    <i class="fas fa-circle text-info"></i>
                                    <div class="ms-3">
                                        <div class="fw-bold">Response by ${response.responderName}</div>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${response.createdAt}"
                                                          pattern="MMM dd, yyyy HH:mm"/>
                                        </small>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
