package com.petcare.controller;

import com.petcare.dao.UserDAO;
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

@WebServlet("/my/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!CsrfUtil.isValid(request)) {
            response.sendRedirect(request.getContextPath() + "/my/profile?error=csrf");
            return;
        }

        User current = currentUser(request);
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        if (ValidationUtil.isEmpty(fullName) ||
                (!ValidationUtil.isEmpty(phone) && !ValidationUtil.isValidPhone(phone)) ||
                (!ValidationUtil.isEmpty(email) && !ValidationUtil.isValidEmail(email))) {
            response.sendRedirect(request.getContextPath() + "/my/profile?error=invalid");
            return;
        }

        current.setFullName(fullName.trim());
        current.setPhone(phone == null ? null : phone.trim());
        current.setEmail(email == null ? null : email.trim());
        userDAO.updateProfile(current);
        request.getSession().setAttribute("user", current);
        response.sendRedirect(request.getContextPath() + "/my/profile?success=updated");
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (User) session.getAttribute("user");
    }
}
