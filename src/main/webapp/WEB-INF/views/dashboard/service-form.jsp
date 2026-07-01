<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm hoặc sửa dịch vụ - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="brand-mark"><i class="bi bi-heart-pulse"></i></div>
            <div class="brand-copy">
                <strong>PetCare</strong>
                <span>Clinic admin</span>
            </div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2"></i> Tổng quan</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/pets"><i class="bi bi-heart"></i> Thú cưng</a></li>
            <li><a href="#"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/services" class="active"><i class="bi bi-clipboard2-pulse"></i> Dịch vụ</a></li>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <li><a href="#"><i class="bi bi-people"></i> Nhân sự</a></li>
            </c:if>
            <li><a class="logout-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Quản lý dịch vụ</h1>
                <p class="topbar-kicker">Thiết lập tên dịch vụ, giá và mô tả</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.user.role})</span>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="card-panel form-shell" style="max-width:680px;">
                <h3 class="card-title">
                    <c:choose>
                        <c:when test="${service != null}">Cập nhật dịch vụ</c:when>
                        <c:otherwise>Thêm mới dịch vụ</c:otherwise>
                    </c:choose>
                </h3>
                <p class="card-subtitle">Giá nhập theo VNĐ, hệ thống sẽ định dạng lại ở danh sách.</p>
                <c:if test="${not empty error}">
                    <div style="margin-top: 12px; padding: 12px 14px; border-radius: 8px; background: #fee2e2; color: #991b1b; font-weight: 600;">
                        ${error}
                    </div>
                </c:if>
                <form action="${pageContext.request.contextPath}/admin/services/${service != null ? 'update' : 'insert'}" method="POST" style="margin-top:18px;" novalidate>
                    <c:if test="${service != null}">
                        <input type="hidden" name="id" value="${service.id}">
                    </c:if>

                    <div class="form-group">
                        <label>Tên dịch vụ *</label>
                        <input type="text" name="name" class="form-control" value="<c:out value='${service.name}'/>" required>
                    </div>

                    <div class="form-group">
                        <label>Giá (VNĐ) *</label>
                        <input type="text" name="price" class="form-control" value="<c:out value='${service.price}'/>" min="0" required>
                    </div>

                    <div class="form-group">
                        <label>Mô tả</label>
                        <textarea name="description" class="form-control" placeholder="Ví dụ: Khám tổng quát, tư vấn dinh dưỡng, theo dõi sau điều trị..."><c:out value='${service.description}'/></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-save"></i> Lưu lại</button>
                        <a href="${pageContext.request.contextPath}/admin/services" class="btn btn-secondary"><i class="bi bi-x-circle"></i> Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
