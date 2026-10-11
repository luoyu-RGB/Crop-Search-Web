<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cropknowledge.model.DeepSeekFieldSuggestion,com.cropknowledge.web.Html" %>
<% String root=request.getContextPath(); DeepSeekFieldSuggestion suggestion=(DeepSeekFieldSuggestion)request.getAttribute("suggestion"); %>
<!DOCTYPE html><html lang="zh-CN"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>DeepSeek OCR 建议 · 管理后台</title><link rel="stylesheet" href="<%=root%>/assets/site.css"><link rel="stylesheet" href="<%=root%>/assets/admin.css"></head><body>
<header class="site-header"><a class="brand" href="<%=root%>/">作物知识库</a><nav><a href="<%=root%>/admin/crops">资料管理</a><a href="<%=root%>/account/">我的账户</a></nav></header>
<main class="page"><div class="intro"><span class="eyebrow">DEEPSEEK OCR</span><h1>OCR 字段建议</h1><p>DeepSeek 只生成候选 JSON，结果必须人工核对后再录入，不会自动发布。</p></div>
<% if(request.getAttribute("error")!=null){ %><p class="error" role="alert"><%=Html.escape(request.getAttribute("error"))%></p><% } %>
<form class="auth-form" method="post" action="<%=root%>/admin/ai-suggest"><label>PDF 来源页码<input name="sourcePage" type="number" min="1" required></label><label>OCR 文本<textarea name="ocrText" rows="14" maxlength="4000" required></textarea></label><button class="button" type="submit">调用 DeepSeek 生成建议</button></form>
<% if(suggestion!=null){ %><section class="notice"><h2>待审核建议（PDF 第 <%=suggestion.getSourcePage()%> 页）</h2><p>以下是 DeepSeek 原始返回，未写入作物表：</p><pre style="white-space:pre-wrap"><%=Html.escape(suggestion.getRawResponse())%></pre></section><% } %>
</main></body></html>
