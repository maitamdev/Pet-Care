package com.petcare.controller;

import com.petcare.dao.AppointmentDAO;
import com.petcare.dao.InvoiceDAO;
import com.petcare.dao.UserDAO;
import com.petcare.dao.PetDAO;
import com.petcare.dao.ServiceDAO;
import com.petcare.model.Appointment;
import com.petcare.model.Pet;
import com.petcare.util.CsrfUtil;
import com.petcare.util.JsonUtil;
import com.petcare.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/admin/appointments", "/admin/appointments/update-status", "/admin/appointments/update-clinical", "/admin/appointments/new", "/admin/appointments/insert", "/admin/appointments/get-pets"})
public class AdminAppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private UserDAO userDAO;
    private InvoiceDAO invoiceDAO;
    private PetDAO petDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        userDAO = new UserDAO();
        invoiceDAO = new InvoiceDAO();
        petDAO = new PetDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/appointments/new".equals(path)) {
            request.setAttribute("listCustomers", userDAO.getAllCustomers());
            request.setAttribute("listServices", serviceDAO.getAllServices());
            request.setAttribute("listStaff", userDAO.getAllStaff());
            CsrfUtil.getToken(request);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/appointment-form.jsp").forward(request, response);
            return;
        } else if ("/admin/appointments/get-pets".equals(path)) {
            int customerId = parseInt(request.getParameter("customerId"));
            List<Pet> pets = petDAO.getPetsByCustomerId(customerId);
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < pets.size(); i++) {
                Pet p = pets.get(i);
                json.append(String.format("{\"id\":%d,\"name\":\"%s\",\"species\":\"%s\"}",
                        p.getId(), JsonUtil.escape(p.getName()), JsonUtil.escape(p.getSpecies())));
                if (i < pets.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(json.toString());
            return;
        }

        int page = 1;
        int limit = 10;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int offset = (page - 1) * limit;
        int totalCount = appointmentDAO.getAppointmentsCount();
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        if (totalPages < 1) totalPages = 1;

        List<Appointment> appointments = appointmentDAO.getAppointmentsPaginated(offset, limit);
        request.setAttribute("listAppointments", appointments);
        request.setAttribute("listStaff", userDAO.getAllStaff());
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/dashboard/appointment-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!CsrfUtil.isValid(request)) {
            session.setAttribute("errorMessage", "Phiên biểu mẫu không hợp lệ. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
            return;
        }

        String path = request.getServletPath();
        if ("/admin/appointments/update-status".equals(path)) {
            updateStatus(request, session);
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
        } else if ("/admin/appointments/update-clinical".equals(path)) {
            updateClinicalInfo(request, session);
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
        } else if ("/admin/appointments/insert".equals(path)) {
            insertAppointment(request, response, session);
        }
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
                                ? "Cập nhật trạng thái và tạo hóa đơn thành công."
                                : "Lịch hẹn đã hoàn thành nhưng chưa tạo được hóa đơn.");
                return;
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

    private void insertAppointment(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            int petId = Integer.parseInt(request.getParameter("petId"));
            
            String[] serviceIdStrings = request.getParameterValues("serviceIds");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String reason = request.getParameter("reason");
            String visitType = request.getParameter("visitType");
            String address = request.getParameter("address");
            String staffRaw = request.getParameter("staffId");
            Integer assignedStaffId = (staffRaw == null || staffRaw.trim().isEmpty()) ? null : Integer.parseInt(staffRaw);

            if (serviceIdStrings == null || serviceIdStrings.length == 0 || dateStr == null || dateStr.trim().isEmpty() || timeStr == null || timeStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng điền đầy đủ dịch vụ, ngày và giờ hẹn.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
                return;
            }

            String timeFullStr = timeStr;
            if (timeFullStr.length() == 5) {
                timeFullStr += ":00";
            }
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            sdf.setLenient(false);
            java.sql.Timestamp appointmentDate = new java.sql.Timestamp(sdf.parse(dateStr + " " + timeFullStr).getTime());

            if (appointmentDate.before(new java.sql.Timestamp(System.currentTimeMillis()))) {
                session.setAttribute("errorMessage", "Không thể đặt lịch trong quá khứ.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
                return;
            }

            java.util.Calendar calendar = java.util.Calendar.getInstance();
            calendar.setTimeInMillis(appointmentDate.getTime());
            int hour = calendar.get(java.util.Calendar.HOUR_OF_DAY);
            int minute = calendar.get(java.util.Calendar.MINUTE);
            if (hour < 8 || hour > 17 || (hour == 17 && minute > 0)) {
                session.setAttribute("errorMessage", "Giờ khám chỉ nhận trong khung 08:00 - 17:00.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
                return;
            }

            if (appointmentDAO.hasActiveAppointmentAt(appointmentDate)) {
                session.setAttribute("errorMessage", "Khung giờ này đã có lịch hẹn. Vui lòng chọn giờ khác.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
                return;
            }

            List<Integer> selectedServiceIds = new ArrayList<>();
            for (String sidStr : serviceIdStrings) {
                int sid = ValidationUtil.parseIntOrDefault(sidStr, -1);
                if (sid > 0 && !selectedServiceIds.contains(sid)) {
                    selectedServiceIds.add(sid);
                }
            }
            if (selectedServiceIds.isEmpty()) {
                session.setAttribute("errorMessage", "Dịch vụ được chọn không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
                return;
            }
            if (!serviceDAO.areAllServicesActive(selectedServiceIds)) {
                session.setAttribute("errorMessage", "Một hoặc nhiều dịch vụ không tồn tại hoặc đã ngừng hoạt động.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
                return;
            }
            if (!petDAO.isPetOwnedByCustomer(petId, customerId)) {
                session.setAttribute("errorMessage", "Thú cưng không thuộc khách hàng đã chọn.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
                return;
            }

            Appointment app = new Appointment();
            app.setCustomerId(customerId);
            app.setPetId(petId);
            app.setAppointmentDate(appointmentDate);
            app.setReason(reason == null ? null : reason.trim());
            app.setSelectedServiceIds(selectedServiceIds);
            app.setVisitType(visitType != null ? visitType : "CLINIC");
            app.setAddress(address != null ? address.trim() : "");
            
            boolean success = appointmentDAO.addAppointment(app);
            if (success) {
                if (assignedStaffId != null) {
                    appointmentDAO.updateStatus(app.getId(), "CONFIRMED");
                    appointmentDAO.updateClinicalInfo(app.getId(), assignedStaffId, "");
                }
                session.setAttribute("successMessage", "Tạo lịch hẹn thành công.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments");
            } else {
                session.setAttribute("errorMessage", "Lỗi lưu lịch hẹn vào cơ sở dữ liệu.");
                response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Dữ liệu nhập không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/appointments/new");
        }
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }

}
