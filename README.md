# PetCare Clinic

Hệ thống Quản lý Phòng Khám Thú Y & Đặt Lịch Hẹn Trực Tuyến.

## 1. Thông tin nhóm

| STT | Họ và tên | Vai trò |
| :---: | :--- | :--- |
| 1 | Mai Trần Thiện Tâm | Trưởng nhóm |
| 2 | Nguyễn Hoàng Trung Hiếu | Thành viên |
| 3 | Châu Thanh Sang | Thành viên |
| 4 | Nguyễn Thanh Thiên | Thành viên |
| 5 | La Gia Thành | Thành viên |

- **Giảng viên hướng dẫn:** TS. Lê Duy Tân

## 2. Mô tả đề tài

PetCare Clinic là website quản lý phòng khám thú y được phát triển trên nền tảng Java Web (Servlet/JSP), nhằm hỗ trợ tối ưu các hoạt động vận hành phòng khám và cung cấp cổng đặt lịch hẹn trực tuyến cho khách hàng. Hệ thống phục vụ ba nhóm người dùng: Quản trị viên (Admin), Nhân viên (Staff) và Khách hàng (Customer).

## 3. Công nghệ sử dụng

- Java 17
- Java Servlet API
- JSP (JavaServer Pages) & JSTL
- JDBC (Java Database Connectivity)
- HTML5, CSS3, JavaScript
- MySQL Server 8
- Apache Tomcat (Tomcat Maven Plugin)
- Apache Maven
- jBCrypt (mã hóa mật khẩu)
- JUnit 5 (kiểm thử tự động)

## 4. Các chức năng chính

1. Đăng ký, đăng nhập, đăng xuất và phân quyền (Admin / Staff / Customer).
2. Trang chủ giới thiệu phòng khám và dịch vụ.
3. Đặt lịch hẹn khám trực tuyến cho thú cưng.
4. Quản lý hồ sơ thú cưng (thêm, sửa, xóa, upload ảnh).
5. Quản lý dịch vụ y tế (thêm, sửa, xóa, tìm kiếm).
6. Quản lý lịch hẹn (phê duyệt, cập nhật trạng thái, ghi chú bệnh án lâm sàng).
7. Quản lý hóa đơn thanh toán (tạo, sửa, cập nhật trạng thái).
8. Quản lý nhân viên & bác sĩ thú y.
9. Quản lý thông tin khách hàng.
10. Thống kê và báo cáo doanh thu phòng khám.
11. Quản lý hồ sơ cá nhân và đổi mật khẩu.

## 5. Hướng dẫn cài đặt

### Yêu cầu hệ thống

- JDK 17
- Maven 3.8+
- MySQL Server 8+

### Các bước cài đặt

1. Clone project từ GitHub:
   ```bash
   git clone https://github.com/maitamdev/Pet-Care.git
   cd Pet-Care
   ```

2. Import database vào MySQL:
   ```sql
   source database/petcare_db.sql;
   ```

3. Chạy project:
   
   ```bash
   mvn tomcat7:run
   ```

4. Mở trình duyệt truy cập:
   ```
   http://localhost:8080/PetCareClinic
   ```

## 6. Tài khoản demo

| Vai trò | Username | Password |
| :--- | :--- | :--- |
| Admin | admin | 123456 |

Tài khoản Customer có thể đăng ký trực tiếp trên giao diện web.

## 7. Cấu trúc thư mục

```
Pet-Care/
├── database/
│   └── petcare_db.sql
├── src/main/java/com/petcare/
│   ├── config/
│   ├── controller/
│   ├── dao/
│   ├── filter/
│   ├── model/
│   └── util/
├── src/main/webapp/
│   ├── assets/css/
│   ├── assets/js/
│   ├── assets/images/
│   ├── WEB-INF/views/
│   └── index.jsp
├── src/test/java/
├── report/
├── slides/
├── video/
├── pom.xml
└── README.md
```

## 8. Video thuyết trình và demo

> Video thuyết trình và demo sản phẩm: [Xem tại đây](video/)
