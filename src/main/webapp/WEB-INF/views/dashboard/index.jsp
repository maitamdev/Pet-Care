<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan phòng khám - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="dashboard"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <p class="topbar-title">Chào buổi sáng, <c:out value="${sessionScope.user.fullName}"/></p>
                <p class="topbar-kicker">PetCare Clinic</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <div class="user-copy">
                    <strong><c:out value="${sessionScope.user.fullName}"/></strong>
                    <span><c:out value="${sessionScope.user.role}"/></span>
                </div>
                <i class="bi bi-chevron-down profile-chevron" aria-hidden="true"></i>
            </div>
        </header>

        <div class="content-wrapper dashboard-overview">
            <section class="page-intro">
                <h1>Tổng quan phòng khám</h1>
                <p>Hôm nay, mọi hoạt động đều trong tầm kiểm soát.</p>
            </section>

            <section class="stats-grid" aria-label="Chỉ số phòng khám">
                <article class="stat-card">
                    <div class="stat-icon green"><i class="bi bi-calendar2-week"></i></div>
                    <div class="stat-details">
                        <h2>Lịch hẹn hôm nay</h2>
                        <p>${totalAppointments}</p>
                        <span class="stat-trend"><i class="bi bi-arrow-up-right"></i> 12% so với hôm qua</span>
                    </div>
                </article>

                <article class="stat-card">
                    <div class="stat-icon orange"><i class="bi bi-hourglass-split"></i></div>
                    <div class="stat-details">
                        <h2>Chờ duyệt</h2>
                        <p>${pendingApprovals}</p>
                        <span class="stat-trend">Cần xử lý trước 17:00</span>
                    </div>
                </article>

                <article class="stat-card">
                    <div class="stat-icon blue"><i class="bi bi-stethoscope"></i></div>
                    <div class="stat-details">
                        <h2>Thú cưng đang điều trị</h2>
                        <p>${totalPets}</p>
                        <span class="stat-trend">Hồ sơ đang hoạt động</span>
                    </div>
                </article>

                <article class="stat-card">
                    <div class="stat-icon green"><i class="bi bi-wallet2"></i></div>
                    <div class="stat-details">
                        <h2>Doanh thu tháng</h2>
                        <p>${totalRevenue} <small>VNĐ</small></p>
                        <span class="stat-trend">Dòng tiền ổn định</span>
                    </div>
                </article>
            </section>

            <section class="dashboard-grid">
                <article class="card-panel schedule-panel">
                    <div class="panel-heading">
                        <div class="panel-title-wrap">
                            <i class="bi bi-calendar3"></i>
                            <h2 class="card-title">Lịch hẹn hôm nay</h2>
                        </div>
                        <a class="text-button" href="${pageContext.request.contextPath}/admin/appointments">
                            Xem tất cả <i class="bi bi-chevron-right"></i>
                        </a>
                    </div>

                    <div class="timeline">
                        <c:forEach var="app" items="${todayAppointments}">
                            <div class="timeline-item">
                                <div class="timeline-time">
                                    <fmt:formatDate value="${app.appointmentDate}" pattern="HH:mm"/>
                                </div>
                                <div class="timeline-copy">
                                    <strong><c:out value="${app.serviceName}"/> cho <c:out value="${app.petName}"/></strong>
                                    <span>Khách hàng: <c:out value="${app.customerName}"/></span>
                                </div>
                                <span class="status-pill status-${app.status.toLowerCase()}">
                                    <c:choose>
                                        <c:when test="${app.status == 'PENDING'}">Chờ duyệt</c:when>
                                        <c:when test="${app.status == 'CONFIRMED'}">Đã xác nhận</c:when>
                                        <c:when test="${app.status == 'COMPLETED'}">Hoàn thành</c:when>
                                        <c:when test="${app.status == 'CANCELLED'}">Đã hủy</c:when>
                                        <c:otherwise><c:out value="${app.status}"/></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </c:forEach>

                        <c:if test="${empty todayAppointments}">
                            <div class="empty-schedule">
                                <div class="empty-icon"><i class="bi bi-calendar2-check"></i></div>
                                <strong>Không có lịch hẹn nào được đặt trong hôm nay.</strong>
                                <span>Thư giãn một chút và chuẩn bị cho những cuộc hẹn tiếp theo!</span>
                            </div>
                        </c:if>
                    </div>
                </article>

                <aside class="dashboard-side">
                    <article class="card-panel quick-panel">
                        <div class="panel-title-wrap">
                            <i class="bi bi-lightning-charge"></i>
                            <h2 class="card-title">Thao tác nhanh</h2>
                        </div>
                        <nav class="quick-links" aria-label="Thao tác nhanh">
                            <a class="quick-link primary" href="${pageContext.request.contextPath}/admin/pets/new">
                                <i class="bi bi-plus-circle"></i> Thêm thú cưng
                            </a>
                            <a class="quick-link primary" href="${pageContext.request.contextPath}/admin/appointments">
                                <i class="bi bi-calendar-plus"></i> Tạo lịch hẹn
                            </a>
                            <a class="quick-link" href="${pageContext.request.contextPath}/admin/services">
                                <i class="bi bi-briefcase"></i> Quản lý dịch vụ
                            </a>
                            <a class="quick-link" href="${pageContext.request.contextPath}/admin/invoices">
                                <i class="bi bi-receipt"></i> Quản lý hóa đơn
                            </a>
                        </nav>
                    </article>


                </aside>
            </section>
        </div>
    </main>
</body>
</html>
