package com.cropknowledge.web;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class SecurityFilter implements Filter {
    @Override
    public void doFilter(ServletRequest input, ServletResponse output, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) input;
        HttpServletResponse response = (HttpServletResponse) output;
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("X-Content-Type-Options", "nosniff");
        String path = request.getRequestURI().substring(request.getContextPath().length());
        if (!path.startsWith("/account/") && !path.startsWith("/admin/")
            && !path.equals("/search") && !path.startsWith("/crop/")) {
            chain.doFilter(input, output);
            return;
        }
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (path.startsWith("/admin/") && !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        response.setHeader("Cache-Control", "no-store");
        chain.doFilter(input, output);
    }
}
