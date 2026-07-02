package com.petcare.util;

import org.junit.jupiter.api.Test;

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
}
