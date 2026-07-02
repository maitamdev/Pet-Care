package com.petcare.dao;

import com.petcare.config.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    public BigDecimal getPaidRevenueInYear(int year) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM invoices WHERE status = 'PAID' AND YEAR(created_at) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public int countCompletedAppointmentsInYear(int year) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'COMPLETED' AND YEAR(appointment_date) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Map<String, Object>> getMonthlyRevenue(int year) {
        List<Map<String, Object>> rows = new ArrayList<>();
        String sql = "SELECT MONTH(created_at) AS report_month, COALESCE(SUM(total_amount), 0) AS revenue " +
                "FROM invoices WHERE status = 'PAID' AND YEAR(created_at) = ? " +
                "GROUP BY MONTH(created_at) ORDER BY report_month";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("month", rs.getInt("report_month"));
                    row.put("revenue", rs.getBigDecimal("revenue"));
                    rows.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rows;
    }

    public List<Map<String, Object>> getAppointmentStatusCounts(int year) {
        List<Map<String, Object>> rows = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) AS total FROM appointments WHERE YEAR(appointment_date) = ? GROUP BY status ORDER BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("status", rs.getString("status"));
                    row.put("total", rs.getInt("total"));
                    rows.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rows;
    }

    public List<Map<String, Object>> getTopServices(int year) {
        List<Map<String, Object>> rows = new ArrayList<>();
        String sql = "SELECT s.name, COUNT(*) AS used_count, COALESCE(SUM(ad.price_at_booking), 0) AS revenue " +
                "FROM appointment_details ad " +
                "JOIN appointments a ON ad.appointment_id = a.id " +
                "JOIN services s ON ad.service_id = s.id " +
                "WHERE YEAR(a.appointment_date) = ? " +
                "GROUP BY s.id, s.name ORDER BY used_count DESC, revenue DESC LIMIT 5";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("name", rs.getString("name"));
                    row.put("usedCount", rs.getInt("used_count"));
                    row.put("revenue", rs.getBigDecimal("revenue"));
                    rows.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rows;
    }

    public int normalizeYear(String rawYear) {
        int currentYear = LocalDate.now().getYear();
        try {
            int parsed = Integer.parseInt(rawYear);
            return parsed >= 2000 && parsed <= currentYear + 1 ? parsed : currentYear;
        } catch (Exception e) {
            return currentYear;
        }
    }
}
