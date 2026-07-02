package com.petcare.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CsrfUtil {
    private static final String TOKEN_NAME = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String token = (String) session.getAttribute(TOKEN_NAME);
        if (token == null) {
            byte[] bytes = new byte[32];
            RANDOM.nextBytes(bytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
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
        return expected != null && actual != null && expected.equals(actual);
    }
}
