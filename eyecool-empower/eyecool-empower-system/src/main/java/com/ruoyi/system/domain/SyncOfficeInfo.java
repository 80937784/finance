package com.ruoyi.system.domain;

import java.util.List;

import com.alibaba.fastjson.JSON;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 组织机构对象 sync_office_info
 * 
 * @author ruoyi
 * @date 2020-02-13
 */
public class SyncOfficeInfo extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private String id;

    /** 部门名称 */
    private String officeName;

    /** 部门英文名称 */
    private String officeEn;

    /** 隶属部门号（默认是0） */
    private String parentId;

    /** 部门地址 */
    private String officeAddress;

    /** 部门联系电话 */
    private String officePhone;

    /** 部门状态（0正常 1停用） */
    private String status;

    /** 子部门节点*/
    List<SyncOfficeInfo> children;

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setOfficeName(String officeName) {
        this.officeName = officeName;
    }

    public String getOfficeName() {
        return officeName;
    }

    public void setOfficeEn(String officeEn) {
        this.officeEn = officeEn;
    }

    public String getOfficeEn() {
        return officeEn;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getParentId() {
        return parentId;
    }

    public void setOfficeAddress(String officeAddress) {
        this.officeAddress = officeAddress;
    }

    public String getOfficeAddress() {
        return officeAddress;
    }

    public void setOfficePhone(String officePhone) {
        this.officePhone = officePhone;
    }

    public String getOfficePhone() {
        return officePhone;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public List<SyncOfficeInfo> getChildren() {
        return children;
    }

    public void setChildren(List<SyncOfficeInfo> children) {
        this.children = children;
    }

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }
}
