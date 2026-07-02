--tạo bảng invoices để lưu thông tin hóa đơn từ các lịch hẹn đã hoàn thành tự động
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

--Bảng tạo hóa đơn thủ công
ALTER TABLE invoices
    MODIFY appointment_id INT NULL;

ALTER TABLE invoices
    ADD COLUMN manual_customer_name VARCHAR(100) NULL AFTER appointment_id,
    ADD COLUMN manual_pet_name VARCHAR(100) NULL AFTER manual_customer_name,
    ADD COLUMN manual_service_name VARCHAR(150) NULL AFTER manual_pet_name;