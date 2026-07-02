<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý hóa đơn - PetCare</title>
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .badge.status-unpaid {
            background: #fff3cd;
            color: #856404;
        }

        .badge.status-paid {
            background: #d4edda;
            color: #155724;
        }

        .badge.status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .invoice-actions {
            display: flex;
            gap: 6px;
        }
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-box {
            width: min(560px, 92vw);
            background: #fff;
            border-radius: var(--radius);
            padding: 22px;
            box-shadow: 0 20px 60px rgba(15, 23, 42, 0.25);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 18px;
        }

        .modal-header h3 {
            margin: 0 0 6px;
        }

        .modal-header p {
            margin: 0;
            color: var(--muted);
        }
    </style>
    <script>
    function openInvoiceModal() {
        document.getElementById('invoiceModal').style.display = 'flex';
    }

    function closeInvoiceModal() {
        document.getElementById('invoiceModal').style.display = 'none';
    }
</script>
</head>
<div id="invoiceModal" class="modal-overlay" style="display:none;">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <h3>Tạo hóa đơn thủ công</h3>
                <p>Nhập hóa đơn không gắn với lịch hẹn.</p>
            </div>
            <button type="button" class="btn btn-secondary btn-icon" onclick="closeInvoiceModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/invoices" method="POST">
            <div class="form-group">
                <label>Khách hàng *</label>
                <input type="text" name="customerName" class="form-control" required>
            </div>

            <div class="form-group">
                <label>Thú cưng *</label>
                <input type="text" name="petName" class="form-control" required>
            </div>

            <div class="form-group">
                <label>Dịch vụ *</label>
                <input type="text" name="serviceName" class="form-control" required>
            </div>

            <div class="form-group">
                <label>Tổng tiền (VNĐ) *</label>
                <input type="number" name="totalAmount" class="form-control" min="0" required>
            </div>

            <div class="form-group">
                <label>Phương thức thanh toán</label>
                <select name="paymentMethod" class="form-control">
                    <option value="">Chưa chọn</option>
                    <option value="CASH">Tiền mặt</option>
                    <option value="TRANSFER">Chuyển khoản</option>
                    <option value="CARD">Thẻ</option>
                </select>
            </div>

            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status" class="form-control">
                    <option value="UNPAID">Chưa thanh toán</option>
                    <option value="PAID">Đã thanh toán</option>
                    <option value="CANCELLED">Đã hủy</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-save"></i> Lưu hóa đơn
                </button>
                <button type="button" class="btn btn-secondary" onclick="closeInvoiceModal()">Hủy</button>
            </div>
        </form>
    </div>
</div>
<body class="dashboard-body">
    <jsp:include page="/WEB-INF/views/dashboard/layout/sidebar.jsp">
        <jsp:param name="active" value="invoices"/>
    </jsp:include>
    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 class="topbar-title">Quản lý hóa đơn</h1>
                <p class="topbar-kicker">Theo dõi hóa đơn, thanh toán và tổng tiền dịch vụ</p>
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
                        <h3 class="card-title">Danh sách hóa đơn</h3>
                        <p class="card-subtitle">Danh sách hóa đơn sẽ hiển thị sau khi kết nối database.</p>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="openInvoiceModal()">
                        <i class="bi bi-plus-circle"></i> Tạo hóa đơn
                    </button>
                </div>

                <form action="${pageContext.request.contextPath}/admin/invoices" method="GET"
                    style="margin-bottom: 16px; display: flex; gap: 10px; align-items: center;">
                    <input type="text"
                        name="keyword"
                        class="form-control"
                        placeholder="Tìm kiếm theo khách hàng hoặc mã hóa đơn..."
                        style="max-width: 360px;">

                    <select name="status" class="form-control" style="max-width: 190px;">
                        <option value="">Tất cả trạng thái</option>
                        <option value="UNPAID">Chưa thanh toán</option>
                        <option value="PAID">Đã thanh toán</option>
                        <option value="CANCELLED">Đã hủy</option>
                    </select>

                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Tìm kiếm
                    </button>
                </form>

                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Khách hàng</th>
                                <th>Thú cưng</th>
                                <th>Dịch vụ</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Ngày lập</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${listInvoices}">
                                <tr>
                                    <td>#HD${item.id}</td>
                                    <td>
                                        <span class="cell-title">
                                            <c:choose>
                                                <c:when test="${not empty item.customerName}">
                                                    ${item.customerName}
                                                </c:when>
                                                <c:otherwise>
                                                    ${item.manualCustomerName}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.petName}">
                                                ${item.petName}
                                            </c:when>
                                            <c:otherwise>
                                                ${item.manualPetName}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.serviceName}">
                                                ${item.serviceName}
                                            </c:when>
                                            <c:otherwise>
                                                ${item.manualServiceName}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <strong><fmt:formatNumber value="${item.totalAmount}" pattern="#,###"/> đ</strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'PAID'}">
                                                <span class="badge status-paid">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${item.status == 'CANCELLED'}">
                                                <span class="badge status-cancelled">Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge status-unpaid">Chưa thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <div class="invoice-actions">
                                            <a href="#" title="Xem chi tiết" class="btn btn-secondary btn-icon">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="#" title="Đánh dấu đã thanh toán" class="btn btn-primary btn-icon">
                                                <i class="bi bi-check-circle"></i>
                                            </a>
                                            <a href="#" title="Hủy hóa đơn" class="btn btn-danger btn-icon">
                                                <i class="bi bi-x-circle"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listInvoices}">
                                <tr>
                                    <td colspan="8">
                                        <div class="empty-state">Chưa có hóa đơn nào.</div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>