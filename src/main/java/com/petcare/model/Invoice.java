package com.petcare.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Invoice {
    private int id;
    private int appointmentId;
    private BigDecimal totalAmount;
    private String paymentMethod;
    private String status;
    private Timestamp paymentDate;
    private Timestamp createdAt;

    private String customerName;
    private String petName;
    private String serviceName;
    private Timestamp appointmentDate;
    private String manualCustomerName;
    private String manualPetName;
    private String manualServiceName;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getPetName() { return petName; }
    public void setPetName(String petName) { this.petName = petName; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public Timestamp getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Timestamp appointmentDate) { this.appointmentDate = appointmentDate; }
    public String getManualCustomerName() { return manualCustomerName; }
    public void setManualCustomerName(String manualCustomerName) { this.manualCustomerName = manualCustomerName; }
    public String getManualPetName() { return manualPetName; }
    public void setManualPetName(String manualPetName) { this.manualPetName = manualPetName; }
    public String getManualServiceName() { return manualServiceName; }
    public void setManualServiceName(String manualServiceName) { this.manualServiceName = manualServiceName; }
}
