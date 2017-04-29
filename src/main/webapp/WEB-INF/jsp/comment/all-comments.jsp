<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-23
  Time: 17:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<script type="text/javascript">

    var subEditors;

    $(function () {

        $(document).foundation();

        // 生成楼中楼回复编辑器
        generateEditor();

    });


    /**
     * 生成楼中楼回复的编辑器
     */
    function generateEditor() {

        var len = $(".subCommentEditor").length;
        subEditors = new Array(len);

        var i = 0;

        $(".subCommentEditor").each(function () {

            var subCommentEditorId = $(this).attr("id");

            var subCommentEditor = new wangEditor(subCommentEditorId);

            // 关闭菜单栏fixed
            subCommentEditor.config.menuFixed = false;

            subCommentEditor.config.menus = [
                'source',
                'bold',
                'italic',
                'eraser',
                'fontfamily',
                'fontsize',
                '|',
                'quote',
                'emotion',
                'img',
                'insertcode',
                'undo',
                'redo'
            ];

            // 上传图片
            subCommentEditor.config.uploadImgUrl = '/upload';

            subCommentEditor.config.emotions = {
                'default': {
                    title: '默认',
                    data: '${pageContext.request.contextPath}/static/emotions/emotions.data'
                }
            };

            subCommentEditor.create();

            subCommentEditor.$txt.html('<p><br></p>');

            subCommentEditor.customCommand = override.wangEditor.customCommand();

            subEditors[i++] = subCommentEditor;

        });
    }

    /**
     * 显示或隐藏楼中楼的回复
     * @param subCommentSpanObj
     */
    function showOrHideSubComment(subCommentSpanObj) {
        var subCommentDiv = $(subCommentSpanObj).parent().next(".article-sub-comment");
        var accordion = subCommentDiv.children(".accordion:first-child");
        var accordionItem = accordion.children(".accordion-item:first-child");
        var accordionTitle = accordionItem.children(".my-accordion-title:first-child");

        accordionTitle.trigger("click");

        var replyBtn = $(subCommentSpanObj).children(":first-child");

        var count = replyBtn.attr("count");

        if (replyBtn.text() == "隐藏") {
            if (count == 0) {
                replyBtn.text("回复");
            } else {
                var text = "回复(" + count + ")";
                replyBtn.text(text);
            }
        } else {
            replyBtn.text("隐藏");
        }

    }


    /**
     * 楼中楼回复，异步提交，后台返回页面上某部分的html，再把它替换掉
     * @param spanObj
     */
    function subCommentReply(spanObj) {

        var getCurrentUserIdUrl = "${pageContext.request.contextPath}/user/getCurrentUserId.action";

        // 获取当前登录用户的id
        $.post(getCurrentUserIdUrl, null, function (data) {
            var json = jQuery.parseJSON(data);

            var userId = json.userId;

            if (userId == "null") {
                alert("亲，您还未登录呢");

            } else {

                var cmtParentId = $(spanObj).parents(".row").attr("cmtParentId");
                var index = $(spanObj).parents(".row").attr("index");

                var articleId = $("#articleId").val();

                var cmtContent = subEditors[index].$txt.html();

                var param = {
                    "commentParentId": cmtParentId,
                    "articleId": articleId,
                    "commentContent": cmtContent,
                    "userId": userId
                };


                var url = $(spanObj).children("a:first-child").attr("url");


                $.post(url, param, function (data) {

//                      需要异步刷新的div
                    $(spanObj).parents(".sub-comment-reply-editor").siblings(".refresh-div").html(data);

                    subEditors[index].$txt.html('<p><br></p>');

                    var replyOrHide = $(spanObj).parents(".article-sub-comment").siblings(".article-publish-date").find("a[count]");
                    var count = replyOrHide.attr("count");

                    var subReplyNum = parseInt(count) + 1;
                    // 回复数加1
                    replyOrHide.attr("count", subReplyNum);

                });

            }
        });

    }


    /**
     * 在楼中楼中点击某位作者下的回复时调用
     * @param atAuthorSpanObj
     */
    function atAuthorSubCommentReply(atAuthorSpanObj) {
        var cmtParentId = $(atAuthorSpanObj).parents(".row").attr("cmtParentId");
        var index = $(atAuthorSpanObj).parents(".row").attr("index");

        var usernameTitle = $(atAuthorSpanObj).parent(".article-publish-date").parent(".accordion-content").siblings("a");

        subEditors[index].$txt.append('&nbsp;@' + usernameTitle.text() + '&nbsp;&nbsp;');

    }


    /**
     * 楼中楼的分页按钮点击时调用
     * @param linkObj
     */
    function subPreAndNextPage(linkObj) {
        var $linkObj = $(linkObj);
        var url = $linkObj.attr("url");

        if ($linkObj.css("cursor") == "not-allowed") {
            return;
        }

        var url = $(linkObj).attr("url");


        var refreshDiv = $(linkObj).parents(".refresh-div");
        var top = refreshDiv.offset().top;

        $.post(url, null, function (data) {

//           需要异步刷新的div
            refreshDiv.html(data);

            $(window).scrollTop(top - 150);

        });

    }

    /**
     * 删除楼层
     * @param linkObj
     */
    function deleteFloor(linkObj) {

        if (!window.confirm("确定要删除该楼层吗 ?")) {
            return;
        }

        // 请求后台删除楼层，返回json数据，然后移除该楼层的div
        var $floor = $(linkObj).parents(".row");

        var cmtId = $floor.attr("cmtParentId");
        var cmtNum = $floor.attr("cmtNum");

        var url = $(linkObj).attr("url");

        var param = {
            "commentId": cmtId
        };

        $.post(url, param, function (data) {
            var json = jQuery.parseJSON(data);
            if (json.success != "true") {
                alert("删除该楼层失败！");
            } else {
                // 移除该楼层
                $floor.remove();
                // dom结构发生变化，“跳楼”按钮那里也要把删掉的楼层去除
                var $liContainer = $("#liContainer");
                $liContainer.find("li[cm=" + cmtNum + "]").remove();

            }
        });

    }



    function showOrHideContent(showOrHideLink) {

        var $a = $(showOrHideLink);
        var flag = $a.attr("flag");

        $a.parent("div").siblings(".accordion-title").trigger("click");

        if (flag == "down") {
            $a.html('<i class="fa fa-angle-up"></i>');
            $a.attr("flag", "up");

        } else {
            $a.html('<i class="fa fa-angle-down"></i>');
            $a.attr("flag", "down");
        }

    }

</script>


<%-- 其他楼层 --%>

<c:forEach items="${pageComments.results}" var="comment" varStatus="vs">

    <%-- comment -- 正在遍历 --%>
    <%-- 楼中楼回复 --%>

    <div class="row" cmtParentId="${comment.commentId}" index="${vs.index}" cmtNum="${comment.commentNum}">
        <div class="large-3 medium-3 columns left-avatar">
            <div class="user-avatar">
                <img src="${pageContext.request.contextPath}/static/image/01.jpg" height="95%" width="95%" class="thumbnail">
            </div>
            <div class="user-name">
                <a href="${pageContext.request.contextPath}/user/showOtherUserInfo.action?userId=${comment.userId}"
                   target="_blank" title="${comment.user.username}">${comment.user.username}</a>
            </div>
        </div>
        <div class="large-9 medium-9 columns right-content">

            <div class="padding-20-20-10-20-div">
                    <%--回复的内容--%>
                <div class="article-content">
                        ${comment.commentContent}
                </div>

                    <%--回复的时间，楼层数--%>
                <div class="article-publish-date" style="margin-bottom: 10px;">
                        <c:if test="${comment.userId == currentLoginUser.userId}">
                            <a href="javascript:void(0);" url="${pageContext.request.contextPath}/comment/deleteDirectComment.action"
                               onclick="deleteFloor(this)" class="delete-this-floor">删除</a>
                            <a href="javascript:void(0);" class="only-see-this-author">只看我</a>
                        </c:if>
                        <c:if test="${comment.userId != currentLoginUser.userId}">
                            <a href="#" class="only-see-this-author">只看该作者</a>
                        </c:if>
                        ${comment.commentNum}楼 | 发表于：<fmt:formatDate value="${comment.commentDate}" type="both"></fmt:formatDate>
                    <span onclick="showOrHideSubComment(this)" class="text-center article-reply">
                        <c:if test="${comment.subCommentCount == 0}">
                            <a count="${comment.subCommentCount}" href="javascript:void(0);">回复</a>
                        </c:if>
                        <c:if test="${comment.subCommentCount > 0}">
                            <a count="${comment.subCommentCount}" href="javascript:void(0);">隐藏</a>
                        </c:if>
                    </span>
                </div>


                    <%-- comment -- 正在遍历 --%>
                    <%-- 楼中楼回复 --%>
                <div class="article-sub-comment" style="">

                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                    <c:if test="${comment.subCommentCount == 0}">
                        <li class="accordion-item" data-accordion-item>
                    </c:if>
                    <c:if test="${comment.subCommentCount > 0}">
                        <li class="accordion-item is-active" data-accordion-item>
                    </c:if>
                            <a href="javascript:void(0);" class="accordion-title my-accordion-title" style="display: none;"></a>

                            <div class="accordion-content bg-white" data-tab-content style="padding: 1rem 1rem 0 1rem;">

                                <div class="refresh-div">
                                    <%--需要刷新的部分--%>

                                    <div class="sub-comment-content">
                                        <c:forEach items="${comment.pageSubComments.results}" var="subComment">
                                        <ul class="accordion margin-bottom-06rem" data-accordion data-allow-all-closed="true" data-slide-speed="80">
                                            <li class="accordion-item is-active" data-accordion-item>

                                                <a href="javascript:void(0);" style="display: none;" class="accordion-title my-accordion-title">${subComment.user.username}</a>

                                                <div class="text-left" style="border: 1px solid #e6e6e6; padding: 0.5rem 1rem; font-size: 12px;">
                                                    <a href="${pageContext.request.contextPath}/user/showOtherUserInfo.action?userId=${subComment.userId}"
                                                        target="_blank" >
                                                        ${subComment.user.username}
                                                    </a>
                                                    <a flag="down" onclick="showOrHideContent(this)" href="javascript:void(0);"
                                                       style="float: right; font-size: 18px; margin-top: 1px;"><i class="fa fa-angle-down"></i></a>
                                                </div>

                                                <div class="accordion-content my-accordion-content" data-tab-content style="border-top: 0px solid #e6e6e6;">
                                                    <ul class="bt-list-group my-bt-list-group" style="margin-left: 0;">
                                                        <li class="bt-list-group-item font-size-12">${subComment.commentContent}</li>
                                                    </ul>
                                                    <div class="article-publish-date" style="">
                                                            ${subComment.commentNum}号房 | 发表于：
                                                        <fmt:formatDate value="${subComment.commentDate}" type="both"></fmt:formatDate>
                                                        <span onclick="atAuthorSubCommentReply(this)" class="text-center article-reply">
                                                            <a href="javascript:void(0);">回复</a>
                                                        </span>
                                                    </div>
                                                </div>
                                            </li>
                                        </ul>
                                    </c:forEach>
                                    </div>

                                    <%--需要刷新的部分--%>
                                    <div class="sub-comment-pagination">
                                        <c:if test="${comment.pageSubComments.totalPageNum > 1}">
                                            <ul class="pagination text-center" role="pagination" style="margin-top: 0rem;">

                                                <li>
                                                    <a <c:if test="${comment.pageSubComments.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                                       class="pagination-a"
                                                       url="${pageContext.request.contextPath}/comment/showComment.action?articleId=${article.articleId}&commentId=${comment.commentId}&subPageNo=${comment.pageSubComments.currentPage-1}"
                                                       href="javascript:void(0);"
                                                       onclick="subPreAndNextPage(this)">&lt;</a>
                                                </li>

                                                <c:forEach items="${comment.pageSubComments.pageNums}" var="subPageNum">
                                                    <li>
                                                        <a <c:if test="${subPageNum == comment.pageSubComments.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                                                           class="pagination-a"
                                                           url="${pageContext.request.contextPath}/comment/showComment.action?articleId=${article.articleId}&commentId=${comment.commentId}&subPageNo=${subPageNum}"
                                                           href="javascript:void(0);"
                                                           onclick="subPreAndNextPage(this)">${subPageNum}</a>
                                                    </li>
                                                </c:forEach>

                                                <li>
                                                    <a <c:if test="${comment.pageSubComments.currentPage + 1 > comment.pageSubComments.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                                       class="pagination-a"
                                                       url="${pageContext.request.contextPath}/comment/showComment.action?articleId=${article.articleId}&commentId=${comment.commentId}&subPageNo=${comment.pageSubComments.currentPage+1}"
                                                       href="javascript:void(0);"
                                                       onclick="subPreAndNextPage(this)">&gt;</a>
                                                </li>

                                            </ul>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="sub-comment-reply-editor">
                                    <div style="width: 100%; margin: 0 auto;">
                                        <div class="subCommentEditor" id="subCommentEditor${comment.commentNum}" style="min-height: 100px;"></div>
                                    </div>
                                    <div class="article-publish-date" style="margin: 1rem 0;">
                                        <span onclick="subCommentReply(this)" class="text-center sub-comment-reply-span">
                                            <a url="${pageContext.request.contextPath}/comment/publishSubComment.action" href="javascript:void(0);">回 复</a>
                                        </span>
                                    </div>
                                </div>

                            </div>
                        </li>
                    </ul>

                </div>



            </div>

        </div>
    </div>


    <%--<%@ include file="/WEB-INF/jsp/comment/comment.jsp"%>--%>

</c:forEach>
