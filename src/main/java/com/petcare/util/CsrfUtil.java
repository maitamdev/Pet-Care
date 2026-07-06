package com.petcare.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class CsrfUtil {
    private static final String TOKEN_NAME = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String token = (String) session.getAttribute(TOKEN_NAME);
        if (token == null) {
            token = generateToken();
            session.setAttribute(TOKEN_NAME, token);
        }
        request.setAttribute(TOKEN_NAME, token);
        return token;
    }

    public static boolean isValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        String expected = (String) session.getAttribute(TOKEN_NAME);
        String actual = request.getParameter(TOKEN_NAME);
        if (!constantTimeEquals(expected, actual)) {
            return false;
        }
        session.removeAttribute(TOKEN_NAME);
        getToken(request);
        return true;
    }

    private static String generateToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private static boolean constantTimeEquals(String expected, String actual) {
        if (expected == null || actual == null) {
            return false;
        }
        return MessageDigest.isEqual(expected.getBytes(), actual.getBytes());
    }
}