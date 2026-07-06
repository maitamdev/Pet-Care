package com.petcare.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ValidationUtilTest {

    @Test
    void isEmptyHandlesNullBlankAndText() {
        assertTrue(ValidationUtil.isEmpty(null));
        assertTrue(ValidationUtil.isEmpty(""));
        assertTrue(ValidationUtil.isEmpty("   "));
        assertFalse(ValidationUtil.isEmpty("PetCare"));
    }

    @Test
    void isValidPhoneAcceptsVietnameseTenDigitMobileFormat() {
        assertTrue(ValidationUtil.isValidPhone("0912345678"));
        assertFalse(ValidationUtil.isValidPhone("912345678"));
        assertFalse(ValidationUtil.isValidPhone("09123456789"));
        assertFalse(ValidationUtil.isValidPhone("09abc45678"));
    }

    @Test
    void isValidEmailAcceptsCommonEmailFormats() {
        assertTrue(ValidationUtil.isValidEmail("customer@example.com"));
        assertTrue(ValidationUtil.isValidEmail("pet.care-01@example.com"));
        assertFalse(ValidationUtil.isValidEmail("customer.example.com"));
        assertFalse(ValidationUtil.isValidEmail("customer@"));
    }

    @Test
    void isValidPasswordRequiresMinimumLength() {
        assertFalse(ValidationUtil.isValidPassword("1234567"));
        assertTrue(ValidationUtil.isValidPassword("12345678"));
    }

    @Test
    void parseIntOrDefaultHandlesInvalidValues() {
        assertEquals(5, ValidationUtil.parseIntOrDefault("5", 1));
        assertEquals(1, ValidationUtil.parseIntOrDefault("abc", 1));
        assertEquals(1, ValidationUtil.parseIntOrDefault(null, 1));
    }

    @Test
    void generateTemporaryPasswordCreatesStrongEnoughValue() {
        String password = ValidationUtil.generateTemporaryPassword();
        assertEquals(12, password.length());
        assertTrue(ValidationUtil.isValidPassword(password));
    }
}