package com.petcare.controller;

import com.petcare.dao.InvoiceDAO;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/admin/invoices", "/admin/invoices/update", "/my/invoices"})
public class InvoiceServlet extends HttpServlet {
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() {
        invoiceDAO = new InvoiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        CsrfUtil.getToken(request);
        if (request.getServletPath().startsWith("/my")) {
            request.setAttribute("invoices", invoiceDAO.getInvoicesByCustomerId(user.getId()));
            request.getRequestDispatcher("/WEB-INF/views/customer/invoice-list.jsp").forward(request, response);
            return;
        }

        request.setAttribute("invoices", invoiceDAO.getAllInvoices());
        request.getRequestDispatcher("/WEB-INF/views/dashboard/invoice-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices?error=csrf");
            return;
        }
        int id = parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String method = request.getParameter("paymentMethod");
        invoiceDAO.updatePaymentStatus(id, status, method);
        response.sendRedirect(request.getContextPath() + "/admin/invoices?success=updated");
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
