<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="zh-CN"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>注册 · 作物知识库</title><link rel="stylesheet" href="<%= request.getContextPath() %>/assets/site.css"></head><body>
<header class="site-header"><a class="brand" href="<%= request.getContextPath() %>/">作物知识库</a><nav><a href="<%= request.getContextPath() %>/login">已有账户？登录</a></nav></header>
<main class="auth-page"><form class="auth-form" method="post" action="<%= request.getContextPath() %>/register" id="registerForm"><h1>创建账户</h1><p class="subtle">注册后可使用作物查询服务</p>
<% if (request.getAttribute("error") != null) { %><p class="error" role="alert"><%= request.getAttribute("error") %></p><% } %>
<label>用户名<input name="username" required minlength="3" maxlength="30" pattern="[A-Za-z0-9_]+" autocomplete="username"></label>
<label>邮箱<input name="email" type="email" required maxlength="100" autocomplete="email"></label>
<label>密码<input name="password" type="password" required minlength="8" maxlength="128" autocomplete="new-password"></label>
<label>确认密码<input name="confirmPassword" type="password" required minlength="8" maxlength="128" autocomplete="new-password"></label>
<p class="error" id="formError" role="alert" hidden></p><button class="button" type="submit">注册</button><p class="form-footer">已有账户？<a href="<%= request.getContextPath() %>/login">登录</a></p></form></main>
<script src="<%= request.getContextPath() %>/assets/auth.js"></script></body></html>
