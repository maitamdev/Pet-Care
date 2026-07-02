<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhân sự - PetCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
<main class="main-content" style="margin:0 auto;">
    <div class="content-wrapper">
        <div class="card-panel form-shell">
            <h1 class="topbar-title">${staff == null ? 'Thêm nhân sự' : 'Cập nhật nhân sự'}</h1>
            <form method="POST" action="${pageContext.request.contextPath}/admin/staff/${staff == null ? 'insert' : 'update'}" style="margin-top:20px;">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                <c:if test="${staff != null}"><input type="hidden" name="id" value="${staff.id}"></c:if>
                <div class="form-grid">
                    <div class="form-group"><label>Họ tên *</label><input class="form-control" name="fullName" value="<c:out value='${staff.fullName}'/>" required></div>
                    <div class="form-group"><label>Tài khoản *</label><input class="form-control" name="username" value="<c:out value='${staff.username}'/>" ${staff != null ? 'readonly' : 'required'}></div>
                    <c:if test="${staff == null}"><div class="form-group"><label>Mật khẩu *</label><input type="password" class="form-control" name="password" required></div></c:if>
                    <div class="form-group"><label>Số điện thoại</label><input class="form-control" name="phone" value="<c:out value='${staff.phone}'/>"></div>
                    <div class="form-group"><label>Email</label><input class="form-control" name="email" value="<c:out value='${staff.email}'/>"></div>
                    <div class="form-group"><label>Chuyên môn</label><input class="form-control" name="specialty" value="<c:out value='${staff.specialty}'/>"></div>
                </div>
                <div class="form-actions"><button class="btn btn-primary" type="submit"><i class="bi bi-save"></i> Lưu</button><a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/staff">Hủy</a></div>
            </form>
        </div>
    </div>
</main>
</body>
</html>
