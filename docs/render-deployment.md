# Render 部署

本项目通过 Docker 在 Render Web Service 上运行。Render 负责构建和运行 Tomcat，MySQL 与 DeepSeek 通过环境变量连接。

## 部署前准备

1. 将仓库推送到 GitHub：

   `https://github.com/luoyu-RGB/Crop-Search-Web`

2. 准备一个可从公网访问的 MySQL 8 数据库。Render 免费 Web Service 不包含 MySQL，可以使用已有数据库或其他提供商的 MySQL 实例。
3. 在数据库中按顺序执行初始化脚本：

   ```text
   database/schema.sql
   database/seed-crops.sql
   database/seed-chemistry.sql
   database/seed.sql
   database/approve-initial-crops.sql
   ```

   已存在旧数据库时，先按 `database/README.md` 的说明执行邮箱登录迁移和其他增量脚本。

## 在 Render 创建服务

1. 登录 [Render](https://render.com)，选择 **New → Blueprint**。
2. 连接 GitHub，并选择 `Crop-Search-Web` 仓库的 `master` 分支。
3. Render 会读取仓库根目录的 `render.yaml`，使用 `Dockerfile` 构建服务。
4. 在创建或部署时填写这些私密变量：

   | 变量 | 值 |
   | --- | --- |
   | `CROP_DB_URL` | MySQL JDBC URL，例如 `jdbc:mysql://host:3306/crop_knowledge?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&sslMode=REQUIRED` |
   | `CROP_DB_USER` | 数据库用户名 |
   | `CROP_DB_PASSWORD` | 数据库密码 |
   | `DEEPSEEK_API_KEY` | DeepSeek API Key |

   `DEEPSEEK_BASE_URL` 和 `DEEPSEEK_MODEL` 已在 `render.yaml` 中设置为默认值。密钥只填写在 Render 的 Environment 页面，不要提交到 Git。
5. 等待构建完成后，打开 Render 分配的 `https://<service>.onrender.com/health`。返回 `{"status":"ok"}` 后，再访问首页并注册账号。

## 首次上线后的操作

注册账号后，在数据库中将自己的账号提升为管理员：

```sql
USE crop_knowledge;
UPDATE users SET role = 'ADMIN' WHERE email = 'YOUR_REGISTERED_EMAIL';
```

然后退出并重新登录，进入管理后台审核或维护资料。

## 免费方案限制

- 免费 Web Service 会在一段时间无访问后休眠，第一次访问可能需要等待几十秒。
- `CROP_UPLOAD_DIR=/tmp/crop-uploads` 位于临时磁盘，服务重启或重新部署后管理员上传的图片可能丢失。初始图片会随 WAR 打包，不受此影响。
- Render 免费额度不包含 DeepSeek API 费用；AI 请求仍按 DeepSeek 账户规则计费。
- 外部 MySQL 必须允许 Render 的出站连接，并建议开启 TLS（JDBC URL 添加 `sslMode=REQUIRED`）。

## 本地验证 Docker 镜像

安装 Docker 后，在项目根目录执行：

```bash
docker build -t crop-knowledge-web .
docker run --rm -p 8080:8080 \
  -e CROP_DB_URL="jdbc:mysql://host.docker.internal:3306/crop_knowledge?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai" \
  -e CROP_DB_USER="YOUR_DB_USER" \
  -e CROP_DB_PASSWORD="YOUR_DB_PASSWORD" \
  -e CROP_UPLOAD_DIR="/tmp/crop-uploads" \
  crop-knowledge-web
```

然后访问 `http://localhost:8080/health`。
