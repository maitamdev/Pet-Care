<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn - PetCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
<aside class="sidebar">
    <div class="sidebar-header"><div class="brand-mark"><i class="bi bi-heart-pulse"></i></div><div class="brand-copy"><strong>PetCare</strong><span>Clinic admin</span></div></div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2"></i> Tổng quan</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/pets"><i class="bi bi-heart"></i> Thú cưng</a></li>
        <li><a class="active" href="${pageContext.request.contextPath}/admin/invoices"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/services"><i class="bi bi-clipboard2-pulse"></i> Dịch vụ</a></li>
        <c:if test="${sessionScope.user.role == 'ADMIN'}"><li><a href="${pageContext.request.contextPath}/admin/staff"><i class="bi bi-people"></i> Nhân sự</a></li></c:if>
        <li><a class="logout-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
    </ul>
</aside>
<main class="main-content">
    <header class="topbar"><div><h1 class="topbar-title">Hóa đơn</h1><p class="topbar-kicker">Theo dõi thanh toán sau khi ca khám hoàn thành.</p></div></header>
    <div class="content-wrapper">
        <div class="card-panel">
            <table class="data-table">
                <thead><tr><th>Mã</th><th>Khách hàng</th><th>Dịch vụ</th><th>Tổng tiền</th><th>Trạng thái</th><th>Thanh toán</th></tr></thead>
                <tbody>
                <c:forEach var="item" items="${invoices}">
                    <tr>
                        <td>#${item.id}</td>
                        <td><span class="cell-title"><c:out value="${item.customerName}"/></span><span class="cell-note"><c:out value="${item.petName}"/></span></td>
                        <td><c:out value="${item.serviceName}"/></td>
                        <td><strong><fmt:formatNumber value="${item.totalAmount}" pattern="#,###"/>đ</strong></td>
                        <td><span class="status-pill">${item.status}</span></td>
                        <td>
                            <form method="POST" action="${pageContext.request.contextPath}/admin/invoices/update" style="display:flex; gap:8px; align-items:center;">
                                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                <input type="hidden" name="id" value="${item.id}">
                                <select class="form-control" name="status" style="min-width:120px;"><option value="UNPAID" ${item.status == 'UNPAID' ? 'selected' : ''}>Chưa trả</option><option value="PAID" ${item.status == 'PAID' ? 'selected' : ''}>Đã trả</option><option value="CANCELLED" ${item.status == 'CANCELLED' ? 'selected' : ''}>Hủy</option></select>
                                <select class="form-control" name="paymentMethod" style="min-width:120px;"><option value="CASH">Tiền mặt</option><option value="TRANSFER">Chuyển khoản</option><option value="CARD">Thẻ</option></select>
                                <button class="btn btn-primary btn-icon" type="submit"><i class="bi bi-check-lg"></i></button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty invoices}"><tr><td colspan="6"><div class="empty-state">Chưa có hóa đơn.</div></td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>
