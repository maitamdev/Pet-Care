<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lịch hẹn mới - PetCare</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="appointments"/>
    </jsp:include>

    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Đặt lịch hẹn mới</h1>
                <p class="topbar-kicker">Tạo lịch khám cho thú cưng và phân công trực tiếp</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><i class="bi bi-person"></i></div>
                <span>Xin chào, <strong><c:out value="${sessionScope.user.fullName}"/></strong> (${sessionScope.user.role})</span>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="card-panel form-shell" style="max-width:800px;">
                <h3 class="card-title">Phiếu đặt lịch hẹn</h3>
                <p class="card-subtitle">Vui lòng điền đầy đủ các thông tin bắt buộc dưới đây.</p>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div style="margin-top: 12px; padding: 12px 14px; border-radius: 8px; background: #fee2e2; color: #991b1b; font-weight: 600;">
                        <c:out value="${sessionScope.errorMessage}"/>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/appointments/insert" method="POST" style="margin-top:18px;">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">

                    <!-- Customer -->
                    <div class="form-group">
                        <label>Khách hàng chủ nuôi *</label>
                        <select name="customerId" id="customerId" class="form-control" required>
                            <option value="">-- Chọn khách hàng --</option>
                            <c:forEach var="cust" items="${listCustomers}">
                                <option value="${cust.id}"><c:out value="${cust.fullName}"/> (<c:out value="${cust.username}"/>) - ${cust.phone}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Pet -->
                    <div class="form-group">
                        <label>Thú cưng khám *</label>
                        <select name="petId" id="petId" class="form-control" required disabled>
                            <option value="">-- Chọn thú cưng --</option>
                        </select>
                        <span class="cell-note" style="margin-top: 4px;">Danh sách thú cưng tự động tải sau khi chọn chủ nuôi.</span>
                    </div>

                    <!-- Services (Checkboxes) -->
                    <div class="form-group">
                        <label>Chọn dịch vụ sử dụng (Chọn ít nhất một) *</label>
                        <div class="services-list" style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; background: #fafafa; padding: 16px; border-radius: 8px; border: 1px solid #e2e8f0; max-height: 250px; overflow-y: auto;">
                            <c:forEach var="srv" items="${listServices}">
                                <div style="display: flex; align-items: flex-start; gap: 8px;">
                                    <input type="checkbox" name="serviceIds" value="${srv.id}" id="srv_${srv.id}" style="margin-top: 4px;">
                                    <label for="srv_${srv.id}" style="font-weight: normal; cursor: pointer; font-size: 14px;">
                                        <strong><c:out value="${srv.name}"/></strong><br>
                                        <span class="cell-note" style="color: var(--brand); font-weight: bold;">
                                            <fmt:formatNumber value="${srv.price}" pattern="#,###"/> đ
                                        </span>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Date and Time -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Ngày hẹn khám *</label>
                            <input type="date" name="date" id="appDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Giờ hẹn khám (08:00 - 17:00) *</label>
                            <input type="time" name="time" id="appTime" class="form-control" required>
                        </div>
                    </div>

                    <!-- Assign Staff -->
                    <div class="form-group">
                        <label>Phân công Bác sĩ / Nhân viên (Không bắt buộc)</label>
                        <select name="staffId" class="form-control">
                            <option value="">-- Tự động phân công / Chọn sau --</option>
                            <c:forEach var="st" items="${listStaff}">
                                <option value="${st.id}"><c:out value="${st.fullName}"/> (<c:out value="${st.specialty == null ? 'Bác sĩ thú y' : st.specialty}"/>)</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Visit Type -->
                    <div class="form-group">
                        <label>Địa điểm khám *</label>
                        <select name="visitType" id="visitType" class="form-control">
                            <option value="CLINIC">Tại phòng khám</option>
                            <option value="HOME">Khám tại nhà</option>
                        </select>
                    </div>

                    <!-- Home Address -->
                    <div class="form-group" id="addressContainer" style="display: none;">
                        <label>Địa chỉ khám tại nhà *</label>
                        <input type="text" name="address" id="address" class="form-control" placeholder="Nhập địa chỉ chi tiết">
                    </div>

                    <!-- Reason/Symptoms -->
                    <div class="form-group">
                        <label>Ghi chú triệu chứng / Lý do khám</label>
                        <textarea name="reason" class="form-control" rows="3" placeholder="Ví dụ: Thú cưng biếng ăn, sốt nhẹ, hoặc yêu cầu cắt tỉa đặc biệt..."></textarea>
                    </div>

                    <div class="form-actions" style="margin-top: 24px; display: flex; gap: 12px;">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-save"></i> Đặt lịch hẹn</button>
                        <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-secondary"><i class="bi bi-x-circle"></i> Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>
        document.getElementById('customerId').addEventListener('change', function() {
            const custId = this.value;
            const petSelect = document.getElementById('petId');
            petSelect.innerHTML = '<option value="">-- Đang tải thú cưng... --</option>';
            petSelect.disabled = true;

            if (!custId) {
                petSelect.innerHTML = '<option value="">-- Chọn thú cưng --</option>';
                return;
            }

            fetch('${pageContext.request.contextPath}/admin/appointments/get-pets?customerId=' + custId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Mạng gặp lỗi khi tải thú cưng');
                    }
                    return response.json();
                })
                .then(data => {
                    petSelect.innerHTML = '';
                    if (data.length === 0) {
                        petSelect.innerHTML = '<option value="">-- Khách hàng chưa có thú cưng --</option>';
                        petSelect.disabled = true;
                        alert('Khách hàng này chưa có hồ sơ thú cưng! Vui lòng thêm thú cưng cho khách hàng trước.');
                    } else {
                        data.forEach(pet => {
                            const opt = document.createElement('option');
                            opt.value = pet.id;
                            opt.textContent = pet.name + ' (' + pet.species + ')';
                            petSelect.appendChild(opt);
                        });
                        petSelect.disabled = false;
                    }
                })
                .catch(err => {
                    console.error('Error fetching pets:', err);
                    petSelect.innerHTML = '<option value="">-- Lỗi tải thú cưng --</option>';
                });
        });

        document.getElementById('visitType').addEventListener('change', function() {
            const container = document.getElementById('addressContainer');
            const input = document.getElementById('address');
            if (this.value === 'HOME') {
                container.style.display = 'block';
                input.required = true;
            } else {
                container.style.display = 'none';
                input.required = false;
                input.value = '';
            }
        });

        // Set min date of date input to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appDate').min = today;

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const checkboxes = document.querySelectorAll('input[name="serviceIds"]:checked');
            if (checkboxes.length === 0) {
                alert('Vui lòng chọn ít nhất một dịch vụ khám.');
                e.preventDefault();
                return;
            }

            const appDate = document.getElementById('appDate').value;
            const appTime = document.getElementById('appTime').value;
            if (appDate && appTime) {
                const selectedDt = new Date(appDate + 'T' + appTime);
                const now = new Date();
                if (selectedDt <= now) {
                    alert('Thời gian hẹn khám phải ở tương lai.');
                    e.preventDefault();
                    return;
                }

                const hour = selectedDt.getHours();
                const minutes = selectedDt.getMinutes();
                if (hour < 8 || hour > 17 || (hour === 17 && minutes > 0)) {
                    alert('Giờ khám phải nằm trong khung giờ làm việc: 08:00 - 17:00.');
                    e.preventDefault();
                }
            }
        });
    </script>
</body>
</html>
