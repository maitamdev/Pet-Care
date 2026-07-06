package com.petcare.controller;

import com.petcare.dao.UserDAO;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;
import com.petcare.util.FileUploadUtil;
import com.petcare.util.HashUtil;
import com.petcare.util.SessionUtil;
import com.petcare.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/my/profile")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (SessionUtil.requireUser(request, response) == null) {
            return;
        }
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User current = SessionUtil.requireUser(request, response);
        if (current == null) {
            return;
        }
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/my/profile?error=csrf");
            return;
        }

        String action = request.getParameter("action");
        if ("change-password".equals(action)) {
            changePassword(request, response, current);
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        if (ValidationUtil.isEmpty(fullName) ||
                (!ValidationUtil.isEmpty(phone) && !ValidationUtil.isValidPhone(phone)) ||
                (!ValidationUtil.isEmpty(email) && !ValidationUtil.isValidEmail(email))) {
            response.sendRedirect(request.getContextPath() + "/my/profile?error=invalid");
            return;
        }

        if (!ValidationUtil.isEmpty(email) && userDAO.checkEmailExist(email, current.getId())) {
            response.sendRedirect(request.getContextPath() + "/my/profile?error=email_exists");
            return;
        }

        current.setFullName(fullName.trim());
        current.setPhone(phone == null ? null : phone.trim());
        current.setEmail(email == null ? null : email.trim());
        String imageUrl = FileUploadUtil.saveImage(request.getPart("avatar"), getUploadRoot());
        if (imageUrl != null) {
            current.setImageUrl(imageUrl);
        }
        if (userDAO.updateProfile(current)) {
            SessionUtil.updateUser(request, current);
            response.sendRedirect(request.getContextPath() + "/my/profile?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/my/profile?error=update_failed");
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User current)
            throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String storedHash = userDAO.getPasswordHash(current.getId());

        if (ValidationUtil.isEmpty(currentPassword) || ValidationUtil.isEmpty(newPassword) ||
                !ValidationUtil.isValidPassword(newPassword) || !newPassword.equals(confirmPassword) ||
                !HashUtil.verifyPassword(currentPassword, storedHash)) {
            response.sendRedirect(request.getContextPath() + "/my/profile?error=password");
            return;
        }

        if (userDAO.updatePassword(current.getId(), HashUtil.hashPassword(newPassword))) {
            response.sendRedirect(request.getContextPath() + "/my/profile?success=password");
        } else {
            response.sendRedirect(request.getContextPath() + "/my/profile?error=password_update");
        }
    }

    private String getUploadRoot() {
        return getServletContext().getRealPath("/uploads");
    }
}