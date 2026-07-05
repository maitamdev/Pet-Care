package com.petcare.controller;

import com.petcare.dao.UserDAO;
import com.petcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty()) {
            request.setAttribute("redirect", redirect);
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String username = request.getParameter("username");
        String passwordRaw = request.getParameter("password");

        if (username == null || passwordRaw == null || username.trim().isEmpty() || passwordRaw.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.login(username, passwordRaw);

        String redirect = request.getParameter("redirect");

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                if (redirect != null && !redirect.trim().isEmpty()) {
                    String target = redirect.trim();
                    if (target.startsWith("/")) {
                        target = target.substring(1);
                    }
                    if (target.startsWith("booking")) {
                        response.sendRedirect(request.getContextPath() + "/" + target);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/home");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
