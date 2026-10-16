package com.cropknowledge.web;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/** Session-bound CSRF token for state-changing browser requests. */
public final class Csrf {
    private static final String SESSION_KEY = Csrf.class.getName() + ".token";
    private static final SecureRandom RANDOM = new SecureRandom();

    private Csrf() { }

    public static String token(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        Object existing = session.getAttribute(SESSION_KEY);
        if (existing instanceof String && !((String) existing).isEmpty()) return (String) existing;
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        session.setAttribute(SESSION_KEY, token);
        return token;
    }

    public static boolean isValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        Object expected = session.getAttribute(SESSION_KEY);
        String actual = request.getParameter("_csrf");
        if (actual == null || actual.isEmpty()) actual = request.getHeader("X-CSRF-Token");
        return expected instanceof String && actual != null
            && MessageDigest.isEqual(((String) expected).getBytes(StandardCharsets.US_ASCII),
                actual.getBytes(StandardCharsets.US_ASCII));
    }
}
