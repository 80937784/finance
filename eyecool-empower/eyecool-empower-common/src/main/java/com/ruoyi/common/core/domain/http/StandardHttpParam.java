package com.ruoyi.common.core.domain.http;

import java.io.Serializable;

import javax.validation.constraints.NotBlank;

import org.hibernate.validator.constraints.Length;

import com.alibaba.fastjson.JSON;

/**
 * 标准HTTP请求参数Bean.
 * 
 * @author admin 
 * @date 2019年11月4日
 */
public class StandardHttpParam implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 应用唯一标识*/
    @NotBlank(message = "应用标识[appKey]不能为空")
    @Length(min = 8, max = 8, message = "应用标识[appKey]长度不合法，必须为8位")
    private String appKey;

    /** 请求签名(防止篡改)*/
    @NotBlank(message = "请求签名[sign]不能为空")
    private String sign;

    /** 请求时间戳(和nonce配合，确保请求的唯一性,防止重放攻击)*/
    @NotBlank(message = "请求时间戳[timestamp]不能为空")
    @Length(min = 13, max = 13, message = "请求时间戳[timestamp]长度不合法，必须为13位数字")
    private String timestamp;

    /** 请求唯一标识*/
    @NotBlank(message = "请求唯一标识[nonce]不能为空")
    @Length(max = 48, message = "请求唯一标识[nonce]长度不合法，最大支持48位")
    private String nonce;

    /** 接口交易码*/
    @NotBlank(message = "请求接口交易码[transCode]不能为空")
    @Length(max = 48, message = "请求接口交易码[transCode]长度不合法，最大支持48位")
    private String transCode;

    /** 接口请求参数的集合*/
    @NotBlank(message = "请求参数集合[bizContent]不能为空")
    private String bizContent;

    public String getAppKey() {
        return appKey;
    }

    public void setAppKey(String appKey) {
        this.appKey = appKey;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getNonce() {
        return nonce;
    }

    public void setNonce(String nonce) {
        this.nonce = nonce;
    }

    public String getTransCode() {
        return transCode;
    }

    public void setTransCode(String transCode) {
        this.transCode = transCode;
    }

    public String getBizContent() {
        return bizContent;
    }

    public void setBizContent(String bizContent) {
        this.bizContent = bizContent;
    }

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }

}
