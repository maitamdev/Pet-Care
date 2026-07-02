USE petcare_db;

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

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
              AND table_name = 'invoices'
              AND column_name = 'appointment_id'
              AND is_nullable = 'NO'
        ),
        'ALTER TABLE invoices MODIFY appointment_id INT NULL',
        'SELECT 1'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        NOT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
              AND table_name = 'invoices'
              AND column_name = 'manual_customer_name'
        ),
        'ALTER TABLE invoices ADD COLUMN manual_customer_name VARCHAR(100) NULL AFTER appointment_id',
        'SELECT 1'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        NOT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
              AND table_name = 'invoices'
              AND column_name = 'manual_pet_name'
        ),
        'ALTER TABLE invoices ADD COLUMN manual_pet_name VARCHAR(100) NULL AFTER manual_customer_name',
        'SELECT 1'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(
        NOT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
              AND table_name = 'invoices'
              AND column_name = 'manual_service_name'
        ),
        'ALTER TABLE invoices ADD COLUMN manual_service_name VARCHAR(150) NULL AFTER manual_pet_name',
        'SELECT 1'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

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
    i.manual_customer_name = COALESCE(i.manual_customer_name, x.customer_name),
    i.manual_pet_name = COALESCE(i.manual_pet_name, x.pet_name),
    i.manual_service_name = COALESCE(i.manual_service_name, x.service_name)
WHERE i.appointment_id IS NOT NULL;
