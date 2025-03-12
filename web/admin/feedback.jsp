<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Management</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    
    <style>
        .avatar-sm {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .avatar-text {
            font-size: 14px;
            font-weight: 500;
            color: #6c757d;
        }

        .feedback-content {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
        }

        .response-item {
            background: #fff;
            border-left: 3px solid #0d6efd;
            margin-bottom: 1rem;
            padding: 1rem;
            border-radius: 0.25rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .response-item:hover {
            background: #f8f9fa;
        }

        .badge {
            font-weight: 500;
        }

        .responses-list {
            max-height: 300px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #dee2e6 #fff;
        }

        .responses-list::-webkit-scrollbar {
            width: 6px;
        }

        .responses-list::-webkit-scrollbar-track {
            background: #fff;
        }

        .responses-list::-webkit-scrollbar-thumb {
            background-color: #dee2e6;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <!-- Navigation/Header (assuming it's included) -->
    <%@ include file="/WEB-INF/jspf/admin-header.jspf" %>

    <!-- Main Content -->
    <div class="container-fluid px-4">
        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="mt-2">Feedback Management</h1>
            <div class="d-flex gap-2">
                <select class="form-select form-select-sm" style="width: 150px;" id="filterStatus">
                    <option value="">All Status</option>
                    <option value="NEW">New</option>
                    <option value="OPEN">Open</option>
                    <option value="IN_PROGRESS">In Progress</option>
                    <option value="RESOLVED">Resolved</option>
                    <option value="CLOSED">Closed</option>
                </select>
                <select class="form-select form-select-sm" style="width: 150px;" id="filterType">
                    <option value="">All Types</option>
                    <option value="BUG">Bug Report</option>
                    <option value="FEATURE">Feature Request</option>
                    <option value="SUPPORT">Support Request</option>
                </select>
            </div>
        </div>

        <!-- Feedback List Card -->
        <div class="card shadow-sm">
            <div class="card-header bg-white py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <i class="fas fa-comments text-primary me-2"></i>
                        <span class="fw-bold">All Feedback</span>
                    </div>
                    <span class="badge bg-primary" id="totalCount">${feedbacks.size()} Total</span>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Type</th>
                                <th>Subject</th>
                                <th>User</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${feedbacks}" var="feedback">
                                <tr data-feedback-id="${feedback.id}">
                                    <td><span class="text-secondary">#${feedback.id}</span></td>
                                    <td>
                                        <span class="badge bg-${feedback.type == 'BUG' ? 'danger' : 
                                            feedback.type == 'FEATURE' ? 'primary' : 
                                            feedback.type == 'SUPPORT' ? 'warning' : 'info'} rounded-pill">
                                            ${feedback.type}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="text-truncate" style="max-width: 250px;">
                                            ${feedback.subject}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm me-2 bg-light rounded-circle">
                                                <span class="avatar-text">${fn:substring(feedback.userName, 0, 1)}</span>
                                            </div>
                                            ${feedback.userName}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-${feedback.priority == 'HIGH' ? 'danger' : 
                                            feedback.priority == 'MEDIUM' ? 'warning' : 'success'} rounded-pill">
                                            ${feedback.priority}
                                        </span>
                                    </td>
                                    <td class="status-cell">
                                        <span class="badge bg-${feedback.status == 'OPEN' ? 'primary' : 
                                            feedback.status == 'IN_PROGRESS' ? 'warning' : 
                                            feedback.status == 'RESOLVED' ? 'success' : 'secondary'} rounded-pill">
                                            ${feedback.status}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="text-muted small">${feedback.createdAt}</span>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-primary btn-view-feedback" 
                                                data-id="${feedback.id}">
                                            <i class="fas fa-eye me-1"></i> View
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Feedback Details Modal -->
    <div class="modal fade" id="viewFeedbackModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">
                        <i class="fas fa-clipboard-list text-primary me-2"></i>
                        Feedback Details
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <!-- Left Column: Feedback Details -->
                        <div class="col-md-8">
                            <div id="feedbackDetails">
                                <div class="feedback-content p-3 rounded-3 mb-4"></div>
                                
                                <!-- Responses Section -->
                                <div class="feedback-responses">
                                    <h6 class="fw-bold mb-3">
                                        <i class="fas fa-comments text-primary me-2"></i>
                                        Previous Responses
                                    </h6>
                                    <div class="responses-list"></div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Right Column: Actions -->
                        <div class="col-md-4">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h6 class="fw-bold mb-3">Actions</h6>
                                    
                                    <!-- Status Update -->
                                    <div class="mb-4">
                                        <label class="form-label small fw-bold">Update Status</label>
                                        <select class="form-select form-select-sm" id="statusUpdate" 
                                                onchange="updateFeedbackStatus()">
                                            <option value="NEW">New</option>
                                            <option value="OPEN">Open</option>
                                            <option value="IN_PROGRESS">In Progress</option>
                                            <option value="RESOLVED">Resolved</option>
                                            <option value="CLOSED">Closed</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Add Response Form -->
                                    <form id="responseForm" onsubmit="return submitResponse(event)">
                                        <input type="hidden" id="feedbackId" name="feedbackId">
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold">Add Response</label>
                                            <textarea class="form-control form-control-sm" 
                                                    id="message" name="message" 
                                                    rows="4" required
                                                    placeholder="Type your response here..."></textarea>
                                        </div>
                                        <button type="submit" class="btn btn-primary btn-sm w-100">
                                            <i class="fas fa-paper-plane me-1"></i>
                                            Send Response
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentStatus = '';
        let feedbackModal = null;

        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM Content Loaded');
            
            // Initialize the Bootstrap modal
            feedbackModal = new bootstrap.Modal(document.getElementById('viewFeedbackModal'));
            
            // Initialize filters
            const filterStatus = document.getElementById('filterStatus');
            const filterType = document.getElementById('filterType');
            
            filterStatus?.addEventListener('change', applyFilters);
            filterType?.addEventListener('change', applyFilters);

            // Add click handlers to all view buttons
            document.querySelectorAll('.btn-view-feedback').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const id = this.getAttribute('data-id');
                    viewFeedback(id);
                });
            });
        });

        async function viewFeedback(id) {
            console.log('View Feedback clicked for ID:', id);
            
            if (!feedbackModal) {
                console.error('Modal not initialized');
                return;
            }

            // Show loading state
            const feedbackContent = document.querySelector('#feedbackDetails .feedback-content');
            if (!feedbackContent) {
                console.error('Feedback content element not found');
                return;
            }

            feedbackContent.innerHTML = `
                <div class="text-center py-4">
                    <div class="spinner-border text-primary" role="status"></div>
                    <div class="mt-2">Loading feedback details...</div>
                </div>
            `;

            try {
                // Show the modal first
                feedbackModal.show();
                
                // Set feedback ID
                const feedbackIdInput = document.getElementById('feedbackId');
                if (feedbackIdInput) {
                    feedbackIdInput.value = id;
                }

                // Fetch feedback details
                const response = await fetch(`${pageContext.request.contextPath}/admin/feedback?action=view&id=${id}`, {
                    method: 'GET',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Accept': 'application/json',
                        'Cache-Control': 'no-cache'
                    }
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const data = await response.json();
                console.log('Feedback data:', data);

                if (data.redirect) {
                    window.location.href = data.redirect;
                    return;
                }

                // Update the modal content
                feedbackContent.innerHTML = `
                    <div class="row">
                        <div class="col-12">
                            <h5 class="fw-bold mb-0">${data.subject || 'No Subject'}</h5>
                            <div class="d-flex gap-2 mt-2">
                                <span class="badge bg-${getBadgeClassForType(data.type)}">${data.type || 'Unknown'}</span>
                                <span class="badge bg-${getBadgeClassForPriority(data.priority)}">${data.priority || 'Unknown'}</span>
                                <span class="badge bg-${getBadgeClassForStatus(data.status)}">${data.status || 'Unknown'}</span>
                            </div>
                            <div class="text-muted small mt-2">
                                <i class="fas fa-user me-1"></i> ${data.userName || 'Unknown User'}
                                <span class="mx-2">•</span>
                                <i class="fas fa-clock me-1"></i> ${formatDate(data.createdAt)}
                            </div>
                        </div>
                        <div class="col-12 mt-3">
                            <p class="mb-0">${data.message || 'No description available'}</p>
                        </div>
                    </div>
                `;

                // Update status
                currentStatus = data.status;
                const statusUpdate = document.getElementById('statusUpdate');
                if (statusUpdate) {
                    statusUpdate.value = data.status;
                }

                // Update responses if they exist
                const responsesList = document.querySelector('.responses-list');
                if (responsesList && data.responses) {
                    if (data.responses.length > 0) {
                        responsesList.innerHTML = data.responses.map(response => `
                            <div class="response-item">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fw-bold">${response.adminName}</div>
                                        <div class="text-muted small">${formatDate(response.createdAt)}</div>
                                    </div>
                                </div>
                                <div class="mt-2">${response.message}</div>
                            </div>
                        `).join('');
                    } else {
                        responsesList.innerHTML = '<div class="text-muted text-center py-3">No responses yet</div>';
                    }
                }

            } catch (error) {
                console.error('Error:', error);
                feedbackContent.innerHTML = `
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        Error loading feedback details. Please try again.
                    </div>
                `;
            }
        }

        function applyFilters() {
            const status = document.getElementById('filterStatus').value;
            const type = document.getElementById('filterType').value;
            
            const rows = document.querySelectorAll('tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const rowStatus = row.querySelector('.status-cell').textContent.trim();
                const rowType = row.querySelector('td:nth-child(2)').textContent.trim();
                
                const statusMatch = !status || rowStatus.includes(status);
                const typeMatch = !type || rowType.includes(type);
                
                if (statusMatch && typeMatch) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            document.getElementById('totalCount').textContent = `${visibleCount} Total`;
        }

        function getBadgeClassForType(type) {
            switch(type) {
                case 'BUG': return 'danger';
                case 'FEATURE': return 'primary';
                case 'SUPPORT': return 'warning';
                default: return 'info';
            }
        }

        function getBadgeClassForPriority(priority) {
            switch(priority) {
                case 'HIGH': return 'danger';
                case 'MEDIUM': return 'warning';
                case 'LOW': return 'success';
                default: return 'secondary';
            }
        }

        function getBadgeClassForStatus(status) {
            switch(status) {
                case 'OPEN': return 'primary';
                case 'IN_PROGRESS': return 'warning';
                case 'RESOLVED': return 'success';
                case 'CLOSED': return 'secondary';
                default: return 'info';
            }
        }

        function formatDate(dateString) {
            const options = { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric',
                hour: '2-digit', 
                minute: '2-digit'
            };
            return new Date(dateString).toLocaleDateString('en-US', options);
        }

        function updateFeedbackStatus() {
            const newStatus = document.getElementById('statusUpdate').value;
            const feedbackId = document.getElementById('feedbackId').value;
            
            if (newStatus === currentStatus) {
                return;
            }

            fetch(`${pageContext.request.contextPath}/admin/feedback?action=updateStatus`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: `feedbackId=${feedbackId}&status=${newStatus}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update status in the table
                    const statusCell = document.querySelector(`tr[data-feedback-id="${feedbackId}"] .status-cell`);
                    if (statusCell) {
                        statusCell.innerHTML = `
                            <span class="badge bg-${getBadgeClassForStatus(newStatus)} rounded-pill">
                                ${newStatus}
                            </span>
                        `;
                    }
                    
                    // Refresh feedback details
                    viewFeedback(feedbackId);
                    
                    // Show success message
                    alert('Status updated successfully');
                } else {
                    throw new Error(data.message || 'Failed to update status');
                }
            })
            .catch(error => {
                console.error('Error updating status:', error);
                alert('Failed to update status. Please try again.');
                // Revert status select to current status
                document.getElementById('statusUpdate').value = currentStatus;
            });
        }

        function submitResponse(event) {
            event.preventDefault();
            
            const form = event.target;
            const feedbackId = form.feedbackId.value;
            const message = form.message.value.trim();
            
            if (!message) {
                return false;
            }

            fetch(`${pageContext.request.contextPath}/admin/feedback?action=respond`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: `feedbackId=${feedbackId}&message=${encodeURIComponent(message)}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Clear the response form
                    form.message.value = '';
                    
                    // Refresh feedback details
                    viewFeedback(feedbackId);
                    
                    // Show success message
                    alert('Response submitted successfully');
                } else {
                    throw new Error(data.message || 'Failed to submit response');
                }
            })
            .catch(error => {
                console.error('Error submitting response:', error);
                alert('Failed to submit response. Please try again.');
            });

            return false;
        }
    </script>