package com.ruoyi.common.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * HTTP请求日志注解
 *
 * @author sunhuayu
 * Date on 2019/10/23
 */
@Target({ ElementType.PARAMETER, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface HttpApiLog {
    /**
     * 接口描述
     */
    public String desc() default "HTTP统一调用接口";

    /**
     * 是否保存请求的参数
     */
    public boolean isSaveRequestData() default true;

}
