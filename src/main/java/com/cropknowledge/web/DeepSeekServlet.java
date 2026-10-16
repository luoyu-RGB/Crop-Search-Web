package com.cropknowledge.web;

import com.cropknowledge.dao.CropDao;
import com.cropknowledge.dao.KnowledgeQuestionDao;
import com.cropknowledge.model.Crop;
import com.cropknowledge.model.DeepSeekAnswer;
import com.cropknowledge.model.DeepSeekFieldSuggestion;
import com.cropknowledge.service.DeepSeekAnswerService;
import com.cropknowledge.service.DeepSeekFieldSuggestionService;
import com.cropknowledge.service.DeepSeekService;
import com.cropknowledge.service.WebSearchService;
import com.cropknowledge.security.AiRateLimiter;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.time.Duration;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/assistant", "/admin/ai-suggest"})
public class DeepSeekServlet extends HttpServlet {
    private static final AiRateLimiter USER_LIMITER = new AiRateLimiter(5, Duration.ofMinutes(10));
    private static final AiRateLimiter IP_LIMITER = new AiRateLimiter(20, Duration.ofMinutes(10));
    private final CropDao crops = new CropDao();
    private final KnowledgeQuestionDao questions = new KnowledgeQuestionDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String view = "/assistant".equals(request.getServletPath()) ? "assistant" : "admin-ai-suggest";
        request.getRequestDispatcher("/WEB-INF/views/" + view + ".jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            enforceRateLimit(request);
            if ("/admin/ai-suggest".equals(request.getServletPath())) suggest(request); else answer(request);
        } catch (RateLimitException ex) {
            response.setStatus(429);
            request.setAttribute("error", ex.getMessage());
        } catch (UserInputException ex) {
            request.setAttribute("error", ex.getMessage());
        } catch (DeepSeekService.MissingApiKeyException ex) {
            request.setAttribute("error", "Tomcat 未配置 DEEPSEEK_API_KEY，请在服务器运行配置的“环境”中添加后重启");
        } catch (DeepSeekAnswerService.WebSearchException ex) {
            IOException cause = ex.getCause() instanceof IOException ? (IOException) ex.getCause() : null;
            getServletContext().log("Web search failed: " + (cause == null ? "no results" : cause.getClass().getSimpleName()));
            if (cause == null || cause instanceof WebSearchService.NoResultsException) {
                request.setAttribute("error", "数据库没有匹配资料，联网搜索也没有找到可用结果。请换个关键词重试");
            } else if (cause instanceof WebSearchService.SearchHttpException) {
                int status = ((WebSearchService.SearchHttpException) cause).getStatusCode();
                if (status == 401 || status == 403) {
                    request.setAttribute("error", "网页搜索站点拒绝了请求，请稍后重试");
                } else if (status == 429) {
                    request.setAttribute("error", "联网搜索请求次数已达上限，请稍后重试");
                } else {
                    request.setAttribute("error", "联网搜索服务返回 HTTP " + status + "，请稍后重试");
                }
            } else if (cause instanceof java.net.SocketTimeoutException) {
                request.setAttribute("error", "数据库没有匹配资料，连接联网搜索服务超时，请检查服务器网络后重试");
            } else {
                request.setAttribute("error", "数据库没有匹配资料，联网搜索连接失败，请检查服务器网络后重试");
            }
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

    private static void enforceRateLimit(HttpServletRequest request) {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        Object userId = session == null ? null : session.getAttribute("userId");
        String userKey = userId == null ? "anonymous" : "user:" + userId;
        String ip = request.getRemoteAddr();
        if (!USER_LIMITER.tryAcquire(userKey) || !IP_LIMITER.tryAcquire("ip:" + (ip == null ? "unknown" : ip))) {
            throw new RateLimitException("AI 请求过于频繁，请稍后再试");
        }
    }

    private void answer(HttpServletRequest request) throws SQLException {
        String question = require(request.getParameter("question"), "请输入问题");
        List<Crop> matches = crops.findApprovedMentionedIn(question);
        if (matches.isEmpty()) matches = crops.findApprovedByLocationMentionedIn(question);
        try (DeepSeekService deepSeek = new DeepSeekService()) {
            DeepSeekAnswer answer = new DeepSeekAnswerService(deepSeek, new WebSearchService()).answer(matches, question);
            request.setAttribute("answer", answer);
            long userId = ((Number) request.getSession(false).getAttribute("userId")).longValue();
            try {
                questions.save(userId, question, answer.getHistoryText(), answer.getCropId(), answer.getSourcePage());
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

    private static final class UserInputException extends IllegalArgumentException {
        private UserInputException(String message) { super(message); }
    }

    private static final class RateLimitException extends IllegalArgumentException {
        private RateLimitException(String message) { super(message); }
    }
}
