<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/3/28
  Time: 21:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">

    $(document).ready(function() {

        $("#index-to-login").unbind("click");
        $("#index-to-login").bind("click", function () {

            var url = "${pageContext.request.contextPath}/user/toLogin.action";

            window.location.href = url;

        });

        $("#index-to-my-info").unbind("click");
        $("#index-to-my-info").bind("click", function () {

            var url = "${pageContext.request.contextPath}/user/toMyBackend.action";

            window.location.href = url;

        });

        $(".to-index").unbind("click");
        $(".to-index").bind("click", function () {

            var url = "${pageContext.request.contextPath}/";

            window.location.href = url;

        });

        $("#index-to-relogin").unbind("click");
        $("#index-to-relogin").bind("click", function () {

            var url = "${pageContext.request.contextPath}/user/relogin.action";

            window.location.href = url;

        });

        $("#index-to-zheteng-link").unbind("click");
        $("#index-to-zheteng-link").bind("click", function () {

            var url = "${pageContext.request.contextPath}/user/toMyZheTengLink.action";

            window.location.href = url;

        });
    });

</script>

<!-- 顶部logo栏-->
<div class="row hide-for-small-only" id="logoBar">
    <div class="title-bar bg-black" style="padding: 0.2rem 0.5rem;">
        <div id="leftTitle" class="title-bar-left" style="margin-top: 4px; margin-left: 10px;">
            <a class="to-index" href="javascript:void(0);">
                <img src="${pageContext.request.contextPath}/static/image/logo-small.png">
            </a>
        </div>
        <div class="title-bar-right">
            <ul id="header-menu-ul" class="menu">
                <li>
                    <a href="${pageContext.request.contextPath}/">首页</a>
                </li>
                <li>
                    <a id="index-to-zheteng-link" href="javascript:void(0);">我的折腾链</a>
                </li>
                <c:if test="${empty currentLoginUser}">
                    <li>
                        <a id="index-to-login" href="javascript:void(0);">登录</a>
                    </li>
                    <li>
                        <a href="#">注册</a>
                    </li>
                </c:if>
                <c:if test="${!empty currentLoginUser}">
                    <li>
                        <a id="index-to-my-info" href="javascript:void(0);">${currentLoginUser.username}</a>
                    </li>
                    <li>
                        <a id="index-to-relogin" href="javascript:void(0);">重新登录</a>
                    </li>
                </c:if>
                <li>
                    <a href="#">关于本站</a>
                </li>
            </ul>
        </div>

    </div>
</div>

<!-- 手机设备的导航栏-->
<div class="show-for-small-only" data-sticky-container>
    <div class="title-bar bg-black sticky" style="width: 100%;" data-sticky-on="small" data-sticky data-margin-top="0" data-hide-for="medium">
        <div class="title-bar-left">
            <button class="menu-icon" type="button" data-toggle="offCanvasLeft"></button>
            <a class="to-index" href="javascript:void(0);">
                <img src="${pageContext.request.contextPath}/static/image/logo-small.png">
            </a>
        </div>
        <div class="title-bar-right">
            <button class="" style="color: white; cursor: pointer; position: relative; top: 1px;" type="button" data-toggle="offCanvasRight">版块</button>
            <button class="menu-icon" type="button" data-toggle="offCanvasRight"></button>
        </div>
    </div>
</div>

<!-- off canvas效果的左边滑动弹窗-->
<div class="off-canvas-wrapper show-for-small-only" style="z-index: 20;">
    <div class="off-canvas position-left bg-black" data-off-canvas id="offCanvasLeft">
        <!-- Close button -->
        <button class="close-button" style="color: #cccccc;" aria-label="Close menu" type="button" data-close>
            <span aria-hidden="true">&times;</span>
        </button>

        <div class="header-title-div" style="margin-top: 10px;">
            <i></i>
            <a class="titleLink" style="color: #97dcef;" href="#">快捷链接</a>
        </div>
        <div class="data-list-div">
            <!-- Menu -->
            <ul class="vertical menu">
                <li><a href="#">Foundation</a></li>
                <li><a href="#">Dot</a></li>
                <li><a href="#">ZURB</a></li>
                <li><a href="#">Com</a></li>
                <li><a href="#">Slash</a></li>
                <li><a href="#">Sites</a></li>
            </ul>
        </div>
    </div>
</div>


<!-- off canvas效果的右边滑动弹窗-->
<div class="off-canvas-wrapper show-for-small-only" style="z-index: 50;">
    <div class="off-canvas position-right bg-black" data-off-canvas id="offCanvasRight">
        <!-- Close button -->
        <button class="close-button" style="color: #cccccc;" aria-label="Close menu" type="button" data-close>
            <span aria-hidden="true">&times;</span>
        </button>

        <div class="header-title-div" style="margin-top: 10px;">
            <i></i>
            <a class="titleLink" style="color: #97dcef;" href="#">全部版块</a>
        </div>
        <div class="data-list-div">
            <!-- Menu -->
            <ul class="vertical menu">
                <li><a href="#">Foundation</a></li>
                <li><a href="#">Dot</a></li>
                <li><a href="#">ZURB</a></li>
                <li><a href="#">Com</a></li>
                <li><a href="#">Slash</a></li>
                <li><a href="#">Sites</a></li>
            </ul>
        </div>
    </div>
</div>
