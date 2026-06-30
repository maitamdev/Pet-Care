CREATE DATABASE IF NOT EXISTS petcare_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE petcare_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    image_url VARCHAR(255),
    specialty VARCHAR(100),
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
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
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
    appointment_id INT NOT NULL UNIQUE,
    total_amount DECIMAL(12, 0) NOT NULL,
    payment_method ENUM('CASH', 'TRANSFER', 'CARD'),
    status ENUM('UNPAID', 'PAID', 'CANCELLED') NOT NULL DEFAULT 'UNPAID',
    payment_date DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (full_name, username, password, role, status) VALUES
('Administrator', 'admin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'ADMIN', 1);

INSERT INTO services (name, price, description, status) VALUES
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
('Khách sạn thú cưng', 200000, 'Dịch vụ nội trú chăm sóc, cho ăn và lưu trữ thú cưng qua đêm.', 1);
