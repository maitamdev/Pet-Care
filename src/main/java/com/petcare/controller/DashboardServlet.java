package com.petcare.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.petcare.model.User;
import com.petcare.model.Appointment;
import com.petcare.dao.AppointmentDAO;
import com.petcare.dao.PetDAO;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private PetDAO petDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        petDAO = new PetDAO();
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

        int totalAppointments = appointmentDAO.countTodayAppointments();
        int pendingApprovals = appointmentDAO.countPendingAppointments();
        int totalPets = petDAO.getAllPets().size();
        long monthlyRev = appointmentDAO.getMonthlyRevenue();
        
        // Format monthly revenue with commas
        String totalRevenue = String.format("%,d", monthlyRev);

        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("totalPets", totalPets);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("pendingApprovals", pendingApprovals);

        // Fetch today's appointments for "Lịch khám nổi bật"
        List<Appointment> todayAppointments = appointmentDAO.getTodayAppointments();
        request.setAttribute("todayAppointments", todayAppointments);

        request.getRequestDispatcher("/WEB-INF/views/dashboard/index.jsp").forward(request, response);
    }
}
