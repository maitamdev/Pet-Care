<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
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
        .pagination-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #e2e8f0;
        }
        .pagination-info {
            font-size: 14px;
            color: #64748b;
        }
        .pagination-links {
            display: flex;
            gap: 6px;
        }
        .pagination-links a, .pagination-links span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 32px;
            height: 32px;
            padding: 0 6px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            color: #334155;
            background: #fff;
            transition: all 0.2s;
        }
        .pagination-links a:hover {
            border-color: #4f46e5;
            color: #4f46e5;
        }
        .pagination-links .active {
            background-color: #4f46e5;
            border-color: #4f46e5;
            color: #fff;
        }
        .pagination-links .disabled {
            background-color: #f8fafc;
            border-color: #e2e8f0;
            color: #94a3b8;
            cursor: not-allowed;
        }
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
        document.getElementById('invoiceAction').value = 'create';
        document.getElementById('invoiceId').value = '';
        document.getElementById('invoiceCustomerName').value = '';
        document.getElementById('invoicePetName').value = '';
        document.getElementById('invoiceServiceName').value = '';
        document.getElementById('invoiceTotalAmount').value = '';
        document.getElementById('invoicePaymentMethod').value = '';
        document.getElementById('invoiceStatus').value = 'UNPAID';
        document.getElementById('invoiceModal').style.display = 'flex';
    }

    function openEditInvoiceModal(id, customerName, petName, serviceName, totalAmount, paymentMethod, status) {
        document.getElementById('invoiceAction').value = 'update';
        document.getElementById('invoiceId').value = id;
        document.getElementById('invoiceCustomerName').value = customerName || '';
        document.getElementById('invoicePetName').value = petName || '';
        document.getElementById('invoiceServiceName').value = serviceName || '';
        document.getElementById('invoiceTotalAmount').value = totalAmount || '';
        document.getElementById('invoicePaymentMethod').value = paymentMethod || '';
        document.getElementById('invoiceStatus').value = status || 'UNPAID';
        document.getElementById('invoiceModal').style.display = 'flex';
    }

    function closeInvoiceModal() {
        document.getElementById('invoiceModal').style.display = 'none';
    }

    function openEditInvoiceModalFromButton(button) {
        openEditInvoiceModal(
            button.dataset.id,
            button.dataset.customerName,
            button.dataset.petName,
            button.dataset.serviceName,
            button.dataset.totalAmount,
            button.dataset.paymentMethod,
            button.dataset.status
        );
    }

    function openInvoiceDetailModal(id, customerName, petName, serviceName, totalAmount, status, paymentMethod, createdAt) {
    document.getElementById('detailInvoiceId').innerText = '#HD' + id;
    document.getElementById('detailCustomerName').innerText = customerName || 'Chưa có';
    document.getElementById('detailPetName').innerText = petName || 'Chưa có';
    document.getElementById('detailServiceName').innerText = serviceName || 'Chưa có';
    document.getElementById('detailTotalAmount').innerText = Number(totalAmount || 0).toLocaleString('vi-VN') + ' đ';
    document.getElementById('detailStatus').innerText = status || 'UNPAID';
    document.getElementById('detailPaymentMethod').innerText = paymentMethod || 'Chưa chọn';
    document.getElementById('detailCreatedAt').innerText = createdAt || '';

    document.getElementById('invoiceDetailModal').style.display = 'flex';
    }

    function openInvoiceDetailModalFromButton(button) {
        openInvoiceDetailModal(
            button.dataset.id,
            button.dataset.customerName,
            button.dataset.petName,
            button.dataset.serviceName,
            button.dataset.totalAmount,
            button.dataset.status,
            button.dataset.paymentMethod,
            button.dataset.createdAt
        );
    }

    function closeInvoiceDetailModal() {
        document.getElementById('invoiceDetailModal').style.display = 'none';
    }
    </script>
</head>

<body class="dashboard-body">
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
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                <input type="hidden" name="action" id="invoiceAction" value="create">
                <input type="hidden" name="id" id="invoiceId">
                <div class="form-group">
                    <label>Khách hàng *</label>
                    <input type="text" name="customerName" id="invoiceCustomerName" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Thú cưng *</label>
                    <input type="text" name="petName" class="form-control" id="invoicePetName" required>
                </div>

                <div class="form-group">
                    <label>Dịch vụ *</label>
                    <input type="text" name="serviceName" class="form-control" id="invoiceServiceName" required>
                </div>

                <div class="form-group">
                    <label>Tổng tiền (VNĐ) *</label>
                    <input type="number" name="totalAmount" class="form-control" id="invoiceTotalAmount" min="0" required>
                </div>

                <div class="form-group">
                    <label>Phương thức thanh toán</label>
                    <select name="paymentMethod" id="invoicePaymentMethod" class="form-control">
                        <option value="">Chưa chọn</option>
                        <option value="CASH">Tiền mặt</option>
                        <option value="TRANSFER">Chuyển khoản</option>
                        <option value="CARD">Thẻ</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status" id="invoiceStatus" class="form-control">
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
    <div id="invoiceDetailModal" class="modal-overlay" style="display:none;">
        <div class="modal-box">
            <div class="modal-header">
                <div>
                    <h3>Chi tiết hóa đơn</h3>
                    <p id="detailInvoiceId"></p>
                </div>
                <button type="button" class="btn btn-secondary btn-icon" onclick="closeInvoiceDetailModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <div class="form-group">
                <label>Khách hàng</label>
                <div id="detailCustomerName" class="form-control"></div>
            </div>

            <div class="form-group">
                <label>Thú cưng</label>
                <div id="detailPetName" class="form-control"></div>
            </div>

            <div class="form-group">
                <label>Dịch vụ</label>
                <div id="detailServiceName" class="form-control"></div>
            </div>

            <div class="form-group">
                <label>Tổng tiền</label>
                <div id="detailTotalAmount" class="form-control"></div>
            </div>

            <div class="form-group">
                <label>Trạng thái</label>
                <div id="detailStatus" class="form-control"></div>
            </div>

            <div class="form-group">
                <label>Phương thức thanh toán</label>
                <div id="detailPaymentMethod" class="form-control"></div>
            </div>

            <div class="form-group">
                <label>Ngày lập</label>
                <div id="detailCreatedAt" class="form-control"></div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="closeInvoiceDetailModal()">Đóng</button>
            </div>
        </div>
    </div>
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
                        value="<c:out value='${keyword}'/>"
                        placeholder="Tìm kiếm theo khách hàng hoặc mã hóa đơn..."
                        style="max-width: 360px;">

                    <select name="status" class="form-control" style="max-width: 190px;" onchange="this.form.submit()">
                        <option value="" ${status == '' || status == null ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="UNPAID" ${status == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                        <option value="PAID" ${status == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                        <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
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
                                    <td><span class="cell-title"><c:out value="${item.customerName}"/></span></td>
                                    <td><c:out value="${item.petName}"/></td>
                                    <td><c:out value="${item.serviceName}"/></td>
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
                                            <button type="button"
                                                    title="Xem chi tiết"
                                                    class="btn btn-secondary btn-icon"
                                                    data-id="<c:out value='${item.id}'/>"
                                                    data-customer-name="<c:out value='${item.customerName}'/>"
                                                    data-pet-name="<c:out value='${item.petName}'/>"
                                                    data-service-name="<c:out value='${item.serviceName}'/>"
                                                    data-total-amount="<c:out value='${item.totalAmount}'/>"
                                                    data-status="<c:out value='${item.status}'/>"
                                                    data-payment-method="<c:out value='${item.paymentMethod}'/>"
                                                    data-created-at="<c:out value='${item.createdAt}'/>"
                                                    onclick="openInvoiceDetailModalFromButton(this)">
                                                <i class="bi bi-eye"></i>
                                            </button>

                                            <button type="button"
                                                    title="Sửa hóa đơn"
                                                    class="btn btn-primary btn-icon"
                                                    data-id="<c:out value='${item.id}'/>"
                                                    data-customer-name="<c:out value='${item.customerName}'/>"
                                                    data-pet-name="<c:out value='${item.petName}'/>"
                                                    data-service-name="<c:out value='${item.serviceName}'/>"
                                                    data-total-amount="<c:out value='${item.totalAmount}'/>"
                                                    data-payment-method="<c:out value='${item.paymentMethod}'/>"
                                                    data-status="<c:out value='${item.status}'/>"
                                                    onclick="openEditInvoiceModalFromButton(this)">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <form action="${pageContext.request.contextPath}/admin/invoices" method="POST" style="display:inline;">
                                                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                <input type="hidden" name="action" value="update-status">
                                                <input type="hidden" name="id" value="${item.id}">
                                                <input type="hidden" name="status" value="CANCELLED">
                                                <button type="submit" title="Hủy hóa đơn" class="btn btn-danger btn-icon"
                                                        onclick="return confirm('Bạn có chắc muốn hủy hóa đơn này?');">
                                                    <i class="bi bi-x-circle"></i>
                                                </button>
                                            </form>
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

                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <div class="pagination-info">
                            Hiển thị trang <strong>${currentPage}</strong> trên tổng số <strong>${totalPages}</strong> (Có ${totalCount} hóa đơn)
                        </div>
                        <div class="pagination-links">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/admin/invoices?page=${currentPage - 1}&keyword=<c:out value='${keyword}'/>&status=<c:out value='${status}'/>" title="Trang trước"><i class="bi bi-chevron-left"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <span class="disabled"><i class="bi bi-chevron-left"></i></span>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${p == currentPage}">
                                        <span class="active">${p}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/admin/invoices?page=${p}&keyword=<c:out value='${keyword}'/>&status=<c:out value='${status}'/>">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/admin/invoices?page=${currentPage + 1}&keyword=<c:out value='${keyword}'/>&status=<c:out value='${status}'/>" title="Trang sau"><i class="bi bi-chevron-right"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <span class="disabled"><i class="bi bi-chevron-right"></i></span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</body>
</html>
