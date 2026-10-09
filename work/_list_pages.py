"""列出每页作物与图片数量，用于核对图片归属。"""
import glob
import json

for p in sorted(glob.glob('data/extracted/page-*.json')):
    d = json.load(open(p, encoding='utf-8'))
    names = [c['chineseName'] for c in d['crops']]
    imgs = [len(c.get('images') or []) for c in d['crops']]
    print(f"{d['page']:>2} | section={str(d.get('section'))[:20]:<20} | crops={names} | images={imgs}")
