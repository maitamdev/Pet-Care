<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="brand-mark"><i class="bi bi-heart-pulse"></i></div>
        <div class="brand-copy">
            <strong>PetCare</strong>
            <span>Clinic admin</span>
        </div>
    </div>

    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/dashboard"
               class="${param.active == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i> Tổng quan
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/appointments"
               class="${param.active == 'appointments' ? 'active' : ''}">
                <i class="bi bi-calendar-check"></i> Lịch hẹn
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/pets"
               class="${param.active == 'pets' ? 'active' : ''}">
                <i class="bi bi-heart"></i> Thú cưng
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/invoices"
               class="${param.active == 'invoices' ? 'active' : ''}">
                <i class="bi bi-receipt"></i> Hóa đơn
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/services"
               class="${param.active == 'services' ? 'active' : ''}">
                <i class="bi bi-clipboard2-pulse"></i> Dịch vụ
            </a>
        </li>

        <c:if test="${sessionScope.user.role == 'ADMIN'}">
            <li>
                <a href="${pageContext.request.contextPath}/admin/reports"
                   class="${param.active == 'reports' ? 'active' : ''}">
                    <i class="bi bi-bar-chart"></i> Báo cáo
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/staff"
                   class="${param.active == 'staff' ? 'active' : ''}">
                    <i class="bi bi-people"></i> Nhân sự
                </a>
            </li>
        </c:if>

        <li>
            <a class="logout-link" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right"></i> Đăng xuất
            </a>
        </li>
    </ul>
</aside>
