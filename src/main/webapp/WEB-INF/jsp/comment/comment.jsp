<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-23
  Time: 16:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script type="text/javascript">

    $(function () {

        $(document).foundation();

    });


</script>

                    <c:forEach items="${cmt.pageSubComments.results}" var="subComment">
                        <ul class="accordion margin-bottom-1rem" data-accordion data-allow-all-closed="true">
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

                    <ul class="accordion pagination-accordion" data-accordion data-allow-all-closed="true">
                        <li class="accordion-item is-active" data-accordion-item>

                            <div class="accordion-content my-accordion-content" data-tab-content style=" padding: 14px 1rem 0;">
                                <ul class="bt-list-group my-bt-list-group" style="margin-left: 0;">
                                    <li class="bt-list-group-item my-bt-list-group-item border-none">

                                        <%--<c:if test="${cmt.pageSubComments.totalPageNum != 1}">--%>
                                        <ul class="pagination" role="pagination" style="margin-top: 0rem;">

                                            <li>
                                                <a <c:if test="${cmt.pageSubComments.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                                   class="pagination-a"
                                                   url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${cmt.pageSubComments.currentPage-1}"
                                                   href="javascript:void(0);"
                                                   onclick="preAndNextPage(this)">&lt;</a>
                                            </li>

                                            <c:forEach items="${cmt.pageSubComments.pageNums}" var="subPageNum">
                                                <li>
                                                    <a <c:if test="${subPageNum == cmt.pageSubComments.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                                                       class="pagination-a"
                                                       url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${subPageNum}"
                                                       href="javascript:void(0);"
                                                       onclick="preAndNextPage(this)">${subPageNum}</a>
                                                </li>
                                            </c:forEach>

                                            <li>
                                                <a <c:if test="${cmt.pageSubComments.currentPage + 1 > cmt.pageSubComments.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                                                   class="pagination-a"
                                                   url="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}&pageNo=${cmt.pageSubComments.currentPage+1}"
                                                   href="javascript:void(0);"
                                                   onclick="preAndNextPage(this)">&gt;</a>
                                            </li>

                                        </ul>
                                        <%--</c:if>--%>

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
