package com.petcare.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class HashUtilTest {

    @Test
    void hashPasswordUsesBcryptAndVerifiesPassword() {
        String hash = HashUtil.hashPassword("123456");

        assertTrue(hash.startsWith("$2"));
        assertTrue(HashUtil.verifyPassword("123456", hash));
        assertFalse(HashUtil.verifyPassword("wrong-password", hash));
    }

    @Test
    void verifyPasswordSupportsLegacySha256Hashes() {
        String legacySha256 = "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92";

        assertTrue(HashUtil.verifyPassword("123456", legacySha256));
        assertFalse(HashUtil.verifyPassword("wrong-password", legacySha256));
    }

    @Test
    void hashPasswordGeneratesSaltedHashes() {
        String firstHash = HashUtil.hashPassword("123456");
        String secondHash = HashUtil.hashPassword("123456");

        assertNotEquals(firstHash, secondHash);
    }
}
