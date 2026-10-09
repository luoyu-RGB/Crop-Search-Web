"""最终版图片切分。

流程：
1. 按“照片行”（行内彩色像素占比高或存在长墨色连续段）与非白像素得到照片掩码。
2. 连通域标记得到照片块，按面积/边长/填充率过滤掉表格与文字。
3. 对每个照片块递归切分：若块内存在整行或整列的空白缝，则沿缝拆成多张照片。
4. 裁剪保存为 data/images/page-NN/fig-MM.png，并输出 data/images/index.json。

输出同时生成调试图 work/debug/page-NN-final.png。
"""
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
MIN_AREA_RATIO = 0.005
MIN_SIDE_RATIO = 0.06
MIN_FILL_RATIO = 0.40
MIN_FIG_W_RATIO = 0.08     # 切分后单张照片最小宽度
MIN_FIG_H_RATIO = 0.012    # 切分后单张照片最小高度
GAP_MERGE_RATIO = 0.002    # 缝隙宽度小于该比例时不做切分（避免切开照片内部白缝）
GAP_FILL = 0.012           # 空白缝判定：该行/列非白像素占比低于此值

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


def split_partial(mask, x0, y0, x1, y1, sw, sh, depth=0):
    """同一行内左右两张照片高度不一致时，整行不会是空白缝；
    这里检查「内部空白缝」：行内非白像素只集中在图块两侧边缘（各自属于左右两张照片）。"""
    if depth > 3:
        return [(x0, y0, x1, y1)]
    bw = x1 - x0 + 1
    if bw < 2 * MIN_FIG_W_RATIO * sw:
        return [(x0, y0, x1, y1)]
    inner0 = x0 + int(bw * 0.08)
    inner1 = x1 - int(bw * 0.08)
    if inner1 <= inner0:
        return [(x0, y0, x1, y1)]
    inner = mask[y0:y1 + 1, inner0:inner1 + 1]
    fill = inner.mean(axis=1)

    gaps = []
    i = 0
    n = len(fill)
    min_gap = max(2, int(GAP_MERGE_RATIO * sh))
    while i < n:
        if fill[i] < GAP_FILL:
            s = i
            while i < n and fill[i] < GAP_FILL:
                i += 1
            if (i - s) >= min_gap:
                gaps.append((s, i - 1))
        else:
            i += 1

    for (g0, g1) in gaps:
        if g0 == 0 or g1 == n - 1:
            continue
        if g0 >= MIN_FIG_H_RATIO * sh and (n - g1 - 1) >= MIN_FIG_H_RATIO * sh:
            out = []
            out += split_box(mask, x0, y0, x1, y0 + g0 - 1, sw, sh, depth + 1)
            out += split_box(mask, x0, y0 + g1 + 1, x1, y1, sw, sh, depth + 1)
            return out
    return [(x0, y0, x1, y1)]


def split_box(mask, x0, y0, x1, y1, sw, sh, depth=0):
    """在框内沿空白缝递归切分，返回若干子框。"""
    if depth > 3:
        return [(x0, y0, x1, y1)]
    sub = mask[y0:y1 + 1, x0:x1 + 1]
    rows = sub.mean(axis=1)
    cols = sub.mean(axis=0)

    def gaps(fill, min_gap):
        res = []
        i = 0
        n = len(fill)
        while i < n:
            if fill[i] < GAP_FILL:
                s = i
                while i < n and fill[i] < GAP_FILL:
                    i += 1
                if (i - s) >= min_gap:
                    res.append((s, i - 1))
            else:
                i += 1
        return res

    min_gap = max(2, int(GAP_MERGE_RATIO * sw))

    # 先按行缝切（阈值按本块高度计算，避免大块内的上下两张照片切不开）
    min_h = max(2, int(0.05 * (y1 - y0 + 1)))
    for (g0, g1) in gaps(rows, min_gap):
        if g0 == 0 or g1 == len(rows) - 1:
            continue
        top_h = g0
        bot_h = len(rows) - g1 - 1
        if top_h >= min_h and bot_h >= min_h:
            out = []
            out += split_box(mask, x0, y0, x1, y0 + g0 - 1, sw, sh, depth + 1)
            out += split_box(mask, x0, y0 + g1 + 1, x1, y1, sw, sh, depth + 1)
            return out

    # 再按列缝切
    min_w = max(2, int(0.05 * (x1 - x0 + 1)))
    for (g0, g1) in gaps(cols, min_gap):
        if g0 == 0 or g1 == len(cols) - 1:
            continue
        left_w = g0
        right_w = len(cols) - g1 - 1
        if left_w >= min_w and right_w >= min_w:
            out = []
            out += split_box(mask, x0, y0, x0 + g0 - 1, y1, sw, sh, depth + 1)
            out += split_box(mask, x0 + g1 + 1, y0, x1, y1, sw, sh, depth + 1)
            return out

    return [(x0, y0, x1, y1)]


index = {}
total = 0
report = []

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

    boxes = []
    for x0, y0, x1, y1, area in sorted(label(photo_mask), key=lambda v: (v[1], v[0])):
        bw, bh = x1 - x0 + 1, y1 - y0 + 1
        if area < MIN_AREA_RATIO * sw * sh:
            continue
        if bw < MIN_SIDE_RATIO * sw or bh < MIN_SIDE_RATIO * sh:
            continue
        if area / float(bw * bh) < MIN_FILL_RATIO:
            continue
        boxes.extend(split_box(photo_mask, x0, y0, x1, y1, sw, sh))

    # 再处理“左右两张照片高度不一致”造成的合并块
    refined = []
    for b in boxes:
        refined.extend(split_partial(photo_mask, b[0], b[1], b[2], b[3], sw, sh))
    boxes = refined

    boxes.sort(key=lambda b: (b[1], b[0]))

    page_dir = os.path.join('data', 'images', page)
    os.makedirs(page_dir, exist_ok=True)
    for old in glob.glob(os.path.join(page_dir, 'fig-*.png')):
        os.remove(old)

    figures = []
    for (x0, y0, x1, y1) in boxes:
        # 收紧边界：只保留实际非白区域
        sub = photo_mask[y0:y1 + 1, x0:x1 + 1]
        rr = np.where(sub.mean(axis=1) > 0.02)[0]
        cc = np.where(sub.mean(axis=0) > 0.02)[0]
        if len(rr) == 0 or len(cc) == 0:
            continue
        ty0, ty1 = y0 + int(rr[0]), y0 + int(rr[-1])
        tx0, tx1 = x0 + int(cc[0]), x0 + int(cc[-1])
        fx0, fy0 = tx0 * SCALE, ty0 * SCALE
        fx1, fy1 = min(w, (tx1 + 1) * SCALE), min(h, (ty1 + 1) * SCALE)
        if (fx1 - fx0) < MIN_FIG_W_RATIO * w or (fy1 - fy0) < MIN_FIG_H_RATIO * h:
            continue
        crop = im.crop((fx0, fy0, fx1, fy1))
        name = f'fig-{len(figures) + 1:02d}.png'
        crop.save(os.path.join(page_dir, name))
        figures.append({
            'file': f'{page}/{name}',
            'x': fx0, 'y': fy0, 'width': crop.width, 'height': crop.height,
            'yRatio': round(fy0 / h, 3), 'xRatio': round(fx0 / w, 3),
        })

    index[page] = figures
    total += len(figures)
    report.append((page, len(figures)))

    vis = small.copy()
    d = ImageDraw.Draw(vis)
    for i, g in enumerate(figures, start=1):
        d.rectangle([g['x'] // SCALE, g['y'] // SCALE,
                     (g['x'] + g['width']) // SCALE, (g['y'] + g['height']) // SCALE],
                    outline=(255, 0, 0), width=2)
        d.text((g['x'] // SCALE + 3, g['y'] // SCALE + 3), str(i), fill=(255, 0, 0))
    vis.resize((vis.width * 2, vis.height * 2), Image.NEAREST).save(
        os.path.join('work', 'debug', f'{page}-final.png'))
    print(f'{page}: {len(figures)} 张')

with open(os.path.join('data', 'images', 'index.json'), 'w', encoding='utf-8') as fh:
    json.dump(index, fh, ensure_ascii=False, indent=2)
print(f'\n共 {total} 张')
