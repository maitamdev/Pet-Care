# 🐾 PetCare Clinic - Hệ Thống Quản Lý & Đặt Lịch Khám Thú Cưng

Website quản lý phòng khám thú y và đặt lịch khám trực tuyến chuyên nghiệp được phát triển theo mô hình **MVC (Model-View-Controller)** sử dụng công nghệ Java Web tiêu chuẩn.

---

## ✨ Các Tính Năng Nổi Bật

### 🌐 Dành Cho Khách Hàng (Công Cộng)
*   **Giao diện trang chủ:** Giới thiệu dịch vụ phòng khám, đội ngũ bác sĩ và liên hệ với phong cách thiết kế hiện đại, responsive.
*   **Đăng ký & Đăng nhập:** Hệ thống xác thực người dùng an toàn.
*   **Đặt lịch khám thông minh:** 
    *   Chọn bé thú cưng đã đăng ký hoặc đăng ký hồ sơ nhanh cho bé mới ngay trên form đặt lịch.
    *   Lựa chọn dịch vụ khám chuyên biệt và hiển thị giá tiền minh bạch.
    *   Hẹn ngày giờ khám linh hoạt (có kiểm tra giới hạn thời gian thực tế).

### ⚙️ Dành Cho Quản Trị Viên & Nhân Viên (Dashboard)
*   **Dashboard thống kê trực quan:** Cập nhật số liệu thực tế về doanh thu tháng, tổng số ca khám hôm nay, số lịch hẹn chờ duyệt và tổng số hồ sơ thú cưng hoạt động.
*   **Quản lý lịch hẹn:**
    *   Danh sách lịch hẹn toàn hệ thống phân bổ màu sắc trực quan theo trạng thái (`Chờ duyệt`, `Đã xác nhận`, `Hoàn thành`, `Đã hủy`).
    *   Tính năng duyệt nhanh: Phê duyệt từ **Chờ duyệt ➔ Xác nhận**, chuyển tiếp sang **Hoàn thành** sau khi khám, hoặc **Hủy** lịch hẹn.
*   **Quản lý thú cưng:** Xem danh sách hồ sơ thú cưng của khách hàng, chỉnh sửa thông tin hoặc thêm hồ sơ mới.
*   **Quản lý dịch vụ:** Thêm mới dịch vụ, sửa tên/giá/mô tả và cập nhật trạng thái hoạt động của dịch vụ.

---

## 🛠️ Công Nghệ Sử Dụng

*   **Backend:** Java 17, Servlet API 4.0.1, JDBC
*   **Frontend:** JSP (JavaServer Pages), JSTL 1.2, Vanilla CSS, Bootstrap Icons
*   **Cơ sở dữ liệu:** MySQL 8.0, MySQL Connector/J 8.3.0
*   **Build Tool:** Maven 3.8+
*   **Web Server:** Apache Tomcat 9 (chạy trực tiếp thông qua Maven Plugin)

---

## 🚀 Hướng Dẫn Cài Đặt & Khởi Chạy

### 1. Chuẩn Bị Môi Trường
Đảm bảo máy tính của bạn đã cài đặt sẵn:
*   [JDK 17](https://www.oracle.com/java/technologies/downloads/#java17) hoặc cao hơn.
*   [Maven](https://maven.apache.org/download.cgi) (đã cấu hình biến môi trường).
*   [MySQL Server](https://dev.mysql.com/downloads/installer/).

---

### 2. Thiết Lập Cơ Sở Dữ Liệu
1.  Khởi động máy chủ MySQL (cổng mặc định `3306`).
2.  Mở công cụ quản lý MySQL của bạn (như MySQL Workbench, DBeaver, hoặc Navicat) và thực thi toàn bộ tệp tin SQL tại đường dẫn:
    `database/petcare_db.sql`
    *(Thao tác này sẽ tự động tạo database `petcare_db` cùng dữ liệu dịch vụ mẫu).*

---

### 3. Cấu Hình Kết Nối Database
Mở tệp tin [DBConnection.java](src/main/java/com/petcare/config/DBConnection.java):
```java
private static final String URL = "jdbc:mysql://localhost:3306/petcare_db" ...
private static final String USER = "root";
private static final String PASSWORD = "MAT_KHAU_MYSQL_CUA_BAN";
```
*   Thay đổi giá trị biến `PASSWORD` tương ứng với mật khẩu MySQL trên máy của bạn.

---

### 4. Khởi Chạy Dự Án
Mở terminal tại thư mục gốc của dự án (`Pet-Care`) và chạy các lệnh sau:

1.  **Dọn dẹp và Build dự án:**
    ```bash
    mvn clean install
    ```
2.  **Chạy dự án trực tiếp bằng Tomcat Maven Plugin:**
    ```bash
    mvn tomcat7:run
    ```
3.  Khi server khởi động hoàn tất, truy cập ứng dụng thông qua trình duyệt tại:
    👉 **[http://localhost:8080/PetCareClinic](http://localhost:8080/PetCareClinic)**

---

## 🔑 Tài Khoản Thử Nghiệm

Hệ thống đã chuẩn bị sẵn tài khoản quản trị để bạn test nhanh luồng duyệt lịch hẹn:

*   **Quyền Admin:**
    *   **Username:** `admin`
    *   **Password:** `123456`
*   **Quyền Khách hàng (Đặt lịch):**
    Bạn có thể tự đăng ký tài khoản khách hàng mới ngay trên giao diện web (trang Đăng ký) để trải nghiệm toàn bộ luồng nghiệp vụ từ đầu đến cuối.

---

## 📂 Cấu Trúc Mã Nguồn

```text
Pet-Care/
├── database/
│   └── petcare_db.sql        # File script khởi tạo database mẫu
├── src/
│   └── main/
│       ├── java/             # Source code Java (Servlet, DAO, Model, Config)
│       └── webapp/
│           ├── WEB-INF/
│           │   └── views/    # Giao diện JSP (public, dashboard, auth)
│           ├── assets/       # Tài nguyên tĩnh (css, images, js)
│           └── index.jsp     # Trang chuyển hướng mặc định
├── pom.xml                   # Cấu hình dự án Maven & Tomcat Plugin
└── README.md                 # Tài liệu hướng dẫn sử dụng
```
