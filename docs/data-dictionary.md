# 数据字典（第一版）

数据库建议使用 MySQL，主键统一使用自增整数 `BIGINT`，时间字段使用 `DATETIME`，数值字段缺失时保存 `NULL`。

## users：用户表

| 字段 | 类型 | 说明 |
|---|---|---|
| id | BIGINT | 主键 |
| username | VARCHAR(50) | 登录名，唯一 |
| password_hash | VARCHAR(255) | 加密后的密码 |
| real_name | VARCHAR(50) | 姓名 |
| role | VARCHAR(20) | USER 或 ADMIN |
| email | VARCHAR(100) | 邮箱 |
| status | TINYINT | 1 正常，0 禁用 |
| create_time | DATETIME | 创建时间 |

## crops：作物基本信息表

| 字段 | 类型 | 说明 |
|---|---|---|
| id | BIGINT | 主键 |
| chinese_name | VARCHAR(100) | 中文名称 |
| english_name | VARCHAR(150) | 英文名称 |
| latin_name | VARCHAR(200) | 拉丁学名 |
| family | VARCHAR(100) | 科 |
| genus | VARCHAR(100) | 属 |
| features | TEXT | 形态特征 |
| distribution | TEXT | 分布 |
| cultivation | TEXT | 栽培 |
| uses | TEXT | 用途 |
| source_page | INT | PDF 来源页码 |
| review_status | VARCHAR(20) | DRAFT、PENDING、APPROVED、REJECTED |
| create_time | DATETIME | 创建时间 |
| update_time | DATETIME | 修改时间 |

## crop_aliases：作物别名表

| 字段 | 类型 | 说明 |
|---|---|---|
| id | BIGINT | 主键 |
| crop_id | BIGINT | 关联作物 |
| alias_name | VARCHAR(100) | 别名 |
| alias_type | VARCHAR(30) | 中文别名、英文别名等 |

## crop_samples：采集和测试样品表

| 字段 | 类型 | 说明 |
|---|---|---|
| id | BIGINT | 主键 |
| crop_id | BIGINT | 关联作物 |
| collection_unit | VARCHAR(150) | 采集单位 |
| test_unit | VARCHAR(150) | 测试单位 |
| test_part | VARCHAR(100) | 测试部位 |
| origin | VARCHAR(200) | 产地 |
| remark | TEXT | 备注 |

## crop_oil_data：油脂指标表

| 字段 | 类型 | 说明 |
|---|---|---|
| id | BIGINT | 主键 |
| crop_id | BIGINT | 关联作物 |
| sample_id | BIGINT | 关联样品，可为空 |
| oil_content | DECIMAL(10,4) | 含油率 |
| iodine_value | DECIMAL(10,4) | 碘值 |
| acid_value | DECIMAL(10,4) | 酸值 |
| saponification_value | DECIMAL(10,4) | 皂化值 |
| unit | VARCHAR(20) | 数值单位 |

## crop_components：化学组分表

| 字段 | 类型 | 说明 |
|---|---|---|
| id | BIGINT | 主键 |
| crop_id | BIGINT | 关联作物 |
| sample_id | BIGINT | 关联样品，可为空 |
| component_name | VARCHAR(30) | 如 C18:1 |
| component_value | DECIMAL(10,4) | 组分含量 |
| unit | VARCHAR(20) | 数值单位 |
| remark | VARCHAR(255) | 备注 |

## crop_images：作物图片表

| 字段 | 类型 | 说明 |
|---|---|---|
| id | BIGINT | 主键 |
| crop_id | BIGINT | 关联作物 |
| image_path | VARCHAR(255) | 文件路径 |
| image_title | VARCHAR(100) | 图片标题 |
| image_type | VARCHAR(30) | 植株、果实、种子等 |
| is_cover | TINYINT | 是否封面图 |
| sort_order | INT | 展示顺序 |

## search_records：查询记录表

| 字段 | 类型 | 说明 |
|---|---|---|
| id | BIGINT | 主键 |
| user_id | BIGINT | 查询用户 |
| query_text | TEXT | 原始查询文字 |
| query_conditions | JSON | 结构化查询条件 |
| result_count | INT | 返回结果数量 |
| create_time | DATETIME | 查询时间 |

## 关系说明

```text
users 1 ─── N search_records
crops 1 ─── N crop_aliases
crops 1 ─── N crop_samples
crops 1 ─── N crop_oil_data
crops 1 ─── N crop_components
crops 1 ─── N crop_images
crop_samples 1 ─── N crop_oil_data
crop_samples 1 ─── N crop_components
```
