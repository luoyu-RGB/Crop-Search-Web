package com.cropknowledge.dao;

import com.cropknowledge.config.Database;
import com.cropknowledge.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserDao {
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, password_hash, role, status FROM users WHERE username = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) return null;
                return new User(result.getLong("id"), result.getString("username"),
                    result.getString("password_hash"), result.getString("role"),
                    result.getInt("status") == 1);
            }
        }
    }

    public long create(String username, String passwordHash, String email) throws SQLException {
        String sql = "INSERT INTO users (username, password_hash, email, role, status) VALUES (?, ?, ?, 'USER', 1)";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, username);
            statement.setString(2, passwordHash);
            statement.setString(3, email);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) throw new SQLException("No generated user id");
                return keys.getLong(1);
            }
        }
    }
}
