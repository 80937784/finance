/**
 * 人脸采集js
 */
var params = Ec.Util.getUrlParams() || {};
var propObj;
var personAttrArray;
$(document).ready(function() {
	initPage();
	initEvent();
});

// 初始化页面
function initPage() {
	initCropper();// 初始化cropper剪裁机
}

// 注册事件
function initEvent() {
	$("#faceImg").click(facePicClick);// 人脸照片选取-start
	$("#selFaceImg").click(facePicClick);
	$("#facePic").change(imgFileOnChange);
	$('#cropperModal').on('hide.bs.modal', function() {
		$('#gridSystemModal').css({
			'overflow-y' : 'scroll'
		});
	});
	$("#btn_save").click(btnSubmit);// 提交
}

// 提交前核实数据非法性
function checkData() {
	var result = true;
	var inputObjs = $("input[type='text'][id^='obj_']");
	var radioObjs = $("input[type='radio'][name^='obj_']");
	var checkboxObjs = $("input[type='checkbox'][name^='obj_']");
	// 1.输入框
	for (var i = 0; i < inputObjs.length; i++) {
		var $obj = $(inputObjs[i]);
		var objValue = $obj.val();
		var objErrormsg = $obj.attr("errormsg");
		var objId = $obj.attr("id");
		var isrequired = $obj.attr("isrequired");// 是否必填
		if ("true" == isrequired) {
			if (isNotNull(objValue)) {
				ValidationMessage($obj, objErrormsg + "不能为空");
				result = false;
				return result;
			}
		}
		var attrId = objId.substring(4);
		if (attrId == 1) {
			// 身份证号
			if (!isIDCardOrNull(objValue)) {
				ValidationMessage($obj, "必须为身份证格式");
				result = false;
				return result;
			}
		}
		if (attrId == 2) {
			// 手机号
			if (!mobileOrNull(objValue)) {
				ValidationMessage($obj, "必须为手机格式");
				result = false;
				return result;
			}
		}
		if (attrId == 3) {
			// 卡号-数据库字段大小20位
			if (!isLenStrOrNull(objValue, 20)) {
				ValidationMessage($obj, "必须小于20位字符");
				result = false;
				return result;
			}
		}
		if (attrId == 4) {
			// 姓名-数据库字段大小30位
			if (!isLenStrOrNull(objValue, 30)) {
				ValidationMessage($obj, "必须小于30位字符");
				result = false;
				return result;
			}
		}
		if (attrId == 5) {
			// 邮箱
			if (!isEmailOrNull(objValue)) {
				ValidationMessage($obj, "必须为E-mail格式");
				result = false;
				return result;
			}
		}
		if (attrId == 11) {
			var uploadUserId = params.uploadUserId;
			// 学工号
			if (uploadUserId && objValue != uploadUserId) {
				ValidationMessage($obj, "请输入正确的学号(工号)");
				result = false;
				return result;
			}
		}
	}
	// 2.单选按钮
	for (var i = 0; i < radioObjs.length; i++) {
		var $obj = $(radioObjs[i]);
		var objName = $obj.attr("name");
		var isrequired = $obj.attr("isrequired");// 是否必选
		if ("true" == isrequired) {
			var objValue = $('input[type=radio][name="' + objName + '"]:checked').val();
			if (objValue == undefined) {
				// form-group
				var parentObj = $obj.parent().parent();
				var sp = parentObj.find("span").last();
				$(sp).html("&nbsp;&nbsp;&nbsp;需要选择一项");
				$(sp).css("color", "red");
				result = false;
				break;
			}
		}
	}
	// 3.复选框
	for (var i = 0; i < checkboxObjs.length; i++) {
		var $obj = $(checkboxObjs[i]);
		var objName = $obj.attr("name");
		var isrequired = $obj.attr("isrequired");// 是否必选
		if ("true" == isrequired) {
			var objValue = $('input[type=checkbox][name="' + objName + '"]:checked').val();
			if (objValue == undefined) {
				// form-group
				var parentObj = $obj.parent().parent();
				var sp = parentObj.find("span").last();
				$(sp).html("&nbsp;&nbsp;&nbsp;需要选择一项");
				$(sp).css("color", "red");
				result = false;
				break;
			}
		}
	}
	// 4.人脸照片
	var faceImgSrc = $("#faceImg").attr("src");
	if (faceImgSrc.indexOf("base64") < 0) {
		var parentObj = $("#faceImg").parent();
		var sp = parentObj.find("span").last();
		$(sp).html("&nbsp;&nbsp;&nbsp;需要选择人脸照片");
		$(sp).css("color", "red");
		result = false;
	}
	return result
}

// 初始化裁剪图片
function initCropper() {// 调整20180928 300 300
	$("#cropperImage").cropper({
		aspectRatio : 3 / 4,
		zoomable : false,
		viewModel : 1,
		minContainerWidth : 300,
		minContainerHeight : 300
	});
}

// 选择图片
function facePicClick() {
	$("#facePic").click();
}

// 上传
function imgFileOnChange() {
	var file1 = this.files[0];
	if (typeof (file1) != 'undefined' && file1.type.indexOf("image/") != 0) {
		showTips("您上传的不是照片，请重新上传照片", 3000, 0);
		return 0;
	}
	var imgSrc = $("#faceImg")[0].src || '';
	if (typeof (file1) == 'undefined' && imgSrc.length == 0) {
		showTips("请上传照片", 3000, 0);
		return 0;
	}
	if (typeof (file1) == 'undefined') {
		return 0;
	}
	// 640, width: 640
	lrz(file1, {
		height : 640,
		width : 640
	}).then(function(rst) {
		$("#cropperImage").cropper("replace", rst.base64);
		$("#cropperModal").modal();
		$("#facePic").val('');
	});

}

// 图片Base64编码
var logoImgbase64;
function cropperSuccess() {
	logoImgbase64 = $("#cropperImage").cropper('getCroppedCanvas', {
		width : 640,
		height : 640
	}).toDataURL('image/png');
	$("#faceImg").attr("src", logoImgbase64);
	$("span.faceError").empty();
	$("#cropperModal").modal("hide");
	$("#caseModal").modal("hide");
};

// 提交
function btnSubmit() {
	$("#btn_save").attr("disabled", true);// 提交按钮禁用
	if (checkData()) {
		var person = {};
		person.userId = $("#obj_11").val();// 用户唯一标识
		person.userName = $("#obj_12").val();// 姓名
		person.imgBase64 = '';
		// 人脸照片base64
		var faceImgSrc = $("#faceImg").attr("src");
		if (faceImgSrc.indexOf("base64") > 0) {
			person.imgBase64 = faceImgSrc.substring(faceImgSrc.indexOf(',') + 1);
		}
		person.uploadUserId = params.uploadUserId;// 数据来源
		// json对象转json串
		var personStr = JSON.stringify(person);
		// 提交
		var url = 'basedata/face/collect/save';
		$.ajax({
			url : urlCtx + url,
			type : "POST",
			dataType : "json",
			contentType : "application/json",
			data : personStr,
			success : function(res) {
				if (res.code == 0) {
					params.faceId = res.data.faceId
					var url = Ec.Util.generateURL(urlCtx + 'basedata/face/collect/success/' + res.data.faceId);
					window.location.href = url;
				} else {
					// 此处可以直接提示，也可以跳转到失败页面提示,目前跳转失败页面
					// showTips(resMsg.ErrorDesc, 3000, 0);
					params.failReason = res.msg;
					var url = Ec.Util.generateURL(urlCtx + 'basedata/face/collect/fail', params);
					window.location.href = url;
					$("#btn_save").removeAttr("disabled");
				}
			}
		});
	} else {
		$("#btn_save").removeAttr("disabled");
	}
}