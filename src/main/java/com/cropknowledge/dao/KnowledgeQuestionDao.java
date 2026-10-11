package com.cropknowledge.dao;

import com.cropknowledge.config.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public final class KnowledgeQuestionDao {
    public void save(long userId, String question, String answer, long cropId, int sourcePage) throws SQLException {
        String sql = "INSERT INTO knowledge_questions (user_id, question, answer, crop_id, source_page) VALUES (?, ?, ?, NULLIF(?, 0), NULLIF(?, 0))";
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId); statement.setString(2, question); statement.setString(3, answer); statement.setLong(4, cropId); statement.setInt(5, sourcePage); statement.executeUpdate();
        }
    }
}
