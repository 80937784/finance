package com.ruoyi.system.service;

import java.util.List;

import com.ruoyi.system.domain.BaseRequestHisRecord;

/**
 * 基础数据_接口请求报文信息Service接口
 * 
 * @author ruoyi
 * @date 2019-10-24
 */
public interface IBaseRequestHisRecordService {
    /**
     * 查询基础数据_接口请求报文信息
     * 
     * @param id 基础数据_接口请求报文信息ID
     * @return 基础数据_接口请求报文信息
     */
    public BaseRequestHisRecord selectBaseRequestHisRecordById(String id);

    /**
     * 查询基础数据_接口请求报文信息列表
     * 
     * @param baseRequestHisRecord 基础数据_接口请求报文信息
     * @return 基础数据_接口请求报文信息集合
     */
    public List<BaseRequestHisRecord> selectBaseRequestHisRecordList(BaseRequestHisRecord baseRequestHisRecord);

    /**
     * 新增基础数据_接口请求报文信息
     * 
     * @param baseRequestHisRecord 基础数据_接口请求报文信息
     * @return 结果
     */
    public int insertBaseRequestHisRecord(BaseRequestHisRecord baseRequestHisRecord);

    /**
     * 修改基础数据_接口请求报文信息
     * 
     * @param baseRequestHisRecord 基础数据_接口请求报文信息
     * @return 结果
     */
    public int updateBaseRequestHisRecord(BaseRequestHisRecord baseRequestHisRecord);

    /**
     * 批量删除基础数据_接口请求报文信息
     * 
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    public int deleteBaseRequestHisRecordByIds(String ids);

    /**
     * 删除基础数据_接口请求报文信息信息
     * 
     * @param id 基础数据_接口请求报文信息ID
     * @return 结果
     */
    public int deleteBaseRequestHisRecordById(String id);
}
