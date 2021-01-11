package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 凭证管理对象 fin_voucher
 *
 * @author zfx
 * @date 2021-01-11
 */
public class FinVoucher extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * 主键
     */
    private String id;

    /**
     * 凭证编号
     */
    @Excel(name = "凭证编号")
    private String voucherNum;

    /**
     * 借方金额
     */
    @Excel(name = "借方金额")
    private Long debitAmount;

    /**
     * 贷方金额
     */
    @Excel(name = "贷方金额")
    private Long creditAmount;

    /**
     * 科目id
     */
    @Excel(name = "科目id")
    private String subjectId;

    /**
     * 凭证日期
     */
    @Excel(name = "凭证日期")
    private String vouDate;

    /**
     * 摘要
     */
    @Excel(name = "摘要")
    private String summary;

    /**
     * 凭证属性
     */
    @Excel(name = "凭证属性")
    private String vouType;

    /**
     * 业务类型
     */
    private String busType;

    /**
     * 创建人
     */
    private String creator;

    /**
     * 更新人
     */
    private String updator;

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setVoucherNum(String voucherNum) {
        this.voucherNum = voucherNum;
    }

    public String getVoucherNum() {
        return voucherNum;
    }

    public void setDebitAmount(Long debitAmount) {
        this.debitAmount = debitAmount;
    }

    public Long getDebitAmount() {
        return debitAmount;
    }

    public void setCreditAmount(Long creditAmount) {
        this.creditAmount = creditAmount;
    }

    public Long getCreditAmount() {
        return creditAmount;
    }

    public void setSubjectId(String subjectId) {
        this.subjectId = subjectId;
    }

    public String getSubjectId() {
        return subjectId;
    }

    public void setVouDate(String vouDate) {
        this.vouDate = vouDate;
    }

    public String getVouDate() {
        return vouDate;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getSummary() {
        return summary;
    }

    public void setVouType(String vouType) {
        this.vouType = vouType;
    }

    public String getVouType() {
        return vouType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public String getBusType() {
        return busType;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    public String getCreator() {
        return creator;
    }

    public void setUpdator(String updator) {
        this.updator = updator;
    }

    public String getUpdator() {
        return updator;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("voucherNum", getVoucherNum())
                .append("debitAmount", getDebitAmount())
                .append("creditAmount", getCreditAmount())
                .append("subjectId", getSubjectId())
                .append("vouDate", getVouDate())
                .append("summary", getSummary())
                .append("vouType", getVouType())
                .append("busType", getBusType())
                .append("creator", getCreator())
                .append("createTime", getCreateTime())
                .append("updator", getUpdator())
                .append("updateTime", getUpdateTime())
                .toString();
    }
}
