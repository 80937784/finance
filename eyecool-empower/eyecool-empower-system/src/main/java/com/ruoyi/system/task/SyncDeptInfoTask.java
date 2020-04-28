package com.ruoyi.system.task;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ruoyi.system.domain.SyncOfficeInfo;
import com.ruoyi.system.domain.SysDept;
import com.ruoyi.system.mapper.SyncOfficeInfoMapper;
import com.ruoyi.system.mapper.SysDeptMapper;

/**
 * 同步部门信息定时任务
 * 
 * @author mawenjun 
 * @version 1.0
 * @date 2020年2月13日 
 *
 */
@Component("syncDeptInfoTask")
public class SyncDeptInfoTask {

    private static final Logger LOG = LoggerFactory.getLogger(SyncDeptInfoTask.class);

    @Autowired
    private SysDeptMapper sysDeptMapper;
    @Autowired
    private SyncOfficeInfoMapper syncOfficeInfoMapper;

    /**
     * 执行同步
     * 
     * @author mawenjun    
     * @date 2020年2月13日 
     *
     */
    public void executeSync() {
        long start = System.currentTimeMillis();
        // 从中间表中，查询下所有的组织机构(树形)
        List<SyncOfficeInfo> officeInfoList = officeTreeInfo("0");
        if (CollectionUtils.isEmpty(officeInfoList)) {
            LOG.warn("同步组织机构，组织机构中间表数据为空！");
            return;
        }
        // 查询所有的组织机构（数据量不大）
        List<SysDept> deptList = sysDeptMapper.selectDeptList(new SysDept());
        // Map(部门编码:部门信息)
        Map<String, SysDept> deptCodeMap = new HashMap<String, SysDept>();
        // Map(parentId:maxOrderNum)
        Map<Long, String> orderNumMap = new HashMap<Long, String>();
        for (SysDept it : deptList) {
            // 设置部门编码为key值的部门信息Map
            if (it.getParentId() == 0L) {
                deptCodeMap.put(null, it);// 顶级部门可能code不存在，设置key为null(hashMap只能有一个key为null)
            } else if (StringUtils.isNotBlank(it.getDeptCode())) {
                deptCodeMap.put(it.getDeptCode(), it);
            }
            String orderNum = it.getOrderNum();
            if (StringUtils.isBlank(orderNum)) {
                continue;
            }
            String maxorderNum = orderNumMap.get(it.getParentId());
            maxorderNum = StringUtils.isBlank(maxorderNum) ? orderNum : String.valueOf(Math.max(Integer.valueOf(maxorderNum), Integer.valueOf(orderNum)));
            orderNumMap.put(it.getParentId(), maxorderNum);
        }
        saveDeptInfo(officeInfoList, deptCodeMap, orderNumMap);
        long end = System.currentTimeMillis();
        LOG.info("组织机构同步，共花费时间：" + (end - start));
    }

    /**
     * 递归保存部门信息
     * 
     * @author mawenjun
     * @param officeInfoList
     * @param deptCodeMap
     * @param orderNumMap 
     * @date 2020年2月13日 
     *
     */
    private void saveDeptInfo(List<SyncOfficeInfo> officeInfoList, Map<String, SysDept> deptCodeMap, Map<Long, String> orderNumMap) {
        officeInfoList.forEach(item -> {
            String deptCode = item.getId();
            String parentCode = item.getParentId();
            // 从部门表查询部门信息
            SysDept dept = deptCodeMap.get(deptCode);
            SysDept parentDept = deptCodeMap.get(parentCode);
            if ("0".equals(parentCode)) {// 顶级部门
                dept = deptCodeMap.get(null);
            }
            boolean isInsert = false;
            if (null == dept) {// 部门不存在，直接新增,主键自增
                dept = new SysDept();
                dept.setCreateTime(new Date());
                isInsert = true;
            }
            dept.setDeptCode(deptCode);
            dept.setParentId(null == parentDept ? 0L : parentDept.getDeptId());
            dept.setDeptName(item.getOfficeName());
            dept.setPhone(item.getOfficePhone());
            dept.setStatus(item.getStatus());
            dept.setDelFlag("0");
            dept.setUpdateTime(new Date());
            // 设置排序
            String maxOrderNum = orderNumMap.get(dept.getParentId());
            maxOrderNum = StringUtils.isBlank(maxOrderNum) ? "1" : String.valueOf(Integer.valueOf(maxOrderNum) + 1);
            dept.setOrderNum(maxOrderNum);
            // 设置祖级别列表
            dept.setAncestors(null == parentDept ? "0" : parentDept.getAncestors() + "," + parentDept.getDeptId());
            if (isInsert) {
                sysDeptMapper.insertDept(dept);
            } else {
                sysDeptMapper.updateDept(dept);
            }
            deptCodeMap.put(deptCode, dept);// key相同，value值会直接替换
            orderNumMap.put(dept.getParentId(), maxOrderNum);
            if (CollectionUtils.isNotEmpty(item.getChildren())) {
                saveDeptInfo(item.getChildren(), deptCodeMap, orderNumMap);
            }
        });
    }

    /**
     * 查询组织机构中间表树形结构
     * 
     * @author mawenjun
     * @param parentId
     * @return    
     * @date 2020年2月13日 
     *
     */
    private List<SyncOfficeInfo> officeTreeInfo(String parentId) {
        SyncOfficeInfo info = new SyncOfficeInfo();
        info.setParentId(parentId);
        List<SyncOfficeInfo> officeList = syncOfficeInfoMapper.selectSyncOfficeInfoList(info);
        officeList.stream().forEach(it -> {
            it.setChildren(officeTreeInfo(it.getId()));
        });
        return officeList;
    }

}
