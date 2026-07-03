<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý thú cưng - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="pets"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Quản lý thú cưng</h1>
                <p class="topbar-kicker">Hồ sơ thú cưng và thông tin chủ nuôi</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong><c:out value="${sessionScope.user.fullName}"/></strong> (${sessionScope.user.role})</span>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="card-panel">
                <div class="action-bar">
                    <div>
                        <h3 class="card-title">Danh sách thú cưng</h3>
                        <p class="card-subtitle">Theo dõi giống loài, cân nặng, tuổi và chủ nuôi.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/pets/new" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Thêm thú cưng</a>
                </div>

                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Tên bé</th>
                                <th>Chủ nuôi</th>
                                <th>Loài</th>
                                <th>Giới tính</th>
                                <th>Tuổi</th>
                                <th>Cân nặng</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${listPets}">
                                <tr>
                                    <td><span class="cell-title"><c:out value="${item.name}"/></span><span class="cell-note"><c:out value="${item.breed}"/></span></td>
                                    <td><c:out value="${item.customerName}"/></td>
                                    <td><c:out value="${item.species}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.gender == 'MALE'}"><span class="badge male">Đực</span></c:when>
                                            <c:when test="${item.gender == 'FEMALE'}"><span class="badge female">Cái</span></c:when>
                                            <c:otherwise><span class="badge unknown">Chưa rõ</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${item.age}</td>
                                    <td>${item.weight} kg</td>
                                    <td>
                                        <div class="table-actions">
                                            <a title="Sửa" href="${pageContext.request.contextPath}/admin/pets/edit?id=${item.id}" class="btn btn-warning btn-icon"><i class="bi bi-pencil-square"></i></a>
                                            <form action="${pageContext.request.contextPath}/admin/pets/delete" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa thú cưng này?');">
                                                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                <input type="hidden" name="id" value="${item.id}">
                                                <button title="Xóa" type="submit" class="btn btn-danger btn-icon"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listPets}">
                                <tr><td colspan="7"><div class="empty-state">Chưa có hồ sơ thú cưng nào.</div></td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
