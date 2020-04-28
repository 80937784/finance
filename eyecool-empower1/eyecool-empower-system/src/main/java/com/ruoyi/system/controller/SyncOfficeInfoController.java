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
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SyncOfficeInfo;
import com.ruoyi.system.service.ISyncOfficeInfoService;

/**
 * 组织机构Controller
 * 
 * @author ruoyi
 * @date 2020-02-13
 */
@Controller
@RequestMapping("/system/office")
public class SyncOfficeInfoController extends BaseController {
    private String prefix = "system/office";

    @Autowired
    private ISyncOfficeInfoService syncOfficeInfoService;

    @RequiresPermissions("system:office:view")
    @GetMapping()
    public String office() {
        return prefix + "/office";
    }

    /**
     * 查询组织机构列表
     */
    @RequiresPermissions("system:office:list")
    @PostMapping("/list")
    @ResponseBody
    public List<SyncOfficeInfo> list(SyncOfficeInfo syncOfficeInfo) {
        List<SyncOfficeInfo> list = syncOfficeInfoService.selectSyncOfficeInfoList(syncOfficeInfo);
        return list;
    }

    /**
     * 导出组织机构列表
     */
    @RequiresPermissions("system:office:export")
    @Log(title = "组织机构", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(SyncOfficeInfo syncOfficeInfo) {
        List<SyncOfficeInfo> list = syncOfficeInfoService.selectSyncOfficeInfoList(syncOfficeInfo);
        ExcelUtil<SyncOfficeInfo> util = new ExcelUtil<SyncOfficeInfo>(SyncOfficeInfo.class);
        return util.exportExcel(list, "office");
    }

    /**
     * 新增组织机构
     */
    @GetMapping("/add")
    public String add() {
        return prefix + "/add";
    }

    /**
     * 新增保存组织机构
     */
    @RequiresPermissions("system:office:add")
    @Log(title = "组织机构", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(SyncOfficeInfo syncOfficeInfo) {
        return toAjax(syncOfficeInfoService.insertSyncOfficeInfo(syncOfficeInfo));
    }

    /**
     * 修改组织机构
     */
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") String id, ModelMap mmap) {
        SyncOfficeInfo syncOfficeInfo = syncOfficeInfoService.selectSyncOfficeInfoById(id);
        mmap.put("syncOfficeInfo", syncOfficeInfo);
        return prefix + "/edit";
    }

    /**
     * 修改保存组织机构
     */
    @RequiresPermissions("system:office:edit")
    @Log(title = "组织机构", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(SyncOfficeInfo syncOfficeInfo) {
        return toAjax(syncOfficeInfoService.updateSyncOfficeInfo(syncOfficeInfo));
    }

    /**
     * 删除组织机构
     */
    @RequiresPermissions("system:office:remove")
    @Log(title = "组织机构", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids) {
        return toAjax(syncOfficeInfoService.deleteSyncOfficeInfoByIds(ids));
    }
}
