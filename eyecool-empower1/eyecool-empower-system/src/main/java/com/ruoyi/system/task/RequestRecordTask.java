package com.ruoyi.system.task;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.Sets;
import com.ruoyi.common.constant.DatabaseTypeConstants;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.common.utils.sql.SqlUtil;
import com.ruoyi.system.domain.BaseRequestHisRecord;
import com.ruoyi.system.domain.BaseRequestRecord;
import com.ruoyi.system.mapper.BaseRequestHisRecordMapper;
import com.ruoyi.system.mapper.BaseRequestRecordMapper;

/**
 * 清空接口报文历史表分区定时任务
 * 
 * @author admin 
 * @date 2020年4月10日
 */
@Component("requestRecordTask")
public class RequestRecordTask {

    private static final Logger LOG = LoggerFactory.getLogger(RequestRecordTask.class);

    @Autowired
    private BaseRequestHisRecordMapper baseRequestHisRecordMapper;
    @Autowired
    private BaseRequestRecordMapper baseRequestRecordMapper;
    @Value("${mybatis.configuration.database-id}")
    private String databaseId;

    /**
     * 新增分区，并删除过期分区，分区按天划分
     * 
     * @param schenaName
     * @param offsetDay
     */
    public void clearAndAddPartition(String schemaName, Integer offsetDay) {
        if (offsetDay < 3) {
            LOG.error("保留天数{}设置不合理，至少保留三天的报文信息，默认执行保留3天", offsetDay);
            offsetDay = 3;
        }
        String tableName = "base_request_his_record";
        if (DatabaseTypeConstants.DB_MYSQL.equals(databaseId) || DatabaseTypeConstants.DB_ORACLE.equals(databaseId)) {
            baseRequestHisRecordMapper.addPartition(schemaName, tableName, -2);
            baseRequestHisRecordMapper.addPartition(schemaName, tableName, -1);
            baseRequestHisRecordMapper.addPartition(schemaName, tableName, 0);
            baseRequestHisRecordMapper.addPartition(schemaName, tableName, 1);
            baseRequestHisRecordMapper.addPartition(schemaName, tableName, 2);
        } else if (DatabaseTypeConstants.DB_PG.equals(databaseId)) {
            tableName = tableName + "_" + DateUtils.parseDateToStr("yyyyMMdd", DateUtils.addDays(new Date(), -(offsetDay + 1)));
        }
        baseRequestHisRecordMapper.dropPartition(schemaName, tableName, offsetDay);
    }

    /**
     * 迁移接口报文日志
     */
    public void migrateRequestRecord() {
        long total = 0; // 数据总量
        int pageNum = 1;// 分页
        int pageSize = 100;// 分页数量
        String orderBy = SqlUtil.escapeOrderBySql("received_time");
        // 序列号原子对象
        final AtomicInteger successNum = new AtomicInteger(0);// 迁移成功数量原子对象
        Set<String> failList = Sets.newTreeSet();
        Date todayStartTime = DateUtils.truncate(new Date(), Calendar.DATE);
        boolean isEnd = false;
        RequestRecordTask proxyObj = (RequestRecordTask) AopContext.currentProxy();
        do {
            // pageNum一直是第一页，因为中间涉及到删除,分页一直查询第一页就可以
            PageHelper.startPage(pageNum, pageSize, orderBy);
            // 查询消息日志
            List<BaseRequestRecord> recordList = baseRequestRecordMapper.selectBaseRequestRecordList(new BaseRequestRecord());
            for (BaseRequestRecord record : recordList) {
                try {
                    Date receivedTime = record.getReceivedTime();
                    isEnd = isEnd || (null != receivedTime && receivedTime.compareTo(todayStartTime) >= 0);
                    if (null == receivedTime || receivedTime.compareTo(todayStartTime) < 0) {
                        proxyObj.migrateSingleRecord(record);
                        successNum.getAndIncrement();
                    }
                } catch (Exception e) {
                    LOG.error("接口报文信息迁移异常:{}, recordId:{}", e.getMessage(), record.getId(), e);
                    failList.add(record.getId());
                }
            }
            total = new PageInfo<BaseRequestRecord>(recordList).getTotal();
        } while (!isEnd && total > pageNum * pageSize);
        String msg = "共有" + successNum.get() + "条接口报文信息日志迁移成功," + failList.size() + "条接口报文信息日志迁移失败!";
        LOG.info(msg);
    }

    /**
     * 迁移单条消息日志
     * 
     * @param log
     */
    @Transactional
    public void migrateSingleRecord(BaseRequestRecord record) {
        BaseRequestHisRecord hisRecord = new BaseRequestHisRecord();
        BeanUtils.copyBeanProp(hisRecord, record);
        baseRequestHisRecordMapper.insertBaseRequestHisRecord(hisRecord);
        baseRequestRecordMapper.deleteBaseRequestRecordById(record.getId());
    }

}
