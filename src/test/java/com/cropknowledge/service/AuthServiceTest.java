package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import org.junit.jupiter.api.Test;

class AuthServiceTest {
    private final AuthService service = new AuthService();

    @Test
    void registrationRejectsInvalidInputBeforeDatabaseAccess() {
        assertEquals("用户名须为 3-30 位字母、数字或下划线",
            service.validateRegistration("a", "password123", "password123", "a@example.com"));
        assertEquals("两次密码不一致",
            service.validateRegistration("valid_user", "password123", "different", "a@example.com"));
        assertEquals("请输入有效邮箱地址",
            service.validateRegistration("valid_user", "password123", "password123", "invalid"));
        assertNull(service.validateRegistration("valid_user", "password123", "password123", "a@example.com"));
    }
}
