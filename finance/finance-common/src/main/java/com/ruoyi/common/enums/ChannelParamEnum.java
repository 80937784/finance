package com.ruoyi.common.enums;

import java.util.List;
import java.util.Map;

import com.beust.jcommander.internal.Lists;
import com.beust.jcommander.internal.Maps;
import com.ruoyi.common.constant.DictConstants;
import com.ruoyi.common.exception.BusinessException;
import com.ruoyi.common.utils.StringUtils;

/**
 * 渠道参数说明枚举
 * 
 * @author admin 
 * @date 2019年12月11日
 */
public enum ChannelParamEnum {

    FACE_COMPARE_CHECK_LIVE_PARAM("face.compare.checklive", "人脸1:1比对是否检活", "人脸1-1是否执行检活，参数值为[Y/N]之一，严格区分大小写", DictConstants.BioAttestType.FACE, Lists.newArrayList("Y", "N")),

    FACE_SEARCHN_CHECK_LIVE_PARAM("face.searchN.checklive", "人脸1:N搜索是否检活", "人脸1-N是否执行检活，参数值为[Y/N]之一，严格区分大小写", DictConstants.BioAttestType.FACE, Lists.newArrayList("Y", "N")),

    FACE_COMPARE_CHECK_LIVE_THRESHOLD_PARAM("face.compare.checklive.threshold", "人脸1:1比对检活阈值", "人脸1-1执行检活时的阈值，参数值必须是数字", DictConstants.BioAttestType.FACE, null),

    FACE_SEARCHN_CHECK_LIVE_THRESHOLD_PARAM("face.searchN.checklive.threshold", "人脸1:N搜索检活阈值", "人脸1-N执行检活时的阈值，参数值必须是数字", DictConstants.BioAttestType.FACE, null),

    FACE_COMPARE_THRESHOLD_PARAM("face.compare.threshold", "人脸1:1比对阈值", "人脸1-1比对时的阈值，参数值必须是数字", DictConstants.BioAttestType.FACE, null),

    FACE_SEARCH_N_THRESHOLD_PARAM("face.searchN.threshold", "人脸1:N搜索阈值", "人脸1-N搜索时的阈值，参数值必须是数字", DictConstants.BioAttestType.FACE, null),

    FINGER_COMPARE_THRESHOLD_PARAM("finger.compare.threshold", "指纹1:1比对阈值", "指纹1-1比对时的阈值，参数值必须是数字", DictConstants.BioAttestType.FINGER, null),

    FINGER_SEARCH_N_THRESHOLD_PARAM("finger.searchN.threshold", "指纹1:N搜索阈值", "指纹1-N搜索时的阈值，参数值必须是数字", DictConstants.BioAttestType.FINGER, null),

    IRIS_COMPARE_THRESHOLD_PARAM("iris.compare.threshold", "虹膜1:1比对阈值", "虹膜1-1比对时的阈值，参数值必须是数字", DictConstants.BioAttestType.IRIS, null),

    IRIS_SEARCH_N_THRESHOLD_PARAM("iris.searchN.threshold", "虹膜1:N搜索阈值", "虹膜1-N搜索时的阈值，参数值必须是数字", DictConstants.BioAttestType.IRIS, null);

    /** 参数编码*/
    private final String code;
    /** 参数名称*/
    private final String name;
    /** 参数说明*/
    private final String desc;
    /** 认证类型*/
    private final String bioAttestType;
    /** 可选值*/
    private final List<String> valList;

    private ChannelParamEnum(String code, String name, String desc, String bioAttestType, List<String> valList) {
        this.code = code;
        this.name = name;
        this.desc = desc;
        this.bioAttestType = bioAttestType;
        this.valList = valList;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public String getDesc() {
        return desc;
    }

    public String getBioAttestType() {
        return bioAttestType;
    }

    public List<String> getValList() {
        return valList;
    }

    public static List<Map<String, Object>> list() {
        List<Map<String, Object>> list = Lists.newArrayList();
        for (ChannelParamEnum it : ChannelParamEnum.values()) {
            Map<String, Object> map = Maps.newHashMap();
            map.put("code", it.getCode());
            map.put("name", it.getName());
            map.put("desc", it.getDesc());
            map.put("bioAttestType", it.getBioAttestType());
            map.put("valList", it.getValList());
            list.add(map);
        }
        return list;
    }

    public static ChannelParamEnum parse(String code) {
        if (StringUtils.isBlank(code)) {
            throw new BusinessException("参数编码不能为空");
        }
        for (ChannelParamEnum it : ChannelParamEnum.values()) {
            if (it.getCode().equals(code)) {
                return it;
            }
        }
        throw new BusinessException("无法匹配的参数编码:" + code);
    }

}
