package com.petcare.controller;

import com.petcare.dao.AppointmentDAO;
import com.petcare.model.Appointment;
import com.petcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/appointments", "/admin/appointments/update-status"})
public class AdminAppointmentServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if ("CUSTOMER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        List<Appointment> listAppointments = appointmentDAO.getAllAppointments();
        request.setAttribute("listAppointments", listAppointments);

        request.getRequestDispatcher("/WEB-INF/views/dashboard/appointment-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("User");
        if ("CUSTOMER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String path = request.getServletPath();
        if ("/admin/appointments/update-status".equals(path)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                
                boolean success = appointmentDAO.updateStatus(id, status);
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật trạng thái lịch hẹn thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể cập nhật trạng thái lịch hẹn.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi dữ liệu yêu cầu: " + e.getMessage());
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/appointments");
    }
}
