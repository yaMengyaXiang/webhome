<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-22
  Time: 10:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>${article.title}</title>

    <%@include file="/WEB-INF/jsp/common/static.jsp"%>

    <script type="text/javascript">

        $(function () {

            $(document).foundation();

            $("#publishCmtBtn").unbind("click");
            $("#publishCmtBtn").bind("click", function () {

                var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

                // 获取当前登录用户的id
                $.post(getCurrentUserIdUrl, null, function (data) {
                    var json = jQuery.parseJSON(data);
                    if (json.userId == "null") {
                        alert("您还未登录呢");
                    } else {
                        var userId = json.userId;
                        alert(userId);

                        var url = $("#publishCmtBtn").attr("url");

                        var comemntContent = editor.$txt.html();

                        var articleId = $("#articleId").val();

                        var param = {
                            "userId": userId,
                            "commentContent": comemntContent,
                            "articleId": articleId,
                            "targetUrl": window.location.href
                        };

                        $.post(url, param, function (data) {

                            var json = jQuery.parseJSON(data);
                            if ("false" == json.success) {
                                alert("评论失败！");
                            } else {
                                var targetUrl = json.success;
                                window.location.href = targetUrl;
                            }

                        });

                    }
                });

            });

        });

        function preAndNextPage(linkObj) {
            var $linkObj = $(linkObj);
            var url = $linkObj.attr("url");

            if ($linkObj.css("cursor") == "not-allowed") {
                return;
            }

            window.location.href = url;

        }

        function showSubComment(subCommentSpanObj) {
            var subCommentDiv = $(subCommentSpanObj).parent().next(".article-sub-comment");
            subCommentDiv.slideToggle("normal", function () {
                var replyBtn = $(subCommentSpanObj).children(":first-child");

                if (replyBtn.text() == "收起回复") {
                    replyBtn.text("回复");
                } else {
                    replyBtn.text("收起回复");
                }
                $(subCommentSpanObj).toggleClass("article-reply-bg-border", "article-reply");
            });

        }

    </script>

</head>
<body>

    <%@include file="/WEB-INF/jsp/common/header.jsp"%>

    <%@include file="/WEB-INF/jsp/common/menubar.jsp"%>

    <div class="hide-for-small-only" style="max-width: 85%; margin: 0.5rem auto;">
        <div class="padding-10-5-div">
            <div class="layer padding-5-div">

                <%-- 文章标题，点击量，回复量 --%>
                <div class="row">
                    <div class="large-3 medium-3 columns left-avatar-title text-center">
                        <div class="padding-5-0-div">
                            <label class="article-click-reply-hit">
                                查看: <i style="color: #ff4400; font-style: normal;">${article.clickHit}</i>
                                 |
                                回复: <i style="color: #ff4400; font-style: normal;">${article.replyHit}</i>
                            </label>
                        </div>
                    </div>
                    <div class="large-9 medium-9 columns right-content-title">
                        <input type="hidden" id="articleId" name="articleId" value="${article.articleId}">
                        <div class="padding-5-0-div">
                            <label class="article-title">${article.title}</label>
                        </div>
                    </div>
                </div>

                <%-- 1楼 --%>
                <c:if test="${pageComments.currentPage == 1}">
                <div class="row">
                    <div class="large-3 medium-3 columns left-avatar">
                        <div class="user-avatar">
                            <img src="${pageContext.request.contextPath}/static/image/01.jpg" height="95%" width="95%" class="thumbnail">
                        </div>
                        <div class="user-name">
                            <label>${articleUser.username}</label>
                        </div>
                    </div>
                    <div class="large-9 medium-9 columns right-content">
                        <div class="padding-20-div">
                            <div class="article-content">
                               ${article.articleContent}
                            </div>
                            <div class="article-publish-date">
                                <a href="#" class="only-see-this-author">只看该作者</a>
                                1楼 | 发表于：<fmt:formatDate value="${article.publishDate}" type="both"></fmt:formatDate>
                                <a href="#" class="article-reply">回复</a>
                            </div>

                        </div>
                    </div>
                </div>
                </c:if>

                <%-- 其他楼层 --%>
                <c:forEach items="${pageComments.results}" var="comment">
                <div class="row">
                    <div class="large-3 medium-3 columns left-avatar">
                        <div class="user-avatar">
                            <img src="${pageContext.request.contextPath}/static/image/01.jpg" height="95%" width="95%" class="thumbnail">
                        </div>
                        <div class="user-name">
                            <label>${comment.user.username}</label>
                        </div>
                    </div>
                    <div class="large-9 medium-9 columns right-content">
                        <div class="padding-20-div">
                            <div class="article-content">
                                ${comment.commentContent}
                            </div>
                            <div class="article-publish-date" style="margin-bottom: 10px;">
                                <a href="#" class="only-see-this-author">只看该作者</a>
                                ${comment.commentNum}楼 | 发表于：<fmt:formatDate value="${comment.commentDate}" type="both"></fmt:formatDate>
                                <span onclick="showSubComment(this)" class="text-center article-reply">
                                    <a href="javascript:void(0);">回复(10)</a>
                                </span>
                            </div>
                            <div class="article-sub-comment" style="min-height: 100px;">


                                <div style="width: 90%; margin: 0 auto;">
                                    <div class="" id="subCommentEditorDiv${comment.commentNum}" style="min-height: 50px;"></div>
                                    <script type="text/javascript">
                                        var id = "subCommentEditorDiv${comment.commentNum}";
                                        var subCommentEditor = new wangEditor(id);

                                        // 关闭菜单栏fixed
                                        subCommentEditor.config.menuFixed = false;

                                        subCommentEditor.config.menus = [
                                            'bold',
                                            'italic',
                                            'quote',
                                            'fontfamily',
                                            'fontsize',
                                            '|',
                                            'emotion',
                                            'img',
                                            'insertcode',
                                            'undo',
                                            'redo'
                                        ];

                                        subCommentEditor.create();
                                    </script>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                </c:forEach>

            </div>

            <%-- 分页按钮 --%>
            <div class="row padding-5-div">
                <div class="text-right">
                    <c:if test="${!empty pageComments.results}">
                    <ul class="pagination" role="pagination" style="margin-top: 1rem;">

                        <li>
                            <a <c:if test="${pageComments.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                               class="pagination-a"
                               url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${pageComments.currentPage-1}"
                               href="javascript:void(0);"
                               onclick="preAndNextPage(this)">&lt;</a>
                        </li>

                        <c:forEach items="${pageNums}" var="pageNum">
                        <li>
                            <a <c:if test="${pageNum == pageComments.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                               class="pagination-a"
                               url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${pageNum}"
                               href="javascript:void(0);"
                               onclick="preAndNextPage(this)">${pageNum}</a>
                        </li>
                        </c:forEach>

                        <li>
                            <a <c:if test="${pageComments.currentPage + 1 > pageComments.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                               class="pagination-a"
                               url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${pageComments.currentPage+1}"
                               href="javascript:void(0);"
                               onclick="preAndNextPage(this)">&gt;</a>
                        </li>

                    </ul>
                    </c:if>
                </div>
            </div>

            <%-- 评论框 --%>
            <div class="row padding-5-div">

                <div class="border-1">
                    <div class="" style="width: 90%; margin: 10px auto;">
                        <div style="height: 26px;">
                            <div class="medium-6 columns text-left">
                                <label style="font-size: 17px; font-weight: bold;">走过路过，发表一下你的评论吧 !</label>
                            </div>
                            <div class="medium-6 columns text-right">
                                <label style="font-size: 17px; font-weight: bold; float: right;">亲，请记得文明用语哦 !</label>
                            </div>
                        </div>
                    </div>
                    <div style="width: 90%; margin: 0 auto;">
                        <div class="" id="wang-editor" style="min-height: 200px;"></div>
                        <script type="text/javascript">
                            var editor = new wangEditor("wang-editor");

                            // 关闭菜单栏fixed
                            editor.config.menuFixed = false;

                            editor.config.menus = [
                                'bold',
                                'italic',
                                'quote',
                                'fontfamily',
                                'fontsize',
                                'head',
                                '|',
                                'unorderlist',
                                'orderlist',
                                'link',
                                'unlink',
                                'emotion',
                                '|',
                                'img',
                                'video',
                                'insertcode',
                                'undo',
                                'redo',
                                'fullscreen'
                            ];

                            editor.create();
                        </script>
                    </div>
                    <div class="text-right" style="width: 90%; margin: 10px auto 0px;">
                        <a url="${pageContext.request.contextPath}/comment/publishComment.action"
                           href="javascript:void(0);" id="publishCmtBtn" type="button" class="button">发表评论</a>
                    </div>
                </div>


            </div>

        </div>
    </div>


    <div class="show-for-small-only" style="max-width: 98%; margin: 0.5rem auto;">
        <div class="padding-10-5-div">
            <div class="layer padding-5-div">

                <div class="row">
                    <div class="medium-3 columns small-left-avatar text-center">
                        <div class="padding-5-0-div">
                            <label class="article-click-reply">
                                查看：1234
                                |
                                回复：123
                            </label>
                        </div>
                    </div>
                    <div class="medium-9 columns small-right-content">
                        <div class="padding-5-0-div">
                            <label class="article-title">这是主题注释主题主题这是主题注释主题主题这是主题注释主题主题</label>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="medium-3 columns small-left-avatar">
                        <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    </div>
                    <div class="medium-9 columns small-right-content">
                        <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    </div>
                </div>

                <div class="row">
                    <div class="medium-3 columns small-left-avatar">
                        <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    </div>
                    <div class="medium-9 columns small-right-content">
                        <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    </div>
                </div>

                <div class="row">
                    <div class="medium-3 columns small-left-avatar">
                        <br><br><br><br><br><br><br>
                    </div>
                    <div class="medium-9 columns small-right-content">
                        <br><br><br><br><br><br><br>
                    </div>
                </div>

                <div class="row">
                    <div class="medium-3 columns small-left-avatar">
                        <br><br><br><br><br><br><br>
                    </div>
                    <div class="medium-9 columns small-right-content">
                        <br><br><br><br><br><br><br>
                    </div>
                </div>

                <div class="row">
                    <div class="medium-3 columns small-left-avatar">
                        <br><br><br><br><br><br>
                    </div>
                    <div class="medium-9 columns small-right-content">
                        <br><br><br><br><br><br>
                    </div>
                </div>

                <div class="row">
                    <div class="medium-3 columns small-left-avatar">
                        <br><br><br><br><br><br>
                    </div>
                    <div class="medium-9 columns small-right-content">
                        <br><br><br><br><br><br>
                    </div>
                </div>



            </div>
        </div>
    </div>


    <%@include file="/WEB-INF/jsp/common/bottom.jsp"%>

</body>
</html>
