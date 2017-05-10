<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/3/26
  Time: 15:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head lang="zh-cn">
    <meta charset="UTF-8">
    <title>折腾人生 -- 我们那充满折腾的人生</title>

    <%@include file="/WEB-INF/jsp/common/static.jsp"%>

    <script type="text/javascript">

        $(document).ready(function() {

        });

        function scrollToTop() {
            /*
            $("html,body").animate({
                scrollTop: top - 200
            });
             */
            var sTop = $(window).scrollTop();
            console.log(sTop);

            var height = $("#indexContainer > div:first").height();

            if (sTop < height) {
                $("#divMenuBar").css("top", "0px");
            } else {
                // 菜单栏和顶部感觉有1px的间隔，多减1
                var top = sTop - height - 1;
                $("#divMenuBar").css("top", top + "px");
            }

        }

    </script>

</head>
<body style="background-color: #f9fafc;">

    <%@include file="/WEB-INF/jsp/common/header.jsp"%>

    <%@include file="/WEB-INF/jsp/common/top-menubar.jsp"%>

    <!-- 最新资讯 最热折腾-->
    <div class="row row-margin-bottom">
        <div class="padding-20-div">
            <div class="large-4 medium-12 small-12 columns row-margin-bottom">
                <div class="padding-10-div bg-white-border">
                    <div class="header-title-div">
                        <i></i>
                        <a class="titleLink" href="#">最新资讯</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="data-list-div" style="height: 290px;">
                        <ul>
                            <li>ddddaaaaaaaaaaaaaaaaaaadd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="large-8 medium-12 small-12 columns">

                <div id="orbit"  class="orbit" role="region" aria-label="Favorite Space Pictures" data-orbit
                     data-options="animInFromLeft:fade-in; animInFromRight:fade-in; animOutToLeft:fade-out; animOutToRight:fade-out;">
                    <ul class="orbit-container" tabindex="0" style="height: 350px;">
                        <button style="background-image: url(${pageContext.request.contextPath}/static/image/left-arrow.png);" class="orbit-previous" aria-label="previous" tabindex="0">
                            <span class="show-for-sr">Previous Slide</span>
                        </button>
                        <button style="background-image: url(${pageContext.request.contextPath}/static/image/right-arrow.png);" class="orbit-next" aria-label="next" tabindex="0">
                            <span class="show-for-sr">Next Slide</span>
                        </button>
                        <li class="orbit-slide is-active" data-slide="0" style="max-height: 350px;display: block; position: relative; top: 0px; transition: 0ms; -webkit-transition: 0ms;" aria-live="polite">
                            <img class="orbit-image" style="width: 100%; height: 100%;" src="${pageContext.request.contextPath}/static/image/01.jpg" alt="Space">
                            <figcaption class="orbit-caption">Outta This World 1</figcaption>
                        </li>
                        <li class="orbit-slide is-active" data-slide="0" style="max-height: 350px;display: block; position: relative; top: 0px; transition: 0ms; -webkit-transition: 0ms;" aria-live="polite">
                            <img class="orbit-image" style="width: 100%; height: 100%;" src="${pageContext.request.contextPath}/static/image/02.jpg" alt="Space">
                            <figcaption class="orbit-caption">Outta This World 1</figcaption>
                        </li>
                        <li class="orbit-slide is-active" data-slide="0" style="max-height: 350px;display: block; position: relative; top: 0px; transition: 0ms; -webkit-transition: 0ms;" aria-live="polite">
                            <img class="orbit-image" style="width: 100%; height: 100%;" src="${pageContext.request.contextPath}/static/image/03.jpg" alt="Space">
                            <figcaption class="orbit-caption">Outta This World 1</figcaption>
                        </li>
                        <li class="orbit-slide is-active" data-slide="0" style="max-height: 350px;display: block; position: relative; top: 0px; transition: 0ms; -webkit-transition: 0ms;" aria-live="polite">
                            <img class="orbit-image" style="width: 100%; height: 100%;" src="${pageContext.request.contextPath}/static/image/04.jpg" alt="Space">
                            <figcaption class="orbit-caption">Outta This World 1</figcaption>
                        </li>
                    </ul>

                    <nav class="orbit-bullets" style="bottom: 0px; position: absolute; right: 20px;">
                        <button class="is-active" data-slide="0"><span class="show-for-sr">First slide details.</span><span class="show-for-sr">Current Slide</span></button>
                        <button data-slide="1"><span class="show-for-sr">Second slide details.</span></button>
                        <button data-slide="2"><span class="show-for-sr">Third slide details.</span></button>
                        <button data-slide="3"><span class="show-for-sr">Fourth slide details.</span></button>
                    </nav>

                </div>

                <script>
                    $(document).foundation();
//                    $('#orbit').foundation();

                    $(window).resize(function () {
//                        $(document).foundation('_reset');
//                        $('#orbit').foundation('_reset');
                    });

                </script>

            </div>
        </div>
    </div>

    <!-- 折友生活 折友博客 职业生涯-->
    <div class="row">
        <div class="padding-10-20-div">
            <div class="large-4 medium-6 small-12 columns row-margin-bottom">
                <div class="padding-10-div bg-white-border">
                    <div class="header-title-div">
                        <i></i>
                        <a class="titleLink" href="#">折友生活</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="data-list-div" style="height: 90%;">
                        <ul>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="large-4 medium-6 small-12 columns row-margin-bottom">
                <div class="padding-10-div bg-white-border">
                    <div class="header-title-div">
                        <i></i>
                        <a class="titleLink" href="#">折友博客</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="data-list-div" style="height: 90%;">
                        <ul>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="large-4 medium-12 small-12 columns row-margin-bottom">
                <div class="padding-10-div bg-white-border">
                    <div class="header-title-div">
                        <i></i>
                        <a class="titleLink" href="#">职业生涯</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="data-list-div" style="height: 90%;">
                        <ul>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 折友众测-->
    <div class="row">
        <div class="padding-0-20-div">
            <div class="padding-15-div">
                <div class="large-12 medium-12 columns bg-white-border">
                    <div class="header-title-padding-15-10-10-div">
                        <i></i>
                        <a class="titleLink" href="#">折友众测</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="padding-20-10-div">
                        <div class="large-4 medium-6 columns row-margin-bottom-20">
                            <div class="data-list-border-1-div">

                            </div>
                        </div>
                        <div class="large-4 medium-6 columns row-margin-bottom-20">
                            <div class="data-list-border-1-div">

                            </div>
                        </div>
                        <div class="large-4 medium-12 columns row-margin-bottom-20">
                            <div class="data-list-border-1-div">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 众测报告-->
    <div class="row row-margin-bottom">
        <div class="padding-10-20-div">
            <div class="padding-10-15-div">
                <div class="large-12 medium-12 columns bg-white-border">
                    <div class="header-title-padding-15-10-10-div">
                        <i></i>
                        <a class="titleLink" href="#">众测报告</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="padding-20-10-div">
                        <div class="large-6 medium-12 columns row-margin-bottom-20">
                            <div class="data-list-border-1-div">

                            </div>
                        </div>
                        <div class="large-6 medium-12 columns row-margin-bottom-20">
                            <div class="data-list-border-1-div">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 三栏-->
    <div class="row row-margin-bottom">
        <div class="padding-10-20-div">
            <div class="large-4 medium-6 small-12 columns row-margin-bottom">
                <div class="padding-10-div bg-white-border">
                    <div class="header-title-div">
                        <i></i>
                        <a class="titleLink" href="#">最新资讯</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="data-list-div" style="height: 90%;">
                        <ul>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="large-4 medium-6 small-12 columns row-margin-bottom">
                <div class="padding-10-div bg-white-border">
                    <div class="header-title-div">
                        <i></i>
                        <a class="titleLink" href="#">最新资讯</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="data-list-div" style="height: 90%;">
                        <ul>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="large-4 medium-12 small-12 columns row-margin-bottom">
                <div class="padding-10-div bg-white-border">
                    <div class="header-title-div">
                        <i></i>
                        <a class="titleLink" href="#">最新资讯</a>
                        <a class="titleLink" style="float: right;" href="#">更多</a>
                    </div>
                    <div class="data-list-div" style="height: 90%;">
                        <ul>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                            <li>ddddddddddddddddddddddddd</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <%@include file="/WEB-INF/jsp/common/bottom.jsp"%>

</body>
</html>