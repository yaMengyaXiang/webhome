<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-30
  Time: 0:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<option value="">请选择</option>
<c:forEach items="${categories}" var="category">
    <option value="${category.categoryId}">${category.categoryName}</option>
</c:forEach>
