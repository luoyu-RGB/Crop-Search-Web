"""检查各页 JSON 的 images 分配情况。"""
import glob
import json
import os

total = 0
nulls = 0
for p in sorted(glob.glob('data/extracted/page-*.json')):
    d = json.load(open(p, encoding='utf-8'))
    line = []
    for c in d.get('crops', []):
        imgs = c.get('images') or []
        for i in imgs:
            total += 1
            if not i.get('file'):
                nulls += 1
        line.append(f"{c['chineseName']}:{[i.get('file') for i in imgs]}")
    print(f"page {d['page']:>2} | " + ' | '.join(line))
print(f'\n图片记录 {total} 条，缺少 file 的 {nulls} 条')
