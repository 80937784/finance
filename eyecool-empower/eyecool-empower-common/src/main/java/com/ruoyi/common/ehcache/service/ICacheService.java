package com.ruoyi.common.ehcache.service;

import java.io.Serializable;

/**
 * 缓存服务.
 * 
 * @author admin 
 * @date 2019年11月4日
 */
public interface ICacheService {

    /**
     * 添加一个指定的值到缓存中：如果已经存在相应的key，那么调用set()方法，否则调用add()方法. 存放到本地缓存中。
     *
     * @param cacheName
     * @param key
     * @param value
     * @return
     */
    boolean put(String cacheName, String key, Serializable value);

    /**
     * 根据指定的关键字获取对象.
     *
     * @param cacheName
     * @param key
     * @return 如果不存在那么返回null
     */
    Object get(String cacheName, String key);

    /**
     * 根据指定的关键字判断是否存在.
     *
     * @param cacheName
     * @param key
     * @return
     */
    boolean keyExists(String cacheName, String key);

    /**
     * 根据指定的关键字删除.
     * 
     * @param cacheName
     * @param key
     * @return
     */
    boolean remove(String cacheName, String key);

}
