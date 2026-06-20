CREATE DATABASE IF NOT EXISTS petcare_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE petcare_db;

CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    role        ENUM('ADMIN', 'STAFF') NOT NULL DEFAULT 'STAFF',
    status      TINYINT(1)   NOT NULL DEFAULT 1,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (full_name, username, password, role, status) VALUES
('Administrator', 'admin', '123456', 'ADMIN', 1);

CREATE TABLE IF NOT EXISTS services (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    price       DECIMAL(12, 0) NOT NULL DEFAULT 0,
    description TEXT,
    status      TINYINT(1) NOT NULL DEFAULT 1,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO services (name, price, description, status) VALUES
('Khám tổng quát', 200000, 'Khám sức khỏe tổng quát cho thú cưng, kiểm tra cân nặng, nhiệt độ, nhịp tim và tình trạng chung.', 1),
('Tiêm phòng', 300000, 'Tiêm vaccine phòng bệnh cho chó mèo theo lịch tiêm phòng tiêu chuẩn.', 1),
('Tẩy giun', 100000, 'Tẩy giun định kỳ cho thú cưng, phòng ngừa các bệnh ký sinh trùng đường ruột.', 1),
('Cắt tỉa lông', 150000, 'Dịch vụ cắt tỉa, tạo kiểu lông chuyên nghiệp cho thú cưng.', 1),
('Siêu âm', 500000, 'Siêu âm bụng kiểm tra các cơ quan nội tạng, phát hiện bệnh lý sớm.', 1),
('Khám da liễu', 250000, 'Khám và điều trị các bệnh về da, lông, nấm, ve rận cho thú cưng.', 1);
