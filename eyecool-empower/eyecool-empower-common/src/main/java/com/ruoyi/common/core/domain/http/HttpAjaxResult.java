package com.ruoyi.common.core.domain.http;

import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.StringUtils;

/**
 * HTTP接口状态码常量定义
 * 
 * @author admin 
 * @date 2019年11月4日
 */
public class HttpAjaxResult extends AjaxResult {

    private static final long serialVersionUID = 1L;

    public static final String HTTP_SUCC_CODE = Constants.SUCCESS;
    public static final String HTTP_ERR_CODE = Constants.FAIL;

    public HttpAjaxResult() {
        super();
    }

    public HttpAjaxResult(String code, String msg) {
        super.put(AjaxResult.CODE_TAG, code);
        super.put(AjaxResult.MSG_TAG, msg);
    }

    public HttpAjaxResult(String code, String msg, Object data) {
        super.put(CODE_TAG, code);
        super.put(MSG_TAG, msg);
        if (StringUtils.isNotNull(data)) {
            super.put(DATA_TAG, data);
        }
    }

    /**
     * 返回成功消息
     * 
     * @return
     */
    public static AjaxResult httpSuccess() {
        return new HttpAjaxResult(HTTP_SUCC_CODE, "操作成功!");
    }

    /**
     * 返回成功消息
     * 
     * @param msg
     * @param data
     * @return
     */
    public static AjaxResult httpSuccess(String msg, Object data) {
        return new HttpAjaxResult(HTTP_SUCC_CODE, msg, data);
    }

    /**
     * 返回成功消息
     * 
     * @param msg
     * @return
     */
    public static AjaxResult httpSuccess(String msg) {
        return new HttpAjaxResult(HTTP_SUCC_CODE, msg);
    }

    /**
     * 返回成功消息
     * 
     * @param data
     * @return
     */
    public static AjaxResult httpSuccess(Object data) {
        return new HttpAjaxResult(HTTP_SUCC_CODE, "操作成功!", data);
    }

    /**
     * 返回错误消息
     * 
     * @return
     */
    public static AjaxResult httpError() {
        return new HttpAjaxResult(HTTP_ERR_CODE, "操作失败!");
    }

    /**
     * 返回错误消息
     * 
     * @param msg
     * @return
     */
    public static AjaxResult httpError(String msg) {
        return new HttpAjaxResult(HTTP_ERR_CODE, msg);
    }

    /**
     * 返回错误信息
     * 
     * @param msg
     * @param data
     * @return
     */
    public static AjaxResult httpError(String msg, Object data) {
        return new HttpAjaxResult(HTTP_ERR_CODE, msg, data);
    }

    /**
     * 返回错误消息
     * 
     * @param data
     * @return
     */
    public static AjaxResult httpError(Object data) {
        return new HttpAjaxResult(HTTP_ERR_CODE, "操作失败", data);
    }

    /**
     * 返回错误消息
     * 
     * @param code
     * @param msg
     * @return
     */
    public static AjaxResult httpError(String code, String msg) {
        return new HttpAjaxResult(code, msg);
    }

    /**
     * 返回错误消息
     * 
     * @param code
     * @param msg
     * @param data
     * @return
     */
    public static AjaxResult httpError(String code, String msg, Object data) {
        return new HttpAjaxResult(code, msg, data);
    }

    /**
     * 返回公共参数校验错误
     * 
     * @param msg
     * @return
     */
    public static AjaxResult globalValidError(String msg) {
        return httpError("1001", msg);
    }

    /**
     * 时间戳校验错误
     * 
     * @param msg
     * @return
     */
    public static AjaxResult timestampValidError() {
        String msg = "请求时间戳[timestamp]范围无效，服务器当前时间[" + System.currentTimeMillis() + "]";
        return globalValidError(msg);
    }

    /**
     * 重复请求错误
     * 
     * @param msg
     * @return
     */
    public static AjaxResult nonceRepeatError() {
        String msg = "重复请求，请求唯一码[nonce]无效";
        return httpError("1002", msg);
    }

    /**
     * 应用系统不存在错误
     * 
     * @param msg
     * @return
     */
    public static AjaxResult appKeyNotExistsError() {
        String msg = "应用系统[appKey]不存在";
        return httpError("1003", msg);
    }

    /**
     * 请求接口不存在错误
     * 
     * @param msg
     * @return
     */
    public static AjaxResult transCodeNotExistsError(String transCode) {
        String msg = "请求接口交易码[" + transCode + "]对应接口不存在";
        return httpError("1004", msg);
    }

    /**
     * 签名验证不通过
     * 
     * @param msg
     * @return
     */
    public static AjaxResult signIllegalError() {
        String msg = "签名验证不通过";
        return httpError("1005", msg);
    }

    /**
     * 没有接口访问权限
     * 
     * @param msg
     * @return
     */
    public static AjaxResult interfaceAuthFailedError(String transCode) {
        String msg = "没有接口[" + transCode + "]访问权限";
        return httpError("1006", msg);
    }

    /**
     * 接口访问权限过期
     * 
     * @param msg
     * @return
     */
    public static AjaxResult interfaceAuthExpireError(String transCode) {
        String msg = "接口[" + transCode + "]访问权限已过期";
        return httpError("1006", msg);
    }

    /**
     * 业务数据校验错误
     * 
     * @param msg
     * @return
     */
    public static AjaxResult businessDataValidError(String msg) {
        return httpError("1100", msg);
    }

    /**
     * 系统繁忙
     * 
     * @param msg
     * @return
     */
    public static AjaxResult systemBusyError() {
        return httpError("-1", "系统繁忙，请稍后再试");
    }

    /**
     * 系统繁忙
     * 
     * @param msg
     * @return
     */
    public static AjaxResult systemBusyError(String msg) {
        return httpError("-1", msg);
    }

    /**
     * 业务错误
     * 
     * @param msg
     * @return
     */
    public static AjaxResult businessError(String msg) {
        return httpError("1101", msg);
    }

}
