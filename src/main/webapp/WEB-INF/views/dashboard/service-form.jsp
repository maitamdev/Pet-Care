<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm hoặc sửa dịch vụ - PetCare</title>
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
                <p class="topbar-kicker">Thiết lập tên dịch vụ, giá và mô tả</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong><c:out value="${sessionScope.user.fullName}"/></strong> (${sessionScope.user.role})</span>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="card-panel form-shell" style="max-width:680px;">
                <h3 class="card-title">
                    <c:choose>
                        <c:when test="${service != null}">Cập nhật dịch vụ</c:when>
                        <c:otherwise>Thêm mới dịch vụ</c:otherwise>
                    </c:choose>
                </h3>
                <p class="card-subtitle">Giá nhập theo VNĐ, hệ thống sẽ định dạng lại ở danh sách.</p>
                <c:if test="${not empty error}">
                    <div style="margin-top: 12px; padding: 12px 14px; border-radius: 8px; background: #fee2e2; color: #991b1b; font-weight: 600;">
                        <c:out value="${error}"/>
                    </div>
                </c:if>
                <form action="${pageContext.request.contextPath}/admin/services/${service != null ? 'update' : 'insert'}" method="POST" style="margin-top:18px;" novalidate>
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <c:if test="${service != null}">
                        <input type="hidden" name="id" value="${service.id}">
                    </c:if>

                    <div class="form-group">
                        <label>Tên dịch vụ *</label>
                        <input type="text" name="name" class="form-control" value="<c:out value='${service.name}'/>" required>
                    </div>

                    <div class="form-group">
                        <label>Nhóm dịch vụ (Category) *</label>
                        <select name="category" class="form-control" required>
                            <option value="">-- Chọn nhóm dịch vụ --</option>
                            <option value="Khám tổng quát & Phòng bệnh" ${service.category == 'Khám tổng quát & Phòng bệnh' ? 'selected' : ''}>Khám tổng quát & Phòng bệnh</option>
                            <option value="Khám chuyên khoa" ${service.category == 'Khám chuyên khoa' ? 'selected' : ''}>Khám chuyên khoa</option>
                            <option value="Chẩn đoán hình ảnh & Xét nghiệm" ${service.category == 'Chẩn đoán hình ảnh & Xét nghiệm' ? 'selected' : ''}>Chẩn đoán hình ảnh & Xét nghiệm</option>
                            <option value="Phẫu thuật & Điều trị" ${service.category == 'Phẫu thuật & Điều trị' ? 'selected' : ''}>Phẫu thuật & Điều trị</option>
                            <option value="Spa & Grooming" ${service.category == 'Spa & Grooming' ? 'selected' : ''}>Spa & Grooming</option>
                            <option value="Dịch vụ khác" ${service.category == 'Dịch vụ khác' ? 'selected' : ''}>Dịch vụ khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Giá (VNĐ) *</label>
                        <input type="text" name="price" class="form-control" value="<c:out value='${service.price}'/>" min="0" required>
                    </div>

                    <div class="form-group">
                        <label>Mô tả</label>
                        <textarea name="description" class="form-control" placeholder="Ví dụ: Khám tổng quát, tư vấn dinh dưỡng, theo dõi sau điều trị..."><c:out value='${service.description}'/></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-save"></i> Lưu lại</button>
                        <a href="${pageContext.request.contextPath}/admin/services" class="btn btn-secondary"><i class="bi bi-x-circle"></i> Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>

