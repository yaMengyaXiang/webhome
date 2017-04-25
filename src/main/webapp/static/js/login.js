/**
 * Created by Long on 2017/3/21.
 */


/*对登录div进行定位*/
function formDivLocate() {

    var height = $("#login-form-div").height();
    var width = $("#login-form-div").width();

    var browserWidth = $(window).width();

    // 浏览器当前窗口的高度
    var browserHeight = $(window).height();

    if (browserHeight % 2 != 0) {
        browserHeight += 1;
    }

    var x = (browserWidth - width) >> 1;
    var y = (browserHeight - height) >> 1;

    $("#login-form-div").css("top", y + "px");
    $("#login-form-div").css("left", x + "px");

}

/*适应高度，窗口放大缩小时用来调整div的高度，宽度100%不变*/
function adjustHeight() {
    // 浏览器当前窗口的高度 错错！！！这个是页面的高度，应该带边框的
    var browserHeight = $(window).height();

    // 下面这个才是浏览器窗口的大小
    //var browserHeight = $(document.body).outerHeight(true);

    if (browserHeight % 2 != 0) {
        browserHeight += 1;
    }

    var topDivHeight = browserHeight >> 1;
    var bottomDivHeight = browserHeight >> 1;

    bottomDivHeight = bottomDivHeight + 0;

    $("#login-top-div").css("height", topDivHeight + "px");
    $("#login-bottom-div").css("height", bottomDivHeight + "px");

    $("#login-top-div div").css("top", topDivHeight + 10 + "px");
    $("#login-bottom-div div").css("top", "-10px");

}

function go() {
    var browserHeight = $(window).height();

    if (browserHeight % 2 != 0) {
        browserHeight += 1;
    }

    var bottomDivHeight = browserHeight >> 1;
    var topDivHeight = browserHeight >> 1;

    // 向上填充白色
    $("#login-top-div div").animate({
        top: "0px",
        height: topDivHeight + "px"
    }, function() {
        $("#topDiv").hide();
    });
    // 向下填充白色
    $("#login-bottom-div div").animate({
        top: "0px",
        height: bottomDivHeight + "px"
    }, function() {
        $("#bottomDiv").hide();
    });

}


var loginUtil = {

    loginGo: function () {
        go();
    },

    loginFunctions : function() {
        adjustHeight();
        formDivLocate();
    }
};