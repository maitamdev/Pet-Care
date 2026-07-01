<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetCare Clinic</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #e0f2f1 0%, #b2dfdb 50%, #80cbc4 100%);
        }
        .welcome-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 50px 40px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            max-width: 480px;
            width: 90%;
        }
        .logo-icon { font-size: 64px; margin-bottom: 15px; }
        .welcome-card h1 {
            color: #00796b;
            font-size: 28px;
            margin-bottom: 8px;
            font-weight: 700;
        }
        .welcome-card .subtitle {
            color: #26a69a;
            font-size: 15px;
            margin-bottom: 30px;
            font-weight: 500;
        }
        .status {
            display: inline-block;
            background: linear-gradient(135deg, #00c853, #00e676);
            color: white;
            padding: 8px 24px;
            border-radius: 30px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0, 200, 83, 0.3);
        }
        .nav-links { display: flex; flex-direction: column; gap: 12px; }
        .nav-links a {
            display: block;
            padding: 14px 24px;
            border-radius: 12px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: linear-gradient(135deg, #00897b, #26a69a);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 137, 123, 0.3);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 137, 123, 0.4);
        }
        .btn-secondary { background: #e0f2f1; color: #00796b; }
        .btn-secondary:hover { background: #b2dfdb; transform: translateY(-2px); }
        .footer-info { margin-top: 30px; color: #90a4ae; font-size: 12px; }
    </style>
</head>
<body>
    <div class="welcome-card">
        <div class="logo-icon">🐾</div>
        <h1>PetCare Clinic</h1>
        <p class="subtitle">Hệ thống quản lý phòng khám thú y</p>
        <div class="status">Project is running!</div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/login" class="btn-primary" style="background: linear-gradient(135deg, #1976d2, #1565c0);">
                Đăng nhập hệ thống (Admin/Staff)
            </a>
            <a href="${pageContext.request.contextPath}/home" class="btn-primary">
                Trang chủ - Home Page
            </a>
            <a href="${pageContext.request.contextPath}/test-db" class="btn-secondary">
                Test kết nối Database
            </a>
        </div>
        <p class="footer-info">Java 8 compatible | Servlet 3.0 | JSP | MySQL 8 | Tomcat 7</p>
    </div>
</body>
</html>
