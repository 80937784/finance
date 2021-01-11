package com.ruoyi.business.service.impl;

import com.ruoyi.business.domain.FinSubject;
import com.ruoyi.business.mapper.FinSubjectMapper;
import com.ruoyi.business.service.IFinSubjectService;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.IdWorker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 科目管理Service业务层处理
 *
 * @author zfx
 * @date 2021-01-11
 */
@Service
public class FinSubjectServiceImpl implements IFinSubjectService {
    @Autowired
    private FinSubjectMapper finSubjectMapper;

    /**
     * 查询科目管理
     *
     * @param id 科目管理ID
     * @return 科目管理
     */
    @Override
    public FinSubject selectFinSubjectById(String id) {
        return finSubjectMapper.selectFinSubjectById(id);
    }

    /**
     * 查询科目管理列表
     *
     * @param finSubject 科目管理
     * @return 科目管理
     */
    @Override
    public List<FinSubject> selectFinSubjectList(FinSubject finSubject) {
        return finSubjectMapper.selectFinSubjectList(finSubject);
    }

    /**
     * 新增科目管理
     *
     * @param finSubject 科目管理
     * @return 结果
     */
    @Override
    public int insertFinSubject(FinSubject finSubject) {
        finSubject.setId(IdWorker.getInstance().nextId() + "");
        finSubject.setCreateTime(DateUtils.getNowDate());
        return finSubjectMapper.insertFinSubject(finSubject);
    }

    /**
     * 修改科目管理
     *
     * @param finSubject 科目管理
     * @return 结果
     */
    @Override
    public int updateFinSubject(FinSubject finSubject) {
        finSubject.setUpdateTime(DateUtils.getNowDate());
        return finSubjectMapper.updateFinSubject(finSubject);
    }

    /**
     * 删除科目管理对象
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    @Override
    public int deleteFinSubjectByIds(String ids) {
        return finSubjectMapper.deleteFinSubjectByIds(Convert.toStrArray(ids));
    }

    /**
     * 删除科目管理信息
     *
     * @param id 科目管理ID
     * @return 结果
     */
    @Override
    public int deleteFinSubjectById(String id) {
        return finSubjectMapper.deleteFinSubjectById(id);
    }
}
