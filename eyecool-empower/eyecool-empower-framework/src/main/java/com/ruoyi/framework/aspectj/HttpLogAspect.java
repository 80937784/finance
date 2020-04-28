package com.ruoyi.framework.aspectj;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Date;
import java.util.concurrent.CompletableFuture;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONObject;
import com.ruoyi.common.annotation.HttpApiLog;
import com.ruoyi.common.constant.DictConstants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.http.HttpAjaxResult;
import com.ruoyi.common.core.domain.http.StandardHttpParam;
import com.ruoyi.common.exception.base.BaseException;
import com.ruoyi.common.json.JSON;
import com.ruoyi.common.utils.IdWorker;
import com.ruoyi.common.utils.ServletUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.framework.util.ShiroUtils;
import com.ruoyi.framework.web.service.DictService;
import com.ruoyi.system.domain.BaseRequestRecord;
import com.ruoyi.system.service.IBaseRequestRecordService;

/**
 * HTTP接口访问日志切面
 *
 * @author sunhuayu
 * Date on 2019/10/23
 */
@Aspect
@Component
public class HttpLogAspect {

    private static final Logger LOG = LoggerFactory.getLogger(HttpLogAspect.class);

    @Autowired
    private DictService dictService;
    @Autowired
    private IBaseRequestRecordService baseRequestRecordService;

    @Pointcut("@annotation(com.ruoyi.common.annotation.HttpApiLog)")
    public void httpLogPointCut() {
    }

    @Around(value = "httpLogPointCut()")
    public Object doAround(ProceedingJoinPoint joinPoint) {
        BaseRequestRecord baseRequestRecord = new BaseRequestRecord();
        baseRequestRecord.setReceivedTime(new Date());
        try {
            Object proceed = joinPoint.proceed();
            AjaxResult ajaxResult = (AjaxResult) proceed;
            baseRequestRecord.setResponseMsg(JSON.marshal(proceed));
            if (null != ajaxResult) {
                baseRequestRecord.setStatusCode(ajaxResult.get(AjaxResult.CODE_TAG).toString());
            } else {
                baseRequestRecord.setStatusCode(HttpAjaxResult.HTTP_SUCC_CODE);
            }
            return proceed;
        } catch (Throwable throwable) {
            LOG.error("HTTP接口异常,", throwable);
            baseRequestRecord.setResponseMsg(getExceptionInfo(throwable));
            baseRequestRecord.setStatusCode(HttpAjaxResult.HTTP_ERR_CODE);
            throw new BaseException(getExceptionInfo(throwable));
        } finally {
            String transUrl = ServletUtils.getRequest().getRequestURI();
            CompletableFuture.runAsync(() -> {
                saveLog(joinPoint, baseRequestRecord, transUrl);
            });
        }
    }

    /**
     * 执行保存日志
     * 
     * @param joinPoint
     * @param baseRequestRecord
     */
    private void saveLog(ProceedingJoinPoint joinPoint, BaseRequestRecord baseRequestRecord, String transUrl) {
        // 输出
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        HttpApiLog httpApiLog = signature.getMethod().getAnnotation(HttpApiLog.class);
        Object[] args = joinPoint.getArgs();
        StandardHttpParam httpParam = null;
        for (Object arg : args) {
            if (arg instanceof StandardHttpParam) {
                httpParam = (StandardHttpParam) arg;
                String transCode = httpParam.getTransCode();// 交易码
                baseRequestRecord.setTransCode(transCode);
                String label = dictService.getLabel(DictConstants.HTTP_INTREFACE_DICT_TYPE, transCode); // 交易标题
                baseRequestRecord.setTransTitle(label);
                break;
            }
        }
        if (httpApiLog.isSaveRequestData()) {
            try {
                String params = JSON.marshal(httpParam);
                baseRequestRecord.setRequestMsg(params);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        Date sendTime = new Date();
        baseRequestRecord.setSendTime(new Date());
        baseRequestRecord.setTimeUsed(sendTime.getTime() - baseRequestRecord.getReceivedTime().getTime());
        baseRequestRecord.setId(String.valueOf(IdWorker.getInstance().nextId()));
        baseRequestRecord.setClientIp(ShiroUtils.getIp());
        baseRequestRecord.setTransUrl(transUrl);
        baseRequestRecord.setClassMethod(signature.getDeclaringTypeName() + "." + signature.getName() + "()");
        try {
            // 如果是渠道交易，需要从bizContent中获取渠道编码
            String bizContent = httpParam.getBizContent();
            JSONObject bizContentObj = com.alibaba.fastjson.JSON.parseObject(bizContent);
            String channelCode = (String) bizContentObj.get("channelCode");
            if (StringUtils.isNotBlank(channelCode)) {
                baseRequestRecord.setChannelCode(channelCode);
            }
        } catch (Exception e) {
            LOG.error(e.getMessage(), e);
        }
        baseRequestRecordService.insertBaseRequestRecord(baseRequestRecord);
    }

    @AfterThrowing(value = "httpLogPointCut()", throwing = "e")
    public void doAfterThrowing(JoinPoint joinPoint, Exception e) {
    }

    /**
     * getExceptionInfo
     *
     * @param e
     * @return result限制长度65530，MySQL text字段长65535，防止存不进去
     */
    public static String getExceptionInfo(Throwable e) {
        StringWriter sw = null;
        PrintWriter pw = null;
        try {
            sw = new StringWriter();
            pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String result = sw.toString();
            if (StringUtils.isNotBlank(result) && result.length() > 65530) {
                result = result.substring(0, 65530);
            }
            return result;
        } finally {
            if (null != sw) {
                try {
                    sw.close();
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
            if (null != pw) {
                pw.close();
            }
        }
    }
}
