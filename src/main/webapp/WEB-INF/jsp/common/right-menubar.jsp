<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-24
  Time: 22:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/menubar.js"></script>

<script type="text/javascript">

    $(function () {

        menubar.locateOnload("right-menubar");

        menubar.adjustMenubar("right-menubar", "right");

        $(window).resize(function () {

            menubar.adjustMenubar("right-menubar", "right");

        });


        $(window).scroll(function () {
            menubar.scrollToTop("right-menubar");
        });


    });


</script>

<%--右边菜单栏--%>
<div id="right-menubar" class="hide-for-small-only" style="z-index: 50;"></div>