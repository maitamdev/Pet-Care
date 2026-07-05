<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/customer/layout/sidebar.jsp">
        <jsp:param name="active" value="profile"/>
    </jsp:include>
    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Hồ sơ cá nhân</h1>
                <p class="topbar-kicker">Cập nhật thông tin liên hệ và mật khẩu tài khoản.</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong><c:out value="${sessionScope.user.fullName}"/></strong></span>
            </div>
        </header>
        <div class="content-wrapper">
            <div class="card-panel form-shell" style="max-width:800px;">
                <h3 class="card-title">Thông tin tài khoản</h3>
                
                <c:if test="${param.success == 'updated'}"><div class="alert alert-success" style="margin-top: 12px; padding: 12px 14px; border-radius: 8px; background: #d4edda; color: #155724; font-weight: 600;"><i class="bi bi-check-circle-fill"></i> Cập nhật hồ sơ thành công.</div></c:if>
                <c:if test="${param.success == 'password'}"><div class="alert alert-success" style="margin-top: 12px; padding: 12px 14px; border-radius: 8px; background: #d4edda; color: #155724; font-weight: 600;"><i class="bi bi-check-circle-fill"></i> Đổi mật khẩu thành công.</div></c:if>
                <c:if test="${not empty param.error}"><div class="alert alert-danger" style="margin-top: 12px; padding: 12px 14px; border-radius: 8px; background: #fee2e2; color: #991b1b; font-weight: 600;"><i class="bi bi-exclamation-triangle-fill"></i> Thông tin chưa hợp lệ, vui lòng kiểm tra lại.</div></c:if>

                <form method="POST" action="${pageContext.request.contextPath}/my/profile" enctype="multipart/form-data" style="margin-top:20px;">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <div class="form-grid">
                        <div class="form-group full">
                            <label>Ảnh đại diện</label>
                            <c:if test="${not empty sessionScope.user.imageUrl}">
                                <img src="${pageContext.request.contextPath}${sessionScope.user.imageUrl}" alt="Avatar" style="width:96px;height:96px;object-fit:cover;border-radius:50%;display:block;margin-bottom:10px;border: 3px solid var(--border-default);">
                            </c:if>
                            <input type="file" class="form-control" name="avatar" accept="image/png,image/jpeg,image/gif">
                        </div>
                        <div class="form-group">
                            <label>Họ tên *</label>
                            <input class="form-control" name="fullName" value="<c:out value='${sessionScope.user.fullName}'/>" required>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input class="form-control" name="phone" value="<c:out value='${sessionScope.user.phone}'/>">
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input class="form-control" name="email" value="<c:out value='${sessionScope.user.email}'/>">
                        </div>
                    </div>
                    <div class="form-actions" style="margin-top: 20px;">
                        <button class="btn btn-primary" type="submit"><i class="bi bi-save"></i> Lưu hồ sơ</button>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/my/appointments">Quay lại</a>
                    </div>
                </form>

                <hr style="margin:28px 0;border:0;border-top:1px solid var(--border-default);">
                
                <h3 class="card-title">Đổi mật khẩu</h3>
                <form method="POST" action="${pageContext.request.contextPath}/my/profile" style="margin-top:16px;">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <input type="hidden" name="action" value="change-password">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Mật khẩu hiện tại *</label>
                            <input type="password" class="form-control" name="currentPassword" required>
                        </div>
                        <div class="form-group">
                            <label>Mật khẩu mới * (Tối thiểu 6 ký tự)</label>
                            <input type="password" class="form-control" name="newPassword" minlength="6" required>
                        </div>
                        <div class="form-group">
                            <label>Nhập lại mật khẩu mới *</label>
                            <input type="password" class="form-control" name="confirmPassword" minlength="6" required>
                        </div>
                    </div>
                    <div class="form-actions" style="margin-top: 20px;">
                        <button class="btn btn-primary" type="submit"><i class="bi bi-key"></i> Đổi mật khẩu</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
