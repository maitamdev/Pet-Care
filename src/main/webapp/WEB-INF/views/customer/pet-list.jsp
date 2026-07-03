<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thú cưng của tôi - PetCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
<jsp:include page="/WEB-INF/views/customer/layout/sidebar.jsp">
        <jsp:param name="active" value="pets"/>
    </jsp:include>
<main class="main-content">
    <header class="topbar"><div><h1 class="topbar-title">Thú cưng của tôi</h1><p class="topbar-kicker">Quản lý hồ sơ cơ bản của các bé.</p></div></header>
    <div class="content-wrapper">
        <div class="card-panel">
            <div class="action-bar"><div><h3 class="card-title">Danh sách thú cưng</h3></div><a class="btn btn-primary" href="${pageContext.request.contextPath}/my/pets/new"><i class="bi bi-plus-circle"></i> Thêm thú cưng</a></div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead><tr><th>Tên</th><th>Loài</th><th>Giống</th><th>Tuổi</th><th>Cân nặng</th><th>Thao tác</th></tr></thead>
                    <tbody>
                    <c:forEach var="item" items="${listPets}">
                        <tr>
                            <td><span class="cell-title"><c:out value="${item.name}"/></span></td>
                            <td><c:out value="${item.species}"/></td>
                            <td><c:out value="${item.breed}"/></td>
                            <td>${item.age}</td>
                            <td>${item.weight} kg</td>
                            <td><a class="btn btn-warning btn-icon" href="${pageContext.request.contextPath}/my/pets/edit?id=${item.id}"><i class="bi bi-pencil-square"></i></a></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listPets}"><tr><td colspan="6"><div class="empty-state">Chưa có hồ sơ thú cưng.</div></td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
</body>
</html>
