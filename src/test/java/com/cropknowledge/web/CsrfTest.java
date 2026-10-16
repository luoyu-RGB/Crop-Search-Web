package com.cropknowledge.web;

import static org.junit.jupiter.api.Assertions.*;
import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;

class CsrfTest {
    @Test
    void tokenIsStableAndValidatesAgainstSession() {
        Map<String, Object> values = new HashMap<>();
        HttpSession session = (HttpSession) Proxy.newProxyInstance(getClass().getClassLoader(), new Class<?>[]{HttpSession.class},
            (proxy, method, args) -> {
                if ("getAttribute".equals(method.getName())) return values.get(args[0]);
                if ("setAttribute".equals(method.getName())) { values.put((String) args[0], args[1]); return null; }
                if ("getId".equals(method.getName())) return "test";
                return defaultValue(method.getReturnType());
            });
        final String[] submitted = new String[1];
        HttpServletRequest request = (HttpServletRequest) Proxy.newProxyInstance(getClass().getClassLoader(), new Class<?>[]{HttpServletRequest.class},
            (proxy, method, args) -> {
                if ("getSession".equals(method.getName())) return session;
                if ("getParameter".equals(method.getName())) return "_csrf".equals(args[0]) ? submitted[0] : null;
                if ("getHeader".equals(method.getName())) return null;
                return defaultValue(method.getReturnType());
            });
        String token = Csrf.token(request);
        assertEquals(token, Csrf.token(request));
        submitted[0] = token;
        assertTrue(Csrf.isValid(request));
        submitted[0] = "wrong";
        assertFalse(Csrf.isValid(request));
    }

    private static Object defaultValue(Class<?> type) {
        if (!type.isPrimitive()) return null;
        if (type == boolean.class) return false;
        if (type == char.class) return '\0';
        if (type == byte.class) return (byte) 0;
        if (type == short.class) return (short) 0;
        if (type == int.class) return 0;
        if (type == long.class) return 0L;
        if (type == float.class) return 0f;
        if (type == double.class) return 0d;
        return null;
    }
}
