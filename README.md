# PetCare Clinic

Website quản lý và đặt lịch khám thú cưng PetCare

---

## Yêu cầu hệ thống

- JDK 17
- Apache Tomcat 9
- MySQL 8
- Maven 3.8+
- VS Code

---

## Hướng dẫn cài đặt và chạy

### Bước 1: Cài JDK 17

Tải JDK 17 từ Oracle hoặc dùng OpenJDK. Thiết lập biến môi trường JAVA_HOME và thêm vào PATH.

```bash
java -version
javac -version
```

### Bước 2: Cài Maven

Tải Maven, giải nén, thiết lập MAVEN_HOME và thêm vào PATH.

```bash
mvn -version
```

### Bước 3: Cài MySQL 8

Tải và cài MySQL Server 8. Ghi nhớ mật khẩu root.

### Bước 4: Import database

```bash
mysql -u root -p < database/petcare_db.sql
```

### Bước 5: Cấu hình kết nối Database

Mở file `src/main/java/com/petcare/config/DBConnection.java`

Đổi dòng:
```java
private static final String PASSWORD = "";
```
thành mật khẩu MySQL của bạn.

### Bước 6: Cài Tomcat 9

Tải Tomcat 9 (bản zip), giải nén ra thư mục.

### Bước 7: Build project

```bash
mvn clean package
```

### Bước 8: Deploy lên Tomcat

Copy file `target/PetCareClinic.war` vào thư mục `webapps` của Tomcat, rồi chạy `startup.bat`.

Hoặc dùng VS Code extension "Community Server Connectors" để deploy.

---

## URL test

- http://localhost:8080/PetCareClinic
- http://localhost:8080/PetCareClinic/home
- http://localhost:8080/PetCareClinic/test-db

---

## Công nghệ sử dụng

- Java 17
- javax.servlet 4.0.1
- JSP + JSTL 1.2
- JDBC
- MySQL 8
- Apache Tomcat 9
- Maven
- MVC Pattern
