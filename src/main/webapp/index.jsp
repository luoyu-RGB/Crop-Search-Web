<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>作物知识库</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/site.css">
    </head>
    <body>
        <header class="site-header">
            <a class="brand" href="<%= request.getContextPath() %>/">作物知识库</a>
            <nav>
                <a href="<%= request.getContextPath() %>/assistant">AI问答</a>
                <% if(session.getAttribute("userId")==null){ %>
                    <a href="<%= request.getContextPath() %>/login">登录</a>
                    <a class="button small" href="<%= request.getContextPath() %>/register">注册</a>
                <% }else{ %>
                    <a href="<%= request.getContextPath() %>/search">作物查询</a>
                    <a href="<%= request.getContextPath() %>/account/">我的账户</a>
                    <% if("ADMIN".equals(session.getAttribute("role"))){ %>
                        <a href="<%= request.getContextPath() %>/admin/">管理后台</a>
                    <% } %>
                    <form action="<%= request.getContextPath() %>/logout" method="post">
                        <button class="link-button" type="submit">退出</button>
                    </form>
                <% } %>
            </nav>
        </header>
        <main class="page">
            <div class="intro">
                <span class="eyebrow">CROP KNOWLEDGE</span>
                <h1>作物知识库</h1>
                <p>作物资料查询与 AI 辅助问答平台</p>
            </div>
            <section class="notice">
                <h2>资料查询</h2>
                <p>先登录后可查询已审核作物资料，并使用 AI 生成带来源页的辅助回答。</p>
                <% if(session.getAttribute("userId")==null){ %>
                    <a class="button" href="<%= request.getContextPath() %>/register">创建账户</a>
                <% }else{ %>
                    <a class="button" href="<%= request.getContextPath() %>/search">开始查询</a>
                    <a class="button" href="<%= request.getContextPath() %>/assistant">打开 AI 问答</a>
                <% } %>
            </section>
        </main>
    </body>
</html>
