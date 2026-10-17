# Hugging Face Spaces 部署

本项目使用 Docker Space 运行 Tomcat，容器默认监听 `7860` 端口。Hugging Face 只负责运行 Web 容器，MySQL 仍需要使用可从公网访问的外部数据库。

## 创建 Space

1. 登录 [Hugging Face](https://huggingface.co/)，选择 **New → Space**。
2. 填写 Space 名称，Visibility 可选 Public 或 Private。
3. `Space SDK` 选择 **Docker**，`Hardware` 选择免费的 CPU 配置。
4. 创建后，将本项目文件上传到 Space 仓库，或在本地添加 Space 为 Git remote 后推送：

   ```bash
   git remote add hf https://huggingface.co/spaces/YOUR_USERNAME/YOUR_SPACE_NAME
   git push hf master:main
   ```

   如果 Space 使用的默认分支不是 `main`，以 Space 页面显示的分支为准。

README 顶部的 YAML 元数据已经声明了 `sdk: docker` 和 `app_port: 7860`，无需另建启动脚本。

## 配置密钥

进入 Space 的 **Settings → Variables and secrets**，添加以下变量。数据库密码和 API Key 必须选择 Secret：

| 变量 | 类型 | 说明 |
| --- | --- | --- |
| `CROP_DB_URL` | Secret | MySQL JDBC URL，建议开启 `sslMode=REQUIRED` |
| `CROP_DB_USER` | Secret | MySQL 用户名 |
| `CROP_DB_PASSWORD` | Secret | MySQL 密码 |
| `DEEPSEEK_API_KEY` | Secret | DeepSeek API Key |
| `CROP_UPLOAD_DIR` | Variable | `/tmp/crop-uploads` |
| `CROP_FORCE_HTTPS` | Variable | `true` |
| `DEEPSEEK_BASE_URL` | Variable | `https://api.deepseek.com` |
| `DEEPSEEK_MODEL` | Variable | `deepseek-chat` |

## 初始化数据库

在外部 MySQL 8 数据库中按顺序执行：

```text
database/schema.sql
database/seed-crops.sql
database/seed-chemistry.sql
database/seed.sql
database/approve-initial-crops.sql
```

已有旧数据库时，先按照 `database/README.md` 执行邮箱登录迁移和其他增量脚本。

## 检查部署

Space 构建完成后，打开：

```text
https://YOUR_USERNAME-YOUR_SPACE_NAME.hf.space/health
```

正常时返回：

```json
{"status":"ok"}
```

首次启动需要构建 Maven 和 Tomcat 镜像，可能需要等待几分钟。

## 使用限制

- 免费 Space 可能休眠，首次访问需要等待唤醒。
- `/tmp/crop-uploads` 是临时存储，Space 重启后管理员上传的图片可能丢失；初始图片已打包进 WAR。
- Hugging Face 免费 Space 的 CPU 和内存有限，不适合高并发访问。
- DeepSeek API 费用由 DeepSeek 账户承担，不包含在 Hugging Face 免费额度中。
- 不要把数据库密码或 DeepSeek Key 写入 README、Dockerfile 或 Git 历史。
