"""按页面版式切片：左栏正文（上下两段）与底部数据表（左右两半），用于精确阅读与人工校对。"""
import glob
import os

from PIL import Image

pages_dir = os.path.join('work', 'pages')
out_dir = os.path.join('work', 'chunks')
os.makedirs(out_dir, exist_ok=True)

# 版式：正文左栏约占宽度 0~57%，底部数据表约占高度 87.8% 之后
LEFT_X0 = 0.0
LEFT_X1 = 0.58
TABLE_Y0 = 0.872


def save(im, box, name):
    crop = im.crop(box)
    path = os.path.join(out_dir, name + '.png')
    crop.save(path)
    return crop.size


for f in sorted(glob.glob(os.path.join(pages_dir, 'page-*.png'))):
    page = os.path.splitext(os.path.basename(f))[0]
    im = Image.open(f)
    w, h = im.size

    # 正文左栏：上段（标题 + 特征 + 分布）与下段（栽培 + 用途）
    save(im, (int(w * LEFT_X0), 0, int(w * LEFT_X1), int(h * 0.62)), f'{page}-text-top')
    save(im, (int(w * LEFT_X0), int(h * 0.55), int(w * LEFT_X1), int(h * 0.90)), f'{page}-text-bottom')

    # 数据表：左右两半，2 倍放大
    ty = int(h * TABLE_Y0)
    left = im.crop((0, ty, int(w * 0.5), h))
    right = im.crop((int(w * 0.46), ty, w, h))
    left.resize((left.width * 2, left.height * 2), Image.LANCZOS).save(
        os.path.join(out_dir, f'{page}-table-left.png'))
    right.resize((right.width * 2, right.height * 2), Image.LANCZOS).save(
        os.path.join(out_dir, f'{page}-table-right.png'))

    print(f'{page}: text {int(w * LEFT_X1)}x{int(h * 0.62)} / table halves ready')
