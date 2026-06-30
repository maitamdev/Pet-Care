package com.petcare.dao;

import com.petcare.config.DBConnection;
import com.petcare.model.Pet;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PetDAO {

    public List<Pet> getAllPets() {
        List<Pet> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name as customer_name " +
                     "FROM pets p " +
                     "JOIN users u ON p.customer_id = u.id " +
                     "ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Pet p = new Pet();
                p.setId(rs.getInt("id"));
                p.setCustomerId(rs.getInt("customer_id"));
                p.setName(rs.getString("name"));
                p.setSpecies(rs.getString("species"));
                p.setBreed(rs.getString("breed"));
                
                int age = rs.getInt("age");
                if (!rs.wasNull()) p.setAge(age);
                
                p.setWeight(rs.getBigDecimal("weight"));
                p.setGender(rs.getString("gender"));
                p.setNotes(rs.getString("notes"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setCustomerName(rs.getString("customer_name"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Pet getPetById(int id) {
        String sql = "SELECT * FROM pets WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Pet p = new Pet();
                    p.setId(rs.getInt("id"));
                    p.setCustomerId(rs.getInt("customer_id"));
                    p.setName(rs.getString("name"));
                    p.setSpecies(rs.getString("species"));
                    p.setBreed(rs.getString("breed"));
                    
                    int age = rs.getInt("age");
                    if (!rs.wasNull()) p.setAge(age);
                    
                    p.setWeight(rs.getBigDecimal("weight"));
                    p.setGender(rs.getString("gender"));
                    p.setNotes(rs.getString("notes"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addPet(Pet p) {
        String sql = "INSERT INTO pets (customer_id, name, species, breed, age, weight, gender, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCustomerId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getSpecies());
            ps.setString(4, p.getBreed());
            
            if (p.getAge() != null) ps.setInt(5, p.getAge());
            else ps.setNull(5, Types.INTEGER);
            
            ps.setBigDecimal(6, p.getWeight());
            ps.setString(7, p.getGender());
            ps.setString(8, p.getNotes());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int addPetAndGetId(Pet p) {
        String sql = "INSERT INTO pets (customer_id, name, species, breed, age, weight, gender, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getCustomerId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getSpecies());
            ps.setString(4, p.getBreed());
            
            if (p.getAge() != null) ps.setInt(5, p.getAge());
            else ps.setNull(5, Types.INTEGER);
            
            ps.setBigDecimal(6, p.getWeight());
            ps.setString(7, p.getGender());
            ps.setString(8, p.getNotes());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updatePet(Pet p) {
        String sql = "UPDATE pets SET customer_id=?, name=?, species=?, breed=?, age=?, weight=?, gender=?, notes=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCustomerId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getSpecies());
            ps.setString(4, p.getBreed());
            
            if (p.getAge() != null) ps.setInt(5, p.getAge());
            else ps.setNull(5, Types.INTEGER);
            
            ps.setBigDecimal(6, p.getWeight());
            ps.setString(7, p.getGender());
            ps.setString(8, p.getNotes());
            ps.setInt(9, p.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePet(int id) {
        String sql = "DELETE FROM pets WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Pet> getPetsByCustomerId(int customerId) {
        List<Pet> list = new ArrayList<>();
        String sql = "SELECT * FROM pets WHERE customer_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pet p = new Pet();
                    p.setId(rs.getInt("id"));
                    p.setCustomerId(rs.getInt("customer_id"));
                    p.setName(rs.getString("name"));
                    p.setSpecies(rs.getString("species"));
                    p.setBreed(rs.getString("breed"));
                    int age = rs.getInt("age");
                    if (!rs.wasNull()) p.setAge(age);
                    p.setWeight(rs.getBigDecimal("weight"));
                    p.setGender(rs.getString("gender"));
                    p.setNotes(rs.getString("notes"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
