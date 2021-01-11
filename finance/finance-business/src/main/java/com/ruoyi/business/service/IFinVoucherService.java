package com.ruoyi.business.service;

import java.util.List;

import com.ruoyi.business.domain.FinVoucher;

/**
 * 凭证管理Service接口
 *
 * @author zfx
 * @date 2021-01-11
 */
public interface IFinVoucherService {
    /**
     * 查询凭证管理
     *
     * @param id 凭证管理ID
     * @return 凭证管理
     */
    public FinVoucher selectFinVoucherById(String id);

    /**
     * 查询凭证管理列表
     *
     * @param finVoucher 凭证管理
     * @return 凭证管理集合
     */
    public List<FinVoucher> selectFinVoucherList(FinVoucher finVoucher);

    /**
     * 新增凭证管理
     *
     * @param finVoucher 凭证管理
     * @return 结果
     */
    public int insertFinVoucher(FinVoucher finVoucher);

    /**
     * 修改凭证管理
     *
     * @param finVoucher 凭证管理
     * @return 结果
     */
    public int updateFinVoucher(FinVoucher finVoucher);

    /**
     * 批量删除凭证管理
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    public int deleteFinVoucherByIds(String ids);

    /**
     * 删除凭证管理信息
     *
     * @param id 凭证管理ID
     * @return 结果
     */
    public int deleteFinVoucherById(String id);
}
