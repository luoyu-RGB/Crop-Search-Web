"""检测每页“红色标题行”的位置（作物标题、特征/分布/栽培/用途等小标题）。

红色标题是判断作物分栏起止的关键锚点：左侧第一段红色标题为该页主作物标题，
右栏出现的红色标题行代表第二个作物标题或第二段小标题。
"""
import glob
import os
import sys

import numpy as np
from PIL import Image

RED_MIN = 90
RED_OVER_G = 45
ROW_RATIO = 0.012

for f in sorted(glob.glob(os.path.join('work', 'pages', 'page-*.png'))):
    page = os.path.splitext(os.path.basename(f))[0]
    if len(sys.argv) > 1 and page not in sys.argv[1:]:
        continue
    im = Image.open(f).convert('RGB')
    w, h = im.size
    small = im.resize((w // 4, h // 4), Image.BILINEAR)
    arr = np.asarray(small).astype(np.int16)
    sh, sw = arr.shape[0], arr.shape[1]
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    red = (r > RED_MIN) & ((r - g) > RED_OVER_G) & ((r - b) > RED_OVER_G)

    left = red[:, : int(sw * 0.56)]
    right = red[:, int(sw * 0.56):]
    print(f'--- {page} ({sw}x{sh}) ---')
    for label, seg in (('L', left), ('R', right)):
        dens = seg.mean(axis=1)
        rows = np.where(dens > ROW_RATIO)[0]
        groups = []
        if len(rows):
            start = rows[0]
            prev = rows[0]
            for y in rows[1:]:
                if y - prev > 6:
                    groups.append((start, prev))
                    start = y
                prev = y
            groups.append((start, prev))
        print(f'  {label}: ' + ', '.join(f'{a / sh:.3f}-{b / sh:.3f}' for a, b in groups))
