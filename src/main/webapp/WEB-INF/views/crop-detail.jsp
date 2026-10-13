<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cropknowledge.model.Crop,com.cropknowledge.web.Html" %>
<%
    Crop crop = (Crop) request.getAttribute("crop");
    String root = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title><%= Html.escape(crop.chineseName) %> · 作物知识库</title>
        <link rel="stylesheet" href="<%= root %>/assets/site.css?v=20261013-ui6">
        <link rel="stylesheet" href="<%= root %>/assets/crop.css?v=20261013-ui6">
    </head>
    <body>
        <header class="site-header">
            <a class="brand" href="<%= root %>/">作物知识库</a>
            <nav>
                <a href="<%= root %>/search">返回查询</a>
                <a href="<%= root %>/account/">我的账户</a>
            </nav>
        </header>
        <main class="page detail-page">
            <a class="back-link" href="<%= root %>/search">← 返回查询</a>
            <div class="intro">
                <span class="eyebrow"><%= Html.escape(crop.family) %> / <%= Html.escape(crop.genus) %></span>
                <h1><%= Html.escape(crop.chineseName) %></h1>
                <p><%= Html.escape(crop.latinName) %>
                <% if(!crop.aliases.isEmpty()){ %>
                     · 别名：<%= Html.escape(String.join("、",crop.aliases)) %>
                <% } %>
                </p>
                <span class="source">来源：课程设计资料 PDF 第 <%= crop.sourcePage %> 页</span>
            </div>
            <% if(!crop.images.isEmpty()){ %>
                <div class="image-strip">
                    <% for(Crop.Image image:crop.images){ %>
                        <figure>
                            <img src="<%= root %>/assets/crops/<%= Html.escape(image.path) %>" alt="<%= Html.escape(image.title==null?crop.chineseName:image.title) %>" loading="lazy">
                            <figcaption><%= Html.escape(image.title) %></figcaption>
                        </figure>
                    <% } %>
                </div>
            <% } %>
            <div class="detail-grid">
                <section>
                    <h2>主要特征</h2>
                    <p><%= Html.escape(crop.features) %></p>
                </section>
                <section>
                    <h2>分布</h2>
                    <p><%= Html.escape(crop.distribution) %></p>
                </section>
                <section>
                    <h2>栽培</h2>
                    <p><%= Html.escape(crop.cultivation) %></p>
                </section>
                <section>
                    <h2>用途</h2>
                    <p><%= Html.escape(crop.uses) %></p>
                </section>
            </div>
            <section class="measurements">
                <h2>样品与化学数据</h2>
                <% if(crop.samples.isEmpty()){ %>
                    <p>暂无检测数据。</p>
                <% }else{ %>
                    <% for(Crop.Sample sample:crop.samples){ %>
                        <div class="sample-row">
                            <div class="sample-head">
                                <strong><%= Html.escape(sample.origin) %></strong><span><%= Html.escape(sample.testPart) %></span>
                            </div>
                            <div class="metrics">
                                <span>含油率 <b><%= sample.oilContent==null?"—":sample.oilContent.stripTrailingZeros().toPlainString()+"%" %></b></span><span>碘值 <b><%= sample.iodineValue==null?"—":sample.iodineValue.stripTrailingZeros().toPlainString() %></b></span><span>酸值 <b><%= sample.acidValue==null?"—":sample.acidValue.stripTrailingZeros().toPlainString() %></b></span><span>皂化值 <b><%= sample.saponificationValue==null?"—":sample.saponificationValue.stripTrailingZeros().toPlainString() %></b></span>
                            </div>
                            <% if(!sample.components.isEmpty()){ %>
                                <div class="components">
                                    <% for(Crop.Component component:sample.components){ %>
                                        <span><%= Html.escape(component.name) %><b><%= component.value.stripTrailingZeros().toPlainString() %>%</b></span>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                <% } %>
            </section>
        </main>
    </body>
</html>
