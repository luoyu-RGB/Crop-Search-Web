package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import com.cropknowledge.dao.UserDao;
import com.cropknowledge.model.User;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import org.junit.jupiter.api.Test;

class AuthServiceTest {
    @Test
    void registrationRejectsInvalidInputBeforeDatabaseAccess() {
        AuthService service = new AuthService(new InMemoryUserDao());
        assertEquals("用户名须为 3-30 位字母、数字或下划线",
            service.validateRegistration("a", "password123", "password123", "a@example.com"));
        assertEquals("两次密码不一致",
            service.validateRegistration("valid_user", "password123", "different", "a@example.com"));
        assertEquals("请输入有效邮箱地址",
            service.validateRegistration("valid_user", "password123", "password123", "invalid"));
        assertNull(service.validateRegistration("valid_user", "password123", "password123", "a@example.com"));
    }

    @Test
    void usernamesMayRepeatButEmailsMustBeUnique() throws SQLException {
        InMemoryUserDao users = new InMemoryUserDao();
        AuthService service = new AuthService(users);

        service.register("same_name", "password123", "password123", "First@Example.com");
        service.register("same_name", "password456", "password456", "second@example.com");

        assertEquals(2, users.size());
        IllegalArgumentException duplicateEmail = assertThrows(IllegalArgumentException.class,
            () -> service.register("another_name", "password789", "password789", " first@example.com "));
        assertEquals("该邮箱已被注册", duplicateEmail.getMessage());
        assertEquals(2, users.size());
    }

    @Test
    void loginUsesNormalizedEmailAndNeverUsername() throws SQLException {
        InMemoryUserDao users = new InMemoryUserDao();
        AuthService service = new AuthService(users);
        service.register("login_name", "password123", "password123", "person@example.com");

        User loggedIn = service.login(" PERSON@EXAMPLE.COM ", "password123");
        assertNotNull(loggedIn);
        assertEquals("login_name", loggedIn.getUsername());
        assertNull(service.login("login_name", "password123"));
    }

    private static final class InMemoryUserDao extends UserDao {
        private final Map<String, User> byEmail = new HashMap<>();
        private long nextId = 1;

        @Override
        public User findByEmail(String email) {
            return byEmail.get(AuthService.normalizeEmail(email));
        }

        @Override
        public long create(String username, String passwordHash, String email) throws SQLException {
            String normalized = AuthService.normalizeEmail(email);
            if (byEmail.containsKey(normalized)) {
                throw new java.sql.SQLIntegrityConstraintViolationException("duplicate email");
            }
            User user = new User(nextId++, username, passwordHash, "USER", true);
            byEmail.put(normalized, user);
            return user.getId();
        }

        int size() {
            return byEmail.size();
        }
    }
}
