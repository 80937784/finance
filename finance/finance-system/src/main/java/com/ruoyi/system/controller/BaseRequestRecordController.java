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
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.BaseRequestRecord;
import com.ruoyi.system.service.IBaseRequestRecordService;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 基础数据_接口请求报文信息Controller
 * 
 * @author ruoyi
 * @date 2019-10-24
 */
@Controller
@RequestMapping("/system/record")
public class BaseRequestRecordController extends BaseController
{
    private String prefix = "system/record";

    @Autowired
    private IBaseRequestRecordService baseRequestRecordService;

    @RequiresPermissions("system:record:view")
    @GetMapping()
    public String record()
    {
        return prefix + "/record";
    }

    /**
     * 查询基础数据_接口请求报文信息列表
     */
    @RequiresPermissions("system:record:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(BaseRequestRecord baseRequestRecord)
    {
        startPage();
        List<BaseRequestRecord> list = baseRequestRecordService.selectBaseRequestRecordList(baseRequestRecord);
        return getDataTable(list);
    }

    /**
     * 导出基础数据_接口请求报文信息列表
     */
    @RequiresPermissions("system:record:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(BaseRequestRecord baseRequestRecord)
    {
        List<BaseRequestRecord> list = baseRequestRecordService.selectBaseRequestRecordList(baseRequestRecord);
        ExcelUtil<BaseRequestRecord> util = new ExcelUtil<BaseRequestRecord>(BaseRequestRecord.class);
        return util.exportExcel(list, "record");
    }

    /**
     * 新增基础数据_接口请求报文信息
     */
    @GetMapping("/add")
    public String add()
    {
        return prefix + "/add";
    }

    /**
     * 新增保存基础数据_接口请求报文信息
     */
    @RequiresPermissions("system:record:add")
    @Log(title = "基础数据_接口请求报文信息", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(BaseRequestRecord baseRequestRecord)
    {
        return toAjax(baseRequestRecordService.insertBaseRequestRecord(baseRequestRecord));
    }

    /**
     * 修改基础数据_接口请求报文信息
     */
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") String id, ModelMap mmap)
    {
        BaseRequestRecord baseRequestRecord = baseRequestRecordService.selectBaseRequestRecordById(id);
        mmap.put("baseRequestRecord", baseRequestRecord);
        return prefix + "/edit";
    }

    /**
     * 修改保存基础数据_接口请求报文信息
     */
    @RequiresPermissions("system:record:edit")
    @Log(title = "基础数据_接口请求报文信息", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(BaseRequestRecord baseRequestRecord)
    {
        return toAjax(baseRequestRecordService.updateBaseRequestRecord(baseRequestRecord));
    }

    /**
     * 删除基础数据_接口请求报文信息
     */
    @RequiresPermissions("system:record:remove")
    @Log(title = "基础数据_接口请求报文信息", businessType = BusinessType.DELETE)
    @PostMapping( "/remove")
    @ResponseBody
    public AjaxResult remove(String ids)
    {
        return toAjax(baseRequestRecordService.deleteBaseRequestRecordByIds(ids));
    }

    @RequiresPermissions("system:record:detail")
    @GetMapping("/detail/{recordId}")
    public String detail(@PathVariable("recordId") String recordId, ModelMap mmap) {
        mmap.put("name", "record");
        mmap.put("record", baseRequestRecordService.selectBaseRequestRecordById(recordId));
        return prefix + "/detail";
    }
}
