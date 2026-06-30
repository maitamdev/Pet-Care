<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm hoặc sửa thú cưng - PetCare</title>
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="brand-mark"><i class="bi bi-heart-pulse"></i></div>
            <div class="brand-copy">
                <strong>PetCare</strong>
                <span>Clinic admin</span>
            </div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2"></i> Tổng quan</a></li>
            <li><a href="#"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/pets" class="active"><i class="bi bi-heart"></i> Thú cưng</a></li>
            <li><a href="#"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/services"><i class="bi bi-clipboard2-pulse"></i> Dịch vụ</a></li>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <li><a href="#"><i class="bi bi-people"></i> Nhân sự</a></li>
            </c:if>
            <li><a class="logout-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Quản lý thú cưng</h1>
                <p class="topbar-kicker">Nhập hồ sơ y tế cơ bản và thông tin chủ nuôi</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.user.role})</span>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="card-panel form-shell">
                <h3 class="card-title">
                    <c:choose>
                        <c:when test="${pet != null}">Cập nhật thông tin thú cưng</c:when>
                        <c:otherwise>Thêm mới thú cưng</c:otherwise>
                    </c:choose>
                </h3>
                <p class="card-subtitle">Các trường có dấu * là thông tin bắt buộc.</p>

                <form action="${pageContext.request.contextPath}/admin/pets/${pet != null ? 'update' : 'insert'}" method="POST">
                    <c:if test="${pet != null}">
                        <input type="hidden" name="id" value="${pet.id}">
                    </c:if>

                    <div class="form-group full" style="margin-top:18px;">
                        <label>Chọn khách hàng (chủ nuôi) *</label>
                        <select name="customerId" class="form-control" required>
                            <option value="">-- Chọn chủ nuôi --</option>
                            <c:forEach var="customer" items="${listCustomers}">
                                <option value="${customer.id}" ${pet != null && pet.customerId == customer.id ? 'selected' : ''}>
                                    ${customer.fullName} - ${customer.phone}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Tên thú cưng *</label>
                            <input type="text" name="name" class="form-control" value="<c:out value='${pet.name}'/>" required>
                        </div>
                        <div class="form-group">
                            <label>Loài</label>
                            <input type="text" name="species" class="form-control" value="<c:out value='${pet.species}'/>" placeholder="Chó, mèo...">
                        </div>
                        <div class="form-group">
                            <label>Giống loài</label>
                            <input type="text" name="breed" class="form-control" value="<c:out value='${pet.breed}'/>">
                        </div>
                        <div class="form-group">
                            <label>Tuổi</label>
                            <input type="number" name="age" class="form-control" value="<c:out value='${pet.age}'/>" min="0">
                        </div>
                        <div class="form-group">
                            <label>Cân nặng (kg)</label>
                            <input type="number" step="0.01" name="weight" class="form-control" value="<c:out value='${pet.weight}'/>" min="0">
                        </div>
                        <div class="form-group">
                            <label>Giới tính</label>
                            <select name="gender" class="form-control">
                                <option value="UNKNOWN" ${pet.gender == 'UNKNOWN' ? 'selected' : ''}>Chưa rõ</option>
                                <option value="MALE" ${pet.gender == 'MALE' ? 'selected' : ''}>Đực</option>
                                <option value="FEMALE" ${pet.gender == 'FEMALE' ? 'selected' : ''}>Cái</option>
                            </select>
                        </div>
                        <div class="form-group full">
                            <label>Ghi chú thêm</label>
                            <textarea name="notes" class="form-control" placeholder="Tình trạng sức khỏe, dị ứng, lịch sử điều trị..."><c:out value='${pet.notes}'/></textarea>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-save"></i> Lưu lại</button>
                        <a href="${pageContext.request.contextPath}/admin/pets" class="btn btn-secondary"><i class="bi bi-x-circle"></i> Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
