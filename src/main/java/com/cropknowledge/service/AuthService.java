package com.cropknowledge.service;

import com.cropknowledge.dao.UserDao;
import com.cropknowledge.model.User;
import com.cropknowledge.security.PasswordHasher;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Locale;
import java.util.Objects;
import java.util.regex.Pattern;

public class AuthService {
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9_]{3,30}$");
    private static final Pattern EMAIL = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private final UserDao users;

    public AuthService() {
        this(new UserDao());
    }

    AuthService(UserDao users) {
        this.users = Objects.requireNonNull(users, "users");
    }

    public static String normalizeEmail(String email) {
        return email == null ? null : email.trim().toLowerCase(Locale.ROOT);
    }

    public String validateRegistration(String username, String password, String confirm, String email) {
        if (username == null || !USERNAME.matcher(username).matches()) return "用户名须为 3-30 位字母、数字或下划线";
        if (password == null || password.length() < 8 || password.length() > 128) return "密码须为 8-128 位";
        if (!password.equals(confirm)) return "两次密码不一致";
        String normalizedEmail = normalizeEmail(email);
        if (normalizedEmail == null || normalizedEmail.length() > 100 || !EMAIL.matcher(normalizedEmail).matches()) return "请输入有效邮箱地址";
        return null;
    }

    public long register(String username, String password, String confirm, String email) throws SQLException {
        String error = validateRegistration(username, password, confirm, email);
        if (error != null) throw new IllegalArgumentException(error);
        String normalizedEmail = normalizeEmail(email);
        if (users.findByEmail(normalizedEmail) != null) throw new IllegalArgumentException("该邮箱已被注册");
        try {
            return users.create(username, PasswordHasher.hash(password), normalizedEmail);
        } catch (SQLIntegrityConstraintViolationException ex) {
            String detail = ex.getMessage();
            if (detail != null && (detail.toLowerCase(Locale.ROOT).contains("email")
                || detail.toLowerCase(Locale.ROOT).contains("uq_users_email"))) {
                throw new IllegalArgumentException("该邮箱已被注册", ex);
            }
            throw new IllegalArgumentException("数据库尚未完成邮箱登录迁移，请先执行 database/migrate-email-login.sql", ex);
        }
    }

    public User login(String email, String password) throws SQLException {
        String normalizedEmail = normalizeEmail(email);
        if (normalizedEmail == null || password == null || normalizedEmail.isEmpty() || password.isEmpty()) return null;
        User user = users.findByEmail(normalizedEmail);
        if (user == null || !user.isActive() || !PasswordHasher.verify(password, user.getPasswordHash())) return null;
        return user;
    }
}
