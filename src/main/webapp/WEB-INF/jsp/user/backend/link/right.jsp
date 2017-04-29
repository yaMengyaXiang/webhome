<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-30
  Time: 0:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script src="//cdn.bootcss.com/echarts/3.4.0/echarts.min.js"></script>
<script src="//cdn.bootcss.com/echarts/3.4.0/extension/dataTool.min.js"></script>

<script type="text/javascript">

    function resizeMain() {
        var width = $("#mainContent").width();

        var mainWidth = width - 50;

        $("#main").css("width", mainWidth + "px");

        console.log(mainWidth);

    }

    function initEcharts() {

        var main = document.getElementById('main');

        resizeMain();

        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(main);

        myChart.showLoading();

        var url = "${pageContext.request.contextPath}/user/getZheTengLinkText.action";

        $.post(url, null, function (data) {

            // 返回的是json格式的字符串
            var json = data;

            myChart.hideLoading();

            console.log(json);

            var option = {
                legend: {
                    data: ['Java', 'JavaSE', 'JavaEE', 'JavaScript', 'jQuery'],
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
                    data: json.nodes.map(function (node, idx) {
                        node.id = idx;
                        node.symbolSize = 35;
                        return node;
                    }),
                    categories: json.categories,
                    force: {
                        // initLayout: 'circular',
                        edgeLength: 10,
                        repulsion: 1000,
                        gravity: 0.1
                    },
                    edges: json.links
                }]
            };

            myChart.setOption(option);

        }, 'json');

        myChart.on("dblclick", function(params) {
            alert(params.name);
        });


        $(window).resize(function(){
            resizeMain();
            myChart.resize({width: 'auto', height: 'auto'});
        });

    }

    $(function() {

        $(document).foundation();

        initEcharts();

    });


</script>


<ul class="accordion" data-accordion data-allow-all-closed="true">
    <li class="accordion-item is-active" data-accordion-item>

        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
            <i class="fa fa-object-ungroup"></i>
            我的折腾链
        </a>

        <div class="accordion-content" data-tab-content>

            <div id="main" style="height: 480px; margin: 0 auto;" ></div>

        </div>
    </li>
</ul>