package com.petcare.controller;

import com.petcare.dao.UserDAO;
import com.petcare.model.User;
import com.petcare.util.CsrfUtil;
import com.petcare.util.RedirectUtil; // Redirect helper
import com.petcare.util.SessionUtil; // Session helper

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String redirect = RedirectUtil.sanitizeRedirect(request.getParameter("redirect"));
        if (redirect != null) {
            request.setAttribute("redirect", redirect);
        }
        CsrfUtil.getToken(request);
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!CsrfUtil.isValid(request)) {
            request.setAttribute("error", "Phiên biểu mẫu không hợp lệ. Vui lòng thử lại.");
            doGet(request, response);
            return;
        }

        String username = request.getParameter("username");
        String passwordRaw = request.getParameter("password");

        if (username == null || passwordRaw == null || username.trim().isEmpty() || passwordRaw.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            doGet(request, response);
            return;
        }

        User user = userDAO.login(username, passwordRaw);
        String redirect = RedirectUtil.sanitizeRedirect(request.getParameter("redirect"));

        if (user != null) {
            SessionUtil.bindUser(request, user);

            if ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else if (redirect != null) {
                response.sendRedirect(request.getContextPath() + "/" + redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            doGet(request, response);
        }
    }
}