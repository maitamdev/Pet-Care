package com.petcare.controller;

import com.petcare.dao.UserDAO;
import com.petcare.model.User;
import com.petcare.util.HashUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String passwordRaw = request.getParameter("password");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        if (fullName == null || username == null || passwordRaw == null || 
            fullName.trim().isEmpty() || username.trim().isEmpty() || passwordRaw.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Họ tên, Tài khoản và Mật khẩu!");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.checkUsernameExist(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác!");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setUsername(username);
        newUser.setPassword(HashUtil.hashPassword(passwordRaw));
        newUser.setPhone(phone);
        newUser.setEmail(email);

        boolean success = userDAO.registerUser(newUser);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/login?registered=true");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}
