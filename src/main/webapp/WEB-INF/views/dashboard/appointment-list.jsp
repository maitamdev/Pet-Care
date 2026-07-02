<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch hẹn - PetCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
<aside class="sidebar">
    <div class="sidebar-header"><div class="brand-mark"><i class="bi bi-heart-pulse"></i></div><div class="brand-copy"><strong>PetCare</strong><span>Clinic admin</span></div></div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2"></i> Tổng quan</a></li>
        <li><a class="active" href="${pageContext.request.contextPath}/admin/appointments"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/pets"><i class="bi bi-heart"></i> Thú cưng</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/invoices"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/services"><i class="bi bi-clipboard2-pulse"></i> Dịch vụ</a></li>
        <c:if test="${sessionScope.user.role == 'ADMIN'}"><li><a href="${pageContext.request.contextPath}/admin/staff"><i class="bi bi-people"></i> Nhân sự</a></li></c:if>
        <li><a class="logout-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
    </ul>
</aside>
<main class="main-content">
    <header class="topbar">
        <div><h1 class="topbar-title">Lịch hẹn</h1><p class="topbar-kicker">Duyệt lịch, phân công bác sĩ và ghi nhận kết quả khám.</p></div>
        <div class="user-profile"><div class="user-avatar"><i class="bi bi-person"></i></div><span><c:out value="${sessionScope.user.fullName}"/> (${sessionScope.user.role})</span></div>
    </header>
    <div class="content-wrapper">
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="notice notice-success"><c:out value="${sessionScope.successMessage}"/></div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="notice notice-danger"><c:out value="${sessionScope.errorMessage}"/></div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <div class="card-panel">
            <div class="action-bar">
                <div><h3 class="card-title">Danh sách lịch hẹn</h3><p class="card-subtitle">Hoàn thành lịch hẹn sẽ tự tạo hóa đơn chưa thanh toán.</p></div>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/invoices"><i class="bi bi-receipt"></i> Xem hóa đơn</a>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                    <tr><th>Mã</th><th>Khách hàng</th><th>Dịch vụ</th><th>Lịch khám</th><th>Hồ sơ khám</th><th>Trạng thái</th><th>Thao tác</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${listAppointments}">
                        <tr>
                            <td>#${item.id}</td>
                            <td><span class="cell-title"><c:out value="${item.customerName}"/></span><span class="cell-note"><c:out value="${item.petName}"/></span></td>
                            <td><span class="cell-title"><c:out value="${item.serviceName}"/></span><span class="cell-note"><fmt:formatNumber value="${item.priceAtBooking}" pattern="#,###"/>đ</span></td>
                            <td><strong><fmt:formatDate value="${item.appointmentDate}" pattern="dd/MM/yyyy"/></strong><span class="cell-note"><fmt:formatDate value="${item.appointmentDate}" pattern="HH:mm"/></span></td>
                            <td style="min-width:280px;">
                                <form method="POST" action="${pageContext.request.contextPath}/admin/appointments/update-clinical" class="inline-clinic-form">
                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                    <input type="hidden" name="id" value="${item.id}">
                                    <select class="form-control" name="staffId">
                                        <option value="">Chưa phân công</option>
                                        <c:forEach var="staff" items="${listStaff}">
                                            <option value="${staff.id}" ${item.staffId == staff.id ? 'selected' : ''}><c:out value="${staff.fullName}"/></option>
                                        </c:forEach>
                                    </select>
                                    <textarea class="form-control" name="diagnosis" placeholder="Chẩn đoán, dặn dò sau khám..."><c:out value="${item.diagnosis}"/></textarea>
                                    <button class="btn btn-secondary" type="submit"><i class="bi bi-journal-medical"></i> Lưu hồ sơ</button>
                                </form>
                            </td>
                            <td><span class="status-pill status-${item.status.toLowerCase()}">${item.status}</span></td>
                            <td>
                                <div class="btn-action-group">
                                    <c:if test="${item.status == 'PENDING'}">
                                        <form method="POST" action="${pageContext.request.contextPath}/admin/appointments/update-status">
                                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                            <input type="hidden" name="id" value="${item.id}">
                                            <input type="hidden" name="status" value="CONFIRMED">
                                            <button class="btn btn-primary btn-icon" type="submit" title="Xác nhận"><i class="bi bi-check-lg"></i></button>
                                        </form>
                                        <form method="POST" action="${pageContext.request.contextPath}/admin/appointments/update-status">
                                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                            <input type="hidden" name="id" value="${item.id}">
                                            <input type="hidden" name="status" value="CANCELLED">
                                            <button class="btn btn-danger btn-icon" type="submit" title="Hủy"><i class="bi bi-x-lg"></i></button>
                                        </form>
                                    </c:if>
                                    <c:if test="${item.status == 'CONFIRMED'}">
                                        <form method="POST" action="${pageContext.request.contextPath}/admin/appointments/update-status">
                                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                            <input type="hidden" name="id" value="${item.id}">
                                            <input type="hidden" name="status" value="COMPLETED">
                                            <button class="btn btn-warning" type="submit"><i class="bi bi-clipboard-check"></i> Hoàn thành</button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listAppointments}"><tr><td colspan="7"><div class="empty-state">Chưa có lịch hẹn nào.</div></td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
</body>
</html>
