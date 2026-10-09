package com.cropknowledge.web;

import com.cropknowledge.model.User;
import com.cropknowledge.service.AuthService;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/register", "/login", "/logout"})
public class AuthServlet extends HttpServlet {
    private final AuthService auth = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/logout".equals(path)) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/" + ("/register".equals(path) ? "register" : "login") + ".jsp")
            .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        try {
            if ("/register".equals(path)) {
                auth.register(username, password, request.getParameter("confirmPassword"), request.getParameter("email"));
                response.sendRedirect(request.getContextPath() + "/login?registered=1");
                return;
            }
            User user = auth.login(username, password);
            if (user == null) {
                request.setAttribute("error", "用户名或密码错误，或账号已禁用");
            } else {
                HttpSession old = request.getSession(false);
                if (old != null) old.invalidate();
                HttpSession session = request.getSession(true);
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(request.getContextPath() + ("ADMIN".equals(user.getRole()) ? "/admin/" : "/account/"));
                return;
            }
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
        } catch (SQLException | IllegalStateException ex) {
            getServletContext().log("Authentication failed", ex);
            request.setAttribute("error", "服务暂时不可用，请检查数据库配置");
        }
        doGet(request, response);
    }
}
