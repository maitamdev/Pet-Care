<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - PetCare Clinic</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .auth-container { display:flex; justify-content:center; align-items:center; min-height:100vh; background:linear-gradient(135deg, #e0f2f1, #80cbc4); }
        .auth-card { background:white; padding:40px; border-radius:16px; box-shadow:0 10px 40px rgba(0,0,0,0.1); max-width:400px; width:90%; }
        .auth-header { text-align:center; margin-bottom:20px; }
        .form-group { margin-bottom: 15px; text-align: left; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; color: #455a64; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; box-sizing: border-box; }
        .btn-submit { width: 100%; padding: 12px; background: #00796b; color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 10px; }
        .btn-submit:hover { background: #004d40; }
        .alert-error { color: #d32f2f; background: #ffebee; padding: 10px; border-radius: 8px; margin-bottom: 15px; font-size: 14px; text-align: center; }
        .alert-success { color: #388e3c; background: #e8f5e9; padding: 10px; border-radius: 8px; margin-bottom: 15px; font-size: 14px; text-align: center; }
        .auth-links { text-align: center; margin-top: 20px; font-size: 14px; }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <div style="font-size:48px;">🐾</div>
                <h2 style="color:#00796b;">Đăng nhập PetCare</h2>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert-error"><c:out value="${error}"/></div>
            </c:if>
            <c:if test="${param.registered == 'true'}">
                <div class="alert-success">Đăng ký thành công! Vui lòng đăng nhập.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <c:if test="${not empty param.redirect}">
                    <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>">
                </c:if>
                <c:if test="${not empty redirect}">
                    <input type="hidden" name="redirect" value="<c:out value='${redirect}'/>">
                </c:if>
                <div class="form-group">
                    <label>Tài khoản</label>
                    <input type="text" name="username" class="form-control" required placeholder="Nhập tên đăng nhập">
                </div>
                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" class="form-control" required placeholder="Nhập mật khẩu">
                </div>
                <button type="submit" class="btn-submit">Đăng nhập</button>
            </form>
            
            <div class="auth-links">
                <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" style="color:#00897b;font-weight:600;">Đăng ký ngay</a></p>
                <p style="margin-top: 10px;"><a href="${pageContext.request.contextPath}/home" style="color:#78909c;text-decoration:none;">← Quay về trang chủ</a></p>
            </div>
        </div>
    </div>
</body>
</html>

