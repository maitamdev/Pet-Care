<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khách hàng - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .btn-danger {
            background-color: var(--danger, #dc3545);
            border-color: var(--danger, #dc3545);
            color: #fff;
        }
        .btn-danger:hover {
            background-color: #bb2d3b;
        }
        .alert {
            padding: 12px 16px;
            border-radius: var(--radius, 8px);
            margin-bottom: 20px;
            font-weight: bold;
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
        <jsp:param name="active" value="customers"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Quản lý khách hàng</h1>
                <p class="topbar-kicker">Xem danh sách khách hàng và quản lý quyền truy cập hệ thống</p>
            </div>
            
            <form method="GET" action="${pageContext.request.contextPath}/admin/customers" style="display:flex; gap:8px; align-items:center;">
                <input class="form-control" type="text" name="keyword" placeholder="Tìm tên, SĐT, Email..." value="<c:out value='${keyword}'/>" style="width:220px;">
                <select class="form-control" name="status" style="width:160px;">
                    <option value="">-- Tất cả trạng thái --</option>
                    <option value="1" ${status == '1' ? 'selected' : ''}>Hoạt động</option>
                    <option value="0" ${status == '0' ? 'selected' : ''}>Bị khóa</option>
                </select>
                <button class="btn btn-primary" type="submit"><i class="bi bi-funnel"></i> Lọc</button>
            </form>
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
                <div class="action-bar" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h3 class="card-title">Danh sách tài khoản khách hàng</h3>
                        <p class="card-subtitle">Khách hàng đăng ký tài khoản từ cổng công cộng.</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/customers/new" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                            <i class="bi bi-plus-circle"></i> Thêm khách hàng
                        </a>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã KH</th>
                                <th>Họ và tên</th>
                                <th>Tên đăng nhập</th>
                                <th>Số điện thoại</th>
                                <th>Email</th>
                                <th>Trạng thái</th>
                                <th style="text-align: center; width: 180px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${listCustomers}">
                                <tr>
                                    <td>#${item.id}</td>
                                    <td><strong><c:out value="${item.fullName}"/></strong></td>
                                    <td><c:out value="${item.username}"/></td>
                                    <td><c:out value="${empty item.phone ? 'Chưa cập nhật' : item.phone}"/></td>
                                    <td><c:out value="${empty item.email ? 'Chưa cập nhật' : item.email}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 1}">
                                                <span class="badge status-completed" style="background:#d4edda;color:#155724;"><i class="bi bi-check-circle-fill"></i> Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge status-cancelled" style="background:#f8d7da;color:#721c24;"><i class="bi bi-slash-circle-fill"></i> Bị khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <div style="display: flex; gap: 6px; justify-content: center; align-items: center;">
                                            <a href="${pageContext.request.contextPath}/admin/customers/edit?id=${item.id}" class="btn btn-primary btn-sm" title="Sửa thông tin" style="background-color: var(--warning, #ffc107); border-color: var(--warning, #ffc107); color: #000; text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">
                                                <i class="bi bi-pencil-square"></i> Sửa
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/customers/update-status" method="POST" onsubmit="return confirm('Bạn có chắc chắn muốn thay đổi trạng thái tài khoản khách hàng này?');" style="display:inline; margin:0;">
                                                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                <input type="hidden" name="id" value="${item.id}">
                                                <c:choose>
                                                    <c:when test="${item.status == 1}">
                                                        <input type="hidden" name="status" value="0">
                                                        <button type="submit" class="btn btn-danger btn-sm" title="Khóa tài khoản" style="display: inline-flex; align-items: center; gap: 4px;">
                                                            <i class="bi bi-lock-fill"></i> Khóa
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="status" value="1">
                                                        <button type="submit" class="btn btn-primary btn-sm" title="Mở khóa tài khoản" style="display: inline-flex; align-items: center; gap: 4px;">
                                                            <i class="bi bi-unlock-fill"></i> Mở khóa
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listCustomers}">
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state" style="text-align: center; padding: 48px; color: var(--muted);">
                                            <i class="bi bi-people-fill" style="font-size: 3rem; display: block; margin-bottom: 12px;"></i>
                                            Không tìm thấy tài khoản khách hàng nào phù hợp.
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
