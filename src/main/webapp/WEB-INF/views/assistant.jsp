<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cropknowledge.model.DeepSeekAnswer,com.cropknowledge.model.WebSource,com.cropknowledge.web.Html" %>
<%
    String root = request.getContextPath();
    DeepSeekAnswer answer = (DeepSeekAnswer) request.getAttribute("answer");
%>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>AI智能问答 · 作物知识库</title>
        <link rel="stylesheet" href="<%= root %>/assets/site.css">
    </head>
    <body>
        <header class="site-header">
            <a class="brand" href="<%= root %>/">作物知识库</a>
            <nav>
                <a href="<%= root %>/search">作物查询</a>
                <a href="<%= root %>/account/">我的账户</a>
            </nav>
        </header>
        <main class="page">
            <div class="intro">
                <span class="eyebrow">AI</span>
                <h1>资料问答</h1>
                <p>优先使用已审核作物资料；没有匹配资料时联网搜索回答。</p>
            </div>
            <% if(request.getAttribute("error")!=null){ %>
                <p class="error" role="alert"><%= Html.escape(request.getAttribute("error")) %></p>
            <% } %>
            <section class="notice">
                <form method="post" action="<%= root %>/assistant">
                    <label>
                        问题
                        <input name="question" maxlength="300" required value="<%= Html.escape(request.getParameter("question")) %>" placeholder="例如：银杏的主要用途是什么？">
                    </label>
                    <button class="button" type="submit">回答</button>
                </form>
            </section>
            <% if(answer!=null){ %>
                <section class="notice">
                    <h2>回答</h2>
                    <p class="subtle"><%= answer.isDatabaseUsed()?"依据：优先使用已审核作物资料；资料未覆盖处可能使用通用知识。":"依据：联网搜索结果；本次未使用数据库资料，请核对原网页。" %></p>
                    <p style="white-space:pre-line"><%= Html.escape(answer.getText()) %></p>
                    <% if(!answer.getWebSources().isEmpty()){ %>
                        <h3>网页来源</h3>
                        <ol>
                            <% for(WebSource source:answer.getWebSources()){ %>
                                <li>
                                    <a href="<%= Html.escape(source.getUrl()) %>" target="_blank" rel="noopener noreferrer"><%= Html.escape(source.getTitle()) %></a>
                                </li>
                            <% } %>
                        </ol>
                    <% } %>
                    <% if(answer.getCropId()>0){ %>
                        <a href="<%= root %>/crop/detail?id=<%= answer.getCropId() %>">查看作物详情</a>
                    <% } %>
                </section>
            <% } %>
        </main>
    </body>
</html>
