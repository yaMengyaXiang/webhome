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

            subEditors[i++] = subCommentEditor;

        });
    }

    //        显示楼中楼回复
    function showSubComment(subCommentSpanObj) {
        var subCommentDiv = $(subCommentSpanObj).parent().next(".article-sub-comment");
        var accordion = subCommentDiv.children(".accordion:first-child");
        var accordionItem = accordion.children(".accordion-item:first-child");
        var accordionTitle = accordionItem.children(".my-accordion-title:first-child");
        var accordionContent = accordionItem.children(".accordion-content:first-child");

//        accordion.foundation('up', accordionContent);

        accordionTitle.trigger("click");

//        accordionItem.removeClass(".is-active");

        var replyBtn = $(subCommentSpanObj).children(":first-child");

        if (replyBtn.text() == "隐藏") {
            var count = replyBtn.attr("count");
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


    //        显示回复框
    function showSubCommentReply(btnObj) {
//        var paginationAccordion = $(btnObj).parents(".pagination-accordion");
//        var subCommentReplyHead = paginationAccordion.next(".sub-comment-reply-accordion")
//                .find(".my-accordion-title:first-child");


        var articleSubComment = $(btnObj).parents(".article-sub-comment");
        var subEditorDiv = articleSubComment.next(".sub-comment-reply-editor");

        subEditorDiv.find(".accordion-title").trigger("click");

//        subCommentReplyHead.trigger("click");

    }


    //       楼中楼回复必须异步刷新
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
                    $(spanObj).parents(".sub-comment-reply-editor").siblings(".article-sub-comment").find(".refresh-div").html(data);

                    subEditors[index].$txt.html('<p><br></p>');

                });

            }
        });

    }



</script>


<%-- 其他楼层 --%>
<c:forEach items="${pageComments.results}" var="comment" varStatus="vs">

    <%-- comment -- 正在遍历 --%>
    <%-- 楼中楼回复 --%>
    <%--
    <div class="article-sub-comment" style="">

        <ul class="accordion" data-accordion data-allow-all-closed="true">
            <li class="accordion-item is-active" data-accordion-item>

                <a href="javascript:void(0);" class="accordion-title" style="display: none;"></a>

                <div class="accordion-content border-none bg-white" data-tab-content>

                    <c:forEach items="${comment.pageSubComments.results}" var="subComment">
                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                        <li class="accordion-item is-active" data-accordion-item>

                            <a href="javascript:void(0);" class="accordion-title my-accordion-title">${subComment.user.username}</a>
                            <div class="accordion-content my-accordion-content" data-tab-content>
                                <ul class="bt-list-group my-bt-list-group" style="margin-left: 0;">
                                    <li class="bt-list-group-item">
                                            ${subComment.commentContent}
                                    </li>
                                </ul>
                                <div class="article-publish-date" style="">
                                    ${subComment.commentNum}号房 | 发表于：
                                        <fmt:formatDate value="${subComment.commentDate}" type="both"></fmt:formatDate>
                                    <span onclick="" class="text-center article-reply">
                                        <a href="javascript:void(0);">回复</a>
                                    </span>
                                </div>
                            </div>
                        </li>
                    </ul>
                    </c:forEach>

                    <c:if test="${!empty comment.pageSubComments.results}">
                    <ul class="accordion pagination-accordion" data-accordion data-allow-all-closed="true">
                        <li class="accordion-item is-active" data-accordion-item>

                            <div class="accordion-content my-accordion-content" data-tab-content style=" padding: 14px 1rem 0;">
                                <ul class="bt-list-group my-bt-list-group" style="margin-left: 0;">
                                    <li class="bt-list-group-item my-bt-list-group-item border-none">

                                        <ul class="pagination" role="pagination" style="margin-top: 1rem;">

                                            <li>
                                                <a <c:if test="${comment.pageSubComments.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                                   class="pagination-a"
                                                   url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${comment.pageSubComments.currentPage-1}"
                                                   href="javascript:void(0);"
                                                   onclick="preAndNextPage(this)">&lt;</a>
                                            </li>

                                            <c:forEach items="${comment.pageSubComments.pageNums}" var="subPageNum">
                                                <li>
                                                    <a <c:if test="${subPageNum == comment.pageSubComments.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                                                       class="pagination-a"
                                                       url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${subPageNum}"
                                                       href="javascript:void(0);"
                                                       onclick="preAndNextPage(this)">${subPageNum}</a>
                                                </li>
                                            </c:forEach>

                                            <li>
                                                <a <c:if test="${comment.pageSubComments.currentPage + 1 > comment.pageSubComments.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                                   class="pagination-a"
                                                   url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${comment.pageSubComments.currentPage+1}"
                                                   href="javascript:void(0);"
                                                   onclick="preAndNextPage(this)">&gt;</a>
                                            </li>

                                        </ul>

                                        <div class="" style="position: absolute; top: 5px; right: 0;">
                                            <span onclick="showSubCommentReply(this)" class="text-center sub-comment-reply-span">
                                                <a href="javascript:void(0);">我也来回复</a>
                                            </span>
                                        </div>

                                    </li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                    </c:if>

                    <ul class="accordion sub-comment-reply-accordion" data-accordion data-allow-all-closed="true">
                        <li class="accordion-item" data-accordion-item>

                            <a href="javascript:void(0);" class="accordion-title my-accordion-title" style="display: none;"></a>

                            <div class="accordion-content my-accordion-content" data-tab-content>
                                <ul class="bt-list-group my-bt-list-group" style="margin-left: 0;">
                                    <li class="bt-list-group-item border-none" style="padding-left: 0; padding-right: 0;">

                                        <div style="width: 100%; margin: 0 auto;">
                                            <div class="subCommentEditor" id="subCommentEditor${comment.commentNum}" style="min-height: 50px;"></div>
                                        </div>

                                    </li>
                                </ul>
                                <div class="article-publish-date" style="">
                                    <span onclick="subCommentReply(${vs.index}, this)" class="text-center sub-comment-reply-span">
                                        <a url="${pageContext.request.contextPath}/comment/publishSubComment.action" href="javascript:void(0);">回复</a>
                                    </span>
                                </div>
                            </div>
                        </li>
                    </ul>

                </div>
            </li>
        </ul>

    </div>--%>

    <div class="row" cmtParentId="${comment.commentId}" index="${vs.index}">
        <div class="large-3 medium-3 columns left-avatar">
            <div class="user-avatar">
                <img src="${pageContext.request.contextPath}/static/image/01.jpg" height="95%" width="95%" class="thumbnail">
            </div>
            <div class="user-name">
                <label>${comment.user.username}</label>
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
                    <a href="#" class="only-see-this-author">只看该作者</a>
                        ${comment.commentNum}楼 | 发表于：<fmt:formatDate value="${comment.commentDate}" type="both"></fmt:formatDate>
                    <span onclick="showSubComment(this)" class="text-center article-reply">
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

                            <div class="refresh-div accordion-content bg-white" data-tab-content style="padding: 1rem 1rem 0 1rem;">

                                <div class="sub-comment-content">

                                    <%--需要刷新的部分--%>
                                    <c:forEach items="${comment.pageSubComments.results}" var="subComment">
                                        <ul class="accordion margin-bottom-06rem" data-accordion data-allow-all-closed="true">
                                            <li class="accordion-item is-active" data-accordion-item>

                                                <a href="javascript:void(0);" class="accordion-title my-accordion-title">${subComment.user.username}</a>

                                                <div class="accordion-content my-accordion-content" data-tab-content>
                                                    <ul class="bt-list-group my-bt-list-group" style="margin-left: 0;">
                                                        <li class="bt-list-group-item">
                                                                ${subComment.commentContent}
                                                        </li>
                                                    </ul>
                                                    <div class="article-publish-date" style="">
                                                            ${subComment.commentNum}号房 | 发表于：
                                                        <fmt:formatDate value="${subComment.commentDate}" type="both"></fmt:formatDate>
                                                        <span onclick="" class="text-center article-reply">
                                                        <a href="javascript:void(0);">回复</a>
                                                    </span>
                                                    </div>
                                                </div>
                                            </li>
                                        </ul>
                                    </c:forEach>


                                </div>

                                <div class="sub-comment-pagination">
                                    <c:if test="${comment.pageSubComments.totalPageNum > 1}">
                                    <ul class="pagination text-center" role="pagination" style="margin-top: 0rem;">

                                        <li>
                                            <a <c:if test="${comment.pageSubComments.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                               class="pagination-a"
                                               url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${comment.pageSubComments.currentPage-1}"
                                               href="javascript:void(0);"
                                               onclick="preAndNextPage(this)">&lt;</a>
                                        </li>

                                        <c:forEach items="${comment.pageSubComments.pageNums}" var="subPageNum">
                                            <li>
                                                <a <c:if test="${subPageNum == comment.pageSubComments.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                                                   class="pagination-a"
                                                   url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${subPageNum}"
                                                   href="javascript:void(0);"
                                                   onclick="preAndNextPage(this)">${subPageNum}</a>
                                            </li>
                                        </c:forEach>

                                        <li>
                                            <a <c:if test="${comment.pageSubComments.currentPage + 1 > comment.pageSubComments.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                               class="pagination-a"
                                               url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${comment.pageSubComments.currentPage+1}"
                                               href="javascript:void(0);"
                                               onclick="preAndNextPage(this)">&gt;</a>
                                        </li>

                                    </ul>
                                    </c:if>
                                </div>

                                <div class="sub-comment-reply-editor">
                                    <div style="width: 100%; margin: 0 auto;">
                                        <div class="subCommentEditor" id="subCommentEditor${comment.commentNum}" style="min-height: 50px;"></div>
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

