package com.ruoyi.system.controller;

import java.io.InputStream;
import java.util.Properties;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.core.io.support.PropertiesLoaderUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.ruoyi.common.core.controller.BaseController;

@Controller
@RequestMapping("/system/version")
public class GitBuildVersionController extends BaseController {

    private String prefix = "system/version";

    /**
     * 版本属性信息页面
     * 
     * @return
     */
    @GetMapping()
    @RequiresPermissions("system:version:view")
    public String httpTestView(ModelMap mmap) {
        Properties gitProperties = readGitProperties();
        mmap.put("gitProperties", JSON.toJSONString(gitProperties));
        return prefix + "/info";
    }

    /**
     * 获取属性
     * 
     * @return
     */
    private Properties readGitProperties() {
        InputStream inputStream = null;
        Properties properties = new Properties();
        try {
            properties = PropertiesLoaderUtils.loadAllProperties("git.properties");
            return properties;
        } catch (Exception e) {
            logger.error("get git version info fail", e);
            return properties;
        } finally {
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
            } catch (Exception e) {
                logger.error("close inputstream fail", e);
            }
        }
    }
}
