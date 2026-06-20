package com.petcare.controller;

import com.petcare.config.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/test-db")
public class DatabaseTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("  <meta charset='UTF-8'>");
        out.println("  <title>PetCare - Database Test</title>");
        out.println("  <style>");
        out.println("    body { font-family: 'Segoe UI', sans-serif; display: flex;");
        out.println("           justify-content: center; align-items: center;");
        out.println("           min-height: 100vh; margin: 0; background: #f0f4f8; }");
        out.println("    .card { background: white; padding: 40px; border-radius: 12px;");
        out.println("            box-shadow: 0 4px 20px rgba(0,0,0,0.1); text-align: center;");
        out.println("            max-width: 500px; width: 90%; }");
        out.println("    .success { color: #0d9488; }");
        out.println("    .error { color: #dc2626; }");
        out.println("    .detail { color: #64748b; font-size: 14px; margin-top: 10px; }");
        out.println("    a { color: #0d9488; text-decoration: none; }");
        out.println("    a:hover { text-decoration: underline; }");
        out.println("  </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("  <div class='card'>");

        try (Connection conn = DBConnection.getConnection()) {
            out.println("    <h1 class='success'>Database Connected Successfully!</h1>");
            out.println("    <p class='detail'>Database: " + conn.getCatalog() + "</p>");
            out.println("    <p class='detail'>MySQL Version: " + conn.getMetaData().getDatabaseProductVersion() + "</p>");
        } catch (SQLException e) {
            out.println("    <h1 class='error'>Database Connection Failed!</h1>");
            out.println("    <p class='error'><strong>Error:</strong> " + e.getMessage() + "</p>");
            out.println("    <p class='detail'><strong>SQL State:</strong> " + e.getSQLState() + "</p>");
            out.println("    <p class='detail'><strong>Error Code:</strong> " + e.getErrorCode() + "</p>");
        }

        out.println("    <br>");
        out.println("    <a href='" + request.getContextPath() + "/'>Quay về trang chủ</a>");
        out.println("  </div>");
        out.println("</body>");
        out.println("</html>");
    }
}
