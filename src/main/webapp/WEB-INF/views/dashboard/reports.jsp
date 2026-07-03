<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="reports"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Báo cáo vận hành</h1>
                <p class="topbar-kicker">Doanh thu, trạng thái lịch hẹn và dịch vụ nổi bật trong năm.</p>
            </div>
            <form method="GET" action="${pageContext.request.contextPath}/admin/reports" style="display:flex;gap:8px;align-items:center;">
                <input class="form-control" type="number" name="year" value="<c:out value='${year}'/>" min="2000" style="width:120px;">
                <button class="btn btn-primary" type="submit"><i class="bi bi-funnel"></i> Lọc</button>
            </form>
        </header>

        <div class="content-wrapper">
            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-details">
                            <h3>Doanh thu đã thanh toán</h3>
                            <p><fmt:formatNumber value="${yearRevenue}" pattern="#,###"/> đ</p>
                        </div>
                        <div class="stat-icon green"><i class="bi bi-cash-coin"></i></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-details">
                            <h3>Lịch đã hoàn thành</h3>
                            <p><c:out value="${completedAppointments}"/></p>
                        </div>
                        <div class="stat-icon blue"><i class="bi bi-calendar-check"></i></div>
                    </div>
                </div>
            </section>

            <section class="dashboard-grid">
                <div class="card-panel">
                    <h3 class="card-title">Doanh thu theo tháng</h3>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead><tr><th>Tháng</th><th>Doanh thu</th></tr></thead>
                            <tbody>
                                <c:forEach var="row" items="${monthlyRevenue}">
                                    <tr>
                                        <td>Tháng <c:out value="${row.month}"/></td>
                                        <td><strong><fmt:formatNumber value="${row.revenue}" pattern="#,###"/> đ</strong></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty monthlyRevenue}"><tr><td colspan="2"><div class="empty-state">Chưa có doanh thu đã thanh toán trong năm này.</div></td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card-panel">
                    <h3 class="card-title">Trạng thái lịch hẹn</h3>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead><tr><th>Trạng thái</th><th>Số lượng</th></tr></thead>
                            <tbody>
                                <c:forEach var="row" items="${statusCounts}">
                                    <tr><td><c:out value="${row.status}"/></td><td><strong><c:out value="${row.total}"/></strong></td></tr>
                                </c:forEach>
                                <c:if test="${empty statusCounts}"><tr><td colspan="2"><div class="empty-state">Chưa có lịch hẹn trong năm này.</div></td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>

            <div class="card-panel">
                <h3 class="card-title">Top dịch vụ được sử dụng</h3>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead><tr><th>Dịch vụ</th><th>Số lượt</th><th>Doanh thu dự kiến</th></tr></thead>
                        <tbody>
                            <c:forEach var="row" items="${topServices}">
                                <tr>
                                    <td><span class="cell-title"><c:out value="${row.name}"/></span></td>
                                    <td><c:out value="${row.usedCount}"/></td>
                                    <td><fmt:formatNumber value="${row.revenue}" pattern="#,###"/> đ</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty topServices}"><tr><td colspan="3"><div class="empty-state">Chưa có dữ liệu dịch vụ.</div></td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
