<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/4/8
  Time: 11:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript">

    $(function() {

        $(document).foundation();

    });


</script>

<ul class="accordion" data-accordion data-allow-all-closed="true">
    <li class="accordion-item is-active" data-accordion-item>

        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
            <i class="fa fa-address-card-o"></i>
            基本资料
        </a>

        <div class="accordion-content" data-tab-content>

            <form class="padding-10-div" action="${pageContext.request.contextPath}/user/login.action" method="post">
                <div class="row">
                    <div class="large-6 medium-12 columns">
                        <label>
                            用户名：<input type="text" name="username">
                        </label>
                    </div>
                    <div class="large-6 medium-12 columns">
                        <label>
                            密码：<input type="password" name="password">
                        </label>
                    </div>
                </div>
                <div class="row">
                    <div class="large-6 medium-12 columns">
                        <label>
                            邮箱：<input type="text" name="mailbox">
                        </label>
                    </div>
                    <div class="large-6 medium-12 columns">
                        <label>
                            个性签名：<input type="text" name="signature">
                        </label>
                    </div>
                </div>
                <div class="row">
                    <div class="large-6 medium-12 columns">
                        <label>
                            个人简介： <textarea class="padding-10-div" style="min-height: 60px;" placeholder="介绍一下自己吧n_n"
                                            name="description"></textarea>
                        </label>
                    </div>
                    <div class="large-6 medium-12 columns text-center">
                        <label>
                            <button class="button" style="margin-top: 36px; margin-bottom: 0;">更新信息</button>
                        </label>
                    </div>
                </div>
            </form>

        </div>
    </li>
</ul>
