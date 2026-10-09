"""将扫描版课程设计资料 PDF 渲染为高分辨率页面图片，供 OCR 使用。"""
import glob
import os

import fitz

pdf = glob.glob('*.pdf')[0]
out_dir = os.path.join('work', 'pages')
os.makedirs(out_dir, exist_ok=True)

doc = fitz.open(pdf)
print(f'file={pdf} pages={doc.page_count}')
for i in range(doc.page_count):
    page = doc.load_page(i)
    pix = page.get_pixmap(matrix=fitz.Matrix(3, 3), alpha=False)
    path = os.path.join(out_dir, f'page-{i + 1:02d}.png')
    pix.save(path)
    print(f'page {i + 1:02d} -> {pix.width}x{pix.height} {os.path.getsize(path)} bytes')
