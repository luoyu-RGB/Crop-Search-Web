CREATE DATABASE IF NOT EXISTS crop_knowledge
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE crop_knowledge;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    real_name VARCHAR(50),
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    email VARCHAR(100),
    status TINYINT NOT NULL DEFAULT 1,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_users_role CHECK (role IN ('USER', 'ADMIN'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS crops (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    chinese_name VARCHAR(100) NOT NULL,
    english_name VARCHAR(150),
    latin_name VARCHAR(200),
    family VARCHAR(100),
    genus VARCHAR(100),
    features TEXT,
    distribution TEXT,
    cultivation TEXT,
    uses TEXT,
    source_page INT,
    review_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_crops_latin_name UNIQUE (latin_name),
    CONSTRAINT ck_crops_review_status CHECK (review_status IN ('DRAFT', 'PENDING', 'APPROVED', 'REJECTED')),
    INDEX idx_crops_chinese_name (chinese_name),
    INDEX idx_crops_family_genus (family, genus),
    INDEX idx_crops_review_status (review_status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS crop_aliases (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    crop_id BIGINT NOT NULL,
    alias_name VARCHAR(100) NOT NULL,
    alias_type VARCHAR(30),
    CONSTRAINT fk_alias_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE,
    UNIQUE KEY uq_crop_alias (crop_id, alias_name),
    INDEX idx_alias_name (alias_name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS crop_samples (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    crop_id BIGINT NOT NULL,
    collection_unit VARCHAR(150),
    test_unit VARCHAR(150),
    test_part VARCHAR(100),
    origin VARCHAR(200),
    remark TEXT,
    CONSTRAINT fk_sample_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE,
    INDEX idx_sample_origin (origin)
) ENGINE=InnoDB;

-- 分布采集点：资料“分布”段落中的逐条采集记录（省、地点、经纬度、海拔、日期、采集人、采集号）
CREATE TABLE IF NOT EXISTS crop_distribution_points (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    crop_id BIGINT NOT NULL,
    province VARCHAR(50),
    locality VARCHAR(200),
    latitude VARCHAR(40),
    longitude VARCHAR(40),
    altitude VARCHAR(40),
    collect_date VARCHAR(40),
    collectors VARCHAR(200),
    collection_no VARCHAR(40),
    sort_order INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_point_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE,
    INDEX idx_point_crop_order (crop_id, sort_order),
    INDEX idx_point_province (province),
    INDEX idx_point_locality (locality)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS crop_oil_data (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    crop_id BIGINT NOT NULL,
    sample_id BIGINT,
    oil_content DECIMAL(10,4),
    iodine_value DECIMAL(10,4),
    acid_value DECIMAL(10,4),
    saponification_value DECIMAL(10,4),
    unit VARCHAR(20) DEFAULT '%',
    remark VARCHAR(255),
    CONSTRAINT fk_oil_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE,
    CONSTRAINT fk_oil_sample FOREIGN KEY (sample_id) REFERENCES crop_samples(id) ON DELETE SET NULL,
    INDEX idx_oil_content (oil_content),
    INDEX idx_iodine_value (iodine_value)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS crop_components (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    crop_id BIGINT NOT NULL,
    sample_id BIGINT,
    component_name VARCHAR(30) NOT NULL,
    component_value DECIMAL(10,4),
    unit VARCHAR(20) DEFAULT '%',
    remark VARCHAR(255),
    CONSTRAINT fk_component_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE,
    CONSTRAINT fk_component_sample FOREIGN KEY (sample_id) REFERENCES crop_samples(id) ON DELETE SET NULL,
    UNIQUE KEY uq_crop_component_sample (crop_id, sample_id, component_name),
    INDEX idx_component_name_value (component_name, component_value)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS crop_images (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    crop_id BIGINT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    image_title VARCHAR(100),
    image_type VARCHAR(30),
    is_cover TINYINT NOT NULL DEFAULT 0,
    sort_order INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_image_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE,
    INDEX idx_image_crop_order (crop_id, sort_order)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS search_records (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    query_text TEXT,
    query_conditions JSON,
    result_count INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_search_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_search_user_time (user_id, create_time)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS admin_operation_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    action VARCHAR(40) NOT NULL,
    crop_id BIGINT,
    detail VARCHAR(255),
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_admin_log_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE SET NULL,
    INDEX idx_admin_log_time (create_time)
) ENGINE=InnoDB;

