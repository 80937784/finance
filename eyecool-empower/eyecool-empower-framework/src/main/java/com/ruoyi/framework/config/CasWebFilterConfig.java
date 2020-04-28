package com.ruoyi.framework.config;

import java.util.ArrayList;
import java.util.List;

import org.jasig.cas.client.session.SingleSignOutFilter;
import org.jasig.cas.client.util.HttpServletRequestWrapperFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.neusoft.cas.AuthenticationFilter;
import com.neusoft.cas.Cas20ProxyReceivingTicketValidationFilter;

/**
 * Cas认证过滤器配置
 * 
 * @author admin 
 * @date 2019年10月8日
 */
@Configuration
public class CasWebFilterConfig {

    /**
     * 统一退出过滤器
     */
    @Bean
    public FilterRegistrationBean<SingleSignOutFilter> casSingleSignOutFilter() {
        // 创建 过滤器注册bean
        FilterRegistrationBean<SingleSignOutFilter> registrationBean = new FilterRegistrationBean<>();
        SingleSignOutFilter singleFilter = new SingleSignOutFilter();
        registrationBean.setFilter(singleFilter);
        List<String> urls = new ArrayList<>();
        urls.add("/basedata/face/collect"); // 给自助采集请求添加过滤器
        urls.add("/scene/busi/selfopen/face"); // 自助人脸认证开通或关闭请求添加过滤器
        // 设置 有效url
        registrationBean.setUrlPatterns(urls);
        return registrationBean;
    }

    /**
     * 该过滤器负责用户的认证工作，必须启用它
     */
    @Bean
    public FilterRegistrationBean<AuthenticationFilter> sduCasAuthenticationFilter() {
        // 创建 过滤器注册bean
        FilterRegistrationBean<AuthenticationFilter> registrationBean = new FilterRegistrationBean<>();
        AuthenticationFilter singleFilter = new AuthenticationFilter();
        registrationBean.setFilter(singleFilter);
        List<String> urls = new ArrayList<>();
        urls.add("/basedata/face/collect"); // 给自助采集请求添加过滤器
        urls.add("/scene/busi/selfopen/face"); // 自助人脸认证开通或关闭请求添加过滤器
        // 设置 有效url
        registrationBean.setUrlPatterns(urls);
        return registrationBean;
    }

    /**
     * 该过滤器负责对Ticket的校验工作，必须启用它
     */
    @Bean
    public FilterRegistrationBean<Cas20ProxyReceivingTicketValidationFilter> sduCasValidationFilter() {
        // 创建 过滤器注册bean
        FilterRegistrationBean<Cas20ProxyReceivingTicketValidationFilter> registrationBean = new FilterRegistrationBean<>();
        Cas20ProxyReceivingTicketValidationFilter singleFilter = new Cas20ProxyReceivingTicketValidationFilter();
        registrationBean.setFilter(singleFilter);
        List<String> urls = new ArrayList<>();
        urls.add("/basedata/face/collect"); // 给自助采集请求添加过滤器
        urls.add("/scene/busi/selfopen/face"); // 自助人脸认证开通或关闭请求添加过滤器
        // 设置 有效url
        registrationBean.setUrlPatterns(urls);
        return registrationBean;
    }

    /**
     * 过滤器负责实现HttpServletRequest请求的包裹，
     * 比如允许开发者通过HttpServletRequest的getRemoteUser()方法获得SSO登录用户的登录名，可选配置
     */
    @Bean
    public FilterRegistrationBean<HttpServletRequestWrapperFilter> casHttpServletRequestWrapperFilter() {
        // 创建 过滤器注册bean
        FilterRegistrationBean<HttpServletRequestWrapperFilter> registrationBean = new FilterRegistrationBean<>();
        HttpServletRequestWrapperFilter singleFilter = new HttpServletRequestWrapperFilter();
        registrationBean.setFilter(singleFilter);
        List<String> urls = new ArrayList<>();
        urls.add("/basedata/face/collect"); // 给自助采集请求添加过滤器
        urls.add("/scene/busi/selfopen/face"); // 自助人脸认证开通或关闭请求添加过滤器
        // 设置 有效url
        registrationBean.setUrlPatterns(urls);
        return registrationBean;
    }

}
