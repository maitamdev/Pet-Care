package com.petcare.controller;

import com.petcare.dao.AppointmentDAO;
import com.petcare.dao.InvoiceDAO;
import com.petcare.dao.UserDAO;
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

@WebServlet({"/admin/appointments", "/admin/appointments/update-status", "/admin/appointments/update-clinical"})
public class AdminAppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private UserDAO userDAO;
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        userDAO = new UserDAO();
        invoiceDAO = new InvoiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Appointment> appointments = appointmentDAO.getAllAppointments();
        request.setAttribute("listAppointments", appointments);
        request.setAttribute("listStaff", userDAO.getAllStaff());
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/appointment-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (!CsrfUtil.isValid(request)) {
            session.setAttribute("errorMessage", "Phiên biểu mẫu không hợp lệ. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
            return;
        }

        String path = request.getServletPath();
        if ("/admin/appointments/update-status".equals(path)) {
            updateStatus(request, session);
        } else if ("/admin/appointments/update-clinical".equals(path)) {
            updateClinicalInfo(request, session);
        }

        response.sendRedirect(request.getContextPath() + "/admin/appointments");
    }

    private void updateStatus(HttpServletRequest request, HttpSession session) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            boolean success = appointmentDAO.updateStatus(id, status);
            if (success && "COMPLETED".equals(status)) {
                invoiceDAO.createForCompletedAppointment(id);
            }
            session.setAttribute(success ? "successMessage" : "errorMessage",
                    success ? "Cập nhật trạng thái lịch hẹn thành công." : "Không thể cập nhật trạng thái lịch hẹn.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu trạng thái không hợp lệ.");
        }
    }

    private void updateClinicalInfo(HttpServletRequest request, HttpSession session) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String staffRaw = request.getParameter("staffId");
            Integer staffId = (staffRaw == null || staffRaw.trim().isEmpty()) ? null : Integer.parseInt(staffRaw);
            String diagnosis = request.getParameter("diagnosis");
            boolean success = appointmentDAO.updateClinicalInfo(id, staffId, diagnosis == null ? null : diagnosis.trim());
            session.setAttribute(success ? "successMessage" : "errorMessage",
                    success ? "Cập nhật hồ sơ khám thành công." : "Không thể cập nhật hồ sơ khám.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu hồ sơ khám không hợp lệ.");
        }
    }
}
