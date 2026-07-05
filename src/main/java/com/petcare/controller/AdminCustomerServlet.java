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
import java.util.List;

@WebServlet({
    "/admin/customers",
    "/admin/customers/new",
    "/admin/customers/insert",
    "/admin/customers/edit",
    "/admin/customers/update",
    "/admin/customers/update-status"
})
public class AdminCustomerServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Tạo CSRF token để chống tấn công giả mạo request
        CsrfUtil.getToken(request);

        if ("/admin/customers/new".equals(path)) {
            // Mở trang thêm mới khách hàng
            request.setAttribute("customer", new User());
            request.setAttribute("actionUrl", request.getContextPath() + "/admin/customers/insert");
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/customer-form.jsp").forward(request, response);
        } else if ("/admin/customers/edit".equals(path)) {
            // Mở trang sửa thông tin khách hàng
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                User customer = userDAO.getUserById(id);
                // Chỉ cho sửa nếu đúng là tài khoản Khách hàng
                if (customer != null && "CUSTOMER".equals(customer.getRole())) {
                    request.setAttribute("customer", customer);
                    request.setAttribute("actionUrl", request.getContextPath() + "/admin/customers/update");
                    request.setAttribute("isEdit", true);
                    request.getRequestDispatcher("/WEB-INF/views/dashboard/customer-form.jsp").forward(request, response);
                } else {
                    request.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng.");
                    response.sendRedirect(request.getContextPath() + "/admin/customers");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Yêu cầu không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/admin/customers");
            }
        } else {
            // Xem danh sách khách hàng (có tìm kiếm và lọc trạng thái)
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");

            List<User> listCustomers = userDAO.searchCustomers(keyword, status);
            request.setAttribute("listCustomers", listCustomers);
            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/customer-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra mã CSRF để đảm bảo form gửi lên là an toàn
        if (!CsrfUtil.isValid(request)) {
            session.setAttribute("errorMessage", "Phiên làm việc hết hạn hoặc yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/customers");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/customers/insert".equals(path)) {
            // Xử lý thêm khách hàng mới
            String fullName = request.getParameter("fullName");
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Kiểm tra các trường bắt buộc
            if (ValidationUtil.isEmpty(fullName) || ValidationUtil.isEmpty(username) || ValidationUtil.isEmpty(phone)) {
                session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ các trường bắt buộc.");
                response.sendRedirect(request.getContextPath() + "/admin/customers/new");
                return;
            }

            // Kiểm tra tên tài khoản (4-50 kí tự, ko dấu)
            if (!username.matches("^[A-Za-z0-9_]{4,50}$")) {
                session.setAttribute("errorMessage", "Tên đăng nhập phải từ 4-50 ký tự và chỉ chứa chữ cái, số, dấu gạch dưới.");
                response.sendRedirect(request.getContextPath() + "/admin/customers/new");
                return;
            }

            // Kiểm tra số điện thoại (10 số, bắt đầu bằng số 0)
            if (!ValidationUtil.isValidPhone(phone)) {
                session.setAttribute("errorMessage", "Số điện thoại không hợp lệ (phải bắt đầu bằng số 0 và gồm 10 chữ số).");
                response.sendRedirect(request.getContextPath() + "/admin/customers/new");
                return;
            }

            // Kiểm tra định dạng email
            if (!ValidationUtil.isEmpty(email) && !ValidationUtil.isValidEmail(email)) {
                session.setAttribute("errorMessage", "Địa chỉ email không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/admin/customers/new");
                return;
            }

            // Kiểm tra xem username trùng không
            if (userDAO.checkUsernameExist(username)) {
                session.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại.");
                response.sendRedirect(request.getContextPath() + "/admin/customers/new");
                return;
            }

            // Kiểm tra xem email trùng không
            if (!ValidationUtil.isEmpty(email) && userDAO.checkEmailExist(email)) {
                session.setAttribute("errorMessage", "Email đã tồn tại.");
                response.sendRedirect(request.getContextPath() + "/admin/customers/new");
                return;
            }

            // Gán dữ liệu khách hàng mới
            User newCustomer = new User();
            newCustomer.setFullName(fullName.trim());
            newCustomer.setUsername(username.trim());
            newCustomer.setPhone(phone.trim());
            newCustomer.setEmail(ValidationUtil.isEmpty(email) ? null : email.trim());
            
            // Nếu không nhập mật khẩu thì lấy mặc định là 123456 cho nhanh
            if (ValidationUtil.isEmpty(password)) {
                password = "123456";
            }
            newCustomer.setPassword(HashUtil.hashPassword(password));

            boolean success = userDAO.registerUser(newCustomer);
            if (success) {
                session.setAttribute("successMessage", "Thêm khách hàng mới thành công. Mật khẩu mặc định là: " + password);
            } else {
                session.setAttribute("errorMessage", "Không thể tạo tài khoản khách hàng.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/customers");

        } else if ("/admin/customers/update".equals(path)) {
            // Xử lý cập nhật thông tin khách hàng
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");

                User customer = userDAO.getUserById(id);
                if (customer == null || !"CUSTOMER".equals(customer.getRole())) {
                    session.setAttribute("errorMessage", "Không tìm thấy khách hàng.");
                    response.sendRedirect(request.getContextPath() + "/admin/customers");
                    return;
                }

                if (ValidationUtil.isEmpty(fullName) || ValidationUtil.isEmpty(phone)) {
                    session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ các trường bắt buộc.");
                    response.sendRedirect(request.getContextPath() + "/admin/customers/edit?id=" + id);
                    return;
                }

                if (!ValidationUtil.isValidPhone(phone)) {
                    session.setAttribute("errorMessage", "Số điện thoại không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/customers/edit?id=" + id);
                    return;
                }

                if (!ValidationUtil.isEmpty(email) && !ValidationUtil.isValidEmail(email)) {
                    session.setAttribute("errorMessage", "Địa chỉ email không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/customers/edit?id=" + id);
                    return;
                }

                // Nếu đổi email khác thì phải check xem email mới đã có ai dùng chưa
                if (!ValidationUtil.isEmpty(email) && !email.trim().equalsIgnoreCase(customer.getEmail())) {
                    if (userDAO.checkEmailExist(email)) {
                        session.setAttribute("errorMessage", "Email đã tồn tại.");
                        response.sendRedirect(request.getContextPath() + "/admin/customers/edit?id=" + id);
                        return;
                    }
                }

                customer.setFullName(fullName.trim());
                customer.setPhone(phone.trim());
                customer.setEmail(ValidationUtil.isEmpty(email) ? null : email.trim());

                boolean success = userDAO.updateCustomerByAdmin(customer);
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật thông tin khách hàng thành công.");
                } else {
                    session.setAttribute("errorMessage", "Không thể cập nhật thông tin khách hàng.");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Yêu cầu không hợp lệ.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/customers");

        } else if ("/admin/customers/update-status".equals(path)) {
            // Xử lý khóa hoặc mở khóa tài khoản
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                int status = Integer.parseInt(request.getParameter("status"));
                boolean success = userDAO.updateUserStatus(id, status);
                if (success) {
                    session.setAttribute("successMessage", status == 1 ? "Đã mở khóa tài khoản thành công." : "Đã khóa tài khoản thành công.");
                } else {
                    session.setAttribute("errorMessage", "Không thể cập nhật trạng thái tài khoản.");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Yêu cầu không hợp lệ.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/customers");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
