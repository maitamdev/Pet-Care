# PetCare Clinic feature TODO

## Public
- [x] Home page and service presentation
- [x] Register and login
- [x] Customer booking with pet/service/date/time
- [x] Booking validation, CSRF, and duplicate-slot guard

## Customer
- [x] View my appointments
- [x] Cancel pending or confirmed appointments
- [x] View my pets
- [x] Add and edit my pets
- [x] Profile update

## Staff
- [x] Dashboard overview
- [x] Appointment approval workflow
- [x] Assign doctor/staff to appointment
- [x] Add diagnosis and clinical notes
- [x] Generate invoice from completed appointment

## Admin
- [x] Manage services
- [x] Manage pets
- [x] Manage staff accounts
- [x] Manage invoices and payment status
- [x] Revenue and operation reports

## Security and quality
- [x] BCrypt password hashing with legacy SHA-256 compatibility
- [x] CSRF token for mutating forms
- [x] Escape dynamic JSP output
- [x] Hide database test endpoint from non-admin users
- [ ] Add automated tests

## External integrations
- [ ] Email/SMS reminders
- [ ] Pet/user image upload
- [ ] Online payment gateway
