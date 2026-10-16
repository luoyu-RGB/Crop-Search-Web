<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cropknowledge.web.Html,com.cropknowledge.web.SearchHistoryFormatter,com.cropknowledge.model.SearchRecord,java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>我的账户 · 作物知识库</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/site.css?v=20261016-history">
    </head>
    <body>
        <header class="site-header">
            <a class="brand" href="<%= request.getContextPath() %>/">作物知识库</a>
            <nav>
                <a href="<%= request.getContextPath() %>/search">作物查询</a>
                <a href="<%= request.getContextPath() %>/assistant">AI问答</a>
                <form action="<%= request.getContextPath() %>/logout" method="post">
<input type="hidden" name="_csrf" value="<%= com.cropknowledge.web.Html.escape(com.cropknowledge.web.Csrf.token(request)) %>">
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
        <% List<SearchRecord> searchRecords = (List<SearchRecord>) request.getAttribute("searchRecords"); %>
        <section class="notice search-history">
            <h2>&#26368;&#36817;&#25628;&#32034;</h2>
            <% if (searchRecords == null || searchRecords.isEmpty()) { %>
                <p>&#36824;&#27809;&#26377;&#25628;&#32034;&#35760;&#24405;&#12290;</p>
            <% } else { %>
                <ul>
                    <% int visibleSearchCount = 0; %>
                    <% for (SearchRecord record : searchRecords) { %>
                        <% String displayQuery = SearchHistoryFormatter.display(record.queryText); %>
                        <% if (!displayQuery.isEmpty()) { visibleSearchCount++; %>
                        <li><span><%= Html.escape(displayQuery) %></span><small><%= record.resultCount %> &#26465;&#32467;&#26524;</small></li>
                        <% } %>
                    <% } %>
                    <% if (visibleSearchCount == 0) { %><li class="search-history-empty">还没有有效的搜索记录。</li><% } %>
                </ul>
            <% } %>
        </section>
        </main>
    </body>
</html>
