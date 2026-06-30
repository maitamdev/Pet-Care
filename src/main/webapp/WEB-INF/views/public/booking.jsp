<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Khám - PetCare Clinic</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .booking-section {
            padding: 140px 0 100px;
            min-height: 90vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .booking-card {
            background: #FFFFFF;
            border: 2px solid var(--border-orange);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow-flat-orange);
            padding: 48px;
            width: 100%;
            max-width: 1100px;
        }

        .booking-card h2 {
            margin-bottom: 8px;
            color: var(--text-dark);
            font-size: 2.25rem;
        }

        .booking-card p.subtitle {
            margin-bottom: 32px;
            color: var(--text-body);
            font-size: 1.05rem;
            font-weight: 500;
        }

        .form-group {
            margin-bottom: 24px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-dark);
        }

        .form-control {
            font-family: 'Fredoka', sans-serif;
            font-size: 1rem;
            padding: 12px 16px;
            border: 2px solid var(--border-default);
            border-radius: var(--radius-sm);
            background: #FAF6F0;
            color: var(--text-dark);
            outline: none;
            transition: border-color 0.2s ease, background-color 0.2s ease;
        }

        .form-control:focus {
            border-color: var(--accent-orange);
            background: #FFFFFF;
        }

        .quick-pet-fields {
            background: rgba(238, 124, 82, 0.03);
            border: 2px dashed var(--border-orange);
            border-radius: var(--radius-md);
            padding: 24px;
            margin-bottom: 24px;
            display: none; /* Toggled via JS */
            flex-direction: column;
            gap: 16px;
        }

        .quick-pet-fields.show-fields {
            display: flex;
        }

        .quick-pet-fields-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .alert-error {
            background: #FDF3E7;
            border: 2px solid var(--border-orange);
            color: var(--accent-orange);
            padding: 16px;
            border-radius: var(--radius-sm);
            margin-bottom: 24px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 24px;
            font-weight: 600;
            color: var(--text-light);
            transition: color 0.2s ease;
        }
        
        .back-link:hover {
            color: var(--accent-orange);
        }

        /* Redesign Specific styles */
        .step-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 32px;
            margin-bottom: 16px;
            border-bottom: 2px solid var(--border-default);
            padding-bottom: 8px;
        }
        
        .step-num {
            background: var(--accent-orange);
            color: #FFFFFF;
            font-family: 'Fredoka', sans-serif;
            font-weight: 700;
            font-size: 0.9rem;
            width: 24px;
            height: 24px;
            border-radius: var(--radius-full);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .step-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0;
        }

        .pet-cards-grid, .service-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        
        .card-item {
            background: #FFFFFF;
            border: 2px solid var(--border-default);
            border-radius: var(--radius-md);
            padding: 20px 16px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            cursor: pointer;
            position: relative;
            transition: transform var(--transition-bubbly), border-color 0.2s ease, box-shadow 0.2s ease;
        }
        
        .card-item:hover {
            transform: translateY(-4px);
            border-color: var(--border-orange);
        }
        
        .card-item.selected {
            border-color: var(--accent-orange);
            background: rgba(238, 124, 82, 0.02);
            box-shadow: var(--shadow-flat-orange);
            transform: translateY(-2px);
        }
        
        .card-item-icon {
            font-size: 2rem;
            margin-bottom: 12px;
            color: var(--primary);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: color 0.2s ease;
        }
        
        .card-item.selected .card-item-icon {
            color: var(--accent-orange);
        }
        
        .card-item-title {
            font-weight: 700;
            color: var(--text-dark);
            font-size: 1rem;
            margin-bottom: 4px;
        }
        
        .card-item-subtitle {
            font-size: 0.85rem;
            color: var(--text-light);
            font-weight: 500;
        }
        
        .card-item-price {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--accent-orange);
            margin-top: 4px;
        }

        .card-item-check {
            position: absolute;
            top: 8px;
            right: 8px;
            width: 20px;
            height: 20px;
            background: var(--accent-orange);
            color: white;
            border-radius: var(--radius-full);
            display: none;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: bold;
        }
        
        .card-item.selected .card-item-check {
            display: flex;
        }

        .segmented-control {
            display: flex;
            background: var(--primary-light);
            border: 2px solid var(--border-green);
            border-radius: var(--radius-full);
            padding: 4px;
            gap: 4px;
            margin-bottom: 8px;
        }
        
        .segment-btn {
            flex: 1;
            text-align: center;
            padding: 10px 16px;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-dark);
            border-radius: var(--radius-full);
            cursor: pointer;
            transition: background-color 0.2s ease, color 0.2s ease;
        }
        
        .segment-btn:hover {
            background: rgba(42, 90, 83, 0.08);
        }
        
        .segment-btn.active {
            background: var(--primary);
            color: #FFFFFF;
        }

        /* 2-Column Booking Layout */
        .booking-form-grid {
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap: 36px;
            align-items: start;
            margin-top: 24px;
        }

        .booking-form-left {
            display: flex;
            flex-direction: column;
        }
        
        .booking-form-right {
            display: flex;
            flex-direction: column;
            background: rgba(238, 124, 82, 0.02);
            border: 2px solid var(--border-orange);
            border-radius: var(--radius-lg);
            padding: 32px;
            position: sticky;
            top: 110px;
            box-shadow: 0 8px 30px rgba(238, 124, 82, 0.03);
        }
        
        @media (max-w: 992px) {
            .booking-form-grid {
                grid-template-columns: 1fr;
                gap: 28px;
            }
            .booking-form-right {
                position: static;
                padding: 24px;
            }
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
            <button class="mobile-toggle" onclick="toggleMobileMenu()">☰</button>
        </div>
    </header>

    <section class="booking-section">
        <div class="booking-card">
            <h2>Đặt Lịch Khám</h2>
            <p class="subtitle">Đăng ký lịch hẹn khám sức khỏe cho bé cưng của bạn nhanh chóng 🐾</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert-error">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/booking" method="POST">
                <div class="booking-form-grid">
                    <!-- Left Column -->
                    <div class="booking-form-left">
                        <!-- STEP 1: Select Pet -->
                        <div class="step-header" style="margin-top: 0;">
                            <div class="step-num">1</div>
                            <h3 class="step-title">Chọn bé đi khám</h3>
                        </div>
                        
                        <div class="form-group">
                            <div class="pet-cards-grid">
                                <c:forEach var="pet" items="${listPets}">
                                    <div class="card-item pet-card-item" data-value="${pet.id}" onclick="selectPetCard('${pet.id}')">
                                        <div class="card-item-check"><i class="bi bi-check-lg"></i></div>
                                        <div class="card-item-icon">
                                            <i class="bi bi-patch-check-fill"></i>
                                        </div>
                                        <div class="card-item-title">${pet.name}</div>
                                        <div class="card-item-subtitle">${pet.species}</div>
                                    </div>
                                </c:forEach>
                                <div class="card-item pet-card-item" data-value="-1" id="addPetCard" onclick="selectPetCard('-1')">
                                    <div class="card-item-check"><i class="bi bi-check-lg"></i></div>
                                    <div class="card-item-icon">
                                        <i class="bi bi-plus-circle"></i>
                                    </div>
                                    <div class="card-item-title">Thêm bé mới</div>
                                    <div class="card-item-subtitle">Đăng ký hồ sơ</div>
                                </div>
                            </div>
                            
                            <!-- Hidden native select for backend compatibility -->
                            <select name="petId" id="petId" class="form-control" onchange="toggleQuickPetFields()" style="display: none;">
                                <c:forEach var="pet" items="${listPets}">
                                    <option value="${pet.id}">${pet.name} (${pet.species})</option>
                                </c:forEach>
                                <option value="-1" ${empty listPets ? 'selected' : ''}>+ Thêm thú cưng mới</option>
                            </select>
                        </div>

                        <!-- Quick Pet Fields (Active if no pets exist or + Create new pet is selected) -->
                        <div class="quick-pet-fields ${empty listPets ? 'show-fields' : ''}" id="quickPetSection">
                            <h4 style="color: var(--text-dark); margin-bottom: 8px; font-weight: 700;">Thông tin thú cưng mới</h4>
                            <div class="form-group">
                                <label for="newPetName">Tên bé *</label>
                                <input type="text" name="newPetName" id="newPetName" class="form-control" placeholder="Nhập tên bé cưng" ${empty listPets ? 'required' : ''}>
                            </div>
                            
                            <div class="quick-pet-fields-grid">
                                <div class="form-group">
                                    <label>Loài</label>
                                    <div class="segmented-control" id="speciesSegmented">
                                        <div class="segment-btn active" data-value="Chó" onclick="selectSegment('newPetSpecies', this)">Chó</div>
                                        <div class="segment-btn" data-value="Mèo" onclick="selectSegment('newPetSpecies', this)">Mèo</div>
                                        <div class="segment-btn" data-value="Khác" onclick="selectSegment('newPetSpecies', this)">Khác</div>
                                    </div>
                                    <input type="hidden" name="newPetSpecies" id="newPetSpecies" value="Chó">
                                </div>
                                
                                <div class="form-group">
                                    <label>Giới tính</label>
                                    <div class="segmented-control" id="genderSegmented">
                                        <div class="segment-btn active" data-value="Đực" onclick="selectSegment('newPetGender', this)">Đực</div>
                                        <div class="segment-btn" data-value="Cái" onclick="selectSegment('newPetGender', this)">Cái</div>
                                    </div>
                                    <input type="hidden" name="newPetGender" id="newPetGender" value="Đực">
                                </div>
                            </div>
                            
                            <div class="quick-pet-fields-grid">
                                <div class="form-group">
                                    <label for="newPetBreed">Giống loài (VD: Poodle, Ba Tư)</label>
                                    <input type="text" name="newPetBreed" id="newPetBreed" class="form-control" placeholder="Nhập giống">
                                </div>
                                <div class="form-group">
                                    <label for="newPetAge">Tuổi</label>
                                    <input type="number" name="newPetAge" id="newPetAge" class="form-control" placeholder="Nhập số tuổi" min="0">
                                </div>
                            </div>
                        </div>

                        <!-- STEP 2: Select Service -->
                        <div class="step-header">
                            <div class="step-num">2</div>
                            <h3 class="step-title">Chọn dịch vụ chăm sóc</h3>
                        </div>
                        
                        <div class="form-group">
                            <div class="service-cards-grid">
                                <c:forEach var="service" items="${listServices}">
                                    <div class="card-item service-card-item" data-value="${service.id}" onclick="selectServiceCard('${service.id}')">
                                        <div class="card-item-check"><i class="bi bi-check-lg"></i></div>
                                        <div class="card-item-icon">
                                            <c:choose>
                                                <c:when test="${service.name == 'Khám tổng quát'}">
                                                    <i class="bi bi-clipboard2-pulse-fill"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Tiêm phòng'}">
                                                    <i class="bi bi-shield-plus"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Tẩy giun'}">
                                                    <i class="bi bi-capsule"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Cắt tỉa lông' || service.name == 'Tắm & Grooming'}">
                                                    <i class="bi bi-scissors"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Siêu âm'}">
                                                    <i class="bi bi-activity"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Khám da liễu'}">
                                                    <i class="bi bi-microscope"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Triệt sản thẩm mỹ'}">
                                                    <i class="bi bi-heart-pulse-fill"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Xét nghiệm máu'}">
                                                    <i class="bi bi-droplet-fill"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Khám & Lấy cao răng'}">
                                                    <i class="bi bi-emoji-smile-fill"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Cấp cứu 24/7'}">
                                                    <i class="bi bi-telephone-fill" style="color: #DC3545;"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Chụp X-Quang'}">
                                                    <i class="bi bi-file-earmark-medical-fill"></i>
                                                </c:when>
                                                <c:when test="${service.name == 'Khách sạn thú cưng'}">
                                                    <i class="bi bi-house-heart-fill"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-heart-fill"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="card-item-title">${service.name}</div>
                                        <div class="card-item-price">${service.price}đ</div>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <!-- Hidden native select for backend compatibility -->
                            <select name="serviceId" id="serviceId" class="form-control" required style="display: none;">
                                <c:forEach var="service" items="${listServices}">
                                    <option value="${service.id}">${service.name} (${service.price}đ)</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Right Column -->
                    <div class="booking-form-right">
                        <!-- STEP 3: Date & Time -->
                        <div class="step-header" style="margin-top: 0;">
                            <div class="step-num">3</div>
                            <h3 class="step-title">Chọn lịch hẹn</h3>
                        </div>
                        
                        <div class="form-group">
                            <label for="date">Ngày khám *</label>
                            <input type="date" name="date" id="date" class="form-control" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>
                        <div class="form-group">
                            <label for="time">Giờ khám *</label>
                            <input type="time" name="time" id="time" class="form-control" required>
                        </div>

                        <!-- STEP 4: Symptoms -->
                        <div class="step-header">
                            <div class="step-num">4</div>
                            <h3 class="step-title">Ghi chú triệu chứng</h3>
                        </div>
                        
                        <div class="form-group">
                            <label for="reason">Mô tả triệu chứng / Lý do khám</label>
                            <textarea name="reason" id="reason" class="form-control" rows="3" placeholder="Ví dụ: Khám sức khỏe định kỳ, Bé lười ăn 2 ngày nay..."></textarea>
                        </div>

                        <button type="submit" class="btn btn-green" style="width: 100%; margin-top: 16px; font-weight: 700; font-size: 1.1rem; padding: 14px;">Xác Nhận Đặt Lịch ➔</button>
                    </div>
                </div>
            </form>

            <a href="${pageContext.request.contextPath}/home" class="back-link"><i class="bi bi-arrow-left"></i> Quay về trang chủ</a>
        </div>
    </section>

    <script>
        function toggleQuickPetFields() {
            const petIdSelect = document.getElementById('petId');
            const quickPetSection = document.getElementById('quickPetSection');
            const newPetName = document.getElementById('newPetName');
            
            if (petIdSelect.value === '-1') {
                quickPetSection.style.display = 'flex';
                newPetName.setAttribute('required', 'required');
            } else {
                quickPetSection.style.display = 'none';
                newPetName.removeAttribute('required');
            }
        }

        function selectPetCard(petId) {
            // Remove active classes
            document.querySelectorAll('.pet-card-item').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add active class to selected card
            const selectedCard = document.querySelector('.pet-card-item[data-value="' + petId + '"]');
            if (selectedCard) {
                selectedCard.classList.add('selected');
            }
            
            // Update hidden select
            const petSelect = document.getElementById('petId');
            petSelect.value = petId;
            
            // Toggle form fields
            toggleQuickPetFields();
        }

        // Select Service
        function selectServiceCard(serviceId) {
            // Remove active classes
            document.querySelectorAll('.service-card-item').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add active class to selected card
            const selectedCard = document.querySelector('.service-card-item[data-value="' + serviceId + '"]');
            if (selectedCard) {
                selectedCard.classList.add('selected');
            }
            
            // Update hidden select
            const serviceSelect = document.getElementById('serviceId');
            serviceSelect.value = serviceId;
        }

        function selectSegment(inputName, btnEl) {
            // Remove active from all buttons in same segmented control
            const container = btnEl.parentElement;
            container.querySelectorAll('.segment-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Set active
            btnEl.classList.add('active');
            
            // Set value
            document.getElementById(inputName).value = btnEl.getAttribute('data-value');
        }

        // Set default values and setup initial UI state
        document.addEventListener('DOMContentLoaded', () => {
            // Set default minimum date to today
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('date').min = today;

            // Initialize default pet card selection
            const petSelect = document.getElementById('petId');
            if (petSelect && petSelect.options.length > 0) {
                const defaultPetVal = petSelect.value;
                selectPetCard(defaultPetVal);
            } else {
                selectPetCard('-1');
            }

            // Initialize default service card selection
            const serviceSelect = document.getElementById('serviceId');
            if (serviceSelect && serviceSelect.options.length > 0) {
                selectServiceCard(serviceSelect.value);
            }
        });

        // Mobile Menu toggle
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
