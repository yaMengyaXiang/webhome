<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/4/8
  Time: 11:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<html>
<head>
    <title>显示用户的资料</title>

    <%@include file="/WEB-INF/jsp/common/static.jsp"%>
    <script src="//cdn.bootcss.com/echarts/3.4.0/echarts.min.js"></script>
    <script src="//cdn.bootcss.com/echarts/3.4.0/extension/dataTool.min.js"></script>

    <script type="text/javascript">


        function resizeMain() {
            var width = $("#rightContainer").width();

            var mainWidth = width - 50;

            $("#main").css("width", mainWidth + "px");

            console.log(mainWidth);

        }

        function initEcharts() {

            var main = document.getElementById('main');

            resizeMain();

            // 基于准备好的dom，初始化echarts实例
            myChart = echarts.init(main);

            myChart.showLoading();

            var otheruserId = "${otherUser.userId}";

            var url = "${pageContext.request.contextPath}/user/getZheTengLinkText.action";

            $.post(url, {"userId": otheruserId}, function (data) {
                console.log(data);
                // 返回的是json格式的字符串，注意！！！此处的json变量仅仅是个字符串，不是json对象
                var json = data.success;
                myChart.hideLoading();
                if (json == "false") {
                    return;
                }
                // 再次转换成json对象
                json = jQuery.parseJSON(json);

                console.log(json.nodes);

                var option = {
                    legend: {
                        data: json.categories.map(function (item) {
                            return item.name;
                        }),
                        orient: 'vertical',
                        left: 0
                    },
                    series: [{
                        type: 'graph',
                        layout: 'force',
                        animation: false,
                        label: {
                            normal: {
                                position: 'right',
                                formatter: '{b}'
                            }
                        },
                        draggable: true,
                        data: json.nodes.map(function (node) {
                            node.symbolSize = 40;
                            return node;
                        }),
                        categories: json.categories,
                        force: {
                            // initLayout: 'circular',
                            edgeLength: 30,
                            repulsion: 1500,
                            gravity: 0.1
                        },
                        edges: json.links
                    }]
                };

                myChart.setOption(option);

            }, "json");


            $(window).resize(function(){
                resizeMain();
                myChart.resize({width: 'auto', height: 'auto'});
            });

        }


        $(function() {

            $(document).foundation();

            initEcharts();

        });


        function preAndNextPage(linkObj, pageNo) {

            var $linkObj = $(linkObj);
            var url = $linkObj.attr("url");

            if ($linkObj.css("cursor") == "not-allowed") {
                return;
            }

            $.post(url, null, function (data) {

                $("#articles").html(data);

            });


        }

    </script>

</head>
<body>


<%@include file="/WEB-INF/jsp/common/header.jsp"%>

<%@include file="/WEB-INF/jsp/common/top-menubar.jsp"%>


<div class="row">
    <div class="padding-10-5-div">
        <div class="large-4 medium-12 columns">
            <div class="padding-10-5-div">
                <div class="bg-white border-1">
                    <div class="header-title-div" style="margin-top: 10px;">
                        <i></i>
                        <a class="titleLink" href="#">Ta的资料</a>
                    </div>
                    <div class="data-list-div">
                        <div style="margin: 20px auto 0px; width: 95%;text-align: center;">
                            <img class="thumbnail" height="95%" width="95%" style="margin-bottom: 15px;" src="${pageContext.request.contextPath}/static/image/05.jpg">
                            <label style="margin-bottom: 10px;font-size: 18px; font-weight: bold;">${otherUser.username}</label>
                            <label style="margin-bottom: 15px;">
                                <i class="fa fa-mars"></i>
                                年龄：1年
                                发帖：200
                            </label>

                            <label style="margin-bottom: 15px; ">
                                个性签名：${otherUser.signature}
                            </label>
                            <button class="button" type="button" style="margin-right: 10px;">关注</button>
                            <button class="button" type="button" style="margin-left: 10px;">私信</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div id="rightContainer" class="large-8 medium-12 columns">
            <div class="padding-10-5-div" style="padding-left: 0px;">

                <ul class="tabs" data-deep-link="true" data-deep-link-smudge-delay="600"
                    data-update-history="true" data-deep-link-smudge="true" data-deep-link-smudge="500" data-tabs id="deeplinked-tabs">
                    <li class="tabs-title is-active"><a href="#zhetengLink" aria-selected="true">Ta的折腾链</a></li>
                    <li class="tabs-title"><a href="#articles">Ta的文章</a></li>
                    <li class="tabs-title"><a href="#panel3v">Tab 3</a></li>
                    <li class="tabs-title"><a href="#panel4v">Tab 4</a></li>
                </ul>

                <div class="tabs-content vertical" data-tabs-content="deeplinked-tabs" style="border: 1px solid #ccccff; border-top: none;">
                    <div class="tabs-panel is-active" id="zhetengLink">

                        <div id="main" style="height: 420px; margin: 0 auto;" ></div>

                    </div>
                    <div class="tabs-panel" id="articles">

                        <c:forEach items="${pageArticles.results}" var="article">
                        <div class="article-list-div">

                            <div class="row" style="font-size: 16px; margin-bottom: 10px;">
                                <a target="_blank"
                                   href="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}">${article.title}</a>
                            </div>
                            <div class="row margin-bottom-1rem">
                                ${fn:substring(article.summary, 0, 100)}
                                <c:set var="sumLen" value="${fn:length(article.summary)}"/>
                                <c:if test="${sumLen > 100 }">...</c:if>
                            </div>
                            <div class="row text-right">
                                发表于：
                                <fmt:formatDate value="${article.publishDate}" type="both"/>
                            </div>

                        </div>
                        </c:forEach>

                        <div class="row">
                            <div class="padding-5-20-div">
                            <c:if test="${!empty pageArticles.results}">
                                <ul class="pagination" role="pagination">

                                    <li>
                                        <a <c:if test="${pageArticles.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                           class="pagination-a"
                                           url="${pageContext.request.contextPath}/user/showOtherUserArticles.action?pageNo=${pageArticles.currentPage-1}&userId=${otherUser.userId}"
                                           href="javascript:void(0);"
                                           onclick="preAndNextPage(this, ${pageArticles.currentPage-1})">&lt;&lt;</a>
                                    </li>

                                    <c:forEach items="${pageNums}" var="pageNum">
                                        <li>
                                            <a <c:if test="${pageNum == pageArticles.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                                               class="pagination-a"
                                               url="${pageContext.request.contextPath}/user/showOtherUserArticles.action?pageNo=${pageNum}&userId=${otherUser.userId}"
                                               href="javascript:void(0);"
                                               onclick="preAndNextPage(this, ${pageNum})">${pageNum}</a>
                                        </li>
                                    </c:forEach>

                                    <li>
                                        <a <c:if test="${pageArticles.currentPage + 1 > pageArticles.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                           class="pagination-a"
                                           url="${pageContext.request.contextPath}/user/showOtherUserArticles.action?pageNo=${pageArticles.currentPage+1}&userId=${otherUser.userId}"
                                           href="javascript:void(0);"
                                           onclick="preAndNextPage(this, ${pageArticles.currentPage+1})">&gt;&gt;</a>
                                    </li>

                                </ul>
                            </c:if>
                            </div>
                        </div>

                    </div>
                    <div class="tabs-panel" id="panel3v">
                        <img class="thumbnail" height="95%" width="95%" src="${pageContext.request.contextPath}/static/image/04.jpg">
                    </div>
                    <div class="tabs-panel" id="panel4v">
                        <p>Loidunt ut labore et dolore magna aliqua.</p>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>



</body>
</html>
