"""裁剪页面底部的含油率及化学组分数据表区域，放大后供人工/模型核对。"""
import glob
import os

from PIL import Image

out_dir = os.path.join('work', 'tables')
os.makedirs(out_dir, exist_ok=True)

files = sorted(glob.glob(os.path.join('work', 'pages', 'page-*.png')))
print('pages:', len(files))
for f in files:
    name = os.path.splitext(os.path.basename(f))[0]
    im = Image.open(f)
    w, h = im.size
    # 数据表位于页面底部约 12%
    crop = im.crop((0, int(h * 0.878), w, h))
    crop = crop.resize((crop.width * 2, crop.height * 2), Image.LANCZOS)
    path = os.path.join(out_dir, f'{name}-table.png')
    crop.save(path)
    print(f'{name} table {crop.width}x{crop.height}')
