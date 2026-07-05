package com.petcare.controller;

import com.petcare.dao.UserDAO;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;
import com.petcare.util.HashUtil;
import com.petcare.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/admin/staff", "/admin/staff/new", "/admin/staff/insert", "/admin/staff/edit", "/admin/staff/update", "/admin/staff/delete"})
public class StaffServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        CsrfUtil.getToken(request);
        String path = request.getServletPath();
        if ("/admin/staff/new".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/dashboard/staff-form.jsp").forward(request, response);
            return;
        }
        if ("/admin/staff/edit".equals(path)) {
            request.setAttribute("staff", userDAO.getUserById(parseInt(request.getParameter("id"))));
            request.getRequestDispatcher("/WEB-INF/views/dashboard/staff-form.jsp").forward(request, response);
            return;
        }

        request.setAttribute("listStaff", userDAO.getAllStaff());
        request.getRequestDispatcher("/WEB-INF/views/dashboard/staff-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/staff?error=csrf");
            return;
        }

        String path = request.getServletPath();
        if ("/admin/staff/delete".equals(path)) {
            userDAO.deactivateStaff(parseInt(request.getParameter("id")));
            response.sendRedirect(request.getContextPath() + "/admin/staff?success=deleted");
            return;
        }

        User staff = buildStaff(request);
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff?error=invalid");
            return;
        }

        if ("/admin/staff/update".equals(path)) {
            staff.setId(parseInt(request.getParameter("id")));
            userDAO.updateStaff(staff);
            response.sendRedirect(request.getContextPath() + "/admin/staff?success=updated");
        } else {
            String password = request.getParameter("password");
            if (ValidationUtil.isEmpty(staff.getUsername()) || ValidationUtil.isEmpty(password) ||
                    password.length() < 8 || userDAO.checkUsernameExist(staff.getUsername())) {
                response.sendRedirect(request.getContextPath() + "/admin/staff?error=invalid");
                return;
            }
            staff.setPassword(HashUtil.hashPassword(password));
            userDAO.addStaff(staff);
            response.sendRedirect(request.getContextPath() + "/admin/staff?success=created");
        }
    }

    private User buildStaff(HttpServletRequest request) {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        if (ValidationUtil.isEmpty(fullName)) {
            return null;
        }
        if (!ValidationUtil.isEmpty(phone) && !ValidationUtil.isValidPhone(phone)) {
            return null;
        }
        if (!ValidationUtil.isEmpty(email) && !ValidationUtil.isValidEmail(email)) {
            return null;
        }
        User staff = new User();
        staff.setFullName(fullName.trim());
        staff.setUsername(username == null ? null : username.trim());
        staff.setPhone(phone == null ? null : phone.trim());
        staff.setEmail(email == null ? null : email.trim());
        staff.setSpecialty(trim(request.getParameter("specialty")));
        return staff;
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
