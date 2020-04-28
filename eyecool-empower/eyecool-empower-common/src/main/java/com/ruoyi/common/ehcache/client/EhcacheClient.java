package com.ruoyi.common.ehcache.client;

import java.net.URL;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

/**
 * 缓存工具类
 * 
 * @author admin 
 * @date 2019年11月4日
 */
public class EhcacheClient {

    private static final transient Logger LOG = LoggerFactory.getLogger(EhcacheClient.class);

    /**默认的cache*/
    private static final String DEFAULT_CACHE_NAME = "eyecoolDefaultCache";
    private static CacheManager cacheManager = null;

    private static CacheManager getCacheManager() {
        if (cacheManager == null) {
            synchronized (EhcacheClient.class) {
                if (cacheManager == null) {
                    URL url = EhcacheClient.class.getResource("/ehcache/ehcache.xml");
                    cacheManager = CacheManager.create(url);
                }
            }
        }
        return cacheManager;
    }

    /**
     * 清空所有缓存
     */
    public static void removeAll() {
        if (getCacheManager() == null) {
            return;
        }
        getCacheManager().clearAll();
    }

    /**
     * 判读是否存在缓存
     *
     * @param cacheName 名称
     * @param key       键值
     * @return boolean isExist
     */
    public static boolean isExist(String cacheName, String key) {
        boolean flag = false;
        if (key == null) {
            return flag;
        }
        Object obj = get(cacheName, key);
        flag = obj != null;
        return flag;
    }

    /**
     * 判读是否存在缓存
     *
     * @param key  键值
     * @return boolean isExist
     */
    public static boolean isExist(String key) {
        return isExist(DEFAULT_CACHE_NAME, key);
    }

    /**
     * 设置缓存
     *
     * @param cacheName 名称
     * @param key       键值
     * @param value     值
     */
    public static boolean put(String cacheName, String key, Object value) {
        try {
            if (getCacheManager() == null) {
                return true;
            }
            Cache cache = getCacheManager().getCache(cacheName);
            Element element = new Element(key, value);
            cache.put(element);
            return true;
        } catch (Exception e) {
            LOG.error("put error :{} ", e);
            return false;
        }
    }

    /**
     * 设置缓存
     *
     * @param key       键值
     * @param value     值
     */
    public static boolean put(String key, Object value) {
        return put(DEFAULT_CACHE_NAME, key, value);
    }

    /**
     * 获取缓存
     *
     * @param cacheName  名称
     * @param key        键值
     * @return obj       value
     */
    public static Object get(String cacheName, String key) {
        if (getCacheManager() == null) {
            return null;
        }
        Cache cache = getCacheManager().getCache(cacheName);
        if (cache == null) {
            return null;
        }
        Element element = cache.get(key);
        return element == null ? null : element.getObjectValue();
    }

    /**
     * 获取缓存
     *
     * @param key       键值
     * @return obj      value
     */
    public static Object get(String key) {
        return get(DEFAULT_CACHE_NAME, key);
    }

    /**
     * 获取cache
     *
     * @param cacheName 名称
     * @return cache    cache
     */
    public static Cache getCache(String cacheName) {
        if (getCacheManager() == null) {
            return null;
        }
        return getCacheManager().getCache(cacheName);
    }

    /**
     * 清除缓存
     *
     * @param cacheName 名称
     * @param key       键值
     */
    public static boolean remove(String cacheName, String key) {
        try {
            if (getCacheManager() == null) {
                return true;
            }
            Cache cache = getCacheManager().getCache(cacheName);
            cache.remove(key);
            return true;
        } catch (Exception e) {
            LOG.error("remove error :{} ", e);
            return false;
        }
    }

    /**
     * 清除缓存
     *
     * @param key   键值
     */
    public static boolean remove(String key) {
        return remove(DEFAULT_CACHE_NAME, key);
    }
}
