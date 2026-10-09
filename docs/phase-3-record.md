# 第三阶段：注册、登录和权限控制

本阶段实现注册、登录、退出、Session、管理员页面访问控制和数据库连接池，已通过检查并提交 Git。

## 功能

- `User`、`UserDao`、`AuthService` 和 `AuthServlet` 分层。
- 用户名唯一性检查；后端验证用户名、密码、确认密码和邮箱；前端提供输入约束与两次密码一致性提示。
- 密码用随机盐 PBKDF2-HMAC-SHA256 哈希保存。数据库中不保存明文密码。
- 登录后创建 Session，退出时销毁 Session；`SecurityFilter` 限制账户和管理员页面。
- `HikariCP` 连接 MySQL，应用停止时关闭连接池。

## 在 Eclipse/Tomcat 运行

1. 使用已安装的 **Tomcat 10.1**。项目使用 `jakarta.servlet` 6.0。
2. 在 MySQL 中依次运行 `database/schema.sql`、`database/seed-crops.sql`、`database/seed-chemistry.sql`、`database/seed.sql`。
3. 在 Eclipse 的 Tomcat 运行配置中设置环境变量：

```text
CROP_DB_URL=jdbc:mysql://localhost:3306/crop_knowledge?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
CROP_DB_USER=你的数据库用户名
CROP_DB_PASSWORD=你的数据库密码
```

4. Maven Update Project，然后 Run on Server。默认 WAR 上下文路径为 `/crop-knowledge-web`。
5. 首次注册创建普通用户。管理员账号由数据库管理员单独创建，勿在网页注册时允许自选管理员角色。

## 验证

`mvn test` 检查输入校验和密码哈希，`mvn package` 检查 WAR 构建。数据库和 Tomcat 联调需要本机 MySQL 账号配置后进行。
