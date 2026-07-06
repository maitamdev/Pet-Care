package com.petcare.config;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/petcare_db"
            + "?useSSL=false"
            + "&serverTimezone=UTC"
            + "&allowPublicKeyRetrieval=true"
            + "&characterEncoding=UTF-8";

    private static final String URL = setting("PETCARE_DB_URL", DEFAULT_URL);
    private static final String USER = setting("PETCARE_DB_USER", "petcare_app");
    private static final String PASSWORD = setting("PETCARE_DB_PASSWORD", null);

    private static String setting(String name, String defaultValue) {
        String value = System.getenv(name);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(name);
        }
        if (value == null || value.trim().isEmpty()) {
            value = readEnvFileSetting(name);
        }
        return value == null || value.trim().isEmpty() ? defaultValue : value;
    }

    private static String readEnvFileSetting(String name) {
        File envFile = findEnvFile();
        if (!envFile.isFile()) {
            return null;
        }

        String prefix = "$env:" + name + "=";
        try (BufferedReader reader = Files.newBufferedReader(envFile.toPath(), StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = stripBom(line).trim();
                int index = trimmed.indexOf(prefix);
                if (index >= 0) {
                    return unquote(trimmed.substring(index + prefix.length()).trim());
                }
            }
        } catch (IOException ignored) {
            return null;
        }
        return null;
    }

    private static File findEnvFile() {
        File current = new File(System.getProperty("user.dir", ".")).getAbsoluteFile();
        for (int i = 0; i < 5 && current != null; i++) {
            File candidate = new File(current, ".env.ps1");
            if (candidate.isFile()) {
                return candidate;
            }
            current = current.getParentFile();
        }
        return new File(".env.ps1");
    }

    private static String stripBom(String value) {
        if (value == null || value.isEmpty()) {
            return value;
        }
        if (value.charAt(0) == '\uFEFF') {
            return value.substring(1);
        }
        if (value.startsWith("ï»¿")) {
            return value.substring(3);
        }
        return value;
    }

    private static String unquote(String value) {
        if (value.length() >= 2) {
            char first = value.charAt(0);
            char last = value.charAt(value.length() - 1);
            if ((first == '\'' && last == '\'') || (first == '"' && last == '"')) {
                return value.substring(1, value.length() - 1);
            }
        }
        return value;
    }

    public static Connection getConnection() throws SQLException {
        if (PASSWORD == null || PASSWORD.trim().isEmpty()) {
            throw new SQLException("Database password is not configured. Run setup.ps1 or set PETCARE_DB_PASSWORD.");
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}