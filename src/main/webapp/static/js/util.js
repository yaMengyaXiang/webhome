/**
 * Created by Long on 2017/3/27.
 */

// 存放常量
var ztrsConstants = {

    "form_method_get": "GET",
    "form_method_post": "POST",

    "form_enctype_default": "application/x-www-form-urlencoded",
    "form_enctype_file_upload": "multipart/form-data"
};

var ztrsUtil = {

    xml: {
        string2xml: function (strTxt) {
            return $.string2xml(strTxt);
        }
    }

};

(function (jQuery) {

    /**
     * 解析字符串内容，转换成xml document对象
     */
    $.string2xml = function (strTxt) {

        // for ie
        if (window.ActiveXObject) {

            var xmlObj = new ActiveXObject("Microsoft.XMLDOM");
            xmlObj.async = "false";
            xmlObj.loadXML(strTxt);
            return xmlObj;

        } else {    // other browser

            var parser = new DOMParser();
            var xmlObj = parser.parseFromString(strTxt, "text/xml");
            return xmlObj;

        }

    },

    // 生成表单并提交
    $.generateAndSubmitForm = function (option) {
        /*
        {
            "action": "action",
            "queryStrings" : [
                {"name": "name", "value": "value"},
                {"name": "name", "value": "value"},
                {"name": "name", "value": "value"}
            ]
        }

            改进：
         {
             "action": "action",
             "queryStrings": {
                "username": "username",
                "password": "password",
                "fromUrl": "fromUrl"
             }

         }
        */

        // file upload : multipart/form-data
        var defaultOption = {
            "method": ztrsConstants.form_method_post,
            "enctype": ztrsConstants.form_enctype_default
        };

        $.extend(defaultOption, option);

        var action = defaultOption.action;
        var queryStrings = defaultOption.queryStrings;

        console.log(queryStrings);

        var form = $("<form></form>")
            .attr("action", action)
            .attr("method", defaultOption.method)
            .attr("enctype", defaultOption.enctype);

        for (var name in queryStrings) {
            var value = queryStrings[name];
            var input = $("<input/>")
                .attr("name", name)
                .attr("value", value);

            form.append(input);
        }
/*

        for (var i = 0; i < queryStrings.length; i++) {
            var queryString = queryStrings[i];
            var input = $("<input/>")
                .attr("name", queryString.name)
                .attr("value", queryString.value);

            form.append(input);
        }
*/

        console.log(form);

        // 如果不加这句则无法提交表单
        $("body").append(form);

        form.submit();

    };

})(jQuery);