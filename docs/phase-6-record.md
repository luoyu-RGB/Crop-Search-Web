# 第六阶段：PDF 资料导入与数据质量收尾

## 完成状态

本阶段的 PDF 整理、数据校验和图片归档已完成。用户已根据原 PDF 完成人工内容校对。

## 产出统计

- PDF 共 19 页，对应 `data/extracted/page-01.json` 至 `page-19.json`?
- 作物 33 条，别名 9 条，样品 91 条，脂肪酸组分 601 条，分布采集点 71 条。
- 图片 101 张，`data/images/index.json` 与 JSON 归档记录一致。
- `database/seed-crops.sql` 和 `database/seed-chemistry.sql` 已由结构化 JSON 生成，涉及 10 个数据表。

## 质量校验

- `python work\validate_extract.py`：ERROR 0，WARNING 0。
- `python work\audit_data.py`：JSON 与 SQL 数量一致，ERROR 0。
- 审计报告中的 24 条 WARNING 是原 PDF 数据的可追溯异常：22 条脂肪酸合计偏差、一条样品无油脂指标、一条图片部署提示。这些内容均按原 PDF 保留，缺失数值保存为 `NULL`。
- 用户已完成人工校对，未发现需要重新转录的页面内容。

## 数据发布

初始 SQL 将 33 条作物标记为 `PENDING`，确认后执行 `database/approve-initial-crops.sql` 将其发布为 `APPROVED`。当前环境未配置 `CROP_DB_*`，因此本次只验证脚本和数据一致性，未连接实际 MySQL 执行发布脚本。

## 阶段产出

- `data/extracted/page-01.json` 至 `page-19.json`
- `data/images/` 和 `data/images/index.json`
- `database/seed-crops.sql`
- `database/seed-chemistry.sql`
- `database/approve-initial-crops.sql`
- `docs/pdf-extraction-spec.md`
- `docs/data-dictionary.md`

下一阶段为 OCR/AI 增强能力和自然语言查询。
