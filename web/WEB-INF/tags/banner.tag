<%@ tag description="Banner Display Component" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="banners" type="java.util.List" required="true" %>
<%@ attribute name="containerClass" type="java.lang.String" required="false" %>
<%@ attribute name="height" type="java.lang.String" required="false" %>

<c:if test="${not empty banners}">
    <div class="banner-section ${containerClass}">
        <c:forEach items="${banners}" var="banner">
            <div class="banner-container position-relative" style="height: ${empty height ? '400px' : height};">
                <a href="${banner.linkUrl}" class="d-block h-100">
                    <img src="${pageContext.request.contextPath}/${banner.imageUrl}?v=${System.currentTimeMillis()}" 
                         alt="${banner.title}"
                         style="width: 100%; height: 100%; object-fit: cover;">
                    <div class="banner-content position-absolute bottom-0 start-0 w-100 p-4 text-white"
                         style="background: linear-gradient(transparent, rgba(0,0,0,0.7));">
                        <h2 class="mb-2">${banner.title}</h2>
                        <p class="mb-0 lead">${banner.description}</p>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</c:if>
