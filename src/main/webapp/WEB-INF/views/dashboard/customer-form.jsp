<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa khách hàng' : 'Thêm khách hàng mới'} - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: var(--dark, #2b303a);
        }
        .form-group input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border, #e2e8f0);
            border-radius: var(--radius, 8px);
            font-size: 15px;
            box-sizing: border-box;
            background-color: var(--background, #fff);
            color: var(--dark, #2b303a);
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--primary, #4f46e5);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }
        .form-group input:disabled {
            background-color: #f1f5f9;
            color: #64748b;
            cursor: not-allowed;
        }
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 28px;
        }
        .btn-secondary {
            background-color: #e2e8f0;
            border-color: #e2e8f0;
            color: #334155;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            border-radius: var(--radius, 8px);
            font-weight: 600;
        }
        .btn-secondary:hover {
            background-color: #cbd5e1;
        }
        .alert-info-box {
            background-color: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e40af;
            padding: 12px 16px;
            border-radius: var(--radius, 8px);
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: flex-start;
            gap: 8px;
        }
        .error-message {
            color: var(--danger, #dc3545);
            font-size: 13px;
            margin-top: 4px;
            display: none;
        }
    </style>
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="customers"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">${isEdit ? 'Chỉnh sửa khách hàng' : 'Thêm khách hàng mới'}</h1>
                <p class="topbar-kicker">
                    <a href="${pageContext.request.contextPath}/admin/customers" style="text-decoration:none; color:var(--primary);"><i class="bi bi-arrow-left"></i> Quay lại danh sách</a>
                </p>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="card-panel form-container">
                <h3 class="card-title" style="margin-bottom:20px;">Thông tin tài khoản khách hàng</h3>

                <form id="customerForm" action="${actionUrl}" method="POST" onsubmit="return validateForm();">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${customer.id}">
                    </c:if>

                    <div class="form-group">
                        <label for="fullName">Họ và tên <span style="color:var(--danger);">*</span></label>
                        <input type="text" id="fullName" name="fullName" value="<c:out value='${customer.fullName}'/>" placeholder="Nhập đầy đủ họ tên khách hàng" required>
                        <div class="error-message" id="fullNameErr">Họ tên không được để trống.</div>
                    </div>

                    <div class="form-group">
                        <label for="username">Tên đăng nhập <span style="color:var(--danger);">*</span></label>
                        <input type="text" id="username" name="username" value="<c:out value='${customer.username}'/>" placeholder="Nhập tên đăng nhập (4-50 ký tự)" ${isEdit ? 'disabled' : 'required'} pattern="^[A-Za-z0-9_]{4,50}$" title="Chỉ chứa chữ cái, số, và dấu gạch dưới. Từ 4 đến 50 ký tự.">
                        <c:if test="${isEdit}">
                            <!-- Send username along as it is disabled and won't be sent in post body -->
                            <input type="hidden" name="username" value="<c:out value='${customer.username}'/>">
                        </c:if>
                        <div class="error-message" id="usernameErr">Tên đăng nhập không hợp lệ. Chỉ chấp nhận chữ cái, số, dấu gạch dưới (4-50 ký tự).</div>
                    </div>

                    <c:if test="${!isEdit}">
                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <input type="password" id="password" name="password" placeholder="Để trống nếu đặt mật khẩu mặc định (123456)">
                            <div class="alert-info-box" style="margin-top: 8px; margin-bottom: 0;">
                                <i class="bi bi-info-circle-fill"></i>
                                <span>Nếu để trống, mật khẩu mặc định của khách hàng khi tạo sẽ là <strong>123456</strong>. Khách hàng có thể tự đổi mật khẩu sau khi đăng nhập.</span>
                            </div>
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label for="phone">Số điện thoại <span style="color:var(--danger);">*</span></label>
                        <input type="tel" id="phone" name="phone" value="<c:out value='${customer.phone}'/>" placeholder="Ví dụ: 0912345678" required pattern="^0\d{9}$">
                        <div class="error-message" id="phoneErr">Số điện thoại không hợp lệ (phải bắt đầu bằng số 0 và có đúng 10 chữ số).</div>
                    </div>

                    <div class="form-group">
                        <label for="email">Địa chỉ Email</label>
                        <input type="email" id="email" name="email" value="<c:out value='${customer.email}'/>" placeholder="Ví dụ: khachhang@gmail.com">
                        <div class="error-message" id="emailErr">Email không đúng định dạng.</div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary" style="flex: 1;"><i class="bi bi-check-circle"></i> Lưu thông tin</button>
                        <a href="${pageContext.request.contextPath}/admin/customers" class="btn-secondary">Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>
        // Hàm JavaScript tự check dữ liệu biểu mẫu trước khi gửi lên controller
        function validateForm() {
            let isValid = true;
            
            // Ẩn tất cả thông báo lỗi cũ đi trước khi check lại
            document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');

            // Kiểm tra họ tên xem có rỗng không
            const fullName = document.getElementById('fullName').value.trim();
            if (fullName === '') {
                document.getElementById('fullNameErr').style.display = 'block';
                isValid = false;
            }

            // Kiểm tra tên tài khoản (chỉ kiểm tra khi tạo mới khách hàng)
            const usernameInput = document.getElementById('username');
            if (usernameInput && !usernameInput.disabled) {
                const username = usernameInput.value.trim();
                const usernameRegex = /^[A-Za-z0-9_]{4,50}$/;
                if (!usernameRegex.test(username)) {
                    document.getElementById('usernameErr').style.display = 'block';
                    isValid = false;
                }
            }

            // Kiểm tra định dạng số điện thoại
            const phone = document.getElementById('phone').value.trim();
            const phoneRegex = /^0\d{9}$/;
            if (!phoneRegex.test(phone)) {
                document.getElementById('phoneErr').style.display = 'block';
                isValid = false;
            }

            // Kiểm tra định dạng hòm thư email nếu có điền
            const email = document.getElementById('email').value.trim();
            if (email !== '') {
                const emailRegex = /^[\w\.-]+@[\w\.-]+\.\w{2,}$/;
                if (!emailRegex.test(email)) {
                    document.getElementById('emailErr').style.display = 'block';
                    isValid = false;
                }
            }

            return isValid;
        }
    </script>
</body>
</html>
