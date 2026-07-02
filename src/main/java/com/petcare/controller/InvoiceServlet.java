package com.petcare.controller;

import com.petcare.dao.InvoiceDAO;
import com.petcare.model.Invoice;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

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

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        List<Invoice> invoices = invoiceDAO.searchInvoices(keyword, status);
        request.setAttribute("invoices", invoices);
        request.setAttribute("listInvoices", invoices);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/invoice-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices?error=csrf");
            return;
        }

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            updateInvoice(request, response);
            return;
        }

        if ("update-status".equals(action)) {
            int id = parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            boolean success = invoiceDAO.updateInvoiceStatus(id, status);
            response.sendRedirect(request.getContextPath() + "/admin/invoices?" + (success ? "success=updated" : "error=update_failed"));
            return;
        }

        createManualInvoice(request, response);
    }

    private void createManualInvoice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String customerName = request.getParameter("customerName");
        String petName = request.getParameter("petName");
        String serviceName = request.getParameter("serviceName");
        String totalRaw = request.getParameter("totalAmount");
        String status = request.getParameter("status");
        String paymentMethod = request.getParameter("paymentMethod");

        if (isBlank(customerName) || isBlank(petName) || isBlank(serviceName) || isBlank(totalRaw)) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid");
            return;
        }

        BigDecimal totalAmount = parseAmount(totalRaw);
        if (totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) < 0) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid_amount");
            return;
        }

        boolean success = invoiceDAO.createManualInvoice(
                customerName.trim(), petName.trim(), serviceName.trim(), totalAmount, status, paymentMethod);
        response.sendRedirect(request.getContextPath() + "/admin/invoices?" + (success ? "success=created" : "error=create_failed"));
    }

    private void updateInvoice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = parseInt(request.getParameter("id"));
        String customerName = request.getParameter("customerName");
        String petName = request.getParameter("petName");
        String serviceName = request.getParameter("serviceName");
        String totalRaw = request.getParameter("totalAmount");
        String status = request.getParameter("status");
        String paymentMethod = request.getParameter("paymentMethod");

        if (id <= 0 || isBlank(customerName) || isBlank(petName) || isBlank(serviceName) || isBlank(totalRaw)) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid");
            return;
        }

        BigDecimal totalAmount = parseAmount(totalRaw);
        if (totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) < 0) {
            response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid_amount");
            return;
        }

        boolean success = invoiceDAO.updateInvoice(
                id, customerName.trim(), petName.trim(), serviceName.trim(), totalAmount, status, paymentMethod);
        response.sendRedirect(request.getContextPath() + "/admin/invoices?" + (success ? "success=updated" : "error=update_failed"));
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("user");
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }

    private BigDecimal parseAmount(String value) {
        try {
            return new BigDecimal(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
