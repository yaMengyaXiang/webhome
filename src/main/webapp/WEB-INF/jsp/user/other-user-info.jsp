<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/4/8
  Time: 11:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        }

        function initEcharts() {

            var main = document.getElementById('main');

            resizeMain();

            // 基于准备好的dom，初始化echarts实例
            var myChart = echarts.init(main);

            myChart.showLoading();

            $.get('1.gexf', function (xml) {
                myChart.hideLoading();

                var graph = echarts.dataTool.gexf.parse(xml);
                var categories = [];
                for (var i = 0; i < 8; i++) {
                    categories[i] = {
                        name: '类目' + i
                    };
                }
                graph.nodes.forEach(function (node) {
                    node.itemStyle = null;
                    node.symbolSize = 35;
                    node.value = node.symbolSize;
                    node.category = node.attributes.modularity_class;
                    // Use random x, y
                    node.x = node.y = null;
                    node.draggable = true;
                });
                var option = {
                    tooltip: {
                        show: true,
                        showContent: true,
                        formatter: '{b}'
                    },
                    legend: [{
                        data: categories.map(function (a) {
                            return a.name;
                        }),

                        left: 'center'
                    }],
                    animation: false,
                    series : [
                        {
                            type: 'graph',
                            layout: 'force',
                            data: graph.nodes,
                            links: graph.links,
                            categories: categories,
                            roam: false,
                            label: {
                                normal: {
                                    show: false,
                                    position: 'right'
                                }
                            },
                            force: {
                                repulsion: 1200,
                                focusNodeAdjacency: false,
                                symbol: "circle"
                            }
                        }
                    ]
                };

                myChart.setOption(option);
            }, 'xml');

            myChart.on("dblclick", function(params) {
                alert(params.name);
            });


            $(window).resize(function(){
                resizeMain();
                myChart.resize();
            });

        }

        $(function() {

            $(document).foundation();

            initEcharts();

        });


    </script>

</head>
<body>


<%@include file="/WEB-INF/jsp/common/header.jsp"%>

<%@include file="/WEB-INF/jsp/common/menubar.jsp"%>


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
                        <div style="margin: 20px auto 0px;; width: 95%;text-align: center;">
                            <img class="thumbnail" height="200px" width="200px" style="margin-bottom: 15px;" src="../image/avatar.jpg">
                            <label style="margin-bottom: 10px;font-size: 18px; font-weight: bold;">追梦的自学者</label>
                            <label style="margin-bottom: 15px;">
                                <i class="fa fa-mars"></i>
                                年龄：1年
                                发帖：200
                            </label>

                            <label style="margin-bottom: 15px; ">
                                个性签名：我能够作为自己活着，真是太好了 !!!
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
                    <li class="tabs-title is-active"><a href="#panel1v" aria-selected="true">Ta的技能链</a></li>
                    <li class="tabs-title"><a href="#panel2v">Ta的文章</a></li>
                    <li class="tabs-title"><a href="#panel3v">Tab 3</a></li>
                    <li class="tabs-title"><a href="#panel4v">Tab 4</a></li>
                </ul>

                <div class="tabs-content vertical" data-tabs-content="deeplinked-tabs" style="border: 1px solid #ccccff;">
                    <div class="tabs-panel is-active" id="panel1v">

                        <div id = "main" style="height: 400px; margin: 0 auto;" ></div>

                    </div>
                    <div class="tabs-panel" id="panel2v">

                        <div class="article-list-div">

                            <div class="row">
                                <a href="#">htmlunit 获取指定元素</a>
                            </div>
                            <div class="row">
                                摘要: htmlunit 提供了丰富的api来获取指定元素 jsoup有的 htmlunit也有；
                                我们这里举例：package com.open1111;import java.io.IOException;
                                import java.net.MalformedURLException;import com.gargo...
                            </div>
                            <div class="row text-right">
                                发表于：2017年4月7日
                            </div>

                        </div>
                        <div class="article-list-div">

                            <div class="row">
                                <a href="#">htmlunit 获取指定元素</a>
                            </div>
                            <div class="row">
                                摘要: htmlunit 提供了丰富的api来获取指定元素 jsoup有的 htmlunit也有；
                                我们这里举例：package com.open1111;import java.io.IOException;
                                import java.net.MalformedURLException;import com.gargo...
                            </div>
                            <div class="row text-right">
                                发表于：2017年4月7日
                            </div>

                        </div>
                        <div class="article-list-div">

                            <div class="row">
                                <a href="#">htmlunit 获取指定元素</a>
                            </div>
                            <div class="row">
                                摘要: htmlunit 提供了丰富的api来获取指定元素 jsoup有的 htmlunit也有；
                                我们这里举例：package com.open1111;import java.io.IOException;
                                import java.net.MalformedURLException;import com.gargo...
                            </div>
                            <div class="row text-right">
                                发表于：2017年4月7日
                            </div>

                        </div>

                    </div>
                    <div class="tabs-panel" id="panel3v">
                        <img class="thumbnail" src="../image/01.jpg">
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
