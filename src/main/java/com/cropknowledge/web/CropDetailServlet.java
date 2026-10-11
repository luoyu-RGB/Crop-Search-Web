package com.cropknowledge.web;

import com.cropknowledge.dao.CropDao;
import com.cropknowledge.model.Crop;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/crop/detail")
public class CropDetailServlet extends HttpServlet {
    private final CropDao crops = new CropDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String rawId = request.getParameter("id");
        try {
            long id = Long.parseLong(rawId);
            boolean includePending = "ADMIN".equals(request.getSession(false).getAttribute("role"));
            Crop crop = crops.findById(id, includePending);
            if (crop == null) { response.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            request.setAttribute("crop", crop);
            request.getRequestDispatcher("/WEB-INF/views/crop-detail.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "作物编号无效");
        } catch (SQLException | IllegalStateException ex) {
            getServletContext().log("Crop detail failed", ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "详情服务暂时不可用");
        }
    }
}
