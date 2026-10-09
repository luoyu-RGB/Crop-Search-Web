"""列出每页内容流中绘制图片的指令（cm 矩阵 + Do），用于精确判定每张照片的位置和大小。"""
import glob
import re

import fitz

pdf = glob.glob('*.pdf')[0]
doc = fitz.open(pdf)

for i in range(doc.page_count):
    page = doc.load_page(i)
    images = page.get_images(full=True)
    by_xref = {}
    for info in images:
        by_xref[info[0]] = (info[2], info[3])  # xref -> (width, height)

    xref_names = {}
    for xref, name in page.get_image_info(xrefs=True) and []:
        pass

    # xref -> 资源名
    for name, xref in page.get_images(full=True) and []:
        pass

    cont = page.read_contents().decode('latin-1', 'ignore')
    # 资源名映射：/Im0 12 0 R 形式
    res_names = dict((m.group(1), int(m.group(2))) for m in re.finditer(r'/(\w+)\s+(\d+)\s+0\s+R', cont))
    placements = []
    for m in re.finditer(r'([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+cm\s*(?:/[^\s/]+\s+)*/(\w+)\s+Do', cont):
        a, b, c, d, e, f = (float(x) for x in m.groups()[:6])
        name = m.group(7)
        xref = res_names.get(name)
        placements.append((name, xref, a, b, c, d, e, f))

    print(f'--- page {i + 1}: {len(images)} 个图片对象, {len(placements)} 处绘制 ---')
    for name, xref, a, b, c, d, e, f in placements:
        size = by_xref.get(xref, ('?', '?'))
        print(f'   {name} xref={xref} 像素={size} cm=({a:g},{b:g},{c:g},{d:g},{e:g},{f:g})')
