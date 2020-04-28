package com.ruoyi.common.ehcache.service.impl;

import java.io.Serializable;

import org.springframework.stereotype.Service;

import com.ruoyi.common.ehcache.client.EhcacheClient;
import com.ruoyi.common.ehcache.service.ICacheService;

/**
 * 缓存服务的实现类.
 * 
 * @author admin 
 * @date 2019年11月4日
 */
@Service("cacheService")
public class CacheServiceImpl implements ICacheService {

    /**
     * 添加一个指定的值到缓存中：如果已经存在相应的key，那么调用set()方法，否则调用add()方法.
     */
    @Override
    public boolean put(String cacheName, String key, Serializable value) {
        return EhcacheClient.put(cacheName, key, value);
    }

    /**
     * 根据指定的关键字获取对象.
     */
    @Override
    public Object get(String cacheName, String key) {
        return EhcacheClient.get(cacheName, key);
    }

    /**
     * 根据指定的关键字判断是否存在.
     */
    @Override
    public boolean keyExists(String cacheName, String key) {
        return EhcacheClient.isExist(cacheName, key);
    }

    /**
     * 根据指定的关键字删除.
     */
    @Override
    public boolean remove(String cacheName, String key) {
        return EhcacheClient.remove(cacheName, key);
    }

}
