<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-05-10
  Time: 22:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<c:forEach items="${pageArticles.results}" var="article">
    <div class="article-list-div">

        <div class="row" style="font-size: 16px; margin-bottom: 10px;">
            <a target="_blank"
               href="${pageContext.request.contextPath}/article/showArticleDetail.action?articleId=${article.articleId}">${article.title}</a>
        </div>
        <div class="row margin-bottom-1rem">
                ${fn:substring(article.summary, 0, 100)}
            <c:set var="sumLen" value="${fn:length(article.summary)}"/>
            <c:if test="${sumLen > 100 }">...</c:if>
        </div>
        <div class="row text-right">
            发表于：
            <fmt:formatDate value="${article.publishDate}" type="both"/>
        </div>

    </div>
</c:forEach>

<div class="row">
    <div class="padding-5-20-div">
        <c:if test="${!empty pageArticles.results}">
            <ul class="pagination" role="pagination">

                <li>
                    <a <c:if test="${pageArticles.currentPage - 1 == 0}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                       class="pagination-a"
                       url="${pageContext.request.contextPath}/user/showOtherUserArticles.action?pageNo=${pageArticles.currentPage-1}&userId=${userId}"
                       href="javascript:void(0);"
                       onclick="preAndNextPage(this, ${pageArticles.currentPage-1})">&lt;&lt;</a>
                </li>

                <c:forEach items="${pageNums}" var="pageNum">
                    <li>
                        <a <c:if test="${pageNum == pageArticles.currentPage}">style="background: #1779ba none repeat scroll 0 0;color: #fefefe;cursor: default;" </c:if>
                           class="pagination-a"
                           url="${pageContext.request.contextPath}/user/showOtherUserArticles.action?pageNo=${pageNum}&userId=${userId}"
                           href="javascript:void(0);"
                           onclick="preAndNextPage(this, ${pageNum})">${pageNum}</a>
                    </li>
                </c:forEach>

                <li>
                    <a <c:if test="${pageArticles.currentPage + 1 > pageArticles.totalPageNum}">style="cursor: not-allowed;color: #cacaca; border: 1px solid #cacaca;"</c:if>
                       class="pagination-a"
                       url="${pageContext.request.contextPath}/user/showOtherUserArticles.action?pageNo=${pageArticles.currentPage+1}&userId=${userId}"
                       href="javascript:void(0);"
                       onclick="preAndNextPage(this, ${pageArticles.currentPage+1})">&gt;&gt;</a>
                </li>

            </ul>
        </c:if>
    </div>
</div>