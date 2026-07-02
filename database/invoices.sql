-- tạo bảng invoices để lưu thông tin hóa đơn từ các lịch hẹn đã hoàn thành tự động
CREATE TABLE `invoices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int DEFAULT NULL,
  `manual_customer_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manual_pet_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manual_service_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_amount` decimal(12,0) NOT NULL,
  `payment_method` enum('CASH','TRANSFER','CARD') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('UNPAID','PAID','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNPAID',
  `payment_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `appointment_id` (`appointment_id`),
  CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng tạo hóa đơn thủ công
ALTER TABLE invoices
    MODIFY appointment_id INT NULL;

ALTER TABLE invoices
    ADD COLUMN manual_customer_name VARCHAR(100) NULL AFTER appointment_id,
    ADD COLUMN manual_pet_name VARCHAR(100) NULL AFTER manual_customer_name,
    ADD COLUMN manual_service_name VARCHAR(150) NULL AFTER manual_pet_name;

-- lịch hẹn có nhiều dịch vụ, nên cần lưu tên dịch vụ trong hóa đơn
UPDATE invoices i
JOIN (
    SELECT 
        a.id AS appointment_id,
        u.full_name AS customer_name,
        p.name AS pet_name,
        GROUP_CONCAT(s.name SEPARATOR ', ') AS service_name
    FROM appointments a
    JOIN users u ON a.customer_id = u.id
    JOIN pets p ON a.pet_id = p.id
    JOIN appointment_details ad ON a.id = ad.appointment_id
    JOIN services s ON ad.service_id = s.id
    GROUP BY a.id, u.full_name, p.name
) x ON i.appointment_id = x.appointment_id
SET 
    i.manual_customer_name = x.customer_name,
    i.manual_pet_name = x.pet_name,
    i.manual_service_name = x.service_name
WHERE i.appointment_id IS NOT NULL
  AND (
      i.manual_customer_name IS NULL
      OR i.manual_pet_name IS NULL
      OR i.manual_service_name IS NULL
  );

-- check lại dữ liệu trong bảng invoices
SELECT *
FROM invoices
ORDER BY id DESC;