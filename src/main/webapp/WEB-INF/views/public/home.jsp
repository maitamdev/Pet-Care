<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PetCare Clinic - Chăm sóc thú cưng chuyên nghiệp</title>
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        </head>

        <body>

            <header class="header">
                <div class="container header-inner">
                    <a href="${pageContext.request.contextPath}/home" class="logo">
                        <img src="${pageContext.request.contextPath}/assets/images/petcare_logo_full.png"
                            alt="PetCare Clinic">
                    </a>
                    <nav class="nav-menu">
                        <a href="${pageContext.request.contextPath}/home" class="nav-link active">Trang chủ</a>
                        <a href="#services" class="nav-link">Dịch vụ</a>
                        <a href="#why" class="nav-link">Đặt lịch</a>
                        <a href="#contact" class="nav-link">Liên hệ</a>
                    </nav>
                    <a href="#contact" class="btn btn-primary"><i class="bi bi-calendar-check"></i> Đặt lịch khám</a>
                    <button class="mobile-toggle" onclick="toggleMobileMenu()">☰</button>
                </div>
            </header>

            <section class="hero">
                <div class="container hero-content">
                    <div class="hero-text">
                        <h1>Chăm sóc <span class="text-highlight">thú cưng</span><br>bằng cả trái tim</h1>
                        <p class="hero-desc">
                            PetCare Clinic cung cấp dịch vụ thú y chuyên nghiệp,
                            hiện đại và tận tâm nhất cho thú cưng của bạn.
                        </p>
                        <div class="hero-actions">
                            <a href="#contact" class="btn btn-primary btn-lg"><i class="bi bi-calendar-check"></i> Đặt
                                lịch ngay</a>
                            <a href="#services" class="btn btn-outline btn-lg"><i class="bi bi-search"></i> Xem dịch
                                vụ</a>
                        </div>
                    </div>
                    <div class="hero-image">
                        <img src="${pageContext.request.contextPath}/assets/images/petcare_hero_image.png"
                            alt="PetCare Clinic">
                    </div>
                </div>
            </section>

            <section id="services" class="services-section">
                <div class="container">
                    <div class="services-grid">
                        <div class="service-card">
                            <div class="service-icon"><i class="bi bi-activity"></i></div>
                            <div class="service-info">
                                <h3>Khám tổng quát</h3>
                                <p>Kiểm tra sức khỏe toàn diện.</p>
                            </div>
                        </div>
                        <div class="service-card">
                            <div class="service-icon"><i class="bi bi-shield-check"></i></div>
                            <div class="service-info">
                                <h3>Tiêm phòng</h3>
                                <p>Bảo vệ thú cưng khỏi bệnh nguy hiểm.</p>
                            </div>
                        </div>
                        <div class="service-card">
                            <div class="service-icon"><i class="bi bi-scissors"></i></div>
                            <div class="service-info">
                                <h3>Tắm & Grooming</h3>
                                <p>Vệ sinh và chăm sóc toàn diện.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section id="why" class="why-section">
                <div class="container">
                    <h2 class="section-title">Vì sao chọn PetCare?</h2>
                    <div class="why-grid">
                        <div class="why-card">
                            <div class="why-icon green"><i class="bi bi-person-check"></i></div>
                            <div class="why-info">
                                <h3>Đội ngũ bác sĩ giàu kinh nghiệm</h3>
                                <p>Tận tâm và chuyên môn cao.</p>
                            </div>
                        </div>
                        <div class="why-card">
                            <div class="why-icon red"><i class="bi bi-heart-pulse"></i></div>
                            <div class="why-info">
                                <h3>Trang thiết bị hiện đại</h3>
                                <p>Chẩn đoán và điều trị chính xác.</p>
                            </div>
                        </div>
                        <div class="why-card">
                            <div class="why-icon teal"><i class="bi bi-emoji-smile"></i></div>
                            <div class="why-info">
                                <h3>Dịch vụ nhẹ nhàng, thân thiện</h3>
                                <p>Môi trường an toàn, thoải mái.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <footer id="contact" class="footer">
                <div class="container footer-inner">
                    <div class="footer-brand">
                        <img src="${pageContext.request.contextPath}/assets/images/petcare_logo_full.png"
                            alt="PetCare Clinic" class="footer-logo">
                    </div>
                    <div class="footer-contact">
                        <div class="contact-item"><i class="bi bi-telephone"></i> 1900 1234 56</div>
                        <div class="contact-item"><i class="bi bi-envelope"></i> info@petcareclinic.vn</div>
                        <div class="contact-item"><i class="bi bi-geo-alt"></i> 392 Cao Thắng, Quận 10, TP. Hồ Chí Minh
                        </div>
                    </div>
                </div>
            </footer>

            <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        </body>

        </html>