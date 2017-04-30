<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-30
  Time: 0:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<div class="medium-12 columns">
    源节点：
    <select name="sourceNodeId">
        <option>请选择</option>
        <c:forEach items="${nodes}" var="node">
            <option value="${node.nodeId}">${node.nodeName}</option>
        </c:forEach>
    </select>
</div>
<div class="medium-12 columns">
    目标节点：
    <select name="targetNodeId">
        <option>请选择</option>
        <c:forEach items="${nodes}" var="node">
            <option value="${node.nodeId}">${node.nodeName}</option>
        </c:forEach>
    </select>
</div>
