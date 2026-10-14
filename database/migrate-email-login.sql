-- 将旧版 users 表迁移为“邮箱登录、邮箱唯一、用户名可重复”。
-- 这是一次性迁移。执行 ALTER TABLE 前，请先确认下面两个查询都没有返回需要处理的记录。
USE crop_knowledge;

-- 旧账号如果没有邮箱，或邮箱在规范化（去空格、忽略大小写）后重复，不能安全自动迁移。
SELECT id, username, email
FROM users
WHERE email IS NULL OR TRIM(email) = '';

SELECT LOWER(TRIM(email)) AS normalized_email, COUNT(*) AS account_count,
       GROUP_CONCAT(id ORDER BY id) AS user_ids
FROM users
WHERE email IS NOT NULL AND TRIM(email) <> ''
GROUP BY LOWER(TRIM(email))
HAVING COUNT(*) > 1;

-- 处理完上述异常数据后执行。当前 schema.sql 创建的用户名唯一索引名称为 username。
ALTER TABLE users
    DROP INDEX username,
    MODIFY email VARCHAR(100) NOT NULL,
    ADD CONSTRAINT uq_users_email UNIQUE (email);
