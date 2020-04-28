package com.ruoyi.common.constant;

/**
 * 缓存常量信息
 * 
 * @author admin 
 * @date 2019年11月13日
 */
public interface EhCacheConstants {

    /** 并发量缓存KEY前缀(渠道并发量缓存KEY：[semaphore_cache_key_渠道编码])*/
    public static final String SEMAPHORE_CACHE_PREFIX_KEY = "semaphore_cache_key_";
    /** 基础数据并发量缓存KEY*/
    public static final String SEMAPHORE_CACHE_BASEDATA_KEY = SEMAPHORE_CACHE_PREFIX_KEY + "basedata";
    /** 基础数据人员信心更细自增标识缓存KEY*/
    public static final String LIVE_UPDATE_SERIA_NUM_CACHE_KEY = "live_update_seria_num_cache_key";
    /** 默认缓存名称*/
    public static final String DEFAULT_CACHE_NAME = "eyecoolDefaultCache";
    /** 对外HTTP接口请求唯一码缓存名称*/
    public static final String HTTP_NONCE_CACHE_NAME = "httpNonceCache";
    /** 微信验证码缓存名称*/
    public static final String WECHAT_CAPTCHA_CACHE_NAME = "wechatCaptcha";

}
