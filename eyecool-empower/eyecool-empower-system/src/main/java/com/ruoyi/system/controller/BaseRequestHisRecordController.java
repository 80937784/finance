package com.ruoyi.system.controller;

import java.util.List;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.BaseRequestHisRecord;
import com.ruoyi.system.service.IBaseRequestHisRecordService;

/**
 * 基础数据_接口请求历史报文信息Controller
 * 
 * @author ruoyi
 * @date 2019-10-24
 */
@Controller
@RequestMapping("/system/hisrecord")
public class BaseRequestHisRecordController extends BaseController {
    private String prefix = "system/hisrecord";

    @Autowired
    private IBaseRequestHisRecordService baseRequestHisRecordService;

    @RequiresPermissions("system:hisrecord:view")
    @GetMapping()
    public String record() {
        return prefix + "/record";
    }

    /**
     * 查询基础数据_接口请求历史报文信息列表
     */
    @RequiresPermissions("system:hisrecord:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(BaseRequestHisRecord baseRequestHisRecord) {
        startPage();
        List<BaseRequestHisRecord> list = baseRequestHisRecordService.selectBaseRequestHisRecordList(baseRequestHisRecord);
        return getDataTable(list);
    }

    /**
     * 导出基础数据_接口请求历史报文信息列表
     */
    @RequiresPermissions("system:hisrecord:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(BaseRequestHisRecord baseRequestHisRecord) {
        List<BaseRequestHisRecord> list = baseRequestHisRecordService.selectBaseRequestHisRecordList(baseRequestHisRecord);
        ExcelUtil<BaseRequestHisRecord> util = new ExcelUtil<BaseRequestHisRecord>(BaseRequestHisRecord.class);
        return util.exportExcel(list, "record");
    }

    /**
     * 新增基础数据_接口请求历史报文信息
     */
    @GetMapping("/add")
    public String add() {
        return prefix + "/add";
    }

    /**
     * 新增保存基础数据_接口请求历史报文信息
     */
    @RequiresPermissions("system:hisrecord:add")
    @Log(title = "基础数据_接口请求历史报文信息", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(BaseRequestHisRecord baseRequestHisRecord) {
        return toAjax(baseRequestHisRecordService.insertBaseRequestHisRecord(baseRequestHisRecord));
    }

    /**
     * 修改基础数据_接口请求历史报文信息
     */
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") String id, ModelMap mmap) {
        BaseRequestHisRecord baseRequestHisRecord = baseRequestHisRecordService.selectBaseRequestHisRecordById(id);
        mmap.put("baseRequestHisRecord", baseRequestHisRecord);
        return prefix + "/edit";
    }

    /**
     * 修改保存基础数据_接口请求历史报文信息
     */
    @RequiresPermissions("system:hisrecord:edit")
    @Log(title = "基础数据_接口请求历史报文信息", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(BaseRequestHisRecord baseRequestHisRecord) {
        return toAjax(baseRequestHisRecordService.updateBaseRequestHisRecord(baseRequestHisRecord));
    }

    /**
     * 删除基础数据_接口请求历史报文信息
     */
    @RequiresPermissions("system:hisrecord:remove")
    @Log(title = "基础数据_接口请求历史报文信息", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids) {
        return toAjax(baseRequestHisRecordService.deleteBaseRequestHisRecordByIds(ids));
    }

    /**
     * 详情
     * 
     * @param recordId
     * @param mmap
     * @return
     */
    @RequiresPermissions("system:hisrecord:detail")
    @GetMapping("/detail/{recordId}")
    public String detail(@PathVariable("recordId") String recordId, ModelMap mmap) {
        mmap.put("name", "record");
        mmap.put("record", baseRequestHisRecordService.selectBaseRequestHisRecordById(recordId));
        return prefix + "/detail";
    }
}
