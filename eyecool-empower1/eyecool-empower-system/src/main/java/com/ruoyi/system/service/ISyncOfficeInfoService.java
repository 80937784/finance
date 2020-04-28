package com.ruoyi.system.service;

import com.ruoyi.system.domain.SyncOfficeInfo;
import java.util.List;

/**
 * 组织机构Service接口
 * 
 * @author ruoyi
 * @date 2020-02-13
 */
public interface ISyncOfficeInfoService 
{
    /**
     * 查询组织机构
     * 
     * @param id 组织机构ID
     * @return 组织机构
     */
    public SyncOfficeInfo selectSyncOfficeInfoById(String id);

    /**
     * 查询组织机构列表
     * 
     * @param syncOfficeInfo 组织机构
     * @return 组织机构集合
     */
    public List<SyncOfficeInfo> selectSyncOfficeInfoList(SyncOfficeInfo syncOfficeInfo);

    /**
     * 新增组织机构
     * 
     * @param syncOfficeInfo 组织机构
     * @return 结果
     */
    public int insertSyncOfficeInfo(SyncOfficeInfo syncOfficeInfo);

    /**
     * 修改组织机构
     * 
     * @param syncOfficeInfo 组织机构
     * @return 结果
     */
    public int updateSyncOfficeInfo(SyncOfficeInfo syncOfficeInfo);

    /**
     * 批量删除组织机构
     * 
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    public int deleteSyncOfficeInfoByIds(String ids);

    /**
     * 删除组织机构信息
     * 
     * @param id 组织机构ID
     * @return 结果
     */
    public int deleteSyncOfficeInfoById(String id);
}
