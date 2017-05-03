<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/4/8
  Time: 12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

        function addBtnClick(idNeedToClick) {
            $("#" + idNeedToClick).trigger("click");
        }

        function editBtnClick(checkboxName) {
            var $checkedObj = $(":checkbox[name='" + checkboxName + "']:checked");
            var checkedLen = $checkedObj.length;

            if (checkedLen == 0) {
                alert("请选择一行！！！");
                return;
            } else if (checkedLen > 1) {
                alert("请只选择一行！！！");
                return;
            }

            var id = $checkedObj.val();

            // 请求后台获取该文章内容，并跳转到编辑界面
            var url = "${pageContext.request.contextPath}/article/editArticleById.action";
//            var param = {
//                "articleId": id
//            };

            window.location.href = url + "?articleId=" + id;

//
//            $.post(url, param, function (data) {
//                $("#mainContent").html(data);
//            });

        }

        function deleteClickToSubmit(btnObj) {

            common.deleteClickToSubmit(btnObj, "toMyArticles");

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

                    <a href="javascript:void(0);" class="accordion-title">
                        <i class="fa fa-list-alt"></i>
                        我的文章
                    </a>

                    <div class="accordion-content" data-tab-content>

                        <table>

                            <tr class="text-center">
                                <th>
                                    <input class="margin-05-0-0" type="checkbox" id="selectAll">
                                </th>
                                <th>编号</th>
                                <th>标题</th>
                                <th>标签</th>
                                <th>发表时间</th>
                                <th>关键字</th>
                            </tr>

                            <c:forEach items="${pageArticles.results}" var="article" varStatus="vs">
                                <tr class="text-center">
                                    <td>
                                        <input class="margin-05-0-0" type="checkbox" name="articleId" value="${article.articleId}">
                                    </td>
                                    <td>${vs.count}</td>
                                    <td title="${article.title}">
                                        <a target="_blank" href="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}">${article.title}</a>
                                    </td>
                                    <td title="${article.tagId}">
                                        <c:forEach items="${tags}" var="tag">
                                            <c:if test="${article.tagId == tag.tagId}">${tag.tagName}</c:if>
                                        </c:forEach>
                                    </td>
                                    <td title="${article.publishDate}">
                                        <fmt:formatDate value="${article.publishDate}" type="both"></fmt:formatDate>
                                    </td>
                                    <td title="${article.keyword}">${article.keyword}</td>
                                </tr>
                            </c:forEach>
                        </table>

                        <div style="height: 32px; margin: 20px 0">

                            <div class="medium-6 columns text-left">
                                <!-- 按钮触发模态框 -->
                                <a href="javascript:void(0);" onclick="addBtnClick('toWriteArticle')" class="button-a margin-old-10" >撰写文章</a>

                                <!-- 按钮触发模态框 -->
                                <a href="javascript:void(0);" onclick="editBtnClick('articleId')" class="button-a margin-old-10" >更新文章</a>

                                <a href="javascript:void(0);" onclick="common.deleteBtnClick('articleId')" class="button-a margin-old-10" >删除文章</a>
                                <button id="deleteBtn" style="display: none;" data-toggle="deleteModal"></button>

                                <div class="reveal" id="deleteModal" data-reveal data-close-on-click="true"
                                     data-animation-in="scale-in-up" data-animation-out="scale-out-down">

                                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                                        <li class="accordion-item is-active" data-accordion-item>

                                            <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                                                <i class="fa fa-tags"></i>
                                                删除文章
                                            </a>

                                            <div class="accordion-content" data-tab-content>
                                                <form id="deleteForm">
                                                    <label style="font-size: 16px; color: red;">确定要删除所选文章吗 ?</label>
                                                    <div style="width: 100%; text-align: right;">
                                                        <a href="javascript:void(0);" onclick="common.cancel('deleteModal')" class="button" style="margin-bottom: 0;" >取消</a>
                                                        <a url="${pageContext.request.contextPath}/article/deleteArticles.action"
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
                                <c:if test="${!empty pageArticles.results}">
                                    <ul class="pagination" role="pagination">

                                        <li>
                                            <a <c:if test="${pageArticles.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                               class="pagination-a"
                                               url="${pageContext.request.contextPath}/user/toMyArticles.action?pageNo=${pageArticles.currentPage-1}"
                                               href="javascript:void(0);"
                                               onclick="common.preAndNextPage(this, ${pageArticles.currentPage-1})">&lt;&lt;</a>
                                        </li>

                                        <c:forEach items="${pageNums}" var="pageNum">
                                            <li>
                                                <a <c:if test="${pageNum == pageArticles.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                                                   class="pagination-a"
                                                   url="${pageContext.request.contextPath}/user/toMyArticles.action?pageNo=${pageNum}"
                                                   href="javascript:void(0);"
                                                   onclick="common.preAndNextPage(this, ${pageNum})">${pageNum}</a>
                                            </li>
                                        </c:forEach>

                                        <li>
                                            <a <c:if test="${pageArticles.currentPage + 1 > pageArticles.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                               class="pagination-a"
                                               url="${pageContext.request.contextPath}/user/toMyArticles.action?pageNo=${pageArticles.currentPage+1}"
                                               href="javascript:void(0);"
                                               onclick="common.preAndNextPage(this, ${pageArticles.currentPage+1})">&gt;&gt;</a>
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
