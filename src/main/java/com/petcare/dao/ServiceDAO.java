package com.petcare.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.petcare.config.DBConnection;
import com.petcare.model.Service;

public class ServiceDAO {

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE status = 1 ORDER BY category ASC, id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Service s = new Service();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setPrice(rs.getBigDecimal("price"));
                s.setDescription(rs.getString("description"));
                s.setCategory(rs.getString("category"));
                s.setStatus(rs.getInt("status"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean areAllServicesActive(List<Integer> serviceIds) {
        if (serviceIds == null || serviceIds.isEmpty()) {
            return false;
        }
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < serviceIds.size(); i++) {
            if (i > 0) {
                placeholders.append(',');
            }
            placeholders.append('?');
        }
        String sql = "SELECT COUNT(*) FROM services WHERE status = 1 AND id IN (" + placeholders + ")";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < serviceIds.size(); i++) {
                ps.setInt(i + 1, serviceIds.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) == serviceIds.size();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Service getServiceById(int id) {
        String sql = "SELECT * FROM services WHERE id = ? AND status = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service s = new Service();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setPrice(rs.getBigDecimal("price"));
                    s.setDescription(rs.getString("description"));
                    s.setCategory(rs.getString("category"));
                    s.setStatus(rs.getInt("status"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addService(Service s) {
        String sql = "INSERT INTO services (name, price, description, category, status) VALUES (?, ?, ?, ?, 1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setBigDecimal(2, s.getPrice());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getCategory());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateService(Service s) {
        String sql = "UPDATE services SET name=?, price=?, description=?, category=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setBigDecimal(2, s.getPrice());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getCategory());
            ps.setInt(5, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteService(int id) {
        String sql = "UPDATE services SET status=0 WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<Service> getServicesSortedByPrice(String sort) {
        List<Service> list = new ArrayList<>();

        String sql;
        if ("price_asc".equals(sort)) {
            sql = "SELECT * FROM services WHERE status = 1 ORDER BY price ASC";
        } else if ("price_desc".equals(sort)) {
            sql = "SELECT * FROM services WHERE status = 1 ORDER BY price DESC";
        } else {
            sql = "SELECT * FROM services WHERE status = 1 ORDER BY id DESC";
        }

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service s = new Service();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setPrice(rs.getBigDecimal("price"));
                s.setDescription(rs.getString("description"));
                s.setCategory(rs.getString("category"));
                s.setStatus(rs.getInt("status"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<Service> searchServicesByName(String keyword) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE status = 1 AND name LIKE ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setPrice(rs.getBigDecimal("price"));
                    s.setDescription(rs.getString("description"));
                    s.setCategory(rs.getString("category"));
                    s.setStatus(rs.getInt("status"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<Service> searchServicesByNameAndSort(String keyword, String sort) {
        List<Service> list = new ArrayList<>();

        String orderBy;
        if ("price_asc".equals(sort)) {
            orderBy = " ORDER BY price ASC";
        } else if ("price_desc".equals(sort)) {
            orderBy = " ORDER BY price DESC";
        } else {
            orderBy = " ORDER BY id DESC";
        }

        String sql = "SELECT * FROM services WHERE status = 1 AND name LIKE ?" + orderBy;

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setPrice(rs.getBigDecimal("price"));
                    s.setDescription(rs.getString("description"));
                    s.setCategory(rs.getString("category"));
                    s.setStatus(rs.getInt("status"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
