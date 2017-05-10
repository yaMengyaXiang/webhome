<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/4/8
  Time: 11:57
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

        });


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
                        <i class="fa fa-address-card-o"></i>
                        基本资料
                    </a>

                    <div class="accordion-content" data-tab-content>

                        <form id="userInfoForm" class="padding-10-div" action="${pageContext.request.contextPath}/user/updateInfo.action"
                              method="post">
                            <div class="row">
                                <div class="large-6 medium-12 columns">
                                    <label>
                                        用户名：<input type="text" name="username" value="${currentLoginUser.username}">
                                    </label>
                                </div>
                                <div class="large-6 medium-12 columns">
                                    <label>
                                        邮箱：<input type="text" name="mailbox" value="${currentLoginUser.mailbox}">
                                    </label>
                                </div>
                            </div>
                            <div class="row">
                                <%--
                                <div class="large-3 medium-12 columns">
                                    <label>
                                        密码：<input type="password" name="password" value="${currentLoginUser.password}">
                                    </label>
                                </div>--%>
                                    <div class="large-6 medium-12 columns">
                                        <label style="margin-bottom: 15px;">
                                            个性签名：<textarea class="padding-10-div" style="min-height: 60px;" placeholder="来一个帅气的签名吧n_n"
                                                      name="signature" maxlength="45">${currentLoginUser.signature}</textarea>
                                        </label>
                                    </div>
                                <div class="large-6 medium-12 columns">
                                    <label style="margin-bottom: 15px;">
                                        个人简介：
                                        <textarea class="padding-10-div" style="min-height: 60px;" placeholder="介绍一下自己吧n_n"
                                                  name="description" maxlength="100">${currentLoginUser.description}</textarea>
                                    </label>
                                </div>

                            </div>
                            <div class="row">
                                <div class="large-6 medium-6 small-6 columns text-center">
                                    <input type="submit" class="button" id="submitBtn" value="更新信息">
                                </div>
                                <div class="large-6 medium-6 small-6 columns text-center">
                                    <a href="javascript:void(0);" class="button" style="">修改密码？</a>
                                </div>
                            </div>
                        </form>

                    </div>
                </li>
            </ul>
        </div>


    </div>
</div>

</body>
</html>