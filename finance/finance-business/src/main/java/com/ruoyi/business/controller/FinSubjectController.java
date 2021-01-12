package com.ruoyi.business.controller;

import com.ruoyi.business.domain.FinSubject;
import com.ruoyi.business.service.IFinSubjectService;
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
 * 科目管理Controller
 *
 * @author zfx
 * @date 2021-01-11
 */
@Controller
@RequestMapping("/business/subject")
public class FinSubjectController extends BaseController {
    private String prefix = "business/subject";

    @Autowired
    private IFinSubjectService finSubjectService;

    @RequiresPermissions("business:subject:view")
    @GetMapping()
    public String subject() {
        return prefix + "/subject";
    }

    /**
     * 查询科目管理列表
     */
    @RequiresPermissions("business:subject:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(FinSubject finSubject) {
        startPage();
        List<FinSubject> list = finSubjectService.selectFinSubjectList(finSubject);
        return getDataTable(list);
    }
    /**
     * 查询待加入渠道库的人员列表
     *
     * @return
     */
    @PostMapping("/listSubject")
    @ResponseBody
    public TableDataInfo selectListSubject(FinSubject finSubject) {
        startPage();
        List<FinSubject> list = finSubjectService.selectFinSubjectList(finSubject);
        return getDataTable(list);
    }
    /**
     * 导出科目管理列表
     */
    @RequiresPermissions("business:subject:export")
    @Log(title = "科目管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(FinSubject finSubject) {
        List<FinSubject> list = finSubjectService.selectFinSubjectList(finSubject);
        ExcelUtil<FinSubject> util = new ExcelUtil<FinSubject>(FinSubject.class);
        return util.exportExcel(list, "subject");
    }

    /**
     * 新增科目管理
     */
    @GetMapping("/add")
    public String add() {
        return prefix + "/add";
    }

    /**
     * 新增保存科目管理
     */
    @RequiresPermissions("business:subject:add")
    @Log(title = "科目管理", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(FinSubject finSubject) {
        return toAjax(finSubjectService.insertFinSubject(finSubject));
    }

    /**
     * 修改科目管理
     */
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") String id, ModelMap mmap) {
        FinSubject finSubject = finSubjectService.selectFinSubjectById(id);
        mmap.put("finSubject", finSubject);
        return prefix + "/edit";
    }

    /**
     * 修改保存科目管理
     */
    @RequiresPermissions("business:subject:edit")
    @Log(title = "科目管理", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(FinSubject finSubject) {
        return toAjax(finSubjectService.updateFinSubject(finSubject));
    }

    /**
     * 删除科目管理
     */
    @RequiresPermissions("business:subject:remove")
    @Log(title = "科目管理", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids) {
        return toAjax(finSubjectService.deleteFinSubjectByIds(ids));
    }

    @PostMapping("/selectSubjects")
    @ResponseBody
    public TableDataInfo selectSubjects(FinSubject finSubject) {
        startPage();
        List<FinSubject> list = finSubjectService.selectFinSubjectList(finSubject);
        return getDataTable(list);
    }
    @GetMapping("/selectSubjects/{id}")
    public String selectSubjects(@PathVariable("id") String id ,ModelMap mmap) {
        mmap.put("id", id);
        return prefix + "/listSubject";
    }

}
