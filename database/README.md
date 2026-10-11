# 数据库脚本

## 执行顺序

1. 执行 `schema.sql` 创建数据库和表。
2. 执行 `seed-crops.sql` 导入作物基本信息、别名和图片记录（由 `work/build_seed_sql.py` 依据逐页转写结果生成）。
3. 执行 `seed-chemistry.sql` 导入样品、油脂指标和脂肪酸组分数据（同一脚本生成）。
4. 执行 `seed.sql` 导入账号等基础数据。
5. 经人工确认初始资料后，执行 `approve-initial-crops.sql` 发布这 33 条作物。

若数据库已导入过银杏及第 8、9、13、15、17 页图片记录，执行 `fix-conifer-images.sql`，同步修正图片归属与描述。脚本可重复执行，只替换这九种植物在对应原资料页的图片记录。

若此前已执行过未完成的第 17 页修正版本，再执行 `fix-page-17-images.sql` 将油松首图归还樟子松。

若数据库已在旧版本中导入过第 19 页图片记录，执行 `fix-page-19-images.sql` 一次，修正金钱松与柳杉的图片归属；之后重启或重新加载 Tomcat。

`seed.sql` 暂不包含虚构作物或明文密码。管理员账号必须使用安全生成的密码哈希创建。

重新生成资料数据：

```powershell
python work\validate_extract.py      # 校验转写结果
python work\build_review_sheet.py    # 生成人工校对表（Excel）
python work\build_seed_sql.py        # 生成 seed-crops.sql / seed-chemistry.sql
```

## 设计说明

- 作物基本资料、别名、样品、油脂指标、化学组分和图片分别存储。
- 删除作物时，关联资料通过外键级联删除。
- 删除用户时，查询记录保留但将 `user_id` 置空。
- 待审核数据通过 `review_status` 控制，不进入普通用户查询。
- `crop_images.image_type` 取值：植株、花、果实、种子、树皮、其他。
- `crop_components.component_name` 统一使用 C12:0、C14:0、C16:0、C16:1、C18:0、C18:1、C18:2、C18:3、C20:0、C20:1。
- 表格空白单元格一律保存为 `NULL`，不使用 `0` 或“无”代替。
- 资料初始数据由 PDF 逐页转写产生，来源页码记录在 `crops.source_page`，转写状态由 `crops.review_status` 控制。
