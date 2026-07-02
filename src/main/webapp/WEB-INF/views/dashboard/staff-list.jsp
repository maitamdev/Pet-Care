<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý nhân sự - PetCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
            <jsp:param name="active" value="staff"/>
    </jsp:include>
    <main class="main-content">
        <div class="content-wrapper">
            <div class="card-panel">
                <h3 class="card-title">Quản lý nhân sự</h3>
                <p class="card-subtitle">Chức năng nhân sự sẽ được phát triển sau.</p>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">Quay lại tổng quan</a>
            </div>
        </div>
    </main>
</body>
</html>