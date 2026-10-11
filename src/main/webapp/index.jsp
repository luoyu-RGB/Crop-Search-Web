<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>作物知识库</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/site.css">
</head>
<body>
<header class="site-header"><a class="brand" href="<%= request.getContextPath() %>/">作物知识库</a><nav>
<% if (session.getAttribute("userId") == null) { %>
<a href="<%= request.getContextPath() %>/login">登录</a><a class="button small" href="<%= request.getContextPath() %>/register">注册</a>
<% } else { %>
<a href="<%= request.getContextPath() %>/search">作物查询</a><a href="<%= request.getContextPath() %>/account/">我的账户</a><% if ("ADMIN".equals(session.getAttribute("role"))) { %><a href="<%= request.getContextPath() %>/admin/">管理后台</a><% } %>
<form action="<%= request.getContextPath() %>/logout" method="post"><button class="link-button" type="submit">退出</button></form>
<% } %>
</nav></header>
<main class="page"><div class="intro"><span class="eyebrow">CROP KNOWLEDGE</span><h1>作物知识库</h1><p>作物资料查询平台</p></div>
<section class="notice"><h2>资料查询</h2><p>作物资料正在整理发布。账户功能现已开放，查询功能将在下一阶段上线。</p>
<% if (session.getAttribute("userId") == null) { %><a class="button" href="<%= request.getContextPath() %>/register">创建账户</a><% } else { %><a class="button" href="<%= request.getContextPath() %>/account/">进入我的账户</a><% } %>
</section></main>
</body>
</html>
