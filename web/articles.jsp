<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tech Blog - TechStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .article-card {
            border: none;
            border-radius: 20px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }
        
        .article-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
        }
        
        .article-thumbnail {
            height: 250px;
            object-fit: cover;
        }
        
        .article-meta {
            color: #64748b;
            font-size: 0.9rem;
        }
        
        .article-summary {
            color: #475569;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="/includes/header.jsp" />

    <div class="container py-5 mt-5">
        <div class="row mb-5">
            <div class="col-12 text-center">
                <h1 class="fw-bold mb-4">Tech Blog</h1>
                <p class="lead text-muted">Stay updated with the latest tech news and insights</p>
            </div>
        </div>

        <div class="row g-4">
            <c:forEach items="${articles}" var="article">
                <div class="col-md-4">
                    <article class="card article-card h-100">
                        <img src="${article.thumbnail}" 
                             class="article-thumbnail" 
                             alt="${article.title}">
                        <div class="card-body">
                            <div class="article-meta mb-2">
                                <span class="me-3">
                                    <i class="far fa-user me-1"></i>${article.author}
                                </span>
                                <span>
                                    <i class="far fa-calendar me-1"></i>
                                    <fmt:formatDate value="${article.createdAt}" pattern="MMM dd, yyyy"/>
                                </span>
                            </div>
                            <h5 class="card-title fw-bold mb-3">${article.title}</h5>
                            <p class="article-summary mb-4">${article.summary}</p>
                            <a href="${pageContext.request.contextPath}/articles/${article.slug}" 
                               class="btn btn-outline-primary">
                                Read More
                            </a>
                        </div>
                    </article>
                </div>
            </c:forEach>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
