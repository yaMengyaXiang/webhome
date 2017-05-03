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
    var currentNodeColor = "";
    var keepNodeId = false;

    var linkSourceNodeId = "";
    var linkTargetNodeId = "";

    var linkSourceNodeName = "";
    var linkTargetNodeName = "";

    var currentCategoryId = "";
    var keepCategoryId = false;

    var isNode = false;
    var isTryToLink = false;
    var isLink = false;

    var linkAlert = true;

    var currentLinkId = "";

    var myChart;

    function resizeMain() {
        var width = $("#mainContent").width();

        var mainWidth = width - 50;

        $("#main").css("width", mainWidth + "px");

    }

    function initEcharts() {

        var main = document.getElementById('main');

        resizeMain();

        // 基于准备好的dom，初始化echarts实例
        myChart = echarts.init(main);

        myChart.showLoading();

        var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

        // 获取当前登录用户的id
        $.post(getCurrentUserIdUrl, null, function (data) {
            var json = jQuery.parseJSON(data);

            var userId = json.userId;

            if (userId == "null") {
                alert("亲，您还未登录呢");

            } else {

                var url = "${pageContext.request.contextPath}/user/getZheTengLinkText.action";

                $.post(url, {"userId": userId}, function (data) {
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
                                edgeLength: 80,
                                repulsion: 800,
                                gravity: 0.1
                            },
                            edges: json.links
                        }]
                    };

                    myChart.setOption(option);

                }, "json");
            }
        });

        myChart.on("mouseover", function(params) {
            var type = params.dataType;
            if (type == "edge") {
                var linkIndex = params.dataIndex;
                var linkId = zhetengLinkJson.links[linkIndex].id;
                currentLinkId = linkId;

                isLink = true;
            } else if (type == "node") {
                var index = params.dataIndex;
                currentNodeIndex = index;
                currentNodeId = zhetengLinkJson.nodes[index].id;
                currentNodeName = params.name;
                isNode = true;
                isLink = false;
                console.log("myChart mouseover, currentNodeId: " + currentNodeId);
            }
        });

        myChart.on("mouseout", function(params) {

            console.log("myChart mouseout, currentNodeId: " + currentNodeId);

            var contextMenuVisable = $(".context-menu-list").css("display");
            if (contextMenuVisable == "none") {
                currentNodeIndex = "";
                currentNodeId = "";
                currentNodeName = "";
                currentLinkId = "";
            }
            isNode = false;
            isLink = false;

        });

        myChart.on("click", function(params) {

            if (isTryToLink) {

                var targetNodeIndex = params.dataIndex;

                var node = zhetengLinkJson.nodes[targetNodeIndex];
                linkTargetNodeId = node.id;
                linkTargetNodeName = params.name;

                if (linkSourceNodeId == linkTargetNodeId) {
                    linkTargetNodeId = "";
                    linkTargetNodeName = "";
                    return;
                }

                if (linkAlert) {
                    var str = "是否要将 " + linkSourceNodeName + " 与 " + linkTargetNodeName + " 连接吗？";
                    if (window.confirm(str)) {

                        addOrEditLink();

                        isTryToLink = false;
                    } else {
                        linkTargetNodeId = "";
                        linkTargetNodeName = "";
                    }
                }
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

        var contextMenuOptions = {
            selector: '.context-menu-one',
            events: {
                show: function (options) {
                    if (isTryToLink) {
                        // 鼠标变回默认样式，表示取消连接节点
                        $("#main div canvas").css("cursor", "");
                        isTryToLink = false;

                        linkSourceNodeId = "";
                        linkSourceNodeName = "";

                        return false;
                    }
                },
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
                    icon: "add",
                    visible: function (key, opt) {
                        return !isNode && !isLink;
                    },
                    callback: function (key, opt) {
                        keepCategoryId = false;
                        $("#addCategoryBtn").trigger("click");
                    }
                },
                "editCategory": {
                    name: "编辑类目",
                    icon: "edit",
                    visible: function (key, opt) {
                        return !isNode && !isLink;
                    },
                    callback: function (key, opt) {

                        $("#editCategoryBtn").trigger("click");
                    }
                },
                "deleteCategory": {
                    name: "删除类目",
                    icon: "delete",
                    visible: function (key, opt) {
                        return !isNode && !isLink;
                    },
                    callback: function (key, opt) {
                        $("#deleteCategoryBtn").trigger("click");
                    }
                },
                sep0: {
                    "type": "cm_separator",
                    visible: function (key, opt) {
                        return !isNode && !isLink;
                    }
                },
                "addNode": {
                    name: "新增节点",
                    icon: "add",
                    visible: function (key, opt) {
                        return !isNode && !isLink;
                    },
                    callback: function (key, opt) {
                        keepNodeId = false;
                        $("#addNodeBtn").trigger("click");

                    }
                },
                "editNode": {
                    name: "编辑节点",
                    icon: "edit",
                    visible: function (key, opt) {
                        return isNode;
                    },
                    callback: function (key, opt) {
                        console.log("currentNodeId: " + currentNodeId);
                        if (currentNodeId != "") {

                            var node = zhetengLinkJson.nodes[currentNodeIndex];
                            var categoryIndex = node.category;
                            var categoryId = zhetengLinkJson.categories[categoryIndex].id;
                            var color = node.itemStyle.normal.color;
                            currentNodeColor = color;

                            $("#editNodeName").val(currentNodeName);
                            $("#editNodeColor").attr("value", color);
                            $("#editCategoryIdSelect").children("option[value=" + categoryId + "]").attr("selected", "selected");

                            keepNodeId = true;
                            $("#editNodeBtn").trigger("click");
                        }
                    }
                },
                "deleteNode": {
                    name: "删除节点",
                    icon: "delete",
                    visible: function (key, opt) {
                        return isNode;
                    },
                    callback: function (key, opt) {
                        console.log(currentNodeId);
                        if (currentNodeId != "") {
                            keepNodeId = true;
                            $("#deleteNodeBtn").trigger("click");
                        }
                    }
                },
                "reclassifyNode": {
                    name: "重新分类",
                    icon: "edit",
                    visible: function (key, opt) {
                        return isNode;
                    },
                    callback: function (key, opt) {
                        console.log(currentNodeId);
                        if (currentNodeId != "") {

                            var node = zhetengLinkJson.nodes[currentNodeIndex];
                            var categoryIndex = node.category;
                            var categoryId = zhetengLinkJson.categories[categoryIndex].id;
                            var color = node.itemStyle.normal.color;
                            currentNodeColor = color;

                            $("#reclassifyNodeName").text("当前节点名称：" + currentNodeName);
                            $("#reclassifyCategoryIdSelect").children("option[value=" + categoryId + "]").attr("selected", "selected");

                            keepNodeId = true;
                            $("#reclassifyNodeBtn").trigger("click");
                        }
                    }
                },
                sep1: {
                    "type": "cm_separator",
                    visible: function (key, opt) {
                        return isNode;
                    }
                },
                "linkNode": {
                    name: "添加连接",
                    icon: "add",
                    visible: function (key, opt) {
                        return isNode;
                    },
                    callback: function (key, opt) {

                        isTryToLink = true;
                        $("#main div canvas").css("cursor", "crosshair");

                        linkSourceNodeId = currentNodeId;
                        linkSourceNodeName = currentNodeName;

                    }
                },
                "deleteLink": {
                    name: "删除连接",
                    icon: "delete",
                    visible: function (key, opt) {
                        return !isNode && isLink;
                    },
                    callback: function (key, opt) {
                        if (currentLinkId != "" && typeof(currentLinkId) != "undefined") {

                            deleteLink(currentLinkId);
                            isLink = false;

                        }
                    }
                },
                sep2: {"type": "cm_separator"},
                "quit": {
                    name: "关闭",
                    icon: function(){
                        return 'context-menu-icon context-menu-icon-quit';
                    },
                    callback: function (key, opt) {
                        return true;
                    }
                }
            }
        };

        $.contextMenu(contextMenuOptions);


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


        resetSelectCategory();

        $("#selectCategoryId").change(function () {

            var categoryId = $(this).children("option:selected").attr("value");
            if (categoryId != "") {

                currentCategoryId = categoryId;
                var cs = zhetengLinkJson.categories;
                var len = cs.length;
                for (var i = 0; i < len; i++) {
                    if (cs[i].id == categoryId) {

                        $("#editCategoryName").val(cs[i].name);
                        $("#editCategoryColor").val(cs[i].itemStyle.normal.color);
                        $("#editCategoryName").removeAttr("disabled");
                        $("#editCategoryColor").removeAttr("disabled");
                        break;

                    }
                }

            } else {
                currentCategoryId = "";
                refreshCategory();
            }

        });

    });


    function resetSelectCategory() {
        $("#selectCategoryId").prop("selectedIndex", 0);
        $("#editCategoryName").val("");
        $("#editCategoryColor").val("#000000");
        $("#editCategoryName").attr("disabled", "true");
        $("#editCategoryColor").attr("disabled", "true");
    }

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

                if (currentCategoryId != "") {
                    param.categoryId = currentCategoryId;
                    modalId = "editCategoryBtn";
                }

                $.post(url, param, function (data) {

                    $("#" + modalId).trigger("click");
                    $("#mainContent").html(data);

                    refreshCategory();

                });

            }
        });

    }


    function deleteCategoryToSubmit(linkObj) {

        var categoryId = $("#deleteCategoryIdSelect").children("option:selected").attr("value");
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

                var url = $(linkObj).attr("url");

                var modalId = "deleteCategoryBtn";

                var param = {
                    "categoryId": categoryId,
                    "userId": userId
                };

                $.post(url, param, function (data) {

                    $("#" + modalId).trigger("click");
                    $("#mainContent").html(data);

                    refreshCategory();

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

//                    refreshNode();

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

    function reclassifyNodeSubmit() {

        var categoryId = $("#reclassifyCategoryIdSelect").children("option:selected").attr("value");
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

                var $form = $("#reclassifyNodeForm");

                var url = $form.attr("action");

                var modalId = "reclassifyNodeBtn";

                var param = {
                    "categoryId": categoryId,
                    "userId": userId,
                    "nodeId": currentNodeId,
                    "nodeName": currentNodeName,
                    "nodeColor": currentNodeColor
                };

                $.post(url, param, function (data) {

                    $("#" + modalId).trigger("click");
                    $("#mainContent").html(data);

                    refreshNode();

                });

            }
        });

    }


    function addOrEditLink() {

        var sourceNodeId = linkSourceNodeId;
        if (sourceNodeId == "") {
            alert("请选择源节点！");
            return;
        }
        var targetNodeId = linkTargetNodeId;
        if (targetNodeId == "") {
            alert("请选择源节点！");
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

                var url = "${pageContext.request.contextPath}/link/addOrEditLink.action";

                var param = {
                    "sourceNodeId": sourceNodeId,
                    "targetNodeId": targetNodeId,
                    "userId": userId
                };

                $.post(url, param, function (data) {

                    $("#mainContent").html(data);

                });

            }
        });

    }

    function deleteLink(linkId) {

        var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

        // 获取当前登录用户的id
        $.post(getCurrentUserIdUrl, null, function (data) {
            var json = jQuery.parseJSON(data);

            var userId = json.userId;

            if (userId == "null") {
                alert("亲，您还未登录呢");

            } else {

                var url = "${pageContext.request.contextPath}/link/deleteLink.action";

                var param = {
                    "linkId": linkId,
                    "userId": userId
                };

                $.post(url, param, function (data) {

                    $("#mainContent").html(data);

                });

            }
        });

    }

    function refreshCategory() {

        var url = "${pageContext.request.contextPath}/category/showAllCategories.action";

        $.post(url, null, function (data) {
            $("#addCategoryIdSelect").html(data);
            $("#editCategoryIdSelect").html(data);
            $("#reclassifyCategoryIdSelect").html(data);
            $("#deleteCategoryIdSelect").html(data);
            $("#selectCategoryId").html(data);
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

            <div id="categoryDiv">
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
                     data-animation-in="slide-in-down">
                    <%--编辑类目--%>
                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                        <li class="accordion-item is-active" data-accordion-item>
                            <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                                <i class="fa fa-tags"></i>
                                编辑类目
                            </a>
                            <div class="accordion-content" data-tab-content>
                                <form id="editCategoryForm" action="${pageContext.request.contextPath}/category/addOrEditCategory.action">

                                    选择一个类目进行修改：
                                    <select id="selectCategoryId" name="categoryId">
                                        <option value="">请选择</option>
                                        <c:forEach items="${categories}" var="category">
                                            <option value="${category.categoryId}">${category.categoryName}</option>
                                        </c:forEach>
                                    </select>

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
                 data-animation-in="slide-in-down">

                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                        <li class="accordion-item is-active" data-accordion-item>
                            <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                                <i class="fa fa-tags"></i>
                                删除类目
                            </a>
                            <div class="accordion-content" data-tab-content>
                                <form id="deleteCategoryForm">

                                    选择要删除的类目：
                                    <select id="deleteCategoryIdSelect" name="categoryId">
                                        <option value="">请选择</option>
                                        <c:forEach items="${categories}" var="category">
                                            <option value="${category.categoryId}">${category.categoryName}</option>
                                        </c:forEach>
                                    </select>

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
            </div>

            <div id="nodeDiv">
                <button id="addNodeBtn" style="display: none;" data-toggle="addNodeModal"></button>

                <button id="editNodeBtn" style="display: none;" data-toggle="editNodeModal"></button>

                <button id="reclassifyNodeBtn" style="display: none;" data-toggle="reclassifyifyNodeModal"></button>

                <button id="deleteNodeBtn" style="display: none;" data-toggle="deleteNodeModal"></button>

                <div class="tiny reveal" id="addNodeModal" data-reveal data-close-on-click="true"
                     data-animation-in="slide-in-down">
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
                                    <select id="addCategoryIdSelect" name="categoryId">
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
                     data-animation-in="slide-in-down">
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
                                    <select id="editCategoryIdSelect" name="categoryId">
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

                <div class="tiny reveal" id="reclassifyifyNodeModal" data-reveal data-close-on-click="true"
                     data-animation-in="scale-in-up">
                    <%--编辑节点--%>
                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                        <li class="accordion-item is-active" data-accordion-item>
                            <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                                <i class="fa fa-tags"></i>
                                节点重新分类
                            </a>
                            <div class="accordion-content" data-tab-content>
                                <form id="reclassifyNodeForm" action="${pageContext.request.contextPath}/node/addOrEditNode.action">
                                    <label style="margin-bottom: 15px; font-size: 15px;" id="reclassifyNodeName"></label>
                                    所属类目：
                                    <select id="reclassifyCategoryIdSelect" name="categoryId">
                                        <option value="">请选择</option>
                                        <c:forEach items="${categories}" var="category">
                                            <option value="${category.categoryId}">${category.categoryName}</option>
                                        </c:forEach>
                                    </select>

                                    <div style="width: 100%; text-align: right;">
                                        <a href="javascript:void(0);" onclick="cancel('reclassifyifyNodeModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                        <a href="javascript:void(0);" onclick="reclassifyNodeSubmit()" class="button" style="margin-bottom: 0;" >提交更改</a>
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
                 data-animation-in="slide-in-down">

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

        </div>
    </li>
</ul>
