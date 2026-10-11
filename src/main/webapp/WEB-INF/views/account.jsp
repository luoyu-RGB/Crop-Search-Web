<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cropknowledge.web.Html" %>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>我的账户 · 作物知识库</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/site.css">
    </head>
    <body>
        <header class="site-header">
            <a class="brand" href="<%= request.getContextPath() %>/">作物知识库</a>
            <nav>
                <a href="<%= request.getContextPath() %>/search">作物查询</a>
                <a href="<%= request.getContextPath() %>/assistant">AI问答</a>
                <form action="<%= request.getContextPath() %>/logout" method="post">
                    <button class="link-button" type="submit">退出</button>
                </form>
            </nav>
        </header>
        <main class="page">
            <div class="intro">
                <span class="eyebrow">ACCOUNT</span>
                <h1>我的账户</h1>
                <p>你好，<%= Html.escape(session.getAttribute("username")) %></p>
            </div>
            <section class="notice">
                <h2>作物资料</h2>
                <p>按名称、科属、用途和检测数据查找资料。</p>
                <a class="button" href="<%= request.getContextPath() %>/search">开始查询</a>
                <a class="button" href="<%= request.getContextPath() %>/assistant">AI问答</a>
            </section>
        </main>
    </body>
</html>
