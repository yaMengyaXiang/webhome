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

        menubar.adjustMenubar("left-menubar", "left");

        $(window).resize(function () {

            menubar.adjustMenubar("left-menubar", "left");

        });

    });


</script>


<%--左边菜单栏--%>
<div id="left-menubar" class="hide-for-small-only" style="z-index: 50;">
    <ul class="vertical dropdown menu" data-dropdown-menu>
        <li class="opens-right">
            <a class="my-vertical-menubar-a">按钮</a>
            <ul class="menu">
                <li><a href="#">Item A</a></li>
                <li><a href="#">Item B</a></li>
                <li><a href="#">Item C</a></li>
            </ul>
        </li>
        <li class="opens-right">
            <a class="my-vertical-menubar-a">跳楼</a>
            <ul class="menu">
                <li><a href="#">Item A</a></li>
                <li><a href="#">Item B</a></li>
                <li><a href="#">Item C</a></li>
                <li><a href="#">Item D</a></li>
                <li><a href="#">Item E</a></li>
                <li><a href="#">Item F</a></li>
                <li><a href="#">Item G</a></li>
                <li><a href="#">Item H</a></li>
                <li><a href="#">Item I</a></li>
                <li><a href="#">Item J</a></li>
            </ul>
        </li>
    </ul>
</div>