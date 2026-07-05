package com.petcare.controller;

import com.petcare.dao.UserDAO;
import com.petcare.model.User;
import com.petcare.util.HashUtil;
import com.petcare.util.ValidationUtil;

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
        // Trả về trang đăng ký khách hàng
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin đăng ký gửi từ form lên
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String passwordRaw = request.getParameter("password");
        String confirmPasswordRaw = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        // Kiểm tra xem có để trống các trường bắt buộc không
        if (ValidationUtil.isEmpty(fullName) || ValidationUtil.isEmpty(username) || ValidationUtil.isEmpty(passwordRaw) || ValidationUtil.isEmpty(confirmPasswordRaw)) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ các thông tin bắt buộc.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // So sánh xem mật khẩu và xác nhận mật khẩu có khớp nhau không
        if (!passwordRaw.equals(confirmPasswordRaw)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        fullName = fullName.trim();
        username = username.trim();
        phone = phone == null ? null : phone.trim();
        email = email == null ? null : email.trim();

        // Kiểm tra định dạng tài khoản (chữ cái, số, gạch dưới, dài từ 4 kí tự)
        if (!username.matches("^[A-Za-z0-9_]{4,50}$")) {
            request.setAttribute("error", "Tên đăng nhập chỉ gồm chữ, số, dấu gạch dưới và tối thiểu 4 ký tự.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Yêu cầu mật khẩu tối thiểu 8 kí tự để bảo mật
        if (passwordRaw.length() < 8) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra định dạng số điện thoại nếu có nhập
        if (phone != null && !phone.isEmpty() && !ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("error", "Số điện thoại không hợp lệ.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra định dạng email nếu có nhập
        if (email != null && !email.isEmpty() && !ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem tên tài khoản đã tồn tại trong DB chưa
        if (userDAO.checkUsernameExist(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem email đã có ai dùng chưa
        if (userDAO.checkEmailExist(email)) {
            request.setAttribute("error", "Email đã được sử dụng.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng khách hàng mới và mã hóa mật khẩu bằng BCrypt
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setUsername(username);
        newUser.setPassword(HashUtil.hashPassword(passwordRaw));
        newUser.setPhone(phone);
        newUser.setEmail(email);

        boolean success = userDAO.registerUser(newUser);

        if (success) {
            // Đăng ký thành công thì chuyển về trang login kèm thông báo
            response.sendRedirect(request.getContextPath() + "/login?registered=true");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}
