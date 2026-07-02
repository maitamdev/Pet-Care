<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - PetCare Clinic</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .status-pill.status-pending { background: #fff3cd; color: #856404; }
        .status-pill.status-confirmed { background: #cce5ff; color: #004085; }
        .status-pill.status-completed { background: #d4edda; color: #155724; }
        .status-pill.status-cancelled { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="dashboard"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Tổng quan hệ thống</h1>
                <p class="topbar-kicker">Theo dõi vận hành phòng khám trong ngày</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.user.role})</span>
            </div>
        </header>

        <div class="content-wrapper">
            <section class="hero-panel">
                <div class="hero-copy">
                    <h2>Chăm sóc thú cưng gọn gàng, nhanh và rất có gu.</h2>
                    <p>Quản lý lịch hẹn, hồ sơ thú cưng và dịch vụ trong một màn hình sáng sủa hơn, dễ đọc hơn, đúng tinh thần một phòng khám hiện đại.</p>
                    <div class="quick-actions">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/pets/new"><i class="bi bi-plus-circle"></i> Thêm thú cưng</a>
                        <a class="btn" href="${pageContext.request.contextPath}/admin/services"><i class="bi bi-clipboard2-pulse"></i> Xem dịch vụ</a>
                    </div>
                </div>
                <div class="hero-side">
                    <div class="signal-card">
                        <span>Lịch hôm nay</span>
                        <strong>${totalAppointments} ca khám</strong>
                    </div>
                    <div class="signal-card">
                        <span>Doanh thu tháng</span>
                        <strong>${totalRevenue} VNĐ</strong>
                    </div>
                </div>
            </section>

            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-details">
                            <h3>Lịch hẹn hôm nay</h3>
                            <p>${totalAppointments}</p>
                        </div>
                        <div class="stat-icon blue"><i class="bi bi-calendar2-week"></i></div>
                    </div>
                    <span class="stat-trend"><i class="bi bi-arrow-up-right"></i> 12% so với hôm qua</span>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-details">
                            <h3>Chờ duyệt</h3>
                            <p>${pendingApprovals}</p>
                        </div>
                        <div class="stat-icon orange"><i class="bi bi-hourglass-split"></i></div>
                    </div>
                    <span class="stat-trend">Cần xử lý trước 17:00</span>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-details">
                            <h3>Thú cưng đang điều trị</h3>
                            <p>${totalPets}</p>
                        </div>
                        <div class="stat-icon purple"><i class="bi bi-heart"></i></div>
                    </div>
                    <span class="stat-trend">Hồ sơ đang hoạt động</span>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-details">
                            <h3>Doanh thu tháng</h3>
                            <p>${totalRevenue}</p>
                        </div>
                        <div class="stat-icon green"><i class="bi bi-cash-coin"></i></div>
                    </div>
                    <span class="stat-trend"><i class="bi bi-arrow-up-right"></i> Dòng tiền ổn định</span>
                </div>
            </section>

            <section class="dashboard-grid">
                <div class="card-panel">
                    <h3 class="card-title">Lịch khám hôm nay</h3>
                    <p class="card-subtitle">Các lịch khám của thú cưng hẹn trong ngày hôm nay.</p>
                    <div class="timeline">
                        <c:forEach var="app" items="${todayAppointments}">
                            <div class="timeline-item">
                                <div class="timeline-time">
                                    <fmt:formatDate value="${app.appointmentDate}" pattern="HH:mm" />
                                </div>
                                <div>
                                    <strong>${app.serviceName} cho ${app.petName}</strong>
                                    <span>Khách hàng: ${app.customerName}</span>
                                </div>
                                <span class="status-pill status-${app.status.toLowerCase()}">
                                    <c:choose>
                                        <c:when test="${app.status == 'PENDING'}">Chờ duyệt</c:when>
                                        <c:when test="${app.status == 'CONFIRMED'}">Đã xác nhận</c:when>
                                        <c:when test="${app.status == 'COMPLETED'}">Hoàn thành</c:when>
                                        <c:when test="${app.status == 'CANCELLED'}">Đã hủy</c:when>
                                        <c:otherwise>${app.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </c:forEach>
                        <c:if test="${empty todayAppointments}">
                            <p style="color: var(--text-light); text-align: center; padding: 32px 0;">Không có lịch khám nào được đặt trong hôm nay 🐾</p>
                        </c:if>
                    </div>
                </div>

                <div class="card-panel">
                    <h3 class="card-title">Lối tắt quản trị</h3>
                    <p class="card-subtitle">Các chức năng vận hành nhanh dành cho nhân viên phòng khám.</p>
                    <div style="margin-top: 20px; display: flex; flex-direction: column; gap: 14px;">
                        <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-primary" style="text-align: center; justify-content: center; padding: 12px 16px; border-radius: var(--radius); text-decoration: none; font-weight: 700; display: inline-flex; align-items: center; gap: 8px;">
                            <i class="bi bi-calendar-check"></i> Duyệt & Xác nhận Lịch Hẹn
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/services" class="btn" style="text-align: center; justify-content: center; padding: 12px 16px; border-radius: var(--radius); text-decoration: none; font-weight: 700; background: #FAF6F0; border: 1px solid var(--border-default); color: var(--ink); display: inline-flex; align-items: center; gap: 8px;">
                            <i class="bi bi-clipboard2-pulse"></i> Quản lý danh mục Dịch vụ
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/pets" class="btn" style="text-align: center; justify-content: center; padding: 12px 16px; border-radius: var(--radius); text-decoration: none; font-weight: 700; background: #FAF6F0; border: 1px solid var(--border-default); color: var(--ink); display: inline-flex; align-items: center; gap: 8px;">
                            <i class="bi bi-heart"></i> Quản lý hồ sơ Thú cưng
                        </a>
                    </div>
                </div>
            </section>
        </div>
    </main>
</body>
</html>
