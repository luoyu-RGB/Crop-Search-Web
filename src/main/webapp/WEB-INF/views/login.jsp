<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="zh-CN"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>登录 · 作物知识库</title><link rel="stylesheet" href="<%= request.getContextPath() %>/assets/site.css"></head><body>
<header class="site-header"><a class="brand" href="<%= request.getContextPath() %>/">作物知识库</a><nav><a href="<%= request.getContextPath() %>/register">创建账户</a></nav></header>
<main class="auth-page"><form class="auth-form" method="post" action="<%= request.getContextPath() %>/login"><h1>登录</h1><p class="subtle">访问你的作物知识库账户</p>
<% if (request.getParameter("registered") != null) { %><p class="success">注册成功，请登录。</p><% } %>
<% if (request.getAttribute("error") != null) { %><p class="error" role="alert"><%= request.getAttribute("error") %></p><% } %>
<label>用户名<input name="username" required autocomplete="username"></label>
<label>密码<input name="password" type="password" required autocomplete="current-password"></label>
<button class="button" type="submit">登录</button><p class="form-footer">还没有账户？<a href="<%= request.getContextPath() %>/register">注册</a></p></form></main></body></html>
