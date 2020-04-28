package com.ruoyi.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ruoyi.common.core.text.Convert;
import com.ruoyi.system.domain.BaseRequestHisRecord;
import com.ruoyi.system.mapper.BaseRequestHisRecordMapper;
import com.ruoyi.system.service.IBaseRequestHisRecordService;

/**
 * 基础数据_接口请求报文信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2019-10-24
 */
@Service
public class BaseRequestHisRecordServiceImpl implements IBaseRequestHisRecordService {
    @Autowired
    private BaseRequestHisRecordMapper baseRequestHisRecordMapper;

    /**
     * 查询基础数据_接口请求报文信息
     * 
     * @param id 基础数据_接口请求报文信息ID
     * @return 基础数据_接口请求报文信息
     */
    @Override
    public BaseRequestHisRecord selectBaseRequestHisRecordById(String id) {
        return baseRequestHisRecordMapper.selectBaseRequestHisRecordById(id);
    }

    /**
     * 查询基础数据_接口请求报文信息列表
     * 
     * @param baseRequestHisRecord 基础数据_接口请求报文信息
     * @return 基础数据_接口请求报文信息
     */
    @Override
    public List<BaseRequestHisRecord> selectBaseRequestHisRecordList(BaseRequestHisRecord baseRequestHisRecord) {
        return baseRequestHisRecordMapper.selectBaseRequestHisRecordList(baseRequestHisRecord);
    }

    /**
     * 新增基础数据_接口请求报文信息
     * 
     * @param baseRequestHisRecord 基础数据_接口请求报文信息
     * @return 结果
     */
    @Override
    public int insertBaseRequestHisRecord(BaseRequestHisRecord baseRequestHisRecord) {
        return baseRequestHisRecordMapper.insertBaseRequestHisRecord(baseRequestHisRecord);
    }

    /**
     * 修改基础数据_接口请求报文信息
     * 
     * @param baseRequestHisRecord 基础数据_接口请求报文信息
     * @return 结果
     */
    @Override
    public int updateBaseRequestHisRecord(BaseRequestHisRecord baseRequestHisRecord) {
        return baseRequestHisRecordMapper.updateBaseRequestHisRecord(baseRequestHisRecord);
    }

    /**
     * 删除基础数据_接口请求报文信息对象
     * 
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    @Override
    public int deleteBaseRequestHisRecordByIds(String ids) {
        return baseRequestHisRecordMapper.deleteBaseRequestHisRecordByIds(Convert.toStrArray(ids));
    }

    /**
     * 删除基础数据_接口请求报文信息信息
     * 
     * @param id 基础数据_接口请求报文信息ID
     * @return 结果
     */
    @Override
    public int deleteBaseRequestHisRecordById(String id) {
        return baseRequestHisRecordMapper.deleteBaseRequestHisRecordById(id);
    }
}
