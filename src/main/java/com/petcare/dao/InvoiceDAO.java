package com.petcare.dao;

import com.petcare.config.DBConnection;
import com.petcare.model.Invoice;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public boolean createForCompletedAppointment(int appointmentId) {
        String totalSql = "SELECT SUM(price_at_booking) AS total FROM appointment_details WHERE appointment_id = ?";
        String insertSql = "INSERT IGNORE INTO invoices (appointment_id, total_amount, status) VALUES (?, ?, 'UNPAID')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement totalPs = conn.prepareStatement(totalSql);
             PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
            totalPs.setInt(1, appointmentId);
            BigDecimal total = BigDecimal.ZERO;
            try (ResultSet rs = totalPs.executeQuery()) {
                if (rs.next() && rs.getBigDecimal("total") != null) {
                    total = rs.getBigDecimal("total");
                }
            }

            insertPs.setInt(1, appointmentId);
            insertPs.setBigDecimal(2, total);
            insertPs.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Invoice> getAllInvoices() {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.*, u.full_name AS customer_name, p.name AS pet_name, s.name AS service_name " +
                "FROM invoices i " +
                "JOIN appointments a ON i.appointment_id = a.id " +
                "JOIN users u ON a.customer_id = u.id " +
                "JOIN pets p ON a.pet_id = p.id " +
                "JOIN appointment_details ad ON a.id = ad.appointment_id " +
                "JOIN services s ON ad.service_id = s.id " +
                "ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                invoices.add(mapInvoice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }

    public List<Invoice> getInvoicesByCustomerId(int customerId) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.*, u.full_name AS customer_name, p.name AS pet_name, s.name AS service_name " +
                "FROM invoices i " +
                "JOIN appointments a ON i.appointment_id = a.id " +
                "JOIN users u ON a.customer_id = u.id " +
                "JOIN pets p ON a.pet_id = p.id " +
                "JOIN appointment_details ad ON a.id = ad.appointment_id " +
                "JOIN services s ON ad.service_id = s.id " +
                "WHERE a.customer_id = ? " +
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

    public boolean updatePaymentStatus(int invoiceId, String status, String paymentMethod) {
        if (!"UNPAID".equals(status) && !"PAID".equals(status) && !"CANCELLED".equals(status)) {
            return false;
        }
        String method = paymentMethod == null || paymentMethod.trim().isEmpty() ? null : paymentMethod.trim();
        String sql = "UPDATE invoices SET status = ?, payment_method = ?, payment_date = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, method);
            ps.setTimestamp(3, "PAID".equals(status) ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setInt(4, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Invoice invoice = new Invoice();
        invoice.setId(rs.getInt("id"));
        invoice.setAppointmentId(rs.getInt("appointment_id"));
        invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
        invoice.setPaymentMethod(rs.getString("payment_method"));
        invoice.setStatus(rs.getString("status"));
        invoice.setPaymentDate(rs.getTimestamp("payment_date"));
        invoice.setCreatedAt(rs.getTimestamp("created_at"));
        invoice.setCustomerName(rs.getString("customer_name"));
        invoice.setPetName(rs.getString("pet_name"));
        invoice.setServiceName(rs.getString("service_name"));
        return invoice;
    }
}
