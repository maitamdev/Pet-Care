package com.petcare.controller;

import com.petcare.dao.AppointmentDAO;
import com.petcare.model.Appointment;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;
import com.petcare.util.SessionUtil;
import com.petcare.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/my/appointments", "/my/appointments/cancel"})
public class CustomerAppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = SessionUtil.requireUser(request, response);
        if (user == null) {
            return;
        }
        List<Appointment> appointments = appointmentDAO.getAppointmentsByCustomerId(user.getId());
        request.setAttribute("appointments", appointments);
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/customer/appointment-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = SessionUtil.requireUser(request, response);
        if (user == null) {
            return;
        }
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/my/appointments?error=csrf");
            return;
        }
        int id = ValidationUtil.parseIntOrDefault(request.getParameter("id"), -1);
        boolean success = appointmentDAO.cancelByCustomer(id, user.getId());
        response.sendRedirect(request.getContextPath() + "/my/appointments?" + (success ? "success=cancelled" : "error=cancel_failed"));
    }
}