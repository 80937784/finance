package com.ruoyi.api;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import com.alibaba.fastjson.JSON;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.common.core.domain.http.StandardHttpParam;
import com.ruoyi.common.utils.http.HttpClientUtil;
import com.ruoyi.common.utils.security.Md5Utils;

/**
 * 标准HTTP请求客户端测试
 * 
 * @author admin 
 * @date 2019年11月7日
 */
public class StandardHttpClientTest {

    public static final String APP_KEY = "viMX8bAn";
    public static final String APP_SECRECT = "9ad4e9b2739c7cf69ee0b1c7c3ff28cdd6fb9cb4";

    @Test
    public final void testMockMvc() throws Exception {
        StandardHttpParam httpParam = new StandardHttpParam();
        httpParam.setAppKey(APP_KEY);
        httpParam.setNonce(String.valueOf(new Date().getTime()));
        httpParam.setTimestamp(String.valueOf(new Date().getTime()));
        httpParam.setTransCode("PERSON_INFO_DELETE");
        httpParam.setSign(generateSign(httpParam, APP_SECRECT));
        Map<String, Object> bizContentMap = new HashMap<String, Object>();
        bizContentMap.put("uniqueId", "20190004");
        httpParam.setBizContent(JSON.toJSONString(bizContentMap));
        // 转换为JSON
        String requestJson = new ObjectMapper().writeValueAsString(httpParam);
        String url = "http://localhost:8765//biapwp/api/standard/";
        String res = HttpClientUtil.doPostJson(url, requestJson);
        System.err.println(res);
    }

    /**
     * 服务端生成签名, 使用公共参数即可
     * 
     * @return
     */
    private String generateSign(StandardHttpParam httpParam, String appSecrect) {
        String appKey = httpParam.getAppKey();
        String timestamp = httpParam.getTimestamp();
        String transCode = httpParam.getTransCode();
        String nonce = httpParam.getNonce();
        // 源字符串拼接,按照请求参数名的字母升序排列非空请求参数(appkey->nonce->timestamp->transCode)
        String originalSignStr = "appkey=" + appKey + "&nonce=" + nonce + "&timestamp=" + timestamp + "&transCode=" + transCode;
        // 拼接appSecrect
        originalSignStr = originalSignStr + "&appSecrect=" + appSecrect;
        // 进行MD5加密并转为大写
        String md5 = Md5Utils.hash(originalSignStr);
        return md5.toUpperCase();
    }

}
