<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${article.title} - TechStore Blog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .article-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 6rem 0;
            margin-bottom: 3rem;
        }
        
        .article-meta {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1rem;
        }
        
        .article-content {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #334155;
        }
        
        .article-content img {
            max-width: 100%;
            height: auto;
            border-radius: 12px;
            margin: 2rem 0;
        }
        
        .article-content h2, 
        .article-content h3 {
            margin-top: 2rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/header.jsp" />

    <header class="article-header">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <h1 class="fw-bold mb-4">${article.title}</h1>
                    <div class="article-meta">
                        <span class="me-4">
                            <i class="far fa-user me-2"></i>${article.author}
                        </span>
                        <span class="me-4">
                            <i class="far fa-calendar me-2"></i>
                            <fmt:formatDate value="${article.createdAt}" pattern="MMM dd, yyyy"/>
                        </span>
                        <span>
                            <i class="far fa-eye me-2"></i>${article.viewCount} views
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="container mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <article class="article-content">
                    ${article.content}
                </article>
                
                <div class="border-top mt-5 pt-4">
                    <a href="${pageContext.request.contextPath}/articles" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Articles
                    </a>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
