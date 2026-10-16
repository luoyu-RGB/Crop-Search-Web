-- Add indexes used by search, detail pages, and sample loading.
USE crop_knowledge;

CREATE TABLE IF NOT EXISTS schema_migrations (
    version VARCHAR(100) PRIMARY KEY,
    applied_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

SET @sql = (SELECT IF(COUNT(*) = 0,
    'ALTER TABLE crops ADD INDEX idx_crops_status_name (review_status, chinese_name, id)', 'SELECT 1')
    FROM information_schema.statistics WHERE table_schema = DATABASE()
    AND table_name = 'crops' AND index_name = 'idx_crops_status_name');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(COUNT(*) = 0,
    'ALTER TABLE crop_samples ADD INDEX idx_sample_crop_id (crop_id, id)', 'SELECT 1')
    FROM information_schema.statistics WHERE table_schema = DATABASE()
    AND table_name = 'crop_samples' AND index_name = 'idx_sample_crop_id');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(COUNT(*) = 0,
    'ALTER TABLE crop_oil_data ADD INDEX idx_oil_crop_sample (crop_id, sample_id)', 'SELECT 1')
    FROM information_schema.statistics WHERE table_schema = DATABASE()
    AND table_name = 'crop_oil_data' AND index_name = 'idx_oil_crop_sample');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(COUNT(*) = 0,
    'ALTER TABLE crop_components ADD INDEX idx_component_sample (sample_id, component_name, component_value)', 'SELECT 1')
    FROM information_schema.statistics WHERE table_schema = DATABASE()
    AND table_name = 'crop_components' AND index_name = 'idx_component_sample');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

INSERT IGNORE INTO schema_migrations(version) VALUES ('002-query-performance');
