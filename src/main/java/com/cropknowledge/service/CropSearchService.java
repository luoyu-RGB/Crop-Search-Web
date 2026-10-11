package com.cropknowledge.service;

import com.cropknowledge.model.CropSearch;
import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class CropSearchService {
    private static final Set<String> COMPONENTS = new HashSet<>(Arrays.asList(
        "C12:0", "C14:0", "C16:0", "C16:1", "C18:0", "C18:1", "C18:2", "C18:3", "C20:0", "C20:1"));
    private static final Set<String> FILTER_FIELDS = new HashSet<>(Arrays.asList(
        "family", "genus", "features", "distribution", "cultivation", "uses"));

    public CropSearch parse(HttpServletRequest request) {
        CropSearch search = new CropSearch();
        search.name = text(request, "name");
        search.family = text(request, "family");
        search.genus = text(request, "genus");
        search.features = text(request, "features");
        search.distribution = text(request, "distribution");
        search.cultivation = text(request, "cultivation");
        search.uses = text(request, "uses");
        parseTextFilters(request, search);
        search.minOil = number(request, "minOil");
        search.maxOil = number(request, "maxOil");
        search.minIodine = number(request, "minIodine");
        search.maxIodine = number(request, "maxIodine");
        search.minAcid = number(request, "minAcid");
        search.maxAcid = number(request, "maxAcid");
        search.minSaponification = number(request, "minSaponification");
        search.maxSaponification = number(request, "maxSaponification");
        search.component = text(request, "component");
        search.minComponent = number(request, "minComponent");
        search.maxComponent = number(request, "maxComponent");
        if (!search.component.isEmpty() && !COMPONENTS.contains(search.component)) {
            throw new IllegalArgumentException("请选择有效的脂肪酸组分");
        }
        if (search.component.isEmpty() && (search.minComponent != null || search.maxComponent != null)) {
            throw new IllegalArgumentException("请先选择脂肪酸组分");
        }
        range(search.minOil, search.maxOil);
        range(search.minIodine, search.maxIodine);
        range(search.minAcid, search.maxAcid);
        range(search.minSaponification, search.maxSaponification);
        range(search.minComponent, search.maxComponent);
        search.matchAny = "any".equals(request.getParameter("match"));
        search.includePending = request.getSession(false) != null
            && "ADMIN".equals(request.getSession(false).getAttribute("role"))
            && "true".equals(request.getParameter("preview"));
        String page = request.getParameter("page");
        if (page != null && !page.isEmpty()) {
            try { search.page = Math.max(1, Integer.parseInt(page)); }
            catch (NumberFormatException ex) { throw new IllegalArgumentException("页码无效"); }
        }
        return search;
    }

    private static void parseTextFilters(HttpServletRequest request, CropSearch search) {
        String[] fields = request.getParameterValues("filterField");
        String[] values = request.getParameterValues("filterValue");
        if (fields == null && values == null) return;
        if (fields == null || values == null || fields.length != values.length || fields.length > 3) {
            throw new IllegalArgumentException("组合查询条件无效");
        }
        for (int i = 0; i < fields.length; i++) {
            String field = fields[i] == null ? "" : fields[i].trim();
            String value = values[i] == null ? "" : values[i].trim();
            if (value.isEmpty()) continue;
            if (!FILTER_FIELDS.contains(field)) throw new IllegalArgumentException("请选择有效的组合查询字段");
            if (value.length() > 100) throw new IllegalArgumentException("查询内容不能超过 100 字");
            search.textFilters.add(new CropSearch.TextFilter(field, value));
        }
    }

    public void validateFilterOptions(CropSearch search, Map<String, List<String>> options) {
        for (CropSearch.TextFilter filter : search.textFilters) {
            if (!options.getOrDefault(filter.field, java.util.Collections.emptyList()).contains(filter.value)) {
                throw new IllegalArgumentException("请选择列表中的组合查询内容");
            }
        }
    }

    private static String text(HttpServletRequest request, String key) {
        String value = request.getParameter(key);
        if (value == null) return "";
        value = value.trim();
        if (value.length() > 100) throw new IllegalArgumentException("查询内容不能超过 100 字");
        return value;
    }

    private static BigDecimal number(HttpServletRequest request, String key) {
        String raw = text(request, key);
        if (raw.isEmpty()) return null;
        try {
            BigDecimal value = new BigDecimal(raw);
            if (value.signum() < 0 || value.compareTo(new BigDecimal("100000")) > 0) throw new NumberFormatException();
            return value;
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("请输入有效的非负数值");
        }
    }

    private static void range(BigDecimal min, BigDecimal max) {
        if (min != null && max != null && min.compareTo(max) > 0) {
            throw new IllegalArgumentException("最小值不能大于最大值");
        }
    }
}
