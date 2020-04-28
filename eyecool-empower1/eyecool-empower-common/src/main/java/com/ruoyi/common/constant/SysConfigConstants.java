package com.ruoyi.common.constant;

/**
 * 系统配置参数常量类
 * 
 * @author admin 
 * @date 2019年10月16日
 */
public class SysConfigConstants {

    /** 二维码图片文件夹KEY值 */
    public static final String BASEDATA_QRCODE_DIR_KEY = "basedata.qrcode.dir";

    /** 人脸图片文件夹KEY值 */
    public static final String BASEDATA_FACE_DIR_KEY = "basedata.face.dir";

    /** 人脸1-N比对搜索图片文件夹KEY值 */
    public static final String BUSI_FACE_SEARCH_DIR_KEY = "busi.face.searchN.dir";

    /** 人脸1:1认证图片文件夹KEY值 */
    public static final String BUSI_FACE_COMPARE_DIR_KEY = "busi.face.compare.dir";

    /** 指纹图片文件夹KEY值 */
    public static final String BASEDATA_FINGER_DIR_KEY = "basedata.finger.dir";

    /** 指纹1-N比对搜索图片文件夹KEY值 */
    public static final String BUSI_FINGER_SEARCH_DIR_KEY = "busi.finger.searchN.dir";

    /** 指纹1:1认证图片文件夹KEY值 */
    public static final String BUSI_FINGER_COMPARE_DIR_KEY = "busi.finger.compare.dir";

    /** 虹膜图片文件夹KEY值 */
    public static final String BASEDATA_IRIS_DIR_KEY = "basedata.iris.dir";

    /** 虹膜1-N比对搜索图片文件夹KEY值 */
    public static final String BUSI_IRIS_SEARCH_DIR_KEY = "busi.iris.searchN.dir";

    /** 虹膜1:1认证图片文件夹KEY值 */
    public static final String BUSI_IRIS_COMPARE_DIR_KEY = "busi.iris.compare.dir";

    /** 证件照图片文件夹KEY值 */
    public static final String BASEDATA_CERT_DIR_KEY = "basedata.cert.dir";

    /** 人脸图片质量检测阈值KEY值 */
    public static final String BASEDATA_FACE_QUALITY_DETECT_THRESHOLD_KEY = "basedata.face.quality.detect.threshold";

    /** 指纹图片质量检测阈值KEY值 */
    public static final String BASEDATA_FINGER_QUALITY_DETECT_THRESHOLD_KEY = "basedata.finger.quality.detect.threshold";

    /** 人脸1:1比对阈值KEY值 */
    public static final String BASEDATA_FACE_COMPARE_THRESHOLD_KEY = "basedata.face.compare.threshold";

    /** 人脸检活阈值KEY值 */
    public static final String BASEDATA_FACE_CHECKLIVE_THRESHOLD_KEY = "basedata.face.checklive.threshold";

    /** 人脸1-N搜索阈值KEY值 */
    public static final String BASEDATA_FACE_SEARCH_N_THRESHOLD_KEY = "basedata.face.searchN.threshold";

    /** 指纹1:1比对阈值KEY值 */
    public static final String BASEDATA_FINGER_COMPARE_THRESHOLD_KEY = "basedata.finger.compare.threshold";

    /** 指纹1-N搜索阈值KEY值 */
    public static final String BASEDATA_FINGER_SEARCH_N_THRESHOLD_KEY = "basedata.finger.searchN.threshold";

    /** 重复指纹阈值KEY值 */
    public static final String BASEDATA_FINGER_REPEAT_THRESHOLD_KEY = "basedata.finger.repeat.threshold";

    /** 虹膜1:1比对阈值KEY值 */
    public static final String BASEDATA_IRIS_COMPARE_THRESHOLD_KEY = "basedata.iris.compare.threshold";

    /** 虹膜1:1比对结果策略 */
    public static final String BUSI_IRIS_COMPARE_RESULT_STRATEGY_KEY = "busi.iris.compare.result.strategy";

    /** 虹膜1-N搜索阈值KEY值 */
    public static final String BASEDATA_IRIS_SEARCH_N_THRESHOLD_KEY = "basedata.iris.searchN.threshold";

    /** 虹膜1:N搜索结果策略 */
    public static final String BUSI_IRIS_SEARCH_N_RESULT_STRATEGY_KEY = "busi.iris.searchN.result.strategy";

    /** 重复虹膜阈值KEY值 */
    public static final String BASEDATA_IRIS_REPEAT_THRESHOLD_KEY = "basedata.iris.repeat.threshold";

    /** 人脸自助采集页面标题KEY值 */
    public static final String BASEDATA_FACE_COLLECT_PAGE_TITLE_KEY = "basedata.face.collect.page.title";

    /** 人脸自助采集默认登录用户密码KEY值 */
    public static final String BASEDATA_FACE_COLLECT_DEFAULT_LOGIN_PWD_KEY = "basedata.face.collect.login.pwd";

    /** 渠道业务服务自助开通默认登录用户密码KEY值 */
    public static final String CHANNEL_BUSI_SELF_OPEN_DEFAULT_LOGIN_PWD_KEY = "busi.self.open.login.pwd";

    /** 人脸自助采集是否在没有底库照时校验证件照KEY值,VALUE为[Y/N]*/
    public static final String BASEDATA_FACE_COLLECT_VALIDATE_CERT = "basedata.face.collect.validte.cert";

    /** 基础数据接口并发量KEY值 */
    public static final String BASEDATA_INTERFACE_CONCURRENT_KEY = "basedata.interface.concurrent";

    /** 人脸入库是否进行1-N校验KEY值 */
    public static final String BASEDATA_FACE_ADD_ISVALIDN_KEY = "basedata.face.add.isValidN";

    /** 指纹入库是否进行1-N校验KEY值 */
    public static final String BASEDATA_FINGER_ADD_ISVALIDN_KEY = "basedata.finger.add.isValidN";

    /** 虹膜入库是否进行1-N校验KEY值 */
    public static final String BASEDATA_IRIS_ADD_ISVALIDN_KEY = "basedata.iris.add.isValidN";

    /** APP版本文件存放文件夹KEY值 */
    public static final String DEVICE_VERSION_FILE_DIR_KEY = "device.version.file.dir";

    /** ABIS微服务调用超时时间（单位:s）*/
    public static final String ABIS_SERVICE_CALL_TIMEOUT_KEY = "abis.service.call.timeout";

    /** 系统组织架构默认部门编码*/
    public static final String DEFAULT_SYS_DEPT_CODE = "default";

    /** 消息推送子系统附件存放位置*/
    public static final String MSG_ATTACHMENT_DIR_KEY = "msg.attachment.dir";

    /** 人脸1-N日志是否比对去重 */
    public static final String BUSI_FACE_SEARCH_LOG_SAVE_DISTINCT_KEY = "busi.face.searchN.log.save.distinct";

    /** 人脸1-N日志保存去重时间 */
    public static final String BUSI_FACE_SEARCH_LOG_DUPLICATE_TIME_KEY = "busi.face.searchN.log.duplicate.time";

    /** 平台是否开启1-N功能KEY值 */
    public static final String PLATFORM_SEARCH_N_FUNCTION_OPEN_KEY = "platform.searchN.function.isOpen";

    /** 人员信息实时同步调用服务端分配的AppKey对应的参数设置Key值 */
    public static final String PERSON_LIVE_UPDATE_CALL_APPKEY_KEY = "person.liveupdate.call.appkey";

    /** 人员信息实时同步调用服务端分配的AppSecrect对应的参数设置Key值 */
    public static final String PERSON_LIVE_UPDATE_CALL_APPSECRECT_KEY = "person.liveupdate.call.appsecrect";

    /** 人员信息实时同步上一次同步的最大更新标识Key值 */
    public static final String PERSON_LIVE_UPDATE_MAX_SERIANUM_KEY = "person.liveupdate.max.serianum";

    /** 人员信息实时同步上一次同步的最大更新时间Key值 */
    public static final String PERSON_LIVE_UPDATE_MAX_UPDATETIME_KEY = "person.liveupdate.max.updatetime";

    /** 人员信息实时同步客户端对应的渠道编码Key值 */
    public static final String PERSON_LIVE_UPDATE_CHANNEL_CODE_KEY = "person.liveupdate.channelCode";

    /** 人员信息实时同步服务端应用地址Key值 */
    public static final String PERSON_LIVE_UPDATE_SERVER_ADDRESS_KEY = "person.liveupdate.server.address";

}
