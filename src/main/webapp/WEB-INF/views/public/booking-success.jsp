<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Thành Công - PetCare Clinic</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .success-section {
            padding: 140px 0 100px;
            min-height: 90vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .success-card {
            background: #FFFFFF;
            border: 2px solid var(--border-green);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow-flat-green);
            padding: 48px;
            width: 100%;
            max-width: 500px;
            text-align: center;
        }

        .success-icon-container {
            width: 80px;
            height: 80px;
            border-radius: 20px;
            border: 3px solid var(--border-green);
            background: var(--primary-light);
            color: var(--accent-green);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            margin: 0 auto 32px;
            box-shadow: var(--shadow-flat-green);
        }

        .success-card h2 {
            color: var(--accent-green);
            font-size: 2.25rem;
            margin-bottom: 12px;
        }

        .success-card p {
            font-size: 1.1rem;
            color: var(--text-body);
            margin-bottom: 32px;
        }

        .success-badge {
            background: #FAF6F0;
            border: 2px solid var(--border-default);
            border-radius: var(--radius-sm);
            padding: 20px;
            text-align: left;
            margin-bottom: 40px;
        }

        .success-badge-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 1rem;
            color: var(--text-dark);
            font-weight: 500;
        }

        .success-badge-row:last-child {
            margin-bottom: 0;
        }

        .success-badge-row span.label {
            color: var(--text-light);
        }

        .success-badge-row span.val {
            font-weight: 700;
        }
    </style>
</head>

<body>

    <header class="header">
        <div class="container header-inner">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <img src="${pageContext.request.contextPath}/assets/images/petcare_logo_full.png" alt="PetCare Clinic">
            </a>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/home" class="nav-link">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/home#services" class="nav-link">Dịch vụ</a>
                <a href="${pageContext.request.contextPath}/home#why" class="nav-link">Vì sao chọn chúng tôi</a>
                <a href="${pageContext.request.contextPath}/home#contact" class="nav-link">Liên hệ</a>
            </nav>
            <div class="header-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/dashboard" class="nav-link" style="color: var(--accent-green); font-weight: bold;">
                            <i class="bi bi-person-circle"></i> ${sessionScope.user.fullName}
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: #c62828; font-weight: bold;">
                            <i class="bi bi-box-arrow-right"></i> Đăng xuất
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="nav-link" style="color: var(--accent-green); font-weight: bold;">
                            <i class="bi bi-person-circle"></i> Đăng nhập
                        </a>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/booking" class="btn btn-green btn-header active"><i class="bi bi-calendar-check"></i> Đặt lịch khám</a>
            </div>
        </div>
    </header>

    <section class="success-section">
        <div class="success-card">
            <div class="success-icon-container">
                <i class="bi bi-check2-circle"></i>
            </div>
            <h2>Đặt Lịch Thành Công!</h2>
            <p>Lịch khám của bé cưng đã được ghi nhận. Đội ngũ PetCare sẽ liên hệ sớm nhất để xác nhận lại lịch hẹn của bạn.</p>

            <div class="success-badge">
                <div class="success-badge-row">
                    <span class="label">Trạng thái:</span>
                    <span class="val" style="color: var(--accent-green);"><i class="bi bi-hourglass-split"></i> Đang chờ xác nhận</span>
                </div>
                <div class="success-badge-row">
                    <span class="label">Hỗ trợ hotline:</span>
                    <span class="val">0123 456 789</span>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/home" class="btn btn-orange" style="width: 100%;">Quay Về Trang Chủ ➔</a>
        </div>
    </section>

</body>

</html>
