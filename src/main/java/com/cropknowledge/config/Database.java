package com.cropknowledge.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public final class Database {
    private static volatile HikariDataSource pool;

    private Database() { }

    public static Connection getConnection() throws SQLException {
        return dataSource().getConnection();
    }

    public static synchronized void close() {
        if (pool != null) {
            pool.close();
            pool = null;
        }
    }

    private static HikariDataSource dataSource() {
        if (pool == null) {
            synchronized (Database.class) {
                if (pool == null) {
                    String url = System.getenv("CROP_DB_URL");
                    String user = System.getenv("CROP_DB_USER");
                    String password = System.getenv("CROP_DB_PASSWORD");
                    if (url == null || url.trim().isEmpty() || user == null || password == null) {
                        throw new IllegalStateException("Set CROP_DB_URL, CROP_DB_USER and CROP_DB_PASSWORD");
                    }
                    HikariConfig config = new HikariConfig();
                    config.setJdbcUrl(url);
                    config.setDriverClassName("com.mysql.cj.jdbc.Driver");
                    config.setUsername(user);
                    config.setPassword(password);
                    config.setMaximumPoolSize(10);
                    config.setMinimumIdle(1);
                    config.setConnectionTimeout(10_000);
                    config.setValidationTimeout(5_000);
                    config.setLeakDetectionThreshold(30_000);
                    config.setPoolName("crop-knowledge-db");
                    pool = new HikariDataSource(config);
                }
            }
        }
        return pool;
    }
}
