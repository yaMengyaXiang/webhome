<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/4/8
  Time: 12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head lang="zh-cn">

    <title>我的折腾链</title>

    <%@include file="/WEB-INF/jsp/common/static.jsp"%>


</head>
<body>

<%@include file="/WEB-INF/jsp/common/header.jsp"%>

<div class="row">
    <div class="padding-20-5-div">

        <%@include file="/WEB-INF/jsp/user/left-menu.jsp"%>

        <div id="mainContent" class="medium-8 large-9 columns">

            <%@include file="/WEB-INF/jsp/user/backend/link/right.jsp"%>

        </div>

    </div>
</div>

</body>
</html>
