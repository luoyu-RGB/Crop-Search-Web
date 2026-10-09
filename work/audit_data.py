"""资料一致性审计：检查图片、采集点、SQL 覆盖度与 JSON 之间是否一致。

检查项：
A. 图片一致性：磁盘文件 ↔ data/images/index.json ↔ JSON 引用 ↔ SQL 记录
B. SQL 覆盖度：JSON 中的每个作物/别名/图片/样品/油脂指标/组分是否都进了 SQL
C. 数据完整性：数值、缺失字段、疑似异常值
D. 展示可行性：图片路径、文件大小、单位

用法：python work/audit_data.py
退出码：0 表示无 ERROR，1 表示存在 ERROR。
"""
import glob
import json
import os
import re
import sys

from PIL import Image

ERRORS = []
WARNINGS = []
INFO = []


def err(msg):
    ERRORS.append(msg)


def warn(msg):
    WARNINGS.append(msg)


# ---------- 载入数据 ----------
with open(os.path.join('data', 'images', 'index.json'), encoding='utf-8') as fh:
    INDEX = json.load(fh)

DOCS = {}
for path in sorted(glob.glob(os.path.join('data', 'extracted', 'page-*.json'))):
    with open(path, encoding='utf-8') as fh:
        DOCS[path] = json.load(fh)

# ---------- A. 图片一致性 ----------
disk = set()
for p in glob.glob(os.path.join('data', 'images', 'page-*', '*.png')):
    rel = os.path.relpath(p, 'data/images').replace('\\', '/')
    disk.add(rel)

index_files = {fig['file'] for figs in INDEX.values() for fig in figs}

referenced = []          # (page, crop, order, file)
for path, doc in DOCS.items():
    for crop in doc.get('crops', []):
        for img in crop.get('images') or []:
            referenced.append((doc['page'], crop.get('chineseName'), img.get('order'), img.get('file')))

ref_files = {r[3] for r in referenced if r[3]}

only_disk = disk - index_files
only_index = index_files - disk
INFO.append(f'磁盘图片 {len(disk)} 张，index.json 记录 {len(index_files)} 张，JSON 引用 {len(ref_files)} 张')

if only_disk:
    warn(f'存在于磁盘但未登记在 index.json：{sorted(only_disk)}')
if only_index:
    err(f'index.json 登记但磁盘缺失：{sorted(only_index)}')

for page, crop, order, f in referenced:
    if not f:
        err(f'第 {page} 页 {crop} 第 {order} 张图片没有 file 字段')
    elif not os.path.exists(os.path.join('data', 'images', f)):
        err(f'第 {page} 页 {crop} 第 {order} 张引用文件不存在：{f}')

unreferenced = disk - ref_files
if unreferenced:
    warn(f'切图未被任何作物引用：{sorted(unreferenced)}')

# JSON 中的 unassignedImages 也应与作物 images 引用保持一致；
# 分页归属时若图片已挂到作物但旧标记未清理，会造成校对人员误判。
stale_unassigned = []
for path, doc in DOCS.items():
    for rel in doc.get('unassignedImages') or []:
        if rel in ref_files:
            stale_unassigned.append((doc.get('page'), rel))
if stale_unassigned:
    err(f'unassignedImages 含已被作物引用的图片（需清理旧标记）：{stale_unassigned}')

# 图片尺寸/体积
small, large = [], []
for rel in sorted(disk):
    p = os.path.join('data', 'images', rel)
    size = os.path.getsize(p)
    with Image.open(p) as im:
        w, h = im.size
    if w < 150 or h < 120:
        small.append((rel, w, h))
    if size > 3 * 1024 * 1024:
        large.append((rel, round(size / 1024 / 1024, 2)))
for rel, w, h in small:
    warn(f'图片尺寸偏小，可能不适合展示：{rel} ({w}x{h})')
for rel, mb in large:
    warn(f'图片体积偏大：{rel} ({mb} MB)')

# ---------- B. SQL 覆盖度 ----------
crop_sql = open(os.path.join('database', 'seed-crops.sql'), encoding='utf-8').read()
chem_sql = open(os.path.join('database', 'seed-chemistry.sql'), encoding='utf-8').read()

n_crop_insert = len(re.findall(r'INSERT INTO crops ', crop_sql))
n_alias_insert = len(re.findall(r'INSERT INTO crop_aliases ', crop_sql))
n_image_insert = len(re.findall(r'INSERT INTO crop_images ', crop_sql))
n_sample_insert = len(re.findall(r'INSERT INTO crop_samples ', chem_sql))
n_oil_insert = len(re.findall(r'INSERT INTO crop_oil_data ', chem_sql))
n_comp_insert = len(re.findall(r'INSERT INTO crop_components ', chem_sql))

json_crops = sum(len(d.get('crops', [])) for d in DOCS.values())
json_aliases = 0
json_images = sum(len(c.get('images') or []) for d in DOCS.values() for c in d.get('crops', []))
json_samples = sum(len(c.get('chemistry') or []) for d in DOCS.values() for c in d.get('crops', []))
json_components = 0
for d in DOCS.values():
    for c in d.get('crops', []):
        for row in c.get('chemistry') or []:
            json_components += sum(1 for v in (row.get('fattyAcids') or {}).values() if v is not None)
        alias_text = (c.get('aliasText') or '').replace('，', '、')
        json_aliases += len([a for a in alias_text.split('、') if a.strip()])

pairs = [
    ('作物', json_crops, n_crop_insert),
    ('别名', json_aliases, n_alias_insert),
    ('图片', json_images, n_image_insert),
    ('样品', json_samples, n_sample_insert),
    ('油脂指标', json_samples, n_oil_insert),
    ('化学组分', json_components, n_comp_insert),
]
for name, j, s in pairs:
    if j != s:
        err(f'{name}数量不一致：JSON {j} 条，SQL {s} 条')
    else:
        INFO.append(f'{name}：{j} 条，JSON 与 SQL 一致')

# 采集点是否进入 SQL
json_points = sum(len(c.get('distributionPoints') or []) for d in DOCS.values() for c in d.get('crops', []))
sql_points = len(re.findall(r'INSERT INTO crop_distribution_points ', crop_sql)) + \
    len(re.findall(r'INSERT INTO crop_distribution_points ', chem_sql))
if json_points and sql_points == 0:
    err(f'采集点共 {json_points} 条，但没有任何 SQL 脚本写入（展示时会缺失分布详情）')
elif json_points != sql_points:
    err(f'采集点数量不一致：JSON {json_points} 条，SQL {sql_points} 条')
else:
    INFO.append(f'采集点：{json_points} 条，JSON 与 SQL 一致')

# ---------- C. 数据完整性 ----------
fa_keys = ['C12:0', 'C14:0', 'C16:0', 'C16:1', 'C18:0', 'C18:1', 'C18:2', 'C18:3', 'C20:0', 'C20:1']
sum_issues = 0
for path, doc in DOCS.items():
    page = doc['page']
    for crop in doc.get('crops', []):
        name = crop.get('chineseName')
        for attr in ('features', 'distribution', 'cultivation', 'uses'):
            if not crop.get(attr):
                warn(f'第 {page} 页 {name} 缺少 {attr}')
        for r, row in enumerate(crop.get('chemistry') or []):
            vals = [row.get(k) for k in ('oilContent', 'iodineValue', 'acidValue', 'saponificationValue')]
            if all(v is None for v in vals):
                warn(f'第 {page} 页 {name} 第 {r + 1} 行：油脂指标全部为空，仅保留样品信息')
            fa = row.get('fattyAcids') or {}
            present = [fa.get(k) for k in fa_keys if fa.get(k) is not None]
            if present:
                total = sum(present)
                if total > 100.5 or (len(present) >= 8 and total < 95):
                    sum_issues += 1
                    warn(f'第 {page} 页 {name} 第 {r + 1} 行：脂肪酸合计 {total:.2f}（{len(present)} 项）')
INFO.append(f'脂肪酸合计异常行：{sum_issues} 行（已逐条列出）')

# ---------- D. 展示可行性 ----------
if not os.path.isdir(os.path.join('src', 'main', 'webapp', 'uploads', 'crops')):
    warn('webapp 下还没有 uploads/crops 目录，前台展示图片前需要先把切图复制过去')

# ---------- E. SQL 可执行性（表名/列名与 schema.sql 对照） ----------
schema = open(os.path.join('database', 'schema.sql'), encoding='utf-8').read()
schema_tables = {}
for m in re.finditer(r'CREATE TABLE IF NOT EXISTS (\w+)\s*\((.*?)\n\)\s*ENGINE', schema, re.S):
    table, body = m.group(1), m.group(2)
    cols = set()
    for line in body.splitlines():
        line = line.strip()
        cm = re.match(r'^(\w+)\s+(BIGINT|INT|VARCHAR|TEXT|DECIMAL|DATETIME|TINYINT|JSON|CHAR)', line, re.I)
        if cm and cm.group(1).upper() not in ('CONSTRAINT', 'INDEX', 'UNIQUE', 'PRIMARY', 'KEY'):
            cols.add(cm.group(1))
    schema_tables[table] = cols

for script, text in (('seed-crops.sql', crop_sql), ('seed-chemistry.sql', chem_sql)):
    for m in re.finditer(r'INSERT INTO (\w+)\s*\(([^)]*)\)\s*VALUES', text):
        table = m.group(1)
        cols = [c.strip() for c in m.group(2).split(',')]
        if table not in schema_tables:
            err(f'{script}: 表 {table} 在 schema.sql 中不存在')
            continue
        unknown = [c for c in cols if c not in schema_tables[table]]
        if unknown:
            err(f'{script}: 表 {table} 出现 schema 中不存在的列 {unknown}')
INFO.append(f'SQL 表与列校验完成，涉及 {len(schema_tables)} 张表')

# ---------- 输出 ----------
print('=== 一致性审计 ===')
for line in INFO:
    print('  [i] ' + line)
print(f'\nERROR {len(ERRORS)} 条')
for line in ERRORS:
    print('  [E] ' + line)
print(f'WARNING {len(WARNINGS)} 条')
for line in WARNINGS:
    print('  [W] ' + line)

sys.exit(1 if ERRORS else 0)
