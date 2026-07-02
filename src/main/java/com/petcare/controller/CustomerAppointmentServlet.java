package com.petcare.controller;

import com.petcare.dao.AppointmentDAO;
import com.petcare.model.Appointment;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
        User user = currentUser(request);
        List<Appointment> appointments = appointmentDAO.getAppointmentsByCustomerId(user.getId());
        request.setAttribute("appointments", appointments);
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/customer/appointment-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = currentUser(request);
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/my/appointments?error=csrf");
            return;
        }
        int id = parseInt(request.getParameter("id"));
        appointmentDAO.cancelByCustomer(id, user.getId());
        response.sendRedirect(request.getContextPath() + "/my/appointments?success=cancelled");
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (User) session.getAttribute("user");
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }
}
