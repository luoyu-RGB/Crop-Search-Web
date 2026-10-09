"""生成图片区域（连通域）可视化调试图 + 区域坐标清单，用于核对图片归属。"""
import glob
import json
import os

import numpy as np
from PIL import Image, ImageDraw

SCALE = 4
LONG_RUN = 10
COLOR_MIN = 28
COLOR_FRAC = 0.06
LONG_FRAC = 0.30
TABLE_TOP = 0.888
MIN_AREA_RATIO = 0.010
MIN_SIDE_RATIO = 0.10
MIN_FILL_RATIO = 0.45

os.makedirs(os.path.join('work', 'debug'), exist_ok=True)


def label(mask):
    h, w = mask.shape
    parent = {}

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[rb] = ra

    labels = np.zeros((h, w), dtype=np.int32)
    nxt = 0
    for y in range(h):
        row = mask[y]
        for x in range(w):
            if not row[x]:
                continue
            up = labels[y - 1, x] if y > 0 else 0
            left = labels[y, x - 1] if x > 0 else 0
            if up and left:
                labels[y, x] = min(up, left)
                union(up, left)
            elif up or left:
                labels[y, x] = up or left
            else:
                nxt += 1
                labels[y, x] = nxt
                parent[nxt] = nxt
    boxes = {}
    for y in range(h):
        for x in range(w):
            lab = labels[y, x]
            if not lab:
                continue
            root = find(lab)
            if root not in boxes:
                boxes[root] = [x, y, x, y, 0]
            b = boxes[root]
            b[0] = min(b[0], x); b[1] = min(b[1], y)
            b[2] = max(b[2], x); b[3] = max(b[3], y)
            b[4] += 1
    return list(boxes.values())


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
    mask = body.min(axis=2) < 235
    sat = body.max(axis=2) - body.min(axis=2)

    cf = np.zeros(sh); lf = np.zeros(sh)
    for y in range(sh):
        row = mask[y]
        ink = int(row.sum())
        if not ink:
            continue
        cf[y] = float((sat[y][row] > COLOR_MIN).sum()) / ink
        long_px, cur = 0, 0
        for v in row:
            if v:
                cur += 1
            else:
                if cur >= LONG_RUN:
                    long_px += cur
                cur = 0
        if cur >= LONG_RUN:
            long_px += cur
        lf[y] = long_px / float(ink)
    photo_row = (cf > COLOR_FRAC) | (lf > LONG_FRAC)
    photo_mask = mask & photo_row[:, None]

    vis = small.copy()
    d = ImageDraw.Draw(vis)
    regions = []
    for x0, y0, x1, y1, area in sorted(label(photo_mask), key=lambda v: (v[1], v[0])):
        bw, bh = x1 - x0 + 1, y1 - y0 + 1
        if area < MIN_AREA_RATIO * sw * sh:
            continue
        if bw < MIN_SIDE_RATIO * sw or bh < MIN_SIDE_RATIO * sh:
            continue
        if area / float(bw * bh) < MIN_FILL_RATIO:
            continue
        regions.append((x0, y0, x1, y1))
        d.rectangle([x0, y0, x1, y1], outline=(255, 0, 0), width=2)
        d.text((x0 + 3, y0 + 3), str(len(regions)), fill=(255, 0, 0))

    vis.resize((sw * 2, sh * 2), Image.NEAREST).save(os.path.join('work', 'debug', f'{page}-regions.png'))
    summary[page] = [
        {
            'no': i + 1,
            'x': round(x0 / sw, 3), 'y': round(y0 / sh, 3),
            'x2': round((x1 + 1) / sw, 3), 'y2': round((y1 + 1) / sh, 3),
        }
        for i, (x0, y0, x1, y1) in enumerate(regions)
    ]
    print(page, json.dumps(summary[page], ensure_ascii=False))

with open(os.path.join('work', 'debug', 'regions.json'), 'w', encoding='utf-8') as fh:
    json.dump(summary, fh, ensure_ascii=False, indent=2)
