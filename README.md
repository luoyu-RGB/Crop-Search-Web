# Crop Search Web · 作物知识库

基于 Java Servlet、JSP 和 MySQL 的作物资料查询与管理平台。项目将扫描版 PDF 中的植物资料整理为结构化数据，支持名称与别名检索、组合筛选、油脂指标查询、图片管理，以及 DeepSeek 辅助问答。

本项目采用 Maven 构建，以 WAR 包形式部署到 Tomcat，适用于 Java Web 课程设计与学习实践。

## 功能概览

| 模块 | 已实现功能 |
| --- | --- |
| 账户与权限 | 注册、登录、退出、Session 管理，普通用户与管理员权限控制 |
| 作物检索 | 按中文名、英文名、拉丁学名及别名查询；按科属、特征、分布、栽培和用途组合筛选 |
| 数值筛选 | 含油率、碘值、酸值、皂化值和脂肪酸含量范围筛选，支持“全部满足”或“任意满足” |
| 结果与详情 | 分页、自选结果字段、作物图片、样品检测数据及 PDF 来源页码 |
| 管理后台 | 作物增删改、资料审核、别名维护、样品与化学组分维护 |
| 图片管理 | 上传图片、修改标题、选择封面、删除图片 |
| AI 资料问答 | 优先参考已审核资料；未匹配资料时调用网页搜索工具，展示回答与来源链接 |
| OCR 字段建议 | 管理员粘贴 OCR 文本和来源页码，生成候选 JSON，经人工核对后手动录入 |

普通用户只能检索已审核资料。AI/OCR 建议不会自动写入作物资料表或自动发布。

## 数据来源

初始资料整理自仓库中的《课程设计资料.pdf》（《中国非粮生物柴油植物》相关页面），按 PDF 页码保留来源，包含：

- 19 页逐页结构化记录、33 条作物资料、9 条别名。
- 91 条样品、601 条脂肪酸组分、71 条分布采集点。
- 101 张图片，以及人工校对表与数据校验脚本。

缺失数值保存为 `NULL`；原始资料中的检测数据偏差按来源保留。AI 回答和联网搜索摘要仍需结合原始资料核对。

## 技术栈与环境

| 类别 | 技术或要求 |
| --- | --- |
| 后端 | Java、Jakarta Servlet 6.0、JSP，按 Web / Service / DAO / Model 分层 |
| 前端 | 原生 HTML、CSS、JavaScript，响应式布局 |
| 数据库 | MySQL 8.x，MySQL Connector/J 8.4.0、HikariCP 4.0.3 |
| AI 接口 | OpenAI Java SDK 4.80.0，通过兼容接口调用 DeepSeek |
| 构建与测试 | Maven、JUnit 5；JavaScript 测试使用 Node.js 内置断言 |
| 运行容器 | Apache Tomcat 10.1.x（Jakarta 命名空间） |
| JDK | 建议使用 JDK 21 或更新的 LTS 版本；Tomcat 10.1 至少要求 Java 11 |

`pom.xml` 中的 Java 源码/目标级别为 8，但运行环境还需满足 Tomcat 和依赖要求。Node.js 和 Python 仅用于相应测试与资料处理，不是运行网站的必需组件。

## 本地运行

### 1. 克隆项目

```bash
git clone https://github.com/luoyu-RGB/Crop-Search-Web.git
cd Crop-Search-Web
```

### 2. 初始化数据库

在项目根目录打开终端，使用自己的 MySQL 账号进入客户端：

```bash
mysql --default-character-set=utf8mb4 -u YOUR_DB_USER -p
```

在 MySQL 客户端中依次执行：

```sql
SOURCE database/schema.sql;
SOURCE database/seed-crops.sql;
SOURCE database/seed-chemistry.sql;
SOURCE database/seed.sql;
```

初始作物状态为 `PENDING`。核对资料后，可在后台逐条审核，或执行以下脚本发布这批初始资料：

```sql
SOURCE database/approve-initial-crops.sql;
```

新数据库使用的 `schema.sql` 已包含当前表结构。已有数据库的增量脚本、历史图片修正说明见 [database/README.md](database/README.md) 和 [第七阶段记录](docs/phase-7-record.md)。初始数据脚本用于首次导入，不应在已有相同数据的库中反复执行。

### 3. 配置运行环境变量

在**启动 Tomcat 的进程环境**中配置：

```text
CROP_DB_URL=jdbc:mysql://localhost:3306/crop_knowledge?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
CROP_DB_USER=YOUR_DB_USER
CROP_DB_PASSWORD=YOUR_DB_PASSWORD

DEEPSEEK_API_KEY=YOUR_DEEPSEEK_API_KEY
DEEPSEEK_BASE_URL=https://api.deepseek.com
DEEPSEEK_MODEL=deepseek-chat
```

- `CROP_DB_*` 用于数据库连接。
- `DEEPSEEK_API_KEY` 用于 AI 功能；不配置时仍可使用普通资料查询与管理，调用 AI 时页面会提示缺少配置。
- `DEEPSEEK_BASE_URL` 和 `DEEPSEEK_MODEL` 可省略，默认值如上。联网搜索使用 Bing 公开 RSS 搜索结果，不需要额外的 Brave 密钥。
- 将示例占位值换成自己的配置，密钥和密码不要写入源码或提交到 Git。

### 4. 构建与部署

```bash
mvn clean package
```

将生成的 `target/crop-knowledge-web.war` 放入 Tomcat 的 `webapps/` 目录，启动 Tomcat 后访问：

[http://localhost:8080/crop-knowledge-web/](http://localhost:8080/crop-knowledge-web/)

通过 Eclipse 运行时：

1. 选择 **Existing Maven Projects** 导入项目，并更新 Maven 依赖。
2. 配置 **Tomcat 10.1** 运行环境，将应用上下文设为 `/crop-knowledge-web`。
3. 在 Tomcat 的运行配置 **Environment** 中添加上述变量。
4. 使用 **Run on Server** 发布，修改环境变量后重启 Tomcat。

### 5. 设置管理员

项目不提供默认账号或默认密码。先在注册页创建自己的普通账号，再由数据库管理员为指定账号授予管理员角色：

```sql
USE crop_knowledge;
UPDATE users SET role = 'ADMIN' WHERE username = 'YOUR_REGISTERED_USERNAME';
```

角色修改后退出并重新登录即可进入后台。密码由注册流程生成带随机盐的 PBKDF2-HMAC-SHA256 哈希。

## 页面入口

以下路径均相对于 `/crop-knowledge-web`：

| 路径 | 页面 | 权限 |
| --- | --- | --- |
| `/` | 首页 | 公开 |
| `/register`、`/login` | 注册与登录 | 公开 |
| `/account/` | 我的账户 | 已登录 |
| `/search` | 作物查询 | 已登录 |
| `/crop/detail?id=2` | 作物详情（示例 ID） | 已登录 |
| `/assistant` | AI 资料问答 | 已登录 |
| `/admin/crops` | 资料维护列表 | 管理员 |
| `/admin/crops/edit` | 新增或编辑作物 | 管理员 |
| `/admin/ai-suggest` | OCR 字段建议 | 管理员 |

管理员上传的图片保存在部署目录 `assets/crops/admin/`，重新部署前应备份该目录及数据库中的对应记录。仓库内的初始图片由 Maven 从 `data/images/` 打包到 WAR。

## 检查与测试

```bash
# Java 测试和 WAR 构建
mvn clean test package

# 查询条件联动的 JavaScript 测试（需要 Node.js）
node src/test/js/search-options.test.js

# PDF 转写数据校验（需要 Python）
python work/validate_extract.py
python work/audit_data.py
```

MySQL 集成测试需要配置 `CROP_DB_*`，未配置时会跳过；运行时应使用已导入初始数据的测试数据库。联网和 AI 服务的实际可用性取决于本地网络与接口配置。

## 项目结构

```text
src/main/java/com/cropknowledge/
  config/       数据库连接配置
  dao/          数据访问
  model/        领域数据模型
  security/     密码哈希
  service/      检索、认证与 AI 服务
  web/          Servlet、权限过滤器与页面辅助
src/main/webapp/
  WEB-INF/views/  JSP 页面
  assets/         CSS、JavaScript
src/test/       Java 与 JavaScript 测试
database/       表结构、初始数据与增量脚本
data/           逐页 JSON、图片与人工校对资料
docs/           产品需求、数据字典和阶段记录
plan/           开发计划
work/           PDF、OCR 与数据整理脚本
```

## 相关文档

- [产品需求](docs/PRD.md)
- [数据库脚本说明](database/README.md)
- [数据字典](docs/data-dictionary.md)
- [PDF 提取规范](docs/pdf-extraction-spec.md)
- [PDF 数据导入记录](docs/phase-6-record.md)
- [DeepSeek 接入与配置](docs/phase-7-record.md)
