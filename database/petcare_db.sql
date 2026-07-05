CREATE DATABASE IF NOT EXISTS petcare_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE petcare_db;
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    image_url VARCHAR(255),
    specialty VARCHAR(100),
    address VARCHAR(255),
    role ENUM('ADMIN', 'STAFF', 'CUSTOMER') NOT NULL DEFAULT 'CUSTOMER',
    status TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(12, 0) NOT NULL DEFAULT 0,
    description TEXT,
    status TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_services_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(50) NOT NULL,
    breed VARCHAR(50),
    age INT,
    weight DECIMAL(5,2),
    gender VARCHAR(20),
    image_url VARCHAR(255),
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    pet_id INT NOT NULL,
    staff_id INT,
    appointment_date DATETIME NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    reason TEXT,
    diagnosis TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS appointment_details (
    appointment_id INT NOT NULL,
    service_id INT NOT NULL,
    price_at_booking DECIMAL(12, 0) NOT NULL,
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NULL UNIQUE,
    manual_customer_name VARCHAR(100),
    manual_pet_name VARCHAR(100),
    manual_service_name VARCHAR(150),
    total_amount DECIMAL(12, 0) NOT NULL,
    payment_method ENUM('CASH', 'TRANSFER', 'CARD'),
    status ENUM('UNPAID', 'PAID', 'CANCELLED') NOT NULL DEFAULT 'UNPAID',
    payment_date DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO users (full_name, username, password, role, status) VALUES
('Administrator', 'admin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'ADMIN', 1);

INSERT IGNORE INTO services (name, price, description, status) VALUES
('Khám tổng quát', 200000, 'Khám sức khỏe tổng quát cho thú cưng, kiểm tra cân nặng, nhiệt độ, nhịp tim và tình trạng chung.', 1),
('Tiêm phòng', 300000, 'Tiêm vaccine phòng bệnh cho chó mèo theo lịch tiêm phòng tiêu chuẩn.', 1),
('Tẩy giun', 100000, 'Tẩy giun định kỳ cho thú cưng, phòng ngừa các bệnh ký sinh trùng đường ruột.', 1),
('Cắt tỉa lông', 150000, 'Dịch vụ cắt tỉa, tạo kiểu lông chuyên nghiệp cho thú cưng.', 1),
('Siêu âm', 500000, 'Siêu âm bụng kiểm tra các cơ quan nội tạng, phát hiện bệnh lý sớm.', 1),
('Khám da liễu', 250000, 'Khám và điều trị các bệnh về da, lông, nấm, ve rận cho thú cưng.', 1),
('Triệt sản thẩm mỹ', 600000, 'Phẫu thuật triệt sản an toàn, không đau cho chó mèo.', 1),
('Xét nghiệm máu', 400000, 'Xét nghiệm máu tổng quát phân tích các chỉ số sinh hóa cơ bản.', 1),
('Khám & Lấy cao răng', 350000, 'Vệ sinh răng miệng, cạo vôi răng bằng sóng siêu âm nhẹ nhàng.', 1),
('Cấp cứu 24/7', 800000, 'Dịch vụ cấp cứu và chăm sóc đặc biệt khẩn cấp cho thú cưng.', 1),
('Chụp X-Quang', 300000, 'Chụp phim kiểm tra xương khớp và các cơ quan nội tạng.', 1),
('Khách sạn thú cưng', 200000, 'Dịch vụ nội trú chăm sóc, cho ăn và lưu trú thú cưng qua đêm.', 1),
('Tư vấn dinh dưỡng', 180000, 'Đánh giá khẩu phần, cân nặng và xây dựng thực đơn phù hợp theo độ tuổi, giống loài.', 1),
('Khám tim mạch', 450000, 'Thăm khám tim mạch, nghe tim phổi và tư vấn theo dõi bệnh lý tim cho thú cưng.', 1),
('Khám hô hấp', 280000, 'Kiểm tra ho, khó thở, viêm đường hô hấp và các dấu hiệu bất thường khi vận động.', 1),
('Khám tiêu hóa', 260000, 'Tư vấn và điều trị nôn ói, tiêu chảy, biếng ăn, rối loạn tiêu hóa.', 1),
('Khám mắt', 220000, 'Kiểm tra mắt đỏ, chảy nước mắt, đục thủy tinh thể và các bệnh lý nhãn khoa cơ bản.', 1),
('Khám tai mũi họng', 220000, 'Kiểm tra viêm tai, ngứa tai, mùi hôi tai và vệ sinh tai chuyên sâu.', 1),
('Nội soi tai', 350000, 'Nội soi kiểm tra ống tai, dị vật, viêm nhiễm và tổn thương bên trong.', 1),
('Xét nghiệm phân', 180000, 'Tầm soát ký sinh trùng, vi khuẩn đường ruột và hỗ trợ chẩn đoán tiêu hóa.', 1),
('Xét nghiệm nước tiểu', 220000, 'Kiểm tra chức năng tiết niệu, dấu hiệu viêm nhiễm và nguy cơ sỏi.', 1),
('Test bệnh truyền nhiễm', 450000, 'Test nhanh các bệnh phổ biến ở chó mèo như parvo, care, giảm bạch cầu.', 1),
('Chăm sóc hậu phẫu', 300000, 'Theo dõi vết mổ, thay băng, vệ sinh và kiểm tra phục hồi sau phẫu thuật.', 1),
('Thay băng vết thương', 120000, 'Làm sạch, sát khuẩn và thay băng các vết thương nhỏ hoặc sau phẫu thuật.', 1),
('Cắt móng & vệ sinh tai', 90000, 'Cắt móng, mài móng và vệ sinh tai cơ bản cho chó mèo.', 1),
('Tắm trị liệu da', 220000, 'Tắm bằng sản phẩm chuyên dụng cho thú cưng bị nấm, viêm da, ngứa hoặc rụng lông.', 1),
('Spa khử mùi', 180000, 'Tắm, sấy, chải lông và khử mùi nhẹ nhàng cho thú cưng.', 1),
('Gỡ rối lông', 160000, 'Gỡ rối, chải xù và xử lý lông bết trước khi grooming.', 1),
('Nhuộm lông an toàn', 300000, 'Tạo điểm nhấn màu lông bằng sản phẩm an toàn, phù hợp cho thú cưng khỏe mạnh.', 1),
('Vệ sinh tuyến hôi', 120000, 'Vệ sinh tuyến hôi giúp giảm mùi, khó chịu và nguy cơ viêm nhiễm.', 1),
('Khách sạn phòng riêng', 350000, 'Lưu trú phòng riêng, cập nhật tình trạng mỗi ngày và chăm sóc theo lịch cá nhân.', 1),
('Đưa đón thú cưng', 150000, 'Hỗ trợ đưa đón thú cưng trong khu vực nội thành theo lịch hẹn.', 1),
('Gói kiểm tra senior', 750000, 'Gói kiểm tra sức khỏe cho thú cưng lớn tuổi gồm khám tổng quát và xét nghiệm cơ bản.', 1),
('Gói puppy/kitten đầu đời', 650000, 'Tư vấn chăm sóc, tiêm phòng, tẩy giun và kiểm tra sức khỏe cho thú cưng nhỏ.', 1),
('Tư vấn hành vi', 300000, 'Tư vấn các vấn đề căng thẳng, sủa nhiều, cắn phá, đi vệ sinh sai chỗ.', 1),
('Cấp cứu ngoài giờ', 950000, 'Tiếp nhận tình huống khẩn cấp ngoài giờ hành chính với đội ngũ trực hỗ trợ.', 1);
