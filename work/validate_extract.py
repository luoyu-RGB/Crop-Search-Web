"""校验 data/extracted/page-NN.json 是否符合 docs/pdf-extraction-spec.md 的规则。

用法：python work/validate_extract.py
退出码：0 表示全部通过（允许 warning），1 表示存在 error。
"""
import glob
import json
import os
import sys

SPEC_FA_KEYS = ["C12:0", "C14:0", "C16:0", "C16:1", "C18:0", "C18:1", "C18:2", "C18:3", "C20:0", "C20:1"]
TEXT_FIELDS = ["features", "distribution", "cultivation", "uses"]
NUM_FIELDS = ["oilContent", "iodineValue", "acidValue", "saponificationValue"]

errors = []
warnings = []
names = {}
latin_names = {}


def err(page, msg):
    errors.append(f"page {page}: {msg}")


def warn(page, msg):
    warnings.append(f"page {page}: {msg}")


def check_number(page, where, value, lo, hi):
    if value is None:
        return
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        err(page, f"{where} 不是数字: {value!r}")
        return
    if value < lo or value > hi:
        err(page, f"{where} 超出范围 [{lo}, {hi}]: {value}")
    if isinstance(value, float) and round(value, 4) != value:
        warn(page, f"{where} 小数位过多: {value}")


out_dir = os.path.join('data', 'extracted')
files = sorted(glob.glob(os.path.join(out_dir, 'page-*.json')))
if not files:
    print(f'没有找到待校验文件: {out_dir}\\page-NN.json')
    sys.exit(1)

for path in files:
    base = os.path.basename(path)
    page_no = int(base.replace('page-', '').replace('.json', ''))
    with open(path, encoding='utf-8') as fh:
        try:
            doc = json.load(fh)
        except json.JSONDecodeError as exc:
            err(page_no, f'JSON 解析失败: {exc}')
            continue

    if doc.get('page') != page_no:
        err(page_no, f'page 字段与文件名不一致: {doc.get("page")!r}')

    crops = doc.get('crops')
    if not isinstance(crops, list) or not crops:
        err(page_no, 'crops 必须是非空数组')
        continue

    for idx, crop in enumerate(crops):
        tag = f'crop[{idx}]'
        cn = crop.get('chineseName')
        if not cn or not isinstance(cn, str):
            err(page_no, f'{tag} 缺少 chineseName')
            cn = f'<{idx}>'
        else:
            names.setdefault(cn, []).append(page_no)

        latin = crop.get('latinName')
        if latin:
            latin_names.setdefault(latin.strip(), []).append((page_no, cn))

        for field in TEXT_FIELDS:
            val = crop.get(field)
            if val is None:
                warn(page_no, f'{cn} 缺少 {field}')
            elif not isinstance(val, str):
                err(page_no, f'{cn}.{field} 应为字符串或 null')
            elif len(val) < 5:
                warn(page_no, f'{cn}.{field} 过短: {val!r}')

        img = crop.get('images')
        if not isinstance(img, list) or not img:
            warn(page_no, f'{cn} 没有 images 记录')

        chem = crop.get('chemistry')
        if not isinstance(chem, list):
            err(page_no, f'{cn}.chemistry 应为数组')
            continue
        if not chem:
            warn(page_no, f'{cn} 没有 chemistry 数据')
        for r, row in enumerate(chem):
            rtag = f'{cn}.chemistry[{r}]'
            for field in NUM_FIELDS:
                hi = 400 if field == 'saponificationValue' else (300 if field == 'iodineValue' else 100)
                check_number(page_no, f'{rtag}.{field}', row.get(field), 0, hi)
            fa = row.get('fattyAcids')
            if not isinstance(fa, dict):
                err(page_no, f'{rtag}.fattyAcids 缺失或不是对象')
                continue
            missing = [k for k in SPEC_FA_KEYS if k not in fa]
            extra = [k for k in fa if k not in SPEC_FA_KEYS]
            if missing:
                err(page_no, f'{rtag}.fattyAcids 缺少键: {missing}')
            if extra:
                err(page_no, f'{rtag}.fattyAcids 多余键: {extra}')
            for key in SPEC_FA_KEYS:
                check_number(page_no, f'{rtag}.fattyAcids.{key}', fa.get(key), 0, 100)
            if not row.get('testPart'):
                warn(page_no, f'{rtag} 缺少 testPart')
            if not row.get('origin'):
                warn(page_no, f'{rtag} 缺少 origin')

for latin, where in sorted(latin_names.items()):
    if len(where) > 1:
        err(where[0][0], f'拉丁学名重复 {latin}: {where}')

print(f'检查文件数: {len(files)}')
print(f'作物条目数: {sum(len(v) for v in names.values())} 唯一中文名: {len(names)}')
for name, pages in sorted(names.items()):
    print(f'  - {name}: 页 {pages}')

print()
print(f'ERROR {len(errors)} 条')
for line in errors:
    print('  [E] ' + line)
print(f'WARNING {len(warnings)} 条')
for line in warnings:
    print('  [W] ' + line)

sys.exit(1 if errors else 0)
