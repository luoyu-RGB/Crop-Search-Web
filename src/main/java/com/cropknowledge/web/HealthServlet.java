package com.cropknowledge.web;

import com.cropknowledge.config.Database;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** Minimal readiness endpoint for Tomcat or a reverse proxy health check. */
@WebServlet("/health")
public final class HealthServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT 1");
             ResultSet result = statement.executeQuery()) {
            if (!result.next() || result.getInt(1) != 1) throw new SQLException("Database health check returned no result");
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"status\":\"ok\"}");
        } catch (SQLException | IllegalStateException ex) {
            getServletContext().log("Health check failed", ex);
            response.setStatus(503);
            response.getWriter().write("{\"status\":\"unavailable\"}");
        }
    }
}
