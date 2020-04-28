package com.ruoyi.common.enums;

import java.util.Arrays;
import java.util.List;

import org.apache.commons.collections4.CollectionUtils;

import com.ruoyi.common.exception.BusinessException;
import com.ruoyi.common.utils.StringUtils;

/**
 * datamanager特征类型枚举
 * 
 * @author admin 
 * @date 2019年11月20日
 */
public enum DatamanageFeatureType {

    OTHER_UNKNOWN(0, "其他Unknown", "若含有多种生物特征 不要用Unknown", null),

    FACE(300, "300", "FaceFeature", null),

    IRIS_UNKNOWN(100, "虹膜Unknown", "IrisFeatureUnknown", null),

    IRIS_LEFT(101, "左眼", "IrisFeatureLeft", Arrays.asList("L")),

    IRIS_RIGHT(102, "右眼", "IrisFeatureRight", Arrays.asList("R")),

    IRIS_ALL(103, "两个眼", "IrisFeatureAll", null),

    FINGER_UNKNOWN(200, "指纹Unknown", "FingerFeatureUnknown", Arrays.asList("97", "98", "99")),

    FINGER_LEFT_THUMB(201, "左大拇指", "FingerFeatureLeftThumb", Arrays.asList("16")),

    FINGER_LEFT_INDEX(202, "左食指", "FingerFeatureLeftIndex", Arrays.asList("17")),

    FINGER_LEFT_MIDDLE(203, "左中指", "FingerFeatureLeftMiddle", Arrays.asList("18")),

    FINGER_LEFT_RING(204, "左无名指", "FingerFeatureLeftRing", Arrays.asList("19")),

    FINGER_LEFT_LITTLE(205, "左小拇指", "FingerFeatureLeftLittle", Arrays.asList("20")),

    FINGER_RIGHY_THUMB(206, "右大拇指", "FingerFeatureRightThumb", Arrays.asList("11")),

    FINGER_RIGHY_INDEX(207, "右食指", "FingerFeatureRightIndex", Arrays.asList("12")),

    FINGER_RIGHY_MIDDLE(208, "右中指", "FingerFeatureRightMiddle", Arrays.asList("13")),

    FINGER_RIGHY_RING(209, "右无名指", "FingerFeatureRightRing", Arrays.asList("14")),

    FINGER_RIGHY_LITTLE(210, "右小拇指", "FingerFeatureRightLittle", Arrays.asList("15"));

    /** 特征码 */
    private final Integer code;
    /** 特征类型名称 */
    private final String name;
    /** 说明*/
    private final String desc;
    /** 对应平台字典编码*/
    private final List<String> dictCodes;

    private DatamanageFeatureType(Integer code, String name, String desc, List<String> dictCodes) {
        this.code = code;
        this.name = name;
        this.desc = desc;
        this.dictCodes = dictCodes;
    }

    public Integer getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public String getDesc() {
        return desc;
    }

    public List<String> getDictCodes() {
        return dictCodes;
    }

    public static DatamanageFeatureType parse(String dictCode) {
        if (StringUtils.isBlank(dictCode)) {
            throw new BusinessException("对应平台字典编码不能为空");
        }
        for (DatamanageFeatureType type : DatamanageFeatureType.values()) {
            List<String> dictCodes = type.getDictCodes();
            if (CollectionUtils.isNotEmpty(dictCodes) && dictCodes.contains(dictCode)) {
                return type;
            }
        }
        throw new BusinessException("未匹配到合适的Datamanager特征枚举");
    }
}
