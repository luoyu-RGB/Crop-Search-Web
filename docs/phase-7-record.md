# 第七阶段记录：DeepSeek SDK 接入

## 实现内容

- 使用 `com.openai:openai-java:4.80.0`，通过 DeepSeek 的 OpenAI 兼容接口调用 `deepseek-chat`。
- `/assistant` 根据已审核作物资料生成问答，并保存作物记录与 PDF 来源页。
- `/admin/ai-suggest` 根据管理员粘贴的 OCR 文本生成待审核字段建议，不自动写入作物表。
- `knowledge_questions` 保存用户问题、回答、作物 ID 和来源页。

## 配置

在运行 Tomcat 的进程环境中设置：

```text
DEEPSEEK_API_KEY=新生成的 DeepSeek API 密钥
DEEPSEEK_BASE_URL=https://api.deepseek.com
DEEPSEEK_MODEL=deepseek-chat
```

后两项可省略，程序会使用上述默认值。在 Eclipse 中运行 Tomcat 时，可在服务器的运行配置中打开“环境”页，新增变量 `DEEPSEEK_API_KEY`，然后重新发布应用并重启 Tomcat。不要把密钥写到 Java 源码、JSP 或 Git。部署前执行 `database/phase-7.sql`。

## 检查

- `mvn clean test package -q` 通过。
- `git diff --check` 通过。
- 本机数据库已执行 `database/phase-7.sql`；`knowledge_questions` 表存在，问答记录写入经事务回滚验证通过。问答页示例改为数据库中已审核的“银杏”。
- 已在本机 Eclipse Tomcat 启动配置中添加 `DEEPSEEK_API_KEY`，源码按变量名读取。密钥直接调用 DeepSeek 接口返回 HTTP 200；重新构建的 WAR 和部署 class 不包含明文密钥。网页端问答仍需验收。
- 如果密钥曾出现在网页或源码中，应在 DeepSeek 平台撤销并生成新密钥。
