package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ruoyi.common.core.text.Convert;
import com.ruoyi.system.domain.BaseRequestRecord;
import com.ruoyi.system.mapper.BaseRequestRecordMapper;
import com.ruoyi.system.service.IBaseRequestRecordService;

/**
 * 基础数据_接口请求报文信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2019-10-24
 */
@Service
public class BaseRequestRecordServiceImpl implements IBaseRequestRecordService 
{
    @Autowired
    private BaseRequestRecordMapper baseRequestRecordMapper;

    /**
     * 查询基础数据_接口请求报文信息
     * 
     * @param id 基础数据_接口请求报文信息ID
     * @return 基础数据_接口请求报文信息
     */
    @Override
    public BaseRequestRecord selectBaseRequestRecordById(String id)
    {
        return baseRequestRecordMapper.selectBaseRequestRecordById(id);
    }

    /**
     * 查询基础数据_接口请求报文信息列表
     * 
     * @param baseRequestRecord 基础数据_接口请求报文信息
     * @return 基础数据_接口请求报文信息
     */
    @Override
    public List<BaseRequestRecord> selectBaseRequestRecordList(BaseRequestRecord baseRequestRecord)
    {
        return baseRequestRecordMapper.selectBaseRequestRecordList(baseRequestRecord);
    }

    /**
     * 新增基础数据_接口请求报文信息
     * 
     * @param baseRequestRecord 基础数据_接口请求报文信息
     * @return 结果
     */
    @Override
    public int insertBaseRequestRecord(BaseRequestRecord baseRequestRecord)
    {
        return baseRequestRecordMapper.insertBaseRequestRecord(baseRequestRecord);
    }

    /**
     * 修改基础数据_接口请求报文信息
     * 
     * @param baseRequestRecord 基础数据_接口请求报文信息
     * @return 结果
     */
    @Override
    public int updateBaseRequestRecord(BaseRequestRecord baseRequestRecord)
    {
        return baseRequestRecordMapper.updateBaseRequestRecord(baseRequestRecord);
    }

    /**
     * 删除基础数据_接口请求报文信息对象
     * 
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    @Override
    public int deleteBaseRequestRecordByIds(String ids)
    {
        return baseRequestRecordMapper.deleteBaseRequestRecordByIds(Convert.toStrArray(ids));
    }

    /**
     * 删除基础数据_接口请求报文信息信息
     * 
     * @param id 基础数据_接口请求报文信息ID
     * @return 结果
     */
    @Override
    public int deleteBaseRequestRecordById(String id)
    {
        return baseRequestRecordMapper.deleteBaseRequestRecordById(id);
    }
}
