USE crop_knowledge;

-- 第二阶段资料经人工确认后，发布导入时标记为 PENDING 的 33 条初始作物。
UPDATE crops
SET review_status = 'APPROVED'
WHERE id BETWEEN 1 AND 33
  AND source_page BETWEEN 1 AND 19
  AND review_status = 'PENDING';
