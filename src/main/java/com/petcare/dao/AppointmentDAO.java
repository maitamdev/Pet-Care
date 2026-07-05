package com.petcare.dao;

import com.petcare.config.DBConnection;
import com.petcare.model.Appointment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    private static final String PENDING = "PENDING";
    private static final String CONFIRMED = "CONFIRMED";
    private static final String COMPLETED = "COMPLETED";
    private static final String CANCELLED = "CANCELLED";

    public boolean addAppointment(Appointment app) {
        String insertAppointment = "INSERT INTO appointments (customer_id, pet_id, appointment_date, reason, status, visit_type, address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertDetail = "INSERT INTO appointment_details (appointment_id, service_id, price_at_booking) SELECT ?, id, price FROM services WHERE id = ?";
        
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
            psApp.setString(6, app.getVisitType() != null ? app.getVisitType() : "CLINIC");
            psApp.setString(7, app.getAddress());

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

            // 2. Insert into appointment_details for each selected service
            psDetail = conn.prepareStatement(insertDetail);
            if (app.getSelectedServiceIds() != null && !app.getSelectedServiceIds().isEmpty()) {
                for (Integer sid : app.getSelectedServiceIds()) {
                    psDetail.setInt(1, appointmentId);
                    psDetail.setInt(2, sid);
                    psDetail.executeUpdate();
                }
            } else {
                // Fallback for single service (backward compatibility)
                psDetail.setInt(1, appointmentId);
                psDetail.setInt(2, app.getServiceId());
                psDetail.executeUpdate();
            }

            conn.commit(); // Commit transaction
            app.setId(appointmentId); // Set generated ID back to the object
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

    public boolean hasActiveAppointmentAt(Timestamp appointmentDate) {
        String sql = "SELECT id FROM appointments WHERE appointment_date = ? AND status IN ('PENDING', 'CONFIRMED') LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, appointmentDate);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }

    public List<Appointment> getAppointmentsByCustomerId(int customerId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.name as pet_name, staff.full_name as staff_name, " +
                     "GROUP_CONCAT(s.name SEPARATOR ', ') as service_name, SUM(ad.price_at_booking) as price_at_booking " +
                     "FROM appointments a " +
                     "JOIN pets p ON a.pet_id = p.id " +
                     "LEFT JOIN users staff ON a.staff_id = staff.id " +
                     "LEFT JOIN appointment_details ad ON a.id = ad.appointment_id " +
                     "LEFT JOIN services s ON ad.service_id = s.id " +
                     "WHERE a.customer_id = ? " +
                     "GROUP BY a.id " +
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
                    app.setStaffName(rs.getString("staff_name"));
                    app.setServiceName(rs.getString("service_name"));
                    app.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                    app.setVisitType(rs.getString("visit_type"));
                    app.setAddress(rs.getString("address"));
                    
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
        String sql = "SELECT a.*, p.name as pet_name, u.full_name as customer_name, staff.full_name as staff_name, " +
                     "GROUP_CONCAT(s.name SEPARATOR ', ') as service_name, SUM(ad.price_at_booking) as price_at_booking " +
                     "FROM appointments a " +
                     "JOIN pets p ON a.pet_id = p.id " +
                     "JOIN users u ON a.customer_id = u.id " +
                     "LEFT JOIN users staff ON a.staff_id = staff.id " +
                     "LEFT JOIN appointment_details ad ON a.id = ad.appointment_id " +
                     "LEFT JOIN services s ON ad.service_id = s.id " +
                     "WHERE DATE(a.appointment_date) = CURDATE() " +
                     "GROUP BY a.id " +
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
                app.setStaffName(rs.getString("staff_name"));
                app.setPetName(rs.getString("pet_name"));
                app.setServiceName(rs.getString("service_name"));
                app.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                app.setVisitType(rs.getString("visit_type"));
                app.setAddress(rs.getString("address"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.name as pet_name, u.full_name as customer_name, staff.full_name as staff_name, " +
                     "GROUP_CONCAT(s.name SEPARATOR ', ') as service_name, SUM(ad.price_at_booking) as price_at_booking " +
                     "FROM appointments a " +
                     "JOIN pets p ON a.pet_id = p.id " +
                     "JOIN users u ON a.customer_id = u.id " +
                     "LEFT JOIN users staff ON a.staff_id = staff.id " +
                     "LEFT JOIN appointment_details ad ON a.id = ad.appointment_id " +
                     "LEFT JOIN services s ON ad.service_id = s.id " +
                     "GROUP BY a.id " +
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
                app.setStaffName(rs.getString("staff_name"));
                app.setPetName(rs.getString("pet_name"));
                app.setServiceName(rs.getString("service_name"));
                app.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                app.setVisitType(rs.getString("visit_type"));
                app.setAddress(rs.getString("address"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int appointmentId, String status) {
        if (!isAllowedStatus(status)) {
            return false;
        }

        String current = getStatusById(appointmentId);
        if (!isAllowedTransition(current, status)) {
            return false;
        }

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

    public boolean updateClinicalInfo(int appointmentId, Integer staffId, String diagnosis) {
        String sql = "UPDATE appointments SET staff_id = ?, diagnosis = ? WHERE id = ? AND status IN ('CONFIRMED', 'COMPLETED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (staffId == null || staffId <= 0) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, staffId);
            }
            ps.setString(2, diagnosis);
            ps.setInt(3, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelByCustomer(int appointmentId, int customerId) {
        String sql = "UPDATE appointments SET status = 'CANCELLED' WHERE id = ? AND customer_id = ? AND status IN ('PENDING', 'CONFIRMED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private String getStatusById(int appointmentId) {
        String sql = "SELECT status FROM appointments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("status");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách lịch hẹn khám phân trang dùng LIMIT và OFFSET trong SQL
    public List<Appointment> getAppointmentsPaginated(int offset, int limit) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.name as pet_name, u.full_name as customer_name, staff.full_name as staff_name, " +
                     "GROUP_CONCAT(s.name SEPARATOR ', ') as service_name, SUM(ad.price_at_booking) as price_at_booking " +
                     "FROM appointments a " +
                     "JOIN pets p ON a.pet_id = p.id " +
                     "JOIN users u ON a.customer_id = u.id " +
                     "LEFT JOIN users staff ON a.staff_id = staff.id " +
                     "LEFT JOIN appointment_details ad ON a.id = ad.appointment_id " +
                     "LEFT JOIN services s ON ad.service_id = s.id " +
                     "GROUP BY a.id " +
                     "ORDER BY a.appointment_date DESC " +
                     "LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
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
                    app.setCustomerName(rs.getString("customer_name"));
                    app.setStaffName(rs.getString("staff_name"));
                    app.setPetName(rs.getString("pet_name"));
                    app.setServiceName(rs.getString("service_name"));
                    app.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                    app.setVisitType(rs.getString("visit_type"));
                    app.setAddress(rs.getString("address"));
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số lượng lịch hẹn để tính tổng số trang phân trang
    public int getAppointmentsCount() {
        String sql = "SELECT COUNT(*) FROM appointments";
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

    private boolean isAllowedStatus(String status) {
        return PENDING.equals(status) || CONFIRMED.equals(status) || COMPLETED.equals(status) || CANCELLED.equals(status);
    }

    private boolean isAllowedTransition(String current, String next) {
        if (current == null || current.equals(next)) {
            return false;
        }
        if (PENDING.equals(current)) {
            return CONFIRMED.equals(next) || CANCELLED.equals(next);
        }
        if (CONFIRMED.equals(current)) {
            return COMPLETED.equals(next) || CANCELLED.equals(next);
        }
        return false;
    }
}
