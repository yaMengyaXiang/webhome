<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017-04-24
  Time: 22:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/menubar.js"></script>

<script type="text/javascript">

    $(function () {

        menubar.adjustMenubar("right-menubar", "right");

        $(window).resize(function () {

            menubar.adjustMenubar("right-menubar", "right");

        });

        var $floors = $(".layer > .row[cmtNum]");

        $floors.each(function () {
            var cmtNum = $(this).attr("cmtNum");

            var username = $(this).find(".user-name > a").attr("title");

            var $div = $("#liContainer").children("div");
            var $ul = $div.children("ul");
            $ul.append('<li onclick="toFloor('+ cmtNum +')" cm="' +
                    cmtNum + '" class="bt-list-group-item floor-link"><a href="javascript:void(0);">' +
                    cmtNum + '楼 &nbsp; &larr; &nbsp;'+ username +'</a></li>');

        });

        $("#liContainer").mCustomScrollbar({
            theme:"minimal-dark",
            mouseWheel:{
                // 鼠标滚轮滚动一下的像素？
                scrollAmount: 150
            }
        });

    });

    function toFloor(cmtNum) {

        var sTop = $(window).scrollTop();

        var top;

        var tmHeight = $("#top-menubar").height();

        if (sTop == 0) {
            top = $('.layer > .row[cmtNum='+ cmtNum + ']').offset().top - tmHeight + 5 - tmHeight;
        } else {
            top = $('.layer > .row[cmtNum='+ cmtNum + ']').offset().top - tmHeight + 5;
        }

        $("html,body").animate({
            scrollTop: top
        });

    }

    function toTop() {
        $("html,body").animate({
            scrollTop: 0
        });
    }

</script>

<%--右边菜单栏--%>
<div id="right-menubar" class="hide-for-small-only" style="z-index: 50;">
    <ul class="vertical dropdown menu" data-dropdown-menu>
        <li class="opens-left">
            <a class="my-vertical-menubar-a">按钮</a>
            <ul class="menu">
                <li><a href="#">Item A</a></li>
                <li><a href="#">Item B</a></li>
                <li><a href="#">Item C</a></li>
            </ul>
        </li>
        <li class="opens-left">
            <a class="my-vertical-menubar-a">跳楼</a>
            <ul class="menu">
                <li id="liContainer" style="height: 320px; overflow: auto;">
                    <div style="margin: 15px 16px 15px -8px;">
                        <ul class="bt-list-group">

                        </ul>
                    </div>
                </li>
            </ul>
        </li>
        <li class="opens-left">
            <a href="javascript:void(0);" onclick="toTop()" class="my-vertical-menubar-a">顶部</a>
        </li>
    </ul>
</div>