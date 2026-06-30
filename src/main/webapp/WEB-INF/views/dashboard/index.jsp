<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - PetCare Clinic</title>
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
            <li><a href="${pageContext.request.contextPath}/dashboard" class="active"><i class="bi bi-speedometer2"></i> Tổng quan</a></li>
            <li><a href="#"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/pets"><i class="bi bi-heart"></i> Thú cưng</a></li>
            <li><a href="#"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/services"><i class="bi bi-clipboard2-pulse"></i> Dịch vụ</a></li>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <li><a href="#"><i class="bi bi-people"></i> Nhân sự</a></li>
            </c:if>
            <li><a class="logout-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
        </ul>
    </aside>

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
                    <h3 class="card-title">Lịch khám nổi bật</h3>
                    <p class="card-subtitle">Demo giao diện cho luồng đặt lịch sắp nối dữ liệu thật.</p>
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-time">09:00</div>
                            <div>
                                <strong>Khám tổng quát cho Milo</strong>
                                <span>Nguyễn Minh Anh · Phòng 02</span>
                            </div>
                            <span class="status-pill">Đã xác nhận</span>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-time">10:30</div>
                            <div>
                                <strong>Tiêm vaccine cho Bông</strong>
                                <span>Trần Hoàng Nam · Điều dưỡng Linh</span>
                            </div>
                            <span class="status-pill">Sắp tới</span>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-time">14:15</div>
                            <div>
                                <strong>Tái khám da liễu cho Miu</strong>
                                <span>Lê Thu Hà · Bác sĩ Phúc</span>
                            </div>
                            <span class="status-pill">Theo dõi</span>
                        </div>
                    </div>
                </div>

                <div class="card-panel">
                    <h3 class="card-title">Hiệu suất vận hành</h3>
                    <p class="card-subtitle">Một vài chỉ số mẫu để dashboard có chiều sâu hơn khi demo.</p>
                    <div class="progress-list">
                        <div class="progress-row">
                            <div class="progress-label"><span>Tỷ lệ lấp lịch</span><strong>78%</strong></div>
                            <div class="progress-track"><div class="progress-fill" style="width:78%;"></div></div>
                        </div>
                        <div class="progress-row">
                            <div class="progress-label"><span>Hồ sơ cập nhật đủ</span><strong>86%</strong></div>
                            <div class="progress-track"><div class="progress-fill" style="width:86%;"></div></div>
                        </div>
                        <div class="progress-row">
                            <div class="progress-label"><span>Dịch vụ hoàn tất</span><strong>64%</strong></div>
                            <div class="progress-track"><div class="progress-fill" style="width:64%;"></div></div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>
</body>
</html>
