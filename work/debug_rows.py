"""生成“照片行判定”的可视化调试图：原始页 + 被判为照片行的行标注。"""
import os
import sys

import numpy as np
from PIL import Image, ImageDraw

LONG_RUN = 10
COLOR_MIN = 28
COLOR_FRAC = 0.06
LONG_FRAC = 0.30


def row_features(mask, sat):
    sh, sw = mask.shape
    color_frac = np.zeros(sh)
    long_frac = np.zeros(sh)
    for y in range(sh):
        row = mask[y]
        ink = int(row.sum())
        if ink == 0:
            continue
        color_frac[y] = float((sat[y][row] > COLOR_MIN).sum()) / ink
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
        long_frac[y] = long_px / float(ink)
    return color_frac, long_frac


for page in sys.argv[1:]:
    im = Image.open(os.path.join('work', 'pages', page + '.png')).convert('RGB')
    w, h = im.size
    small = im.resize((w // 4, h // 4), Image.BILINEAR)
    arr = np.asarray(small).astype(np.int16)
    sw, sh = small.size

    body = arr.copy()
    body[int(sh * 0.888):, :] = 255          # 去掉底部数据表
    mask = body.min(axis=2) < 235
    sat = body.max(axis=2) - body.min(axis=2)

    color_frac, long_frac = row_features(mask, sat)
    photo = (color_frac > COLOR_FRAC) | (long_frac > LONG_FRAC)

    vis = small.copy()
    d = ImageDraw.Draw(vis)
    for y in range(sh):
        if photo[y]:
            d.line([(0, y), (sw - 1, y)], fill=(255, 0, 0))
    vis = vis.resize((sw * 2, sh * 2), Image.NEAREST)
    out = os.path.join('work', 'debug', f'{page}-rows.png')
    os.makedirs(os.path.dirname(out), exist_ok=True)
    vis.save(out)

    # 打印分段摘要
    segs = []
    start = 0
    for y in range(1, sh + 1):
        if y == sh or photo[y] != photo[start]:
            if photo[start] and (y - start) >= 4:
                segs.append((round(start / sh, 3), round((y - 1) / sh, 3)))
            start = y
    print(f'{page}: 照片行段 {segs} -> {out}')
