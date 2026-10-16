package com.cropknowledge.web;

import com.cropknowledge.dao.SearchRecordDao;
import com.cropknowledge.model.SearchRecord;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/account/", "/admin/"})
public class PageServlet extends HttpServlet {
    private final SearchRecordDao searchRecords = new SearchRecordDao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getServletPath().startsWith("/admin")) {
            response.sendRedirect(request.getContextPath() + "/admin/crops");
            return;
        }
        String view = "account";
        Object userId = request.getSession(false) == null ? null : request.getSession(false).getAttribute("userId");
        if (userId instanceof Number) {
            try {
                request.setAttribute("searchRecords", searchRecords.findRecent(((Number) userId).longValue(), 10));
            } catch (SQLException ex) {
                getServletContext().log("Search history load failed", ex);
                request.setAttribute("searchRecords", Collections.<SearchRecord>emptyList());
            }
        } else {
            request.setAttribute("searchRecords", Collections.<SearchRecord>emptyList());
        }
        request.getRequestDispatcher("/WEB-INF/views/" + view + ".jsp").forward(request, response);
    }
}
