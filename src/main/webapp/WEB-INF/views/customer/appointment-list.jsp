<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch hẹn của tôi - PetCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
<aside class="sidebar">
    <div class="sidebar-header"><div class="brand-mark"><i class="bi bi-heart-pulse"></i></div><div class="brand-copy"><strong>PetCare</strong><span>Customer portal</span></div></div>
    <ul class="sidebar-menu">
        <li><a class="active" href="${pageContext.request.contextPath}/my/appointments"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
        <li><a href="${pageContext.request.contextPath}/my/pets"><i class="bi bi-heart"></i> Thú cưng</a></li>
        <li><a href="${pageContext.request.contextPath}/my/invoices"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
        <li><a href="${pageContext.request.contextPath}/my/profile"><i class="bi bi-person-gear"></i> Hồ sơ</a></li>
        <li><a href="${pageContext.request.contextPath}/home"><i class="bi bi-house"></i> Trang chủ</a></li>
        <li><a class="logout-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
    </ul>
</aside>
<main class="main-content">
    <header class="topbar">
        <div><h1 class="topbar-title">Lịch hẹn của tôi</h1><p class="topbar-kicker">Theo dõi trạng thái khám và lịch sử chăm sóc.</p></div>
        <div class="user-profile"><div class="user-avatar"><i class="bi bi-person"></i></div><span><c:out value="${sessionScope.user.fullName}"/></span></div>
    </header>
    <div class="content-wrapper">
        <div class="card-panel">
            <div class="action-bar">
                <div><h3 class="card-title">Danh sách lịch hẹn</h3><p class="card-subtitle">Bạn có thể hủy lịch khi lịch còn chờ duyệt hoặc đã xác nhận.</p></div>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/booking"><i class="bi bi-plus-circle"></i> Đặt lịch mới</a>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead><tr><th>Mã</th><th>Thú cưng</th><th>Dịch vụ</th><th>Thời gian</th><th>Bác sĩ</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                    <tbody>
                    <c:forEach var="item" items="${appointments}">
                        <tr>
                            <td>#${item.id}</td>
                            <td><span class="cell-title"><c:out value="${item.petName}"/></span><span class="cell-note"><c:out value="${item.reason}"/></span></td>
                            <td><c:out value="${item.serviceName}"/></td>
                            <td><strong><fmt:formatDate value="${item.appointmentDate}" pattern="dd/MM/yyyy"/></strong><span class="cell-note"><fmt:formatDate value="${item.appointmentDate}" pattern="HH:mm"/></span></td>
                            <td><c:out value="${empty item.staffName ? 'Chưa phân công' : item.staffName}"/></td>
                            <td><span class="status-pill status-${item.status.toLowerCase()}">${item.status}</span></td>
                            <td>
                                <c:if test="${item.status == 'PENDING' || item.status == 'CONFIRMED'}">
                                    <form method="POST" action="${pageContext.request.contextPath}/my/appointments/cancel" onsubmit="return confirm('Bạn muốn hủy lịch hẹn này?');">
                                        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                        <input type="hidden" name="id" value="${item.id}">
                                        <button class="btn btn-danger btn-icon" type="submit"><i class="bi bi-x-lg"></i></button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appointments}"><tr><td colspan="7"><div class="empty-state">Bạn chưa có lịch hẹn nào.</div></td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
</body>
</html>
