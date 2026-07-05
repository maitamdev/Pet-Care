<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ thú cưng - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/customer/layout/sidebar.jsp">
        <jsp:param name="active" value="pets"/>
    </jsp:include>
    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">${pet == null ? 'Thêm thú cưng mới' : 'Cập nhật thú cưng'}</h1>
                <p class="topbar-kicker">Khai báo thông tin chi tiết thú cưng của bạn.</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong><c:out value="${sessionScope.user.fullName}"/></strong></span>
            </div>
        </header>
        <div class="content-wrapper">
            <div class="card-panel form-shell" style="max-width:800px;">
                <h3 class="card-title">Hồ sơ sức khỏe</h3>
                
                <form method="POST" action="${pageContext.request.contextPath}/my/pets/${pet == null ? 'insert' : 'update'}" enctype="multipart/form-data" style="margin-top:20px;">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <c:if test="${pet != null}">
                        <input type="hidden" name="id" value="<c:out value='${pet.id}'/>">
                    </c:if>
                    <div class="form-grid">
                        <div class="form-group full">
                            <label>Ảnh thú cưng</label>
                            <c:if test="${not empty pet.imageUrl}">
                                <img src="${pageContext.request.contextPath}${pet.imageUrl}" alt="Pet" style="width:120px;height:90px;object-fit:cover;border-radius:8px;display:block;margin-bottom:10px;border: 1px solid var(--border-default);">
                            </c:if>
                            <input type="file" class="form-control" name="image" accept="image/png,image/jpeg,image/gif">
                        </div>
                        <div class="form-group">
                            <label>Tên *</label>
                            <input class="form-control" name="name" value="<c:out value='${pet.name}'/>" required>
                        </div>
                        <div class="form-group">
                            <label>Loài (Species) *</label>
                            <input class="form-control" name="species" value="<c:out value='${pet.species}'/>" required placeholder="Chó, Mèo, Thỏ...">
                        </div>
                        <div class="form-group">
                            <label>Giống loài (Breed)</label>
                            <input class="form-control" name="breed" value="<c:out value='${pet.breed}'/>" placeholder="Poodle, Corgi, Mèo mướp...">
                        </div>
                        <div class="form-group">
                            <label>Tuổi</label>
                            <input type="number" min="0" max="100" class="form-control" name="age" value="<c:out value='${pet.age}'/>">
                        </div>
                        <div class="form-group">
                            <label>Cân nặng (kg)</label>
                            <input type="number" step="0.01" min="0" class="form-control" name="weight" value="<c:out value='${pet.weight}'/>">
                        </div>
                        <div class="form-group">
                            <label>Giới tính</label>
                            <select class="form-control" name="gender">
                                <option value="UNKNOWN">Chưa rõ</option>
                                <option value="MALE" ${pet.gender == 'MALE' ? 'selected' : ''}>Đực</option>
                                <option value="FEMALE" ${pet.gender == 'FEMALE' ? 'selected' : ''}>Cái</option>
                            </select>
                        </div>
                        <div class="form-group full">
                            <label>Ghi chú sức khỏe / Tiền sử</label>
                            <textarea class="form-control" name="notes" placeholder="Mô tả dị ứng, thói quen ăn uống hoặc các lưu ý đặc biệt khác..."><c:out value='${pet.notes}'/></textarea>
                        </div>
                    </div>
                    <div class="form-actions" style="margin-top: 20px;">
                        <button class="btn btn-primary" type="submit"><i class="bi bi-save"></i> Lưu hồ sơ</button>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/my/pets">Hủy</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
