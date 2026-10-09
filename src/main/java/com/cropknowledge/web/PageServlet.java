package com.cropknowledge.web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/account/", "/admin/"})
public class PageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String view = request.getServletPath().startsWith("/admin") ? "admin" : "account";
        request.getRequestDispatcher("/WEB-INF/views/" + view + ".jsp").forward(request, response);
    }
}
