<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cropknowledge.web.Html" %>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>登录 · 作物知识库</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/site.css?v=20261013-ui6">
    </head>
    <body>
        <header class="site-header">
            <a class="brand" href="<%= request.getContextPath() %>/">作物知识库</a>
            <nav>
                <a href="<%= request.getContextPath() %>/register">创建账户</a>
            </nav>
        </header>
        <main class="auth-page">
            <form class="auth-form" method="post" action="<%= request.getContextPath() %>/login">
<input type="hidden" name="_csrf" value="<%= com.cropknowledge.web.Html.escape(com.cropknowledge.web.Csrf.token(request)) %>">
                <h1>登录</h1>
                <p class="subtle">使用注册邮箱访问你的作物知识库账户</p>
                <% if (request.getParameter("registered") != null) { %>
                    <p class="success">注册成功，请登录。</p>
                <% } %>
                <% if (request.getAttribute("error") != null) { %>
                    <p class="error" role="alert"><%= Html.escape(request.getAttribute("error")) %></p>
                <% } %>
                <label>
                    邮箱
                    <input name="email" type="email" required maxlength="100" autocomplete="email"
                           value="<%= Html.escape(request.getParameter("email")) %>">
                </label>
                <label>
                    密码
                    <input name="password" type="password" required autocomplete="current-password">
                </label>
                <button class="button" type="submit">登录</button>
                <p class="form-footer">还没有账户？
                <a href="<%= request.getContextPath() %>/register">注册</a>
                </p>
            </form>
        </main>
    </body>
</html>
