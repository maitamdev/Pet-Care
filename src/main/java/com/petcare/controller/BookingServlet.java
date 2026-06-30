package com.petcare.controller;

import com.petcare.dao.PetDAO;
import com.petcare.dao.ServiceDAO;
import com.petcare.dao.AppointmentDAO;
import com.petcare.model.Pet;
import com.petcare.model.Service;
import com.petcare.model.Appointment;
import com.petcare.model.User;

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
import java.util.List;

@WebServlet({"/booking", "/booking/success"})
public class BookingServlet extends HttpServlet {

    private PetDAO petDAO;
    private ServiceDAO serviceDAO;
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        petDAO = new PetDAO();
        serviceDAO = new ServiceDAO();
        appointmentDAO = new AppointmentDAO();
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

        // Fetch user's pets
        List<Pet> listPets = petDAO.getPetsByCustomerId(user.getId());
        request.setAttribute("listPets", listPets);

        // Fetch active services
        List<Service> listServices = serviceDAO.getAllServices();
        request.setAttribute("listServices", listServices);

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

        User user = (User) session.getAttribute("user");

        try {
            int petId = -1;
            String petIdParam = request.getParameter("petId");
            if (petIdParam != null && !petIdParam.isEmpty()) {
                petId = Integer.parseInt(petIdParam);
            }

            // If "Register New Pet" is selected
            if (petId == -1) {
                String newPetName = request.getParameter("newPetName");
                String newPetSpecies = request.getParameter("newPetSpecies");
                String newPetBreed = request.getParameter("newPetBreed");
                String newPetAgeStr = request.getParameter("newPetAge");
                String newPetWeightStr = request.getParameter("newPetWeight");
                String newPetGender = request.getParameter("newPetGender");
                
                Pet newPet = new Pet();
                newPet.setCustomerId(user.getId());
                newPet.setName(newPetName);
                newPet.setSpecies(newPetSpecies);
                newPet.setBreed(newPetBreed);
                
                if (newPetAgeStr != null && !newPetAgeStr.isEmpty()) {
                    newPet.setAge(Integer.parseInt(newPetAgeStr));
                }
                if (newPetWeightStr != null && !newPetWeightStr.isEmpty()) {
                    newPet.setWeight(new BigDecimal(newPetWeightStr));
                }
                newPet.setGender(newPetGender);
                
                petId = petDAO.addPetAndGetId(newPet);
                if (petId == -1) {
                    throw new ServletException("Không thể tạo hồ sơ thú cưng mới.");
                }
            }

            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String reason = request.getParameter("reason");

            // Combine date & time into Timestamp robustly
            if (timeStr != null && timeStr.length() == 5) {
                timeStr += ":00";
            }
            String dateTimeStr = dateStr + " " + timeStr;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            java.util.Date parsedDate = sdf.parse(dateTimeStr);
            Timestamp appointmentDate = new Timestamp(parsedDate.getTime());

            // Fetch the service details to get the price
            Service service = serviceDAO.getServiceById(serviceId);
            if (service == null) {
                throw new ServletException("Dịch vụ không tồn tại.");
            }

            // Create Appointment
            Appointment app = new Appointment();
            app.setCustomerId(user.getId());
            app.setPetId(petId);
            app.setAppointmentDate(appointmentDate);
            app.setReason(reason);
            app.setServiceId(serviceId);
            app.setPriceAtBooking(service.getPrice());

            boolean success = appointmentDAO.addAppointment(app);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
                request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi lưu lịch hẹn. Vui lòng thử lại!");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Dữ liệu nhập không hợp lệ hoặc thiếu thông tin. Vui lòng kiểm tra lại!");
            doGet(request, response);
        }
    }
}
