/**
 表单数据验证
 **/
$.fn.Validform = function () {
    var Validatemsg = "";
    var Validateflag = true;
    $(this).find("[isvalid=yes]").each(function () {
        var checkexpession = $(this).attr("checkexpession");
        var errormsg = $(this).attr("errormsg");
        if (checkexpession != undefined) {
            if (errormsg == undefined) {
                errormsg = "";
            }
            var value = $(this).val();
            if ($(this).hasClass('ui-select')) {
                value = $(this).attr('data-value');
            }
            switch (checkexpession) {
                case "NotNull":
                {
                    if (isNotNull(value)) {
                        Validatemsg = errormsg + "不能为空！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Num":
                {
                    if (!isInteger(value)) {
                        Validatemsg = errormsg + "必须为数字！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "IsInteger":
                {
                    if (!isInteger(value)) {
                        Validatemsg = errormsg + "必须为数字！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "IntegerOrDouble":
                {
                    if (!isIntegerOrDouble(value)) {
                        Validatemsg = errormsg + "小数位不能大于2位！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "PositiveInteger":
                {
                    if (!isNotNull(value)) {
                        if (!isInteger(value)) {
                            Validatemsg = errormsg + "必须为正整数！\n";
                            Validateflag = false;
                            ValidationMessage($(this), Validatemsg);
                            return false;
                        } else {
                            if (value < 1) {
                                Validatemsg = errormsg + "必须为正整数！\n";
                                Validateflag = false;
                                ValidationMessage($(this), Validatemsg);
                                return false;
                            }
                        }
                        break;
                    }
                }
                case "NumOrNull":
                {
                    if (!isIntegerOrNull(value)) {
                        Validatemsg = errormsg + "必须为数字！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Email":
                {
                    if (!isEmail(value)) {
                        Validatemsg = errormsg + "必须为E-mail格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "EmailOrNull":
                {
                    if (!isEmailOrNull(value)) {
                        Validatemsg = errormsg + "必须为E-mail格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "EnglishStr":
                {
                    if (!isEnglishStr(value)) {
                        Validatemsg = errormsg + "必须为字符串！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "EnglishStrOrNull":
                {
                    if (!isEnglishStrOrNull(value)) {
                        Validatemsg = errormsg + "必须为字符串！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "LenNum":
                {
                    if (!isLenNum(value, $(this).attr("length"))) {
                        Validatemsg = errormsg + "必须为" + $(this).attr("length") + "位数字！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "LenNumOrNull":
                {
                    if (!isLenNumOrNull(value, $(this).attr("length"))) {
                        Validatemsg = errormsg + "必须为" + $(this).attr("length") + "位数字！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "LenStr":
                {
                    if (!isLenStr(value, $(this).attr("length"))) {
                        Validatemsg = errormsg + "必须小于" + $(this).attr("length") + "位字符！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "LenStrOrNull":
                {
                    if (!isLenStrOrNull(value, $(this).attr("length"))) {
                        Validatemsg = errormsg + "必须小于" + $(this).attr("length") + "位字符！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Phone":
                {
                    if (!isTelephone(value)) {
                        Validatemsg = errormsg + "必须电话格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "PhoneOrNull":
                {
                    if (!isTelephoneOrNull(value)) {
                        Validatemsg = errormsg + "必须电话格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Fax":
                {
                    if (!isTelephoneOrNull(value)) {
                        Validatemsg = errormsg + "必须为传真格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Mobile":
                {
                    if (!isMobilePhone(value)) {
                        Validatemsg = errormsg + "必须为手机格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "MobileOrNull":
                {
                    if (!isMobileOrnull(value)) {
                        Validatemsg = errormsg + "必须为手机格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "MobileOrNullNew":
                {
                    if (!isMobileOrNullNew(value)) {
                        Validatemsg = errormsg + "必须为手机格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "MobileOrPhone":
                {
                    if (!isMobileOrPhone(value)) {
                        Validatemsg = errormsg + "必须为电话格式或手机格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "MobileOrPhoneOrNull":
                {
                    if (!isMobileOrPhoneOrNull(value)) {
                        Validatemsg = errormsg + "必须为电话格式或手机格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Uri":
                {
                    if (!isUri(value)) {
                        Validatemsg = errormsg + "必须为网址格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "UriOrNull":
                {
                    if (!isUriOrnull(value)) {
                        Validatemsg = errormsg + "必须为网址格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Equal":
                {
                    if (!isEqual(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "不相等！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "PwdConfirm":
                {
                    if (!PwdCheck(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "不一致！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "LengthAndNotNull":
                {
                    //1.不为空
                    if (isNotNull(value)) {
                        Validatemsg = errormsg + "不能为空！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    //2.验证长度
                    if (!objLength(value, 9)) {
                        Validatemsg = errormsg + "长度不能小于 " + 9 + "位！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Date":
                {
                    if (!isDate(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为日期格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "DateOrNull":
                {
                    if (!isDateOrNull(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为日期格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "DateTime":
                {
                    if (!isDateTime(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为日期时间格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "DateTimeOrNull":
                {
                    if (!isDateTimeOrNull(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为日期时间格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Time":
                {
                    if (!isTime(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为时间格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "TimeOrNull":
                {
                    if (!isTimeOrNull(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为时间格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "ChineseStr":
                {
                    if (!isChinese(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为中文！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "ChineseStrOrNull":
                {
                    if (!isChineseOrNull(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为中文！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Zip":
                {
                    if (!isZip(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为邮编格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "ZipOrNull":
                {
                    if (!isZipOrNull(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为邮编格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "Double":
                {
                    if (!isDouble(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为小数！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "DoubleOrNull":
                {
                    if (!isDoubleOrNull(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为小数！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "IDCard":
                {
                    if (!isIDCard(value, $(this).attr("eqvalue"))) {
                        debugger
                        Validatemsg = errormsg + "必须为身份证格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "IDCardOrNull":
                {
                    if (!isIDCardOrNull(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为身份证格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "IsIP":
                {
                    if (!isIP(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为IP格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                case "IPOrNull":
                {
                    if (!isIPOrNullOrNull(value, $(this).attr("eqvalue"))) {
                        Validatemsg = errormsg + "必须为IP格式！\n";
                        Validateflag = false;
                        ValidationMessage($(this), Validatemsg);
                        return false;
                    }
                    break;
                }
                default:
                    break;
            }
        }
    });
    if ($(this).find("[fieldexist=yes]").length > 0) {
        return false;
    }
    return Validateflag;
}
//验证不为空 notnull
function isNotNull(obj) {
    obj = $.trim(obj);
    if (obj.length == 0 || obj == null || obj == undefined) {
        return true;
    }
    else
        return false;
}
//验证数字 num
function isInteger(obj) {
    reg = /^[-+]?\d+$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//正整数或不大于两位小数验证
function isIntegerOrDouble(obj) {
    reg = /^\d+(\.\d{2})?$/;
    if (!reg.test(obj)) {
        reg = /^\d+(\.\d{1})?$/;
        if (!reg.test(obj)) {
            return false;
        } else {
            return true;
        }
    } else {
        return true;
    }
}
//验证数字 num  或者null,空
function isIntegerOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    reg = /^[-+]?\d+$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//Email验证 email
function isEmail(obj) {
    //reg = /^\w{3,}@\w+(\.\w+)+$/;
    reg = /^[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//Email验证 email   或者null,空
function isEmailOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    //reg = /^\w{3,}@\w+(\.\w+)+$/;
    reg = /^[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证只能输入英文字符串 echar
function isEnglishStr(obj) {
    reg = /^[a-z,A-Z]+$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证只能输入英文字符串 echar 或者null,空
function isEnglishStrOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    reg = /^[a-z,A-Z]+$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证是否是n位数字字符串编号 nnum
function isLenNum(obj, n) {
    reg = /^[0-9]+$/;
    obj = $.trim(obj);
    if (obj.length > n)
        return false;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证是否是n位数字字符串编号 nnum或者null,空
function isLenNumOrNull(obj, n) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    reg = /^[0-9]+$/;
    obj = $.trim(obj);
    if (obj.length > n)
        return false;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证是否小于等于n位数的字符串 nchar
function isLenStr(obj, n) {
    //reg = /^[A-Za-z0-9\u0391-\uFFE5]+$/;
    obj = $.trim(obj);
    if (obj.length == 0 || obj.length > n)
        return false;
    else
        return true;
}
//验证是否小于等于n位数的字符串 nchar或者null,空
function isLenStrOrNull(obj, n) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    obj = $.trim(obj);
    if (obj.length > n)
        return false;
    else
        return true;
}
//验证是否电话号码 phone
function isTelephone(obj) {
    reg = /^(\d{3,4}\-)?[1-9]\d{6,7}$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证是否电话号码 phone或者null,空
function isTelephoneOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    reg = /^(\d{3,4}\-)?[1-9]\d{6,7}$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证是否手机号 mobile
function isMobile(obj) {
    reg = /^(\+\d{2,3}\-)?\d{11}$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证是否手机号 (只控制数字和11位数)
function isMobilePhone(obj) {
    if (!isInteger(obj)) {
        return false;
    }
    if (obj.length != 11) {
        return false;
    }
    return true;
}

//验证是否手机号 mobile或者为空
function mobileOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    if (!isInteger(obj)) {
        return false;
    }
    if (obj.length != 11) {
        return false;
    }
    return true;
}
//验证是否手机号 mobile或者null,空
function isMobileOrnull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    //reg = /^(\+\d{2,3}\-)?\d{11}$/;
    reg = /^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证是否手机号 mobile或者null,空
function isMobileOrNullNew(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    return isMobilePhone(obj);
}
//验证是否手机号或电话号码 mobile phone
function isMobileOrPhone(obj) {
    reg_mobile = /^(\+\d{2,3}\-)?\d{11}$/;
    reg_phone = /^(\d{3,4}\-)?[1-9]\d{6,7}$/;
    if (!reg_mobile.test(obj) && !reg_phone.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证是否手机号或电话号码 mobile phone或者null,空
function isMobileOrPhoneOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    reg = /^(\+\d{2,3}\-)?\d{11}$/;
    reg2 = /^(\d{3,4}\-)?[1-9]\d{6,7}$/;
    if (!reg.test(obj) && !reg2.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证网址 uri
function isUri(obj) {
    reg = /^http:\/\/[a-zA-Z0-9]+\.[a-zA-Z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证网址 uri或者null,空
function isUriOrnull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    reg = /^http:\/\/[a-zA-Z0-9]+\.[a-zA-Z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
    if (!reg.test(obj)) {
        return false;
    } else {
        return true;
    }
}
//验证前后前面密码是否一致
function PwdCheck(obj1, controlObj) {
    if (obj1 != $(controlObj).val()) {
        return false;
    }
    return true;
}
//验证长度
function objLength(obj, len) {
    var result = true;
    if (obj.length < len) {
        result = false
    }
    return result;
}

//验证两个值是否相等 equals
function isEqual(obj1, controlObj) {
    if (obj1.length != 0 && controlObj.length != 0) {
        if (obj1 == controlObj)
            return true;
        else
            return false;
    }
    else
        return false;
}
//判断日期类型是否为YYYY-MM-DD格式的类型 date
function isDate(obj) {
    if (obj.length != 0) {
        reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/;
        if (!reg.test(obj)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断日期类型是否为YYYY-MM-DD格式的类型 date或者null,空
function isDateOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    if (obj.length != 0) {
        reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/;
        if (!reg.test(obj)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断日期类型是否为YYYY-MM-DD hh:mm:ss格式的类型 datetime
function isDateTime(obj) {
    if (obj.length != 0) {
        reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;
        if (!reg.test(obj)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断日期类型是否为YYYY-MM-DD hh:mm:ss格式的类型 datetime或者null,空
function isDateTimeOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    if (obj.length != 0) {
        reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;
        if (!reg.test(obj)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断日期类型是否为hh:mm:ss格式的类型 time
function isTime(obj) {
    if (obj.length != 0) {
        reg = /^((20|21|22|23|[0-1]\d)\:[0-5][0-9])(\:[0-5][0-9])?$/;
        if (!reg.test(obj)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断日期类型是否为hh:mm:ss格式的类型 time或者null,空
function isTimeOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    if (obj.length != 0) {
        reg = /^((20|21|22|23|[0-1]\d)\:[0-5][0-9])(\:[0-5][0-9])?$/;
        if (!reg.test(obj)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断输入的字符是否为中文 cchar
function isChinese(obj) {
    if (obj.length != 0) {
        reg = /^[\u0391-\uFFE5]+$/;
        if (!reg.test(str)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断输入的字符是否为中文 cchar或者null,空
function isChineseOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    if (obj.length != 0) {
        reg = /^[\u0391-\uFFE5]+$/;
        if (!reg.test(str)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断输入的邮编(只能为六位)是否正确 zip
function isZip(obj) {
    if (obj.length != 0) {
        reg = /^\d{6}$/;
        if (!reg.test(str)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断输入的邮编(只能为六位)是否正确 zip或者null,空
function isZipOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    if (obj.length != 0) {
        reg = /^\d{6}$/;
        if (!reg.test(str)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断输入的字符是否为双精度 double
function isDouble(obj) {
    if (obj.length != 0) {
        reg = /^[-\+]?\d+(\.\d+)?$/;
        if (!reg.test(obj)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断输入的字符是否为双精度 double或者null,空
function isDoubleOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    if (obj.length != 0) {
        reg = /^[-\+]?\d+(\.\d+)?$/;
        if (!reg.test(obj)) {
            return false;
        }
        else {
            return true;
        }
    }
}
//判断是否为身份证 idcard
function isIDCard(obj) {
    debugger
    if (obj.length != 0) {
        reg = /^\d{15}(\d{2}[A-Za-z0-9;])?$/;
        //if (!reg.test(obj))
        if (!IdentityCodeValid(obj))
            return false;
        else
            return true;
    }
}
//判断是否为身份证 idcard或者null,空
function isIDCardOrNull(obj) {
    debugger
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    if (obj.length != 0) {
        reg = /^\d{15}(\d{2}[A-Za-z0-9;])?$/;
        //if (!reg.test(obj))
        if (!IdentityCodeValid(obj))
            return false;
        else
            return true;
    }
}

function IdentityCodeValid(id) {
    var pass = false;
    var format = /^(([1][1-5])|([2][1-3])|([3][1-7])|([4][1-6])|([5][0-4])|([6][1-5])|([7][1])|([8][1-2]))\d{4}(([1][9]\d{2})|([2]\d{3}))(([0][1-9])|([1][0-2]))(([0][1-9])|([1-2][0-9])|([3][0-1]))\d{3}[0-9xX]$/;
    //号码规则校验
    if (!format.test(id)) {
        return pass;
    }
    //区位码校验
    //出生年月日校验   前正则限制起始年份为1900;
    var year = id.substr(6, 4),//身份证年
        month = id.substr(10, 2),//身份证月
        date = id.substr(12, 2),//身份证日
        time = Date.parse(month + '-' + date + '-' + year),//身份证日期时间戳date
        now_time = Date.parse(new Date()),//当前时间戳
        dates = (new Date(year, month, 0)).getDate();//身份证当月天数
    if (time > now_time || date > dates) {
        return pass;
    }
    //校验码判断
    var c = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2);   //系数
    var b = new Array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2');  //校验码对照表
    var id_array = id.split("");
    var sum = 0;
    for (var k = 0; k < 17; k++) {
        sum += parseInt(id_array[k]) * parseInt(c[k]);
    }
    if (id_array[17].toUpperCase() != b[sum % 11].toUpperCase()) {
        return pass;
    }
    pass = true;
    //if(!pass) alert(tip);
    return pass;
}

//判断是否为IP地址格式
function isIP(obj) {
    var re = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g //匹配IP地址的正则表达式
    if (re.test(obj)) {
        if (RegExp.$1 < 256 && RegExp.$2 < 256 && RegExp.$3 < 256 && RegExp.$4 < 256) return true;
    }
    return false;
}
//判断是否为IP地址格式 或者null,空
function isIPOrNull(obj) {
    var controlObj = $.trim(obj);
    if (controlObj.length == 0 || controlObj == null || controlObj == undefined) {
        return true;
    }
    var re = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g //匹配IP地址的正则表达式
    if (re.test(obj)) {
        if (RegExp.$1 < 256 && RegExp.$2 < 256 && RegExp.$3 < 256 && RegExp.$4 < 256) return true;
    }
    return false;
}


/**
 * 备注改变事件
 */
function remarkChange() {
    //debugger

    var $obj_remark = $("#obj_remark") || $(".classObjRemark");

    var strMax = 250;//最大长度
    var strlen = 0; //初始定义长度为0
    var txtval = $obj_remark.val();
    if (txtval) {
        for (var i = 0; i < txtval.length; i++) {
            strlen = strlen + 1;//中文和英文都是一个字符(mysql_5.0新版本特性)
        }
    }
    var strLeave = strMax - strlen;
    if (strlen >= strMax) {
        $("#remarkNum").css("color", "red");
    } else {
        $("#remarkNum").css("color", "#bfbfbf");
    }
    $("#remarkNum").text(strlen);
    if (strLeave <= 0) {
        $obj_remark.val(txtval.substring(0, strMax));
        /*$obj_remark.keydown(
         function(e) {
         return false
         }
         );*/
        //这个与输入法有冲突
        /*$obj_remark.keypress(
         function(e) {
         return false
         }
         );*/
    }
}

//提示信息
function ValidationMessage(obj, Validatemsg) {
    try {
        removeMessage(obj);
        obj.focus();
        var $poptip_error = $('<div class="poptip">' + Validatemsg + '</div>').css("color", "#d73925").css("left", obj.offset().left + 'px').css("top", obj.offset().top + obj.parent().height() + 5 + 'px')
        obj.parent().append($poptip_error);
        if (obj.hasClass('form-control') || obj.hasClass('ui-select')) {
            obj.parent().addClass('has-error');
        }
        if (obj.hasClass('ui-select')) {
            $('.input-error').remove();
        }
        obj.change(function () {
            if (obj.val()) {
                removeMessage(obj);
            }
        });
        if (obj.hasClass('ui-select')) {
            $(document).click(function (e) {
                if (obj.attr('data-value')) {
                    removeMessage(obj);
                }
                e.stopPropagation();
            });
        }
        return false;
    } catch (e) {
        alert(e)
    }
}
//移除提示
function removeMessage(obj) {
    obj.parent().removeClass('has-error');
    $('.poptip').remove();
    $('.input-error').remove();
}
// 用法
// if (!$('#form1').Validform()) {
//     return false;
// }

// 页面 input 框中输入
// isvalid="yes" checkexpession="NotNull" errormsg="姓名"
//验证是否是数字是数字返回true
function isNotNumber(val) {

    var regPos = /^\d+(\.\d+)?$/; //非负浮点数
    var regNeg = /^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //负浮点数
    if (regPos.test(val) || regNeg.test(val)) {
        return false;
    } else {
        return true;
        // return false;
    }

}