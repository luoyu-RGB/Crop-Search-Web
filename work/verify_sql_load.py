"""用 SQLite 内存库模拟执行建表与前两步初始化脚本，验证 SQL 可加载、外键与唯一约束成立。

说明：MySQL 专有语法（ENGINE、字符集、USE、CHECK）在转换时剔除，其余语句按原样执行，
用于在没有 MySQL 的环境下发现结构性问题（列数不匹配、外键悬空、唯一键冲突等）。

用法：python work/verify_sql_load.py
"""
import re
import sqlite3
import sys

SCHEMA = 'database/schema.sql'
SCRIPTS = ['database/seed-crops.sql', 'database/seed-chemistry.sql']


def load_ddl(path):
    """把 MySQL 建表脚本转换为 SQLite 可执行形式（仅用于结构验证）。

    逐行处理并跟踪括号深度，用于正确剔除跨行的 CHECK 约束。
    """
    text = open(path, encoding='utf-8').read()
    text = re.sub(r'CREATE DATABASE.*?;', '', text, flags=re.S)
    text = re.sub(r'^USE .*?;$', '', text, flags=re.M)
    # SQLite 不认识 MySQL 的表选项；保留右括号并删除整段 ENGINE/字符集选项。
    text = re.sub(r'\)\s*ENGINE\s*=\s*\w+\s*[^;]*;', ');', text, flags=re.I)
    text = re.sub(r'ON UPDATE CURRENT_TIMESTAMP', '', text)
    text = re.sub(r'\bJSON\b', 'TEXT', text)
    text = re.sub(r'BIGINT PRIMARY KEY AUTO_INCREMENT', 'INTEGER PRIMARY KEY AUTOINCREMENT', text)
    text = re.sub(r'\bBIGINT\b', 'INTEGER', text)
    text = re.sub(r'\bTINYINT\b', 'INTEGER', text)
    text = re.sub(r'\bDATETIME\b', 'TEXT', text)

    text = re.sub(r'^\s*CONSTRAINT\s+\w+\s+CHECK\s*\([^\n]+\),?\s*$', '', text, flags=re.M | re.I)
    extra = []
    out_lines = []
    current = None
    depth = 0

    for line in text.splitlines():
        stripped = line.strip()

        m = re.match(r'CREATE TABLE IF NOT EXISTS (\w+)', stripped)
        if m:
            current = m.group(1)

        im = re.match(r'INDEX\s+(\w+)\s*\(([^)]*)\),?$', stripped)
        if im and current:
            extra.append(f'CREATE INDEX IF NOT EXISTS {im.group(1)} ON {current} ({im.group(2)});')
            continue

        um = re.match(r'UNIQUE KEY\s+(\w+)\s*\(([^)]*)\),?$', stripped)
        if um:
            out_lines.append(f'    UNIQUE ({um.group(2)}),')
            continue

        # 去掉行尾逗号（若下一非空行是表结束括号）
        out_lines.append(line)
        depth += line.count('(') - line.count(')')

    cleaned = []
    lines = out_lines
    for i, line in enumerate(lines):
        nxt = next((lines[j].strip() for j in range(i + 1, len(lines)) if lines[j].strip()), None)
        if line.rstrip().endswith(',') and nxt is not None and nxt.startswith(')'):
            line = line.rstrip()[:-1]
        cleaned.append(line)

    return '\n'.join(cleaned) + '\n' + '\n'.join(extra)


def statements(text):
    out = []
    pending = ''
    for line in text.splitlines():
        if line.lstrip().startswith('--') or not line.strip():
            continue
        pending += line + '\n'
        if sqlite3.complete_statement(pending):
            out.append(pending.strip())
            pending = ''
    if pending.strip():
        raise ValueError('SQL 文件以未完成的语句结尾')
    return out


con = sqlite3.connect(':memory:')
con.execute('PRAGMA foreign_keys=ON')

ddl = load_ddl(SCHEMA)
count = 0
for stmt in statements(ddl):
    try:
        con.execute(stmt)
        count += 1
    except sqlite3.Error as exc:
        print(f'[E] 建表失败: {exc}\n    语句: {stmt[:120]}')
        sys.exit(1)
print(f'建表成功: {count} 条语句')

tables = [r[0] for r in con.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")]
print('表:', tables)

row_counts = {}
for path in SCRIPTS:
    text = open(path, encoding='utf-8').read()
    text = re.sub(r'^USE .*?;$', '', text, flags=re.M)
    ok = 0
    for stmt in statements(text):
        if not stmt.upper().startswith('INSERT'):
            continue
        try:
            con.execute(stmt)
            ok += 1
        except sqlite3.Error as exc:
            print(f'[E] {path} 执行失败: {exc}\n    语句: {stmt[:160]}')
            sys.exit(1)
    print(f'{path}: 成功执行 {ok} 条 INSERT')

for t in tables:
    row_counts[t] = con.execute(f'SELECT COUNT(*) FROM {t}').fetchone()[0]
print('\n各表行数:')
for t, n in row_counts.items():
    print(f'  {t}: {n}')

# 关键一致性抽查
checks = [
    ('没有图片缺路径', 'SELECT COUNT(*) FROM crop_images WHERE image_path IS NULL'),
    ('没有样品缺产地', 'SELECT COUNT(*) FROM crop_samples WHERE origin IS NULL'),
    ('没有组分缺数值', 'SELECT COUNT(*) FROM crop_components WHERE component_value IS NULL'),
    ('采集点都挂了作物', 'SELECT COUNT(*) FROM crop_distribution_points p LEFT JOIN crops c ON c.id=p.crop_id WHERE c.id IS NULL'),
    ('图片都挂了作物', 'SELECT COUNT(*) FROM crop_images i LEFT JOIN crops c ON c.id=i.crop_id WHERE c.id IS NULL'),
]
ok = True
for label, sql in checks:
    n = con.execute(sql).fetchone()[0]
    flag = 'OK' if n == 0 else 'FAIL'
    if n:
        ok = False
    print(f'  [{flag}] {label}: {n}')

# 组合查询演练：科=松科 且 含油率>20 且 C18:1>40
rows = con.execute('''
SELECT DISTINCT c.chinese_name, s.origin, o.oil_content, comp.component_value
FROM crops c
JOIN crop_samples s ON s.crop_id = c.id
JOIN crop_oil_data o ON o.sample_id = s.id
JOIN crop_components comp ON comp.sample_id = s.id AND comp.component_name = 'C18:1'
WHERE c.family = '松科' AND o.oil_content > 20 AND comp.component_value > 40
ORDER BY o.oil_content DESC
''').fetchall()
print(f'\n组合查询演练（松科 + 含油率>20 + C18:1>40）：命中 {len(rows)} 条')
for r in rows[:8]:
    print('   ', r)

sys.exit(0 if ok else 1)
