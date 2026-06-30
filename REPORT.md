# BÁO CÁO TIẾN ĐỘ DỰ ÁN PETCARE CLINIC
*(Hệ thống Quản lý và Đặt lịch khám thú cưng)*

## 1. GIỚI THIỆU CHUNG
Dự án **PetCare Clinic** là hệ thống website hỗ trợ quản lý phòng khám thú y và cho phép khách hàng đặt lịch khám trực tuyến. Dự án được phát triển theo mô hình MVC (Model-View-Controller) sử dụng công nghệ Java Web tiêu chuẩn (Servlet, JSP, JDBC, MySQL).

## 2. CÔNG NGHỆ SỬ DỤNG
* **Backend:** Java 17, Servlet API 4.0.1, JDBC
* **Frontend:** JSP, JSTL 1.2, Vanilla CSS, Bootstrap Icons
* **Cơ sở dữ liệu:** MySQL 8.0, MySQL Connector/J 8.3.0
* **Build tool:** Maven (đóng gói dạng WAR)
* **Web Server:** Apache Tomcat 9

---

## 3. HIỆN TRẠNG HỆ THỐNG (ĐÃ CÓ GÌ)
Hiện tại, dự án đã xây dựng xong phần khung nền tảng bao gồm cấu trúc thư mục, kết nối cơ sở dữ liệu và giao diện trang chủ công cộng.

### 3.1. Cơ sở dữ liệu (Database Schema)
Đã khởi tạo database `petcare_db` với 2 bảng dữ liệu cơ bản:
* **Bảng `users`**: Lưu trữ tài khoản người dùng (mặc định đã có tài khoản `admin` / mật khẩu `123456`).
* **Bảng `services`**: Lưu trữ thông tin 6 dịch vụ chăm sóc thú cưng mẫu.

### 3.2. Cấu trúc mã nguồn Java Backend
* **Cấu hình kết nối**: Lớp [DBConnection.java](file:///d:/Pet-Care/src/main/java/com/petcare/config/DBConnection.java) cấu hình kết nối JDBC tới MySQL.
* **Controller**:
  * [HomeServlet.java](file:///d:/Pet-Care/src/main/java/com/petcare/controller/HomeServlet.java) điều hướng request `/home` hiển thị trang chủ.
  * [DatabaseTestServlet.java](file:///d:/Pet-Care/src/main/java/com/petcare/controller/DatabaseTestServlet.java) điều hướng request `/test-db` kiểm tra trạng thái kết nối cơ sở dữ liệu trực quan trên trình duyệt.
* **DAO (Data Access Object)**:
  * [UserDAO.java](file:///d:/Pet-Care/src/main/java/com/petcare/dao/UserDAO.java) hỗ trợ phương thức đăng nhập cơ bản (`login`).
* **Util & Filter**:
  * [ValidationUtil.java](file:///d:/Pet-Care/src/main/java/com/petcare/util/ValidationUtil.java) kiểm tra tính hợp lệ của email, số điện thoại Việt Nam và chuỗi rỗng.
  * [AuthFilter.java](file:///d:/Pet-Care/src/main/java/com/petcare/filter/AuthFilter.java) lớp lọc phân quyền (hiện đang là khung trống).
* **Model**:
  * Lớp đối tượng [User.java](file:///d:/Pet-Care/src/main/java/com/petcare/model/User.java) ánh xạ dữ liệu từ bảng `users`.

### 3.3. Giao diện (Frontend)
* **Trang chào mừng (`index.jsp`)**: Trang chuyển hướng ban đầu.
* **Trang chủ (`home.jsp`)**: Giao diện giới thiệu dịch vụ phòng khám, thông tin đặt lịch, liên hệ và lý do chọn phòng khám. Đã có CSS/JS đi kèm đầy đủ.
* **Trang Login (`login.jsp`)**: Khung giao diện giữ chỗ.
* **Trang Dashboard (`dashboard/index.jsp`)**: Khung giao diện giữ chỗ cho quản trị viên và nhân viên.

---

## 4. KẾ HOẠCH PHÁT TRIỂN (CẦN CODE GÌ TIẾP THEO)
Để hoàn thiện đồ án đáp ứng các tiêu chuẩn chấm điểm (CRUD, đầy đủ chức năng quản lý, quan hệ dữ liệu liên kết), nhóm cần triển khai các bước tiếp theo sau đây:

### Bước 1: Mở rộng Cơ sở dữ liệu
* Tạo thêm các bảng: `pets` (thú cưng), `appointments` (lịch hẹn), `appointment_details` (dịch vụ trong lịch hẹn), và `invoices` (hóa đơn thanh toán) để thiết lập mối quan hệ dữ liệu đầy đủ.

### Bước 2: Xây dựng Chức năng Đăng nhập & Đăng ký
* Hoàn thiện form trong trang `login.jsp`.
* Viết `LoginServlet` và `RegisterServlet` để tiếp nhận dữ liệu đăng nhập/đăng ký.
* Mã hóa mật khẩu khi đăng ký (sử dụng MD5 hoặc SHA-256) trước khi lưu vào cơ sở dữ liệu.

### Bước 3: Hiện thực hóa Bộ lọc bảo mật (`AuthFilter`)
* Viết logic kiểm tra session trong `AuthFilter`.
* Nếu người dùng chưa đăng nhập hoặc không đúng quyền (`ADMIN`, `STAFF`), hệ thống sẽ chặn và chuyển hướng về trang đăng nhập khi họ cố truy cập vào các đường dẫn nội bộ `/admin/*` hoặc `/staff/*`.

### Bước 4: Phát triển Trang Dashboard Quản trị (Dành cho Admin & Staff)
* Thiết kế giao diện Dashboard hoàn chỉnh (Sidebar điều hướng, khu vực hiển thị nội dung).
* Xây dựng giao diện danh sách và các form Thêm/Sửa/Xóa.

### Bước 5: Viết các API / Servlet CRUD chi tiết
* **CRUD Dịch vụ (Admin):** Thêm mới dịch vụ khám, chỉnh sửa giá tiền, cập nhật trạng thái hoạt động.
* **CRUD Thú cưng (Khách hàng & Nhân viên):** Cho phép người nuôi quản lý thông tin thú cưng của họ.
* **Nghiệp vụ Đặt lịch khám (Khách hàng):** Khách hàng chọn thú cưng, chọn ngày giờ khám, chọn dịch vụ khám -> Lưu thông tin lịch hẹn vào database với trạng thái `PENDING`.
* **Duyệt và Cập nhật lịch khám (Staff):** Nhân viên xác nhận lịch khám, cập nhật kết quả bệnh án sau khi khám xong.
* **Tạo và thanh toán Hóa đơn (Staff):** Tự động tính tiền từ lịch hẹn và dịch vụ đi kèm, chuyển trạng thái thanh toán.

### Bước 6: Thống kê & Báo cáo số liệu (Admin)
* Xây dựng Servlet thống kê doanh thu theo tháng và năm.
* Sử dụng thư viện biểu đồ Javascript (Chart.js) hiển thị trực quan dữ liệu doanh thu lên Dashboard của Admin.
