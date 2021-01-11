package com.ruoyi.business.controller;

import com.ruoyi.business.domain.FinVoucher;
import com.ruoyi.business.service.IFinVoucherService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 凭证管理Controller
 *
 * @author zfx
 * @date 2021-01-11
 */
@Controller
@RequestMapping("/business/voucher")
public class FinVoucherController extends BaseController {
    private String prefix = "business/voucher";

    @Autowired
    private IFinVoucherService finVoucherService;

    @RequiresPermissions("business:voucher:view")
    @GetMapping()
    public String voucher() {
        return prefix + "/voucher";
    }

    /**
     * 查询凭证管理列表
     */
    @RequiresPermissions("business:voucher:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(FinVoucher finVoucher) {
        startPage();
        List<FinVoucher> list = finVoucherService.selectFinVoucherList(finVoucher);
        return getDataTable(list);
    }

    /**
     * 导出凭证管理列表
     */
    @RequiresPermissions("business:voucher:export")
    @Log(title = "凭证管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(FinVoucher finVoucher) {
        List<FinVoucher> list = finVoucherService.selectFinVoucherList(finVoucher);
        ExcelUtil<FinVoucher> util = new ExcelUtil<FinVoucher>(FinVoucher.class);
        return util.exportExcel(list, "voucher");
    }

    /**
     * 新增凭证管理
     */
    @GetMapping("/add")
    public String add() {
        return prefix + "/add";
    }

    /**
     * 新增保存凭证管理
     */
    @RequiresPermissions("business:voucher:add")
    @Log(title = "凭证管理", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(FinVoucher finVoucher) {
        return toAjax(finVoucherService.insertFinVoucher(finVoucher));
    }

    /**
     * 修改凭证管理
     */
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") String id, ModelMap mmap) {
        FinVoucher finVoucher = finVoucherService.selectFinVoucherById(id);
        mmap.put("finVoucher", finVoucher);
        return prefix + "/edit";
    }

    /**
     * 修改保存凭证管理
     */
    @RequiresPermissions("business:voucher:edit")
    @Log(title = "凭证管理", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(FinVoucher finVoucher) {
        return toAjax(finVoucherService.updateFinVoucher(finVoucher));
    }

    /**
     * 删除凭证管理
     */
    @RequiresPermissions("business:voucher:remove")
    @Log(title = "凭证管理", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids) {
        return toAjax(finVoucherService.deleteFinVoucherByIds(ids));
    }
}
