<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/4/8
  Time: 12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head lang="zh-cn">

    <title>个人中心</title>

    <%@include file="/WEB-INF/jsp/common/static.jsp"%>

    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>

    <script type="text/javascript">
        $(function() {
            $(document).foundation();

            common.clickListen("tagId");

        });

        function addClickToSubmit(submitFormId) {

            var param = {
                "tagName": $("#addTagName").val(),
                "description": $("#addTagDesc").val()
            };

            common.addClickToSubmit(submitFormId, param, "toMyTags");

        }

        function editClickToSubmit(submitFormId) {

            var param = {
                "tagId": $("#editHiddenTagId").val(),
                "tagName": $("#editTagName").val(),
                "description": $("#editTagDesc").val()
            };

            common.editClickToSubmit(submitFormId, param, "toMyTags");

        }

        function deleteClickToSubmit(btnObj) {

            common.deleteClickToSubmit(btnObj, "toMyTags");

        }

    </script>

</head>
<body>

<%@include file="/WEB-INF/jsp/common/header.jsp"%>

<div class="row">
    <div class="padding-20-5-div">

        <%@include file="/WEB-INF/jsp/user/left-menu.jsp"%>


        <div id="mainContent" class="medium-8 large-9 columns">
            <ul class="accordion" data-accordion data-allow-all-closed="true">
                <li class="accordion-item is-active" data-accordion-item>

                    <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                        <i class="fa fa-tags"></i>
                        文章标签
                    </a>

                    <div class="accordion-content" data-tab-content>

                        <table>
                            <tr class="text-center">
                                <th>
                                    <input class="margin-05-0-0" type="checkbox" id="selectAll">
                                </th>
                                <th>编号</th>
                                <th>标签名</th>
                                <th>描述</th>
                            </tr>
                            <c:forEach items="${pageTags.results}" var="tag" varStatus="vs">
                                <tr class="text-center">
                                    <td idName="editHiddenTagId">
                                        <input class="margin-05-0-0" type="checkbox" name="tagId" value="${tag.tagId}">
                                    </td>
                                    <td>${vs.count}</td>
                                    <td idName="editTagName" title="${tag.tagName}">${tag.tagName}</td>
                                    <td idName="editTagDesc" title="${tag.description}">${tag.description}</td>
                                </tr>
                            </c:forEach>
                        </table>

                        <div style="height: 32px; margin: 20px 0">

                            <div class="medium-6 columns text-left">
                                <!-- 按钮触发模态框 -->
                                <a href="javascript:void(0);" onclick="common.addBtnClick()" class="button-a margin-old-10" >新增标签</a>
                                <button id="addBtn" style="display: none;" data-toggle="addModal"></button>

                                <!-- 按钮触发模态框 -->
                                <a href="javascript:void(0);" onclick="common.editBtnClick('tagId', 2)" class="button-a margin-old-10" >编辑标签</a>
                                <button id="editBtn" style="display: none;" data-toggle="editModal"></button>

                                <a href="javascript:void(0);" onclick="common.deleteBtnClick('tagId')" class="button-a margin-old-10" >删除标签</a>
                                <button id="deleteBtn" style="display: none;" data-toggle="deleteModal"></button>

                                <div class="reveal" id="addModal" data-reveal data-close-on-click="true"
                                     data-animation-in="scale-in-up" data-animation-out="scale-out-down">

                                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                                        <li class="accordion-item is-active" data-accordion-item>

                                            <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                                                <i class="fa fa-tags"></i>
                                                新增标签
                                            </a>

                                            <div class="accordion-content" data-tab-content>
                                                <form id="addForm" action="${pageContext.request.contextPath}/tag/addOrEditTag.action">
                                                    标签名：
                                                    <input id="addTagName" type="text" name="tagName">
                                                    描述：
                                                    <input id="addTagDesc" type="text" name="description">
                                                    <div style="width: 100%; text-align: right;">
                                                        <a href="javascript:void(0);" onclick="common.cancel('addModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                                        <a href="javascript:void(0);" onclick="addClickToSubmit('addForm')" class="button" style="margin-bottom: 0;" >添加</a>
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

                                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                                        <li class="accordion-item is-active" data-accordion-item>

                                            <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                                                <i class="fa fa-tags"></i>
                                                编辑标签
                                            </a>

                                            <div class="accordion-content" data-tab-content>
                                                <form id="editForm" action="${pageContext.request.contextPath}/tag/addOrEditTag.action">
                                                    <input type="hidden" id="editHiddenTagId" name="tagId" value="">
                                                    标签名：
                                                    <input id="editTagName" type="text" name="tagName">
                                                    描述：
                                                    <input id="editTagDesc" type="text" name="description">
                                                    <div style="width: 100%; text-align: right;">
                                                        <a href="javascript:void(0);" onclick="common.cancel('editModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                                        <a href="javascript:void(0);" onclick="editClickToSubmit('editForm')" class="button" style="margin-bottom: 0;" >提交更改</a>
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
                                                删除标签
                                            </a>

                                            <div class="accordion-content" data-tab-content>
                                                <form id="deleteForm">
                                                    <label style="font-size: 16px; color: red;">确定要删除所选标签吗 ?</label>
                                                    <div style="width: 100%; text-align: right;">
                                                        <a href="javascript:void(0);" onclick="common.cancel('deleteModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                                        <a url="${pageContext.request.contextPath}/tag/deleteTags.action"
                                                           href="javascript:void(0);" onclick="deleteClickToSubmit(this)" class="button" style="margin-bottom: 0;" >确定</a>
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


                            <div class="medium-6 columns text-center">
                                <c:if test="${!empty pageTags.results}">
                                    <ul class="pagination" role="pagination">

                                        <li>
                                            <a <c:if test="${pageTags.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                               class="pagination-a"
                                               url="${pageContext.request.contextPath}/user/toMyTags.action?pageNo=${pageTags.currentPage-1}"
                                               href="javascript:void(0);"
                                               onclick="common.preAndNextPage(this, ${pageTags.currentPage-1})">&lt;&lt;</a>
                                        </li>

                                        <c:forEach items="${pageNums}" var="pageNum">
                                            <li>
                                                <a <c:if test="${pageNum == pageTags.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                                                   class="pagination-a"
                                                   url="${pageContext.request.contextPath}/user/toMyTags.action?pageNo=${pageNum}"
                                                   href="javascript:void(0);"
                                                   onclick="common.preAndNextPage(this, ${pageNum})">${pageNum}</a>
                                            </li>
                                        </c:forEach>

                                        <li>
                                            <a <c:if test="${pageTags.currentPage + 1 > pageTags.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                               class="pagination-a"
                                               url="${pageContext.request.contextPath}/user/toMyTags.action?pageNo=${pageTags.currentPage+1}"
                                               href="javascript:void(0);"
                                               onclick="common.preAndNextPage(this, ${pageTags.currentPage+1})">&gt;&gt;</a>
                                        </li>

                                    </ul>
                                </c:if>

                            </div>

                        </div>

                    </div>
                </li>
            </ul>
        </div>

    </div>
</div>

</body>
</html>

