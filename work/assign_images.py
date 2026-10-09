"""把切分出的图片文件回填到 data/extracted/page-NN.json 的 images 数组。

规则：
1. 保留人工转写的 images 顺序与 isCover（图片描述来自逐页转写）。
2. 按该 JSON 所属物理页的切分结果，为每个作物按声明顺序分配图片文件。
3. 声明多于此页可用图片的，剩余记录保留 `file: null` 并写入 `imageNotes` 说明；
   页面多出的图片写入 `unassignedImages`，不丢弃。

用法：python work/assign_images.py [--dry-run]
"""
import glob
import json
import os
import sys

DRY = '--dry-run' in sys.argv

# 跨页归属的人工指定：{页号: {作物中文名: [图片文件...]}}
# 银杏的表与照片印在物理页 3 顶部，其 JSON 记在 page-02.json，因此需要显式指定。
OVERRIDES = {
    2: {'银杏': ['page-02/fig-01.png', 'page-02/fig-02.png', 'page-03/fig-01.png', 'page-03/fig-02.png']},
    3: {'云南黄果冷杉': ['page-03/fig-03.png', 'page-03/fig-04.png']},
}

with open(os.path.join('data', 'images', 'index.json'), encoding='utf-8') as fh:
    INDEX = json.load(fh)

report = []
for path in sorted(glob.glob(os.path.join('data', 'extracted', 'page-*.json'))):
    with open(path, encoding='utf-8') as fh:
        doc = json.load(fh)
    page = doc['page']
    figures = INDEX.get(f'page-{page:02d}', [])
    crops = doc.get('crops', [])
    if not crops:
        continue

    ordered = [g['file'] for g in sorted(figures, key=lambda g: (g['yRatio'], g['xRatio']))]

    notes = []
    for crop in crops:
        declared = crop.get('images') or []
        # 清理上一次运行追加的补充记录（描述以“补充图片”开头），保证脚本可重复执行
        declared = [i for i in declared if not str(i.get('description') or '').startswith(
            f"{crop.get('chineseName')} 补充图片")]
        # 清理除人工指定外的旧文件分配，避免重复执行后文件错位
        override = (OVERRIDES.get(page) or {}).get(crop.get('chineseName'))
        for img in declared:
            if not override or img.get('file') not in override:
                img['file'] = None
        crop['images'] = declared

    # 已被其它页面引用的文件不再分配
    used_elsewhere = set()
    for other in glob.glob(os.path.join('data', 'extracted', 'page-*.json')):
        if other == path:
            continue
        od = json.load(open(other, encoding='utf-8'))
        for c in od.get('crops', []):
            for img in c.get('images') or []:
                if img.get('file'):
                    used_elsewhere.add(img['file'])

    # 本页 override 已占用的文件
    own_override = set()
    for c in crops:
        ov = (OVERRIDES.get(page) or {}).get(c.get('chineseName')) or []
        own_override.update(ov)

    available = [f for f in ordered if f not in used_elsewhere and f not in own_override]

    for crop in crops:
        declared = crop.get('images') or []
        override = (OVERRIDES.get(page) or {}).get(crop.get('chineseName'))
        if override:
            for img, f in zip(declared, override):
                img['file'] = f
        for img in declared:
            if img.get('file'):
                continue
            if available:
                img['file'] = available.pop(0)
        missing = [i.get('order') for i in declared if not i.get('file')]
        if missing:
            notes.append(f"{crop.get('chineseName')} 第 {missing} 张未找到对应切图，file 置 null")

    doc['imagesAssigned'] = True
    if available:
        # 页面切图多于人工声明的记录：作为补充图片追加到本页最后一个作物，
        # 保证“图片清单 ↔ JSON 引用 ↔ 数据库记录”三者一致。
        target = crops[-1]
        declared = target.setdefault('images', [])
        start_order = max([i.get('order') or 0 for i in declared] or [0])
        for k, f in enumerate(available, start=1):
            declared.append({
                'order': start_order + k,
                'file': f,
                'description': f'{target.get("chineseName")} 补充图片 {k}（描述待补）',
                'isCover': False,
            })
        notes.append(f"补充 {len(available)} 张切图到「{target.get('chineseName')}」：{'、'.join(available)}")
        available = []
    if notes:
        doc['imageNotes'] = notes
    elif 'imageNotes' in doc:
        del doc['imageNotes']

    if not DRY:
        with open(path, 'w', encoding='utf-8') as fh:
            json.dump(doc, fh, ensure_ascii=False, indent=2)

    report.append((page, [(c.get('chineseName'), len(c.get('images') or [])) for c in crops], notes))

for page, crops, notes in report:
    print(f'page {page:>2}: {crops}' + (f'\n          {"; ".join(notes)}' if notes else ''))

nulls = []
for path in sorted(glob.glob(os.path.join('data', 'extracted', 'page-*.json'))):
    doc = json.load(open(path, encoding='utf-8'))
    for crop in doc.get('crops', []):
        for img in crop.get('images') or []:
            if not img.get('file'):
                nulls.append((doc['page'], crop.get('chineseName'), img.get('order'), img.get('description')))
print('\n无对应切图的图片记录:')
for n in nulls:
    print('  ', n)
if not nulls:
    print('   无')
