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
    var currentNodeId = "";
    var currentNodeIndex = "";
    var currentNodeName = "";
    var keepNodeId = false;

    var currentCategoryId = "";
    var keepCategoryId = false;

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
            console.log(data);
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
            currentNodeIndex = index;
            currentNodeId = zhetengLinkJson.nodes[index].id;
            currentNodeName = params.name;
            console.log("myChart mouseover, currentNodeId: " + currentNodeId);

        });

        myChart.on("mouseout", function(params) {

            console.log("myChart mouseout, currentNodeId: " + currentNodeId);

            var contextMenuVisable = $(".context-menu-list").css("display");
            if (contextMenuVisable == "none") {
                currentNodeIndex = "";
                currentNodeId = "";
                currentNodeName = "";
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
                if (key == "addCategory") {

                    keepCategoryId = false;
                    $("#addCategoryBtn").trigger("click");

                } else if (key == "editCategory") {

                    if (currentCategoryId != "") {
                        keepCategoryId = true;
                        $("#editCategoryBtn").trigger("click");
                    }

                } else if (key == "deleteCategory") {

                    if (currentCategoryId != "") {
                        keepCategoryId = true;
                        $("#deleteCategoryBtn").trigger("click");
                    }

                } else if (key == "editNode") {

                    console.log("currentNodeId: " + currentNodeId);
                    if (currentNodeId != "") {


                        var node = zhetengLinkJson.nodes[currentNodeIndex];
                        var categoryIndex = node.category;
                        var categoryId = zhetengLinkJson.categories[categoryIndex].id;
                        var color = node.itemStyle.normal.color;

                        $("#editNodeName").val(currentNodeName);
                        $("#editNodeColor").attr("value", color);
                        $("#editCategoryId").children("option[value=" + categoryId + "]").attr("selected", "selected");

                        keepNodeId = true;
                        $("#editNodeBtn").trigger("click");
                    }

                } else if (key == "deleteNode") {
                    console.log(currentNodeId);
                    if (currentNodeId != "") {
                        keepNodeId = true;
                        $("#deleteNodeBtn").trigger("click");
                    }

                } else if (key == "addNode") {

                    keepNodeId = false;
                    $("#addNodeBtn").trigger("click");

                }
            },
            events: {
                hide: function (options) {
                    console.log("context menu hide, keepNodeId: " + keepNodeId);
                    if (!keepNodeId) {
                        currentNodeId = "";
                    }
                    console.log("context menu hide, currentNodeId: " + currentNodeId);
                }
            },
            items: {
                "addCategory": {
                    name: "新增类目",
                    icon: "add"
                },
                "editCategory": {
                    name: "编辑类目",
                    icon: "edit"
                },
                "deleteCategory": {
                    name: "删除类目",
                    icon: "delete"
                },
                "sep0": "---------",
                "addNode": {
                    name: "新增节点",
                    icon: "add"
                },
                "editNode": {
                    name: "编辑节点",
                    icon: "edit"
                },
                "deleteNode": {
                    name: "删除节点",
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


        $('#addCategoryColor').colpick({
            colorScheme:'dark',
            submit: false,
            styles: {'z-index': 50000},
            onChange:function(hsb,hex,rgb,el,bySetColor) {
                $(el).val('#'+hex);
            }
        });

        $('#editCategoryColor').colpick({
            colorScheme:'dark',
            submit: false,
            styles: {'z-index': 50000},
            onChange:function(hsb,hex,rgb,el,bySetColor) {
                $(el).val('#'+hex);
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

    function addOrEditCategory(submitFormId) {
        var $form = $("#" + submitFormId);

        console.log($form);

        var categoryName = $form.children(":text[name=categoryName]").val();
        if (categoryName == "") {
            alert("请填写类目名称！");
            return;
        }
        var categoryColor = $form.children(":text[name=categoryColor]").val();
        if (categoryColor == "") {
            alert("请选择颜色！");
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

                var modalId = "addCategoryBtn";

                var param = {
                    "categoryName": categoryName,
                    "categoryColor": categoryColor,
                    "userId": userId
                };

                if (currentNodeId != "") {
                    param.categoryId = currentNodeId;
                    modalId = "editCategoryBtn";
                }

                $.post(url, param, function (data) {

                    $("#" + modalId).trigger("click");
                    $("#mainContent").html(data);

                    refreshNode();

                });

            }
        });

    }


    function addOrEditNode(submitFormId) {
        var $form = $("#" + submitFormId);

        console.log($form);

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

                var modalId = "addNodeBtn";

                var param = {
                    "nodeName": nodeName,
                    "nodeColor": nodeColor,
                    "categoryId": categoryId,
                    "userId": userId
                };

                if (currentNodeId != "") {
                    param.nodeId = currentNodeId;
                    modalId = "editNodeBtn";
                }

                $.post(url, param, function (data) {

                    $("#" + modalId).trigger("click");
                    $("#mainContent").html(data);

                    refreshNode();

                });

            }
        });

    }

    function deleteNodeToSubmit(linkObj) {
        console.log(currentNodeId);
        if (currentNodeId == "") {
            return;
        }

        var url = $(linkObj).attr("url");

        var param = {
            "nodeId": currentNodeId
        };

        $.post(url, param, function (data) {

            $("#deleteNodeBtn").trigger("click");
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

            <div class="context-menu-one btn btn-neutral" id="main" style="height: 420px; margin: 0 auto;" ></div>

            <button id="addCategoryBtn" style="display: none;" data-toggle="addCategoryModal"></button>

            <button id="editCategoryBtn" style="display: none;" data-toggle="editCategoryModal"></button>

            <button id="deleteCategoryBtn" style="display: none;" data-toggle="deleteCategoryModal"></button>

            <div class="tiny reveal" id="addCategoryModal" data-reveal data-close-on-click="true"
                 data-animation-in="slide-in-down">
                <%-- 新增类目 --%>
                <ul class="accordion" data-accordion data-allow-all-closed="true">
                    <li class="accordion-item is-active" data-accordion-item>
                        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                            <i class="fa fa-tags"></i> 新增类目
                        </a>
                        <div class="accordion-content" data-tab-content>
                            <form id="addCategoryForm" action="${pageContext.request.contextPath}/category/addOrEditCategory.action">
                                类目名称：<input type="text" name="categoryName">
                                颜色：<input id="addCategoryColor" value="#000000" type="text" name="categoryColor">

                                <div style="width: 100%; text-align: right;">
                                    <a href="javascript:void(0);" onclick="cancel('addCategoryModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                    <a href="javascript:void(0);" onclick="addOrEditCategory('addCategoryForm')" class="button" style="margin-bottom: 0;" >添加</a>
                                </div>
                            </form>
                        </div>
                    </li>
                </ul>

                <button class="close-button" data-close aria-label="Close" type="button">
                    <%--<span aria-hidden="true">&times;</span>--%>
                </button>

            </div>

            <div class="tiny reveal" id="editCategoryModal" data-reveal data-close-on-click="true"
                 data-animation-in="scale-in-up">
                <%--编辑类目--%>
                <ul class="accordion" data-accordion data-allow-all-closed="true">
                    <li class="accordion-item is-active" data-accordion-item>
                        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                            <i class="fa fa-tags"></i>
                            编辑类目
                        </a>
                        <div class="accordion-content" data-tab-content>
                            <form id="editCategoryForm" action="${pageContext.request.contextPath}/category/addOrEditCategory.action">
                                类目名称：<input id="editCategoryName" type="text" name="categoryName">
                                颜色：<input id="editCategoryColor" value="#000000" type="text" name="categoryColor">

                                <div style="width: 100%; text-align: right;">
                                    <a href="javascript:void(0);" onclick="cancel('editCategoryModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                    <a href="javascript:void(0);" onclick="addOrEditCategory('editCategoryForm')" class="button" style="margin-bottom: 0;" >提交更改</a>
                                </div>
                            </form>
                        </div>
                    </li>
                </ul>

                <button class="close-button" data-close aria-label="Close" type="button">
                    <%--<span aria-hidden="true">&times;</span>--%>
                </button>

            </div>

            <div class="tiny reveal" id="deleteCategoryModal" data-reveal data-close-on-click="true"
                 data-animation-in="scale-in-up">

                <ul class="accordion" data-accordion data-allow-all-closed="true">
                    <li class="accordion-item is-active" data-accordion-item>
                        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                            <i class="fa fa-tags"></i>
                            删除类目
                        </a>
                        <div class="accordion-content" data-tab-content>
                            <form id="deleteCategoryForm">
                                <label style="font-size: 16px; color: red;">确定要删除该类目吗 ?</label>
                                <div style="width: 100%; text-align: right;">
                                    <a href="javascript:void(0);" onclick="cancel('deleteCategoryModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                    <a url="${pageContext.request.contextPath}/category/deleteCategory.action"
                                       href="javascript:void(0);" onclick="deleteCategoryToSubmit(this)" class="button" style="margin-bottom: 0;" >确定</a>
                                </div>
                            </form>
                        </div>
                    </li>
                </ul>

                <button class="close-button" data-close aria-label="Close" type="button">
                    <%--<span aria-hidden="true">&times;</span>--%>
                </button>
            </div>



            <button id="addNodeBtn" style="display: none;" data-toggle="addNodeModal"></button>

            <button id="editNodeBtn" style="display: none;" data-toggle="editNodeModal"></button>

            <button id="deleteNodeBtn" style="display: none;" data-toggle="deleteNodeModal"></button>

            <div class="tiny reveal" id="addNodeModal" data-reveal data-close-on-click="true"
                 data-animation-in="scale-in-up">
                <%-- 新增节点 --%>
                <ul class="accordion" data-accordion data-allow-all-closed="true">
                    <li class="accordion-item is-active" data-accordion-item>
                        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                            <i class="fa fa-tags"></i> 新增节点
                        </a>
                        <div class="accordion-content" data-tab-content>
                            <form id="addNodeForm" action="${pageContext.request.contextPath}/node/addOrEditNode.action">
                                节点名称：<input type="text" name="nodeName">
                                颜色：<input id="addNodeColor" value="#000000" type="text" name="nodeColor">
                                所属类目：
                                <select name="categoryId">
                                    <option value="">请选择</option>
                                    <c:forEach items="${categories}" var="category">
                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                    </c:forEach>
                                </select>

                                <div style="width: 100%; text-align: right;">
                                    <a href="javascript:void(0);" onclick="cancel('addNodeModal')" class="button" style="margin-bottom: 0;" >取消</a>
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

            <div class="tiny reveal" id="editNodeModal" data-reveal data-close-on-click="true"
                 data-animation-in="scale-in-up">
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
                                颜色：<input id="editNodeColor" value="#000000" type="text" name="nodeColor">
                                所属类目：
                                <select id="editCategoryId" name="categoryId">
                                    <option value="">请选择</option>
                                    <c:forEach items="${categories}" var="category">
                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                    </c:forEach>
                                </select>

                                <div style="width: 100%; text-align: right;">
                                    <a href="javascript:void(0);" onclick="cancel('editNodeModal')" class="button" style="margin-bottom: 0;" >取消</a>
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

            <div class="tiny reveal" id="deleteNodeModal" data-reveal data-close-on-click="true"
                 data-animation-in="scale-in-up">

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
                                    <a href="javascript:void(0);" onclick="cancel('deleteNodeModal')" class="button" style="margin-bottom: 0;" >取消</a>
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