<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý dịch vụ - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="services"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Quản lý dịch vụ</h1>
                <p class="topbar-kicker">Bảng giá và mô tả dịch vụ phòng khám</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.user.role})</span>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="card-panel">
                <div class="action-bar">
                    <div>
                        <h3 class="card-title">Danh sách dịch vụ</h3>
                        <p class="card-subtitle">Cập nhật dịch vụ, giá tiền và mô tả hiển thị cho nhân viên.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/services/new" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Thêm dịch vụ</a>
                </div>

                <c:if test="${param.success == 'created'}">
                    <div style="margin-bottom: 16px; padding: 12px 14px; border-radius: 8px; background: #dcfce7; color: #166534; font-weight: 600;">
                        Thêm dịch vụ thành công.
                    </div>
                </c:if>

                <c:if test="${param.success == 'updated'}">
                    <div style="margin-bottom: 16px; padding: 12px 14px; border-radius: 8px; background: #dcfce7; color: #166534; font-weight: 600;">
                        Cập nhật dịch vụ thành công.
                    </div>
                </c:if>

                <c:if test="${param.success == 'deleted'}">
                    <div style="margin-bottom: 16px; padding: 12px 14px; border-radius: 8px; background: #dcfce7; color: #166534; font-weight: 600;">
                        Xóa dịch vụ thành công.
                    </div>
                </c:if>
                <form action="${pageContext.request.contextPath}/admin/services" method="GET" accept-charset="UTF-8"
                    style="margin-bottom: 16px; display: flex; gap: 10px; align-items: center;">
                    <input type="text"
                        name="keyword"
                        class="form-control"
                        placeholder="Tìm kiếm dịch vụ theo tên..."
                        value="<c:out value='${keyword}'/>"
                        style="max-width: 360px;">
                    <select name="sort" class="form-control" style="max-width: 180px;"  onchange="this.form.submit()">
                        <option value="">Mặc định</option>
                        <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                        <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                    </select>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Tìm kiếm
                    </button>

                    <c:if test="${not empty keyword || not empty sort}">
                        <a href="${pageContext.request.contextPath}/admin/services" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> Xóa lọc
                        </a>
                    </c:if>
                </form>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên dịch vụ</th>
                                <th>Giá (VNĐ)</th>
                                <th>Mô tả</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${listServices}">
                                <tr>
                                    <td>#${item.id}</td>
                                    <td><span class="cell-title">${item.name}</span></td>
                                    <td><strong><fmt:formatNumber value="${item.price}" pattern="#,###"/></strong></td>
                                    <td>${item.description}</td>
                                    <td>
                                        <div class="table-actions">
                                            <a title="Sửa" href="${pageContext.request.contextPath}/admin/services/edit?id=${item.id}" class="btn btn-warning btn-icon"><i class="bi bi-pencil-square"></i></a>
                                            <a title="Xóa" href="${pageContext.request.contextPath}/admin/services/delete?id=${item.id}" class="btn btn-danger btn-icon" onclick="return confirm('Bạn có chắc muốn xóa dịch vụ này?');"><i class="bi bi-trash"></i></a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listServices}">
                                <tr><td colspan="5"><div class="empty-state">Chưa có dịch vụ nào.</div></td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
