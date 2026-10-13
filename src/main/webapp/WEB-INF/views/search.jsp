<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cropknowledge.model.*,com.cropknowledge.web.Html,java.util.*" %>
<%
    CropPage result = (CropPage) request.getAttribute("page");
    String root = request.getContextPath();
    String[] filterFields = request.getParameterValues("filterField");
    String[] filterValues = request.getParameterValues("filterValue");
    String[][] textOptions = {
        {"family", "科"}, {"genus", "属"}, {"features", "特征"},
        {"distribution", "分布地区"}, {"cultivation", "栽培"}, {"uses", "用途"}
    };
    Map<String, List<String>> filterOptions =
        (Map<String, List<String>>) request.getAttribute("filterOptions");
    if (filterOptions == null) filterOptions = Collections.emptyMap();
%>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>作物查询 · 作物知识库</title>
        <link rel="stylesheet" href="<%= root %>/assets/site.css?v=20261013-ui6">
        <link rel="stylesheet" href="<%= root %>/assets/crop.css?v=20261013-ui6">
        <link rel="stylesheet" href="<%= root %>/assets/search-form.css?v=20261013-ui6">
    </head>
    <body>
        <header class="site-header">
            <a class="brand" href="<%= root %>/">作物知识库</a>
            <nav>
                <a href="<%= root %>/assistant">AI问答</a>
                <a href="<%= root %>/account/">我的账户</a>
                <form method="post" action="<%= root %>/logout">
                    <button class="link-button">退出</button>
                </form>
            </nav>
        </header>
        <main class="page search-page">
            <div class="intro">
                <span class="eyebrow">CROP SEARCH</span>
                <h1>作物查询</h1>
                <p>按名称、形态、分布和油脂数据组合筛选</p>
            </div>
            <form class="search-form" method="get" action="<%= root %>/search">
                <div class="search-section">
                    <h2>按名称搜索</h2>
                    <label class="name-search">
                        名称或别名
                        <input name="name" value="<%= Html.escape(request.getParameter("name")) %>" placeholder="输入中文名、英文名、拉丁学名或别名">
                    </label>
                </div>
                <div class="search-section">
                    <h2>组合查询</h2>
                    <div class="condition-list" id="condition-list">
                        <%
                            for (int i = 0; i < 3; i++) {
                                String field = filterFields != null && i < filterFields.length
                                    ? filterFields[i] : "";
                                String value = filterValues != null && i < filterValues.length
                                    ? filterValues[i] : "";
                        %>
                            <div class="condition-row">
                                <label>
                                    条件 <%= i+1 %>
                                    <select name="filterField">
                                        <option value="">选择字段</option>
                                        <% for(String[] option:textOptions){ %>
                                            <option value="<%= option[0] %>" <%= option[0].equals(field)?"selected":"" %>><%= option[1] %></option>
                                        <% } %>
                                    </select>
                                </label>
                                <label>
                                    选择内容
                                    <select name="filterValue">
                                        <option value="">不限</option>
                                        <% for(String choice:filterOptions.getOrDefault(field,Collections.emptyList())){ %>
                                            <option value="<%= Html.escape(choice) %>" <%= choice.equals(value)?"selected":"" %>><%= Html.escape(choice) %></option>
                                        <% } %>
                                    </select>
                                </label>
                            </div>
                        <% } %>
                        <% for(Map.Entry<String,List<String>> entry:filterOptions.entrySet()){ %>
                            <select class="filter-option-source" data-field="<%= Html.escape(entry.getKey()) %>" hidden disabled>
                                <% for(String choice:entry.getValue()){ %>
                                    <option value="<%= Html.escape(choice) %>"><%= Html.escape(choice) %></option>
                                <% } %>
                            </select>
                        <% } %>
                    </div>
                </div>
                <div class="search-section">
                    <h2>数值范围</h2>
                    <div class="range-grid">
                        <%
                            String[][] ranges = {
                                {"Oil", "含油率 %"}, {"Iodine", "碘值"},
                                {"Acid", "酸值"}, {"Saponification", "皂化值"}
                            };
                            for (String[] range : ranges) {
                        %>
                            <div class="range-row">
                                <span><%= range[1] %></span>
                                <input type="number" step="any" min="0" name="min<%= range[0] %>" value="<%= Html.escape(request.getParameter("min"+range[0])) %>" placeholder="最小">
                                <span>至</span>
                                <input type="number" step="any" min="0" name="max<%= range[0] %>" value="<%= Html.escape(request.getParameter("max"+range[0])) %>" placeholder="最大">
                            </div>
                        <% } %>
                        <div class="range-row">
                            <label>
                                脂肪酸
                                <select name="component">
                                    <option value="">不限</option>
                                    <% for(String part:new String[]{"C12:0","C14:0","C16:0","C16:1","C18:0","C18:1","C18:2","C18:3","C20:0","C20:1"}){ %>
                                        <option value="<%= part %>" <%= part.equals(request.getParameter("component"))?"selected":"" %>><%= part %></option>
                                    <% } %>
                                </select>
                            </label>
                            <input type="number" step="any" min="0" name="minComponent" value="<%= Html.escape(request.getParameter("minComponent")) %>" placeholder="最小 %">
                            <span>至</span>
                            <input type="number" step="any" min="0" name="maxComponent" value="<%= Html.escape(request.getParameter("maxComponent")) %>" placeholder="最大 %">
                        </div>
                    </div>
                </div>
                <div class="search-actions">
                    <div class="segment">
                        <label>
                            <input type="radio" name="match" value="all" <%= !"any".equals(request.getParameter("match"))?"checked":"" %>>
                            组合条件满足全部
                        </label>
                        <label>
                            <input type="radio" name="match" value="any" <%= "any".equals(request.getParameter("match"))?"checked":"" %>>
                            组合条件满足任意
                        </label>
                    </div>
                    <% if("ADMIN".equals(session.getAttribute("role"))){ %>
                        <label class="check">
                            <input type="checkbox" name="preview" value="true" <%= "true".equals(request.getParameter("preview"))?"checked":"" %>>
                            包含待审核资料
                        </label>
                    <% } %>
                    <button class="button" type="submit">查询</button>
                    <a href="<%= root %>/search">清空</a>
                </div>
            </form>
            <% if(request.getAttribute("error")!=null){ %>
                <p class="error" role="alert"><%= Html.escape(request.getAttribute("error")) %></p>
            <% } %>
            <% if(result!=null){ %>
                <section class="results">
                    <div class="result-head">
                        <h2>查询结果 <small><%= result.total %> 条</small></h2>
                        <div class="fields" id="fields">
                            <span>显示字段</span>
                            <label>
                                <input type="checkbox" data-col="latin" checked>
                                学名
                            </label>
                            <label>
                                <input type="checkbox" data-col="alias">
                                别名
                            </label>
                            <label>
                                <input type="checkbox" data-col="family" checked>
                                科属
                            </label>
                            <label>
                                <input type="checkbox" data-col="text">
                                特征
                            </label>
                            <label>
                                <input type="checkbox" data-col="oil" checked>
                                油脂指标
                            </label>
                            <label>
                                <input type="checkbox" data-col="page">
                                来源页
                            </label>
                        </div>
                    </div>
                    <% if(result.crops.isEmpty()){ %>
                        <div class="empty-state">
                            没有符合条件的已发布作物资料。
                        </div>
                    <% }else{ %>
                        <div class="table-scroll">
                            <table class="crop-table">
                                <thead>
                                    <tr>
                                        <th>作物</th>
                                        <th data-col="latin">拉丁学名</th>
                                        <th data-col="alias">别名</th>
                                        <th data-col="family">科 / 属</th>
                                        <th data-col="text">特征</th>
                                        <th data-col="oil">油脂指标</th>
                                        <th data-col="page">来源页</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(Crop crop:result.crops){ %>
                                        <tr>
                                            <td>
                                            <a class="crop-name" href="<%= root %>/crop/detail?id=<%= crop.id %>"><%= Html.escape(crop.chineseName) %></a>
                                            <% if(!"APPROVED".equals(crop.reviewStatus)){ %>
                                                <span class="pending">待审核</span>
                                            <% } %>
                                            </td>
                                            <td data-col="latin"><%= Html.escape(crop.latinName) %></td>
                                            <td data-col="alias"><%= Html.escape(crop.aliasSummary) %></td>
                                            <td data-col="family"><%= Html.escape(crop.family) %> / <%= Html.escape(crop.genus) %></td>
                                            <td data-col="text"><%= Html.escape(crop.features==null?"":crop.features.length()>48?crop.features.substring(0,48)+"…":crop.features) %></td>
                                            <td data-col="oil">含油 <%= crop.maxOilContent==null?"—":crop.maxOilContent.stripTrailingZeros().toPlainString()+"%" %><br>碘值 <%= crop.maxIodineValue==null?"—":crop.maxIodineValue.stripTrailingZeros().toPlainString() %></td>
                                            <td data-col="page"><%= crop.sourcePage %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <div class="pagination">
                            <%
                                String raw = request.getQueryString();
                                String base = raw == null ? "" : raw.replaceAll("(^|&)page=[^&]*", "")
                                    .replaceAll("^&|&$", "");
                                if (!base.isEmpty()) base += "&";
                                if (result.page > 1) {
                            %>
                                <a href="<%= root %>/search?<%= Html.escape(base) %>page=<%= result.page-1 %>">上一页</a>
                            <% } %>
                            <span>第 <%= result.page %> / <%= result.pageCount() %> 页</span>
                            <% if(result.page<result.pageCount()){ %>
                                <a href="<%= root %>/search?<%= Html.escape(base) %>page=<%= result.page+1 %>">下一页</a>
                            <% } %>
                        </div>
                    <% } %>
                </section>
            <% } %>
        </main>
        <script src="<%= root %>/assets/search.js?v=20261010-2"></script>
    </body>
</html>
