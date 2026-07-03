<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhân sự - PetCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-box {
            width: min(720px, 94vw);
            background: #fff;
            border-radius: var(--radius);
            padding: 22px;
            box-shadow: 0 20px 60px rgba(15, 23, 42, 0.25);
        }

        .modal-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .modal-header h3 {
            margin: 0 0 6px;
        }

        .modal-header p {
            margin: 0;
            color: var(--muted);
            font-size: 13px;
        }
    </style>
    <script>
        function openStaffModal() {
            document.getElementById('staffModal').style.display = 'flex';
        }

        function closeStaffModal() {
            document.getElementById('staffModal').style.display = 'none';
        }
    </script>
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="staff"/>
    </jsp:include>
    <main class="main-content">
        <header class="topbar"><div><h1 class="topbar-title">Nhân sự</h1><p class="topbar-kicker">Quản lý tài khoản bác sĩ và nhân viên.</p></div></header>
        <div class="content-wrapper">
            <div class="card-panel">
                <div class="action-bar">
                    <div>
                        <h3 class="card-title">Danh sách nhân sự</h3>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="openStaffModal()">
                        <i class="bi bi-plus-circle"></i> Thêm nhân sự
                    </button>
                </div>
                <table class="data-table">
                    <thead><tr><th>Họ tên</th><th>Tài khoản</th><th>Vai trò</th><th>Chuyên môn</th><th>Liên hệ</th><th>Thao tác</th></tr></thead>
                    <tbody>
                    <c:forEach var="item" items="${listStaff}">
                        <tr>
                            <td><span class="cell-title"><c:out value="${item.fullName}"/></span></td>
                            <td><c:out value="${item.username}"/></td>
                            <td><span class="status-pill">${item.role}</span></td>
                            <td><c:out value="${item.specialty}"/></td>
                            <td><span class="cell-title"><c:out value="${item.phone}"/></span><span class="cell-note"><c:out value="${item.email}"/></span></td>
                            <td>
                                <div class="table-actions">
                                    <c:if test="${item.role == 'STAFF'}">
                                        <a class="btn btn-warning btn-icon" href="${pageContext.request.contextPath}/admin/staff/edit?id=${item.id}"><i class="bi bi-pencil-square"></i></a>
                                        <form method="POST" action="${pageContext.request.contextPath}/admin/staff/delete" onsubmit="return confirm('Ngừng hoạt động tài khoản này?');">
                                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                            <input type="hidden" name="id" value="${item.id}">
                                            <button class="btn btn-danger btn-icon" type="submit"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
    <div id="staffModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <div>
                    <h3>Thêm nhân sự</h3>
                    <p>Tạo tài khoản bác sĩ hoặc nhân viên phòng khám.</p>
                </div>

                <button type="button" class="btn btn-secondary btn-icon" onclick="closeStaffModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/admin/staff/insert">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">

                <div class="form-grid">
                    <div class="form-group">
                        <label>Họ tên *</label>
                        <input class="form-control" name="fullName" required>
                    </div>

                    <div class="form-group">
                        <label>Tài khoản *</label>
                        <input class="form-control" name="username" required>
                    </div>

                    <div class="form-group">
                        <label>Mật khẩu *</label>
                        <input type="password" class="form-control" name="password" minlength="8" required>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input class="form-control" name="phone">
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" class="form-control" name="email">
                    </div>

                    <div class="form-group">
                        <label>Chuyên môn</label>
                        <input class="form-control" name="specialty" placeholder="VD: Bác sĩ thú y, chăm sóc thú cưng...">
                    </div>
                </div>

                <div class="form-actions">
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-save"></i> Lưu nhân sự
                    </button>

                    <button class="btn btn-secondary" type="button" onclick="closeStaffModal()">
                        Hủy
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
