package com.cropknowledge.service;

import com.cropknowledge.dao.UserDao;
import com.cropknowledge.model.User;
import com.cropknowledge.security.PasswordHasher;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.regex.Pattern;

public class AuthService {
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9_]{3,30}$");
    private static final Pattern EMAIL = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private final UserDao users = new UserDao();

    public String validateRegistration(String username, String password, String confirm, String email) {
        if (username == null || !USERNAME.matcher(username).matches()) return "用户名须为 3-30 位字母、数字或下划线";
        if (password == null || password.length() < 8 || password.length() > 128) return "密码须为 8-128 位";
        if (!password.equals(confirm)) return "两次密码不一致";
        if (email == null || email.length() > 100 || !EMAIL.matcher(email).matches()) return "请输入有效邮箱地址";
        return null;
    }

    public long register(String username, String password, String confirm, String email) throws SQLException {
        String error = validateRegistration(username, password, confirm, email);
        if (error != null) throw new IllegalArgumentException(error);
        if (users.findByUsername(username) != null) throw new IllegalArgumentException("用户名已被使用");
        try {
            return users.create(username, PasswordHasher.hash(password), email);
        } catch (SQLIntegrityConstraintViolationException ex) {
            throw new IllegalArgumentException("用户名已被使用", ex);
        }
    }

    public User login(String username, String password) throws SQLException {
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) return null;
        User user = users.findByUsername(username);
        if (user == null || !user.isActive() || !PasswordHasher.verify(password, user.getPasswordHash())) return null;
        return user;
    }
}
