package com.ruoyi.common.constant;

import java.util.List;

import com.beust.jcommander.internal.Lists;

/**
 * 字典常量信息(接口为字典数据常量, String类型为字典类型常量)
 *
 * @author admin
 */
public interface DictConstants {

    /** HTTP请求接口字典类型*/
    public static final String HTTP_INTREFACE_DICT_TYPE = "http_interface";
    /** 手指编号类型*/
    public static final String BIO_FINGER_NO_DICT_TYPE = "bio_finger_code";
    /** 虹膜编码类型*/
    public static final String BIO_EYE_CODE_DICT_TYPE = "bio_eye_code";
    /** 人员标记类型*/
    public static final String PERSON_FLAG_DICT_TYPE = "apply_person_flag";

    /** 是否*/
    interface YesOrNo {
        public static final String YES = "Y"; // 是
        public static final String NO = "N";// 否
    }

    /** 状态*/
    interface Status {
        public static final String ENABLE = "0"; // 正常
        public static final String DISABLE = "1";// 停用
    }

    /** 数据来源*/
    interface DataSource {
        public static final String HTTP_INTERFACE = "HTTP";// HTTP接口
        public static final String INTERFACE = "INTERFACE";// 内部接口
        public static final String IMP = "IMP";// 导入
        public static final String LIVE_UPDATE = "LIVEUPDATE";// 数据实时更新接口
    }

    /** 证件照片类型*/
    interface CertPhotoType {
        public static final String CERT_PHOTO = "0";// 证件照片
        public static final String ENTER_SCHOOL_PHOTO = "1";// 入学照片
        public static final String IN_SCHOOL_PHOTO = "2";// 在校照片
        public static final String GRADUATE_PHOTO = "3";// 毕业照片
    }

    /** 是否加密*/
    interface Encrypted {
        public static final String DISABLE = "0"; // 不加密
        public static final String ENABLE = "1";// 加密
    }

    /** 生物信息图片类型*/
    interface BioPhotoType {
        public static final String FACE_PHOTO = "1";// 人脸图片
        public static final String FINGER_PHOTO = "2";// 指纹图片
        public static final String IRIS_PHOTO = "3";// 虹膜图片
    }

    /** 眼睛编码*/
    interface EyeCode {
        public static final String LEFT_EYE = "L"; // 左眼
        public static final String RIGHT_EYE = "R";// 右眼
    }

    /** 不确定指位手指编码*/
    interface UncertainFingerNo {
        public static final String LEFT_UNCERTAIN_FINGER = "98"; // 右手不确定指位
        public static final String RIGHT_UNCERTAIN_FINGER = "97"; // 左手不确定指位
        public static final String OTHER_UNCERTAIN_FINGER = "99"; // 右手不确定指位

        public static final List<String> uncertainFingerNoList = Lists.newArrayList(LEFT_UNCERTAIN_FINGER, RIGHT_UNCERTAIN_FINGER, OTHER_UNCERTAIN_FINGER);
    }

    /** 生物特征识别开通状态*/
    interface BioModeStatus {
        public static final String ENABLE = "1"; // 开通
        public static final String DISABLE = "0";// 不开通
    }

    /** 生物特征认证类型*/
    interface BioAttestType {
        public static final String FACE = "0"; // 人脸
        public static final String FINGER = "1";// 指纹
        public static final String IRIS = "2";// 虹膜
        public static final String FVEIN = "3";// 指静脉
    }

    /** 生物特征认证结果*/
    interface BioResult {
        public static final String PASS = "0"; // 通过
        public static final String NOTPASS = "1";// 未通过
    }

    /** HTTP接口交易码*/
    interface HttpInterfaceTransCode {
        public static final String PERSON_INSERT = "PERSON_INFO_INSERT"; // 新增人员基础信息
        public static final String PERSON_UPDATE = "PERSON_INFO_UPDATE"; // 修改人员基础信息
        public static final String PERSON_DELETE = "PERSON_INFO_DELETE"; // 删除人员基础信息
        public static final String PERSON_SELECT = "PERSON_INFO_SELECT"; // 查询人员基础信息

        public static final String PERSON_FACE_OPEN = "PERSON_FACE_OPEN"; // 开通人脸
        public static final String PERSON_FACE_CLOSE = "PERSON_FACE_CLOSE"; // 关闭人脸
        public static final String PERSON_FACE_RECOG = "PERSON_FACE_RECOG"; // 人脸识别(1:N)
        public static final String PERSON_FACE_VERIFY = "PERSON_FACE_VERIFY";// 人脸认证(1:1)
        public static final String PERSON_FACE_FEATURE = "PERSON_FACE_FEATURE";// 人脸特征提取

        public static final String PERSON_FINGER_OPEN = "PERSON_FINGER_OPEN";// 开通指纹
        public static final String PERSON_FINGER_CLOSE = "PERSON_FINGER_CLOSE";// 关闭指纹
        public static final String PERSON_FINGER_RECOG = "PERSON_FINGER_RECOG"; // 指纹识别(1:N)
        public static final String PERSON_FINGER_VERIFY = "PERSON_FINGER_VERIFY";// 指纹认证(1:1)

        public static final String PERSON_IRIS_OPEN = "PERSON_IRIS_OPEN";// 开通虹膜
        public static final String PERSON_IRIS_CLOSE = "PERSON_IRIS_CLOSE";// 关闭虹膜
        public static final String PERSON_IRIS_RECOG = "PERSON_IRIS_RECOG"; // 虹膜识别(1:N)
        public static final String PERSON_IRIS_VERIFY = "PERSON_IRIS_VERIFY";// 虹膜认证(1:1)

        public static final String PERSON_FVEIN_OPEN = "PERSON_FVEIN_OPEN";// 开通指静脉
        public static final String PERSON_FVEIN_CLOSE = "PERSON_FVEIN_CLOSE";// 关闭指静脉
        public static final String PERSON_FVEIN_RECOG = "PERSON_FVEIN_RECOG"; // 指静脉识别(1:N)
        public static final String PERSON_FVEIN_VERIFY = "PERSON_FVEIN_VERIFY";// 指静脉认证(1:1)

        public static final String MESSAGE_SMS = "MESSAGE_SEND_SMS"; // 短信推送
        public static final String MESSAGE_WECHAT = "MESSAGE_SEND_WECHAT"; // 微信服务号推送
        public static final String MESSAGE_EMAIL = "MESSAGE_SEND_EMAIL"; // 邮件推送
        public static final String MESSAGE_DING = "MESSAGE_SEND_DING"; // 钉钉推送
        public static final String MESSAGE_DING_RESULT = "MESSAGE_SEND_DING_RESULT"; // 钉钉推送结果查询
        public static final String MESSAGE_DING_UPOLOAD = "MESSAGE_DING_MEDIA_UPLOAD";// 钉钉媒体文件上传

        public static final String PERSON_LIVE_UPDATE = "PERSON_LIVE_UPDATE";// 人员信息实时更新
        public static final String PERSON_FACE_SEARCH_LOG_BAK = "PERSON_FACE_SEARCH_LOG_BAK";// 人脸识别日志回传接口
        public static final String PERSON_SUB_TREASURY_OPERATE = "PERSON_SUB_TREASURY_OPERATE";// 渠道分库操作
        public static final String CLIENT_VERSION_DOWNLOAD = "CLIENT_VERSION_DOWNLOAD";// 设备版本下载接口
        public static final String CLIENT_UPGRADE_SIGNAL = "CLIENT_UPGRADE_SIGNAL";// 设备是否需要更新确认接口
        public static final String CLIENT_UPGRADE_RESULT_BAK = "CLIENT_UPGRADE_RESULT_BAK";// 设备版本升级结果回写

    }

    /** 1-N校验方式*/
    interface SearchNType {
        public static final String SEARCH_N_TYPE_SUB = "1"; // 校验分库
        public static final String SEARCH_N_TYPE_CHANNEL = "2";// 校验渠道库
        public static final String SEARCH_N_TYPE_ALL = "3";// 校验全库
        public static final String SEARCH_N_TYPE_SEQ = "4";// 依次查询
                                                           // 分库->渠道库->全库(查询到就截止)
    }

    /** 1-N搜索日志场景类型*/
    interface SearchNLogSceneType {
        public static final String BASE_INFO_PUT = "1"; // 基础信息入库1:N
        public static final String SEARCH_N_HTTP = "2";// 比对搜索接口1:N
        public static final String SEARCH_N_LOG_BAK = "3";// 子系统日志回传
    }

    /** 虹膜比对搜索结果策略*/
    interface IrisMatchResultStartegy {
        public static final String AND_STRATEGY = "1"; // 与策略
        public static final String OR_STRATEGY = "2";// 或策略
    }

    interface SceneCode {
        public static final String SYSTEM_SERVLET_REQUEST = "SYSTEM_SERVLET_REQUEST";// 工程内servlet请求
        public static final String STANDARD_HTTP_API_DEFAULT = "STANDARD_HTTP_API_DEFAULT";// 未设置scenecode，默认为统一http接口
    }

    /** 设备升级状态*/
    interface DeviceUpgradeStatus {
        public static final String TO_BE_DOWNLOAD = "1";// 待下载
        public static final String TO_BE_UPGRADE = "2";// 待升级
        public static final String UPGRADE_SUCCESS = "3";// 升级成功
        public static final String UPGRADE_FAIL = "4";// 升级失败
        public static final String SKIP_UPGRAD = "5";// 跳过
    }

    /** 设备程序(APP)版本类型*/
    interface ClientVersionType {
        public static final String FULL_LOAD_PACKAGE = "0";// 全量
        public static final String INCREMENT_LOAD_PACKAGE = "1";// 增量
    }

    /** 人员标记*/
    interface PersonFlag {
        public static final String NORMAL = "1";// 正常
        public static final String RED = "2";// 红名单
        public static final String BLACK = "3";// 黑明单
    }

    /** 设备升级任务结果*/
    interface DeviceUpgradeTaskResult {
        public static final String TO_BE_EXECUTE = "1";// 待下载
        public static final String UPGRADE_SUCCESS = "2";// 成功
        public static final String UPGRADE_FAIL = "3";// 失败
        public static final String SKIP_UPGRAD = "4";// 跳过
    }

    /** 消息发送模式*/
    interface MsgType {
        public static final String NORMAL_MSG = "1";// 普通发送
        public static final String TEMPLATE_MSG = "2";// 模板发送
    }

    /** 消息通知方式*/
    interface MsgNoticeMethod {
        public static final String SMS_METHOD = "1";// 短信
        public static final String MAIL_METHOD = "2";// 邮件
        public static final String WECHAT_METHOD = "3";// 微信
        public static final String DING_METHOD = "4";// 钉钉
    }

    /** 消息推送结果*/
    interface MsgResult {
        public static final String SUCCESS = "0";// 成功
        public static final String FAIL = "1";// 失败
    }

    /** 发送邮件类型*/
    interface MailType {
        public static final String TEXT_MAIL = "1";// 文本邮件
        public static final String HTML_MAIL = "2";// HTMl邮件
    }

    /** 发送钉钉消息类型*/
    interface DingtalkType {
        public static final String TEXT = "text";// 文本消息
        public static final String MARKDOWN = "markdown";// MARKDOWN消息
        public static final String LINK = "link"; // 链接消息
        public static final String IMAGE = "image";// 图片消息
        public static final String FILE = "file";// 文件消息
        public static final String OA = "oa";// OA消息
        public static final String ACTION_CARD = "action_card";// ACTION_CARD消息
        public static final String VOICE = "voice";// VOICE消息
    }

    /** 发送钉钉消息媒体文件类型*/
    interface DingtalkMediaType {
        public static final String IMAGE = "image";// 图片消息
        public static final String FILE = "file";// 文件消息
        public static final String VOICE = "voice";// VOICE消息
    }
}
