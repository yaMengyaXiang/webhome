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

                    var userId = json.userId;

                    if (userId == "null") {
                        alert("亲，您还未登录呢");

                    } else {

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

            articleInfoBarScrollToTop("article-info");

            $(window).scroll(function () {
                articleInfoBarScrollToTop("article-info");
            });


            $(window).resize(function () {
                articleInfoBarResize("article-info");
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

        function articleInfoBarResize(toTopId) {
            var $menubar = $("#" + toTopId);

            var $lr = $(".layer > .row:eq(1)");

            // 获取带小数点的宽度值，这个是精确的，要是用jQuery的width()方法，会经过四舍五入
            var mWidth = $lr[0].getBoundingClientRect().width;
//            var mWidth = $lr.outerWidth(true);

            $menubar.css("width", mWidth + "px");

        }

        function articleInfoBarScrollToTop(toTopId) {
            var $menubar = $("#" + toTopId);

            var mHeight = $menubar.height();

            var $lr = $(".layer > .row:eq(1)");

            var mWidth = $lr[0].getBoundingClientRect().width;

            var top = $lr.offset().top - mHeight;

            var sTop = $(window).scrollTop();

            if (sTop >= top) {
                $menubar.css("top", "0px");
                $menubar.css("position", "fixed");
                $menubar.css("width", mWidth + "px");
                $menubar.css("border-bottom", "1px solid #ccccff");

            } else {

                $menubar.css("position", "relative");
                $menubar.css("border-bottom", "none");

            }

        }

    </script>

</head>
<body>

    <%@include file="/WEB-INF/jsp/common/header.jsp"%>

    <%@include file="/WEB-INF/jsp/common/menubar.jsp"%>

    <%@include file="/WEB-INF/jsp/common/left-menubar.jsp"%>

    <%@include file="/WEB-INF/jsp/common/right-menubar.jsp"%>


    <div class="hide-for-small-only main-content" style="max-width: 85%; margin: 0.5rem auto;">
        <div class="padding-10-7-div">
            <div class="layer padding-5-div">

                <%-- 文章标题，点击量，回复量 --%>
                <div class="row" id="article-info" style="z-index: 100;">
                    <div class="large-3 medium-3 columns left-avatar-title text-center">
                        <div class="padding-5-0-div">
                            <label class="article-click-reply-hit">
                                查看: <i title="${article.clickHit}" style="color: #ff4400; font-style: normal;">${article.clickHit}</i>
                                 |
                                回复: <i title="${article.clickHit}" style="color: #ff4400; font-style: normal;">${article.replyHit}</i>
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
                <div class="row" cmtNum="1">
                    <div class="large-3 medium-3 columns left-avatar">
                        <div class="user-avatar">
                            <img src="${pageContext.request.contextPath}/static/image/01.jpg" height="95%" width="95%" class="thumbnail">
                        </div>
                        <div class="user-name">
                            <label title="${articleUser.username}">${articleUser.username}</label>
                        </div>
                    </div>
                    <div class="large-9 medium-9 columns right-content">
                        <div class="padding-20-div">
                            <div class="article-content">
                               ${article.articleContent}
                            </div>
                            <div class="article-publish-date">
                                <c:if test="${articleUser.userId == currentLoginUser.userId}">
                                    <a href="javascript:void(0);" url="${pageContext.request.contextPath}/comment/deleteDirectComment.action"
                                       onclick="deleteFloor(this)" class="delete-this-floor">删除</a>
                                    <a href="javascript:void(0);" class="only-see-this-author">只看我</a>
                                </c:if>
                                <c:if test="${articleUser.userId != currentLoginUser.userId}">
                                    <a href="#" class="only-see-this-author">只看该作者</a>
                                </c:if>
                                1楼 | 发表于：<fmt:formatDate value="${article.publishDate}" type="both"></fmt:formatDate>
                                <a href="#" class="article-reply">回复</a>
                            </div>

                        </div>
                    </div>
                </div>
                </c:if>

                <c:if test="${!empty pageComments.results}">
                <%@include file="/WEB-INF/jsp/comment/all-comments.jsp"%>
                </c:if>

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
                                <label style="font-size: 16px;">走过路过，发表一下你的评论吧 !</label>
                            </div>
                            <div class="medium-6 columns text-right">
                                <label style="font-size: 16px;float: right;">亲，请记得文明用语哦 !</label>
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
                                'source',
                                '|',
                                'bold',
                                'italic',
                                'eraser',
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

                            // 上传图片
                            editor.config.uploadImgUrl = '/upload';

                            editor.config.emotions = {
                                'default': {
                                    title: '默认',
                                    data: '${pageContext.request.contextPath}/static/emotions/emotions.data'
                                }
                            };

                            editor.create();

                            editor.$txt.html('<p><br></p>');

                            // 自定义命令
                            editor.customCommand = override.wangEditor.customCommand();

                        </script>
                    </div>
                    <div class="text-right" style="width: 90%; margin: 10px auto 0px;">
                        <a url="${pageContext.request.contextPath}/comment/publishComment.action"
                           href="javascript:void(0);" id="publishCmtBtn" class="button">发表评论</a>
                    </div>
                </div>


            </div>

        </div>
    </div>

    <div class="show-for-small-only" style="max-width: 98%; margin: 0.5rem auto;">
        <div class="padding-10-7-div">
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
