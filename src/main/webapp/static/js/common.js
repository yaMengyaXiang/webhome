/**
 * Created by Long on 2017-04-21.
 */

var common = {

    idsToDelete: "",

    clickListen: function (checkboxName) {
        var $checkbox = $(":checkbox[name='" + checkboxName + "']");

        // 全选checkbox
        $("#selectAll").unbind("click");
        $("#selectAll").bind("click", function() {
            // jquery 1.6之后，checkbox的状态在加载完成页面时已经初始化，并且不会改变状态，
            // 所以下面的方法会一直返回undefined
            // var flag = $("#selectAll").attr('checked');
            // 解决方法是用prop()

            $checkbox.prop("checked", $(this).prop("checked"));

        });

        // 监听点击事件
        $checkbox.unbind("click");
        $checkbox.bind("click", function() {
            var checkedLen = $(":checkbox[name='" + checkboxName + "']:checked").length;
            var allCheckboxLength = $checkbox.length;
            $("#selectAll").prop("checked", checkedLen == allCheckboxLength);

        });
    },

    addBtnClick: function () {
        $("#addBtn").trigger("click");
    },

    addClickToSubmit: function (submitFormId, param, idNeedToClick) {
        var url = $("#" + submitFormId).attr("action");

        $.post(url, param, function(data) {

            // 字符串转json对象
            var json = jQuery.parseJSON(data);
            // 添加失败
            if ("false" == json.success) {
                // 给出提示
                alert("添加失败");
            } else {
                $("#addModal > button:first").trigger("click");
                $("#" + idNeedToClick).trigger("click");
            }

        });
    },

    editBtnClick: function (checkboxName, totalNum) {

        var $checkedObj = $(":checkbox[name='" + checkboxName + "']:checked");
        var checkedLen = $checkedObj.length;

        if (checkedLen == 0) {
            alert("请选择一行！！！");
            return;
        } else if (checkedLen > 1) {
            alert("请只选择一行！！！");
            return;
        }

        var checkboxValue = $checkedObj.val();
        var hiddenIdName = $checkedObj.parent().attr("idName");
        $("#" + hiddenIdName).attr("value", checkboxValue);

        for (var i = 1; i <= totalNum; i++) {

            var value = $checkedObj.parent().siblings(":eq(" + i + ")").attr("title");
            var idName = $checkedObj.parent().siblings(":eq(" + i + ")").attr("idName");
            $("#" + idName).attr("value", value);

        }

        // 触发点击
        $("#editBtn").trigger("click");

    },

    editClickToSubmit: function (submitFormId, param, idNeedToClick) {
        var url = $("#" + submitFormId).attr("action");

        $.post(url, param, function(data) {
            // 字符串转json对象
            var json = jQuery.parseJSON(data);
            // 添加失败
            if ("false" == json.success) {
                // 给出提示
                alert("更改失败");
            } else {
                $("#editModal > button:first").trigger("click");
                $("#" + idNeedToClick).trigger("click");
            }
        });
    },

    deleteBtnClick: function (checkboxName) {

        var $checkbox = $(":checkbox[name='" + checkboxName + "']:checked");

        var checkedLen = $checkbox.length;

        if (checkedLen == 0) {
            alert("请至少选择一行！！！");
            return;
        }

        common.idsToDelete = new Array($checkbox.length);
        var j = 0;
        $checkbox.each(function() {
            var id = $(this).val();
            common.idsToDelete[j++] = id;
        });

        // 触发点击
        $("#deleteBtn").trigger("click");
    },

    deleteClickToSubmit: function (btnObj, idNeedToClick) {
        var url = $(btnObj).attr("url");

        var param = {
            "ids": common.idsToDelete,
        };

        $.post(url, param, function(data) {
            // 字符串转json对象
            var json = jQuery.parseJSON(data);
            // 添加失败
            if ("false" == json.success) {
                // 给出提示
                alert("删除失败");
            } else {
                $("#deleteModal > button:first").trigger("click");
                $("#" + idNeedToClick).trigger("click");
            }
        });
    },

    cancel: function (modalId) {
        $("#" + modalId + " > button:first").trigger("click");
    },

    preAndNextPage: function (linkObj, pageNo) {
        var $linkObj = $(linkObj);
        var url = $linkObj.attr("url");

        if ($linkObj.css("cursor") == "not-allowed") {
            return;
        }

        window.location.href = url;
        /*
        // ajax请求
        $.post(url, null, function(data) {
            $("#mainContent").html(data);
        });
        */
    }

};

/**
function addBtnClick() {
    $("#addBtn").trigger("click");
}


function addClickToSubmit(submitFormId, param, idNeedToClick) {
    var url = $("#" + submitFormId).attr("action");

    $.post(url, param, function(data) {

        // 字符串转json对象
        var json = jQuery.parseJSON(data);
        // 添加失败
        if ("false" == json.success) {
            // 给出提示
            alert("添加失败");
        } else {
            $("#addModal > button:first").trigger("click");
            $("#" + idNeedToClick).trigger("click");
        }

    });

}


function editBtnClick(checkboxName, totalNum) {

    var $checkedObj = $(":checkbox[name='" + checkboxName + "']:checked");
    var checkedLen = $checkedObj.length;

    if (checkedLen == 0) {
        alert("请选择一行！！！");
        return;
    } else if (checkedLen > 1) {
        alert("请只选择一行！！！");
        return;
    }

    var checkboxValue = $checkedObj.val();
    var hiddenIdName = $checkedObj.parent().attr("idName");
    $("#" + hiddenIdName).attr("value", checkboxValue);

    for (var i = 1; i < totalNum; i++) {

        var value = $checkedObj.parent().siblings(":eq(" + i + ")").attr("title");
        var idName = $checkedObj.parent().siblings(":eq(" + i + ")").attr("idName");
        $("#" + idName).attr("value", value);

    }

    // 触发点击
    $("#editBtn").trigger("click");

}


function editClickToSubmit(submitFormId, param, idNeedToClick) {
    var url = $("#" + submitFormId).attr("action");

    $.post(url, param, function(data) {
        // 字符串转json对象
        var json = jQuery.parseJSON(data);
        // 添加失败
        if ("false" == json.success) {
            // 给出提示
            alert("更改失败");
        } else {
            $("#editModal > button:first").trigger("click");
            $("#" + idNeedToClick).trigger("click");
        }
    });

}


var idsToDelete;

function deleteBtnClick(checkboxName) {

    var $checkbox = $(":checkbox[name='" + checkboxName + "']:checked");

    var checkedLen = $checkbox.length;

    if (checkedLen == 0) {
        alert("请至少选择一行！！！");
        return;
    }

    idsToDelete = new Array($checkbox.length);
    var j = 0;
    $checkbox.each(function() {
        var id = $(this).val();
        idsToDelete[j++] = id;
    });

    // 触发点击
    $("#deleteBtn").trigger("click");

}


function deleteClickToSubmit(btnObj, idNeedToClick) {
    var url = $(btnObj).attr("url");

    var param = {
        "ids": idsToDelete,
    };

    $.post(url, param, function(data) {
        // 字符串转json对象
        var json = jQuery.parseJSON(data);
        // 添加失败
        if ("false" == json.success) {
            // 给出提示
            alert("删除失败");
        } else {
            $("#deleteModal > button:first").trigger("click");
            $("#" + idNeedToClick).trigger("click");
        }
    });

}


function cancel(modalId) {
    $("#" + modalId + " > button:first").trigger("click");
}


function preAndNextPage(linkObj, pageNo) {
    var $linkObj = $(linkObj);
    var url = $linkObj.attr("url");

    if ($linkObj.css("cursor") == "not-allowed") {
        return;
    }
    // ajax请求
    $.post(url, null, function(data) {
        $("#mainContent").html(data);
    });

}

 */