<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn của tôi - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/customer/layout/sidebar.jsp">
        <jsp:param name="active" value="invoices"/>
    </jsp:include>
    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Hóa đơn của tôi</h1>
                <p class="topbar-kicker">Hóa đơn được tạo sau khi lịch khám hoàn thành.</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong><c:out value="${sessionScope.user.fullName}"/></strong></span>
            </div>
        </header>
        <div class="content-wrapper">
            <div class="card-panel">
                <div class="action-bar">
                    <div>
                        <h3 class="card-title">Danh sách hóa đơn</h3>
                        <p class="card-subtitle">Theo dõi trạng thái thanh toán các dịch vụ.</p>
                    </div>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/my/appointments"><i class="bi bi-calendar3"></i> Lịch hẹn</a>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Dịch vụ</th>
                                <th>Thú cưng</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${invoices}">
                            <tr>
                                <td>#${item.id}</td>
                                <td><c:out value="${item.serviceName}"/></td>
                                <td><c:out value="${item.petName}"/></td>
                                <td><strong><fmt:formatNumber value="${item.totalAmount}" pattern="#,###"/> đ</strong></td>
                                <td><span class="status-pill status-${item.status.toLowerCase()}"><c:out value="${item.status}"/></span></td>
                                <td><fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty invoices}">
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">Bạn chưa có hóa đơn nào trong hệ thống.</div>
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
