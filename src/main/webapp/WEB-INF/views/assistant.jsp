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
        <link rel="stylesheet" href="<%= root %>/assets/site.css?v=20261013-ui6">
    </head>
    <body>
        <header class="site-header">
            <a class="brand" href="<%= root %>/">作物知识库</a>
            <nav>
                <a href="<%= root %>/search">作物查询</a>
                <a href="<%= root %>/account/">我的账户</a>
            </nav>
        </header>
        <main class="page assistant-page">
            <div class="intro">
                <span class="eyebrow">AI</span>
                <h1>资料问答</h1>
                <p>优先使用已审核作物资料；没有匹配资料时联网搜索回答。</p>
            </div>
            <% if(request.getAttribute("error")!=null){ %>
                <p class="error" role="alert"><%= Html.escape(request.getAttribute("error")) %></p>
            <% } %>
            <section class="notice ai-question-panel">
                <div class="panel-kicker">ASK THE KNOWLEDGE BASE</div>
                <h2>从作物资料中获取答案</h2>
                <p class="panel-description">输入一个具体问题，系统会优先检索已审核资料，并展示回答来源。</p>
                <form class="question-form" method="post" action="<%= root %>/assistant">
<input type="hidden" name="_csrf" value="<%= com.cropknowledge.web.Html.escape(com.cropknowledge.web.Csrf.token(request)) %>">
                    <label for="question">你的问题</label>
                    <div class="question-row">
                        <input id="question" name="question" maxlength="300" required value="<%= Html.escape(request.getParameter("question")) %>" placeholder="例如：银杏的主要用途是什么？">
                        <button class="button" type="submit">获取答案 <span aria-hidden="true">→</span></button>
                    </div>
                </form>
            </section>
            <% if(answer!=null){ %>
                <section class="notice answer-panel">
                    <div class="answer-heading"><div><div class="panel-kicker">ANSWER</div><h2>回答</h2></div><span class="answer-mark" aria-hidden="true">✓</span></div>
                    <p class="subtle"><%= answer.isDatabaseUsed()?"依据：优先使用已审核作物资料；资料未覆盖处可能使用通用知识。":"依据：联网搜索结果；本次未使用数据库资料，请核对原网页。" %></p>
                    <p style="white-space:pre-line"><%= Html.escape(answer.getText()) %></p>
                    <% if(!answer.getWebSources().isEmpty()){ %>
                        <h3>网页来源</h3>
                        <ol class="source-list">
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
