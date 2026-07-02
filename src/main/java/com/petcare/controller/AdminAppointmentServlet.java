package com.petcare.controller;

import com.petcare.dao.AppointmentDAO;
import com.petcare.dao.InvoiceDAO;
import com.petcare.dao.UserDAO;
import com.petcare.model.Appointment;
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
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!CsrfUtil.isValid(request)) {
            session.setAttribute("errorMessage", "Phien bieu mau khong hop le. Vui long thu lai.");
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
                boolean invoiceCreated = invoiceDAO.createInvoiceFromAppointment(id);
                session.setAttribute(invoiceCreated ? "successMessage" : "errorMessage",
                        invoiceCreated
                                ? "Cap nhat trang thai va tao hoa don thanh cong."
                                : "Lich hen da hoan thanh nhung chua tao duoc hoa don.");
                return;
            }

            session.setAttribute(success ? "successMessage" : "errorMessage",
                    success ? "Cap nhat trang thai lich hen thanh cong." : "Khong the cap nhat trang thai lich hen.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Du lieu trang thai khong hop le.");
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
                    success ? "Cap nhat ho so kham thanh cong." : "Khong the cap nhat ho so kham.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Du lieu ho so kham khong hop le.");
        }
    }
}
