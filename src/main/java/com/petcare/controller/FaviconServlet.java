package com.petcare.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/favicon.ico")
public class FaviconServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("image/png");
        response.setHeader("Cache-Control", "public, max-age=604800");

        try (InputStream icon = getServletContext().getResourceAsStream("/assets/images/petcare_logo_icon.png");
             OutputStream output = response.getOutputStream()) {
            if (icon == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = icon.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        }
    }
}
