-- 修复第 19 页金钱松、柳杉图片归属（执行一次）
USE crop_knowledge;

-- 金钱松：图 1 枝叶特写，图 2 植株
DELETE FROM crop_images WHERE crop_id = 32;
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
VALUES (32, 'page-19/fig-01.png', '枝叶特写', NULL, 1, 1);
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
VALUES (32, 'page-19/fig-02.png', '植株', NULL, 0, 2);

-- 柳杉：图 3 枝叶与雄球花，图 4 种子
DELETE FROM crop_images WHERE crop_id = 33;
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
VALUES (33, 'page-19/fig-03.png', '枝叶与雄球花', NULL, 1, 1);
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
VALUES (33, 'page-19/fig-04.png', '种子', NULL, 0, 2);
