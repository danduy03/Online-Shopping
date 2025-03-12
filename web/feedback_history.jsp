<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Feedback History</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        
        <div class="container mt-4">
            <h2>Your Feedback History</h2>
            
            <div class="table-responsive mt-3">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Subject</th>
                            <th>Type</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Created At</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${feedbacks}" var="feedback">
                            <tr>
                                <td>${feedback.id}</td>
                                <td>${feedback.subject}</td>
                                <td>
                                    <span class="badge bg-${feedback.type == 'BUG' ? 'danger' : 
                                                         feedback.type == 'FEATURE' ? 'primary' : 
                                                         feedback.type == 'IMPROVEMENT' ? 'success' : 'secondary'}">
                                        ${feedback.type}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-${feedback.priority == 'HIGH' ? 'danger' : 
                                                         feedback.priority == 'MEDIUM' ? 'warning' : 'info'}">
                                        ${feedback.priority}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-${feedback.status == 'PENDING' ? 'warning' : 
                                                         feedback.status == 'IN_PROGRESS' ? 'info' : 
                                                         feedback.status == 'RESOLVED' ? 'success' : 'secondary'}">
                                        ${feedback.status}
                                    </span>
                                </td>
                                <td>${feedback.createdAt}</td>
                                <td>
                                    <button class="btn btn-sm btn-primary" 
                                            onclick="viewFeedback(${feedback.id})" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#feedbackModal">
                                        View Details
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Feedback Details Modal -->
        <div class="modal fade" id="feedbackModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Feedback Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="feedbackDetails">
                            <!-- Feedback details will be loaded here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function viewFeedback(feedbackId) {
                fetch('feedback?action=view&id=' + feedbackId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.redirect) {
                            window.location.href = data.redirect;
                            return;
                        }
                        
                        const details = document.getElementById('feedbackDetails');
                        let html = `
                            <div class="mb-3">
                                <h6>Subject</h6>
                                <p>\${data.subject}</p>
                            </div>
                            <div class="mb-3">
                                <h6>Description</h6>
                                <p>\${data.description}</p>
                            </div>
                            <div class="mb-3">
                                <h6>Type</h6>
                                <span class="badge bg-\${data.type === 'BUG' ? 'danger' : 
                                                      data.type === 'FEATURE' ? 'primary' : 
                                                      data.type === 'IMPROVEMENT' ? 'success' : 'secondary'}">
                                    \${data.type}
                                </span>
                            </div>
                            <div class="mb-3">
                                <h6>Priority</h6>
                                <span class="badge bg-\${data.priority === 'HIGH' ? 'danger' : 
                                                      data.priority === 'MEDIUM' ? 'warning' : 'info'}">
                                    \${data.priority}
                                </span>
                            </div>`;
                            
                        if (data.attachmentPath) {
                            html += `
                                <div class="mb-3">
                                    <h6>Attachment</h6>
                                    <a href="\${data.attachmentPath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                        View Attachment
                                    </a>
                                </div>`;
                        }
                        
                        details.innerHTML = html;
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Failed to load feedback details');
                    });
            }
        </script>
    </body>
</html>
