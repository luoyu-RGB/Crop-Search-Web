"""生成图片汇总接触表（前 24 张），用于快速目检切图质量。"""
import json
import math
import os

from PIL import Image, ImageDraw

with open(os.path.join('data', 'images', 'index.json'), encoding='utf-8') as fh:
    index = json.load(fh)

files = []
for page_key in sorted(index):
    for fig in index[page_key]:
        files.append(fig['file'])

CELL_W, CELL_H = 260, 200
COLS = 6
ROWS = math.ceil(min(len(files), 24) / COLS)
sheet = Image.new('RGB', (CELL_W * COLS, CELL_H * ROWS + 30), 'white')
d = ImageDraw.Draw(sheet)
d.text((6, 8), f'共 {len(files)} 张切图，下面显示前 {min(len(files), 24)} 张', fill='black')

for i, rel in enumerate(files[:24]):
    im = Image.open(os.path.join('data', 'images', rel)).convert('RGB')
    im.thumbnail((CELL_W - 8, CELL_H - 24))
    x = (i % COLS) * CELL_W + 4
    y = (i // COLS) * CELL_H + 26
    sheet.paste(im, (x, y))
    d.text((x, y + CELL_H - 22), rel, fill=(150, 0, 0))

out = os.path.join('work', 'debug', 'contact-sheet.png')
sheet.save(out)
print(out, sheet.size)
