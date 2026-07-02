# PetCare Clinic

PetCare Clinic is a Java Web MVC project for managing a veterinary clinic and online pet appointment booking.

## Tech Stack

- Java 17
- Servlet/JSP/JSTL
- JDBC
- MySQL 8
- Maven
- Tomcat Maven Plugin

## Main Features

- Public home page and appointment booking
- Register, login, logout
- Roles: `ADMIN`, `STAFF`, `CUSTOMER`
- Customer profile, password change, pet records, appointments, invoices
- Admin/staff appointment approval, clinical notes, invoice creation
- Service, pet, staff, invoice, and report management
- Image upload for users and pets
- CSRF protection for mutating forms
- BCrypt password hashing with legacy SHA-256 compatibility
- Basic automated tests with JUnit 5

## Requirements

- JDK 17
- Maven 3.8+
- MySQL Server 8+

## First-Time Setup

Open PowerShell in the project root:

```powershell
cd D:\Pet-Care
.\setup.ps1
```

Enter your MySQL `root` password when prompted.

The script will:

- create/update database `petcare_db`
- import seed data
- create/update MySQL user `petcare_app`
- write local credentials to `.env.ps1`

`.env.ps1` is intentionally ignored by Git.

## Run The App

Recommended:

```powershell
.\run.ps1
```

Manual alternative:

```powershell
. .\.env.ps1
mvn tomcat7:run
```

Then open:

```text
http://localhost:8080/PetCareClinic
```

## Demo Account

```text
Username: admin
Password: 123456
Role: ADMIN
```

You can register customer accounts from the web UI.

## Database Migration

If the database already exists and only schema updates are needed:

```powershell
.\migrate.ps1
```

This applies the invoice migration without recreating the app user.

## Build And Test

```powershell
mvn clean package
```

Expected result:

```text
BUILD SUCCESS
Tests run: 6, Failures: 0
```

## Project Structure

```text
Pet-Care/
├── database/
│   ├── petcare_db.sql
│   └── invoices.sql
├── src/main/java/com/petcare/
│   ├── config/
│   ├── controller/
│   ├── dao/
│   ├── filter/
│   ├── model/
│   └── util/
├── src/main/webapp/
│   ├── assets/
│   ├── WEB-INF/views/
│   └── index.jsp
├── src/test/java/
├── setup.ps1
├── migrate.ps1
├── run.ps1
└── pom.xml
```

## Notes For Other Machines

After pulling the code on another computer:

1. Install JDK 17, Maven, and MySQL.
2. Run `.\setup.ps1`.
3. Run `.\run.ps1`.
4. Login with `admin / 123456`.

Do not commit `.env.ps1`, uploaded images, `target/`, or local IDE files.
