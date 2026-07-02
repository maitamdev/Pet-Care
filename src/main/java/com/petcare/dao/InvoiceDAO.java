package com.petcare.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.petcare.config.DBConnection;
import com.petcare.model.Invoice;

public class InvoiceDAO {

    public boolean existsByAppointmentId(int appointmentId) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE appointment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean createInvoiceFromAppointment(int appointmentId) {
        if (existsByAppointmentId(appointmentId)) {
            return true;
        }

        String sql = "INSERT INTO invoices " +
             "(appointment_id, manual_customer_name, manual_pet_name, manual_service_name, total_amount, status) " +
             "SELECT a.id, u.full_name, p.name, GROUP_CONCAT(s.name SEPARATOR ', '), SUM(ad.price_at_booking), 'UNPAID' " +
             "FROM appointments a " +
             "JOIN users u ON a.customer_id = u.id " +
             "JOIN pets p ON a.pet_id = p.id " +
             "JOIN appointment_details ad ON a.id = ad.appointment_id " +
             "JOIN services s ON ad.service_id = s.id " +
             "WHERE a.id = ? " +
             "GROUP BY a.id, u.full_name, p.name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean createManualInvoice(String customerName, String petName, String serviceName,
                                   BigDecimal totalAmount, String status, String paymentMethod) {
        String sql = "INSERT INTO invoices " +
                    "(appointment_id, manual_customer_name, manual_pet_name, manual_service_name, total_amount, status, payment_method, payment_date) " +
                    "VALUES (NULL, ?, ?, ?, ?, ?, ?, CASE WHEN ? = 'PAID' THEN NOW() ELSE NULL END)";

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerName);
            ps.setString(2, petName);
            ps.setString(3, serviceName);
            ps.setBigDecimal(4, totalAmount);
            ps.setString(5, status);
            ps.setString(6, paymentMethod);
            ps.setString(7, status);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateInvoiceStatus(int invoiceId, String status) {
        String sql = "UPDATE invoices " +
                    "SET status = ?, " +
                    "payment_date = CASE WHEN ? = 'PAID' THEN NOW() ELSE payment_date END " +
                    "WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, status);
            ps.setInt(3, invoiceId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    public boolean updateInvoice(int invoiceId, String customerName, String petName, String serviceName,
                                BigDecimal totalAmount, String status, String paymentMethod) {
        String sql = "UPDATE invoices " +
                    "SET manual_customer_name = ?, " +
                    "manual_pet_name = ?, " +
                    "manual_service_name = ?, " +
                    "total_amount = ?, " +
                    "status = ?, " +
                    "payment_method = ?, " +
                    "payment_date = CASE WHEN ? = 'PAID' THEN NOW() ELSE payment_date END " +
                    "WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerName);
            ps.setString(2, petName);
            ps.setString(3, serviceName);
            ps.setBigDecimal(4, totalAmount);
            ps.setString(5, status);
            ps.setString(6, paymentMethod);
            ps.setString(7, status);
            ps.setInt(8, invoiceId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();

        String sql = "SELECT i.*, " +
        "COALESCE(i.manual_customer_name, u.full_name) AS display_customer_name, " +
        "COALESCE(i.manual_pet_name, p.name) AS display_pet_name, " +
        "COALESCE(i.manual_service_name, s.name) AS display_service_name, " +
        "a.appointment_date " +
        "FROM invoices i " +
        "LEFT JOIN appointments a ON i.appointment_id = a.id " +
        "LEFT JOIN users u ON a.customer_id = u.id " +
        "LEFT JOIN pets p ON a.pet_id = p.id " +
        "LEFT JOIN appointment_details ad ON a.id = ad.appointment_id " +
        "LEFT JOIN services s ON ad.service_id = s.id " +
        "ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
                invoice.setAppointmentId(rs.getInt("appointment_id"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setPaymentMethod(rs.getString("payment_method"));
                invoice.setStatus(rs.getString("status"));
                invoice.setPaymentDate(rs.getTimestamp("payment_date"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setAppointmentDate(rs.getTimestamp("appointment_date"));

                invoice.setCustomerName(rs.getString("display_customer_name"));
                invoice.setPetName(rs.getString("display_pet_name"));
                invoice.setServiceName(rs.getString("display_service_name"));

                list.add(invoice);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Invoice> searchInvoices(String keyword, String statusFilter) {
        List<Invoice> list = new ArrayList<>();

        String sql = "SELECT i.*, " +
                "COALESCE(i.manual_customer_name, u.full_name) AS display_customer_name, " +
                "COALESCE(i.manual_pet_name, p.name) AS display_pet_name, " +
                "COALESCE(i.manual_service_name, s.name) AS display_service_name, " +
                "a.appointment_date " +
                "FROM invoices i " +
                "LEFT JOIN appointments a ON i.appointment_id = a.id " +
                "LEFT JOIN users u ON a.customer_id = u.id " +
                "LEFT JOIN pets p ON a.pet_id = p.id " +
                "LEFT JOIN appointment_details ad ON a.id = ad.appointment_id " +
                "LEFT JOIN services s ON ad.service_id = s.id " +
                "WHERE (? IS NULL OR ? = '' OR i.id LIKE ? OR COALESCE(i.manual_customer_name, u.full_name) LIKE ?) " +
                "AND (? IS NULL OR ? = '' OR i.status = ?) " +
                "ORDER BY i.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchText = keyword == null ? "" : keyword.trim();
            String searchPattern = "%" + searchText + "%";
            String statusText = statusFilter == null ? "" : statusFilter.trim();

            ps.setString(1, searchText);
            ps.setString(2, searchText);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);

            ps.setString(5, statusText);
            ps.setString(6, statusText);
            ps.setString(7, statusText);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice invoice = new Invoice();

                    invoice.setId(rs.getInt("id"));
                    invoice.setAppointmentId(rs.getInt("appointment_id"));
                    invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                    invoice.setPaymentMethod(rs.getString("payment_method"));
                    invoice.setStatus(rs.getString("status"));
                    invoice.setPaymentDate(rs.getTimestamp("payment_date"));
                    invoice.setCreatedAt(rs.getTimestamp("created_at"));
                    invoice.setAppointmentDate(rs.getTimestamp("appointment_date"));

                    invoice.setCustomerName(rs.getString("display_customer_name"));
                    invoice.setPetName(rs.getString("display_pet_name"));
                    invoice.setServiceName(rs.getString("display_service_name"));

                    list.add(invoice);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}