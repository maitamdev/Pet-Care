package com.petcare.util;

import java.util.Set;

public final class RedirectUtil {

    private static final Set<String> ALLOWED_REDIRECTS = Set.of("booking", "booking/success");

    private RedirectUtil() {
    }

    public static String sanitizeRedirect(String redirect) {
        if (ValidationUtil.isEmpty(redirect)) {
            return null;
        }
        String target = redirect.trim();
        if (target.startsWith("/")) {
            target = target.substring(1);
        }
        return ALLOWED_REDIRECTS.contains(target) ? target : null;
    }
}