package com.petcare.controller;

import com.petcare.dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/reports")
public class ReportServlet extends HttpServlet {
    private ReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int year = reportDAO.normalizeYear(request.getParameter("year"));
        request.setAttribute("year", year);
        request.setAttribute("yearRevenue", reportDAO.getPaidRevenueInYear(year));
        request.setAttribute("completedAppointments", reportDAO.countCompletedAppointmentsInYear(year));
        request.setAttribute("monthlyRevenue", reportDAO.getMonthlyRevenue(year));
        request.setAttribute("statusCounts", reportDAO.getAppointmentStatusCounts(year));
        request.setAttribute("topServices", reportDAO.getTopServices(year));
        request.getRequestDispatcher("/WEB-INF/views/dashboard/reports.jsp").forward(request, response);
    }
}
