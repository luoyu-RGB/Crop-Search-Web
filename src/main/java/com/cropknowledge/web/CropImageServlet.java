package com.cropknowledge.web;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** Serves administrator uploads from an optional directory outside the web root. */
@WebServlet("/assets/crops/admin/*")
public final class CropImageServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.contains("..") || pathInfo.contains("\\") || pathInfo.startsWith("//")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); return;
        }
        Path root = uploadRoot();
        Path file = root.resolve(pathInfo.substring(1)).normalize();
        if (!file.startsWith(root) || !Files.isRegularFile(file)) { response.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
        String name = file.getFileName().toString().toLowerCase();
        String type = name.endsWith(".png") ? "image/png" : name.endsWith(".gif") ? "image/gif" : "image/jpeg";
        response.setContentType(type);
        response.setHeader("Cache-Control", "public, max-age=86400");
        try (InputStream input = Files.newInputStream(file)) {
            byte[] buffer = new byte[8192];
            int count;
            while ((count = input.read(buffer)) != -1) response.getOutputStream().write(buffer, 0, count);
        }
    }

    private Path uploadRoot() throws IOException {
        String configured = System.getenv("CROP_UPLOAD_DIR");
        String realPath = configured == null || configured.trim().isEmpty()
            ? getServletContext().getRealPath("/assets/crops/admin") : configured.trim();
        if (realPath == null) throw new IOException("Upload directory is unavailable");
        return Paths.get(realPath).toAbsolutePath().normalize();
    }
}
