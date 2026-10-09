"""把整页扫描图按行/列投影切分为候选区域（正文、数据表、图片），打印每页的横向与纵向投影，
用于确定图片区域的大致边界。"""
import glob
import os

import numpy as np
from PIL import Image

files = sorted(glob.glob(os.path.join('work', 'pages', 'page-*.png')))
only = os.environ.get('ONLY_PAGE')

for f in files:
    page = os.path.splitext(os.path.basename(f))[0]
    if only and page != only:
        continue
    im = Image.open(f).convert('RGB')
    w, h = im.size
    small = im.resize((w // 4, h // 4), Image.BILINEAR)
    a = np.asarray(small).astype(np.int16)
    # “非白”掩码：任一通道明显低于 250
    nonwhite = (a.min(axis=2) < 235)

    rows = nonwhite.mean(axis=1)
    cols = nonwhite.mean(axis=0)
    print(f'=== {page} {w}x{h} (缩略 {small.size}) ===')
    # 压缩打印：每 20 行/列一段的平均值
    def band(arr, step):
        out = []
        for i in range(0, len(arr), step):
            out.append(round(float(arr[i:i + step].mean()), 3))
        return out
    print('row density (step 2%):', band(rows, max(1, len(rows) // 50)))
    print('col density (step 2%):', band(cols, max(1, len(cols) // 50)))
