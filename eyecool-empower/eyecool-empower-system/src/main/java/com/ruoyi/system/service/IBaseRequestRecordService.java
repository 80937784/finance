package com.ruoyi.system.service;

import java.util.List;

import com.ruoyi.system.domain.BaseRequestRecord;

/**
 * 基础数据_接口请求报文信息Service接口
 * 
 * @author ruoyi
 * @date 2019-10-24
 */
public interface IBaseRequestRecordService 
{
    /**
     * 查询基础数据_接口请求报文信息
     * 
     * @param id 基础数据_接口请求报文信息ID
     * @return 基础数据_接口请求报文信息
     */
    public BaseRequestRecord selectBaseRequestRecordById(String id);

    /**
     * 查询基础数据_接口请求报文信息列表
     * 
     * @param baseRequestRecord 基础数据_接口请求报文信息
     * @return 基础数据_接口请求报文信息集合
     */
    public List<BaseRequestRecord> selectBaseRequestRecordList(BaseRequestRecord baseRequestRecord);

    /**
     * 新增基础数据_接口请求报文信息
     * 
     * @param baseRequestRecord 基础数据_接口请求报文信息
     * @return 结果
     */
    public int insertBaseRequestRecord(BaseRequestRecord baseRequestRecord);

    /**
     * 修改基础数据_接口请求报文信息
     * 
     * @param baseRequestRecord 基础数据_接口请求报文信息
     * @return 结果
     */
    public int updateBaseRequestRecord(BaseRequestRecord baseRequestRecord);

    /**
     * 批量删除基础数据_接口请求报文信息
     * 
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    public int deleteBaseRequestRecordByIds(String ids);

    /**
     * 删除基础数据_接口请求报文信息信息
     * 
     * @param id 基础数据_接口请求报文信息ID
     * @return 结果
     */
    public int deleteBaseRequestRecordById(String id);
}
