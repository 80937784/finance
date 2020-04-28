//静态页面根目录，反斜杠结尾
//var ctx = "../";
//  var ctx = "http://localhost:9080/icool/";
// var ctx = "/icool/";
$(function () {

    $.ajaxSetup({cache: false});
    //复选框全部选中
    $("#global_checkbox_select_all").click(function () {
        if ($(this).attr("checked")) {
            $(this).removeAttr("checked");
            $(this).prop("checked", false);
            $("input[name='obj_num']").each(function () {
                $(this).removeAttr("checked");
                $(this).prop("checked", false);
            })
        } else {
            $(this).attr("checked", true);
            $(this).prop("checked", true);
            $("input[name='obj_num']").each(function () {
                $(this).attr("checked", true);
                $(this).prop("checked", true);
            })
        }
    });
    //查询时
    $("#global_btn_search").click(function () {
        $("#global_checkbox_select_all").removeAttr("checked");
        $("#global_checkbox_select_all").prop("checked", false);
    });
    //清空查询条件
    $("#global_btn_reset").click(function () {
        $("#global_div_search").find("input").val("");
        $("#global_div_search").find("select").val("");
    });
    // 取消按钮事件，清空表单内容
    $("#global_btn_cancel,#global_btn_x").click(function () {
        $("#id").val("");
        removeMessage($("#global_form_add_modify"));
        $(".has-error").removeClass('has-error');
        $("#global_form_add_modify")[0].reset();
    });
    // 批量选择验证
    $("#global_btn_delete").click(function () {
        var isCheck = false;
        $("input[name='obj_num']:checked").each(function () {
            if (this.value != "") {
                isCheck = true;
            }
        });
        if (isCheck == false) {
            showTips("请先选中!");
            return false;
        } else {
            $('#global_div_delete').modal()
        }
    });
    //ajax请求加载动画
    $(document).ajaxStart(function (event, jqXHR, settings) {
        if ($(".loaderA") != undefined) {
            $(".shadeA").css("display", "block");
            $(".loaderA").css("display", "block");
        }
    });

    $(document).ajaxComplete(function (event, jqXHR, settings) {
        if ($(".loaderA") != undefined) {
            $(".shadeA").css("display", "none");
            $(".loaderA").css("display", "none");
        }
    });
});

//url截取
function urlSplit(str) {
    var dataArr = str.split("&");
    var dataObj = {};
    var dataArrChild = "";
    for (var i in dataArr) {
        dataArrChild = dataArr[i].split("=")
        dataObj[dataArrChild[0]] = dataArrChild[1];
    }
    return dataObj;
}

//url参数拼接
function urlParamStitch(dataObj) {
    var urlStr = "";
    for (var i in dataObj) {
        urlStr += "&" + i + "=" + dataObj[i];
    }

    return urlStr.substring(1, urlStr.length);
}

//显示提示框，目前三个参数(txt：要显示的文本;
//time：自动关闭的时间（不设置的话默认1500毫秒;
//status：默认0为错误提示，1为正确提示;)
function showTips(txt, time, status) {
    var htmlCon = '';
    if (txt != '') {
        if (status != 0 && status != undefined) {
            htmlCon =
                '<div class="tipsBox" style="width:220px;padding:10px;background-color:#4AAF33;color:#ffffff;box-shadow:0 0 12px #4aaf33 ;-webkit-box-shadow: 0 0 12px #4aaf33;text-align:center;position:fixed;top:30%;left:52%;z-index:999999;margin-left:-120px;"><i class="glyphicon glyphicon-ok-sign"></i> ' +
                txt + '</div>';
        } else {
            htmlCon =
                '<div class="tipsBox" style="width:220px;padding:10px;background-color:#D84C31;color:#ffffff;box-shadow:0 0 12px #970000;-webkit-box-shadow: 0 0 12px #970000;text-align:center;position:fixed;top:30%;left:52%;z-index:999999;margin-left:-120px;"><i class="glyphicon glyphicon-remove-sign"></i> ' +
                txt + '</div>';
        }
        $('body').prepend(htmlCon);
        if (time == '' || time == undefined) {
            time = 1500;
        }
        setTimeout(function () {
            $('.tipsBox').remove();
        }, time);
    }
}

//时间日期格式化
function getTime(Num) {

    var date = new Date(Num);
    var year = date.getFullYear();
    var mon = date.getMonth() + 1;
    var day = date.getDate();
    var hour = date.getHours();
    var min = date.getMinutes();
    ///var sec = date.getMilliseconds();
    var sec = date.getSeconds();
    if (mon < 10) {
        mon = "0" + mon;
    }
    if (day < 10) {
        day = "0" + day;
    }
    if (hour < 10) {
        hour = "0" + hour;
    }
    // if(hour == 23){
    //     hour = 24;
    // }
    if (min < 10) {
        min = "0" + min;
    }
    if (sec < 10) {
        sec = "0" + sec;
    }
    return year + "-" + mon + "-" + day + " " + hour + ":" + min + ":" + sec;
}

//数值格式化(num 传入数值;scale 运算结果小数后精确的位数)
function getFormatNum(num, scale) {
    return num.toFixed(scale);
}

// 获取字典表数据（select元素ID,dict_code字典表,默认值）
function renderDict(selectId, dict_code, defaultVal) {
    $.ajax({
        url: urlCtx + "sysDict/getSysDictByCode",
        type: 'POST',
        data: {
            dict_code: dict_code
        },
        success: function (data) {
            if (data.code == "0000") {
                var selectObj = $("#" + selectId);
                for (var i in data.data) {
                    selectObj.append("<option value='" + data.data[i].dictValue + "'>" + data.data[i].dictName + "</option>");
                }
                // 默认选中
                if (defaultVal != "") {
                    selectObj.val(defaultVal);
                }
            } else if (data.code == "0003") {
                showTips(data.msg);
                setTimeout(function () {
                    window.top.location = "../login.html";
                }, 1000);
            }
        },
        error: function (e) {
            console.log(e);
        }
    });
}

// 删除
function globalDelete(id) {
    $("input[name='obj_num']:checked").each(function () {
        if (id != $(this).val()) {
            $(this).removeAttr("checked");
            $(this).prop("checked", false);
        }
    });
    $("#global_checkbox_select_all").removeAttr("checked");
    $("#global_checkbox_select_all").prop("checked", false);
    $("#obj_num_" + id).prop("checked", true);
    $("#obj_num_" + id).attr("checked", "checked");
    $("#global_btn_delete").click();
}

// 获取model
function gloablModify(id, url) {
    $.ajax({
        url: urlCtx + url,
        type: "POST",
        data: {
            "id": id
        },
        success: function (data) {
            if (data.code == "0000") {
                setModel(data);
            } else if (data.code == "0003") {
                showTips(data.msg);
                setTimeout(function () {
                    window.top.location = "../login.html";
                }, 1000);
            } else {
                showTips(data.msg);
            }
        },
        error: function (e) {
            $("body").html(e);
        }
    });
}

// 获取查看model
function gloablView(id, url) {
    $.ajax({
        url: urlCtx + url,
        type: "POST",
        data: {
            "id": id
        },
        success: function (data) {
            if (data.code == "0000") {
                setModelView(data);
            } else if (data.code == "0003") {
                showTips(data.msg);
                setTimeout(function () {
                    window.top.location = "../login.html";
                }, 1000);
            } else {
                showTips(data.msg);
            }
        },
        error: function (e) {
            $("body").html(e);
        }
    });
}

// 批量删除
function globalDeleteBatch(url) {
    // 删除确认
    var _ids = '';
    $("input[name='obj_num']:checked").each(function () {
        if (this.value != "") {
            if (_ids == "") {
                _ids = this.value;
            } else {
                _ids = _ids + "," + this.value;
            }
        }
    });
    if (_ids.split(",").length = $("#global_tbody tr").length) {
        if ($(".current").html() > 1) {
            $("#historyPage").val($(".current").html() - 1);
        }
    }
    //删除
    $.ajax({
        url: urlCtx + url,
        type: 'POST',
        dataType: 'json',
        data: {
            "ids": _ids
        },
        success: function (data) {
            if (data.code == "0000") {
                //关闭窗口
                $("#global_btn_del_cancel").click();
                // 重新获取数据
                icoolBack();
            } else if (data.code == "0003") {
                showTips(data.msg);
                setTimeout(function () {
                    window.top.location = "../login.html";
                }, 1000);
            } else {
                //关闭窗口
                $("#global_btn_del_cancel").click();
                showTips(data.msg,3500,0);
            }

        },
        error: function (e) {
            $("body").html(e);
        }
    });
}

// 保存信息
function globalSave(url, func) {

    $("#global_btn_save").attr("disabled", true);
    if (!$('#global_form_add_modify').Validform()) {
        $("#global_btn_save").attr("disabled", false);
        return false;
    }
    if (func) {
        if (!func()) {
            $("#global_btn_save").attr("disabled", false);
            return false;
        }
    }
    var param = $("#global_form_add_modify").serialize();
    $.ajax({
        url: urlCtx + url,
        type: "POST",
        dataType: "json",
        data: param,
        success: function (resMsg) {
            if (resMsg.code == '0000') {
                $("#id").val("");
                $("#companyId").val("");
                if (url.indexOf("opeMeetingInfo/save") != -1) {
                    $("#state").val("1");
                }

                $("#global_form_add_modify")[0].reset();
                $("#savedState").val("true");
                //$("#global_btn_cancel").click();
                $('#gridSystemModal').modal("hide")
                icoolBack();

            } else if (resMsg.code == "0003") {
                showTips(resMsg.msg);
                setTimeout(function () {
                    window.top.location = "../login.html";
                }, 1000);
            } else {
                showTips(resMsg.msg, 3000);
            }
            $("#global_btn_save").attr("disabled", false);
            removeMessage($("#global_form_add_modify"));
            $(".has-error").removeClass('has-error');
        },
        error: function () {
            $("#global_btn_save").attr("disabled", false);
        }
    });
}

function globalUndelete() {
    $("input[name='obj_num']:checked").each(function () {
        $(this).prop({"checked": false});
    });
    $("#global_checkbox_select_all").prop({"checked": false});
}

//打开list-group-modal,并且给其中元素绑定事件
function openListGroupModal(modalId, ulId, modalName, htmlstr, fn) {
    $(".list-group-modal").modal();
    $(".list-group-modal").attr("id", modalId);
    $(".list-group-modal ul").attr("id", ulId);
    $(".list-group-modal h4").html(modalName);
    $("#" + ulId).html(htmlstr);
    if (fn) {
        $("#" + ulId + " li").css("cursor", "pointer");
        $("#" + ulId + " li").click(fn);
    }
}

function openCheckListGroupModal(modalId, ulId, modalName, htmlstr, ids, fn) {
    $(".checked-list-group-modal").modal();
    $(".checked-list-group-modal").attr("id", modalId);
    $(".checked-list-group-modal ul").attr("id", ulId);
    $(".checked-list-group-modal h4").html(modalName);
    $("#" + ulId).html(htmlstr);
    var idArr = ids.split(",");
    for (var i in idArr) {
        $("#" + ulId + " input[id='" + idArr[i] + "']").prop("checked", true);
    }
    var inputs = $("#" + ulId + " input");
    $(".checked-list-group-modal .btn-primary").unbind("click");
    $(".checked-list-group-modal .btn-primary").click(function () {
        var valArr = [];
        var nameArr = [];
        for (var i = 0; i < inputs.length; i++) {
            if (inputs.eq(i).prop("checked")) {
                valArr.push(inputs.eq(i).attr("id"));
                nameArr.push(inputs.eq(i).attr("idName"))
            }
        }
        fn(valArr.join(), nameArr.join());
    })
}

//模态框滚动条消失处理
$('.list-group-modal, .checked-list-group-modal').on('hidden.bs.modal', function () {
    $('#gridSystemModal').css({
        'overflow-y': 'scroll'
    });
});

//获取公司列表
function getCompanyList(fn) {
    $.ajax({
        type: "post",
        url: urlCtx + "opeCompanyInfo/getList",
        async: false,
        data: "",
        success: function (data) {

            if (data.code == "0000") {
                fn(data);
            } else if (data.code == "0003") {
                showTips(data.msg);
                setTimeout(function () {
                    window.top.location = "../login.html";
                }, 1000);
            }

        },
        error: function () {
            showTips("网络错误请重试");
        }
    });
}

//获取部门列表
function getDeptList(companyId, fn) {
    $.ajax({
        type: "post",
        url: urlCtx + "opeDeptInfo/getList",
        async: false,
        data: {
            "companyId": companyId
        },
        success: function (data) {
            if (data.code == "0000") {
                fn(data);
            } else if (data.code == "0003") {
                showTips(data.msg);
                setTimeout(function () {
                    window.top.location = "../login.html";
                }, 1000);
            } else {
                showTips(data.msg);
            }

        },
        error: function () {
            showTips("网络错误请重试");
        }
    });
}

//查看会议议程
function showMeetagenda(data) {
    var htmlstr = '<table class="table table-bordered table-striped" style="text-align:center;margin-bottom:0px;" id="contentTable">' +
        '<thead><tr id="content1">' +
        '<th style="width: 15%;">开始时间</th>' +
        '<th style="width: 15%;">结束时间</th>' +
        '<th style="width: 50%;">内容</th>' +
        '<th style="width: 10%;">主讲人</th>' +
        '<th style="width: 10%;">会议室</th>' +
        '</tr></thead><tbody>';
    for (var i in data) {
        htmlstr += '<tr>' +
            '<td >' + getTime(data[i].startTime) + '</td>' +
            '<td >' + getTime(data[i].endTime) + '</td>' +
            '<td >' + data[i].content + '</td>';
        if (data[i].speaker) {
            htmlstr += '<td >' + data[i].speaker + '</td>';
        } else {
            htmlstr += '<td ></td>';
        }
        var roomName = data[i].roomName == undefined ? "" : data[i].roomName;
        htmlstr += '<td >' + roomName + '</td>' +
            '</tr>';
    }
    htmlstr += '</tbody></table>';
    return htmlstr;
}

//ajax返回对象错误处理
function unitReturnDeal(data, rightFn, worngFn) {
    if (data.code == "0000") {
        rightFn(data);
    } else if (data.code == "0003") {
        showTips(data.msg);
        setTimeout(function () {
            window.top.location = "../login.html";
        }, 1000);
    } else {
        if (worngFn) {
            worngFn(data);
        }
    }

}

//判断浏览器是否为ie
function IETester(userAgent) {
    var UA = userAgent || navigator.userAgent;
    if (/msie/i.test(UA)) {
        return UA.match(/msie (\d+\.\d+)/i)[1];
    } else if (~UA.toLowerCase().indexOf('trident') && ~UA.indexOf('rv')) {
        return UA.match(/rv:(\d+\.\d+)/)[1];
    }
    return false;
}