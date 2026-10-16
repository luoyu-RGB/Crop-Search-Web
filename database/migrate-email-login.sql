-- Idempotent email-login migration. Run the two preflight queries first and
-- resolve every returned row before applying the constraints.
USE crop_knowledge;

CREATE TABLE IF NOT EXISTS schema_migrations (
    version VARCHAR(100) PRIMARY KEY,
    applied_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

SELECT id, username, email
FROM users
WHERE email IS NULL OR TRIM(email) = '';

SELECT LOWER(TRIM(email)) AS normalized_email, COUNT(*) AS account_count,
       GROUP_CONCAT(id ORDER BY id) AS user_ids
FROM users
WHERE email IS NOT NULL AND TRIM(email) <> ''
GROUP BY LOWER(TRIM(email))
HAVING COUNT(*) > 1;

-- Safe to re-run after the preflight is clean.
SET @drop_username_sql = (
    SELECT IF(COUNT(*) > 0, 'ALTER TABLE users DROP INDEX username', 'SELECT 1')
    FROM information_schema.statistics
    WHERE table_schema = DATABASE() AND table_name = 'users' AND index_name = 'username'
);
PREPARE drop_username FROM @drop_username_sql;
EXECUTE drop_username;
DEALLOCATE PREPARE drop_username;

SET @email_not_null_sql = (
    SELECT IF(COUNT(*) > 0, 'ALTER TABLE users MODIFY email VARCHAR(100) NOT NULL', 'SELECT 1')
    FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'users' AND column_name = 'email'
      AND is_nullable = 'YES'
);
PREPARE email_not_null FROM @email_not_null_sql;
EXECUTE email_not_null;
DEALLOCATE PREPARE email_not_null;

SET @email_unique_sql = (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE users ADD CONSTRAINT uq_users_email UNIQUE (email)', 'SELECT 1')
    FROM information_schema.statistics
    WHERE table_schema = DATABASE() AND table_name = 'users' AND index_name = 'uq_users_email'
);
PREPARE email_unique FROM @email_unique_sql;
EXECUTE email_unique;
DEALLOCATE PREPARE email_unique;

INSERT IGNORE INTO schema_migrations(version) VALUES ('001-email-login');
