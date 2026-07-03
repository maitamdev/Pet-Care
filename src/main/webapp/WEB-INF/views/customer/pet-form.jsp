<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ thú cưng - PetCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
<main class="main-content" style="margin:0 auto;">
    <div class="content-wrapper">
        <div class="card-panel form-shell">
            <h1 class="topbar-title">${pet == null ? 'Thêm thú cưng' : 'Cập nhật thú cưng'}</h1>
            <form method="POST" action="${pageContext.request.contextPath}/my/pets/${pet == null ? 'insert' : 'update'}" enctype="multipart/form-data" style="margin-top:20px;">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                <c:if test="${pet != null}"><input type="hidden" name="id" value="<c:out value='${pet.id}'/>"></c:if>
                <div class="form-grid">
                    <div class="form-group full">
                        <label>Ảnh thú cưng</label>
                        <c:if test="${not empty pet.imageUrl}">
                            <img src="${pageContext.request.contextPath}${pet.imageUrl}" alt="Pet" style="width:120px;height:90px;object-fit:cover;border-radius:8px;display:block;margin-bottom:10px;">
                        </c:if>
                        <input type="file" class="form-control" name="image" accept="image/png,image/jpeg,image/gif">
                    </div>
                    <div class="form-group"><label>Tên *</label><input class="form-control" name="name" value="<c:out value='${pet.name}'/>" required></div>
                    <div class="form-group"><label>Loài *</label><input class="form-control" name="species" value="<c:out value='${pet.species}'/>" required></div>
                    <div class="form-group"><label>Giống</label><input class="form-control" name="breed" value="<c:out value='${pet.breed}'/>"></div>
                    <div class="form-group"><label>Tuổi</label><input type="number" min="0" class="form-control" name="age" value="<c:out value='${pet.age}'/>"></div>
                    <div class="form-group"><label>Cân nặng</label><input type="number" step="0.01" min="0" class="form-control" name="weight" value="<c:out value='${pet.weight}'/>"></div>
                    <div class="form-group"><label>Giới tính</label><select class="form-control" name="gender"><option value="UNKNOWN">Chưa rõ</option><option value="MALE" ${pet.gender == 'MALE' ? 'selected' : ''}>Đực</option><option value="FEMALE" ${pet.gender == 'FEMALE' ? 'selected' : ''}>Cái</option></select></div>
                    <div class="form-group full"><label>Ghi chú</label><textarea class="form-control" name="notes"><c:out value='${pet.notes}'/></textarea></div>
                </div>
                <div class="form-actions"><button class="btn btn-primary" type="submit"><i class="bi bi-save"></i> Lưu</button><a class="btn btn-secondary" href="${pageContext.request.contextPath}/my/pets">Hủy</a></div>
            </form>
        </div>
    </div>
</main>
</body>
</html>
