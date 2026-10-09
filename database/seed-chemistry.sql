-- 由 work/build_seed_sql.py 依据 data/extracted/*.json 自动生成，请勿手改。
USE crop_knowledge;

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (1, 1, 'GXIB', 'SCBG', '种仁', '广西桂林', '采集单位 GXIB；测试单位 SCBG；测试部位 种仁');  -- 苏铁 第1页 广西桂林
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (1, 1, 10.65, 71.29, 1.25, 234.13, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C14:0', 0.26, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C16:0', 5.38, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C16:1', 0.12, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C18:0', 2.45, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C18:1', 30.36, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C18:2', 50.55, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C18:3', 4.03, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C20:0', 2.31, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 1, 'C20:1', 0.22, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (2, 1, 'JSU', 'SCBG', '种仁', '湖南吉首', '采集单位 JSU；测试单位 SCBG；测试部位 种仁');  -- 苏铁 第1页 湖南吉首
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (1, 2, 6.15, 101.14, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C14:0', 0.1, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C16:0', 6.14, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C16:1', 0.12, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C18:0', 2.46, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C18:1', 46.54, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C18:2', 41.67, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C18:3', 0.83, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C20:0', 0.27, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 2, 'C20:1', 0.21, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (3, 1, 'SCU', 'SCU', '种仁', '四川西昌', '采集单位 SCU；测试单位 SCU；测试部位 种仁');  -- 苏铁 第1页 四川西昌
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (1, 3, 25.32, 105.9, 3.1, 165.9, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 3, 'C16:0', 12.41, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 3, 'C18:0', 3.73, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 3, 'C18:1', 22.35, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 3, 'C18:2', 39.94, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 3, 'C18:3', 21.6, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (4, 1, 'ICS', 'SCBG', '种仁', '湖北兴山', '采集单位 ICS；测试单位 SCBG；测试部位 种仁');  -- 苏铁 第1页 湖北兴山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (1, 4, 7.12, 66.68, 11.38, 310.83, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C12:0', 0.39, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C14:0', 0.0, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C16:0', 5.89, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C16:1', 2.99, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C18:0', 2.8, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C18:1', 21.01, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C18:2', 55.05, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C18:3', 1.04, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C20:0', 28.01, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (1, 4, 'C20:1', 0.44, '%', '二十碳一烯酸（花生一烯酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (5, 2, 'GXIB', 'SCBG', '种仁', '广西桂林', '采集单位 GXIB；测试单位 SCBG；测试部位 种仁');  -- 银杏 第2页 广西桂林
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 5, 23.87, NULL, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 5, 'C16:0', 12.02, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 5, 'C18:0', 1.75, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 5, 'C18:1', 23.6, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 5, 'C18:2', 55.03, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 5, 'C18:3', 1.61, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 5, 'C20:0', 0.54, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 5, 'C20:1', 0.28, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (6, 2, 'HNAU', 'ICS', '种仁', '河南郑州', '采集单位 HNAU；测试单位 ICS；测试部位 种仁');  -- 银杏 第2页 河南郑州
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 6, 4.18, 160.25, 13.82, 132.58, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C14:0', 0.44, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C16:0', 8.91, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C16:1', 3.13, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C18:0', 15.13, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C18:1', 21.04, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C18:2', 39.34, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C18:3', 1.38, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C20:0', 0.47, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 6, 'C20:1', 0.36, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (7, 2, 'ECNU', 'SCBG', '种仁', '江苏徐州', '采集单位 ECNU；测试单位 SCBG；测试部位 种仁');  -- 银杏 第2页 江苏徐州
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 7, 26.89, 21.88, 2.75, 205.38, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C14:0', 0.069, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C16:0', 15.15, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C16:1', 0.7, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C18:0', 1.49, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C18:1', 40.53, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C18:2', 37.66, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C18:3', 1.26, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C20:0', 0.16, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 7, 'C20:1', 0.27, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (8, 2, 'ECNU', 'SCBG', '果实', '安徽宣城', '采集单位 ECNU；测试单位 SCBG；测试部位 果实');  -- 银杏 第2页 安徽宣城
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 8, 20.14, 31.12, 8.67, 173.04, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C14:0', 0.15, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C16:0', 14.76, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C16:1', 0.32, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C18:0', 3.66, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C18:1', 20.0, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C18:2', 50.25, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C18:3', 0.78, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C20:0', 0.48, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 8, 'C20:1', 0.33, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (9, 2, 'SCBG', 'SCBG', '种仁', '安徽黄山', '采集单位 SCBG；测试单位 SCBG；测试部位 种仁');  -- 银杏 第2页 安徽黄山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 9, 3.7, 133.35, 8.11, 188.26, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (10, 2, 'SCU', 'SCU', '种仁', '四川峨边', '采集单位 SCU；测试单位 SCU；测试部位 种仁');  -- 银杏 第2页 四川峨边
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 10, 4.19, NULL, NULL, NULL, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (11, 2, 'WHBG', 'WHBG', '种仁', '湖北房县', '采集单位 WHBG；测试单位 WHBG；测试部位 种仁');  -- 银杏 第2页 湖北房县
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 11, 20.4, NULL, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C14:0', 0.26, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C16:0', 5.38, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C16:1', 0.12, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C18:0', 2.45, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C18:1', 30.36, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C18:2', 50.55, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C18:3', 4.03, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C20:0', 2.31, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 11, 'C20:1', 0.22, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (12, 2, 'WHBG', 'WHBG', '种仁', '湖北竹山', '采集单位 WHBG；测试单位 WHBG；测试部位 种仁');  -- 银杏 第2页 湖北竹山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 12, 0.96, NULL, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 12, 'C16:0', 9.4, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 12, 'C16:1', 3.0, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 12, 'C18:0', 1.8, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 12, 'C18:1', 32.6, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 12, 'C18:2', 42.3, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 12, 'C18:3', 1.9, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 12, 'C20:0', 5.1, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 12, 'C20:1', 1.0, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (13, 2, 'OCRI', 'SCBG', '种仁', '湖北神农架', '采集单位 OCRI；测试单位 SCBG；测试部位 种仁');  -- 银杏 第2页 湖北神农架
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 13, 20.28, 22.24, 7.9, 156.79, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 13, 'C14:0', 0.63, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 13, 'C16:0', 1.96, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 13, 'C16:1', 2.26, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 13, 'C18:0', 3.1, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 13, 'C18:1', 31.32, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 13, 'C18:2', 13.04, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 13, 'C18:3', 0.91, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 13, 'C20:1', 0.46, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (14, 2, 'CAU', 'ICS', '种仁', '陕西佛坪', '采集单位 CAU；测试单位 ICS；测试部位 种仁');  -- 银杏 第2页 陕西佛坪
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 14, 2.93, 122.63, 84.96, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 14, 'C16:0', 5.67, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 14, 'C16:1', 2.09, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 14, 'C18:0', 0.9, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 14, 'C18:1', 13.13, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 14, 'C18:2', 38.51, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 14, 'C18:3', 1.79, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (15, 2, 'SCBG', 'SCBG', '种仁', '北京香山', '采集单位 SCBG；测试单位 SCBG；测试部位 种仁');  -- 银杏 第2页 北京香山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (2, 15, 35.65, 95.1, 11.7, 197.99, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C12:0', 0.024, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C14:0', 0.094, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C16:0', 15.38, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C16:1', 0.11, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C18:0', 6.84, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C18:1', 30.0, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C18:2', 47.02, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C18:3', 0.16, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C20:0', 0.11, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (2, 15, 'C20:1', 0.26, '%', '二十碳一烯酸（花生一烯酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (16, 3, 'WHBG', 'WHBG', '种仁', '云南香格里拉', '采集单位 WHBG；测试单位 WHBG；测试部位 种仁');  -- 云南黄果冷杉 第3页 云南香格里拉
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (3, 16, 23.15, 91.98, NULL, 387.2, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (3, 16, 'C14:0', 0.7, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (3, 16, 'C16:0', 4.68, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (3, 16, 'C16:1', 1.03, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (3, 16, 'C18:0', 1.43, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (3, 16, 'C18:2', 74.23, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (3, 16, 'C18:3', 0.45, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (3, 16, 'C20:0', 0.23, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (3, 16, 'C20:1', 0.38, '%', '二十碳一烯酸（花生一烯酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (17, 4, 'WHBG', 'WHBG', '种仁', '湖北神农架', '采集单位 WHBG；测试单位 WHBG；测试部位 种仁');  -- 巴山冷杉 第4页 湖北神农架
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (4, 17, 4.12, NULL, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 17, 'C16:0', 3.9, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 17, 'C18:0', 1.8, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 17, 'C18:1', 31.4, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 17, 'C18:2', 43.1, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 17, 'C18:3', 12.6, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (18, 4, 'ICS', 'CAU', '种仁', '陕西眉县', '采集单位 ICS；测试单位 CAU；测试部位 种仁');  -- 巴山冷杉 第4页 陕西眉县
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (4, 18, 28.3, 82.04, 46.5, 175.7, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C12:0', 0.35, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C14:0', 0.13, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C16:0', 7.18, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C16:1', 0.11, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C18:0', 3.32, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C18:1', 53.29, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C18:2', 32.56, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C18:3', 0.51, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C20:0', 1.34, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 18, 'C20:1', 1.21, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (19, 4, 'ICS', 'CAU', '种仁', '陕西安康', '采集单位 ICS；测试单位 CAU；测试部位 种仁');  -- 巴山冷杉 第4页 陕西安康
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (4, 19, 3.85, NULL, 79.71, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 19, 'C12:0', 0.14, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 19, 'C16:0', 3.59, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 19, 'C18:0', 1.86, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 19, 'C18:1', 19.11, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 19, 'C18:2', 15.85, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 19, 'C18:3', 4.23, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 19, 'C20:0', 0.79, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (4, 19, 'C20:1', 3.41, '%', '二十碳一烯酸（花生一烯酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (20, 5, 'OFPC', NULL, '种子', '辽宁盖县', '采集单位 OFPC；测试部位 种子');  -- 杉松 第4页 辽宁盖县
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (5, 20, 26.4, 157.7, NULL, 154.4, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (5, 20, 'C16:0', 3.6, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (5, 20, 'C18:0', 1.6, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (5, 20, 'C18:1', 30.2, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (5, 20, 'C18:2', 44.0, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (5, 20, 'C18:3', 0.3, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (21, 6, 'KMIB', 'KMIB', '种仁', '云南丽江', '采集单位 KMIB；测试单位 KMIB；测试部位 种仁');  -- 怒江冷杉 第5页 云南丽江
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (6, 21, 26.62, 148.9, 37.6, 104.4, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (6, 21, 'C16:1', 2.57, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (6, 21, 'C18:0', 0.18, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (6, 21, 'C18:1', 1.45, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (6, 21, 'C18:2', 22.05, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (6, 21, 'C18:3', 35.66, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (6, 21, 'C20:0', 1.12, '%', '二十烷酸（花生酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (22, 7, 'ICS', 'ICS', '种子', '山东诸城', '采集单位 ICS；测试单位 ICS；测试部位 种子');  -- 雪松 第5页 山东诸城
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (7, 22, 35.65, 129.03, 80.45, 183.41, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (7, 22, 'C16:0', 4.52, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (7, 22, 'C16:1', 0.08, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (7, 22, 'C18:0', 2.27, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (7, 22, 'C18:1', 40.27, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (7, 22, 'C18:2', 31.08, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (7, 22, 'C18:3', 7.67, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (7, 22, 'C20:0', 1.86, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (7, 22, 'C20:1', 1.12, '%', '二十碳一烯酸（花生一烯酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (23, 8, 'OFPC', NULL, '种子', '湖北恩施', '采集单位 OFPC；测试部位 种子');  -- 铁坚油杉 第6页 湖北恩施
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (8, 23, 47.9, 123.7, NULL, 184.6, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (8, 23, 'C16:0', 7.3, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (8, 23, 'C18:0', 1.9, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (8, 23, 'C18:1', 50.9, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (8, 23, 'C18:2', 30.2, '%', '十八碳二烯酸（亚油酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (24, 9, 'OFPC', NULL, '种子', '云南昆明', '采集单位 OFPC；测试部位 种子');  -- 云南油杉 第6页 云南昆明
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (9, 24, 59.7, 98.4, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (9, 24, 'C16:0', 9.7, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (9, 24, 'C18:0', 1.9, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (9, 24, 'C18:1', 62.0, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (9, 24, 'C18:2', 25.5, '%', '十八碳二烯酸（亚油酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (25, 10, 'OFPC', NULL, '种子', '广东广州', '采集单位 OFPC；测试部位 种子');  -- 油杉 第7页 广东广州
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (10, 25, 48.4, 154.4, NULL, 164.3, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (10, 25, 'C16:0', 4.7, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (10, 25, 'C18:0', 1.6, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (10, 25, 'C18:1', 51.5, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (10, 25, 'C18:2', 39.2, '%', '十八碳二烯酸（亚油酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (26, 11, 'OCRI', 'SCBG', '种仁', '黑龙江北极村', '采集单位 OCRI；测试单位 SCBG；测试部位 种仁');  -- 落叶松 第7页 黑龙江北极村
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (11, 26, 46.21, 14.19, 1.49, 223.4, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 26, 'C14:0', 71.2, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 26, 'C16:0', 3.87, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 26, 'C18:0', 3.52, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 26, 'C18:1', 13.43, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 26, 'C18:2', 20.46, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 26, 'C18:3', 2.68, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 26, 'C20:0', 0.2, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 26, 'C20:1', 0.0, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (27, 11, 'NEFU', 'SCBG', '种仁', '黑龙江大兴安岭', '采集单位 NEFU；测试单位 SCBG；测试部位 种仁');  -- 落叶松 第7页 黑龙江大兴安岭
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (11, 27, 23.15, 20.51, 9.2, 102.15, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (28, 11, 'OFPC', NULL, '种子', '黑龙江带岭', '采集单位 OFPC；测试部位 种子');  -- 落叶松 第7页 黑龙江带岭
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (11, 28, 18.3, 170.2, NULL, 192.0, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 28, 'C16:0', 3.2, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 28, 'C18:0', 1.4, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 28, 'C18:1', 20.9, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 28, 'C18:2', 45.5, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (11, 28, 'C18:3', 25.6, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (29, 12, 'OFPC', NULL, '种子', '黑龙江伊春', '采集单位 OFPC；测试部位 种子');  -- 黄花落叶松 第8页 黑龙江伊春
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (12, 29, 28.4, 164.3, NULL, 192.0, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (12, 29, 'C16:0', 2.9, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (12, 29, 'C18:0', 1.2, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (12, 29, 'C18:1', 22.4, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (12, 29, 'C18:2', 46.1, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (12, 29, 'C18:3', 23.8, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (30, 13, 'WHBG', 'WHBG', '种仁', '湖北神农架', '采集单位 WHBG；测试单位 WHBG；测试部位 种仁');  -- 云杉 第8页 湖北神农架
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (13, 30, 8.27, NULL, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 30, 'C16:0', 7.5, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 30, 'C18:0', 1.6, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 30, 'C18:1', 26.7, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 30, 'C18:2', 60.9, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 30, 'C18:3', 0.7, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 30, 'C20:0', 1.2, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 30, 'C20:1', 0.9, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (31, 13, 'SAU', 'SCBG', '种仁', '四川若尔盖', '采集单位 SAU；测试单位 SCBG；测试部位 种仁');  -- 云杉 第8页 四川若尔盖
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (13, 31, 13.2, 17.29, 8.75, 189.43, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C14:0', 0.05, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C16:0', 9.23, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C16:1', 0.18, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C18:0', 2.22, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C18:1', 17.47, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C18:2', 69.22, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C18:3', 0.38, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C20:0', 0.09, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 31, 'C20:1', 0.15, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (32, 13, 'SCU', 'SCU', '种仁', '青海祁连', '采集单位 SCU；测试单位 SCU；测试部位 种仁');  -- 云杉 第8页 青海祁连
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (13, 32, 45.29, 78.54, 22.83, 157.43, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C12:0', 0.005, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C14:0', 0.08, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C16:0', 9.88, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C16:1', 0.09, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C18:0', 2.8, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C18:1', 7.64, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C18:2', 77.53, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C18:3', 1.59, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C20:0', 0.26, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 32, 'C20:1', 0.14, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (33, 13, 'OFPC', NULL, '种子', '北京', '采集单位 OFPC；测试部位 种子');  -- 云杉 第8页 北京
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (13, 33, 43.0, 163.3, NULL, 196.3, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 33, 'C16:0', 2.9, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 33, 'C18:0', 1.6, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 33, 'C18:1', 18.6, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 33, 'C18:2', 49.0, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (13, 33, 'C18:3', 25.3, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (34, 14, 'OFPC', NULL, '种子', '吉林通化', '采集单位 OFPC；测试部位 种子');  -- 鱼鳞云杉 第9页 吉林通化
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (14, 34, 44.1, 163.8, NULL, 192.1, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (14, 34, 'C16:0', 2.8, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (14, 34, 'C18:0', 1.4, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (14, 34, 'C18:1', 22.9, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (14, 34, 'C18:2', 50.1, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (14, 34, 'C18:3', 19.1, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (35, 15, 'SBRI', 'SCBG', '种仁', '黑龙江桦川', '采集单位 SBRI；测试单位 SCBG；测试部位 种仁');  -- 红皮云杉 第9页 黑龙江桦川
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (15, 35, 45.83, 62.69, 12.16, 243.23, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C14:0', 0.02, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C16:0', 3.67, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C16:1', 0.03, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C18:0', 0.96, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C18:1', 66.96, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C18:2', 26.97, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C18:3', 1.15, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C20:0', 0.11, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 35, 'C20:1', 0.13, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (36, 15, 'OFPC', NULL, '种子', '黑龙江带岭', '采集单位 OFPC；测试部位 种子');  -- 红皮云杉 第9页 黑龙江带岭
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (15, 36, 39.3, 164.3, NULL, 191.6, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 36, 'C16:0', 3.5, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 36, 'C18:0', 1.9, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 36, 'C18:1', 23.8, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 36, 'C18:2', 47.1, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (15, 36, 'C18:3', 18.5, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (37, 16, 'XIEG', 'SCBG', '种子', '新疆阿勒泰', '采集单位 XIEG；测试单位 SCBG；测试部位 种子');  -- 西伯利亚云杉 第10页 新疆阿勒泰
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (16, 37, 24.43, 33.82, 23.01, 208.6, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C12:0', 0.009, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C14:0', 0.4, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C16:0', 18.13, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C16:1', 0.09, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C18:0', 4.95, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C18:1', 12.09, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C18:2', 18.9, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C18:3', 45.08, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C20:0', 0.24, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 37, 'C20:1', 0.11, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (38, 16, 'OFPC', NULL, '种子', '新疆天山', '采集单位 OFPC；测试部位 种子');  -- 西伯利亚云杉 第10页 新疆天山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (16, 38, 36.7, 166.9, NULL, 187.8, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 38, 'C16:0', 3.1, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 38, 'C18:0', 0.7, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 38, 'C18:1', 24.9, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 38, 'C18:2', 54.7, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (16, 38, 'C18:3', 16.6, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (39, 17, 'WHBG', 'WHBG', '种仁', '湖北神农架', '采集单位 WHBG；测试单位 WHBG；测试部位 种仁');  -- 青扦 第10页 湖北神农架
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (17, 39, 23.48, NULL, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (17, 39, 'C14:0', 0.2, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (17, 39, 'C16:0', 11.17, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (17, 39, 'C16:1', 0.99, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (17, 39, 'C18:0', 2.88, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (17, 39, 'C18:1', 27.83, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (17, 39, 'C18:2', 32.23, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (17, 39, 'C18:3', 15.31, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (17, 39, 'C20:0', 0.43, '%', '二十烷酸（花生酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (40, 18, 'HUST', 'HUST', '种仁', '湖南桑植', '采集单位 HUST；测试单位 HUST；测试部位 种仁');  -- 华山松 第11页 湖南桑植
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 40, 53.3, 13.71, 9.71, 173.27, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 40, 'C14:0', 0.39, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 40, 'C16:0', 19.52, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 40, 'C18:0', 3.02, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 40, 'C18:1', 41.77, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 40, 'C18:2', 24.81, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 40, 'C18:3', 2.3, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 40, 'C20:0', 0.62, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 40, 'C20:1', 0.58, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (41, 18, 'JSU', 'SCBG', '种子', '湖南永顺', '采集单位 JSU；测试单位 SCBG；测试部位 种子');  -- 华山松 第11页 湖南永顺
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 41, 53.54, 156.77, 18.26, 268.15, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C14:0', 0.11, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C16:0', 9.85, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C16:1', 0.09, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C18:0', 5.35, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C18:1', 47.4, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C18:2', 21.55, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C18:3', 0.31, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C20:0', 0.5, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 41, 'C20:1', 0.39, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (42, 18, 'ICS', 'ICS', '种子', '山东泰山', '采集单位 ICS；测试单位 ICS；测试部位 种子');  -- 华山松 第11页 山东泰山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 42, 53.57, 133.33, 12.05, 161.39, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C14:0', 0.06, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C16:0', 4.6, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C16:1', 0.18, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C18:0', 1.97, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C18:1', 23.03, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C18:2', 44.29, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C18:3', 13.4, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C20:0', 0.43, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 42, 'C20:1', 0.94, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (43, 18, 'HNAU', 'ICS', '种子', '河南灵宝', '采集单位 HNAU；测试单位 ICS；测试部位 种子');  -- 华山松 第11页 河南灵宝
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 43, 12.01, 40.39, 34.46, 221.58, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 43, 'C14:0', 0.26, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 43, 'C16:0', 10.76, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 43, 'C16:1', 0.13, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 43, 'C18:0', 4.45, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 43, 'C18:1', 41.3, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 43, 'C18:2', 17.78, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 43, 'C18:3', 0.22, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 43, 'C20:0', 0.92, '%', '二十烷酸（花生酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (44, 18, 'OCRI', 'SCBG', '种仁', '湖北神农架', '采集单位 OCRI；测试单位 SCBG；测试部位 种仁');  -- 华山松 第11页 湖北神农架
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 44, 54.65, 35.08, 34.05, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 44, 'C14:0', 0.03, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 44, 'C16:0', 6.09, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 44, 'C18:0', 1.48, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 44, 'C18:1', 8.52, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 44, 'C18:2', 75.28, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 44, 'C18:3', 7.38, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 44, 'C20:0', 0.26, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 44, 'C20:1', 0.15, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (45, 18, 'OCRI', 'SCBG', '种仁', '湖北神农架', '采集单位 OCRI；测试单位 SCBG；测试部位 种仁');  -- 华山松 第11页 湖北神农架
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 45, 46.8, 42.37, 16.36, 172.18, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 45, 'C16:1', 0.22, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 45, 'C18:0', 4.39, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 45, 'C18:1', 81.35, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 45, 'C18:2', 61.6, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 45, 'C18:3', 23.69, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 45, 'C20:0', 0.61, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 45, 'C20:1', 0.46, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (46, 18, 'WHBG', 'WHBG', '种仁', '湖北神农架', '采集单位 WHBG；测试单位 WHBG；测试部位 种仁');  -- 华山松 第11页 湖北神农架
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 46, 17.6, 122.53, 3.88, 216.94, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C14:0', 0.051, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C16:0', 5.94, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C16:1', 0.06, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C18:0', 2.65, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C18:1', 28.77, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C18:2', 60.39, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C18:3', 0.34, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C20:0', 0.52, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 46, 'C20:1', 1.38, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (47, 18, 'SCU', 'SCBG', '种仁', '四川泸定', '采集单位 SCU；测试单位 SCBG；测试部位 种仁');  -- 华山松 第11页 四川泸定
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 47, 20.16, 88.99, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C12:0', 0.1, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C14:0', 0.56, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C16:0', 4.27, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C16:1', 0.19, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C18:0', 1.36, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C18:1', 70.4, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C18:2', 18.76, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C18:3', 0.66, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C20:0', 0.28, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 47, 'C20:1', 0.15, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (48, 18, 'KMIB', 'KMIB', '种仁', '云南麻栗坡', '采集单位 KMIB；测试单位 KMIB；测试部位 种仁');  -- 华山松 第11页 云南麻栗坡
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 48, 49.83, 157.9, 5.7, 182.6, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 48, 'C18:1', 4.36, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 48, 'C18:2', 0.13, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 48, 'C18:3', 1.81, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 48, 'C20:0', 47.71, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 48, 'C20:1', 19.93, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (49, 18, 'SAU', 'SCBG', '种仁', '西藏波密', '采集单位 SAU；测试单位 SCBG；测试部位 种仁');  -- 华山松 第11页 西藏波密
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 49, NULL, 33.82, 23.01, 208.6, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C12:0', 0.02, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C14:0', 0.39, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C16:0', 29.15, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C16:1', 0.48, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C18:0', 3.31, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C18:1', 21.21, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C18:2', 18.44, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C18:3', 4.78, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C20:0', 0.45, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 49, 'C20:1', 0.02, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (50, 18, 'CAU', 'ICS', '种子', '陕西眉县', '采集单位 CAU；测试单位 ICS；测试部位 种子');  -- 华山松 第11页 陕西眉县
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 50, 54.9, 96.38, 5.44, 148.86, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C14:0', 0.09, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C16:0', 8.9, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C16:1', 0.05, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C18:0', 0.62, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C18:1', 47.38, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C18:2', 39.7, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C18:3', 0.43, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C20:0', 0.77, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 50, 'C20:1', 2.06, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (51, 18, 'OFPC', NULL, '种子', '陕西华山', '采集单位 OFPC；测试部位 种子');  -- 华山松 第11页 陕西华山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (18, 51, 20.9, 157.9, NULL, 189.8, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 51, 'C16:0', 5.1, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 51, 'C18:0', 2.2, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 51, 'C18:1', 23.4, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 51, 'C18:2', 48.1, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (18, 51, 'C18:3', 21.2, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (52, 19, 'OFPC', NULL, '种子', '陕西凤县', '采集单位 OFPC；测试部位 种子');  -- 白皮松 第12页 陕西凤县
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (19, 52, 25.6, 140.2, NULL, 186.8, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (19, 52, 'C16:0', 6.7, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (19, 52, 'C18:0', 2.0, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (19, 52, 'C18:1', 28.2, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (19, 52, 'C18:2', 51.7, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (19, 52, 'C18:3', 11.4, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (53, 20, 'SAU', 'SCBG', '种仁', '四川泸定', '采集单位 SAU；测试单位 SCBG；测试部位 种仁');  -- 高山松 第12页 四川泸定
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (20, 53, 9.86, 15.68, 6.84, 192.45, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C12:0', 0.02, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C14:0', 0.05, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C16:0', 1.65, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C16:1', 0.09, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C18:0', 1.19, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C18:1', 61.86, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C18:2', 31.16, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C18:3', 0.51, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C20:0', 0.1, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 53, 'C20:1', 0.59, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (54, 20, 'KMIB', 'KMIB', '种仁', '云南昆明', '采集单位 KMIB；测试单位 KMIB；测试部位 种仁');  -- 高山松 第12页 云南昆明
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (20, 54, 24.02, 153.0, 3.0, 178.1, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 54, 'C16:1', 2.57, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 54, 'C18:0', 0.18, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 54, 'C18:1', 1.45, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 54, 'C18:2', 22.05, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 54, 'C18:3', 35.66, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (20, 54, 'C20:0', 1.12, '%', '二十烷酸（花生酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (55, 21, 'OFPC', NULL, '种子', '黑龙江哈尔滨', '采集单位 OFPC；测试部位 种子');  -- 赤松 第13页 黑龙江哈尔滨
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (21, 55, 32.7, 160.4, NULL, 189.8, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (21, 55, 'C16:0', 4.3, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (21, 55, 'C18:0', 1.6, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (21, 55, 'C18:1', 22.0, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (21, 55, 'C18:2', 47.0, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (21, 55, 'C18:3', 18.0, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (56, 22, 'SYSU', 'SCBG', '种仁', '江西石城', '采集单位 SYSU；测试单位 SCBG；测试部位 种仁');  -- 湿地松 第13页 江西石城
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (22, 56, 12.77, 84.04, 3.58, 167.12, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C12:0', 0.17, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C14:0', 0.16, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C16:0', 7.32, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C18:0', 2.33, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C18:1', 18.55, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C18:2', 32.48, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C18:3', 9.06, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C20:0', 0.79, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 56, 'C20:1', 0.28, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (57, 22, 'OFPC', NULL, '种子', '广东广州', '采集单位 OFPC；测试部位 种子');  -- 湿地松 第13页 广东广州
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (22, 57, 22.5, 156.1, NULL, 188.4, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 57, 'C16:0', 6.9, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 57, 'C18:0', 2.1, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 57, 'C18:1', 27.4, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 57, 'C18:2', 41.1, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (22, 57, 'C18:3', 17.0, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (58, 23, 'CAU', 'ICS', '种子', '山西翼城', '采集单位 CAU；测试单位 ICS；测试部位 种子');  -- 红松 第14页 山西翼城
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (23, 58, 45.3, 77.13, 2.2, 196.4, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C14:0', 0.08, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C16:0', 9.68, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C16:1', 0.09, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C18:0', 4.69, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C18:1', 30.02, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C18:2', 51.64, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C18:3', 0.46, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C20:0', 1.1, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 58, 'C20:1', 2.22, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (59, 23, 'SBRI', 'SCBG', '种仁', '黑龙江伊春', '采集单位 SBRI；测试单位 SCBG；测试部位 种仁');  -- 红松 第14页 黑龙江伊春
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (23, 59, 46.82, 4.184, 11.91, 263.82, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (60, 23, 'OFPC', NULL, '种子', '辽宁本溪', '采集单位 OFPC；测试部位 种子');  -- 红松 第14页 辽宁本溪
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (23, 60, 69.2, 144.2, NULL, 184.3, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 60, 'C16:0', 6.3, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 60, 'C18:0', 2.0, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 60, 'C18:1', 29.9, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 60, 'C18:2', 51.7, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (23, 60, 'C18:3', 10.0, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (61, 24, 'SCBG', 'SCBG', '种仁', '广东乳源', '采集单位 SCBG；测试单位 SCBG；测试部位 种仁');  -- 华南五针松 第14页 广东乳源
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (24, 61, 28.1, 88.02, 10.58, 277.74, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C12:0', 0.003, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C14:0', 0.03, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C16:0', 3.725, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C16:1', 0.1, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C18:0', 2.09, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C18:1', 35.87, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C18:2', 56.99, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C18:3', 0.2, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C20:0', 0.09, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 61, 'C20:1', 0.92, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (62, 24, 'CIPP', 'SCBG', '种仁', '重庆南川', '采集单位 CIPP；测试单位 SCBG；测试部位 种仁');  -- 华南五针松 第14页 重庆南川
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (24, 62, 46.19, NULL, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 62, 'C16:0', 5.6, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 62, 'C16:1', 0.15, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 62, 'C18:0', 1.17, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 62, 'C18:1', 21.83, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 62, 'C18:2', 27.84, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 62, 'C18:3', 39.31, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 62, 'C20:1', 0.22, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (63, 24, 'OFPC', NULL, '种子', '湖南宜章', '采集单位 OFPC；测试部位 种子');  -- 华南五针松 第14页 湖南宜章
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (24, 63, 35.0, 168.0, NULL, 192.1, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 63, 'C16:0', 4.5, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 63, 'C18:0', 1.8, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 63, 'C18:1', 17.8, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 63, 'C18:2', 44.9, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (24, 63, 'C18:3', 21.2, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (64, 25, 'SCBG', 'SCBG', '种仁', '广东阳山', '采集单位 SCBG；测试单位 SCBG；测试部位 种仁');  -- 马尾松 第15页 广东阳山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (25, 64, 29.4, 91.74, 5.62, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C12:0', 0.05, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C14:0', 0.02, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C16:0', 2.79, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C16:1', 0.05, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C18:0', 7.33, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C18:1', 23.09, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C18:2', 50.9, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C18:3', 0.27, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C20:0', 0.45, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 64, 'C20:1', 0.61, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (65, 25, 'JSU', 'SCBG', '种仁', '湖南保靖', '采集单位 JSU；测试单位 SCBG；测试部位 种仁');  -- 马尾松 第15页 湖南保靖
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (25, 65, 39.45, 91.85, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C14:0', 0.11, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C16:0', 6.66, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C16:1', 0.12, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C18:0', 3.43, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C18:1', 30.96, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C18:2', 52.11, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C18:3', 1.79, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C20:0', 1.04, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 65, 'C20:1', 0.5, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (66, 25, 'OCRI', 'SCBG', '种仁', '湖北鹤峰', '采集单位 OCRI；测试单位 SCBG；测试部位 种仁');  -- 马尾松 第15页 湖北鹤峰
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (25, 66, 46.42, 75.06, 2.51, 239.09, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 66, 'C14:0', 0.08, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 66, 'C16:0', 12.41, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 66, 'C18:0', 7.06, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 66, 'C18:1', 14.71, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 66, 'C18:2', 14.86, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 66, 'C18:3', 37.08, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 66, 'C20:0', 0.95, '%', '二十烷酸（花生酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (67, 25, 'SCU', 'SCU', '种仁', '四川泸定', '采集单位 SCU；测试单位 SCU；测试部位 种仁');  -- 马尾松 第15页 四川泸定
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (25, 67, NULL, NULL, NULL, NULL, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (68, 25, 'SCU', 'SCU', '种仁', '四川雅安', '采集单位 SCU；测试单位 SCU；测试部位 种仁');  -- 马尾松 第15页 四川雅安
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (25, 68, 30.88, 156.77, NULL, NULL, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (69, 25, 'OFPC', NULL, '种子', '广东乐昌', '采集单位 OFPC；测试部位 种子');  -- 马尾松 第15页 广东乐昌
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (25, 69, 27.1, 156.3, NULL, 190.8, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 69, 'C16:0', 3.6, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 69, 'C18:0', 1.9, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 69, 'C18:1', 19.6, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 69, 'C18:2', 47.5, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (25, 69, 'C18:3', 23.8, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (70, 26, 'SYSU', 'SCBG', '种仁', '江西铅山', '采集单位 SYSU；测试单位 SCBG；测试部位 种仁');  -- 台湾五针松 第16页 江西铅山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (26, 70, 10.61, 117.62, 2.48, 170.72, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C12:0', 0.04, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C14:0', 0.13, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C16:0', 6.27, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C16:1', 0.85, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C18:0', 1.43, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C18:1', 43.12, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C18:2', 40.21, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C18:3', 1.58, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C20:0', 0.17, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 70, 'C20:1', 0.12, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (71, 26, 'OFPC', NULL, '种子', '江西庐山', '采集单位 OFPC；测试部位 种子');  -- 台湾五针松 第16页 江西庐山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (26, 71, 22.4, 151.0, NULL, 158.0, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 71, 'C16:0', 4.6, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 71, 'C18:0', 1.9, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 71, 'C18:1', 18.8, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 71, 'C18:2', 47.0, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (26, 71, 'C20:0', 20.5, '%', '二十烷酸（花生酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (72, 27, 'XIEG', 'SCBG', '种仁', '新疆阿勒泰', '采集单位 XIEG；测试单位 SCBG；测试部位 种仁');  -- 新疆五针松 第16页 新疆阿勒泰
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (27, 72, 59.14, 110.6, 3.74, 194.02, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C12:0', 0.019, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C14:0', 0.036, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C16:0', 5.41, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C18:0', 3.31, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C18:1', 29.38, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C18:2', 59.3, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C18:3', 0.31, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C20:0', 0.4, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 72, 'C20:1', 1.84, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (73, 27, 'XIEG', 'SCBG', '种子', '新疆阿勒泰', '采集单位 XIEG；测试单位 SCBG；测试部位 种子');  -- 新疆五针松 第16页 新疆阿勒泰
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (27, 73, 35.24, 4.57, 9.15, 232.97, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C14:0', 0.025, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C16:0', 6.41, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C16:1', 0.09, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C18:0', 2.65, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C18:1', 17.61, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C18:2', 8.99, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C18:3', 63.59, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C20:0', 0.39, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (27, 73, 'C20:1', 0.25, '%', '二十碳一烯酸（花生一烯酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (74, 28, 'NEFU', 'SCBG', '种仁', '内蒙古额尔古纳', '采集单位 NEFU；测试单位 SCBG；测试部位 种仁');  -- 樟子松 第17页 内蒙古额尔古纳
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (28, 74, 21.03, 70.76, 5.87, 186.36, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (75, 28, 'NEFU', 'SCBG', '种仁', '黑龙江塔河', '采集单位 NEFU；测试单位 SCBG；测试部位 种仁');  -- 樟子松 第17页 黑龙江塔河
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (28, 75, 36.7, 4.46, 9.73, 132.92, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C14:0', 0.058, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C16:0', 8.47, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C16:1', 0.05, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C18:0', 1.39, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C18:1', 48.49, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C18:2', 38.05, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C18:3', 0.35, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C20:0', 0.58, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 75, 'C20:1', 2.57, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (76, 28, 'SBRI', 'SCBG', '种仁', '黑龙江桦川', '采集单位 SBRI；测试单位 SCBG；测试部位 种仁');  -- 樟子松 第17页 黑龙江桦川
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (28, 76, 43.5, 9.33, 8.12, 90.79, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (77, 28, 'OFPC', NULL, '种子', '辽宁樟武', '采集单位 OFPC；测试部位 种子');  -- 樟子松 第17页 辽宁樟武
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (28, 77, 28.1, 164.5, NULL, 164.5, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 77, 'C16:0', 2.8, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 77, 'C18:0', 1.5, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 77, 'C18:1', 17.6, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 77, 'C18:2', 49.5, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (28, 77, 'C18:3', 19.8, '%', '十八碳三烯酸（亚麻酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (78, 29, 'SCU', 'SCBG', '种仁', '四川若尔盖', '采集单位 SCU；测试单位 SCBG；测试部位 种仁');  -- 油松 第17页 四川若尔盖
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (29, 78, 7.38, 3.54, 12.67, 137.66, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C14:0', 0.046, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C16:0', 6.56, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C16:1', 0.056, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C18:0', 1.93, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C18:1', 15.97, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C18:2', 13.31, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C18:3', 56.9, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C20:0', 0.32, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 78, 'C20:1', 0.16, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (79, 29, 'HNUST', 'ICS', '种子', '河北昌黎', '采集单位 HNUST；测试单位 ICS；测试部位 种子');  -- 油松 第17页 河北昌黎
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (29, 79, 31.06, 77.52, 6.26, 204.64, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C14:0', 0.05, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C16:0', 4.98, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C16:1', 0.15, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C18:0', 2.07, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C18:1', 20.18, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C18:2', 43.49, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C18:3', 17.69, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C20:0', 0.25, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (29, 79, 'C20:1', 0.73, '%', '二十碳一烯酸（花生一烯酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (80, 30, 'OFPC', NULL, '种子', '江苏南京', '采集单位 OFPC；测试部位 种子');  -- 黑松 第18页 江苏南京
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (30, 80, 30.6, 152.4, NULL, 193.9, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (30, 80, 'C16:0', 12.5, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (30, 80, 'C18:0', 5.3, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (30, 80, 'C18:1', 37.9, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (30, 80, 'C18:2', 27.3, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (30, 80, 'C18:3', 0.5, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (30, 80, 'C20:0', 3.9, '%', '二十烷酸（花生酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (81, 31, 'SAU', 'SCBG', '种仁', '四川泸定', '采集单位 SAU；测试单位 SCBG；测试部位 种仁');  -- 云南松 第18页 四川泸定
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (31, 81, 19.34, 4.57, 9.15, 232.97, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C14:0', 0.67, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C16:0', 5.51, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C16:1', 0.03, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C18:0', 1.87, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C18:1', 30.13, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C18:2', 43.5, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C18:3', 0.48, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C20:0', 0.22, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 81, 'C20:1', 7.07, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (82, 31, 'SCU', 'SCU', '种仁', '四川盐源', '采集单位 SCU；测试单位 SCU；测试部位 种仁');  -- 云南松 第18页 四川盐源
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (31, 82, 48.76, 115.2, 3.8, 157.2, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 82, 'C16:0', 8.78, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 82, 'C18:0', 2.27, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 82, 'C18:1', 21.22, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 82, 'C18:2', 47.01, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 82, 'C18:3', 20.03, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 82, 'C20:0', 0.69, '%', '二十烷酸（花生酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (83, 31, 'KMIB', 'KMIB', '种仁', '云南昆明', '采集单位 KMIB；测试单位 KMIB；测试部位 种仁');  -- 云南松 第18页 云南昆明
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (31, 83, 21.69, 141.4, 7.5, 169.8, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 83, 'C16:1', 3.68, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 83, 'C18:0', 0.24, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 83, 'C18:1', 1.55, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 83, 'C18:2', 17.92, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 83, 'C18:3', 43.56, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (31, 83, 'C20:0', 1.23, '%', '二十烷酸（花生酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (84, 32, 'SYSU', 'SCBG', '种仁', '江西吉安', '采集单位 SYSU；测试单位 SCBG；测试部位 种仁');  -- 金钱松 第19页 江西吉安
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (32, 84, 31.04, 150.02, 2.65, 177.87, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C12:0', 0.09, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C14:0', 0.23, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C16:0', 21.07, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C16:1', 0.8, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C18:0', 2.2, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C18:1', 44.44, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C18:2', 16.81, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C18:3', 9.9, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C20:0', 0.2, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 84, 'C20:1', 0.15, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (85, 32, 'OFPC', NULL, '种子', '湖北恩施', '采集单位 OFPC；测试部位 种子');  -- 金钱松 第19页 湖北恩施
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (32, 85, 43.9, 163.4, NULL, 150.2, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 85, 'C16:0', 8.2, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 85, 'C18:1', 29.5, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (32, 85, 'C18:2', 33.8, '%', '十八碳二烯酸（亚油酸）');

INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (86, 33, 'JSU', 'SCBG', '种仁', '湖南永顺', '采集单位 JSU；测试单位 SCBG；测试部位 种仁');  -- 柳杉 第19页 湖南永顺
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (33, 86, 42.02, 120.98, 4.72, 191.83, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C12:0', 0.0, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C14:0', 0.28, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C16:0', 4.4, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C16:1', 0.34, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C18:0', 76.78, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C18:1', 18.16, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C18:2', 0.047, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C18:3', 0.24, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C20:0', 0.0, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 86, 'C20:1', 0.0, '%', '二十碳一烯酸（花生一烯酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (87, 33, 'SCU', 'SCU', '种仁', '四川宜宾', '采集单位 SCU；测试单位 SCU；测试部位 种仁');  -- 柳杉 第19页 四川宜宾
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (33, 87, 6.93, NULL, NULL, NULL, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (88, 33, 'SCU', 'SCU', '果实', '四川雅安', '采集单位 SCU；测试单位 SCU；测试部位 果实');  -- 柳杉 第19页 四川雅安
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (33, 88, 9.12, NULL, NULL, NULL, '%');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (89, 33, 'SCU', 'SCU', '种仁', '四川峨眉山', '采集单位 SCU；测试单位 SCU；测试部位 种仁');  -- 柳杉 第19页 四川峨眉山
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (33, 89, 16.27, NULL, NULL, NULL, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 89, 'C16:0', 6.95, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 89, 'C18:0', 9.78, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 89, 'C18:1', 34.29, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 89, 'C18:2', 48.99, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (90, 33, 'HNAU', 'ICS', '种仁', '河南信阳', '采集单位 HNAU；测试单位 ICS；测试部位 种仁');  -- 柳杉 第19页 河南信阳
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (33, 90, 6.43, 95.94, 88.31, 68.41, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C12:0', 2.07, '%', '十二烷酸（月桂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C14:0', 0.7, '%', '十四烷酸（肉豆蔻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C16:0', 6.8, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C16:1', 1.39, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C18:0', 1.64, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C18:1', 12.1, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C18:2', 12.63, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C18:3', 3.63, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 90, 'C20:0', 10.78, '%', '二十烷酸（花生酸）');
INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES (91, 33, 'OCRI', 'SCBG', '种仁', '湖北神农架', '采集单位 OCRI；测试单位 SCBG；测试部位 种仁');  -- 柳杉 第19页 湖北神农架
INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, saponification_value, unit) VALUES (33, 91, 12.66, 38.36, 0.69, 396.81, '%');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 91, 'C16:0', 7.57, '%', '十六烷酸（棕榈酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 91, 'C16:1', 0.06, '%', '十六碳一烯酸（棕榈油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 91, 'C18:0', 1.84, '%', '十八烷酸（硬脂酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 91, 'C18:1', 11.81, '%', '十八碳一烯酸（油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 91, 'C18:2', 53.6, '%', '十八碳二烯酸（亚油酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 91, 'C18:3', 32.54, '%', '十八碳三烯酸（亚麻酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 91, 'C20:0', 0.3, '%', '二十烷酸（花生酸）');
INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES (33, 91, 'C20:1', 0.29, '%', '二十碳一烯酸（花生一烯酸）');
