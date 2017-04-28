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

    <title>个人中心</title>

    <%@include file="/WEB-INF/jsp/common/static.jsp"%>


    <script type="text/javascript">
        $(function() {

            $(document).foundation();

            $("input[name='avatar']").unbind("change");
            $("input[name='avatar']").bind("change", function() {
                var avatar = $(this).val();

                if (avatar == "") {
                    alert("请选择图片！");
                    return;
                }
                var extName = avatar.substring(avatar.lastIndexOf("."));
                if (".jpg" != extName && ".jpeg" != extName
                        && ".png" != extName && ".gif" != extName) {
                    alert("请选择图片上传！");
                    return;
                }

                var objUrl = getObjectURL(this.files[0]);
                if (objUrl) {
                    $("#user-image").attr("src", objUrl);
                }

            });

        });

        // 建立一个可存取到该file的url
        function getObjectURL(file) {
            var url = null;
            if (window.createObjectURL != undefined) {	// basic
                url = window.createObjectURL(file);
            } else if (window.URL != undefined) {	// mozilla(firefox)
                url  = window.URL.createObjectURL(file);
            } else if (window.webkitURL != undefined) {	// webkit or chrome
                url = window.webkitURL.createObjectURL(file);
            }
            return url;
        }

    </script>


</head>
<body>

<%@include file="/WEB-INF/jsp/common/header.jsp"%>

<div class="row">
    <div class="padding-20-5-div">

        <%@include file="/WEB-INF/jsp/user/left-menu.jsp"%>

        <div id="mainContent" class="medium-8 large-9 columns">
            <ul class="accordion" data-accordion data-allow-all-closed="true">
                <li class="accordion-item is-active" data-accordion-item>

                    <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                        <i class="fa fa-picture-o"></i>
                        头像设置
                    </a>

                    <div class="accordion-content" data-tab-content>

                        <div class="row">
                            <div class="medium-8 columns">
                                <label>
                                    请选择图片：
                                    <input type="file" name="avatar">
                                </label>
                            </div>
                            <div class="medium-4 columns text-right">
                                <button class="button" style="margin-top: 1rem;">更新头像</button>
                            </div>
                        </div>
                        <div class="row" style="width: 90%; margin: 0 auto;">
                            <div class="medium-12 columns">
                                <img id="user-image" src="" alt="我的头像">
                            </div>
                        </div>

                    </div>
                </li>
            </ul>
        </div>

    </div>
</div>

</body>
</html>
