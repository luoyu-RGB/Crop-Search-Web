"""从扫描版 PDF 每页提取内嵌图片（作物照片），过滤页眉装饰与小图标。

输出：data/images/page-NN/fig-XX.<ext>，并生成 data/images/index.json 记录每页图片清单。
"""
import glob
import json
import os

import fitz

pdf = glob.glob('*.pdf')[0]
out_root = os.path.join('data', 'images')
os.makedirs(out_root, exist_ok=True)

doc = fitz.open(pdf)
index = {}
total = 0

for i in range(doc.page_count):
    page = doc.load_page(i)
    page_key = f'page-{i + 1:02d}'
    page_dir = os.path.join(out_root, page_key)
    os.makedirs(page_dir, exist_ok=True)

    figures = []
    for img_no, info in enumerate(page.get_images(full=True), start=1):
        xref = info[0]
        width, height = info[2], info[3]
        # 过滤过小的装饰图与分隔线
        if width < 80 or height < 80:
            continue
        pix = fitz.Pixmap(doc, xref)
        if pix.n - pix.alpha >= 4:  # CMYK 转 RGB
            pix = fitz.Pixmap(fitz.csRGB, pix)
        name = f'fig-{len(figures) + 1:02d}.png'
        path = os.path.join(page_dir, name)
        pix.save(path)
        figures.append({
            'file': f'{page_key}/{name}',
            'width': pix.width,
            'height': pix.height,
            'bytes': os.path.getsize(path),
        })
        pixels = pix.width * pix.height
        pix = None

    index[page_key] = figures
    total += len(figures)
    print(f'{page_key}: {len(figures)} 张 -> {[f["file"].split("/")[-1] for f in figures]}')

with open(os.path.join(out_root, 'index.json'), 'w', encoding='utf-8') as fh:
    json.dump(index, fh, ensure_ascii=False, indent=2)

print(f'\n共提取 {total} 张图片，清单: data/images/index.json')
