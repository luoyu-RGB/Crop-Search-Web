<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cropknowledge.model.DeepSeekAnswer,com.cropknowledge.web.Html" %>
<% String root=request.getContextPath(); DeepSeekAnswer answer=(DeepSeekAnswer)request.getAttribute("answer"); %>
<!DOCTYPE html><html lang="zh-CN"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>DeepSeek 智能问答 · 作物知识库</title><link rel="stylesheet" href="<%=root%>/assets/site.css"></head><body>
<header class="site-header"><a class="brand" href="<%=root%>/">作物知识库</a><nav><a href="<%=root%>/search">作物查询</a><a href="<%=root%>/account/">我的账户</a></nav></header>
<main class="page"><div class="intro"><span class="eyebrow">DEEPSEEK AI</span><h1>资料问答</h1><p>DeepSeek 根据匹配到的已审核作物资料生成回答，并附上资料来源页。</p></div>
<% if(request.getAttribute("error")!=null){ %><p class="error" role="alert"><%=Html.escape(request.getAttribute("error"))%></p><% } %>
<section class="notice"><form method="post" action="<%=root%>/assistant"><label>问题<input name="question" maxlength="300" required placeholder="例如：银杏的主要用途是什么？"></label><button class="button" type="submit">使用 DeepSeek 回答</button></form></section>
<% if(answer!=null){ %><section class="notice"><h2><%=answer.getCropId()>0?"回答":"提示"%></h2><p style="white-space:pre-line"><%=Html.escape(answer.getText())%></p><% if(answer.getCropId()>0){ %><a href="<%=root%>/crop/detail?id=<%=answer.getCropId()%>">查看作物详情</a><% }else{ %><a href="<%=root%>/search">查看已发布作物</a><% } %></section><% } %>
</main></body></html>
