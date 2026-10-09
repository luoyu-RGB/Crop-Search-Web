"""按“长墨色连续段占比”区分文字行与照片行，并输出切分结果供验证。"""
import os
import sys

import numpy as np
from PIL import Image

LONG_RUN = 12  # 降采样后的长段阈值（对应原始约 48 像素）


def long_fraction(row):
    total = int(row.sum())
    if total == 0:
        return 0.0
    long_px = 0
    cur = 0
    for v in row:
        if v:
            cur += 1
        else:
            if cur >= LONG_RUN:
                long_px += cur
            cur = 0
    if cur >= LONG_RUN:
        long_px += cur
    return long_px / float(total)


for page in sys.argv[1:]:
    im = Image.open(os.path.join('work', 'pages', page + '.png')).convert('RGB')
    w, h = im.size
    small = im.resize((w // 4, h // 4), Image.BILINEAR)
    arr = np.asarray(small).astype(np.int16)
    mask = arr.min(axis=2) < 235
    sw, sh = small.size
    fr = np.array([long_fraction(mask[y]) for y in range(sh)])
    # 行分类：长段占比高 -> 照片行
    photo = fr > 0.35
    # 打印分段
    print(f'--- {page} {sw}x{sh} ---')
    start = 0
    for y in range(1, sh + 1):
        if y == sh or photo[y] != photo[start]:
            kind = 'PHOTO' if photo[start] else 'text '
            print(f'  {kind} y {start:4d}-{y - 1:4d}  ({start / sh:5.1%}-{y / sh:5.1%})')
            start = y
