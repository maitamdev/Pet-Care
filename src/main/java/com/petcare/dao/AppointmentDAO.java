package com.petcare.dao;

import com.petcare.config.DBConnection;
import com.petcare.model.Appointment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public boolean addAppointment(Appointment app) {
        String insertAppointment = "INSERT INTO appointments (customer_id, pet_id, appointment_date, reason, status) VALUES (?, ?, ?, ?, ?)";
        String insertDetail = "INSERT INTO appointment_details (appointment_id, service_id, price_at_booking) VALUES (?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement psApp = null;
        PreparedStatement psDetail = null;
        ResultSet generatedKeys = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // 1. Insert into appointments
            psApp = conn.prepareStatement(insertAppointment, Statement.RETURN_GENERATED_KEYS);
            psApp.setInt(1, app.getCustomerId());
            psApp.setInt(2, app.getPetId());
            psApp.setTimestamp(3, app.getAppointmentDate());
            psApp.setString(4, app.getReason());
            psApp.setString(5, "PENDING"); // Default status

            int affectedRows = psApp.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating appointment failed, no rows affected.");
            }

            // Get generated appointment ID
            generatedKeys = psApp.getGeneratedKeys();
            int appointmentId = 0;
            if (generatedKeys.next()) {
                appointmentId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Creating appointment failed, no ID obtained.");
            }

            // 2. Insert into appointment_details
            psDetail = conn.prepareStatement(insertDetail);
            psDetail.setInt(1, appointmentId);
            psDetail.setInt(2, app.getServiceId());
            psDetail.setBigDecimal(3, app.getPriceAtBooking());

            psDetail.executeUpdate();

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            // Clean resources
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (psApp != null) psApp.close();
                if (psDetail != null) psDetail.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<Appointment> getAppointmentsByCustomerId(int customerId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.name as pet_name, s.name as service_name, ad.price_at_booking " +
                     "FROM appointments a " +
                     "JOIN pets p ON a.pet_id = p.id " +
                     "JOIN appointment_details ad ON a.id = ad.appointment_id " +
                     "JOIN services s ON ad.service_id = s.id " +
                     "WHERE a.customer_id = ? " +
                     "ORDER BY a.appointment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment app = new Appointment();
                    app.setId(rs.getInt("id"));
                    app.setCustomerId(rs.getInt("customer_id"));
                    app.setPetId(rs.getInt("pet_id"));
                    app.setStaffId(rs.getInt("staff_id"));
                    if (rs.wasNull()) app.setStaffId(null);
                    
                    app.setAppointmentDate(rs.getTimestamp("appointment_date"));
                    app.setStatus(rs.getString("status"));
                    app.setReason(rs.getString("reason"));
                    app.setDiagnosis(rs.getString("diagnosis"));
                    app.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    app.setPetName(rs.getString("pet_name"));
                    app.setServiceName(rs.getString("service_name"));
                    app.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                    
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countTodayAppointments() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE DATE(appointment_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countPendingAppointments() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public long getMonthlyRevenue() {
        String sql = "SELECT SUM(ad.price_at_booking) FROM appointment_details ad " +
                     "JOIN appointments a ON ad.appointment_id = a.id " +
                     "WHERE a.status = 'COMPLETED' AND MONTH(a.appointment_date) = MONTH(CURDATE()) AND YEAR(a.appointment_date) = YEAR(CURDATE())";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Appointment> getTodayAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.name as pet_name, u.full_name as customer_name, s.name as service_name, ad.price_at_booking " +
                     "FROM appointments a " +
                     "JOIN pets p ON a.pet_id = p.id " +
                     "JOIN users u ON a.customer_id = u.id " +
                     "JOIN appointment_details ad ON a.id = ad.appointment_id " +
                     "JOIN services s ON ad.service_id = s.id " +
                     "WHERE DATE(a.appointment_date) = CURDATE() " +
                     "ORDER BY a.appointment_date ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setCustomerId(rs.getInt("customer_id"));
                app.setPetId(rs.getInt("pet_id"));
                app.setStaffId(rs.getInt("staff_id"));
                if (rs.wasNull()) app.setStaffId(null);
                app.setAppointmentDate(rs.getTimestamp("appointment_date"));
                app.setStatus(rs.getString("status"));
                app.setReason(rs.getString("reason"));
                app.setDiagnosis(rs.getString("diagnosis"));
                app.setCreatedAt(rs.getTimestamp("created_at"));
                app.setCustomerName(rs.getString("customer_name"));
                app.setPetName(rs.getString("pet_name"));
                app.setServiceName(rs.getString("service_name"));
                app.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.name as pet_name, u.full_name as customer_name, s.name as service_name, ad.price_at_booking " +
                     "FROM appointments a " +
                     "JOIN pets p ON a.pet_id = p.id " +
                     "JOIN users u ON a.customer_id = u.id " +
                     "JOIN appointment_details ad ON a.id = ad.appointment_id " +
                     "JOIN services s ON ad.service_id = s.id " +
                     "ORDER BY a.appointment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setCustomerId(rs.getInt("customer_id"));
                app.setPetId(rs.getInt("pet_id"));
                app.setStaffId(rs.getInt("staff_id"));
                if (rs.wasNull()) app.setStaffId(null);
                app.setAppointmentDate(rs.getTimestamp("appointment_date"));
                app.setStatus(rs.getString("status"));
                app.setReason(rs.getString("reason"));
                app.setDiagnosis(rs.getString("diagnosis"));
                app.setCreatedAt(rs.getTimestamp("created_at"));
                app.setCustomerName(rs.getString("customer_name"));
                app.setPetName(rs.getString("pet_name"));
                app.setServiceName(rs.getString("service_name"));
                app.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int appointmentId, String status) {
        String sql = "UPDATE appointments SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
