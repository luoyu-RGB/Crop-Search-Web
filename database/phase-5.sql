USE crop_knowledge;

CREATE TABLE IF NOT EXISTS admin_operation_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    action VARCHAR(40) NOT NULL,
    crop_id BIGINT,
    detail VARCHAR(255),
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_admin_log_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE SET NULL,
    INDEX idx_admin_log_time (create_time)
) ENGINE=InnoDB;
