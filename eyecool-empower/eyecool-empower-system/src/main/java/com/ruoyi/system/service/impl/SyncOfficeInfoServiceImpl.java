package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.SyncOfficeInfoMapper;
import com.ruoyi.system.domain.SyncOfficeInfo;
import com.ruoyi.system.service.ISyncOfficeInfoService;
import com.ruoyi.common.core.text.Convert;

/**
 * 组织机构Service业务层处理
 * 
 * @author ruoyi
 * @date 2020-02-13
 */
@Service
public class SyncOfficeInfoServiceImpl implements ISyncOfficeInfoService 
{
    @Autowired
    private SyncOfficeInfoMapper syncOfficeInfoMapper;

    /**
     * 查询组织机构
     * 
     * @param id 组织机构ID
     * @return 组织机构
     */
    @Override
    public SyncOfficeInfo selectSyncOfficeInfoById(String id)
    {
        return syncOfficeInfoMapper.selectSyncOfficeInfoById(id);
    }

    /**
     * 查询组织机构列表
     * 
     * @param syncOfficeInfo 组织机构
     * @return 组织机构
     */
    @Override
    public List<SyncOfficeInfo> selectSyncOfficeInfoList(SyncOfficeInfo syncOfficeInfo)
    {
        return syncOfficeInfoMapper.selectSyncOfficeInfoList(syncOfficeInfo);
    }

    /**
     * 新增组织机构
     * 
     * @param syncOfficeInfo 组织机构
     * @return 结果
     */
    @Override
    public int insertSyncOfficeInfo(SyncOfficeInfo syncOfficeInfo)
    {
        syncOfficeInfo.setCreateTime(DateUtils.getNowDate());
        return syncOfficeInfoMapper.insertSyncOfficeInfo(syncOfficeInfo);
    }

    /**
     * 修改组织机构
     * 
     * @param syncOfficeInfo 组织机构
     * @return 结果
     */
    @Override
    public int updateSyncOfficeInfo(SyncOfficeInfo syncOfficeInfo)
    {
        syncOfficeInfo.setUpdateTime(DateUtils.getNowDate());
        return syncOfficeInfoMapper.updateSyncOfficeInfo(syncOfficeInfo);
    }

    /**
     * 删除组织机构对象
     * 
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    @Override
    public int deleteSyncOfficeInfoByIds(String ids)
    {
        return syncOfficeInfoMapper.deleteSyncOfficeInfoByIds(Convert.toStrArray(ids));
    }

    /**
     * 删除组织机构信息
     * 
     * @param id 组织机构ID
     * @return 结果
     */
    @Override
    public int deleteSyncOfficeInfoById(String id)
    {
        return syncOfficeInfoMapper.deleteSyncOfficeInfoById(id);
    }
}
