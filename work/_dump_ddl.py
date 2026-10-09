import re
src = open("work/verify_sql_load.py", encoding="utf-8").read()
ns = {}
exec(src.split("con = sqlite3.connect")[0], ns)
ddl = ns["load_ddl"]("database/schema.sql")
print(ddl[:1400])
