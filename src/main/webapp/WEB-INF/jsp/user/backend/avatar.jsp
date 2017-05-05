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

    <link href="//cdn.bootcss.com/cropper/3.0.0-rc.1/cropper.min.css" rel="stylesheet">
    <script src="//cdn.bootcss.com/cropper/3.0.0-rc.1/cropper.min.js"></script>

    <style>
        body {
            background-color: #fcfcfc;
        }

        .avatar-view img {
            width: 100%;
        }

        .avatar-body {
            padding-right: 15px;
            padding-left: 15px;
        }

        .avatar-upload {
            overflow: hidden;
        }

        .avatar-wrapper {
            width: 100%;
            margin-top: 15px;
            box-shadow: inset 0 0 5px rgba(0,0,0,.25);
            background-color: #fcfcfc;
            overflow: hidden;
        }

        .avatar-wrapper img {
            display: block;
            height: auto;
            max-width: 100%;
        }

        .avatar-preview {
            float: left;
            margin-top: 15px;
            margin-right: 15px;
            border-radius: 4px;
            background-color: #fff;
            overflow: hidden;
        }

        .avatar-preview:hover {
            border-color: #ccf;
            box-shadow: 0 0 5px rgba(0,0,0,.15);
        }

        .avatar-preview img {
            width: 100%;
        }

    </style>

    <script type="text/javascript">

        $(function () {

            $(document).foundation();

            $("input[name='avatar_file']").unbind("change");
            $("input[name='avatar_file']").bind("change", function () {
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
                    $("#image").attr("src", objUrl);

                    var $previews = $('.avatar-preview');

                    $('#image').cropper({
                        ready: function (e) {
                            var $clone = $(this).clone().removeClass('cropper-hidden');

                            $clone.css({
                                display: 'block',
                                width: '100%',
                                minWidth: 0,
                                minHeight: 0,
                                maxWidth: 'none',
                                maxHeight: 'none'
                            });

                            $previews.css({
//                                width: '100%',
                                overflow: 'hidden'
                            }).html($clone);

                        },
                        dragMode: 'move',
                        viewMode: 1,
                        aspectRatio: 16 / 9,
                        crop: function (e) {
                            // Output the result data for cropping image.
                            console.log(e.x);
                            console.log(e.y);
                            console.log(e.width);
                            console.log(e.height);
                            console.log(e.rotate);
                            console.log(e.scaleX);
                            console.log(e.scaleY);
                            var imageData = $(this).cropper('getImageData');

                            var previewAspectRatio = e.width / e.height;

                            $previews.each(function () {
                                var $preview = $(this);
                                var previewWidth = $preview.width();
                                var previewHeight = previewWidth / previewAspectRatio;
                                var imageScaledRatio = e.width / previewWidth;

                                $preview.height(previewHeight).find('img').css({
                                    width: imageData.naturalWidth / imageScaledRatio,
                                    height: imageData.naturalHeight / imageScaledRatio,
                                    marginLeft: -e.x / imageScaledRatio,
                                    marginTop: -e.y / imageScaledRatio
                                });

                            });
                        }

                    });


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


        function changeAvatar() {
            $("#avatarBtn").trigger("click");
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
                                <img id="user-image" onclick="changeAvatar()" src="${pageContext.request.contextPath}/static/image/04.jpg">
                            </div>
                        </div>

                        <div class="row">

                            <div class="medium-12 columns">
                                <button id="avatarBtn" style="display: none;" data-toggle="avatarModal"></button>

                                <div class="large reveal" id="avatarModal" data-reveal data-close-on-click="true"
                                     data-animation-in="slide-in-down">

                                    <ul class="accordion" data-accordion data-allow-all-closed="true">
                                        <li class="accordion-item is-active" data-accordion-item>
                                            <a href="javascript:void(0);" class="accordion-title bg-light-blue">
                                                <i class="fa fa-tags"></i> 更换头像
                                            </a>

                                            <div class="accordion-content" data-tab-content>
                                                <form id="avatarForm"
                                                      action="${pageContext.request.contextPath}/user/addOrEditCategory.action">
                                                    <div class="avatar-body">

                                                        <!-- Upload image and data -->
                                                        <div class="row avatar-upload">
                                                            <input type="hidden" class="avatar-src" name="avatar_src">
                                                            <input type="hidden" class="avatar-data" name="avatar_data">

                                                            <div class="small-2 columns">
                                                                <label class="text-center middle">请选择图片：</label>
                                                            </div>

                                                            <div class="small-8 columns">
                                                                <input type="file" style="margin-left: -24px; margin-top: 8px;" class="middle"
                                                                       id="avatarInput" name="avatar_file">
                                                            </div>
                                                            <div class="medium-2 columns">
                                                                <button type="submit" class="button avatar-save" style="margin-top: 7px;">
                                                                    裁剪
                                                                </button>
                                                            </div>

                                                        </div>

                                                        <!-- Crop and preview -->
                                                        <div class="row">
                                                            <div class="medium-8 columns">
                                                                <div class="avatar-wrapper" style="width: 100%; height: 100%;">
                                                                    <img id="image" onclick="changeAvatar()" src="">
                                                                </div>
                                                            </div>
                                                            <div class="medium-4 columns">
                                                                <div class="avatar-preview" style="width: 82%;"></div>
                                                                <div class="avatar-preview" style="width: 65%;"></div>
                                                                <div class="avatar-preview" style="width: 45%;"></div>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </form>
                                            </div>
                                        </li>
                                    </ul>

                                    <button class="close-button" data-close aria-label="Close" type="button">

                                    </button>

                                </div>
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
