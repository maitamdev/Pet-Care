<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="brand-mark"><i class="bi bi-heart-pulse"></i></div>
        <div class="brand-copy"><strong>PetCare</strong><span>Customer portal</span></div>
    </div>
    <ul class="sidebar-menu">
        <li><a class="${param.active == 'appointments' ? 'active' : ''}" href="${pageContext.request.contextPath}/my/appointments"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
        <li><a class="${param.active == 'pets' ? 'active' : ''}" href="${pageContext.request.contextPath}/my/pets"><i class="bi bi-heart"></i> Thú cưng</a></li>
        <li><a class="${param.active == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/my/invoices"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
        <li><a class="${param.active == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/my/profile"><i class="bi bi-person-gear"></i> Hồ sơ</a></li>
        <li><a href="${pageContext.request.contextPath}/home"><i class="bi bi-house"></i> Trang chủ</a></li>
        <li>
            <form action="${pageContext.request.contextPath}/logout" method="POST" style="margin:0;">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <button type="submit" class="logout-link" style="background:none;border:none;width:100%;text-align:left;cursor:pointer;">
                    <i class="bi bi-box-arrow-right"></i> Đăng xuất
                </button>
            </form>
        </li>
    </ul>
</aside>
