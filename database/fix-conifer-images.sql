-- Reapply the verified source-page image mapping to existing crops. Idempotent.
USE crop_knowledge;
START TRANSACTION;

-- 银杏
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '银杏') AND (image_path LIKE 'page-02/%' OR image_path LIKE 'page-03/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-02/fig-01.png', '雄球花枝（柔荑花序）', NULL, 0, 1 FROM crops WHERE chinese_name = '银杏';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-02/fig-02.png', '秋季黄叶的植株（大树）', NULL, 1, 2 FROM crops WHERE chinese_name = '银杏';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-03/fig-01.png', '种子（白果）堆放在蓝色布面上', NULL, 0, 3 FROM crops WHERE chinese_name = '银杏';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-03/fig-02.png', '树干与树皮', NULL, 0, 4 FROM crops WHERE chinese_name = '银杏';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-02/fig-03.png', '枝上未成熟种子（绿色白果）', NULL, 0, 5 FROM crops WHERE chinese_name = '银杏';

-- 黄花落叶松
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '黄花落叶松') AND (image_path LIKE 'page-08/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-08/fig-01.png', '雪中枝叶（针叶覆雪）', NULL, 1, 1 FROM crops WHERE chinese_name = '黄花落叶松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-08/fig-02.png', '球果（紫红色）着生枝上', NULL, 0, 2 FROM crops WHERE chinese_name = '黄花落叶松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-08/fig-03.png', '植株全形（树形）', NULL, 0, 3 FROM crops WHERE chinese_name = '黄花落叶松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-08/fig-04.png', '树干与树皮', NULL, 0, 4 FROM crops WHERE chinese_name = '黄花落叶松';

-- 云杉
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '云杉') AND (image_path LIKE 'page-08/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-08/fig-05.png', '枝叶（针叶与枝条）特写', NULL, 1, 1 FROM crops WHERE chinese_name = '云杉';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-08/fig-06.png', '枝与成熟球果（褐色）', NULL, 0, 2 FROM crops WHERE chinese_name = '云杉';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-08/fig-07.png', '树冠（多株云杉）', NULL, 0, 3 FROM crops WHERE chinese_name = '云杉';

-- 鱼鳞云杉
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '鱼鳞云杉') AND (image_path LIKE 'page-09/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-09/fig-01.png', '枝叶与球果', NULL, 1, 1 FROM crops WHERE chinese_name = '鱼鳞云杉';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-09/fig-02.png', '树干与树皮', NULL, 0, 2 FROM crops WHERE chinese_name = '鱼鳞云杉';

-- 红皮云杉
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '红皮云杉') AND (image_path LIKE 'page-09/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-09/fig-03.png', '树干与树皮', NULL, 1, 1 FROM crops WHERE chinese_name = '红皮云杉';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-09/fig-04.png', '植株全形', NULL, 0, 2 FROM crops WHERE chinese_name = '红皮云杉';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-09/fig-05.png', '未成熟球果（绿色）与枝叶', NULL, 0, 3 FROM crops WHERE chinese_name = '红皮云杉';

-- 湿地松
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '湿地松') AND (image_path LIKE 'page-13/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-13/fig-07.png', '针叶与红色芽状结构特写', NULL, 1, 1 FROM crops WHERE chinese_name = '湿地松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-13/fig-08.png', '植株全形与生境', NULL, 0, 2 FROM crops WHERE chinese_name = '湿地松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-13/fig-06.png', '种子（黑色，散放）', NULL, 0, 3 FROM crops WHERE chinese_name = '湿地松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-13/fig-05.png', '球果与针叶枝', NULL, 0, 4 FROM crops WHERE chinese_name = '湿地松';

-- 马尾松
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '马尾松') AND (image_path LIKE 'page-15/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-15/fig-01.png', '枝、针叶与幼球果', NULL, 1, 1 FROM crops WHERE chinese_name = '马尾松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-15/fig-02.png', '成熟球果（开裂）特写', NULL, 0, 2 FROM crops WHERE chinese_name = '马尾松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-15/fig-03.png', '树皮特写（块状剥落）', NULL, 0, 3 FROM crops WHERE chinese_name = '马尾松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-15/fig-04.png', '种子（松子，深褐色）', NULL, 0, 4 FROM crops WHERE chinese_name = '马尾松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-15/fig-05.png', '针叶与黄色雄球花（小孢子叶球）特写', NULL, 0, 5 FROM crops WHERE chinese_name = '马尾松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-15/fig-06.png', '植株全形（大树与山坡）', NULL, 0, 6 FROM crops WHERE chinese_name = '马尾松';

-- 樟子松
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '樟子松') AND (image_path LIKE 'page-17/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-17/fig-01.png', '针叶与幼球果', NULL, 1, 1 FROM crops WHERE chinese_name = '樟子松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-17/fig-02.png', '成熟球果特写', NULL, 0, 2 FROM crops WHERE chinese_name = '樟子松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-17/fig-03.png', '植株全形', NULL, 0, 3 FROM crops WHERE chinese_name = '樟子松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-17/fig-04.png', '树干与树皮', NULL, 0, 4 FROM crops WHERE chinese_name = '樟子松';

-- 油松
DELETE FROM crop_images WHERE crop_id IN (SELECT id FROM crops WHERE chinese_name = '油松') AND (image_path LIKE 'page-17/%');
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-17/fig-05.png', '球果与针叶', NULL, 1, 1 FROM crops WHERE chinese_name = '油松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-17/fig-06.png', '树干与树皮', NULL, 0, 2 FROM crops WHERE chinese_name = '油松';
INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order)
SELECT id, 'page-17/fig-07.png', '松林景观', NULL, 0, 3 FROM crops WHERE chinese_name = '油松';

COMMIT;
