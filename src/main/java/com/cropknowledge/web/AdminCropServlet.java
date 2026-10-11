package com.cropknowledge.web;

import com.cropknowledge.dao.CropDao;
import com.cropknowledge.model.Crop;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/admin/crops/*")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class AdminCropServlet extends HttpServlet {
    private static final String[] STATUSES = {"DRAFT", "PENDING", "APPROVED", "REJECTED"};
    private static final String[] COMPONENTS = {"C12:0", "C14:0", "C16:0", "C16:1", "C18:0", "C18:1", "C18:2", "C18:3", "C20:0", "C20:1"};
    private final CropDao crops = new CropDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        try {
            if (path == null || "/".equals(path) || "/list".equals(path)) {
                request.setAttribute("crops", crops.findForAdmin(request.getParameter("status"), request.getParameter("name")));
                request.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(request, response);
                return;
            }
            if ("/edit".equals(path)) {
                String rawId = request.getParameter("id");
                Crop crop = rawId == null || rawId.trim().isEmpty() ? new Crop() : crops.findByIdForAdmin(parseId(rawId));
                if (crop == null) { response.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
                if (crop.reviewStatus == null) crop.reviewStatus = "DRAFT";
                request.setAttribute("crop", crop);
                request.setAttribute("statuses", STATUSES);
                request.setAttribute("components", COMPONENTS);
                request.getRequestDispatcher("/WEB-INF/views/admin-crop-edit.jsp").forward(request, response);
                return;
            }
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid crop id");
        } catch (SQLException ex) {
            getServletContext().log("Admin crop page failed", ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database service unavailable");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = trim(request.getParameter("action"));
        try {
            if ("save".equals(action)) { saveCrop(request, response); return; }
            long cropId = parseId(request.getParameter("cropId"));
            if ("delete".equals(action)) { crops.delete(cropId); response.sendRedirect(request.getContextPath() + "/admin/crops"); return; }
            if ("addAlias".equals(action)) { requireText(request.getParameter("alias"), "Alias is required", 100); crops.addAlias(cropId, request.getParameter("alias").trim()); redirectEdit(request, response, cropId); return; }
            if ("deleteAlias".equals(action)) { crops.deleteAlias(cropId, request.getParameter("alias")); redirectEdit(request, response, cropId); return; }
            if ("addSample".equals(action)) { addSample(request, response, cropId); return; }
            if ("updateSample".equals(action)) { updateSample(request, response, cropId); return; }
            if ("deleteSample".equals(action)) { crops.deleteSample(cropId, parseId(request.getParameter("sampleId"))); redirectEdit(request, response, cropId); return; }
            if ("uploadImage".equals(action)) { uploadImage(request, response, cropId); return; }
            if ("deleteImage".equals(action)) { deleteImage(request, response, cropId, parseId(request.getParameter("imageId"))); return; }
            if ("setCover".equals(action)) { crops.setCover(cropId, parseId(request.getParameter("imageId"))); redirectEdit(request, response, cropId); return; }
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown admin action");
        } catch (IllegalArgumentException ex) {
            showEditError(request, response, ex.getMessage());
        } catch (SQLException ex) {
            getServletContext().log("Admin crop action failed", ex);
            showEditError(request, response, ex.getSQLState() != null && ex.getSQLState().startsWith("23") ? "保存失败：名称或别名已经存在" : "保存失败，请检查数据库连接");
        }
    }

    private void saveCrop(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException, ServletException {
        Crop crop = new Crop();
        String rawId = trim(request.getParameter("id"));
        crop.id = rawId.isEmpty() ? 0 : parseId(rawId);
        crop.chineseName = requireText(request.getParameter("chineseName"), "中文名不能为空", 100);
        crop.englishName = trim(request.getParameter("englishName")); crop.latinName = trim(request.getParameter("latinName"));
        crop.family = trim(request.getParameter("family")); crop.genus = trim(request.getParameter("genus"));
        crop.features = trim(request.getParameter("features")); crop.distribution = trim(request.getParameter("distribution"));
        crop.cultivation = trim(request.getParameter("cultivation")); crop.uses = trim(request.getParameter("uses"));
        crop.sourcePage = parseOptionalInt(request.getParameter("sourcePage"), "来源页码必须是正整数");
        crop.reviewStatus = validStatus(request.getParameter("reviewStatus"));
        if (crop.id == 0) { long id = crops.create(crop); response.sendRedirect(request.getContextPath() + "/admin/crops/edit?id=" + id + "&saved=1"); }
        else { crops.update(crop); response.sendRedirect(request.getContextPath() + "/admin/crops/edit?id=" + crop.id + "&saved=1"); }
    }

    private void addSample(HttpServletRequest request, HttpServletResponse response, long cropId) throws IOException, SQLException {
        Crop.Sample sample = sampleFromRequest(request);
        crops.addSample(cropId, sample, parseComponents(request.getParameter("components")));
        redirectEdit(request, response, cropId);
    }

    private void updateSample(HttpServletRequest request, HttpServletResponse response, long cropId) throws IOException, SQLException {
        Crop.Sample sample = sampleFromRequest(request);
        crops.updateSample(cropId, parseId(request.getParameter("sampleId")), sample, parseComponents(request.getParameter("components")));
        redirectEdit(request, response, cropId);
    }

    private static Crop.Sample sampleFromRequest(HttpServletRequest request) {
        Crop.Sample sample = new Crop.Sample();
        sample.collectionUnit = trim(request.getParameter("collectionUnit")); sample.testUnit = trim(request.getParameter("testUnit")); sample.origin = trim(request.getParameter("origin")); sample.testPart = trim(request.getParameter("testPart")); sample.remark = trim(request.getParameter("remark"));
        sample.oilContent = decimal(request.getParameter("oilContent"), "含油率"); sample.iodineValue = decimal(request.getParameter("iodineValue"), "碘值"); sample.acidValue = decimal(request.getParameter("acidValue"), "酸值"); sample.saponificationValue = decimal(request.getParameter("saponificationValue"), "皂化值");
        return sample;
    }

    private void uploadImage(HttpServletRequest request, HttpServletResponse response, long cropId) throws IOException, SQLException, ServletException {
        Part part = request.getPart("imageFile");
        if (part == null || part.getSize() == 0) throw new IllegalArgumentException("请选择图片文件");
        if (part.getContentType() == null || !part.getContentType().toLowerCase().startsWith("image/")) throw new IllegalArgumentException("上传文件必须是图片");
        String original = part.getSubmittedFileName();
        String filename = original == null ? "" : Paths.get(original).getFileName().toString();
        int dot = filename.lastIndexOf('.'); String extension = dot < 0 ? "" : filename.substring(dot + 1).toLowerCase();
        if (!("jpg".equals(extension) || "jpeg".equals(extension) || "png".equals(extension) || "gif".equals(extension) || "webp".equals(extension))) throw new IllegalArgumentException("仅支持 JPG、PNG、GIF 或 WEBP 图片");
        Path root = uploadRoot(); Files.createDirectories(root);
        String storedName = UUID.randomUUID().toString().replace("-", "") + "." + extension;
        Path target = root.resolve(storedName); try (java.io.InputStream input = part.getInputStream()) { Files.copy(input, target); }
        try { crops.addImage(cropId, "admin/" + storedName, trim(request.getParameter("imageTitle")), extension, "true".equals(request.getParameter("cover"))); }
        catch (SQLException ex) { Files.deleteIfExists(target); throw ex; }
        redirectEdit(request, response, cropId);
    }

    private void deleteImage(HttpServletRequest request, HttpServletResponse response, long cropId, long imageId) throws IOException, SQLException {
        Crop crop = crops.findByIdForAdmin(cropId); if (crop == null) throw new IllegalArgumentException("作物不存在");
        String path = null; for (Crop.Image image : crop.images) if (image.id == imageId) path = image.path;
        crops.deleteImage(cropId, imageId); if (path != null && path.startsWith("admin/")) Files.deleteIfExists(uploadRoot().resolve(path.substring("admin/".length())).normalize());
        redirectEdit(request, response, cropId);
    }

    private Path uploadRoot() throws IOException {
        String realPath = getServletContext().getRealPath("/assets/crops/admin");
        if (realPath == null) throw new IOException("Upload directory is unavailable");
        return Paths.get(realPath).toAbsolutePath().normalize();
    }

    private void showEditError(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        try {
            String rawId = trim(request.getParameter("id")); if (rawId.isEmpty()) rawId = trim(request.getParameter("cropId"));
            Crop crop = rawId.isEmpty() ? new Crop() : crops.findByIdForAdmin(parseId(rawId));
            if (crop == null) crop = new Crop(); if (crop.reviewStatus == null) crop.reviewStatus = "DRAFT";
            request.setAttribute("crop", crop); request.setAttribute("statuses", STATUSES); request.setAttribute("components", COMPONENTS); request.setAttribute("error", message);
            request.getRequestDispatcher("/WEB-INF/views/admin-crop-edit.jsp").forward(request, response);
        } catch (SQLException ex) { throw new ServletException(ex); }
    }

    private void redirectEdit(HttpServletRequest request, HttpServletResponse response, long cropId) throws IOException { response.sendRedirect(request.getContextPath() + "/admin/crops/edit?id=" + cropId + "&saved=1"); }
    private static long parseId(String value) { try { long id = Long.parseLong(value); if (id <= 0) throw new NumberFormatException(); return id; } catch (Exception ex) { throw new IllegalArgumentException("编号无效"); } }
    private static String trim(String value) { return value == null ? "" : value.trim(); }
    private static String requireText(String value, String message, int max) { String text = trim(value); if (text.isEmpty() || text.length() > max) throw new IllegalArgumentException(message); return text; }
    private static int parseOptionalInt(String value, String message) { String text = trim(value); if (text.isEmpty()) return 0; try { int number = Integer.parseInt(text); if (number <= 0) throw new NumberFormatException(); return number; } catch (NumberFormatException ex) { throw new IllegalArgumentException(message); } }
    private static String validStatus(String value) { for (String status : STATUSES) if (status.equals(value)) return value; throw new IllegalArgumentException("审核状态无效"); }
    private static BigDecimal decimal(String value, String label) { String text = trim(value); if (text.isEmpty()) return null; try { BigDecimal number = new BigDecimal(text); if (number.signum() < 0) throw new NumberFormatException(); return number; } catch (NumberFormatException ex) { throw new IllegalArgumentException(label + "必须是非负数字"); } }
    private static Map<String, BigDecimal> parseComponents(String value) {
        Map<String, BigDecimal> values = new LinkedHashMap<>(); String text = trim(value); if (text.isEmpty()) return values;
        for (String item : text.split("[,;\\n]")) { String[] pair = item.trim().split("=", 2); if (pair.length != 2) throw new IllegalArgumentException("脂肪酸格式应为 C18:1=12.3"); String name = pair[0].trim(); boolean valid = false; for (String component : COMPONENTS) if (component.equals(name)) valid = true; if (!valid) throw new IllegalArgumentException("脂肪酸名称无效：" + name); values.put(name, decimal(pair[1], name)); }
        return values;
    }
}
