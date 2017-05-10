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

    <%--<link href="//cdn.bootcss.com/cropper/3.0.0-rc.1/cropper.min.css" rel="stylesheet">--%>
    <%--<script src="//cdn.bootcss.com/cropper/3.0.0-rc.1/cropper.min.js"></script>--%>

    <link href="${pageContext.request.contextPath}/static/css/cropper.min.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/static/js/cropper.min.js"></script>

    <script src="//cdn.bootcss.com/jquery.form/4.2.1/jquery.form.min.js"></script>

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

            $("#avatar").unbind("change");
            $("#avatar").bind("change", function () {
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

                    $("#image").cropper('replace', objUrl);

                }

            });

            imageCropper();


            $("#submitBtn").unbind("click");
            $("#submitBtn").bind("click", function() {

                var $imgData = $("#image").cropper('getData', {rounded: true}); // 裁剪后的图片数据

                var x = $imgData.x;
                var y = $imgData.y;
                var height = $imgData.height;
                var width = $imgData.width;

                var $form = $("#avatarForm");

                var url = $form.attr("action");

//                var data = $form.serialize();

                $("#cropX").val(x);
                $("#cropY").val(y);
                $("#cropHeight").val(height);
                $("#cropWidth").val(width);

                var param = {
                    "url": url,
                    "dataType": "json",
                    "type": "post",
                    "success": function (data) {
                        if (data.success == "true") {
                            window.location.reload();
                        } else {
                            alert("头像修改失败！");
                        }
                    }
                };

                console.log(param);

                // ajax表单异步提交
                $form.ajaxSubmit(param);

            });

        });

        function imageCropper() {

            var $previews = $('.avatar-preview');

            $("#image").cropper({
                ready: function (e) {
                    var $clone = $(this).clone().removeClass('cropper-hidden').removeAttr("id");

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
                            <div class="avatar-body">

                                <!-- Upload image and data -->
                                <div class="row avatar-upload">

                                    <form id="avatarForm" method="post" enctype="multipart/form-data"
                                        action="${pageContext.request.contextPath}/user/uploadImage.action">
                                        <div class="small-2 columns">
                                            <label class="text-center middle">请选择图片：</label>
                                        </div>

                                        <div class="small-8 columns">
                                            <input type="file" style="margin-left: -24px; margin-top: 8px;" class="middle"
                                               id="avatar" name="avatar">
                                            <input type="hidden" name="cropX" id="cropX">
                                            <input type="hidden" name="cropY" id="cropY">
                                            <input type="hidden" name="cropWidth" id="cropWidth">
                                            <input type="hidden" name="cropHeight" id="cropHeight">
                                        </div>
                                        <div class="medium-2 columns">
                                            <a href="javascript:void(0);" id="submitBtn" class="button avatar-save"
                                               style="margin-top: 7px;">更改头像</a>
                                        </div>
                                    </form>

                                </div>
                            </div>

                            <!-- Crop and preview -->
                            <div class="row">
                                <div class="medium-8 columns">
                                    <div class="avatar-wrapper" style="width: 100%; height: 100%; margin-left: 15px;">
                                        <img id="image" src="${pageContext.request.contextPath}/static/data/upload/image/${currentLoginUser.avatar}">
                                    </div>
                                </div>
                                <div class="medium-4 columns">
                                    <div class="avatar-preview" style="width: 82%;"></div>
                                    <div class="avatar-preview" style="width: 65%;"></div>
                                    <div class="avatar-preview" style="width: 45%;"></div>
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
