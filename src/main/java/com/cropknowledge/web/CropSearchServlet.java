package com.cropknowledge.web;

import com.cropknowledge.dao.CropDao;
import com.cropknowledge.model.CropPage;
import com.cropknowledge.model.CropSearch;
import com.cropknowledge.service.CropSearchService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/search")
public class CropSearchServlet extends HttpServlet {
    private final CropSearchService searchService = new CropSearchService();
    private final CropDao crops = new CropDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            CropSearch search = searchService.parse(request);
            Map<String, List<String>> filterOptions = crops.filterOptions(search.includePending);
            request.setAttribute("filterOptions", filterOptions);
            searchService.validateFilterOptions(search, filterOptions);
            CropPage page = crops.search(search);
            request.setAttribute("search", search);
            request.setAttribute("page", page);
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
        } catch (SQLException | IllegalStateException ex) {
            getServletContext().log("Crop search failed", ex);
            request.setAttribute("error", "查询服务暂时不可用，请检查数据库配置");
        }
        request.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(request, response);
    }
}
