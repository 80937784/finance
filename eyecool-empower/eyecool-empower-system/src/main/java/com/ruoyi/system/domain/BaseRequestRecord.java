package com.ruoyi.system.domain;

import java.util.Date;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 基础数据_接口请求报文信息对象 base_request_record
 * 
 * @author ruoyi
 * @date 2019-10-24
 */
public class BaseRequestRecord extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private String id;

    /** 交易码 */
    @Excel(name = "交易码")
    private String transCode;

    /** 交易标题 */
    @Excel(name = "交易标题")
    private String transTitle;

    /** 请求时间 */
    @Excel(name = "请求时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date receivedTime;

    /** 请求报文 */
    @Excel(name = "请求报文")
    private String requestMsg;

    /** 客户端IP */
    @Excel(name = "客户端IP")
    private String clientIp;

    /** 响应时间 */
    @Excel(name = "响应时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date sendTime;

    /** 响应报文 */
    @Excel(name = "响应报文")
    private String responseMsg;

    /** 耗时(ms) */
    @Excel(name = "耗时(ms)")
    private Long timeUsed;

    /** 状态码 */
    @Excel(name = "状态码")
    private String statusCode;

    /** 交易请求路径 */
    @Excel(name = "交易请求路径")
    private String transUrl;

    /** 处理方法 */
    @Excel(name = "处理方法")
    private String classMethod;

    /** 渠道编码*/
    @Excel(name = "渠道编码")
    private String channelCode;

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setTransCode(String transCode) {
        this.transCode = transCode;
    }

    public String getTransCode() {
        return transCode;
    }

    public void setTransTitle(String transTitle) {
        this.transTitle = transTitle;
    }

    public String getTransTitle() {
        return transTitle;
    }

    public void setReceivedTime(Date receivedTime) {
        this.receivedTime = receivedTime;
    }

    public Date getReceivedTime() {
        return receivedTime;
    }

    public void setRequestMsg(String requestMsg) {
        this.requestMsg = requestMsg;
    }

    public String getRequestMsg() {
        return requestMsg;
    }

    public void setClientIp(String clientIp) {
        this.clientIp = clientIp;
    }

    public String getClientIp() {
        return clientIp;
    }

    public void setSendTime(Date sendTime) {
        this.sendTime = sendTime;
    }

    public Date getSendTime() {
        return sendTime;
    }

    public void setResponseMsg(String responseMsg) {
        this.responseMsg = responseMsg;
    }

    public String getResponseMsg() {
        return responseMsg;
    }

    public void setTimeUsed(Long timeUsed) {
        this.timeUsed = timeUsed;
    }

    public Long getTimeUsed() {
        return timeUsed;
    }

    public void setStatusCode(String statusCode) {
        this.statusCode = statusCode;
    }

    public String getStatusCode() {
        return statusCode;
    }

    public void setTransUrl(String transUrl) {
        this.transUrl = transUrl;
    }

    public String getTransUrl() {
        return transUrl;
    }

    public void setClassMethod(String classMethod) {
        this.classMethod = classMethod;
    }

    public String getClassMethod() {
        return classMethod;
    }

    public String getChannelCode() {
        return channelCode;
    }

    public void setChannelCode(String channelCode) {
        this.channelCode = channelCode;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE).append("id", getId()).append("transCode", getTransCode()).append("transTitle", getTransTitle())
                .append("receivedTime", getReceivedTime()).append("requestMsg", getRequestMsg()).append("clientIp", getClientIp()).append("sendTime", getSendTime())
                .append("responseMsg", getResponseMsg()).append("timeUsed", getTimeUsed()).append("statusCode", getStatusCode()).append("transUrl", getTransUrl())
                .append("classMethod", getClassMethod()).toString();
    }
}
