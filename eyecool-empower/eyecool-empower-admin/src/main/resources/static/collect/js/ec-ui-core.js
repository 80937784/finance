/* 
 * 前端公用封装类库。
 * 组件清单：
 *  1.包装的ajax工具类
 *   统一处理ajax请求，提供通用的操作例如进度条、提示框、异常处理等
* @Author: duancunming
* @Date:   2018-04-17
* @Last Modified by:   
* @Last Modified time: 2018-04-17
*/
var Ec = window.NameSpace || {};
Ec.ajax = function(opt) {
    var defaultOptions={
        type: 'post',
        cache: false,
        dataType : "json",
        contentType:"application/x-www-form-urlencoded; charset=UTF-8"
    }
    var progressBar;
    //显示进度条 遮罩层
    if (opt.showProgress == "true" || opt.showProgress) {
    	Ec.showLoader();
    }
    var showProgressOpt = {
        success:function(data) {//回调函数
        	Ec.hideLoader();
            if (data != undefined && data["code"] == "403") {
                if (data.nextPage != null && data.nextPage != "") {
                    setTimeout(function() {
                        window.location = data.nextPage;
                    }, 800);
                    return;
                }
            } else {
                //判断是否可自动调用showOperResult
                if (opt.autoHandleResult == true || opt.autoHandleResult == "true") {
                	//待完善，增加统一的提示信息框Ec.Util.showOperResult(data,opt.success,opt.fail);
                	 opt.success(data);
                } else if (opt.fail == undefined || typeof opt.fail != "function") {
                    //如果无fail方法，则全部都走success方法，失败在success方法内部进行判断
                    opt.success(data);
                } else {
                    if (opt.successful && typeof opt.success == "function") {
                        opt.success(data);
                    } else if (typeof opt.fail == "function") {
                        opt.fail(data);
                    }
                }
            }
        },
        //回调函数
        complete: function() {
        	Ec.hideLoader();
            if (typeof opt.complete == "function") {
                opt.complete();
            }
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {//回调函数
        	Ec.hideLoader();
            if (typeof opt.error == "function") {
                opt.error(XMLHttpRequest, textStatus, errorThrown);
            } else {
                if (!(XMLHttpRequest != undefined && XMLHttpRequest["responseText"] == "")) {
                	//提示框 待完善
                	//var txt = '访问后台出错，请联系管理员！';//+ (xhr.status +" "+ xhr.statusText);
                    //Ec.showWarning(txt);
                }
            }
        }
    }
    $.extend(defaultOptions, opt);
    $.extend(defaultOptions, showProgressOpt);
    $.ajax(defaultOptions);
}

/**
 * 显示遮罩层
 */
Ec.showLoader = function() {
	$(".shadeA").show();
	$(".loaderA").show();
}

/**
 * 隐藏遮罩层
 */
Ec.hideLoader = function() {
	$(".shadeA").hide();
	$(".loaderA").hide();
}

//用于生成uuid
Ec.S4 = function() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
}
Ec.guid = function() {
    return (Ec.S4()+Ec.S4()+Ec.S4()+Ec.S4()+Ec.S4()+Ec.S4()+Ec.S4()+Ec.S4());
}

if (!Function.prototype.bind) {//如果原型上没有bind方法
    Function.prototype.bind = function (context) {
        var args = arguments,//获取要传入的所有参数
            obj = arguments[0],//获取要绑定的上下文
            func = this;//获取要调用的函数
        return function () {//返回一个新的函数
            var argc = Array.prototype.slice.call(args, 1);//获取bind的剩余传入参数
            Array.prototype.push.apply(argc, arguments);//将调用时的参数放到最后
            return func.apply(obj || null, argc);//使用新的this执行func函数
        }
    }
}

if (!String.prototype.trim) {
    String.prototype.trim = function () {
        return this.replace(/(^\s*)|(\s*$)/g, "");
    }
}

if (!String.prototype.ltrim) {
    String.prototype.ltrim = function () {
        return this.replace(/(^\s*)/g, "");
    }
}

if (!String.prototype.rtrim) {
    String.prototype.rtrim = function () {
        return this.replace(/(\s*$)/g, "");
    }
}

if (!String.prototype.replaceAll) {
    String.prototype.replaceAll = function (sourceWord, targetWord) {
        var regeExp = new RegExp(sourceWord, "g");
        return this.replace(regeExp, targetWord);
    }
}

/* 
 * 前端工具类库。
* @Author: duancunming
* @Date:   2018-04-17
* @Last Modified by:   
* @Last Modified time: 2018-04-17
*/
Ec.Util = new function() {
	  var self = this;
	  /*判断对象长度*/
	  self.count = function(o) {
	        var t = typeof o;
	        if(t == 'string'){
	            return o.length;
	        }else if(t == 'object'){
                var n = 0;
                for(var i in o){
                	n++;
                }
                return n;
	        }
	        return false;
	    },
	    //判断是否是json
	    self.isJson = function(obj) {
	        var isjson = typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length; 
	        return isjson;
	    },
	    //连接两个json
	    self.concat = function(targetObj, obj) {
	        if (this.isJson(obj) && targetObj != undefined) {
	            for (index in obj) {
	                targetObj[index] = obj[index];
	            }
	        }
	        return targetObj;
	    },
	    /*** 对JSON对象进行深拷贝，而不是进行引用传递* @param obj 待拷贝的JSON对象*/
	    self.copyJsonObj = function(obj) {
	        if(!!obj && typeof(obj) == "object") { 
	            var copyObj = {}; 
	            for(var field in obj) { 
	                if (typeof(obj[field]) == "object") { 
	                    copyObj[field] = Ec.Util.copyJsonObj(obj[field]); 
	                } else {
	                    copyObj[field] = obj[field];
	                } 
	            } 
	            return copyObj; 
	        } return obj;
	    },
	    //获取url中的参数
	    self.getUrlParams = function(url) {
	        var paramJson = {};
	        var n = 0;
	        if (typeof url == "undefined" || url == null || url == "") {
	            url = window.location.href;
	        }
	        var n = url.indexOf("?")//查看是否包含参数
	        var sharpIndex = url.lastIndexOf("#");
	        if ( sharpIndex >= 0) {
	            url = url.substring(0, sharpIndex);
	        }
	        //存在参数 
	        if (n>0) {
	            //参数   
	            var params = url.substr(n+1); 
	            var paramsArray = new Array();
	            if (typeof params != "undefined" && params) {
	                paramsArray = params.split("&");
	            }
	            if (typeof paramsArray != "undefined" && paramsArray && paramsArray.length > 0) {
	                for (var i = 0; i < paramsArray.length;i++) {
	                    paramArray = paramsArray[i].split("=");
	                    paramArray[0] = paramArray[0].replace(/\s/g, '').replace(/%20/g, '');
	                    if (paramArray != undefined && paramArray.length ==2) {
	                        paramArray[1] = paramArray[1].replaceAll('%3A',":").replaceAll('%2C',",");
	                    }
	                    try {
	                        //先尝试此种解码方式并转化为json（适用于参数值为参数格式）
	                        //排除是数字的情况，数字不用$.parseJSON，否则会被四舍五入
	                        if (!isNaN(decodeURI(paramArray[1]))) {
	                            paramJson[paramArray[0]] = decodeURI(paramArray[1]);
	                        } else {
	                            paramJson[paramArray[0]] = $.parseJSON(decodeURI(paramArray[1]));
	                        }
	                    } catch(e) {
	                        try {
	                            //先尝试此种解码方式并转化为json（适用于参数值为参数格式）
	                            //排除是数字的情况，数字不用$.parseJSON，否则会被四舍五入
	                            if (!isNaN(decodeURI(paramArray[1]))) {
	                                paramJson[paramArray[0]] = decodeURIComponent(paramArray[1]);
	                            } else {
	                                paramJson[paramArray[0]] = $.parseJSON(decodeURIComponent(paramArray[1]));
	                            }
	                        } catch(e) {
	                            try {
	                                //否则尝试此种解码方式并转化为json（适用于参数值为参数格式）
	                                if (!isNaN(decodeURI(paramArray[1]))) {
	                                    paramJson[paramArray[0]] = unescape(paramArray[1]);
	                                } else {
	                                    paramJson[paramArray[0]] = $.parseJSON(unescape(paramArray[1]));
	                                }
	                            } catch(e) {
	                                try {
	                                    //否则直接解码返回
	                                    paramJson[paramArray[0]] = decodeURI(paramArray[1]);
	                                } catch(e) {
	                                    //否则直接解码返回
	                                    paramJson[paramArray[0]] = unescape(paramArray[1]);
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	        }
	        return paramJson;
	    },
	    /**
	     * 创建带参数的页面URL.
	     * var url = Ec.Util.generateURL("/index.html", { name : "zhangsan" });
	     * 返回的url内容是/index.html?name=zhangsan
	     * 
	     * @param url 页面地址
	     * @param paramObj 参数对象
	     */
	    self.generateURL = function(url, paramObj) {
	        if (paramObj != undefined) {
	            for (key in paramObj) {
	                url = url + (url.indexOf("?") > -1 ? "&" : "?") + key + "=" + paramObj[key];
	            }
	        }
	        
	        return encodeURI(url);
	    },
	    self.getShowModelDialogName = function(){
	        var iframeName = window.name;
	        //try、catch防止跨域问题的产生
	        try {
	            if (iframeName == undefined || iframeName == "") {
	                var iframeWindow = window;
	                
	                while ((iframeName == undefined || iframeName == "") && iframeWindow != iframeWindow.parent) {
	                    iframeWindow = iframeWindow.parent;
	                    iframeName = iframeWindow.name;
	                }
	            }
	        } catch(e) {
	            return window.name;
	        }
	        return iframeName;
	    },
	    self.getIframeObjByName = function(iframeName){
	        var iframe;
	        if (iframeName == undefined || iframeName == "") {
	            iframeName = Ec.Util.getShowModelDialogName();//window.name;
	        }
	        if (iframeName != undefined && iframeName != "") {
	            if (window != undefined && window.parent != undefined && window.parent.document != undefined) {
	                iframe = window.parent.document.getElementsByName(iframeName)[0];
	                if (!iframe) {
	                    if(window.frameElement) {
	                        var frameElementName = window.frameElement.name; 
	                        iframe = window.parent.document.getElementsByName(frameElementName)[0];
	                    }
	                }
	            }
	        }
	        return iframe;
	    },
	    //将参数由string类型设置为json类型
	    self.paramsStringTojson = function(params) {
	        var paramJson = {};
	        //参数
	        var paramsArray = new Array();
	        if (typeof params != "undefined" && params) {
	            paramsArray = params.split("&");
	        }
	        if (typeof paramsArray != "undefined" && paramsArray && paramsArray.length > 0) {
	            for (var i = 0; i < paramsArray.length;i++) {
	                paramArray = paramsArray[i].split("=");
	                paramJson[paramArray[0]] = decodeURI(paramArray[1]);
	            }
	        }
	        return paramJson;
	    },
	    self.getSystemUrl = function () {
	        //获取当前网址
	        var curPath=window.document.location.href;
	        //获取主机地址之后的目录
	        var pathName=window.document.location.pathname;
	        var pos=curPath.indexOf(pathName);
	        //获取主机地址
	        var localhostPath=curPath.substring(0,pos);
	        //获取项目名
	        var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+2);
	        var realPath=localhostPath+projectName;
	        return realPath;
	      },
	      //判断是否为{}空对象
	      self.isEmptyObject = function (e) {  
	          var t;  
	          for (t in e)  
	              return !1;  
	          return !0  
	      },
	    //判断两个对象是否相等
	      self.isObjectValueEqual = function(a, b) {
	          if(typeof a == 'number' && typeof b == 'number'){
	              return a == b
	          }
	          var aProps = Object.getOwnPropertyNames(a);
	          var bProps = Object.getOwnPropertyNames(b);
	          if (aProps.length != bProps.length) {
	              return false;
	          }
	          for (var i = 0; i < aProps.length; i++) {
	              var propName = aProps[i];
	              if(Object.prototype.toString(a[propName]) == '[Object Object]'||Object.prototype.toString(b[propName]) == '[Object Object]'){
	                  isObjectValueEqual(a[propName],b[propName])
	              }
	              if (a[propName] !== b[propName]) {
	                  return false;
	              }
	          }
	          return true;
	      },
	      //阻止事件冒泡
	      self.stopEventPropagation = function(event){
	          event = event||window.event; 
	          var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
	          var isOpera = userAgent.indexOf("Opera") > -1;
	          if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
	              event.cancelBubble = true;//停止冒泡
	          } else {
	              event.stopPropagation();
	              event.preventDefault();
	          }
	      },
	      self.addEvent = (function() {
	          if (document.attachEvent) {
	              return function(element, event, handler) {
	                  element.attachEvent('on' + event, function() {
	                      var event = window.event;
	                      event.currentTarget = element;
	                      event.target = event.srcElement;
	                      handler.call(element, event); 
	                  });
	              }; 
	           } else {
	              return function(element, event, handler) {
	                  element.addEventListener(event, handler, false);
	              };
	          }
	      }()),
	      self.isInArray = function(arr, val){
	    	  var index = $.inArray(val, arr);
	    	    if(index >= 0){
	    	        return true;
	    	    }
	    	    return false;
	      },
	      self.showOperResult = function (operResult, success_func, fail_func){
	          var msg = "";
	          //首先判断是否无查看权限，如果无查看权限，则跳转到无权限页面--待完善
	          if ((operResult.successful == undefined || operResult.successful) && typeof success_func == "function") {
	              success_func(operResult);
	          } else if (typeof fail_func == "function") {
	              fail_func(operResult);
	          }
	          
	          if (operResult.msgCode != null && operResult.msgCode != "") {
	              //placeHolderParams不为空，则认为是msgCode中存在{0}占位符的情况，message为默认值
	              if (operResult.placeHolderParams != undefined && operResult.placeHolderParams != "") {
	                  msg = operResult.message;
	              } else {
	                  msg = operResult.message;
	              }
	          } else {
	              msg = operResult.message;
	          }
	          if (msg != null && msg != "") {
	              if ((operResult.successful || operResult.success || operResult.successful == undefined) && !(operResult.nextPage != undefined && operResult.nextPage != "")) {
	                  Ec.showSuccess(msg);
	              } else {
	                  Ec.showWarning(msg);
	              }
	          }
	          if (operResult.successful && operResult.nextPage != null && operResult.nextPage != "") {
	              setTimeout(function() {
	                  window.location = operResult.nextPage;
	              }, 800);
	              return;
	          }
	          return operResult.successful;
	      },
	      self.loadScript = function(url, callback) {
	          var script = document.createElement ("script")
	          script.type = "text/javascript";
	          if (script.readyState){ //IE
	              script.onreadystatechange = function(){
	                  if (script.readyState == "loaded" || script.readyState == "complete"){
	                      script.onreadystatechange = null;
	                      callback();
	                  }
	              };
	          } else { //Others
	              script.onload = function(){
	                  callback();
	              };
	          }
	          script.src = url;
	          document.getElementsByTagName("head")[0].appendChild(script);
	      }
	};

	// 弹出层窗体
	var _height = window.screen.availHeight;
	//操作成功弹层
	Ec.showSuccess = function(prompt){
		var iframeObj = Ec.Util.getIframeObjByName();
		$("body",window.parent.parent.document).find(".successLayer").remove();
		$("body",window.parent.parent.document).find(".warningLayer").remove();
		var alertId = "fadeOut_alert_" + (new Date()).getTime()+parseInt(Math.random()*100000);//弹窗索引
		if (iframeObj != undefined) {
			iframeObj.setAttribute("data-alert-id", alertId);
		}
		var $box = $("<div>").addClass("successLayer").attr("id",alertId);//成功弹窗插件容器
		var $icon = $("<span>").addClass('success_icon');//成功图标
		var $text = $("<span>").addClass("success_text");//操作成功
		if(prompt == undefined){
			var $textContent = $text.html('操作成功！');
		}else{
			var $textContent = $text.html(prompt); //提示内容
		}
		var $close = $("<span>").addClass("layer_close");//关闭按钮
		$box.append($icon).append($text).append($close);
		$("body",window.parent.parent.document).append($box);
		$box.css('top',_height *0.65 +"px");
		$close.on('click',function(){
			$box.remove()
		});
		$box.fadeOut(10000,function(){
			$box.remove();
		});
	}

	//警告弹层
	Ec.showWarning = function(prompt){
		var iframeObj = Ec.Util.getIframeObjByName();
		$("body",window.parent.parent.document).find(".successLayer").remove();
		$("body",window.parent.parent.document).find(".warningLayer").remove();
		var alertId = "fadeOut_alert_" + (new Date()).getTime()+parseInt(Math.random()*100000);//弹窗索引
		if (iframeObj != undefined) {
			iframeObj.setAttribute("data-alert-id", alertId);
		}
		var $box = $("<div>").addClass("warningLayer").attr("id",alertId);//警告弹窗插件容器
		var $icon = $("<span>").addClass('warning_icon');//警告图标
		var $text = $("<span>").addClass("warning_text");//操作警告
		var $textContent = $text.html(prompt);//提示内容
		var $close = $("<span>").addClass("layer_close");//关闭按钮
		$box.append($icon).append($text).append($close);
		$("body",window.parent.parent.document).append($box);
		$box.css('top',_height *0.65 +"px");
		$close.on('click',function(){
			$box.remove();
		});
		$box.fadeOut(20000,function(){
			$box.remove();
		});
	}
	
	/**
	 * 获取顶层窗口
	 */
	getTopWindow = function(){
	    var topWindow;
	    try {
	        var parentAttr = window.parent;
	        var windowAttr = window;
	        while (parentAttr != windowAttr) {
	            windowAttr = parentAttr;
	            parentAttr = parentAttr.parent;
	        }
	        topWindow = windowAttr;
	        topWindow.document;
	    } catch(e) {
	        topWindow = window.parent;
	    }
	    return topWindow;
	};
	
/**
 * 重设序号
 * @param obj
 * @returns
 */	
Ec.resetSeq = function (obj){
	var idx = 1;
	obj.find('tbody tr').each(function() {
	      var $cols = $(this).find('td'); 
	      $cols.eq(0).html(idx++);
	 });
}

Ec.iziModal = function (modalObj, opt){
	var defaultOptions={
			title: title,
		    subtitle: '',
		    headerColor: '#88A0B9',
		    background: null,
		    theme: '',  // light
		    icon: null,
		    overlayClose: false,
		    radius: 13,
		    iframe: true,
		    iframeHeight: 300,
		    iframeURL: url,
		    onFullscreen: function(){},
		    onResize: function(){},
		    onOpening: function(){},
		    onOpened: function(){},
		    onClosing: function(){},
		    onClosed: function(){},
		    afterRender: function(){}
	 }
	$.extend(defaultOptions,opt);
	modalObj.iziModal(opt);
}

//整数
Ec.isPInt = function (str) {
    var g = /^\d+$/;
    return g.test(str);
}
/**
 * 会计
 */
Ec.changePrice2money = function(s){
    s = s.toString();
    s=s.replace(/^(\d*)$/,"$1.");
    s=(s+"00").replace(/(\d*\.\d\d)\d*/,"$1");
    s=s.replace(".",",");
    var re=/(\d)(\d{3},)/;
    while(re.test(s))
        s=s.replace(re,"$1,$2");
    s=s.replace(/,(\d\d)$/,".$1");
    return s.replace(/^\./,"0.")
}

/**
 * 获取table json
 * @param tableId
 * @returns
 */
Ec.getJsonData =  function(tableId, titleArr){
	var $tab = $('#'+tableId);
	var $trs = $tab.find('tbody tr');
	var attrName = "name";
	var arrs = [];
	for (var i = 0; i < $trs.length ; i++) {
		var obj = {};
		var $input = $trs.eq(i).find('input');
		var $span = $trs.eq(i).find('span');
		var $a = $trs.eq(i).find('a');
		if($input){
			$input.each(function(){
				var name = $(this).attr(attrName);
				var val = $(this).val();
				  if (name && checkXEditableName(val, titleArr) ) {
					  obj[name] = val;
				}
			});
		}
		if($span){
			$span.each(function(){
			    var name = $(this).attr(attrName);
			    var html = $(this).html();
			    //if(!$span.hasClass('editable-empty')){
				    if (name && checkXEditableName(html, titleArr)) {
				    	obj[name] = html;
				    }
			    //}
			});
		}
		if($a){
			$a.each(function(){
			    var name = $(this).attr(attrName);
			    var html = $(this).text();
//			    if(!$a.hasClass('editable-empty')){
			    	 if (name && checkXEditableName(html, titleArr)) {
					    	obj[name] = html;
					 }
//			    }
			});
		}
		if(JSON.stringify(obj) != "{}"){
			arrs.push(obj);
		}
	}
	return arrs;
}

/**
 * 
 * @param val
 * @returns
 */
function checkXEditableName(val, titleArr){
	var flag = true;
	if ( !titleArr ) {
		return flag;
	}
	for (var i = 0; i < titleArr.length; i++) {
		if (val === titleArr[i]) {
			return false;
		}
	}
	return flag;
}

//保存js内置方法用于后面调用  
window.oldInterval = window.oldInterval?window.oldInterval:window.setInterval;  
window.oldClear = window.oldClear?window.oldClear:window.clearInterval;  
//定义数组，保存所有interval任务的ID，方便其他地方查询  
window.funcArr = window.funcArr?window.funcArr:new Array();  
window.intervalArr = window.intervalArr ? window.intervalArr : new Array(); 
//重写setInterval  
window.setInterval = function(func,timeout){  
    var ele = window.oldInterval(func,timeout);  
    //保存并返回functionID  
    window.funcArr.push(ele);  
    return ele;  
};  
//重写clearInterval  
window.clearInterval = function(funcId){  
    var index = window.funcArr.indexOf(funcId)  
    //清除保存在funcArr中的ID  
    window.funcArr = window.funcArr.splice(index,index)  
    //执行内置清除方法  
    window.oldClear(funcId)  
} 
/**
 * putInterval
 */
window.putInterval = function(id,val){
	window.intervalArr = window.intervalArr || [];
	window.intervalArr[id] = val;
}
