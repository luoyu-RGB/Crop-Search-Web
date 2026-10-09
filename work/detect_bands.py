"""按“白色间隔行”把图片区切成独立照片块。

思路：正文文字集中在左栏，右栏基本是纯图片。对右栏（x > 0.56）逐行统计非白像素，
找出非白行的连续段即为照片块；再用同样方法处理左栏内被正文夹住的照片段。
"""
import glob
import json
import os

import numpy as np
from PIL import Image

SCALE = 4
TABLE_TOP = 0.888
WHITE = 240
MIN_ROW_FILL = 0.55      # 行内非白像素占比超过该值视为“有内容”
MIN_H_RATIO = 0.045      # 照片块最小高度占比
MIN_W_RATIO = 0.12       # 照片块最小宽度占比
COL_SPLIT = 0.56
PAD = 4

os.makedirs(os.path.join('work', 'debug'), exist_ok=True)
summary = {}

for f in sorted(glob.glob(os.path.join('work', 'pages', 'page-*.png'))):
    page = os.path.splitext(os.path.basename(f))[0]
    im = Image.open(f).convert('RGB')
    w, h = im.size
    small = im.resize((w // SCALE, h // SCALE), Image.BILINEAR)
    arr = np.asarray(small).astype(np.int16)
    sw, sh = small.size
    body = arr.copy()
    body[int(sh * TABLE_TOP):, :] = 255
    nonwhite = body.min(axis=2) < WHITE

    regions = []
    col_x0 = int(sw * COL_SPLIT)
    col = nonwhite[:, col_x0:]
    fill = col.mean(axis=1)
    rows = fill > MIN_ROW_FILL

    y = 0
    while y < sh:
        if not rows[y]:
            y += 1
            continue
        start = y
        while y < sh and rows[y]:
            y += 1
        end = y - 1
        if (end - start + 1) < MIN_H_RATIO * sh:
            continue
        band = col[start:end + 1, :]
        cols_any = band.any(axis=0)
        xs = np.where(cols_any)[0]
        if len(xs) == 0:
            continue
        x0 = col_x0 + int(xs[0])
        x1 = col_x0 + int(xs[-1])
        if (x1 - x0 + 1) < MIN_W_RATIO * sw:
            continue
        regions.append((x0, start, x1, end, 'R'))

    # 左栏：找出被正文夹住的图片段（行填充率高且非白像素中彩色比例高）
    left = nonwhite[:, :col_x0]
    sat = body.max(axis=2) - body.min(axis=2)
    lfill = left.mean(axis=1)
    color_frac = np.zeros(sh)
    for yy in range(sh):
        row = left[yy]
        ink = int(row.sum())
        if ink:
            color_frac[yy] = float((sat[yy, :col_x0][row] > 30).sum()) / ink
    lrows = (lfill > 0.72) & (color_frac > 0.10)
    y = 0
    while y < sh:
        if not lrows[y]:
            y += 1
            continue
        start = y
        while y < sh and lrows[y]:
            y += 1
        end = y - 1
        if (end - start + 1) < MIN_H_RATIO * sh:
            continue
        band = left[start:end + 1, :]
        xs = np.where(band.any(axis=0))[0]
        if len(xs) == 0:
            continue
        x0, x1 = int(xs[0]), int(xs[-1])
        if (x1 - x0 + 1) < MIN_W_RATIO * sw:
            continue
        regions.append((x0, start, x1, end, 'L'))

    regions.sort(key=lambda r: (r[1], r[0]))

    from PIL import ImageDraw
    vis = small.copy()
    d = ImageDraw.Draw(vis)
    out = []
    for i, (x0, y0, x1, y1, colname) in enumerate(regions, start=1):
        d.rectangle([x0, y0, x1, y1], outline=(255, 0, 0), width=2)
        d.text((x0 + 3, y0 + 3), str(i), fill=(255, 0, 0))
        out.append({'no': i, 'col': colname, 'x': round(x0 / sw, 3), 'y': round(y0 / sh, 3),
                    'x2': round((x1 + 1) / sw, 3), 'y2': round((y1 + 1) / sh, 3)})
    vis.resize((sw * 2, sh * 2), Image.NEAREST).save(os.path.join('work', 'debug', f'{page}-bands.png'))
    summary[page] = out
    print(page, len(regions), json.dumps(out, ensure_ascii=False))

with open(os.path.join('work', 'debug', 'bands.json'), 'w', encoding='utf-8') as fh:
    json.dump(summary, fh, ensure_ascii=False, indent=2)
