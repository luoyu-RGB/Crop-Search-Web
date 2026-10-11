# 第七阶段记录：DeepSeek SDK 接入

## 实现内容

- 使用 `com.openai:openai-java:4.80.0`，通过 DeepSeek 的 OpenAI 兼容接口调用 `deepseek-chat`。
- `/assistant` 优先使用已审核作物资料生成问答；资料未覆盖的问题可用通用知识补充，并将 PDF 来源页限定为数据库资料部分。
- 问题提及多个已审核作物时会使用多条资料并分别标注来源页；数据库未匹配时，DeepSeek 调用 `browser_search` 工具，服务器读取 Bing 网页搜索的公开 RSS 结果并交回 DeepSeek 整理回答，页面列出来源链接，不附 PDF 来源页。
- `/admin/ai-suggest` 根据管理员粘贴的 OCR 文本生成待审核字段建议，不自动写入作物表。
- `knowledge_questions` 保存用户问题、回答、作物 ID 和来源页。

## 配置

在运行 Tomcat 的进程环境中设置：

```text
DEEPSEEK_API_KEY=新生成的 DeepSeek API 密钥
DEEPSEEK_BASE_URL=https://api.deepseek.com
DEEPSEEK_MODEL=deepseek-chat
```

`DEEPSEEK_BASE_URL` 和 `DEEPSEEK_MODEL` 可省略。搜索工具使用公开网页搜索结果，不需要 Brave 密钥。在 Eclipse 中运行 Tomcat 时，可在服务器的运行配置中打开“环境”页，配置 DeepSeek API Key，然后重新发布应用并重启 Tomcat。不要把密钥写到 Java 源码、JSP 或 Git。部署前执行 `database/phase-7.sql`。

## 检查

- `mvn clean test package -q` 通过。
- `git diff --check` 通过。
- 本地模拟测试覆盖了 DeepSeek 两轮工具调用、搜索结果回传、RSS 解析、安全链接过滤及错误分类；本机 Java 搜索请求取得 5 条真实网页结果，使用现有 DeepSeek 密钥运行完整工具调用后也返回了回答和 5 条来源。此方案读取公开搜索摘要，搜索站点的可用性和结果格式可能变化，回答仍需核对原网页。
- “生长在云南的作物”等地区问题现在优先检索已审核作物的分布文本和采集点省份，最多提供 20 条记录；地区列举不得表述为当地全部作物。未找到数据库记录时，页面会区分搜索无结果、搜索站点拒绝请求、限流和连接超时。
- 本机数据库已执行 `database/phase-7.sql`；`knowledge_questions` 表存在，问答记录写入经事务回滚验证通过。问答页示例改为数据库中已审核的“银杏”。
- 已在本机 Eclipse Tomcat 启动配置中添加 `DEEPSEEK_API_KEY`，源码按变量名读取。密钥直接调用 DeepSeek 接口返回 HTTP 200；重新构建的 WAR 和部署 class 不包含明文密钥。网页端登录后的完整操作仍需人工验收。
- 如果密钥曾出现在网页或源码中，应在 DeepSeek 平台撤销并生成新密钥。
