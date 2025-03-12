<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="layout/admin-layout.jsp">
    <jsp:param name="title" value="Dashboard"/>
    <jsp:param name="active" value="dashboard"/>
</jsp:include>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <div class="row align-items-center">
                        <div class="col">
                            <h6 class="text-muted mb-0">Overview</h6>
                        </div>
                        <div class="col-auto">
                            <div class="btn-group">
                                <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown">
                                    <i class="fas fa-download"></i> Export
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Excel</a></li>
                                    <li><a class="dropdown-item" href="#">PDF</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <jsp:include page="dashboard.jsp" />
                </div>
            </div>
        </div>
    </div>
</div>
