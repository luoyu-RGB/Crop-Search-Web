# 第五阶段：管理员资料维护

## 已完成

- 管理员可按名称和审核状态浏览资料，并新增、修改、删除作物基本资料。
- 支持审核状态 `DRAFT`、`PENDING`、`APPROVED`、`REJECTED`，普通用户查询仍只返回 `APPROVED`。
- 支持别名新增和删除。
- 支持样品、采集/检测信息、产地、检测指标及脂肪酸组成新增和删除；输入值会进行非负数字和脂肪酸名称校验。
- 支持图片上传、标题、封面设置和删除。上传限制为 JPG、PNG、GIF、WEBP，单文件不超过 5 MB。
- 资料删除依靠数据库外键级联清理关联别名、样品、检测数据和图片记录；管理员操作写入 `admin_operation_logs`。
- `/admin/*` 仍由 `SecurityFilter` 强制要求管理员 Session，普通用户返回 403。

## 数据库升级

已有数据库执行 `database/phase-5.sql` 创建管理员操作日志表；全新数据库直接执行更新后的 `database/schema.sql`。

## 验证

- `mvn test package` 通过。
- 6 个自动化测试通过；MySQL 集成测试在未设置 `CROP_DB_*` 时按既有规则跳过。
