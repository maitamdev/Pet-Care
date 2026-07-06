<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form action="${pageContext.request.contextPath}/logout" method="POST" class="logout-form">
    <input type="hidden" name="csrfToken" value="${csrfToken}">
    <button type="submit" class="logout-link">
        <c:if test="${not empty param.icon}">
            <i class="${param.icon}"></i>
        </c:if>
        <c:out value="${empty param.label ? 'Đăng xuất' : param.label}"/>
    </button>
</form>