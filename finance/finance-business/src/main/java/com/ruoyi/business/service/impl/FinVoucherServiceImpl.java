package com.ruoyi.business.service.impl;

import java.util.List;

import com.ruoyi.business.mapper.FinVoucherMapper;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.domain.FinVoucher;
import com.ruoyi.business.service.IFinVoucherService;
import com.ruoyi.common.core.text.Convert;

/**
 * 凭证管理Service业务层处理
 *
 * @author zfx
 * @date 2021-01-11
 */
@Service
public class FinVoucherServiceImpl implements IFinVoucherService {
    @Autowired
    private FinVoucherMapper finVoucherMapper;

    /**
     * 查询凭证管理
     *
     * @param id 凭证管理ID
     * @return 凭证管理
     */
    @Override
    public FinVoucher selectFinVoucherById(String id) {
        return finVoucherMapper.selectFinVoucherById(id);
    }

    /**
     * 查询凭证管理列表
     *
     * @param finVoucher 凭证管理
     * @return 凭证管理
     */
    @Override
    public List<FinVoucher> selectFinVoucherList(FinVoucher finVoucher) {
        return finVoucherMapper.selectFinVoucherList(finVoucher);
    }

    /**
     * 新增凭证管理
     *
     * @param finVoucher 凭证管理
     * @return 结果
     */
    @Override
    public int insertFinVoucher(FinVoucher finVoucher) {
        finVoucher.setCreateTime(DateUtils.getNowDate());
        return finVoucherMapper.insertFinVoucher(finVoucher);
    }

    /**
     * 修改凭证管理
     *
     * @param finVoucher 凭证管理
     * @return 结果
     */
    @Override
    public int updateFinVoucher(FinVoucher finVoucher) {
        finVoucher.setUpdateTime(DateUtils.getNowDate());
        return finVoucherMapper.updateFinVoucher(finVoucher);
    }

    /**
     * 删除凭证管理对象
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    @Override
    public int deleteFinVoucherByIds(String ids) {
        return finVoucherMapper.deleteFinVoucherByIds(Convert.toStrArray(ids));
    }

    /**
     * 删除凭证管理信息
     *
     * @param id 凭证管理ID
     * @return 结果
     */
    @Override
    public int deleteFinVoucherById(String id) {
        return finVoucherMapper.deleteFinVoucherById(id);
    }
}
