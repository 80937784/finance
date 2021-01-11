package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 科目管理对象 fin_subject
 *
 * @author zfx
 * @date 2021-01-11
 */
public class FinSubject extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * 主键
     */
    private String id;

    /**
     * 科目名称
     */
    @Excel(name = "科目名称")
    private String subName;

    /**
     * 科目编号
     */
    @Excel(name = "科目编号")
    private String subNum;

    /**
     * 科目类型
     */
    @Excel(name = "科目类型")
    private String subType;

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

    public void setSubName(String subName) {
        this.subName = subName;
    }

    public String getSubName() {
        return subName;
    }

    public void setSubNum(String subNum) {
        this.subNum = subNum;
    }

    public String getSubNum() {
        return subNum;
    }

    public void setSubType(String subType) {
        this.subType = subType;
    }

    public String getSubType() {
        return subType;
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
                .append("subName", getSubName())
                .append("subNum", getSubNum())
                .append("subType", getSubType())
                .append("creator", getCreator())
                .append("createTime", getCreateTime())
                .append("updator", getUpdator())
                .append("updateTime", getUpdateTime())
                .toString();
    }
}
