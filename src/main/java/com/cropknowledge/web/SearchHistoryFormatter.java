package com.cropknowledge.web;

import com.cropknowledge.model.CropSearch;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Creates short, readable labels for the recent-search panel. */
public final class SearchHistoryFormatter {
    private static final Map<String, String> LABELS = new HashMap<>();
    static {
        LABELS.put("name", "名称");
        LABELS.put("family", "科");
        LABELS.put("genus", "属");
        LABELS.put("features", "特征");
        LABELS.put("distribution", "分布地区");
        LABELS.put("cultivation", "栽培");
        LABELS.put("uses", "用途");
        LABELS.put("minOil", "含油率 ≥");
        LABELS.put("maxOil", "含油率 ≤");
        LABELS.put("minIodine", "碘值 ≥");
        LABELS.put("maxIodine", "碘值 ≤");
        LABELS.put("minAcid", "酸值 ≥");
        LABELS.put("maxAcid", "酸值 ≤");
        LABELS.put("minSaponification", "皂化值 ≥");
        LABELS.put("maxSaponification", "皂化值 ≤");
        LABELS.put("component", "脂肪酸");
        LABELS.put("minComponent", "脂肪酸 ≥");
        LABELS.put("maxComponent", "脂肪酸 ≤");
    }

    private SearchHistoryFormatter() { }

    public static String summarize(CropSearch search) {
        if (search == null || !search.hasCriteria()) return "";
        List<String> parts = new ArrayList<>();
        add(parts, "名称", search.name);
        add(parts, "科", search.family);
        add(parts, "属", search.genus);
        add(parts, "特征", search.features);
        add(parts, "分布地区", search.distribution);
        add(parts, "栽培", search.cultivation);
        add(parts, "用途", search.uses);
        for (CropSearch.TextFilter filter : search.textFilters) {
            add(parts, LABELS.getOrDefault(filter.field, filter.field), filter.value);
        }
        addRange(parts, "含油率", search.minOil, search.maxOil, "%");
        addRange(parts, "碘值", search.minIodine, search.maxIodine, "");
        addRange(parts, "酸值", search.minAcid, search.maxAcid, "");
        addRange(parts, "皂化值", search.minSaponification, search.maxSaponification, "");
        if (search.hasComponentCondition()) {
            String range = range(search.minComponent, search.maxComponent, "%");
            add(parts, "脂肪酸", search.component + range);
        }
        return limit(String.join(" · ", parts));
    }

    /** Converts records created by older versions from URL syntax to readable text. */
    public static String display(String stored) {
        if (stored == null || stored.trim().isEmpty()) return "";
        String value = stored.trim();
        if (value.indexOf('=') < 0 && value.indexOf('&') < 0) return limit(value);
        Map<String, List<String>> params = new HashMap<>();
        for (String pair : value.split("&")) {
            if (pair.isEmpty()) continue;
            String[] pieces = pair.split("=", 2);
            String key = decode(pieces[0]);
            String item = pieces.length == 1 ? "" : decode(pieces[1]);
            if (!item.isEmpty()) params.computeIfAbsent(key, ignored -> new ArrayList<>()).add(item);
        }
        List<String> parts = new ArrayList<>();
        for (String key : new String[]{"name", "family", "genus", "features", "distribution", "cultivation", "uses"}) {
            addFirst(parts, LABELS.get(key), params.get(key));
        }
        List<String> fields = params.get("filterField");
        List<String> values = params.get("filterValue");
        if (fields != null && values != null) {
            for (int i = 0; i < Math.min(fields.size(), values.size()); i++) {
                add(parts, LABELS.getOrDefault(fields.get(i), fields.get(i)), values.get(i));
            }
        }
        for (String key : new String[]{"minOil", "maxOil", "minIodine", "maxIodine", "minAcid", "maxAcid", "minSaponification", "maxSaponification", "component", "minComponent", "maxComponent"}) {
            addFirst(parts, LABELS.get(key), params.get(key));
        }
        return limit(String.join(" · ", parts));
    }

    private static void addRange(List<String> parts, String label, BigDecimal min, BigDecimal max, String suffix) {
        if (min == null && max == null) return;
        if (min != null && max != null) add(parts, label, number(min) + "–" + number(max) + suffix);
        else if (min != null) add(parts, label + " ≥", number(min) + suffix);
        else add(parts, label + " ≤", number(max) + suffix);
    }

    private static String range(BigDecimal min, BigDecimal max, String suffix) {
        if (min == null && max == null) return "";
        if (min != null && max != null) return " " + number(min) + "–" + number(max) + suffix;
        if (min != null) return " ≥" + number(min) + suffix;
        return " ≤" + number(max) + suffix;
    }

    private static String number(BigDecimal value) { return value.stripTrailingZeros().toPlainString(); }

    private static void addFirst(List<String> parts, String label, List<String> values) {
        if (values != null && !values.isEmpty()) add(parts, label, values.get(0));
    }

    private static void add(List<String> parts, String label, String value) {
        if (value != null && !value.trim().isEmpty()) parts.add(label + "：" + value.trim());
    }

    private static String decode(String value) {
        try { return URLDecoder.decode(value, StandardCharsets.UTF_8.name()); }
        catch (Exception ignored) { return value; }
    }

    private static String limit(String value) { return value.length() > 320 ? value.substring(0, 317) + "…" : value; }
}
