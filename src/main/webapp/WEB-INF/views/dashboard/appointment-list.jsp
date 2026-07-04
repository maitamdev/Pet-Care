<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý lịch hẹn - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        /* Specific status badge colors for appointments */
        .badge.status-pending { background: #fff3cd; color: #856404; }
        .badge.status-confirmed { background: #cce5ff; color: #004085; }
        .badge.status-completed { background: #d4edda; color: #155724; }
        .badge.status-cancelled { background: #f8d7da; color: #721c24; }

        .btn-action-group {
            display: flex;
            gap: 6px;
        }

        .alert {
            padding: 12px 16px;
            border-radius: var(--radius);
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 14px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="appointments"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Quản lý lịch hẹn</h1>
                <p class="topbar-kicker">Xem danh sách, phê duyệt và cập nhật tiến độ lịch hẹn khám</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.user.role})</span>
            </div>
        </header>

        <div class="content-wrapper">
            <!-- Success/Error Alerts -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill"></i> ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <div class="card-panel">
                <div class="action-bar">
                    <div>
                        <h3 class="card-title">Danh sách lịch hẹn</h3>
                        <p class="card-subtitle">Cập nhật trạng thái khám của thú cưng khách hàng.</p>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã LH</th>
                                <th>Khách hàng</th>
                                <th>Thú cưng</th>
                                <th>Dịch vụ</th>
                                <th>Lịch hẹn</th>
                                <th>Triệu chứng / Ghi chú</th>
                                <th>Trạng thái</th>
                                <th style="text-align: center;">Thao tác duyệt</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${listAppointments}">
                                <tr>
                                    <td>#${item.id}</td>
                                    <td><strong><c:out value="${item.customerName}"/></strong></td>
                                    <td><c:out value="${item.petName}"/></td>
                                    <td>
                                        <div class="cell-title"><c:out value="${item.serviceName}"/></div>
                                        <c:if test="${item.visitType == 'HOME'}">
                                            <div class="cell-note" style="color: var(--primary-color); margin-top: 4px;"><i class="bi bi-house-door"></i> Tại nhà: <c:out value="${item.address}"/></div>
                                        </c:if>
                                        <c:if test="${item.visitType == 'CLINIC'}">
                                            <div class="cell-note text-muted" style="margin-top: 4px;"><i class="bi bi-building"></i> Tại phòng khám</div>
                                        </c:if>
                                        <span class="cell-note" style="color: var(--brand); font-weight: bold; margin-top: 4px;">
                                            Tổng: <fmt:formatNumber value="${item.priceAtBooking}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                                        </span>
                                    </td>
                                    <td>
                                        <strong><fmt:formatDate value="${item.appointmentDate}" pattern="dd/MM/yyyy" /></strong>
                                        <br/>
                                        <span class="cell-note"><i class="bi bi-clock"></i> <fmt:formatDate value="${item.appointmentDate}" pattern="HH:mm" /></span>
                                    </td>
                                    <td>
                                        <span style="font-size: 13px; color: var(--text-body);">
                                            <c:out value="${item.reason}" default="Không có ghi chú" />
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'PENDING'}">
                                                <span class="badge status-pending"><i class="bi bi-hourglass-split"></i> Chờ duyệt</span>
                                            </c:when>
                                            <c:when test="${item.status == 'CONFIRMED'}">
                                                <span class="badge status-confirmed"><i class="bi bi-check-circle"></i> Đã xác nhận</span>
                                            </c:when>
                                            <c:when test="${item.status == 'COMPLETED'}">
                                                <span class="badge status-completed"><i class="bi bi-calendar-check-fill"></i> Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${item.status == 'CANCELLED'}">
                                                <span class="badge status-cancelled"><i class="bi bi-x-circle-fill"></i> Đã hủy</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-action-group" style="justify-content: center;">
                                            <c:if test="${item.status == 'PENDING'}">
                                                <form action="${pageContext.request.contextPath}/admin/appointments/update-status" method="POST" style="display:inline;">
                                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                    <input type="hidden" name="id" value="<c:out value='${item.id}'/>">
                                                    <input type="hidden" name="status" value="CONFIRMED">
                                                    <button type="submit" class="btn btn-primary btn-sm" title="Xác nhận lịch hẹn">
                                                        <i class="bi bi-check-lg"></i> Xác nhận
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/appointments/update-status" method="POST" style="display:inline;">
                                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                    <input type="hidden" name="id" value="<c:out value='${item.id}'/>">
                                                    <input type="hidden" name="status" value="CANCELLED">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Hủy lịch hẹn" onclick="return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này?');">
                                                        <i class="bi bi-trash"></i> Hủy
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${item.status == 'CONFIRMED'}">
                                                <form action="${pageContext.request.contextPath}/admin/appointments/update-status" method="POST" style="display:inline;">
                                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                    <input type="hidden" name="id" value="<c:out value='${item.id}'/>">
                                                    <input type="hidden" name="status" value="COMPLETED">
                                                    <button type="submit" class="btn btn-warning btn-sm" style="background-color: var(--success); border-color: var(--success);" title="Đánh dấu hoàn thành">
                                                        <i class="bi bi-calendar-check"></i> Hoàn thành
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/appointments/update-status" method="POST" style="display:inline;">
                                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                    <input type="hidden" name="id" value="<c:out value='${item.id}'/>">
                                                    <input type="hidden" name="status" value="CANCELLED">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Hủy lịch hẹn" onclick="return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này?');">
                                                        <i class="bi bi-trash"></i> Hủy
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${item.status == 'COMPLETED' || item.status == 'CANCELLED'}">
                                                <span class="cell-note" style="font-style: italic;">Không có hành động</span>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listAppointments}">
                                <tr>
                                    <td colspan="8">
                                        <div class="empty-state" style="text-align: center; padding: 48px; color: var(--muted);">
                                            <i class="bi bi-calendar-x" style="font-size: 3rem; display: block; margin-bottom: 12px;"></i>
                                            Chưa có lịch hẹn nào được tạo trong hệ thống.
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
