<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/3/27
  Time: 0:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head lang="zh-cn">
    <meta charset="UTF-8">
    <title>登陆</title>


    <%@include file="/WEB-INF/jsp/common/static.jsp"%>


    <script type="text/javascript">

        // 删除字符串左右空格
        function trim(str) {
            return str.replace(/(^\s*)|(\s*$)/g, "");
        }


        $(document).ready(function() {

            adjustHeight();

            $(window).resize(function() {
                adjustHeight();
            });

            $("#username").blur(function() {

                var username = trim($(this).val());
//                var username = trim($(this).attr("value"));

                if ("" == username || username == null) {
                    $("label.login-error-msg-label").text("请输入用户名或邮箱 !");
                    return;
                }

                var top = $(this).offset().top;
                var left = $(this).offset().left;
                top = top + 10;
                var w = $(this).width();
                left = left + w - 12;

                var $loadImg = $("<img src='${pageContext.request.contextPath}/static/image/loading.gif' width='20px' height='20px'>");
                $loadImg.css("position", "absolute");
                $loadImg.css("top", top + "px");
                $loadImg.css("left", left + "px");

                $loadImg.insertBefore($(this));

                console.log(username);

                // ajax请求后台，判断是否有此用户名的用户
                var url = "${pageContext.request.contextPath}/user/validate.action";
                var param = {
                    "username": username
                };
                $.post(url, param, function (data) {
                    // 字符串转json对象
                    var json = jQuery.parseJSON(data);
                    $loadImg.remove();
                    // 不存在该用户
                    if ("false" == json.isExisted) {
                        // 给出提示
                        $("label.login-error-msg-label").text("不存在该名称的用户 !");
                    } else {
                        $("label.login-error-msg-label").empty();
                    }

                });

            });

            $("#username").keydown(function () {
                $("label.login-error-msg-label").text("");
            });

            $("#loginBtn").unbind("click");
            $("#loginBtn").bind("click", function () {

//                var username = trim($(".login-form-item-input:text:first").attr("value"));
                var username = trim($("#username").val());
                console.log(username);

                var password = trim($("#password").val());
//                var fromUrl = trim($(".login-form-item-input:hidden:first").val());
                if ("" == username || username == null) {
                    $("label.login-error-msg-label").text("请输入用户名或邮箱 !");
                    return;
                }
                if ("" == password || password == null) {
                    $("label.login-error-msg-label").text("请输入您的密码 !");
                    return;
                }

                $("#loginForm").submit();

            });

        });

        /*适应高度，窗口放大缩小时用来调整div的高度，宽度100%不变*/
        function adjustHeight() {
            // 浏览器当前窗口的高度 错错！！！这个是页面的高度，应该带边框的
            var browserHeight = $(window).height();

            // 下面这个才是浏览器窗口的大小
//            var browserHeight = $(document.body).outerHeight(true);

            var $login = $(".login-box");
            var lHeight = $login.height();

            var top = (browserHeight - lHeight) >> 1;
            top = top - 20;
            if (top < 0) {
                top = 0;
            }
            console.log(top);
            $login.css("margin-top", top + "px");

        }

    </script>


</head>
<body style="background-color: #333234;">

    <div class="large-4 medium-6 small-10 small-centered large-centered medium-centered columns">
        <div class="login-box">
            <div class="row">
                <div class="large-12 columns align-middle">
                    <form id="loginForm" action="${pageContext.request.contextPath}/user/login.action" method="post">
                        <div class="row">
                            <div class="large-12 columns text-center login-logo">
                                <img src="${pageContext.request.contextPath}/static/image/logo-black.png">
                            </div>
                        </div>
                        <div class="row">
                            <div class="large-12 columns" style="margin-bottom: 20px;">
                                <label class="login-error-msg-label">${errorMsg}</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="large-12 columns" style="">
                                <input id="username" class="" type="text" name="username" placeholder="Username or E-mail">
                            </div>
                        </div>
                        <div class="row">
                            <div class="large-12 columns">
                                <input id="password" class="" type="password" name="password" placeholder="Password">
                            </div>
                        </div>
                        <div class="row">
                            <div class="large-12 columns">
                                <label>请输入验证码: </label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="large-6 medium-6 small-6 columns">
                                <input class="" type="text" style="height: 40px;">
                            </div>
                            <div class="large-6 medium-6 small-6 columns text-center">
                                <img src="" style="height: 40px; width: 120px;">
                            </div>
                        </div>
                        <div class="row">
                            <div class="large-12 large-centered columns">
                                <a id="loginBtn" href="javascript:void(0);" class="button expanded">Login</a>
                            </div>
                        </div>
                        <div class="row">
                            <div class="large-12 large-centered columns" style="margin-bottom: 20px;">
                                <a id="login-forgot-a" href="javascript:void(0);" class="">忘记密码 ? 请点击这里 !</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
