# NỘI DUNG SLIDE VÀ KỊCH BẢN THUYẾT TRÌNH PETCARE CLINIC

> Tài liệu được phân tích từ source hiện tại trong dự án `D:\Pet-Care`, không dựa vào báo cáo tiến độ cũ `REPORT.md`.
>
> Trước khi đưa lên Canva, thay các phần `[Tên sinh viên/nhóm]` và `[Tên giảng viên]` bằng thông tin thật.

## I. Kết quả phân tích source code

### 1. Đề tài của website

**PetCare Clinic – Hệ thống quản lý phòng khám thú y và đặt lịch chăm sóc thú cưng trực tuyến.**

Hệ thống phục vụ ba nhóm đối tượng:

- **Khách hàng (CUSTOMER):** tạo tài khoản, quản lý hồ sơ cá nhân và thú cưng, đặt/hủy lịch khám, theo dõi lịch hẹn và hóa đơn.
- **Nhân viên/bác sĩ (STAFF):** theo dõi dashboard, tiếp nhận lịch hẹn, xác nhận hoặc hủy lịch, phân công người khám, ghi chẩn đoán, hoàn tất lịch và quản lý hóa đơn.
- **Quản trị viên (ADMIN):** có toàn bộ quyền của nhân viên và thêm quyền quản lý dịch vụ, tài khoản nhân viên, báo cáo thống kê.

### 2. Cấu trúc thư mục và vai trò

```text
Pet-Care/
├── database/
│   ├── petcare_db.sql          # Tạo CSDL, 6 bảng, dữ liệu mẫu
│   ├── invoices.sql            # Migration cho hóa đơn
│   └── refresh_services.sql    # Làm mới dữ liệu dịch vụ
├── src/main/java/com/petcare/
│   ├── config/                 # DBConnection: kết nối MySQL
│   ├── controller/             # 16 Servlet tiếp nhận và điều phối request
│   ├── dao/                    # 6 DAO làm việc với JDBC/MySQL
│   ├── filter/                 # AuthFilter: xác thực và phân quyền
│   ├── model/                  # 5 JavaBean ánh xạ dữ liệu
│   └── util/                   # Hash, CSRF, validation, upload ảnh
├── src/main/webapp/
│   ├── assets/css/             # CSS trang công khai và dashboard
│   ├── assets/js/              # JavaScript menu, cuộn trang
│   ├── assets/images/          # Logo, ảnh hero
│   ├── WEB-INF/views/          # JSP: public, auth, customer, dashboard
│   ├── WEB-INF/web.xml         # Welcome page, session timeout 30 phút
│   └── index.jsp               # Trang vào ban đầu
├── src/test/java/              # Test HashUtil và ValidationUtil
├── pom.xml                     # Maven, dependency, đóng gói WAR
└── setup.ps1 / run.ps1         # Cài đặt và chạy dự án
```

Các lớp chính:

- **Model:** `User`, `Pet`, `Service`, `Appointment`, `Invoice`.
- **View:** các trang JSP trong `WEB-INF/views`; dùng JSTL `<c:...>` và `<fmt:...>` để lặp, rẽ nhánh, escape và định dạng dữ liệu.
- **Controller:** các Servlet như `LoginServlet`, `BookingServlet`, `AdminAppointmentServlet`, `InvoiceServlet`.
- **DAO:** `UserDAO`, `PetDAO`, `ServiceDAO`, `AppointmentDAO`, `InvoiceDAO`, `ReportDAO`.
- **Filter/Utility:** `AuthFilter`, `CsrfUtil`, `HashUtil`, `ValidationUtil`, `FileUploadUtil`.

### 3. Công nghệ thực tế trong source

| Nhóm | Công nghệ | Vai trò trong dự án |
|---|---|---|
| Backend | Java 17 | Ngôn ngữ xử lý nghiệp vụ |
| Web backend | Servlet API 3.0.1 | Nhận GET/POST, điều hướng, quản lý session |
| View | JSP 2.2.1, JSTL 1.2 | Render giao diện và dữ liệu động |
| Data access | JDBC | Thực thi truy vấn và transaction |
| Database | MySQL 8, Connector/J 8.4.0 | Lưu tài khoản, thú cưng, lịch, dịch vụ, hóa đơn |
| Frontend | HTML5, CSS thuần, JavaScript thuần | Bố cục, responsive, tương tác giao diện |
| Icon | Bootstrap Icons 1.11.3 | Cung cấp biểu tượng; dự án **không dùng Bootstrap CSS** |
| Security | BCrypt 0.4, CSRF token, session/filter | Băm mật khẩu và bảo vệ request thay đổi dữ liệu |
| Build/Test | Maven, JUnit 5 | Quản lý dependency, build WAR, kiểm thử utility |
| Server | Tomcat qua Maven plugin | Chạy ứng dụng tại `/PetCareClinic` |

### 4. Mô hình tổ chức code

Dự án áp dụng **MVC kết hợp DAO**:

```text
Trình duyệt
   ↓ HTTP request
Servlet Controller ← AuthFilter / Session / CSRF
   ↓ gọi nghiệp vụ
DAO ← JDBC → MySQL
   ↓ trả Model/Collection
Servlet đặt request attribute
   ↓ forward
JSP + JSTL render HTML
   ↓ response
Trình duyệt
```

- **Model** chứa dữ liệu nghiệp vụ và các trường hỗ trợ JOIN để hiển thị.
- **View** nằm trong `WEB-INF`, người dùng không truy cập JSP nội bộ trực tiếp mà phải đi qua Servlet.
- **Controller** kiểm tra input, session, CSRF, gọi DAO và forward/redirect.
- **DAO** cô lập các câu SQL và ánh xạ `ResultSet` sang Model.
- Đây là MVC phù hợp quy mô bài tập lớn, nhưng chưa có **Service layer** riêng nên một số nghiệp vụ vẫn nằm trực tiếp trong Servlet/DAO.

### 5. Các chức năng chính

#### Chức năng công khai và khách hàng

- Xem trang chủ, giới thiệu phòng khám, dịch vụ và thông tin liên hệ.
- Đăng ký tài khoản, đăng nhập, đăng xuất.
- Cập nhật hồ sơ, ảnh đại diện; đổi mật khẩu.
- Xem, thêm, sửa hồ sơ thú cưng và tải ảnh thú cưng.
- Đặt lịch theo thú cưng, dịch vụ, ngày, giờ và lý do khám.
- Có thể tạo nhanh thú cưng ngay trong form đặt lịch.
- Kiểm tra lịch không ở quá khứ, chỉ trong 08:00–17:00 và tránh trùng khung giờ đang hoạt động.
- Xem danh sách lịch hẹn; hủy lịch khi đang `PENDING` hoặc `CONFIRMED`.
- Xem hóa đơn phát sinh từ lịch của chính mình.

#### Chức năng nhân viên

- Xem dashboard: lịch hôm nay, số lịch chờ duyệt, số thú cưng và doanh thu tháng.
- Xem toàn bộ lịch hẹn và bác sĩ/nhân viên.
- Chuyển trạng thái hợp lệ: `PENDING → CONFIRMED/CANCELLED`, `CONFIRMED → COMPLETED/CANCELLED`.
- Phân công nhân viên/bác sĩ và nhập chẩn đoán cho lịch đã xác nhận hoặc hoàn thành.
- Khi lịch chuyển sang `COMPLETED`, hệ thống tự tạo hóa đơn `UNPAID` từ giá đã lưu lúc đặt.
- Quản lý hồ sơ thú cưng và hóa đơn; tìm hóa đơn theo mã/tên, lọc theo trạng thái.
- Tạo hóa đơn thủ công, sửa hóa đơn, cập nhật `UNPAID/PAID/CANCELLED` và phương thức thanh toán.

#### Chức năng riêng của quản trị viên

- CRUD dịch vụ; thao tác “xóa” là **soft delete** bằng `status = 0`.
- Tìm kiếm dịch vụ theo tên, sắp xếp giá tăng/giảm.
- Thêm, sửa, vô hiệu hóa tài khoản nhân viên và chuyên môn.
- Xem báo cáo theo năm: doanh thu đã thanh toán, số lịch hoàn thành, doanh thu từng tháng, số lịch theo trạng thái, top 5 dịch vụ.

### 6. Phân tích cơ sở dữ liệu

Database `petcare_db` gồm **6 bảng**:

| Bảng | Vai trò | Khóa/quan hệ đáng chú ý |
|---|---|---|
| `users` | Tài khoản khách hàng, nhân viên, admin | `username` unique; `role` gồm ADMIN/STAFF/CUSTOMER |
| `services` | Danh mục dịch vụ và giá | Tên unique; `status` hỗ trợ ngừng hoạt động |
| `pets` | Hồ sơ thú cưng | `customer_id → users.id`, xóa user thì xóa pet |
| `appointments` | Lịch khám, trạng thái, bác sĩ, chẩn đoán | FK tới customer, pet, staff; staff có thể null |
| `appointment_details` | Dịch vụ thuộc lịch và giá tại lúc đặt | Khóa kép `(appointment_id, service_id)` |
| `invoices` | Hóa đơn và trạng thái thanh toán | `appointment_id` unique, nullable để hỗ trợ hóa đơn thủ công |

Quan hệ:

```text
users (CUSTOMER) 1 ─── N pets
users (CUSTOMER) 1 ─── N appointments
users (STAFF)    1 ─── N appointments (staff_id có thể null)
pets             1 ─── N appointments
appointments     1 ─── N appointment_details N ─── 1 services
appointments     1 ─── 0..1 invoices
```

Điểm thiết kế tốt:

- `appointment_details.price_at_booking` lưu giá tại thời điểm đặt, nên hóa đơn không bị thay đổi khi admin sửa giá dịch vụ sau này.
- Lịch và chi tiết lịch được thêm trong cùng JDBC transaction; lỗi ở bước hai sẽ rollback cả hai bảng.
- `appointment_id` trong hóa đơn có unique nên không tạo trùng hóa đơn cho một lịch.
- Hóa đơn thủ công dùng các trường `manual_customer_name`, `manual_pet_name`, `manual_service_name` và cho phép `appointment_id = NULL`.

### 7. Luồng nghiệp vụ chính

#### Luồng đăng nhập và phân quyền

1. Người dùng gửi username/password tới `/login`.
2. `LoginServlet` gọi `UserDAO.login()`.
3. `HashUtil.verifyPassword()` kiểm tra BCrypt; vẫn tương thích hash SHA-256 cũ.
4. Nếu hợp lệ, `User` được lưu vào session.
5. ADMIN/STAFF chuyển tới `/dashboard`; CUSTOMER về `/home` hoặc tiếp tục `/booking`.
6. `AuthFilter` chặn trang cần đăng nhập và giới hạn quyền theo vai trò.

#### Luồng đặt lịch đến thanh toán

1. CUSTOMER đăng nhập và chọn thú cưng hoặc tạo nhanh hồ sơ mới.
2. Chọn một dịch vụ, ngày, giờ và nhập lý do.
3. `BookingServlet` kiểm tra CSRF, chủ sở hữu thú cưng, thời gian và trùng lịch.
4. `AppointmentDAO` dùng transaction tạo `appointments` ở trạng thái `PENDING` và `appointment_details`.
5. STAFF xác nhận lịch thành `CONFIRMED`, phân công người khám và ghi chẩn đoán.
6. STAFF chuyển lịch thành `COMPLETED`.
7. `InvoiceDAO` tự tổng hợp `price_at_booking` và tạo hóa đơn `UNPAID`.
8. Nhân viên cập nhật phương thức thanh toán và trạng thái `PAID`; CUSTOMER xem hóa đơn trong tài khoản.

### 8. Điểm mạnh, hạn chế và hướng phát triển

#### Điểm mạnh

- Phân vai rõ ràng cho CUSTOMER, STAFF, ADMIN; có kiểm soát cả giao diện và URL.
- Nghiệp vụ xuyên suốt từ hồ sơ thú cưng → đặt lịch → khám/chẩn đoán → hóa đơn → báo cáo.
- Dùng PreparedStatement ở DAO, hạn chế SQL Injection.
- BCrypt cost 12 cho mật khẩu mới; có cơ chế tương thích dữ liệu SHA-256 cũ.
- CSRF token cho phần lớn form thay đổi dữ liệu; JSP dùng `<c:out>` ở nhiều vị trí.
- Kiểm tra chủ sở hữu pet trước khi đặt/sửa và giới hạn thao tác theo customer ID.
- Có transaction khi tạo lịch, state transition rõ ràng, soft delete dịch vụ.
- Có upload ảnh với tên UUID, giới hạn 2 MB và phần mở rộng.
- Dự án build WAR thành công; 6/6 test JUnit hiện có đều đạt.

#### Hạn chế thực tế

- Chưa có Service layer nên Controller/DAO còn gánh một phần nghiệp vụ.
- Kết nối JDBC tạo mới theo từng thao tác, chưa dùng connection pool.
- Test mới bao phủ Hash/Validation; chưa có integration test cho DAO, Servlet và luồng đặt lịch.
- Chưa có phân trang; danh sách lịch, pet, dịch vụ có thể chậm khi dữ liệu lớn.
- Chống trùng lịch đang khóa **toàn phòng khám theo một timestamp**, chưa dựa theo bác sĩ/phòng khám; sẽ hạn chế nhiều ca khám song song.
- Upload mới kiểm tra phần mở rộng, chưa kiểm tra MIME/nội dung ảnh; file lưu trong webapp runtime có thể mất khi redeploy.
- Chưa có email/SMS nhắc lịch, thanh toán online, quên mật khẩu và audit log.
- `DBConnection` vẫn có mật khẩu mặc định cho môi trường local; khi triển khai thật phải bắt buộc biến môi trường/secret.
- `REPORT.md` và nội dung kỹ thuật ở `index.jsp` là tài liệu cũ, không còn khớp source hiện tại; cần cập nhật trước khi nộp.

#### Hướng phát triển

- Thêm Service layer, DTO, connection pool và xử lý lỗi/log tập trung.
- Tạo lịch theo bác sĩ/phòng/ca làm việc; hỗ trợ nhiều dịch vụ trong một lịch.
- Tích hợp email/SMS nhắc lịch và cổng thanh toán sandbox.
- Thêm phân trang, tìm kiếm nâng cao, dashboard biểu đồ và xuất PDF/Excel.
- Tăng test coverage với database test riêng và kiểm thử luồng end-to-end.
- Lưu ảnh trên object storage, kiểm tra MIME và quét file.
- Bổ sung quên mật khẩu, xác minh email, audit log và chính sách mật khẩu/session chặt hơn.

---

## II. Nội dung 12 slide Canva và lời thuyết trình

## Slide 1 — Trang bìa

### Nội dung ngắn gọn trên Canva

**PETCARE CLINIC**  
Hệ thống quản lý phòng khám thú y & đặt lịch trực tuyến

- Môn: Lập trình Website
- Sinh viên/nhóm: `[Tên sinh viên/nhóm]`
- Giảng viên hướng dẫn: `[Tên giảng viên]`
- Công nghệ chính: Java JSP/Servlet – JDBC – MySQL

### Hình ảnh nên chèn

- Logo `petcare_logo_full.png`.
- Ảnh hero có bác sĩ và thú cưng từ trang chủ.
- Một nhãn nhỏ “Java Web MVC”.

### Lời thuyết trình (30–45 giây)

“Em xin chào thầy/cô và các bạn. Hôm nay em xin trình bày bài tập lớn môn Lập trình Website với đề tài PetCare Clinic. Đây là hệ thống quản lý phòng khám thú y kết hợp chức năng đặt lịch khám trực tuyến. Website được xây dựng bằng Java Servlet, JSP, JDBC và MySQL theo mô hình MVC kết hợp DAO. Trong phần trình bày, em sẽ giới thiệu bài toán, kiến trúc source, cơ sở dữ liệu, luồng đặt lịch đến hóa đơn và demo các chức năng theo ba vai trò khách hàng, nhân viên và quản trị viên.”

## Slide 2 — Lý do chọn đề tài

### Nội dung ngắn gọn trên Canva

**Vì sao chọn PetCare Clinic?**

- Nhu cầu chăm sóc thú cưng ngày càng phổ biến
- Đặt lịch thủ công dễ trùng giờ, khó theo dõi
- Hồ sơ thú cưng, lịch khám và hóa đơn thường rời rạc
- Phù hợp để áp dụng CRUD, phân quyền và quy trình nghiệp vụ thực tế

### Hình ảnh nên chèn

- Sơ đồ “Trước: sổ tay/điện thoại → Sau: một hệ thống tập trung”.
- Ảnh khu vực “Vì sao chọn PetCare?” trên trang chủ.

### Lời thuyết trình (35–50 giây)

“Em chọn đề tài này vì việc nuôi và chăm sóc thú cưng ngày càng phổ biến, trong khi nhiều phòng khám nhỏ vẫn nhận lịch qua điện thoại hoặc ghi chép thủ công. Cách làm đó dễ trùng giờ, khó tìm lại hồ sơ và khó theo dõi công nợ. PetCare Clinic tập trung thông tin khách hàng, thú cưng, dịch vụ, lịch khám và hóa đơn trong cùng một hệ thống. Đề tài cũng có tính thực tế cao và phù hợp với môn học vì bao quát đăng nhập, CRUD, session, phân quyền, quan hệ cơ sở dữ liệu và quy trình xử lý nhiều bước.”

## Slide 3 — Mục tiêu đề tài

### Nội dung ngắn gọn trên Canva

**Mục tiêu hệ thống**

- Số hóa quy trình đặt và xử lý lịch khám
- Cho khách hàng tự quản lý hồ sơ thú cưng
- Hỗ trợ nhân viên xác nhận, khám và lập hóa đơn
- Hỗ trợ admin quản lý dịch vụ, nhân sự và báo cáo
- Đảm bảo dữ liệu đúng quyền, nhất quán và dễ tra cứu

### Hình ảnh nên chèn

- Ba biểu tượng/người dùng: Customer – Staff – Admin.
- Một mũi tên quy trình: Đặt lịch → Khám → Hóa đơn → Báo cáo.

### Lời thuyết trình (35–50 giây)

“Mục tiêu chính là số hóa toàn bộ quy trình cơ bản của một phòng khám thú y. Với khách hàng, hệ thống giúp tạo hồ sơ thú cưng, đặt lịch và theo dõi kết quả. Với nhân viên, hệ thống hỗ trợ duyệt lịch, phân công người khám, nhập chẩn đoán và xử lý hóa đơn. Với admin, hệ thống bổ sung quản lý dịch vụ, nhân sự và thống kê theo năm. Bên cạnh chức năng, em đặt mục tiêu dữ liệu phải nhất quán, người dùng chỉ thao tác đúng phần được phân quyền và những bước quan trọng phải có kiểm tra hợp lệ.”

## Slide 4 — Công nghệ sử dụng

### Nội dung ngắn gọn trên Canva

| Tầng | Công nghệ |
|---|---|
| Giao diện | JSP, JSTL, HTML5, CSS, JavaScript, Bootstrap Icons |
| Xử lý | Java 17, Servlet 3.0.1 |
| Dữ liệu | JDBC, MySQL 8, Connector/J 8.4 |
| Bảo mật | Session, AuthFilter, CSRF, BCrypt |
| Công cụ | Maven, JUnit 5, Tomcat, WAR |

Ghi chú nhỏ: **Bootstrap Icons, không dùng Bootstrap CSS.**

### Hình ảnh nên chèn

- Logo Java, JSP/Servlet, MySQL, Maven và Tomcat theo một hàng.
- Không nên chèn quá 6 logo.

### Lời thuyết trình (45–60 giây)

“Ở phía backend, dự án dùng Java 17 và Servlet để nhận request, xử lý session, validation và điều hướng. JSP kết hợp JSTL chịu trách nhiệm hiển thị dữ liệu động. Tầng dữ liệu sử dụng JDBC và MySQL 8; driver thực tế trong pom là MySQL Connector/J 8.4. Giao diện được viết bằng HTML, CSS và JavaScript thuần; Bootstrap chỉ được dùng bộ icon chứ không dùng framework CSS. Maven quản lý dependency và đóng gói ứng dụng thành file WAR. Về bảo mật, source có BCrypt để băm mật khẩu, AuthFilter để phân quyền và CSRF token cho các form thay đổi dữ liệu. Dự án cũng có JUnit 5 để kiểm thử các utility.”

## Slide 5 — Phân tích chức năng hệ thống

### Nội dung ngắn gọn trên Canva

**CUSTOMER**

- Hồ sơ cá nhân & thú cưng
- Đặt/hủy lịch khám
- Theo dõi lịch & hóa đơn

**STAFF**

- Duyệt lịch, phân công bác sĩ
- Ghi chẩn đoán, hoàn tất lịch
- Quản lý pet & hóa đơn

**ADMIN**

- Toàn bộ quyền STAFF
- Quản lý dịch vụ, nhân viên
- Báo cáo doanh thu & top dịch vụ

### Hình ảnh nên chèn

- Bố cục ba cột theo ba vai trò.
- Mỗi cột dùng một màu và một icon khác nhau.

### Lời thuyết trình (45–60 giây)

“Hệ thống chia chức năng theo ba vai trò. Customer có thể đăng ký, cập nhật hồ sơ, thêm hoặc sửa thú cưng, đặt lịch, hủy lịch còn hiệu lực và xem hóa đơn của chính mình. Staff làm việc tại dashboard, xác nhận hoặc hủy lịch, phân công người khám, ghi chẩn đoán và hoàn tất lịch để sinh hóa đơn. Staff cũng có thể quản lý pet và hóa đơn. Admin có đầy đủ chức năng của Staff, đồng thời được quản lý danh mục dịch vụ, tài khoản nhân viên và xem báo cáo theo năm. Phần phân quyền này được kiểm tra ở `AuthFilter`, không chỉ ẩn nút ở giao diện.”

## Slide 6 — Cấu trúc source code

### Nội dung ngắn gọn trên Canva

**MVC + DAO**

- `model/`: User, Pet, Service, Appointment, Invoice
- `views/`: JSP cho public, auth, customer, dashboard
- `controller/`: Servlet nhận GET/POST và điều phối
- `dao/`: JDBC, SQL, ánh xạ dữ liệu
- `filter/`: xác thực và phân quyền
- `util/`: BCrypt, CSRF, validation, upload ảnh

`Request → Servlet → DAO → MySQL → JSP → Response`

### Hình ảnh nên chèn

- Ảnh cây thư mục trong IDE, crop đúng các package.
- Sơ đồ luồng MVC một hàng ở cuối slide.

### Lời thuyết trình (45–60 giây)

“Source được tổ chức theo mô hình MVC kết hợp DAO. Model gồm năm JavaBean ánh xạ các thực thể chính. View là các file JSP được đặt dưới `WEB-INF/views`, nhờ đó người dùng không mở JSP nội bộ trực tiếp mà phải thông qua Servlet. Controller gồm các Servlet nhận GET hoặc POST, kiểm tra dữ liệu, gọi DAO rồi forward sang JSP hoặc redirect. DAO tách toàn bộ truy vấn JDBC khỏi giao diện. Ngoài bốn phần chính, dự án có `AuthFilter` để phân quyền và nhóm utility xử lý băm mật khẩu, CSRF, validation và upload ảnh. Mô hình này giúp source dễ đọc và tách tương đối rõ trách nhiệm.”

## Slide 7 — Cơ sở dữ liệu

### Nội dung ngắn gọn trên Canva

**6 bảng chính**

- `users`: tài khoản & vai trò
- `pets`: hồ sơ thú cưng
- `services`: dịch vụ & giá
- `appointments`: lịch khám & chẩn đoán
- `appointment_details`: dịch vụ/giá lúc đặt
- `invoices`: hóa đơn & thanh toán

Quan hệ trọng tâm:  
`Customer → Pet → Appointment → Detail → Service`  
`Appointment → Invoice`

### Hình ảnh nên chèn

- Vẽ ERD 6 bảng, chỉ giữ PK/FK quan trọng.
- Làm nổi bật `price_at_booking` và `appointment_id UNIQUE`.

### Lời thuyết trình (45–60 giây)

“Cơ sở dữ liệu gồm sáu bảng. `users` dùng chung cho ba vai trò. Mỗi khách hàng có nhiều pet và nhiều lịch hẹn; mỗi lịch thuộc một pet và có thể được gán cho một staff. Quan hệ giữa lịch và dịch vụ được tách qua `appointment_details`, cho phép mở rộng nhiều dịch vụ và đặc biệt lưu `price_at_booking`. Vì vậy nếu admin đổi giá dịch vụ, hóa đơn của lịch cũ vẫn dùng đúng giá tại thời điểm đặt. Mỗi lịch có tối đa một hóa đơn nhờ khóa unique. `appointment_id` trong hóa đơn có thể null để hệ thống vẫn hỗ trợ tạo hóa đơn thủ công.”

## Slide 8 — Luồng hoạt động chính

### Nội dung ngắn gọn trên Canva

**Đặt lịch → Khám → Thanh toán**

1. Customer đăng nhập, chọn pet/dịch vụ/thời gian
2. Kiểm tra CSRF, quyền sở hữu pet, giờ hợp lệ, trùng lịch
3. Transaction tạo lịch `PENDING` + chi tiết dịch vụ
4. Staff xác nhận `CONFIRMED`, phân công và chẩn đoán
5. Hoàn tất `COMPLETED` → tự tạo hóa đơn `UNPAID`
6. Cập nhật thanh toán `PAID` → ghi nhận doanh thu

### Hình ảnh nên chèn

- Timeline ngang 6 bước.
- Dùng màu trạng thái: vàng PENDING, xanh CONFIRMED, tím COMPLETED, đỏ CANCELLED.

### Lời thuyết trình (50–60 giây)

“Đây là luồng quan trọng nhất của hệ thống. Sau khi đăng nhập, khách hàng chọn pet có sẵn hoặc tạo nhanh pet mới, chọn dịch vụ và thời gian. Servlet kiểm tra CSRF, pet có thuộc khách hàng không, thời gian có nằm trong 8 giờ đến 17 giờ và khung giờ có bị trùng không. DAO dùng transaction để tạo đồng thời lịch `PENDING` và chi tiết dịch vụ; nếu một bước lỗi thì rollback. Nhân viên xác nhận lịch, phân công người khám và nhập chẩn đoán. Khi chuyển sang `COMPLETED`, hệ thống tự tạo hóa đơn `UNPAID` từ giá lúc đặt. Chỉ hóa đơn chuyển sang `PAID` mới được tính vào báo cáo doanh thu.”

## Slide 9 — Giao diện website

### Nội dung ngắn gọn trên Canva

**Các màn hình tiêu biểu**

- Trang chủ: giới thiệu thương hiệu & dịch vụ
- Form đặt lịch: pet, dịch vụ, ngày giờ
- Trang “Lịch của tôi”: theo dõi trạng thái
- Dashboard: chỉ số vận hành trong ngày
- Quản lý lịch: duyệt, phân công, chẩn đoán
- Hóa đơn/Báo cáo: thanh toán và thống kê

### Hình ảnh nên chèn

- Ảnh lớn: trang đặt lịch hoặc dashboard.
- Ba ảnh nhỏ: trang chủ, quản lý lịch, báo cáo.
- Chụp ở cùng kích thước trình duyệt, không lộ tab hoặc dữ liệu nhạy cảm.

### Lời thuyết trình (35–50 giây)

“Về giao diện, em đề xuất trình bày bốn màn hình tiêu biểu. Trang chủ thể hiện nhận diện PetCare và dẫn người dùng tới đặt lịch. Form đặt lịch cho thấy rõ dữ liệu động lấy từ pet và dịch vụ. Dashboard dành cho nhân viên tóm tắt lịch hôm nay, lịch chờ, số pet và doanh thu tháng. Cuối cùng, màn hình quản lý lịch và báo cáo thể hiện phần nghiệp vụ phía sau. Khi nói về giao diện, em sẽ không chỉ mô tả màu sắc mà nhấn mạnh mỗi màn hình tương ứng với một vai trò và một bước trong quy trình.”

## Slide 10 — Demo chức năng

### Nội dung ngắn gọn trên Canva

**Kịch bản demo 5 phút**

1. Customer: đăng nhập → thêm pet → đặt lịch
2. Customer: kiểm tra lịch ở trạng thái `PENDING`
3. Admin/Staff: xác nhận lịch → phân công → chẩn đoán
4. Hoàn tất lịch → kiểm tra hóa đơn tự sinh
5. Đánh dấu `PAID` → xem báo cáo
6. Thử truy cập sai quyền để chứng minh phân quyền

### Hình ảnh nên chèn

- Một flow 2 swimlane: Customer và Staff/Admin.
- QR/link video demo nếu bài nộp cho phép.

### Lời thuyết trình (40–55 giây)

“Phần demo được sắp xếp theo một câu chuyện dữ liệu xuyên suốt thay vì mở từng menu rời rạc. Em tạo một pet và một lịch mới bằng tài khoản customer, sau đó cho thấy lịch đang `PENDING`. Em chuyển sang tài khoản staff hoặc admin để xác nhận, phân công người khám, nhập chẩn đoán và hoàn tất. Ngay lúc đó, em mở hóa đơn để chứng minh hệ thống tự sinh dữ liệu từ lịch. Sau khi đánh dấu đã thanh toán, em mở báo cáo để thấy doanh thu. Cuối cùng em thử truy cập một URL admin bằng tài khoản không đủ quyền để minh họa `AuthFilter`.”

## Slide 11 — Kết quả đạt được

### Nội dung ngắn gọn trên Canva

**Kết quả**

- Hoàn thành quy trình từ đặt lịch đến hóa đơn/báo cáo
- Hoàn thành CRUD và phân quyền 3 vai trò
- Áp dụng MVC + DAO, JDBC transaction và quan hệ CSDL
- Có BCrypt, CSRF, validation, upload ảnh
- Maven build WAR thành công
- JUnit: **6 tests – 0 failure – 0 error**

### Hình ảnh nên chèn

- Ảnh terminal có dòng `BUILD SUCCESS` và `Tests run: 6, Failures: 0`.
- Một checklist nhỏ cho các module đã hoàn thành.

### Lời thuyết trình (40–55 giây)

“Kết quả đạt được là một website có quy trình nghiệp vụ tương đối đầy đủ từ đặt lịch đến khám, hóa đơn và báo cáo, thay vì chỉ dừng ở CRUD đơn lẻ. Em đã áp dụng MVC kết hợp DAO, session và filter phân quyền, JDBC transaction, khóa ngoại và các trạng thái nghiệp vụ. Về an toàn, dự án có BCrypt, CSRF, PreparedStatement, validation và kiểm tra quyền sở hữu dữ liệu. Em cũng đã kiểm tra build trực tiếp: Maven biên dịch 34 file Java, đóng gói `PetCareClinic.war` thành công; 6 test JUnit hiện có đều chạy đạt, không có failure hoặc error.”

## Slide 12 — Hạn chế và hướng phát triển

### Nội dung ngắn gọn trên Canva

**Hạn chế hiện tại**

- Chưa có Service layer, connection pool, pagination
- Test chưa bao phủ DAO/Servlet/end-to-end
- Trùng lịch đang kiểm tra chung toàn phòng khám
- Upload ảnh và cấu hình deploy còn ở mức đồ án

**Hướng phát triển**

- Lịch theo bác sĩ/phòng/ca làm việc
- Email/SMS, quên mật khẩu, thanh toán online
- Xuất PDF/Excel, biểu đồ, audit log
- Integration test và lưu ảnh trên cloud

### Hình ảnh nên chèn

- Roadmap ba chặng: Hoàn thiện kiến trúc → Tích hợp dịch vụ → Mở rộng vận hành.
- Không dùng ảnh trang trí lớn; ưu tiên icon nhỏ.

### Lời thuyết trình (45–60 giây)

“Dự án vẫn còn một số hạn chế. Source chưa có Service layer và connection pool; test mới tập trung ở utility, chưa bao phủ DAO và luồng trình duyệt. Kiểm tra trùng lịch hiện khóa một thời điểm cho toàn phòng khám, nên chưa hỗ trợ nhiều bác sĩ khám song song. Upload ảnh và cấu hình secret cũng mới phù hợp môi trường đồ án. Hướng phát triển là quản lý ca làm việc theo bác sĩ và phòng, thêm nhắc lịch qua email hoặc SMS, quên mật khẩu, thanh toán online, xuất báo cáo và audit log. Về kỹ thuật, em sẽ bổ sung integration test, phân trang và lưu ảnh ngoài webapp. Em xin cảm ơn thầy/cô đã lắng nghe và mong nhận được góp ý.”

---

## III. Kịch bản thuyết trình hoàn chỉnh từ đầu đến cuối

“Em xin chào thầy/cô và các bạn. Em là `[Tên]`, hôm nay em xin trình bày bài tập lớn môn Lập trình Website với đề tài **PetCare Clinic – hệ thống quản lý phòng khám thú y và đặt lịch trực tuyến**. Sản phẩm được xây dựng bằng Java Servlet, JSP, JDBC và MySQL theo mô hình MVC kết hợp DAO.

Lý do em chọn đề tài là nhu cầu chăm sóc thú cưng ngày càng tăng, nhưng việc nhận lịch qua điện thoại hoặc sổ tay dễ dẫn đến trùng giờ, thất lạc hồ sơ và khó quản lý hóa đơn. PetCare Clinic tập trung tài khoản, hồ sơ thú cưng, dịch vụ, lịch khám và thanh toán trong một hệ thống. Đề tài vừa có giá trị thực tế, vừa phù hợp để áp dụng các kiến thức trọng tâm của môn học như CRUD, session, phân quyền và cơ sở dữ liệu quan hệ.

Mục tiêu của hệ thống là số hóa quy trình từ khi khách đặt lịch đến lúc phòng khám hoàn thành dịch vụ và ghi nhận doanh thu. Khách hàng tự quản lý pet và lịch của mình. Nhân viên tiếp nhận lịch, phân công người khám, ghi chẩn đoán và xử lý hóa đơn. Admin quản lý thêm dịch vụ, nhân sự và báo cáo.

Về công nghệ, backend sử dụng Java 17 và Servlet API. JSP và JSTL render dữ liệu động. JDBC kết nối tới MySQL 8 thông qua Connector/J 8.4. Phần giao diện dùng HTML, CSS và JavaScript thuần; dự án dùng Bootstrap Icons nhưng không dùng Bootstrap CSS. Maven quản lý dependency, chạy JUnit và đóng gói WAR để triển khai trên Tomcat. Các cơ chế bảo vệ chính gồm session, `AuthFilter`, CSRF token và BCrypt.

Hệ thống có ba vai trò. Customer đăng ký, cập nhật hồ sơ, quản lý pet, đặt hoặc hủy lịch và xem hóa đơn của chính mình. Staff thao tác với dashboard, xác nhận lịch, phân công bác sĩ, ghi chẩn đoán, hoàn tất lịch và quản lý hóa đơn. Admin có thêm quyền CRUD dịch vụ, quản lý tài khoản nhân viên và xem báo cáo. Quyền được kiểm tra ở filter theo đường dẫn, nên không thể vượt quyền chỉ bằng cách nhập URL.

Source được chia theo MVC kết hợp DAO. Model gồm `User`, `Pet`, `Service`, `Appointment` và `Invoice`. View là JSP đặt dưới `WEB-INF/views`. Controller là các Servlet tiếp nhận GET/POST và điều phối request. DAO chứa truy vấn JDBC và ánh xạ kết quả. Ngoài ra còn có filter và utility cho bảo mật, validation và upload ảnh. Luồng chung là trình duyệt gửi request, Servlet gọi DAO, DAO làm việc với MySQL, sau đó Servlet truyền dữ liệu cho JSP để render response.

Cơ sở dữ liệu có sáu bảng: `users`, `pets`, `services`, `appointments`, `appointment_details` và `invoices`. Điểm em muốn nhấn mạnh là bảng chi tiết lịch lưu `price_at_booking`, nhờ vậy giá của lịch cũ không bị thay đổi nếu admin cập nhật bảng giá. Việc tạo lịch và chi tiết lịch được bọc trong transaction. Mỗi lịch chỉ có tối đa một hóa đơn nhờ unique constraint, đồng thời hóa đơn vẫn có thể được tạo thủ công khi `appointment_id` là null.

Luồng chính bắt đầu khi customer chọn pet, dịch vụ, ngày và giờ. `BookingServlet` kiểm tra CSRF, quyền sở hữu pet, thời gian không ở quá khứ, nằm trong khung 8 giờ đến 17 giờ và không trùng lịch. `AppointmentDAO` tạo lịch `PENDING` cùng chi tiết dịch vụ trong một transaction. Staff xác nhận thành `CONFIRMED`, phân công người khám và ghi chẩn đoán. Khi chuyển lịch thành `COMPLETED`, hệ thống tự sinh hóa đơn `UNPAID`. Sau khi hóa đơn được cập nhật `PAID`, số tiền mới được đưa vào báo cáo doanh thu.

Giao diện gồm trang công khai, khu vực customer và dashboard nội bộ. Trong phần demo em sẽ tạo một lịch thật từ tài khoản customer, xử lý cùng lịch đó ở phía staff/admin, kiểm tra hóa đơn tự sinh và cuối cùng xem doanh thu. Cách demo này giúp chứng minh dữ liệu đi xuyên suốt qua các module chứ không phải các màn hình rời rạc.

Kết quả, dự án đã hoàn thành quy trình đặt lịch, quản lý khám, hóa đơn và báo cáo; có CRUD, phân quyền ba vai trò và các kiểm tra bảo mật cơ bản. Em đã build trực tiếp bằng Maven: 34 file Java được biên dịch, file WAR được tạo thành công và 6 test JUnit hiện tại đều đạt.

Hạn chế là chưa có Service layer, connection pool và phân trang; test chưa bao phủ DAO/Servlet; logic chống trùng lịch hiện chưa tách theo bác sĩ; upload ảnh và quản lý secret mới phù hợp môi trường học tập. Trong tương lai em muốn thêm lịch làm việc theo bác sĩ, email/SMS nhắc lịch, thanh toán trực tuyến, xuất báo cáo và integration test.

Phần trình bày của em đến đây là hết. Em xin cảm ơn thầy/cô và các bạn đã lắng nghe. Em sẵn sàng trả lời câu hỏi.”

---

## IV. Thứ tự demo website khi quay video

### Chuẩn bị trước khi quay

- Chạy `mvn clean package` trước để chắc chắn source build được.
- Chạy MySQL và ứng dụng; mở sẵn hai cửa sổ trình duyệt hoặc một cửa sổ thường + một cửa sổ ẩn danh.
- Chuẩn bị một tài khoản CUSTOMER và tài khoản demo `admin / 123456`.
- Chọn ngày tương lai và khung giờ chưa có lịch.
- Zoom trình duyệt 90–100%, tắt thông báo, bookmark và dữ liệu cá nhân.
- Nếu báo cáo chưa có dữ liệu trong năm hiện tại, chuẩn bị sẵn một số hóa đơn `PAID` để màn hình có ý nghĩa.

### Kịch bản demo 5–7 phút

1. **Trang chủ (20 giây):** giới thiệu nhanh CTA đặt lịch, khu vực dịch vụ và trạng thái đăng nhập.
2. **Đăng nhập CUSTOMER (20 giây):** nói rõ session lưu đối tượng `User` và filter phân quyền.
3. **Hồ sơ thú cưng (40 giây):** thêm một pet mới, nhập tên/loài/giống/tuổi/cân nặng, có thể tải ảnh; quay lại danh sách để chứng minh đã lưu.
4. **Đặt lịch (60 giây):** chọn pet vừa tạo, chọn dịch vụ, ngày giờ tương lai, nhập lý do; gửi form và cho thấy trang thành công.
5. **Lịch của tôi (30 giây):** chỉ vào dịch vụ, thời gian, giá lúc đặt và trạng thái `PENDING`.
6. **Đăng nhập ADMIN/STAFF (20 giây):** mở dashboard và nói nhanh các chỉ số.
7. **Quản lý lịch (90 giây):** tìm lịch vừa đặt; chuyển `PENDING → CONFIRMED`; chọn staff, nhập chẩn đoán; chuyển `CONFIRMED → COMPLETED`.
8. **Hóa đơn (45 giây):** mở danh sách hóa đơn, chỉ ra hóa đơn vừa tự sinh ở trạng thái `UNPAID`; cập nhật phương thức và `PAID`.
9. **Báo cáo (30 giây):** mở báo cáo năm hiện tại, chỉ doanh thu đã thanh toán, lịch hoàn thành và top dịch vụ.
10. **Chứng minh phân quyền (30 giây):** dùng CUSTOMER thử mở `/admin/reports` hoặc `/admin/services`; hệ thống chuyển về trang phù hợp.
11. **Kết thúc (15 giây):** nhắc lại luồng dữ liệu xuyên suốt và kết quả build/test.

### Phương án dự phòng nếu demo lỗi

- Có sẵn ảnh chụp từng bước quan trọng.
- Không sửa database trực tiếp trong lúc quay.
- Nếu khung giờ báo trùng, đổi sang giờ/ngày khác và giải thích đây là validation chống trùng lịch.
- Nếu mạng lỗi làm Bootstrap Icons không tải, chức năng vẫn chạy; tiếp tục demo vì icon là tài nguyên CDN, không phải backend.

---

## V. Những điểm nên nhấn mạnh để được điểm tốt

1. **Đây không chỉ là CRUD:** có một quy trình nghiệp vụ hoàn chỉnh từ đặt lịch đến doanh thu.
2. **Transaction khi tạo lịch:** hai thao tác ghi `appointments` và `appointment_details` cùng thành công hoặc cùng rollback.
3. **Giữ lịch sử giá:** dùng `price_at_booking`, không lấy giá hiện tại khi sinh hóa đơn.
4. **State machine cho lịch:** chỉ cho phép các bước chuyển trạng thái hợp lệ, không thể từ `COMPLETED` quay lại `PENDING`.
5. **Phân quyền ở backend:** `AuthFilter` chặn URL theo session và role, không chỉ ẩn menu.
6. **Bảo vệ dữ liệu theo chủ sở hữu:** customer chỉ sửa pet, hủy lịch và xem hóa đơn của chính mình.
7. **Bảo mật có căn cứ:** PreparedStatement, BCrypt cost 12, CSRF, escape output, giới hạn upload.
8. **Thiết kế CSDL có chủ đích:** khóa ngoại, khóa kép, unique invoice và soft delete service.
9. **Biết tự đánh giá hạn chế:** nói đúng những gì source chưa có; không nhận là “bảo mật tuyệt đối” hay “sẵn sàng production”.
10. **Có bằng chứng chất lượng:** build WAR thành công và 6/6 test đạt.

---

## VI. Câu trả lời gợi ý khi giảng viên hỏi về source code

### 1. “Dự án có đúng mô hình MVC không?”

“Dạ, dự án tổ chức theo MVC kết hợp DAO. Model là các JavaBean, View là JSP dưới `WEB-INF`, Controller là Servlet và DAO tách riêng truy vấn JDBC. Tuy nhiên đây là MVC ở quy mô đồ án, chưa có Service layer nên một phần nghiệp vụ vẫn nằm trong Servlet hoặc DAO. Nếu mở rộng em sẽ thêm Service để giảm phụ thuộc giữa Controller và DAO.”

### 2. “Vì sao cần DAO?”

“DAO gom toàn bộ thao tác SQL và ánh xạ `ResultSet` vào một tầng. Servlet không cần biết chi tiết câu truy vấn, nên code dễ bảo trì, thay đổi và kiểm thử hơn.”

### 3. “Luồng request hoạt động thế nào?”

“Request đi qua `AuthFilter` trước. Servlet nhận request, lấy parameter và session, kiểm tra CSRF/validation, gọi DAO. DAO dùng JDBC làm việc với MySQL và trả Model hoặc danh sách. Servlet đặt dữ liệu vào request rồi forward sang JSP; với thao tác POST thành công thường redirect để tránh gửi lại form.”

### 4. “Vì sao JSP nằm trong WEB-INF?”

“Tài nguyên dưới `WEB-INF` không được truy cập trực tiếp từ URL. Người dùng phải đi qua Servlet, nhờ đó Controller có cơ hội kiểm tra quyền, chuẩn bị dữ liệu và điều hướng đúng.”

### 5. “Mật khẩu được lưu thế nào?”

“Tài khoản mới dùng BCrypt với cost 12, không lưu plaintext. Hàm verify vẫn đọc được SHA-256 cũ để tương thích tài khoản seed; về lâu dài em sẽ nâng cấp hash cũ sang BCrypt sau lần đăng nhập thành công.”

### 6. “Hệ thống chống SQL Injection thế nào?”

“Các dữ liệu đầu vào được truyền qua `PreparedStatement` với placeholder `?`, không nối trực tiếp input vào SQL. Các lựa chọn sắp xếp cũng được giới hạn bằng nhánh điều kiện cố định.”

### 7. “CSRF là gì và source dùng ở đâu?”

“CSRF là trường hợp trình duyệt đang đăng nhập bị một trang khác ép gửi request thay đổi dữ liệu. `CsrfUtil` tạo token ngẫu nhiên 32 byte lưu trong session, form gửi lại token và Servlet so sánh trước khi insert, update, delete hoặc đổi trạng thái.”

### 8. “Customer có thể sửa pet của người khác bằng cách đổi ID không?”

“Không. Khi đặt lịch source kiểm tra `pet_id` cùng `customer_id`; khi cập nhật pet, câu SQL cũng có điều kiện `WHERE id = ? AND customer_id = ?`. Vì vậy đổi ID trên form không đủ để vượt quyền.”

### 9. “Tại sao cần transaction khi đặt lịch?”

“Một lịch gồm bản ghi chính và chi tiết dịch vụ. Nếu tạo lịch thành công nhưng thêm chi tiết thất bại sẽ sinh dữ liệu mồ côi. Vì vậy DAO tắt auto-commit, chỉ commit sau khi cả hai insert thành công và rollback nếu có lỗi.”

### 10. “Tại sao lưu `price_at_booking`?”

“Để bảo toàn lịch sử giao dịch. Giá dịch vụ có thể đổi sau ngày khách đặt, nhưng hóa đơn phải dùng giá đã xác nhận tại thời điểm đặt.”

### 11. “Trạng thái lịch được kiểm soát ra sao?”

“Có bốn trạng thái `PENDING`, `CONFIRMED`, `COMPLETED`, `CANCELLED`. DAO chỉ cho phép từ PENDING sang CONFIRMED hoặc CANCELLED, từ CONFIRMED sang COMPLETED hoặc CANCELLED. Trạng thái cuối không chuyển tiếp nữa.”

### 12. “Khi nào hóa đơn được tạo?”

“Khi Staff/Admin chuyển lịch sang `COMPLETED`, Controller gọi `InvoiceDAO.createInvoiceFromAppointment`. DAO tổng hợp dịch vụ và `price_at_booking`, tạo hóa đơn `UNPAID`. Unique constraint và hàm kiểm tra tồn tại giúp tránh tạo trùng.”

### 13. “Doanh thu được tính theo dữ liệu nào?”

“Báo cáo chỉ cộng `total_amount` của hóa đơn có status `PAID`. Source đang nhóm theo năm và tháng của `created_at`. Một hướng cải tiến là thống nhất dùng `payment_date` để phản ánh đúng thời điểm thu tiền.”

### 14. “Tại sao xóa dịch vụ lại đặt status bằng 0?”

“Đó là soft delete. Dịch vụ ngừng hiển thị cho lịch mới nhưng dữ liệu lịch cũ vẫn giữ được quan hệ và lịch sử.”

### 15. “Điểm yếu lớn nhất hiện tại là gì?”

“Về nghiệp vụ, logic chống trùng đang áp dụng cho toàn phòng khám theo một timestamp, chưa theo bác sĩ hoặc phòng. Về kỹ thuật, chưa có Service layer, connection pool và integration test. Đây là ba phần em ưu tiên cải tiến.”

### 16. “Website có dùng Bootstrap không?”

“Dự án chỉ tải **Bootstrap Icons 1.11.3**. Layout và component được viết bằng CSS thuần, không dùng Bootstrap CSS hoặc JavaScript.”

### 17. “Kiểm thử hiện có những gì?”

“Hiện có 6 test JUnit: 3 test cho `HashUtil` và 3 test cho `ValidationUtil`. Maven chạy tất cả đều đạt. Em không nói test đã đầy đủ; bước tiếp theo là test DAO bằng database riêng và test luồng Servlet/end-to-end.”

### 18. “Nếu triển khai thật cần sửa gì?”

“Em sẽ bỏ credential mặc định, dùng secret bắt buộc; thêm connection pool; lưu ảnh ở object storage; kiểm tra MIME; thêm HTTPS, rate limit, reset mật khẩu, audit log; cập nhật dependency/server và tăng test coverage.”

---

## VII. Gợi ý thiết kế slide Canva

### Phong cách đề xuất

- Tỷ lệ **16:9**, nền kem nhạt `#FAF6F0` hoặc trắng.
- Màu chính lấy từ giao diện: xanh đậm `#2A5A53`, cam `#EE7C52`, vàng nhạt làm điểm nhấn.
- Font tiêu đề: **Be Vietnam Pro Bold** hoặc **Montserrat Bold**.
- Font nội dung: **Be Vietnam Pro/Inter**, tối thiểu 22–24 pt.
- Tiêu đề 34–44 pt; không dùng quá hai font.

### Quy tắc ít chữ, dễ hiểu

- Mỗi slide chỉ giữ **một thông điệp chính**.
- Tối đa 5–6 bullet; mỗi bullet khoảng 5–10 từ.
- Nội dung chi tiết để trong lời nói, không chép cả đoạn lên slide.
- Dùng cùng một kiểu icon, bo góc và khoảng cách trên toàn bộ deck.
- Ảnh screenshot nên crop sát nội dung; thêm viền mảnh và chú thích 1 dòng.
- Slide kiến trúc dùng sơ đồ, slide CSDL dùng ERD, slide luồng dùng timeline; không thay bằng đoạn văn.

### Bố cục từng nhóm slide

- Slide 1: ảnh hero chiếm 55–60%, thông tin nằm bên trái.
- Slide 2–3: bố cục 40/60 giữa hình và bullet.
- Slide 4: ma trận công nghệ 2 hàng hoặc 5 logo có nhãn.
- Slide 5: ba cột vai trò.
- Slide 6: cây thư mục bên trái, sơ đồ MVC bên phải.
- Slide 7: ERD gần toàn màn hình, chú thích nhỏ ở dưới.
- Slide 8: timeline ngang.
- Slide 9: một screenshot lớn + ba thumbnail.
- Slide 10: hai swimlane Customer và Staff/Admin.
- Slide 11: con số lớn “6/6 tests” và “BUILD SUCCESS”.
- Slide 12: hai cột “Hạn chế” và “Hướng phát triển”.

### Hiệu ứng

- Chỉ dùng Fade/Rise nhẹ, 0.3–0.5 giây.
- Timeline có thể xuất hiện lần lượt theo bước.
- Không dùng hiệu ứng xoay, nảy hoặc âm thanh vì làm giảm tính học thuật.

---

## VIII. Checklist trước khi nộp

- [ ] Thay tên sinh viên/nhóm và giảng viên.
- [ ] Chụp ảnh thật từ website đang chạy, không dùng ảnh minh họa giả.
- [ ] Cập nhật hoặc bỏ `REPORT.md` cũ khỏi tài liệu nộp để tránh mâu thuẫn.
- [ ] Không nói dự án dùng Bootstrap CSS hoặc Chart.js vì source hiện tại không có.
- [ ] Nhớ nói database có 6 bảng, không phải 2 bảng.
- [ ] Demo một lịch xuyên suốt bằng cùng dữ liệu.
- [ ] Che mật khẩu và thông tin cá nhân khi quay.
- [ ] Có video/ảnh dự phòng nếu demo trực tiếp gặp lỗi.
- [ ] Chạy lại `mvn clean package` và chụp `BUILD SUCCESS`.
- [ ] Tập nói trong khoảng 8–10 phút, demo 5–7 phút tùy yêu cầu môn học.
