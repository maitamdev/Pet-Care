package com.petcare.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.petcare.dao.InvoiceDAO;
import com.petcare.model.Invoice;

@WebServlet("/admin/invoices")
public class InvoiceServlet extends HttpServlet {
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() {
        invoiceDAO = new InvoiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Invoice> listInvoices = invoiceDAO.getAllInvoices();
        request.setAttribute("listInvoices", listInvoices);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/invoice-list.jsp").forward(request, response);
    }
    @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");

            String customerName = request.getParameter("customerName");
            String petName = request.getParameter("petName");
            String serviceName = request.getParameter("serviceName");
            String totalRaw = request.getParameter("totalAmount");
            String status = request.getParameter("status");
            String paymentMethod = request.getParameter("paymentMethod");

            if (customerName == null || customerName.trim().isEmpty()
                    || petName == null || petName.trim().isEmpty()
                    || serviceName == null || serviceName.trim().isEmpty()
                    || totalRaw == null || totalRaw.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid");
                return;
            }

            BigDecimal totalAmount;
            try {
                totalAmount = new BigDecimal(totalRaw.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid_amount");
                return;
            }

            if (totalAmount.compareTo(BigDecimal.ZERO) < 0) {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?error=invalid_amount");
                return;
            }

            if (status == null || status.trim().isEmpty()) {
                status = "UNPAID";
            }

            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                paymentMethod = null;
            }

            boolean success = invoiceDAO.createManualInvoice(
                    customerName.trim(),
                    petName.trim(),
                    serviceName.trim(),
                    totalAmount,
                    status,
                    paymentMethod
            );

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?success=created");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/invoices?error=create_failed");
            }
        }
}