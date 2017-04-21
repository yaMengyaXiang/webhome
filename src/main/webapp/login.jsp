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

    <%--<script src="//cdn.bootcss.com/jquery/2.2.4/jquery.min.js"></script>--%>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ztrs.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/reset.css">

    <script src="${pageContext.request.contextPath}/static/js/jquery-2.1.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/login.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/util.js"></script>

    <script type="text/javascript">

        // 删除字符串左右空格
        function trim(str) {
            return str.replace(/(^\s*)|(\s*$)/g, "");
        }


        $(document).ready(function() {

            loginUtil.loginFunctions();

            $(window).resize(function() {
                loginUtil.loginFunctions();
            });

            $(".login-form-item-input:text:first").blur(function() {

                var username = trim($(this).val());
//                var username = trim($(this).attr("value"));

                if ("" == username || username == null) {
                    $("label.login-error-msg-label").text("请输入用户名或邮箱 !");
                    return;
                }

                var $loadImg = $("<img src='${pageContext.request.contextPath}/static/image/loading.gif' width='20px' height='20px'>");
                $loadImg.css("position", "relative");
                $loadImg.css("float", "right");
                $loadImg.css("bottom", "32px");
                $loadImg.css("margin-right", "8px");

                $loadImg.insertAfter($(this));

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

            $(".login-form-item-input:text:first").keydown(function () {
                $("label.login-error-msg-label").text("");
            });

            $("#login-login-btn-a").unbind("click");
            $("#login-login-btn-a").bind("click", function () {

//                var username = trim($(".login-form-item-input:text:first").attr("value"));
                var username = trim($(".login-form-item-input:text:first").val());
                console.log(username);

                var password = trim($(".login-form-item-input:password:first").val());
//                var fromUrl = trim($(".login-form-item-input:hidden:first").val());
                if ("" == username || username == null) {
                    $("label.login-error-msg-label").text("请输入用户名或邮箱 !");
                    return;
                }
                if ("" == password || password == null) {
                    $("label.login-error-msg-label").text("请输入您的密码 !");
                    return;
                }

                $("#login-form-div > form:first").submit();

            });

        });

    </script>

</head>
<body style="overflow-y: hidden;">

<div id="login-top-div" >
    <div></div>
</div>
<div id="login-bottom-div">
    <div></div>
</div>

<div id="login-form-div">
    <form action="${pageContext.request.contextPath}/user/login.action" method="post">
        <div class="login-logo-div">
            <img src="${pageContext.request.contextPath}/static/image/logo-black.png">
        </div>
        <div class="login-form-item-div" style="height: 24px;">
            <label class="login-error-msg-label">${errorMsg}</label>
        </div>
        <div class="login-form-item-div">
            <input class="login-form-item-input" type="text" name="username" placeholder="Username or E-mail">
        </div>
        <div class="login-form-item-div">
            <input class="login-form-item-input" type="password" name="password" placeholder="Password">
        </div>
        <div class="login-form-item-div" style="text-align: left;">
            <div style="">
                <label>请输入验证码: </label>
            </div>
            <div style="">
                <input class="login-form-item-input" type="text" style="width: 30%;">
                <img src="" style="height: 44px; width: 120px; float: right;">
            </div>
        </div>
        <div class="login-form-item-div" style="text-align: center;">
            <a id="login-login-btn-a" href="javascript:void(0);" class="">Login</a>
        </div>
        <div class="login-form-item-div" style="text-align: center; margin: 20px auto;">
            <a id="login-forgot-a" href="javascript:void(0);" class="">忘记密码 ? 请点击这里 !</a>
        </div>
    </form>
</div>

</body>
</html>
