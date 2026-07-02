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

        String sql = "INSERT INTO invoices (appointment_id, total_amount, status) " +
                     "SELECT a.id, SUM(ad.price_at_booking), 'UNPAID' " +
                     "FROM appointments a " +
                     "JOIN appointment_details ad ON a.id = ad.appointment_id " +
                     "WHERE a.id = ? AND a.status = 'COMPLETED' " +
                     "GROUP BY a.id";

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

    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();

        String sql = "SELECT i.*, u.full_name AS customer_name, p.name AS pet_name, " +
                "s.name AS service_name, a.appointment_date " +
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

                invoice.setCustomerName(rs.getString("customer_name"));
                invoice.setPetName(rs.getString("pet_name"));
                invoice.setServiceName(rs.getString("service_name"));
                invoice.setAppointmentDate(rs.getTimestamp("appointment_date"));

                invoice.setManualCustomerName(rs.getString("manual_customer_name"));
                invoice.setManualPetName(rs.getString("manual_pet_name"));
                invoice.setManualServiceName(rs.getString("manual_service_name"));

                list.add(invoice);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}