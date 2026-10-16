package com.cropknowledge.dao;

import com.cropknowledge.config.Database;
import com.cropknowledge.model.SearchRecord;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public final class SearchRecordDao {
    public void save(long userId, String queryText, int resultCount) throws SQLException {
        if (queryText == null || queryText.trim().isEmpty()) return;
        String normalized = queryText.trim();
        String latestSql = "SELECT query_text FROM search_records "
            + "WHERE user_id = ? ORDER BY create_time DESC, id DESC LIMIT 1";
        String insertSql = "INSERT INTO search_records (user_id, query_text, result_count) VALUES (?, ?, ?)";
        try (Connection connection = Database.getConnection()) {
            try (PreparedStatement latest = connection.prepareStatement(latestSql)) {
                latest.setLong(1, userId);
                try (ResultSet result = latest.executeQuery()) {
                    if (result.next() && normalized.equals(result.getString("query_text"))) return;
                }
            }
            try (PreparedStatement insert = connection.prepareStatement(insertSql)) {
                insert.setLong(1, userId);
                insert.setString(2, normalized);
                insert.setInt(3, Math.max(0, resultCount));
                insert.executeUpdate();
            }
        }
    }

    public List<SearchRecord> findRecent(long userId, int limit) throws SQLException {
        int safeLimit = Math.max(1, Math.min(limit, 20));
        String sql = "SELECT id, query_text, result_count, create_time FROM search_records "
            + "WHERE user_id = ? AND query_text IS NOT NULL AND TRIM(query_text) <> '' "
            + "ORDER BY create_time DESC, id DESC LIMIT ?";
        List<SearchRecord> records = new ArrayList<>();
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            statement.setInt(2, Math.min(100, safeLimit * 5));
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    Timestamp created = result.getTimestamp("create_time");
                    records.add(new SearchRecord(result.getLong("id"), result.getString("query_text"),
                        result.getInt("result_count"), created == null ? null : created.toLocalDateTime()));
                }
            }
        }
        return deduplicateRecent(records, safeLimit);
    }

    static List<SearchRecord> deduplicateRecent(List<SearchRecord> records, int limit) {
        int safeLimit = Math.max(1, Math.min(limit, 20));
        List<SearchRecord> unique = new ArrayList<>();
        Set<String> seen = new HashSet<>();
        for (SearchRecord record : records) {
            String query = record.queryText == null ? "" : record.queryText.trim();
            if (query.isEmpty() || !seen.add(query)) continue;
            unique.add(record);
            if (unique.size() >= safeLimit) break;
        }
        return unique;
    }
}
