<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-28
  Time: 23:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript">

    $(function () {

        $(document).foundation();

        $("#left-menu-ul > li > a").unbind("click");
        $("#left-menu-ul > li > a").bind("click", function () {

            var action = $(this).attr("action");

            window.location.href = action;
/*

            // 发送ajax请求
            $.post(action, null, function (data) {
                //alert(data);
                // 返回的是经过渲染的页面
                $("#mainContent").html(data);
            });
*/


        });

    });

</script>

<div class="medium-4 large-3 columns row-margin-bottom-10">

    <ul class="accordion" data-accordion data-allow-all-closed="true">
        <li class="accordion-item is-active" data-accordion-item>

            <a href="javascript:void(0);" class="accordion-title">
                <i class="fa fa-dashboard"></i>
                我的折腾人生
            </a>
            <div class="accordion-content" data-tab-content>
                <ul id="left-menu-ul" class="bt-list-group" style="margin-left: 0;">
                    <li class="bt-list-group-item">
                        <a href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toMyZheTengLink.action">
                            <i class="fa fa-object-ungroup"></i>
                            我的折腾链
                        </a>
                    </li>
                    <li class="bt-list-group-item">
                        <a href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toMyBaseInfo.action">
                            <i class="fa fa-address-card-o"></i>
                            个人信息
                        </a>
                    </li>
                    <li class="bt-list-group-item">
                        <a href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toMyAvatar.action">
                            <i class="fa fa-picture-o"></i>
                            头像设置
                        </a>
                    </li>
                    <li class="bt-list-group-item">
                        <a id="toMyTags" href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toMyTags.action">
                            <i class="fa fa-tags"></i>
                            文章标签
                        </a>
                    </li>
                    <li class="bt-list-group-item">
                        <a id="toMyArticles" href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toMyArticles.action">
                            <i class="fa fa-list-alt"></i>
                            我的文章
                        </a>
                    </li>
                    <li class="bt-list-group-item">
                        <a id="toWriteArticle" href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toWriteArticle.action">
                            <i class="fa fa-pencil-square-o"></i>
                            撰写文章
                        </a>
                    </li>
                    <li class="bt-list-group-item">
                        <a href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toMyComments.action">
                            <i class="fa fa-comments-o"></i>
                            我的评论
                        </a>
                    </li>
                    <li class="bt-list-group-item">
                        <a href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toMyCollection.action">
                            <i class="fa fa-folder-open-o"></i>
                            我的收藏
                        </a>
                    </li>
                    <li class="bt-list-group-item">
                        <a href="javascript:void(0);" action="${pageContext.request.contextPath}/user/toMyFoucs.action">
                            <i class="fa fa-user-plus"></i>
                            我的关注
                        </a>
                    </li>
                </ul>
            </div>
        </li>
    </ul>

</div>
