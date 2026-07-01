<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetCare Clinic - Chăm sóc thú cưng chuyên nghiệp</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/petcare_logo_icon.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>

<body>

    <header class="header">
        <div class="container header-inner">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <img src="${pageContext.request.contextPath}/assets/images/petcare_logo_full.png" alt="PetCare Clinic">
            </a>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/home" class="nav-link active">Trang chủ</a>
                <a href="#services" class="nav-link">Dịch vụ</a>
                <a href="#why" class="nav-link">Vì sao chọn chúng tôi</a>
                <a href="#contact" class="nav-link">Liên hệ</a>
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
                <a href="${pageContext.request.contextPath}/booking" class="btn btn-green btn-header"><i class="bi bi-calendar-check"></i> Đặt lịch khám</a>
            </div>
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
                    <a href="#services" class="btn btn-orange btn-lg">Khám Phá Dịch Vụ</a>
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-green btn-lg">Đặt Lịch Khám</a>
                </div>
            </div>
            <div class="hero-image">
                <div class="hero-image-container">
                    <img src="${pageContext.request.contextPath}/assets/images/petcare_hero_image.png" alt="PetCare Clinic">
                </div>
            </div>
        </div>
    </section>

    <section id="services" class="section services-section">
        <div class="container">
            <h2 class="section-title">Dịch vụ của chúng tôi</h2>
            <div class="services-grid">
                <div class="service-card">
                    <div class="service-icons-row">
                        <div class="service-icon-container">
                            <svg viewBox="0 0 64 64" width="36" height="36" fill="none" stroke="#2A5A53" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M16 20 C 16 12, 48 12, 48 20 C 48 36, 36 46, 32 46 C 28 46, 16 36, 16 20" />
                                <path d="M22 18 C 22 22, 42 22, 42 18" />
                                <circle cx="32" cy="46" r="4" fill="#EE7C52" />
                                <path d="M32 46 L 32 50 C 32 54, 44 54, 44 48 L 44 46" />
                                <rect x="40" y="40" width="8" height="6" rx="1.5" fill="#EE7C52" />
                            </svg>
                        </div>
                        <div class="service-icon-container" style="background: #FAF6F0; border-color: var(--border-default);">
                            <svg viewBox="0 0 64 64" width="36" height="36" fill="none" stroke="#2A5A53" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M32 46 C 26 46, 22 41, 24 35 C 25 31, 28 29, 32 30 C 36 29, 39 31, 40 35 C 42 41, 38 46, 32 46 Z" fill="#FFC107" />
                                <path d="M32 39 C 32 39, 29 36, 29 34 C 29 32, 31 31, 32 32.5 C 33 31, 35 32, 35 34 C 35 36, 32 39, 32 39 Z" fill="#EE7C52" stroke="#2A5A53" stroke-width="1.5" />
                                <circle cx="18" cy="24" r="4" fill="#FF8A65" />
                                <circle cx="27" cy="17" r="4" fill="#FF8A65" />
                                <circle cx="37" cy="17" r="4" fill="#FF8A65" />
                                <circle cx="46" cy="24" r="4" fill="#FF8A65" />
                            </svg>
                        </div>
                    </div>
                    <h3>Khám tổng quát</h3>
                    <p>Kiểm tra sức khỏe toàn diện.</p>
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-orange">Khám tổng quát <i class="bi bi-arrow-right"></i></a>
                </div>
                <div class="service-card" style="border-color: var(--border-green); box-shadow: var(--shadow-flat-green);">
                    <div class="service-icons-row">
                        <div class="service-icon-container green-icon">
                            <svg viewBox="0 0 64 64" width="36" height="36" fill="none" stroke="#2A5A53" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="22" y="16" width="12" height="28" rx="2" transform="rotate(-45 28 30)" fill="#FFF0EB" />
                                <rect x="23.5" y="28" width="9" height="14" transform="rotate(-45 28 30)" fill="#EE7C52" />
                                <path d="M14 44 L 8 50" />
                                <path d="M37 21 L 46 12" />
                                <path d="M42 8 L 50 16" />
                            </svg>
                        </div>
                    </div>
                    <h3>Tiêm phòng</h3>
                    <p>Bảo vệ thú cưng khỏi bệnh nguy hiểm.</p>
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-green">Tiêm phòng <i class="bi bi-arrow-right"></i></a>
                </div>
                <div class="service-card">
                    <div class="service-icons-row">
                        <div class="service-icon-container">
                            <svg viewBox="0 0 64 64" width="36" height="36" fill="none" stroke="#2A5A53" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 30 L 44 8" />
                                <path d="M42 30 L 20 8" />
                                <circle cx="32" cy="19" r="2.5" fill="#EE7C52" />
                                <circle cx="20" cy="42" r="7" fill="none" />
                                <path d="M22 30 Q 20 34, 20 42" />
                                <circle cx="44" cy="42" r="7" fill="none" />
                                <path d="M42 30 Q 44 34, 44 42" />
                            </svg>
                        </div>
                        <div class="service-icon-container" style="background: #FAF6F0; border-color: var(--border-default);">
                            <svg viewBox="0 0 64 64" width="36" height="36" fill="none" stroke="#2A5A53" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="12" y="22" width="40" height="22" rx="7" fill="#EE7C52" />
                                <text x="32" y="36" font-family="'Fredoka', sans-serif" font-size="10" font-weight="700" fill="#FFFFFF" text-anchor="middle" stroke="none">SOAP</text>
                                <circle cx="16" cy="16" r="3" fill="#FAF6F0" />
                                <circle cx="44" cy="16" r="4.5" fill="#FAF6F0" />
                                <circle cx="48" cy="11" r="2" fill="#FAF6F0" />
                                <circle cx="52" cy="20" r="3" fill="#FAF6F0" />
                            </svg>
                        </div>
                    </div>
                    <h3>Tắm & Grooming</h3>
                    <p>Vệ sinh và chăm sóc toàn diện.</p>
                    <a href="${pageContext.request.contextPath}/booking" class="btn btn-orange">Tắm & Grooming <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </section>

    <section id="why" class="section why-section">
        <div class="container">
            <div class="why-grid">
                <div class="why-text-content">
                    <h2 class="section-title">Vì sao chọn PetCare?</h2>
                    <p>
                        Chúng tôi tự hào đem lại môi trường chăm sóc y tế an toàn, thân thiện, và ngập tràn tình yêu thương dành cho những người bạn bốn chân.
                    </p>
                    <a href="#contact" class="btn btn-orange">Tìm Hiểu Thêm</a>
                </div>
                <div class="why-features">
                    <div class="why-feature">
                        <div class="why-feature-icon"><i class="bi bi-person-check"></i></div>
                        <div class="why-feature-content">
                            <h3>Đội ngũ bác sĩ giàu kinh nghiệm</h3>
                            <p>Tận tâm và chuyên môn cao.</p>
                        </div>
                    </div>
                    <div class="why-feature">
                        <div class="why-feature-icon"><i class="bi bi-heart-pulse"></i></div>
                        <div class="why-feature-content">
                            <h3>Trang thiết bị hiện đại</h3>
                            <p>Chẩn đoán và điều trị chính xác.</p>
                        </div>
                    </div>
                    <div class="why-feature">
                        <div class="why-feature-icon"><i class="bi bi-emoji-smile"></i></div>
                        <div class="why-feature-content">
                            <h3>Dịch vụ nhẹ nhàng, thân thiện</h3>
                            <p>Môi trường an toàn, thoải mái.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer id="contact" class="footer">
        <div class="container">
            <div class="footer-inner">
                <div class="footer-brand">
                    <img src="${pageContext.request.contextPath}/assets/images/petcare_logo_full.png" alt="PetCare Clinic" class="footer-logo">
                    <p>Đồng hành cùng bạn trên hành trình chăm sóc sức khỏe tốt nhất cho thú cưng mỗi ngày. 🐾</p>
                </div>
                <div class="footer-contact">
                    <div class="contact-item"><i class="bi bi-telephone"></i> 1900 1234 56</div>
                    <div class="contact-item"><i class="bi bi-envelope"></i> info@petcareclinic.vn</div>
                    <div class="contact-item"><i class="bi bi-geo-alt"></i> 392 Cao Thắng, Quận 10, TP. Hồ Chí Minh</div>
                </div>
            </div>
            <div class="footer-bottom">
                <div>&copy; 2026 PetCare Clinic. Bản quyền được bảo lưu.</div>
                <div>Thiết kế với tình yêu thương 🐾</div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script>
        function toggleMobileMenu() {
            const menu = document.querySelector('.nav-menu');
            if (menu.style.display === 'flex') {
                menu.style.display = 'none';
            } else {
                menu.style.display = 'flex';
                menu.style.flexDirection = 'column';
                menu.style.position = 'absolute';
                menu.style.top = '80px';
                menu.style.left = '5%';
                menu.style.width = '90%';
                menu.style.background = '#FFFFFF';
                menu.style.border = '2px solid var(--border-default)';
                menu.style.borderRadius = '24px';
                menu.style.padding = '20px';
                menu.style.boxShadow = 'var(--shadow-flat-default)';
                menu.style.zIndex = '1000';
            }
        }
    </script>
</body>

</html>
