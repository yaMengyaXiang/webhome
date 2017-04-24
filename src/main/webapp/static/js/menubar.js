/**
 * Created by Long on 2017-04-24.
 */


var menubar = {

    // 一个临时的变量，左右菜单栏到顶部菜单栏的距离
    tmp: "",

    locateOnload: function (menubarId) {

        var sTop = $(window).scrollTop();
        console.log(sTop);

       // logoBar的高度 a
        var lbHeight = $("#logoBar").height();
        // 元素本身的高度 b
        var hmHeightTmp = $("#top-menubar > .sticky").height();
        // 主要内容框距离顶部的高度 = a + b + menubar.tmp
        var lrTop = $(".layer > .row:first-child").offset().top;

        // 距离顶部菜单栏的高度
        menubar.tmp = lrTop - lbHeight - hmHeightTmp;

        if (sTop != 0) {
            // 一开始滚动条不在0，说明有滚动，则一开始的位置为：滚动条位置sTop + 顶部菜单栏高度 + menubar.tmp
            var topTmp = sTop + hmHeightTmp + menubar.tmp;
            $("#" + menubarId).css("top", topTmp + "px");

        } else {
            // 滚动条位置为0，说明无滚动
            // 一开始的位置应该是顶部logo栏的高度+顶部菜单栏的高度+tmp与菜单栏的距离
            var topTmp = lbHeight + hmHeightTmp + menubar.tmp;

            $("#" + menubarId).css("top", topTmp + "px");
        }


    },

    scrollToTop: function (menubarId) {

        // 水平菜单栏的top值
        var hmTop = $("#top-menubar > .sticky").offset().top;
        var hmHeight = $("#top-menubar > .sticky").height();
        console.log(hmTop);
        var top;

        // 一开始hmTop的值为该元素的高度，当从下面网上滚到为0的时候，获取到的值是0，但它又回到了一开始的位置，也就是hmTop应该为它的高度
        if (hmTop != 0) {

            top = hmTop + hmHeight + menubar.tmp;

        } else {

            var lbHeight = $("#logoBar").height();
            top = lbHeight + hmHeight + menubar.tmp;

        }

        $("#" + menubarId).css("top", top + "px");

    },

    adjustMenubar: function (menubarId, leftOrRight) {
        var mainLeft = $(".main-content").offset().left;
        var mainWidth = $(".main-content").width();

        var htmlWidth = $("html,body").width();

        var $menubar = $("#" + menubarId);

        var menubarWidth = $menubar.width();

        if (leftOrRight == "right") {
            var right = htmlWidth - mainLeft - mainWidth - menubarWidth + 2;
            $menubar.css("right", right + "px");

        } else {
            var left = mainLeft - menubarWidth + 2;
            $menubar.css("left", left + "px");

        }
    }

}


/**
 * 界面加载完成后调用这个方法，调整左右菜单栏的位置
 * @param menubarId
 */
function locateOnload(menubarId) {

    // 一开始的位置应该是顶部logo栏的高度 a
    var tmTopTmp = $("#top-menubar > .sticky").offset().top;
    // 元素本身的高度 b
    var hmHeightTmp = $("#top-menubar > .sticky").height();
    // 主要内容框距离顶部的高度 = a + b + tmp
    var lrTop = $(".layer > .row:first-child").offset().top;
    // 距离顶部菜单栏的高度
    tmp = lrTop - tmTopTmp - hmHeightTmp;

    // 一开始的位置应该是顶部logo栏的高度+顶部菜单栏的高度+tmp与菜单栏的距离
    var topTmp = tmTopTmp + hmHeightTmp + tmp;

    $("#" + menubarId).css("top", topTmp + "px");

}


function scrollToTop(menubarId) {

    // 水平菜单栏的top值
    var hmTop = $("#top-menubar > .sticky").offset().top;
    var hmHeight = $("#top-menubar > .sticky").height();

    var top;

    // 一开始hmTop的值为该元素的高度，当从下面网上滚到为0的时候，获取到的值是0，但它又回到了一开始的位置，也就是hmTop应该为它的高度
    if (hmTop != 0) {

        top = hmTop + hmHeight + tmp;

    } else {

        var lbHeight = $("#logoBar").height();
        top = lbHeight + hmHeight + tmp;

    }

    $("#" + menubarId).css("top", top + "px");

}

/**
 * 调整左右菜单栏的位置
 * @param menubarId
 * @param leftOrRight
 */
function adjustMenubar(menubarId, leftOrRight) {

    var mainLeft = $(".main-content").offset().left;
    var mainWidth = $(".main-content").width();

    var htmlWidth = $("html,body").width();

    var $menubar = $("#" + menubarId);

    var menubarWidth = $menubar.width();

    if (leftOrRight == "right") {
        var right = htmlWidth - mainLeft - mainWidth - menubarWidth + 2;
        $menubar.css("right", right + "px");

    } else {
        var left = mainLeft - menubarWidth + 2;
        $menubar.css("left", left + "px");

    }

}