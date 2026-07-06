package com.petcare.dao;

import com.petcare.config.DBConnection;
import com.petcare.model.Invoice;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public boolean existsByAppointmentId(int appointmentId) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createInvoiceFromAppointment(int appointmentId) {
        String lockSql = "SELECT id FROM invoices WHERE appointment_id = ? LIMIT 1 FOR UPDATE";
        String insertSql = "INSERT INTO invoices " +
                "(appointment_id, manual_customer_name, manual_pet_name, manual_service_name, total_amount, status) " +
                "SELECT a.id, u.full_name, p.name, GROUP_CONCAT(s.name SEPARATOR ', '), " +
                "SUM(ad.price_at_booking), 'UNPAID' " +
                "FROM appointments a " +
                "JOIN users u ON a.customer_id = u.id " +
                "JOIN pets p ON a.pet_id = p.id " +
                "JOIN appointment_details ad ON a.id = ad.appointment_id " +
                "JOIN services s ON ad.service_id = s.id " +
                "WHERE a.id = ? " +
                "GROUP BY a.id, u.full_name, p.name";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement lockPs = conn.prepareStatement(lockSql)) {
                lockPs.setInt(1, appointmentId);
                try (ResultSet rs = lockPs.executeQuery()) {
                    if (rs.next()) {
                        conn.commit();
                        return true;
                    }
                }
            }

            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                insertPs.setInt(1, appointmentId);
                boolean created = insertPs.executeUpdate() > 0;
                conn.commit();
                return created;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            if (e.getErrorCode() == 1062) {
                return true;
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
        return false;
    }

    public long getMonthlyPaidRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM invoices " +
                "WHERE status = 'PAID' AND MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean createForCompletedAppointment(int appointmentId) {
        return createInvoiceFromAppointment(appointmentId);
    }

    public boolean createManualInvoice(String customerName, String petName, String serviceName,
                                       BigDecimal totalAmount, String status, String paymentMethod) {
        String sql = "INSERT INTO invoices " +
                "(appointment_id, manual_customer_name, manual_pet_name, manual_service_name, " +
                "total_amount, status, payment_method, payment_date) " +
                "VALUES (NULL, ?, ?, ?, ?, ?, ?, CASE WHEN ? = 'PAID' THEN NOW() ELSE NULL END)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerName);
            ps.setString(2, petName);
            ps.setString(3, serviceName);
            ps.setBigDecimal(4, totalAmount);
            ps.setString(5, normalizeStatus(status));
            ps.setString(6, normalizePaymentMethod(paymentMethod));
            ps.setString(7, normalizeStatus(status));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInvoice(int invoiceId, String customerName, String petName, String serviceName,
                                 BigDecimal totalAmount, String status, String paymentMethod) {
        String sql = "UPDATE invoices " +
                "SET manual_customer_name = ?, manual_pet_name = ?, manual_service_name = ?, " +
                "total_amount = ?, status = ?, payment_method = ?, " +
                "payment_date = CASE WHEN ? = 'PAID' THEN COALESCE(payment_date, NOW()) ELSE payment_date END " +
                "WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String normalizedStatus = normalizeStatus(status);
            ps.setString(1, customerName);
            ps.setString(2, petName);
            ps.setString(3, serviceName);
            ps.setBigDecimal(4, totalAmount);
            ps.setString(5, normalizedStatus);
            ps.setString(6, normalizePaymentMethod(paymentMethod));
            ps.setString(7, normalizedStatus);
            ps.setInt(8, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInvoiceStatus(int invoiceId, String status) {
        return updatePaymentStatus(invoiceId, status, null);
    }

    public boolean updatePaymentStatus(int invoiceId, String status, String paymentMethod) {
        String normalizedStatus = normalizeStatus(status);
        String sql = "UPDATE invoices SET status = ?, payment_method = ?, payment_date = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, normalizedStatus);
            ps.setString(2, normalizePaymentMethod(paymentMethod));
            ps.setTimestamp(3, "PAID".equals(normalizedStatus) ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setInt(4, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Invoice> getAllInvoices() {
        return searchInvoices(null, null);
    }

    public List<Invoice> searchInvoices(String keyword, String statusFilter) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = baseSelectSql() +
                "HAVING (? = '' OR CAST(i.id AS CHAR) LIKE ? OR customer_name LIKE ?) " +
                "AND (? = '' OR i.status = ?) " +
                "ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchText = keyword == null ? "" : keyword.trim();
            String searchPattern = "%" + searchText + "%";
            String statusText = statusFilter == null ? "" : statusFilter.trim();
            ps.setString(1, searchText);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, statusText);
            ps.setString(5, statusText);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    invoices.add(mapInvoice(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }

    public List<Invoice> getInvoicesByCustomerId(int customerId) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = baseSelectSql() +
                "HAVING appointment_customer_id = ? " +
                "ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    invoices.add(mapInvoice(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }

    private String baseSelectSql() {
        return "SELECT i.*, a.customer_id AS appointment_customer_id, " +
                "COALESCE(i.manual_customer_name, u.full_name) AS customer_name, " +
                "COALESCE(i.manual_pet_name, p.name) AS pet_name, " +
                "COALESCE(i.manual_service_name, GROUP_CONCAT(s.name SEPARATOR ', ')) AS service_name, " +
                "a.appointment_date " +
                "FROM invoices i " +
                "LEFT JOIN appointments a ON i.appointment_id = a.id " +
                "LEFT JOIN users u ON a.customer_id = u.id " +
                "LEFT JOIN pets p ON a.pet_id = p.id " +
                "LEFT JOIN appointment_details ad ON a.id = ad.appointment_id " +
                "LEFT JOIN services s ON ad.service_id = s.id " +
                "GROUP BY i.id, i.appointment_id, i.manual_customer_name, i.manual_pet_name, " +
                "i.manual_service_name, i.total_amount, i.payment_method, i.status, i.payment_date, " +
                "i.created_at, a.customer_id, a.appointment_date, u.full_name, p.name ";
    }

    // Tìm kiếm và lấy danh sách hóa đơn phân trang
    public List<Invoice> searchInvoicesPaginated(String keyword, String statusFilter, int offset, int limit) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = baseSelectSql() +
                "HAVING (? = '' OR CAST(i.id AS CHAR) LIKE ? OR customer_name LIKE ?) " +
                "AND (? = '' OR i.status = ?) " +
                "ORDER BY i.created_at DESC " +
                "LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchText = keyword == null ? "" : keyword.trim();
            String searchPattern = "%" + searchText + "%";
            String statusText = statusFilter == null ? "" : statusFilter.trim();
            ps.setString(1, searchText);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, statusText);
            ps.setString(5, statusText);
            ps.setInt(6, limit);
            ps.setInt(7, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    invoices.add(mapInvoice(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }

    // Đếm số lượng hóa đơn theo từ khóa tìm kiếm (dùng subquery để bọc lại câu SELECT GROUP BY bên dưới)
    public int countSearchInvoices(String keyword, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM (" + baseSelectSql() +
                "HAVING (? = '' OR CAST(i.id AS CHAR) LIKE ? OR customer_name LIKE ?) " +
                "AND (? = '' OR i.status = ?)" +
                ") AS temp";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchText = keyword == null ? "" : keyword.trim();
            String searchPattern = "%" + searchText + "%";
            String statusText = statusFilter == null ? "" : statusFilter.trim();
            ps.setString(1, searchText);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, statusText);
            ps.setString(5, statusText);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Invoice invoice = new Invoice();
        invoice.setId(rs.getInt("id"));
        int appointmentId = rs.getInt("appointment_id");
        invoice.setAppointmentId(rs.wasNull() ? 0 : appointmentId);
        invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
        invoice.setPaymentMethod(rs.getString("payment_method"));
        invoice.setStatus(rs.getString("status"));
        invoice.setPaymentDate(rs.getTimestamp("payment_date"));
        invoice.setCreatedAt(rs.getTimestamp("created_at"));
        invoice.setAppointmentDate(rs.getTimestamp("appointment_date"));
        invoice.setCustomerName(rs.getString("customer_name"));
        invoice.setPetName(rs.getString("pet_name"));
        invoice.setServiceName(rs.getString("service_name"));
        return invoice;
    }

    private String normalizeStatus(String status) {
        if ("PAID".equals(status) || "CANCELLED".equals(status)) {
            return status;
        }
        return "UNPAID";
    }

    private String normalizePaymentMethod(String paymentMethod) {
        return paymentMethod == null || paymentMethod.trim().isEmpty() ? null : paymentMethod.trim();
    }
}
