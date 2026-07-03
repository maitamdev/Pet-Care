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
</head>
<body class="dashboard-body">
<jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="staff"/>
    </jsp:include>
<main class="main-content">
    <header class="topbar"><div><h1 class="topbar-title">Nhân sự</h1><p class="topbar-kicker">Quản lý tài khoản bác sĩ và nhân viên.</p></div></header>
    <div class="content-wrapper">
        <div class="card-panel">
            <div class="action-bar"><div><h3 class="card-title">Danh sách nhân sự</h3></div><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/staff/new"><i class="bi bi-plus-circle"></i> Thêm nhân sự</a></div>
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
</body>
</html>
