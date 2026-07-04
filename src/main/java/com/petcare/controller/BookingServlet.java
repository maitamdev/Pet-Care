package com.petcare.controller;

import com.petcare.dao.AppointmentDAO;
import com.petcare.dao.PetDAO;
import com.petcare.dao.ServiceDAO;
import com.petcare.dao.UserDAO;
import com.petcare.model.Appointment;
import com.petcare.model.Pet;
import com.petcare.model.Service;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;
import com.petcare.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.ArrayList;

@WebServlet({"/booking", "/booking/success"})
public class BookingServlet extends HttpServlet {

    private PetDAO petDAO;
    private ServiceDAO serviceDAO;
    private AppointmentDAO appointmentDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        petDAO = new PetDAO();
        serviceDAO = new ServiceDAO();
        appointmentDAO = new AppointmentDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=booking");
            return;
        }

        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();

        if ("/booking/success".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/public/booking-success.jsp").forward(request, response);
            return;
        }

        List<Pet> listPets = petDAO.getPetsByCustomerId(user.getId());
        request.setAttribute("listPets", listPets);

        List<Service> listServices = serviceDAO.getAllServices();
        request.setAttribute("listServices", listServices);
        CsrfUtil.getToken(request);

        request.getRequestDispatcher("/WEB-INF/views/public/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=booking");
            return;
        }

        if (!CsrfUtil.isValid(request)) {
            request.setAttribute("errorMessage", "Phiên biểu mẫu không hợp lệ. Vui lòng thử lại.");
            doGet(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            int petId = parseInt(request.getParameter("petId"), -1);

            if (petId == -1) {
                petId = createQuickPet(request, user.getId());
            } else if (!petDAO.isPetOwnedByCustomer(petId, user.getId())) {
                throw new ServletException("Hồ sơ thú cưng không thuộc tài khoản của bạn.");
            }

            String[] serviceIdStrings = request.getParameterValues("serviceIds");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String reason = request.getParameter("reason");
            String contactName = request.getParameter("contactName");
            String contactPhone = request.getParameter("contactPhone");
            String visitType = request.getParameter("visitType");
            String contactAddress = request.getParameter("contactAddress");

            if (serviceIdStrings == null || serviceIdStrings.length == 0 || ValidationUtil.isEmpty(dateStr) || ValidationUtil.isEmpty(timeStr)) {
                throw new ServletException("Vui lòng chọn thú cưng, dịch vụ, ngày và giờ khám.");
            }
            
            if (ValidationUtil.isEmpty(contactName)) {
                throw new ServletException("Vui lòng nhập tên người liên hệ.");
            }

            if ("HOME".equals(visitType) && ValidationUtil.isEmpty(contactAddress)) {
                throw new ServletException("Vui lòng nhập địa chỉ khi chọn Khám tại nhà.");
            }

            // Update user contact info if provided
            userDAO.updateContactInfo(user.getId(), contactName.trim(), contactPhone != null ? contactPhone.trim() : "", contactAddress != null ? contactAddress.trim() : "");
            user.setFullName(contactName.trim());
            user.setPhone(contactPhone != null ? contactPhone.trim() : "");
            user.setAddress(contactAddress != null ? contactAddress.trim() : "");

            Timestamp appointmentDate = parseAppointmentDate(dateStr, timeStr);
            validateAppointmentDate(appointmentDate);

            if (appointmentDAO.hasActiveAppointmentAt(appointmentDate)) {
                throw new ServletException("Khung giờ này đã có lịch hẹn. Vui lòng chọn giờ khác.");
            }

            List<Integer> selectedServiceIds = new ArrayList<>();
            for (String sidStr : serviceIdStrings) {
                int sid = parseInt(sidStr, -1);
                if (sid > 0) {
                    selectedServiceIds.add(sid);
                }
            }

            if (selectedServiceIds.isEmpty()) {
                throw new ServletException("Dịch vụ được chọn không hợp lệ.");
            }

            Appointment app = new Appointment();
            app.setCustomerId(user.getId());
            app.setPetId(petId);
            app.setAppointmentDate(appointmentDate);
            app.setReason(reason == null ? null : reason.trim());
            app.setSelectedServiceIds(selectedServiceIds);
            app.setVisitType(visitType != null ? visitType : "CLINIC");
            app.setAddress(contactAddress != null ? contactAddress.trim() : "");

            boolean success = appointmentDAO.addAppointment(app);
            if (success) {
                request.getSession().setAttribute("lastAppointmentId", app.getId());
                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
                request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi lưu lịch hẹn. Vui lòng thử lại.");
                doGet(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage() == null
                    ? "Dữ liệu nhập không hợp lệ hoặc thiếu thông tin. Vui lòng kiểm tra lại."
                    : e.getMessage());
            doGet(request, response);
        }
    }

    private int createQuickPet(HttpServletRequest request, int customerId) throws ServletException {
        String name = request.getParameter("newPetName");
        String species = request.getParameter("newPetSpecies");
        String breed = request.getParameter("newPetBreed");
        String ageRaw = request.getParameter("newPetAge");
        String weightRaw = request.getParameter("newPetWeight");
        String gender = request.getParameter("newPetGender");

        if (ValidationUtil.isEmpty(name) || ValidationUtil.isEmpty(species)) {
            throw new ServletException("Thiếu tên hoặc loài thú cưng.");
        }

        Pet pet = new Pet();
        pet.setCustomerId(customerId);
        pet.setName(name.trim());
        pet.setSpecies(species.trim());
        pet.setBreed(breed == null ? null : breed.trim());
        pet.setGender(gender == null ? "UNKNOWN" : gender.trim());

        if (!ValidationUtil.isEmpty(ageRaw)) {
            int age = Integer.parseInt(ageRaw);
            if (age < 0 || age > 80) {
                throw new ServletException("Tuổi thú cưng không hợp lệ.");
            }
            pet.setAge(age);
        }

        if (!ValidationUtil.isEmpty(weightRaw)) {
            BigDecimal weight = new BigDecimal(weightRaw);
            if (weight.compareTo(BigDecimal.ZERO) < 0) {
                throw new ServletException("Cân nặng thú cưng không hợp lệ.");
            }
            pet.setWeight(weight);
        }

        int petId = petDAO.addPetAndGetId(pet);
        if (petId == -1) {
            throw new ServletException("Không thể tạo hồ sơ thú cưng mới.");
        }
        return petId;
    }

    private Timestamp parseAppointmentDate(String dateStr, String timeStr) throws Exception {
        if (timeStr.length() == 5) {
            timeStr += ":00";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        sdf.setLenient(false);
        return new Timestamp(sdf.parse(dateStr + " " + timeStr).getTime());
    }

    private void validateAppointmentDate(Timestamp appointmentDate) throws ServletException {
        if (appointmentDate.before(new Timestamp(System.currentTimeMillis()))) {
            throw new ServletException("Không thể đặt lịch trong quá khứ.");
        }

        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(appointmentDate.getTime());
        int hour = calendar.get(Calendar.HOUR_OF_DAY);
        int minute = calendar.get(Calendar.MINUTE);
        if (hour < 8 || hour > 17 || (hour == 17 && minute > 0)) {
            throw new ServletException("Giờ khám chỉ nhận trong khung 08:00 - 17:00.");
        }
    }

    private int parseInt(String value, int fallback) {
        try {
            return value == null ? fallback : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
