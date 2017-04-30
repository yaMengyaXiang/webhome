<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-30
  Time: 0:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript">

    $(function () {
        $(document).foundation();

        $("#addCategoryBtn").unbind("click");
        $("#addCategoryBtn").bind("click", function () {

            var categoryName = $(":text[name=categoryName]").val();
            if (categoryName == "") {
                alert("请填写类目名称！");
                return;
            }
            var categoryColor = $(":text[name=categoryColor]").val();
            if (categoryColor == "") {
                alert("请选择颜色！");
                return;
            }
            var categoryDescription = $(":text[name=categoryDescription]").val();

            var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

            // 获取当前登录用户的id
            $.post(getCurrentUserIdUrl, null, function (data) {
                var json = jQuery.parseJSON(data);

                var userId = json.userId;

                if (userId == "null") {
                    alert("亲，您还未登录呢");

                } else {

                    var url = "${pageContext.request.contextPath}/category/addCategory.action";

                    var param = {
                        "categoryName": categoryName,
                        "categoryColor": "#" + categoryColor,
                        "categoryDescription": categoryDescription,
                        "userId": userId
                    };

                    $.post(url, param, function (data) {

                        $("#mainContent").html(data);

                        refreshCategory();

                    });

                }
            });

        });

        $("#addNodeBtn").unbind("click");
        $("#addNodeBtn").bind("click", function () {

            var nodeName = $(":text[name=nodeName]").val();
            if (nodeName == "") {
                alert("请填写节点名称！");
                return;
            }
            var nodeColor = $(":text[name=nodeColor]").val();
            if (nodeColor == "") {
                alert("请选择颜色！");
                return;
            }

            var categoryId = $("select[name=categoryId] option:selected").attr("value");
            if (categoryId == "") {
                alert("请选择类目！");
                return;
            }

            var nodeDescription = $(":text[name=nodeDescription]").val();

            var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

            // 获取当前登录用户的id
            $.post(getCurrentUserIdUrl, null, function (data) {
                var json = jQuery.parseJSON(data);

                var userId = json.userId;

                if (userId == "null") {
                    alert("亲，您还未登录呢");

                } else {

                    var url = "${pageContext.request.contextPath}/node/addNode.action";

                    var param = {
                        "nodeName": nodeName,
                        "nodeColor": "#" + nodeColor,
                        "nodeDescription": nodeDescription,
                        "categoryId": categoryId,
                        "userId": userId
                    };

                    $.post(url, param, function (data) {

                        $("#mainContent").html(data);

                        refreshNode();

                    });

                }
            });

        });

        $("#addLinkBtn").unbind("click");
        $("#addLinkBtn").bind("click", function () {

            var sourceNodeId = $("select[name=sourceNodeId] option:selected").attr("value");
            if (sourceNodeId == "") {
                alert("请选择源节点！");
                return;
            }
            var targetNodeId = $("select[name=targetNodeId] option:selected").attr("value");
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

                    var url = "${pageContext.request.contextPath}/link/addLink.action";

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


        });


    });

</script>

<ul class="accordion" data-accordion data-allow-all-closed="true" data-multi-expand="false">
    <li class="accordion-item is-active" data-accordion-item>

        <a href="javascript:void(0);" class="accordion-title">
            <i class="fa fa-object-ungroup"></i>
            我的折腾链
        </a>

        <div class="accordion-content" data-tab-content>

            <ul class="accordion margin-bottom-1rem" data-accordion data-allow-all-closed="true">

                <li class="accordion-item is-active" data-accordion-item>
                    <a href="javascript:void(0);" class="accordion-title">
                        <i class="fa fa-tags"></i>
                        添加类目
                    </a>

                    <div class="accordion-content" data-tab-content>
                        <div class="row">
                            <div class="medium-12 columns">
                                名称：<input type="text" name="categoryName">
                            </div>
                            <div class="medium-12 columns">
                                颜色：<input class="jscolor" type="text" value="000000" name="categoryColor">
                            </div>
                        </div>
                        <div class="row">
                            <div class="medium-12 columns">
                                描述：<input type="text" name="categoryDescription">
                            </div>
                            <div class="medium-12 columns">
                                <button id="addCategoryBtn" class="button">添加</button>
                            </div>
                        </div>
                    </div>

                </li>

                <li class="accordion-item" data-accordion-item>
                    <a href="javascript:void(0);" class="accordion-title">
                        <i class="fa fa-dot-circle-o"></i>
                        添加节点
                    </a>

                    <div class="accordion-content" data-tab-content>

                        <div class="row">
                            <div class="medium-12 columns">
                                名称：<input type="text" name="nodeName">
                            </div>
                            <div class="medium-12 columns">
                                颜色：<input class="jscolor" value="000000" type="text" name="nodeColor">
                            </div>
                            <div id="addNodeDiv" class="medium-12 columns">
                                <%@include file="/WEB-INF/jsp/user/backend/link/node.jsp"%>
                            </div>
                        </div>
                        <div class="row">
                            <div class="medium-12 columns">
                                描述：<input type="text" name="nodeDescription">
                            </div>
                            <div class="medium-12 columns">
                                <button id="addNodeBtn" class="button">添加</button>
                            </div>
                        </div>

                    </div>

                </li>

                <li class="accordion-item" data-accordion-item>
                    <a href="javascript:void(0);" class="accordion-title">
                        <i class="fa fa-share-alt"></i>
                        节点连接
                    </a>

                    <div class="accordion-content" data-tab-content>
                        <div id="addLinkDiv"  class="row">
                            <%@include file="/WEB-INF/jsp/user/backend/link/link.jsp"%>
                        </div>
                        <div class="row">
                            <div class="medium-12 columns">
                                <button id="addLinkBtn" class="button">连接</button>
                            </div>
                        </div>
                    </div>

                </li>

            </ul>

        </div>
    </li>
</ul>
