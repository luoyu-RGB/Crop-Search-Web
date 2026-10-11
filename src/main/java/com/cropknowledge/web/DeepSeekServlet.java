package com.cropknowledge.web;

import com.cropknowledge.dao.CropDao;
import com.cropknowledge.dao.KnowledgeQuestionDao;
import com.cropknowledge.model.Crop;
import com.cropknowledge.model.DeepSeekAnswer;
import com.cropknowledge.model.DeepSeekFieldSuggestion;
import com.cropknowledge.service.DeepSeekAnswerService;
import com.cropknowledge.service.DeepSeekFieldSuggestionService;
import com.cropknowledge.service.DeepSeekService;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/assistant", "/admin/ai-suggest"})
public class DeepSeekServlet extends HttpServlet {
    private final CropDao crops = new CropDao();
    private final KnowledgeQuestionDao questions = new KnowledgeQuestionDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String view = "/assistant".equals(request.getServletPath()) ? "assistant" : "admin-ai-suggest";
        request.getRequestDispatcher("/WEB-INF/views/" + view + ".jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            if ("/admin/ai-suggest".equals(request.getServletPath())) suggest(request); else answer(request);
        } catch (UserInputException ex) {
            request.setAttribute("error", ex.getMessage());
        } catch (DeepSeekService.MissingApiKeyException ex) {
            request.setAttribute("error", "Tomcat 未配置 DEEPSEEK_API_KEY，请在服务器运行配置的“环境”中添加后重启");
        } catch (IllegalStateException ex) {
            request.setAttribute("error", "DeepSeek 配置或响应异常，请检查服务器日志与环境变量");
        } catch (SQLException ex) {
            getServletContext().log("DeepSeek database request failed", ex);
            request.setAttribute("error", "数据库服务暂时不可用");
        } catch (RuntimeException ex) {
            getServletContext().log("DeepSeek API request failed: " + ex.getClass().getSimpleName());
            request.setAttribute("error", "DeepSeek 服务调用失败，请检查 API 配置或网络连接");
        }
        doGet(request, response);
    }

    private void answer(HttpServletRequest request) throws SQLException {
        String question = require(request.getParameter("question"), "请输入问题");
        Crop crop = crops.findApprovedByName(cropName(question));
        try (DeepSeekService deepSeek = new DeepSeekService()) {
            DeepSeekAnswer answer = new DeepSeekAnswerService(deepSeek).answer(crop, question);
            request.setAttribute("answer", answer);
            long userId = ((Number) request.getSession(false).getAttribute("userId")).longValue();
            try {
                questions.save(userId, question, answer.getText(), answer.getCropId(), answer.getSourcePage());
            } catch (SQLException ex) {
                getServletContext().log("DeepSeek question history save failed", ex);
                request.setAttribute("error", "结果已显示，但问答记录保存失败");
            }
        }
    }

    private void suggest(HttpServletRequest request) {
        String text = require(request.getParameter("ocrText"), "OCR 文本不能为空");
        int page;
        try { page = Integer.parseInt(request.getParameter("sourcePage")); }
        catch (NumberFormatException ex) { throw new UserInputException("来源页码无效"); }
        if (page < 1) throw new UserInputException("来源页码无效");
        try (DeepSeekService deepSeek = new DeepSeekService()) {
            DeepSeekFieldSuggestion suggestion = new DeepSeekFieldSuggestionService(deepSeek).suggest(text, page);
            request.setAttribute("suggestion", suggestion);
        }
    }

    private static String require(String value, String message) {
        if (value == null || value.trim().isEmpty()) throw new UserInputException(message);
        if (value.length() > 4000) throw new UserInputException("输入内容过长");
        return value.trim();
    }

    private static String cropName(String question) {
        String value = question.replaceFirst("^(请问|请|帮我|想知道)", "").trim();
        int end = value.indexOf('的');
        if (end > 0) value = value.substring(0, end);
        for (String token : new String[]{"是什么", "有哪些", "怎么样", "如何", "？", "?"}) {
            int at = value.indexOf(token); if (at > 0) value = value.substring(0, at);
        }
        return value.replaceAll("^(介绍|查询|查找|搜索|关于)", "").trim();
    }

    private static final class UserInputException extends IllegalArgumentException {
        private UserInputException(String message) { super(message); }
    }
}
