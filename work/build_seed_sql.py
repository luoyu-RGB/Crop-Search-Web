"""把 data/extracted/page-NN.json 转换为数据库初始化 SQL。

输出：
  database/seed-crops.sql      —— crops / crop_aliases / crop_images
  database/seed-chemistry.sql  —— crop_samples / crop_oil_data / crop_components

用法：python work/build_seed_sql.py
"""
import glob
import json
import os
import re

FA_KEYS = ['C12:0', 'C14:0', 'C16:0', 'C16:1', 'C18:0', 'C18:1', 'C18:2', 'C18:3', 'C20:0', 'C20:1']
FA_LABELS = {
    'C12:0': '十二烷酸（月桂酸）',
    'C14:0': '十四烷酸（肉豆蔻酸）',
    'C16:0': '十六烷酸（棕榈酸）',
    'C16:1': '十六碳一烯酸（棕榈油酸）',
    'C18:0': '十八烷酸（硬脂酸）',
    'C18:1': '十八碳一烯酸（油酸）',
    'C18:2': '十八碳二烯酸（亚油酸）',
    'C18:3': '十八碳三烯酸（亚麻酸）',
    'C20:0': '二十烷酸（花生酸）',
    'C20:1': '二十碳一烯酸（花生一烯酸）',
}


def q(value):
    """SQL 字符串字面量；None / 空串 -> NULL。"""
    if value is None:
        return 'NULL'
    text = str(value).strip()
    if not text:
        return 'NULL'
    text = text.replace('\\', '\\\\').replace("'", "''")
    return "'" + text + "'"


def num(value):
    if value is None:
        return 'NULL'
    return repr(float(value))


def comment(value):
    """行尾注释，去掉换行。"""
    if not value:
        return ''
    text = re.sub(r'\s+', ' ', str(value)).strip()
    return f'  -- {text}' if text else ''


crop_sql = [
    '-- 由 work/build_seed_sql.py 依据 data/extracted/*.json 自动生成，请勿手改。',
    '-- 内容来源：《课程设计资料.pdf》（《中国非粮生物柴油植物》）逐页转写。',
    'USE crop_knowledge;',
    '',
    '-- 作物基本信息（review_status 先置 PENDING，人工校对后再改 APPROVED）',
]
chem_sql = [
    '-- 由 work/build_seed_sql.py 依据 data/extracted/*.json 自动生成，请勿手改。',
    'USE crop_knowledge;',
    '',
]

crop_id = 0
counts = {'crops': 0, 'aliases': 0, 'images': 0, 'points': 0, 'samples': 0, 'oil': 0, 'components': 0, 'skipped': 0}
seen_latin = {}

for path in sorted(glob.glob(os.path.join('data', 'extracted', 'page-*.json'))):
    with open(path, encoding='utf-8') as fh:
        doc = json.load(fh)
    page = doc.get('page')
    for crop in doc.get('crops', []):
        name = (crop.get('chineseName') or '').strip()
        if not name:
            counts['skipped'] += 1
            continue
        crop_id += 1
        counts['crops'] += 1

        latin = (crop.get('latinName') or '').strip()
        if latin and latin in seen_latin:
            latin = ''
        elif latin:
            seen_latin[latin] = name

        crop_sql.append(
            'INSERT INTO crops (id, chinese_name, english_name, latin_name, family, genus, '
            'features, distribution, cultivation, uses, source_page, review_status) VALUES ('
            f"{crop_id}, {q(name)}, {q(crop.get('englishName'))}, {q(latin)}, {q(crop.get('family'))}, "
            f"{q(crop.get('genus'))}, {q(crop.get('features'))}, {q(crop.get('distribution'))}, "
            f"{q(crop.get('cultivation'))}, {q(crop.get('uses'))}, {page}, 'PENDING');"
            + comment(f"第{page}页 {latin}")
        )

        alias_text = (crop.get('aliasText') or '').replace('，', '、')
        for alias in [a.strip() for a in alias_text.split('、') if a.strip()]:
            counts['aliases'] += 1
            alias_type = '中文别名' if re.search(r'[\u4e00-\u9fff]', alias) else '外文别名'
            crop_sql.append(
                'INSERT INTO crop_aliases (crop_id, alias_name, alias_type) VALUES ('
                f'{crop_id}, {q(alias)}, {q(alias_type)});'
            )

        image_map = {img.get('order'): img for img in (crop.get('images') or [])}
        for order, img in sorted(image_map.items(), key=lambda kv: (kv[0] is None, kv[0])):
            if not isinstance(order, int):
                continue
            counts['images'] += 1
            crop_sql.append(
                'INSERT INTO crop_images (crop_id, image_path, image_title, image_type, is_cover, sort_order) VALUES ('
                f'{crop_id}, {q(img.get("file"))}, {q(img.get("description"))}, {q(img.get("type"))}, '
                f'{1 if img.get("isCover") else 0}, {order});'
                + comment(f'第{page}页 {img.get("description") or ""}')
            )

        for order, pt in enumerate(crop.get('distributionPoints') or [], start=1):
            counts['points'] += 1
            crop_sql.append(
                'INSERT INTO crop_distribution_points (crop_id, province, locality, latitude, longitude, '
                'altitude, collect_date, collectors, collection_no, sort_order) VALUES ('
                f'{crop_id}, {q(pt.get("province"))}, {q(pt.get("locality"))}, {q(pt.get("latitude"))}, '
                f'{q(pt.get("longitude"))}, {q(pt.get("altitude"))}, {q(pt.get("date"))}, '
                f'{q(pt.get("collectors"))}, {q(pt.get("collectionNo"))}, {order});'
                + comment(f'{name} 第{page}页 {pt.get("province") or ""}{pt.get("locality") or ""}')
            )

        for row in crop.get('chemistry') or []:
            counts['samples'] += 1
            sample_id = counts['samples']
            origin = row.get('origin')
            remark_bits = []
            if row.get('collectionUnit'):
                remark_bits.append('采集单位 ' + str(row['collectionUnit']))
            if row.get('testUnit'):
                remark_bits.append('测试单位 ' + str(row['testUnit']))
            if row.get('testPart'):
                remark_bits.append('测试部位 ' + str(row['testPart']))
            remark = '；'.join(remark_bits)

            chem_sql.append(
                'INSERT INTO crop_samples (id, crop_id, collection_unit, test_unit, test_part, origin, remark) VALUES ('
                f'{sample_id}, {crop_id}, {q(row.get("collectionUnit"))}, {q(row.get("testUnit"))}, '
                f'{q(row.get("testPart"))}, {q(origin)}, {q(remark)});'
                + comment(f'{name} 第{page}页 {origin or ""}')
            )

            counts['oil'] += 1
            chem_sql.append(
                'INSERT INTO crop_oil_data (crop_id, sample_id, oil_content, iodine_value, acid_value, '
                'saponification_value, unit) VALUES ('
                f'{crop_id}, {sample_id}, {num(row.get("oilContent"))}, {num(row.get("iodineValue"))}, '
                f'{num(row.get("acidValue"))}, {num(row.get("saponificationValue"))}, \'%\');'
            )

            fa = row.get('fattyAcids') or {}
            for key in FA_KEYS:
                value = fa.get(key)
                if value is None:
                    continue
                counts['components'] += 1
                chem_sql.append(
                    'INSERT INTO crop_components (crop_id, sample_id, component_name, component_value, unit, remark) VALUES ('
                    f'{crop_id}, {sample_id}, {q(key)}, {num(value)}, \'%\', {q(FA_LABELS.get(key))});'
                )

        crop_sql.append('')
        chem_sql.append('')

with open(os.path.join('database', 'seed-crops.sql'), 'w', encoding='utf-8', newline='\n') as fh:
    fh.write('\n'.join(crop_sql).rstrip() + '\n')
with open(os.path.join('database', 'seed-chemistry.sql'), 'w', encoding='utf-8', newline='\n') as fh:
    fh.write('\n'.join(chem_sql).rstrip() + '\n')

print('统计：' + json.dumps(counts, ensure_ascii=False))
print('已生成 database/seed-crops.sql 与 database/seed-chemistry.sql')
