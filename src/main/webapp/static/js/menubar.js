/**
 * Created by Long on 2017-04-24.
 */


var menubar = {

    adjustMenubar: function (menubarId, leftOrRight) {
        menubar.adjustHorizontal(menubarId, leftOrRight);
        // menubar.adjustVertical(menubarId);
    },

    adjustHorizontal: function (menubarId, leftOrRight) {
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
    },

    adjustVertical: function (menubarId) {
        var $menubar = $("#" + menubarId);
        var height = $menubar.height();

        // 浏览器当前窗口的高度
        var browserHeight = $(document.body).outerHeight(true);
        console.log(browserHeight);

        var y;

        if (browserHeight < 500) {
            y = 100;
        } else {
            y = (browserHeight - height) >> 1;
        }

        console.log(y);

        $menubar.css("top", y + "px");

    }

}

