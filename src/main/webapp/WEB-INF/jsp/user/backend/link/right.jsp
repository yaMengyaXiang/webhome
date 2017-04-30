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

<link href="//cdn.bootcss.com/jquery-contextmenu/2.4.4/jquery.contextMenu.min.css" rel="stylesheet">
<script src="//cdn.bootcss.com/jquery-contextmenu/2.4.4/jquery.contextMenu.min.js"></script>

<link href="${pageContext.request.contextPath}/static/css/colpick.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/colpick.js"></script>

<script type="text/javascript">

    var zhetengLinkJson = "";
    var nodeId = "";
    var nodeIndex = "";
    var nodeName = "";

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

            // 返回的是json格式的字符串，注意！！！此处的json变量仅仅是个字符串，不是json对象
            var json = data.success;
            myChart.hideLoading();
            if (json == "false") {
                return;
            }
            // 再次转换成json对象
            json = jQuery.parseJSON(json);

            zhetengLinkJson = json;

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
                        repulsion: 1200,
                        gravity: 0.1
                    },
                    edges: json.links
                }]
            };

            myChart.setOption(option);

        }, "json");

        myChart.on("mouseover", function(params) {
            var index = params.dataIndex;
            nodeIndex = index;
            nodeId = zhetengLinkJson.nodes[index].id;
            nodeName = params.name;

        });

        myChart.on("mouseout", function(params) {

            var contextMenuVisable = ($(".context-menu-list").css("display"));
            if (contextMenuVisable == "none") {
                nodeIndex = "";
                nodeId = "";
                nodeName = "";
            }
        });


        $(window).resize(function(){
            resizeMain();
            myChart.resize({width: 'auto', height: 'auto'});
        });

    }

    $(function() {

        $(document).foundation();

        initEcharts();

        $.contextMenu({
            selector: '.context-menu-one',
            callback: function (key, options) {
                if (key == "edit") {
                    console.log(nodeId);

                    if (nodeId != "") {

                        console.log(zhetengLinkJson);
                        console.log(nodeIndex);
                        var node = zhetengLinkJson.nodes[nodeIndex];
                        console.log(node);
                        var categoryIndex = node.category;
                        var categoryId = zhetengLinkJson.categories[categoryIndex].id;
                        var color = node.itemStyle.normal.color;

                        console.log(categoryId);
                        console.log(color);

                        $("#editNodeName").val(nodeName);
                        $("#editNodeColor").attr("value", color);
                        $("#editCategoryId").children("option[value=" + categoryId + "]").attr("selected", "selected");

                        $("#editBtn").trigger("click");
                    }

                } else if (key == "delete") {
                    console.log(nodeId);
                    if (nodeId != "") {
                        $("#deleteBtn").trigger("click");
                    }

                } else if (key == "add") {

                    $("#addBtn").trigger("click");

                }
            },
            events: {
                hide: function (options) {
                    nodeId = "";
                }
            },
            items: {
                "add": {
                    name: "新增",
                    icon: "add"
                },
                "edit": {
                    name: "编辑",
                    icon: "edit"
                },
                "delete": {
                    name: "删除",
                    icon: "delete"
                },
                "sep1": "---------",
                "quit": {
                    name: "关闭",
                    icon: function(){
                        return 'context-menu-icon context-menu-icon-quit';
                    }
                }
            }
        });


        $('#addNodeColor').colpick({
            colorScheme:'dark',
            submit: false,
            styles: {'z-index': 50000},
            onChange:function(hsb,hex,rgb,el,bySetColor) {
                $(el).val('#'+hex);
            }
        });

        $('#editNodeColor').colpick({
            colorScheme:'dark',
            submit: false,
            styles: {'z-index': 50000},
            onChange:function(hsb,hex,rgb,el,bySetColor) {
                $(el).val('#'+hex);
            }
        });


    });


    function cancel(modalId) {
        $("#" + modalId + " > button:first").trigger("click");
    }

    function addNodeToSubmit(submitFormId) {

        var $form = $("#" + submitFormId);

        var nodeName = $form.find(":text[name=nodeName]").val();
        if (nodeName == "") {
            alert("请填写节点名称！");
            return;
        }
        var nodeColor = $form.find(":text[name=nodeColor]").val();
        if (nodeColor == "") {
            alert("请选择颜色！");
            return;
        }

        var categoryId = $form.find("select[name=categoryId] option:selected").attr("value");
        if (categoryId == "") {
            alert("请选择类目！");
            return;
        }

        var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

        // 获取当前登录用户的id
        $.post(getCurrentUserIdUrl, null, function (data) {
            var json = jQuery.parseJSON(data);

            var userId = json.userId;

            if (userId == "null") {
                alert("亲，您还未登录呢");

            } else {

                var url = $form.attr("action");

                var param = {
                    "nodeName": nodeName,
                    "nodeColor": "#" + nodeColor,
                    "categoryId": categoryId,
                    "userId": userId
                };

                $.post(url, param, function (data) {

                    $("#mainContent").html(data);

                    refreshNode();

                });

            }
        });

    }

    function addOrEditNode(submitFormId) {
        var $form = $("#" + submitFormId);

        alert($form);
        console.log($form);

//        var nodeName = $form.find(":text[name=nodeName]").val();
        var nodeName = $form.children(":text[name=nodeName]").val();
        if (nodeName == "") {
            alert("请填写节点名称！");
            return;
        }
        var nodeColor = $form.children(":text[name=nodeColor]").val();
        if (nodeColor == "") {
            alert("请选择颜色！");
            return;
        }

        var categoryId = $form.children("select[name=categoryId]").children("option:selected").attr("value");
        if (categoryId == "") {
            alert("请选择类目！");
            return;
        }

        var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

        // 获取当前登录用户的id
        $.post(getCurrentUserIdUrl, null, function (data) {
            var json = jQuery.parseJSON(data);

            var userId = json.userId;

            if (userId == "null") {
                alert("亲，您还未登录呢");

            } else {

                var url = $form.attr("action");

                var param = {
                    "nodeName": nodeName,
                    "nodeColor": nodeColor,
                    "categoryId": categoryId,
                    "userId": userId
                };

                if (nodeId != "") {
                    param.nodeId = nodeId;
                }

                $.post(url, param, function (data) {

                    $("#mainContent").html(data);

                    refreshNode();

                });

            }
        });

    }

    function editNodeToSubmit(submitFormId) {
        var $form = $("#" + submitFormId);

        var nodeName = $form.find(":text[name=nodeName]").val();
        if (nodeName == "") {
            alert("请填写节点名称！");
            return;
        }
        var nodeColor = $form.find(":text[name=nodeColor]").val();
        if (nodeColor == "") {
            alert("请选择颜色！");
            return;
        }

        var categoryId = $form.find("select[name=categoryId] option:selected").attr("value");
        if (categoryId == "") {
            alert("请选择类目！");
            return;
        }

        var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

        // 获取当前登录用户的id
        $.post(getCurrentUserIdUrl, null, function (data) {
            var json = jQuery.parseJSON(data);

            var userId = json.userId;

            if (userId == "null") {
                alert("亲，您还未登录呢");

            } else {

                var url = $form.attr("action");

                var param = {
                    "nodeName": nodeName,
                    "nodeColor": "#" + nodeColor,
                    "categoryId": categoryId,
                    "userId": userId
                };

                $.post(url, param, function (data) {

                    $("#mainContent").html(data);

                    refreshNode();

                });

            }
        });
    }

    function deleteNodeToSubmit(linkObj) {
        if (nodeId == "") {
            return;
        }

        var url = $(linkObj).attr("url");

        var param = {
            "nodeId": nodeId
        };

        $.post(url, param, function (data) {

            $("#mainContent").html(data);

            refreshNode();

        });

    }

    function refreshCategory() {

        var url = "${pageContext.request.contextPath}/category/showAllCategories.action";

        $.post(url, null, function (data) {
            $("#addNodeDiv").html(data);
        });

    }

    function refreshNode() {

        var url = "${pageContext.request.contextPath}/node/showAllNodes.action";

        $.post(url, null, function (data) {
            $("#addLinkDiv").html(data);
        });

    }

</script>


<ul class="accordion" data-accordion data-allow-all-closed="true">
    <li class="accordion-item is-active" data-accordion-item>

        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
            <i class="fa fa-object-ungroup"></i>
            我的折腾链
        </a>

        <div class="accordion-content" data-tab-content>

            <div class="context-menu-one btn btn-neutral" id="main" style="height: 450px; margin: 0 auto;" ></div>

            <!-- 按钮触发模态框 -->
            <button id="addBtn" style="display: none;" data-toggle="addModal"></button>

            <!-- 按钮触发模态框 -->
            <button id="editBtn" style="display: none;" data-toggle="editModal"></button>

            <button id="deleteBtn" style="display: none;" data-toggle="deleteModal"></button>

            <div class="reveal" id="addModal" data-reveal data-close-on-click="true"
                 data-animation-in="scale-in-up" data-animation-out="scale-out-down">
                <%-- 新增节点 --%>
                <ul class="accordion" data-accordion data-allow-all-closed="true">
                    <li class="accordion-item is-active" data-accordion-item>
                        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                            <i class="fa fa-tags"></i> 新增节点
                        </a>
                        <div class="accordion-content" data-tab-content>
                            <form id="addNodeForm" action="${pageContext.request.contextPath}/node/addOrEditNode.action">
                                节点名称：<input type="text" name="nodeName">
                                颜色：<input id="addNodeColor" value="ddffdd" type="text" name="nodeColor">
                                所属类目：
                                <select name="categoryId">
                                    <option value="">请选择</option>
                                    <c:forEach items="${categories}" var="category">
                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                    </c:forEach>
                                </select>

                                <div style="width: 100%; text-align: right;">
                                    <a href="javascript:void(0);" onclick="cancel('addModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                    <a href="javascript:void(0);" onclick="addOrEditNode('addNodeForm')" class="button" style="margin-bottom: 0;" >添加</a>
                                </div>
                            </form>
                        </div>
                    </li>
                </ul>

                <button class="close-button" data-close aria-label="Close" type="button">
                    <%--<span aria-hidden="true">&times;</span>--%>
                </button>

            </div>

            <div class="reveal" id="editModal" data-reveal data-close-on-click="true"
                 data-animation-in="scale-in-up" data-animation-out="scale-out-down">
                <%--编辑节点--%>
                <ul class="accordion" data-accordion data-allow-all-closed="true">
                    <li class="accordion-item is-active" data-accordion-item>
                        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                            <i class="fa fa-tags"></i>
                            编辑节点
                        </a>
                        <div class="accordion-content" data-tab-content>
                            <form id="editNodeForm" action="${pageContext.request.contextPath}/node/addOrEditNode.action">
                                节点名称：<input id="editNodeName" type="text" name="nodeName">
                                颜色：<input id="editNodeColor" value="" type="text" name="nodeColor">
                                所属类目：
                                <select id="editCategoryId" name="categoryId">
                                    <option value="">请选择</option>
                                    <c:forEach items="${categories}" var="category">
                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                    </c:forEach>
                                </select>

                                <div style="width: 100%; text-align: right;">
                                    <a href="javascript:void(0);" onclick="cancel('editModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                    <a href="javascript:void(0);" onclick="addOrEditNode('editNodeForm')" class="button" style="margin-bottom: 0;" >提交更改</a>
                                </div>
                            </form>
                        </div>
                    </li>
                </ul>

                <button class="close-button" data-close aria-label="Close" type="button">
                    <%--<span aria-hidden="true">&times;</span>--%>
                </button>

            </div>

            <div class="reveal" id="deleteModal" data-reveal data-close-on-click="true"
                 data-animation-in="scale-in-up" data-animation-out="scale-out-down">

                <ul class="accordion" data-accordion data-allow-all-closed="true">
                    <li class="accordion-item is-active" data-accordion-item>
                        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                            <i class="fa fa-tags"></i>
                            删除节点
                        </a>
                        <div class="accordion-content" data-tab-content>
                            <form id="deleteNodeForm">
                                <label style="font-size: 16px; color: red;">确定要删除该节点吗 ?</label>
                                <div style="width: 100%; text-align: right;">
                                    <a href="javascript:void(0);" onclick="cancel('deleteModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                    <a url="${pageContext.request.contextPath}/node/deleteNode.action"
                                       href="javascript:void(0);" onclick="deleteNodeToSubmit(this)" class="button" style="margin-bottom: 0;" >确定</a>
                                </div>
                            </form>
                        </div>
                    </li>
                </ul>

                <button class="close-button" data-close aria-label="Close" type="button">
                    <%--<span aria-hidden="true">&times;</span>--%>
                </button>
            </div>

        </div>
    </li>
</ul>