<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/3/28
  Time: 21:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<script type="text/javascript">

    $(function () {

        topMenubarScrollToTop("top-menubar");

        $(window).scroll(function () {
            topMenubarScrollToTop("top-menubar");
        });


    });

    function topMenubarScrollToTop(menubarId) {
        var $menubar = $("#" + menubarId);

        var lbHeight = $("#logoBar").height();

        var sTop = $(window).scrollTop();

        if (sTop >= lbHeight) {
            $menubar.css("top", "0px");
            $menubar.css("position", "fixed");

        } else {

            $menubar.css("position", "relative");

        }

    }

</script>

<%--
<!-- 导航栏-->
<div class="row hide-for-small-only" id="top-menubar" data-sticky-container style="z-index: 100;">
    <div class="top-bar sticky" data-sticky-on="medium" data-sticky data-margin-top="0" style="width: 100%; background-color: white; border-bottom: 1px solid #ccccff;">
        <div style="width: 95%; margin: 0 auto; text-align: center;">
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
        </div>
    </div>
</div>
--%>

<div class="row hide-for-small-only" id="top-menubar" style="z-index: 100; width: 100%; position: relative;">
    <div class="top-bar" style="width: 100%; background-color: white; border-bottom: 1px solid #ccccff;">
        <div style="width: 95%; margin: 0 auto; text-align: center;">
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
            <div class="medium-2 columns">
                <a href="javascript:void(0);">首页首页</a>
            </div>
        </div>
    </div>
</div>