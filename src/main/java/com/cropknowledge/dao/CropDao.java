package com.cropknowledge.dao;

import com.cropknowledge.config.Database;
import com.cropknowledge.model.Crop;
import com.cropknowledge.model.CropPage;
import com.cropknowledge.model.CropSearch;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CropDao {
    private static final int PAGE_SIZE = 10;

    public Map<String, List<String>> filterOptions(boolean includePending) throws SQLException {
        Map<String, List<String>> options = new LinkedHashMap<>();
        String status = includePending ? "c.review_status <> 'REJECTED'" : "c.review_status = 'APPROVED'";
        try (Connection connection = Database.getConnection()) {
            options.put("family", distinctOptions(connection, "SELECT DISTINCT c.family FROM crops c WHERE " + status + " AND c.family IS NOT NULL AND c.family <> '' ORDER BY c.family"));
            options.put("genus", distinctOptions(connection, "SELECT DISTINCT c.genus FROM crops c WHERE " + status + " AND c.genus IS NOT NULL AND c.genus <> '' ORDER BY c.genus"));
            options.put("distribution", distinctOptions(connection, "SELECT DISTINCT p.province FROM crop_distribution_points p JOIN crops c ON c.id = p.crop_id WHERE " + status + " AND p.province IS NOT NULL AND p.province <> '' ORDER BY p.province"));
        }
        options.put("features", Arrays.asList("乔木", "灌木", "常绿", "落叶"));
        options.put("cultivation", Arrays.asList("播种", "扦插", "嫁接", "耐寒", "喜光"));
        options.put("uses", Arrays.asList("食用", "药用", "观赏", "用材"));
        return options;
    }

    private static List<String> distinctOptions(Connection connection, String sql) throws SQLException {
        List<String> values = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql); ResultSet result = statement.executeQuery()) {
            while (result.next()) values.add(result.getString(1));
        }
        return values;
    }

    public CropPage search(CropSearch search) throws SQLException {
        Query query = buildQuery(search, false);
        try (Connection connection = Database.getConnection()) {
            int total;
            try (PreparedStatement statement = connection.prepareStatement(buildQuery(search, true).sql)) {
                bind(statement, query.paramsForCount);
                try (ResultSet result = statement.executeQuery()) {
                    result.next();
                    total = result.getInt(1);
                }
            }
            query.params.add(PAGE_SIZE);
            query.params.add(search.page * PAGE_SIZE - PAGE_SIZE);
            List<Crop> crops = new ArrayList<>();
            try (PreparedStatement statement = connection.prepareStatement(query.sql)) {
                bind(statement, query.params);
                try (ResultSet result = statement.executeQuery()) {
                    while (result.next()) crops.add(readSummary(result));
                }
            }
            return new CropPage(crops, search.page, PAGE_SIZE, total);
        }
    }

    public Crop findById(long id, boolean includePending) throws SQLException {
        String status = includePending ? "c.review_status <> 'REJECTED'" : "c.review_status = 'APPROVED'";
        String sql = "SELECT c.* FROM crops c WHERE c.id = ? AND " + status;
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) return null;
                Crop crop = readSummary(result);
                loadRelated(connection, crop);
                return crop;
            }
        }
    }

    private void loadRelated(Connection connection, Crop crop) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT alias_name FROM crop_aliases WHERE crop_id = ? ORDER BY id")) {
            statement.setLong(1, crop.id);
            try (ResultSet result = statement.executeQuery()) { while (result.next()) crop.aliases.add(result.getString(1)); }
        }
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT image_path, image_title FROM crop_images WHERE crop_id = ? ORDER BY is_cover DESC, sort_order")) {
            statement.setLong(1, crop.id);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) { Crop.Image image = new Crop.Image(); image.path = result.getString(1); image.title = result.getString(2); crop.images.add(image); }
            }
        }
        String sampleSql = "SELECT s.id, s.origin, s.test_part, o.oil_content, o.iodine_value, o.acid_value, o.saponification_value "
            + "FROM crop_samples s LEFT JOIN crop_oil_data o ON o.sample_id = s.id WHERE s.crop_id = ? ORDER BY s.id";
        try (PreparedStatement statement = connection.prepareStatement(sampleSql)) {
            statement.setLong(1, crop.id);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    Crop.Sample sample = new Crop.Sample(); sample.origin = result.getString(2); sample.testPart = result.getString(3);
                    sample.oilContent = result.getBigDecimal(4); sample.iodineValue = result.getBigDecimal(5); sample.acidValue = result.getBigDecimal(6); sample.saponificationValue = result.getBigDecimal(7);
                    loadComponents(connection, result.getLong(1), sample); crop.samples.add(sample);
                }
            }
        }
    }

    private void loadComponents(Connection connection, long sampleId, Crop.Sample sample) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement("SELECT component_name, component_value FROM crop_components WHERE sample_id = ? ORDER BY id")) {
            statement.setLong(1, sampleId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) { Crop.Component component = new Crop.Component(); component.name = result.getString(1); component.value = result.getBigDecimal(2); sample.components.add(component); }
            }
        }
    }

    private Query buildQuery(CropSearch search, boolean count) {
        List<String> nameConditions = new ArrayList<>();
        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String status = search.includePending ? "c.review_status <> 'REJECTED'" : "c.review_status = 'APPROVED'";
        addText(nameConditions, params, search.name, "(c.chinese_name LIKE ? OR c.english_name LIKE ? OR c.latin_name LIKE ? OR EXISTS (SELECT 1 FROM crop_aliases a WHERE a.crop_id = c.id AND a.alias_name LIKE ?))", 4);
        for (CropSearch.TextFilter filter : search.textFilters) {
            switch (filter.field) {
                case "family": addText(conditions, params, filter.value, "c.family LIKE ?", 1); break;
                case "genus": addText(conditions, params, filter.value, "c.genus LIKE ?", 1); break;
                case "features": addText(conditions, params, filter.value, "c.features LIKE ?", 1); break;
                case "distribution": addText(conditions, params, filter.value, "c.distribution LIKE ?", 1); break;
                case "cultivation": addText(conditions, params, filter.value, "c.cultivation LIKE ?", 1); break;
                case "uses": addText(conditions, params, filter.value, "c.uses LIKE ?", 1); break;
                default: throw new IllegalArgumentException("请选择有效的组合查询字段");
            }
        }
        addText(conditions, params, search.family, "c.family LIKE ?", 1);
        addText(conditions, params, search.genus, "c.genus LIKE ?", 1);
        addText(conditions, params, search.features, "c.features LIKE ?", 1);
        addText(conditions, params, search.distribution, "c.distribution LIKE ?", 1);
        addText(conditions, params, search.cultivation, "c.cultivation LIKE ?", 1);
        addText(conditions, params, search.uses, "c.uses LIKE ?", 1);
        if (!search.matchAny) {
            List<String> sampleConditions = new ArrayList<>();
            addBound(sampleConditions, params, "od.oil_content", search.minOil, search.maxOil);
            addBound(sampleConditions, params, "od.iodine_value", search.minIodine, search.maxIodine);
            addBound(sampleConditions, params, "od.acid_value", search.minAcid, search.maxAcid);
            addBound(sampleConditions, params, "od.saponification_value", search.minSaponification, search.maxSaponification);
            if (search.hasComponentCondition()) {
                sampleConditions.add("cc.component_name = ?");
                params.add(search.component);
                addBound(sampleConditions, params, "cc.component_value", search.minComponent, search.maxComponent);
            }
            if (!sampleConditions.isEmpty()) {
                conditions.add("EXISTS (SELECT 1 FROM crop_samples s LEFT JOIN crop_oil_data od ON od.sample_id = s.id "
                    + "LEFT JOIN crop_components cc ON cc.sample_id = s.id WHERE s.crop_id = c.id AND "
                    + String.join(" AND ", sampleConditions) + ")");
            }
        } else {
            addRange(conditions, params, "oil_content", search.minOil, search.maxOil);
            addRange(conditions, params, "iodine_value", search.minIodine, search.maxIodine);
            addRange(conditions, params, "acid_value", search.minAcid, search.maxAcid);
            addRange(conditions, params, "saponification_value", search.minSaponification, search.maxSaponification);
        }
        if (search.matchAny && search.hasComponentCondition()) {
            StringBuilder condition = new StringBuilder("EXISTS (SELECT 1 FROM crop_components cc WHERE cc.crop_id = c.id AND cc.component_name = ?");
            params.add(search.component);
            if (search.minComponent != null) { condition.append(" AND cc.component_value >= ?"); params.add(search.minComponent); }
            if (search.maxComponent != null) { condition.append(" AND cc.component_value <= ?"); params.add(search.maxComponent); }
            conditions.add(condition.append(")").toString());
        }
        StringBuilder sql = new StringBuilder();
        if (count) sql.append("SELECT COUNT(DISTINCT c.id) FROM crops c WHERE ").append(status);
        else sql.append("SELECT c.*, "
            + "(SELECT GROUP_CONCAT(a.alias_name ORDER BY a.id SEPARATOR '、') FROM crop_aliases a WHERE a.crop_id = c.id) AS alias_summary, "
            + "(SELECT MAX(oil_content) FROM crop_oil_data o WHERE o.crop_id = c.id) AS max_oil, "
            + "(SELECT MAX(iodine_value) FROM crop_oil_data o WHERE o.crop_id = c.id) AS max_iodine, "
            + "(SELECT MAX(acid_value) FROM crop_oil_data o WHERE o.crop_id = c.id) AS max_acid, "
            + "(SELECT MAX(saponification_value) FROM crop_oil_data o WHERE o.crop_id = c.id) AS max_saponification, "
            + "(SELECT image_path FROM crop_images i WHERE i.crop_id = c.id ORDER BY i.is_cover DESC, i.sort_order LIMIT 1) AS cover_path "
            + "FROM crops c WHERE ").append(status);
        if (!nameConditions.isEmpty()) sql.append(" AND ").append(nameConditions.get(0));
        if (!conditions.isEmpty()) {
            sql.append(" AND (");
            sql.append(String.join(search.matchAny ? " OR " : " AND ", conditions));
            sql.append(")");
        }
        if (!count) sql.append(" ORDER BY c.chinese_name, c.id LIMIT ? OFFSET ?");
        Query query = new Query(sql.toString(), params);
        query.paramsForCount = new ArrayList<>(params);
        return query;
    }

    private static void addText(List<String> conditions, List<Object> params, String value, String condition, int count) {
        if (value == null || value.isEmpty()) return;
        conditions.add(condition);
        String pattern = "%" + value + "%";
        for (int i = 0; i < count; i++) params.add(pattern);
    }

    private static void addRange(List<String> conditions, List<Object> params, String column, Object min, Object max) {
        if (min == null && max == null) return;
        List<String> bounds = new ArrayList<>();
        addBound(bounds, params, "od." + column, min, max);
        conditions.add("EXISTS (SELECT 1 FROM crop_oil_data od WHERE od.crop_id = c.id AND " + String.join(" AND ", bounds) + ")");
    }

    private static void addBound(List<String> conditions, List<Object> params, String column, Object min, Object max) {
        if (min != null) { conditions.add(column + " >= ?"); params.add(min); }
        if (max != null) { conditions.add(column + " <= ?"); params.add(max); }
    }

    private static Crop readSummary(ResultSet result) throws SQLException {
        Crop crop = new Crop(); crop.id = result.getLong("id"); crop.chineseName = result.getString("chinese_name"); crop.englishName = result.getString("english_name"); crop.latinName = result.getString("latin_name"); crop.family = result.getString("family"); crop.genus = result.getString("genus"); crop.features = result.getString("features"); crop.distribution = result.getString("distribution"); crop.cultivation = result.getString("cultivation"); crop.uses = result.getString("uses"); crop.sourcePage = result.getInt("source_page"); crop.reviewStatus = result.getString("review_status");
        if (hasColumn(result, "max_oil")) crop.maxOilContent = result.getBigDecimal("max_oil");
        if (hasColumn(result, "alias_summary")) crop.aliasSummary = result.getString("alias_summary");
        if (hasColumn(result, "max_iodine")) crop.maxIodineValue = result.getBigDecimal("max_iodine");
        if (hasColumn(result, "max_acid")) crop.maxAcidValue = result.getBigDecimal("max_acid");
        if (hasColumn(result, "max_saponification")) crop.maxSaponificationValue = result.getBigDecimal("max_saponification");
        if (hasColumn(result, "cover_path")) crop.coverPath = result.getString("cover_path");
        return crop;
    }

    private static boolean hasColumn(ResultSet result, String name) throws SQLException {
        for (int i = 1; i <= result.getMetaData().getColumnCount(); i++) {
            if (name.equalsIgnoreCase(result.getMetaData().getColumnLabel(i))) return true;
        }
        return false;
    }

    private static void bind(PreparedStatement statement, List<Object> params) throws SQLException { for (int i = 0; i < params.size(); i++) statement.setObject(i + 1, params.get(i)); }

    private static class Query {
        final String sql; final List<Object> params; List<Object> paramsForCount;
        Query(String sql, List<Object> params) { this.sql = sql; this.params = params; }
    }
}
