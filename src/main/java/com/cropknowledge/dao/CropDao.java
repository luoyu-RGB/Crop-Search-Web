package com.cropknowledge.dao;

import com.cropknowledge.config.Database;
import com.cropknowledge.model.Crop;
import com.cropknowledge.model.CropPage;
import com.cropknowledge.model.CropSearch;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CropDao {
    private static final int PAGE_SIZE = 10;

    public List<Crop> findForAdmin(String status, String name) throws SQLException {
        List<Crop> crops = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT c.* FROM crops c WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty() && !"ALL".equals(status)) {
            sql.append(" AND c.review_status = ?");
            params.add(status);
        }
        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND (c.chinese_name LIKE ? OR c.english_name LIKE ? OR c.latin_name LIKE ?)");
            String pattern = "%" + name.trim() + "%";
            params.add(pattern); params.add(pattern); params.add(pattern);
        }
        sql.append(" ORDER BY c.update_time DESC, c.id DESC LIMIT 200");
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            bind(statement, params);
            try (ResultSet result = statement.executeQuery()) { while (result.next()) crops.add(readSummary(result)); }
        }
        return crops;
    }

    public Crop findByIdForAdmin(long id) throws SQLException {
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement("SELECT * FROM crops WHERE id = ?")) {
            statement.setLong(1, id);
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) return null;
                Crop crop = readSummary(result);
                loadRelated(connection, crop);
                return crop;
            }
        }
    }

    public long create(Crop crop) throws SQLException {
        String sql = "INSERT INTO crops (chinese_name, english_name, latin_name, family, genus, features, distribution, cultivation, uses, source_page, review_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bindCrop(statement, crop, false);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) throw new SQLException("No generated crop id");
                long id = keys.getLong(1); logOperation(connection, "CREATE", id, crop.chineseName); return id;
            }
        }
    }

    public void update(Crop crop) throws SQLException {
        String sql = "UPDATE crops SET chinese_name=?, english_name=?, latin_name=?, family=?, genus=?, features=?, distribution=?, cultivation=?, uses=?, source_page=?, review_status=? WHERE id=?";
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            bindCrop(statement, crop, true); statement.setLong(12, crop.id); statement.executeUpdate();
            logOperation(connection, "UPDATE", crop.id, crop.chineseName);
        }
    }

    public void delete(long id) throws SQLException {
        try (Connection connection = Database.getConnection()) {
            String name = null;
            try (PreparedStatement lookup = connection.prepareStatement("SELECT chinese_name FROM crops WHERE id=?")) { lookup.setLong(1, id); try (ResultSet result = lookup.executeQuery()) { if (result.next()) name = result.getString(1); } }
            try (PreparedStatement statement = connection.prepareStatement("DELETE FROM crops WHERE id=?")) { statement.setLong(1, id); statement.executeUpdate(); }
            logOperation(connection, "DELETE", id, name);
        }
    }

    private static void bindCrop(PreparedStatement statement, Crop crop, boolean update) throws SQLException {
        statement.setString(1, crop.chineseName); statement.setString(2, nullable(crop.englishName)); statement.setString(3, nullable(crop.latinName));
        statement.setString(4, nullable(crop.family)); statement.setString(5, nullable(crop.genus)); statement.setString(6, nullable(crop.features));
        statement.setString(7, nullable(crop.distribution)); statement.setString(8, nullable(crop.cultivation)); statement.setString(9, nullable(crop.uses));
        if (crop.sourcePage > 0) statement.setInt(10, crop.sourcePage); else statement.setNull(10, java.sql.Types.INTEGER);
        statement.setString(11, crop.reviewStatus == null ? "DRAFT" : crop.reviewStatus);
    }

    private static String nullable(String value) { return value == null || value.trim().isEmpty() ? null : value.trim(); }

    public void addAlias(long cropId, String alias) throws SQLException {
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement("INSERT INTO crop_aliases (crop_id, alias_name) VALUES (?, ?)")) {
            statement.setLong(1, cropId); statement.setString(2, alias.trim()); statement.executeUpdate(); logOperation(connection, "ADD_ALIAS", cropId, alias);
        }
    }

    public void deleteAlias(long cropId, String alias) throws SQLException {
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement("DELETE FROM crop_aliases WHERE crop_id=? AND alias_name=?")) {
            statement.setLong(1, cropId); statement.setString(2, alias); statement.executeUpdate(); logOperation(connection, "DELETE_ALIAS", cropId, alias);
        }
    }

    public long addSample(long cropId, Crop.Sample sample, Map<String, java.math.BigDecimal> components) throws SQLException {
        try (Connection connection = Database.getConnection()) {
            connection.setAutoCommit(false);
            try {
                String sampleSql = "INSERT INTO crop_samples (crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (?, ?, ?, ?, ?, ?)";
                long sampleId;
                try (PreparedStatement statement = connection.prepareStatement(sampleSql, Statement.RETURN_GENERATED_KEYS)) {
                    statement.setLong(1, cropId); statement.setString(2, nullable(sample.collectionUnit)); statement.setString(3, nullable(sample.testUnit));
                    statement.setString(4, nullable(sample.testPart)); statement.setString(5, nullable(sample.origin)); statement.setString(6, nullable(sample.remark)); statement.executeUpdate();
                    try (ResultSet keys = statement.getGeneratedKeys()) { if (!keys.next()) throw new SQLException("No generated sample id"); sampleId = keys.getLong(1); }
                }
                String oilSql = "INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement statement = connection.prepareStatement(oilSql)) {
                    statement.setLong(1, cropId); statement.setLong(2, sampleId); setDecimal(statement, 3, sample.oilContent); setDecimal(statement, 4, sample.iodineValue); setDecimal(statement, 5, sample.acidValue); setDecimal(statement, 6, sample.saponificationValue); statement.executeUpdate();
                }
                if (components != null && !components.isEmpty()) {
                    String componentSql = "INSERT INTO crop_components (crop_id, sample_id, component_name, component_value) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement statement = connection.prepareStatement(componentSql)) {
                        for (Map.Entry<String, java.math.BigDecimal> entry : components.entrySet()) { statement.setLong(1, cropId); statement.setLong(2, sampleId); statement.setString(3, entry.getKey()); setDecimal(statement, 4, entry.getValue()); statement.addBatch(); }
                        statement.executeBatch();
                    }
                }
                logOperation(connection, "ADD_SAMPLE", cropId, sample.origin); connection.commit(); return sampleId;
            } catch (SQLException ex) { connection.rollback(); throw ex; }
            finally { connection.setAutoCommit(true); }
        }
    }

    private static void setDecimal(PreparedStatement statement, int index, java.math.BigDecimal value) throws SQLException { if (value == null) statement.setNull(index, java.sql.Types.DECIMAL); else statement.setBigDecimal(index, value); }

    public void deleteSample(long cropId, long sampleId) throws SQLException {
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement("DELETE FROM crop_samples WHERE id=? AND crop_id=?")) {
            statement.setLong(1, sampleId); statement.setLong(2, cropId); statement.executeUpdate(); logOperation(connection, "DELETE_SAMPLE", cropId, Long.toString(sampleId));
        }
    }

    public void updateSample(long cropId, long sampleId, Crop.Sample sample, Map<String, java.math.BigDecimal> components) throws SQLException {
        try (Connection connection = Database.getConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement statement = connection.prepareStatement("UPDATE crop_samples SET collection_unit=?, test_unit=?, test_part=?, origin=?, remark=? WHERE id=? AND crop_id=?")) {
                    statement.setString(1, nullable(sample.collectionUnit)); statement.setString(2, nullable(sample.testUnit)); statement.setString(3, nullable(sample.testPart)); statement.setString(4, nullable(sample.origin)); statement.setString(5, nullable(sample.remark)); statement.setLong(6, sampleId); statement.setLong(7, cropId); if (statement.executeUpdate() != 1) throw new SQLException("Sample does not belong to crop");
                }
                try (PreparedStatement statement = connection.prepareStatement("UPDATE crop_oil_data SET oil_content=?, iodine_value=?, acid_value=?, saponification_value=? WHERE crop_id=? AND sample_id=?")) {
                    setDecimal(statement, 1, sample.oilContent); setDecimal(statement, 2, sample.iodineValue); setDecimal(statement, 3, sample.acidValue); setDecimal(statement, 4, sample.saponificationValue); statement.setLong(5, cropId); statement.setLong(6, sampleId); if (statement.executeUpdate() == 0) { try (PreparedStatement insert = connection.prepareStatement("INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value) VALUES (?, ?, ?, ?, ?, ?)")) { insert.setLong(1, cropId); insert.setLong(2, sampleId); setDecimal(insert, 3, sample.oilContent); setDecimal(insert, 4, sample.iodineValue); setDecimal(insert, 5, sample.acidValue); setDecimal(insert, 6, sample.saponificationValue); insert.executeUpdate(); } }
                }
                try (PreparedStatement statement = connection.prepareStatement("DELETE FROM crop_components WHERE crop_id=? AND sample_id=?")) { statement.setLong(1, cropId); statement.setLong(2, sampleId); statement.executeUpdate(); }
                if (components != null && !components.isEmpty()) {
                    try (PreparedStatement statement = connection.prepareStatement("INSERT INTO crop_components (crop_id, sample_id, component_name, component_value) VALUES (?, ?, ?, ?)")) { for (Map.Entry<String, java.math.BigDecimal> entry : components.entrySet()) { statement.setLong(1, cropId); statement.setLong(2, sampleId); statement.setString(3, entry.getKey()); setDecimal(statement, 4, entry.getValue()); statement.addBatch(); } statement.executeBatch(); }
                }
                logOperation(connection, "UPDATE_SAMPLE", cropId, Long.toString(sampleId)); connection.commit();
            } catch (SQLException ex) { connection.rollback(); throw ex; } finally { connection.setAutoCommit(true); }
        }
    }

    public void addImage(long cropId, String path, String title, String type, boolean cover) throws SQLException {
        try (Connection connection = Database.getConnection()) {
            if (cover) try (PreparedStatement clear = connection.prepareStatement("UPDATE crop_images SET is_cover=0 WHERE crop_id=?")) { clear.setLong(1, cropId); clear.executeUpdate(); }
            int sortOrder = 0;
            try (PreparedStatement latest = connection.prepareStatement("SELECT COALESCE(MAX(sort_order), 0) + 1 FROM crop_images WHERE crop_id=?")) { latest.setLong(1, cropId); try (ResultSet result = latest.executeQuery()) { if (result.next()) sortOrder = result.getInt(1); } }
            try (PreparedStatement statement = connection.prepareStatement("INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order) VALUES (?, ?, ?, ?, ?, ?)")) {
                statement.setLong(1, cropId); statement.setString(2, path); statement.setString(3, nullable(title)); statement.setString(4, nullable(type)); statement.setBoolean(5, cover); statement.setInt(6, sortOrder); statement.executeUpdate();
            }
            logOperation(connection, "ADD_IMAGE", cropId, path);
        }
    }

    public void deleteImage(long cropId, long imageId) throws SQLException {
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement("DELETE FROM crop_images WHERE id=? AND crop_id=?")) {
            statement.setLong(1, imageId); statement.setLong(2, cropId); statement.executeUpdate(); logOperation(connection, "DELETE_IMAGE", cropId, Long.toString(imageId));
        }
    }

    public void updateImageTitle(long cropId, long imageId, String title) throws SQLException {
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement("UPDATE crop_images SET image_title=? WHERE id=? AND crop_id=?")) {
            statement.setString(1, nullable(title)); statement.setLong(2, imageId); statement.setLong(3, cropId);
            if (statement.executeUpdate() != 1) throw new SQLException("Image does not belong to crop");
            logOperation(connection, "UPDATE_IMAGE", cropId, title);
        }
    }

    public void setCover(long cropId, long imageId) throws SQLException {
        try (Connection connection = Database.getConnection()) {
            connection.setAutoCommit(false);
            try (PreparedStatement clear = connection.prepareStatement("UPDATE crop_images SET is_cover=0 WHERE crop_id=?"); PreparedStatement set = connection.prepareStatement("UPDATE crop_images SET is_cover=1 WHERE id=? AND crop_id=?")) {
                clear.setLong(1, cropId); clear.executeUpdate(); set.setLong(1, imageId); set.setLong(2, cropId); if (set.executeUpdate() != 1) throw new SQLException("Image does not belong to crop"); logOperation(connection, "SET_COVER", cropId, Long.toString(imageId)); connection.commit();
            } catch (SQLException ex) { connection.rollback(); throw ex; } finally { connection.setAutoCommit(true); }
        }
    }

    private static void logOperation(Connection connection, String action, long cropId, String detail) {
        try (PreparedStatement statement = connection.prepareStatement("INSERT INTO admin_operation_logs (action, crop_id, detail) VALUES (?, ?, ?)")) { statement.setString(1, action); statement.setLong(2, cropId); statement.setString(3, detail); statement.executeUpdate(); } catch (SQLException ignored) { }
    }

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

    /** Finds approved crops explicitly mentioned in the question, including aliases. */
    public List<Crop> findApprovedMentionedIn(String question) throws SQLException {
        List<Crop> crops = new ArrayList<>();
        if (question == null || question.trim().isEmpty()) return crops;
        String sql = "SELECT DISTINCT c.id FROM crops c WHERE c.review_status='APPROVED' AND ("
            + "(CHAR_LENGTH(c.chinese_name)>=2 AND LOCATE(c.chinese_name, ?) > 0) OR "
            + "(CHAR_LENGTH(c.english_name)>=3 AND LOCATE(LOWER(c.english_name), LOWER(?)) > 0) OR "
            + "(CHAR_LENGTH(c.latin_name)>=3 AND LOCATE(LOWER(c.latin_name), LOWER(?)) > 0) OR "
            + "EXISTS (SELECT 1 FROM crop_aliases a WHERE a.crop_id=c.id "
            + "AND CHAR_LENGTH(a.alias_name)>=2 AND LOCATE(a.alias_name, ?) > 0)) LIMIT 5";
        List<Long> ids = new ArrayList<>();
        try (Connection connection = Database.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 1; i <= 4; i++) statement.setString(i, question);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) ids.add(result.getLong(1));
            }
        }
        for (Long id : ids) {
            Crop crop = findById(id, false);
            if (crop != null) crops.add(crop);
        }
        return crops;
    }

    /** Finds approved records for a question about crops in a named province. */
    public List<Crop> findApprovedByLocationMentionedIn(String question) throws SQLException {
        List<Crop> crops = new ArrayList<>();
        if (question == null || !(question.contains("作物") || question.contains("植物")
                || question.contains("品种") || question.contains("种类") || question.contains("哪些"))) return crops;

        try (Connection connection = Database.getConnection()) {
            List<String> provinces = new ArrayList<>();
            String provinceSql = "SELECT DISTINCT p.province FROM crop_distribution_points p "
                + "JOIN crops c ON c.id=p.crop_id WHERE c.review_status='APPROVED' "
                + "AND CHAR_LENGTH(p.province)>=2";
            try (PreparedStatement statement = connection.prepareStatement(provinceSql);
                    ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    String province = result.getString(1);
                    if (question.contains(province)) provinces.add(province);
                }
            }
            if (provinces.isEmpty()) return crops;

            StringBuilder sql = new StringBuilder("SELECT c.* FROM crops c WHERE c.review_status='APPROVED' AND (");
            for (int i = 0; i < provinces.size(); i++) {
                if (i > 0) sql.append(" OR ");
                sql.append("(LOCATE(?, c.distribution)>0 OR EXISTS (SELECT 1 FROM crop_distribution_points p "
                    + "WHERE p.crop_id=c.id AND p.province=?))");
            }
            sql.append(") ORDER BY c.chinese_name, c.id LIMIT 20");
            try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
                int index = 1;
                for (String province : provinces) {
                    statement.setString(index++, province);
                    statement.setString(index++, province);
                }
                try (ResultSet result = statement.executeQuery()) {
                    while (result.next()) crops.add(readSummary(result));
                }
            }
        }
        return crops;
    }

    private void loadRelated(Connection connection, Crop crop) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT alias_name FROM crop_aliases WHERE crop_id = ? ORDER BY id")) {
            statement.setLong(1, crop.id);
            try (ResultSet result = statement.executeQuery()) { while (result.next()) crop.aliases.add(result.getString(1)); }
        }
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT id, image_path, image_title, image_type, is_cover FROM crop_images WHERE crop_id = ? ORDER BY is_cover DESC, sort_order")) {
            statement.setLong(1, crop.id);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) { Crop.Image image = new Crop.Image(); image.id = result.getLong(1); image.path = result.getString(2); image.title = result.getString(3); image.type = result.getString(4); image.cover = result.getBoolean(5); crop.images.add(image); }
            }
        }
        String sampleSql = "SELECT s.id, s.collection_unit, s.test_unit, s.origin, s.test_part, s.remark, o.oil_content, o.iodine_value, o.acid_value, o.saponification_value "
            + "FROM crop_samples s LEFT JOIN crop_oil_data o ON o.sample_id = s.id WHERE s.crop_id = ? ORDER BY s.id";
        try (PreparedStatement statement = connection.prepareStatement(sampleSql)) {
            statement.setLong(1, crop.id);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    Crop.Sample sample = new Crop.Sample(); sample.id = result.getLong(1); sample.collectionUnit = result.getString(2); sample.testUnit = result.getString(3); sample.origin = result.getString(4); sample.testPart = result.getString(5); sample.remark = result.getString(6);
                    sample.oilContent = result.getBigDecimal(7); sample.iodineValue = result.getBigDecimal(8); sample.acidValue = result.getBigDecimal(9); sample.saponificationValue = result.getBigDecimal(10);
                    loadComponents(connection, result.getLong(1), sample); crop.samples.add(sample);
                }
            }
        }
    }

    private void loadComponents(Connection connection, long sampleId, Crop.Sample sample) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement("SELECT id, component_name, component_value FROM crop_components WHERE sample_id = ? ORDER BY id")) {
            statement.setLong(1, sampleId);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) { Crop.Component component = new Crop.Component(); component.id = result.getLong(1); component.name = result.getString(2); component.value = result.getBigDecimal(3); sample.components.add(component); }
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
