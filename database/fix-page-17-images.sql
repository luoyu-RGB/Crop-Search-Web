-- Correct only page-17/fig-04.png: it belongs to Scots pine (樟子松).
USE crop_knowledge;
START TRANSACTION;
UPDATE crop_images
SET crop_id = (SELECT id FROM crops WHERE chinese_name = '樟子松'),
    image_title = '树干与树皮',
    is_cover = 0,
    sort_order = 4
WHERE crop_id = (SELECT id FROM crops WHERE chinese_name = '油松')
  AND image_path = 'page-17/fig-04.png';
UPDATE crop_images
SET sort_order = CASE image_path WHEN 'page-17/fig-05.png' THEN 1 WHEN 'page-17/fig-06.png' THEN 2 ELSE 3 END,
    is_cover = CASE WHEN image_path = 'page-17/fig-05.png' THEN 1 ELSE 0 END
WHERE crop_id = (SELECT id FROM crops WHERE chinese_name = '油松')
  AND image_path IN ('page-17/fig-05.png','page-17/fig-06.png','page-17/fig-07.png');
COMMIT;
