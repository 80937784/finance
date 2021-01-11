package com.ruoyi.business.mapper;

import com.ruoyi.business.domain.FinSubject;

import java.util.List;

/**
 * 科目管理Mapper接口
 *
 * @author zfx
 * @date 2021-01-11
 */
public interface FinSubjectMapper {
    /**
     * 查询科目管理
     *
     * @param id 科目管理ID
     * @return 科目管理
     */
    public FinSubject selectFinSubjectById(String id);

    /**
     * 查询科目管理列表
     *
     * @param finSubject 科目管理
     * @return 科目管理集合
     */
    public List<FinSubject> selectFinSubjectList(FinSubject finSubject);

    /**
     * 新增科目管理
     *
     * @param finSubject 科目管理
     * @return 结果
     */
    public int insertFinSubject(FinSubject finSubject);

    /**
     * 修改科目管理
     *
     * @param finSubject 科目管理
     * @return 结果
     */
    public int updateFinSubject(FinSubject finSubject);

    /**
     * 删除科目管理
     *
     * @param id 科目管理ID
     * @return 结果
     */
    public int deleteFinSubjectById(String id);

    /**
     * 批量删除科目管理
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    public int deleteFinSubjectByIds(String[] ids);
}
