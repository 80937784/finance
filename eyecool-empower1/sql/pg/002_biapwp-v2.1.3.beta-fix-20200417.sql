-- ----------------------------
-- Git构建版本信息展示菜单
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3392, '版本信息', 1, 11, '/system/version', 'menuItem', 'C', '0', 'system:version:view', '#', 'admin', '2020-04-17 15:25:08.558894', '', NULL, '');
-- ----------------------------
-- 参数设置（平台是否开启1-N功能支持）
-- ----------------------------
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (136, '平台是否开启1-N搜索功能', 'platform.searchN.function.isOpen', 'Y', 'N', 'admin', '2020-04-17 15:23:59.386938', 'admin', '2020-04-17 15:24:04.429226', '注意：此参数值需要在初始化部署时设定，避免在平台使用过程中改动。
说明：平台是否开启1-N搜索功能（Y:开启，N：不开启）,不开启则不需要部署Datamanager和fox-minisearch微服务。');

-- ----------------------------
-- 数据一键同步到Datamanager权限按钮
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3393, '一键同步', 3028, 10, '#', 'menuItem', 'F', '0', 'basedata:personInfo:syncdata', '#', 'admin', '2020-04-20 17:45:48.760719', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3394, '一键同步', 3135, 6, '#', 'menuItem', 'F', '0', 'scene:business:syncdata', '#', 'admin', '2020-04-20 17:49:30.28039', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3395, '一键同步', 3202, 6, '#', 'menuItem', 'F', '0', 'scene:subtreasury:syncdata', '#', 'admin', '2020-04-20 17:49:52.520662', '', NULL, '');
-- ----------------------------
-- 人员实时同步参数配置
-- ----------------------------
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (137, '人员基础信息实时同步服务端地址', 'person.liveupdate.server.address', 'http://192.168.0.1:8765', 'N', 'admin', '2020-04-26 14:00:25.051992', '', NULL, '1、参数可以是http://IP:端口或者http://域名
2、服务端地址不能和客户端（边缘端）地址一样，否则会自己调用自己导致同步死循环');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (138, '人员基础信息实时同步接口AppKey', 'person.liveupdate.call.appkey', 'V6IVRgxl', 'N', 'admin', '2020-04-26 14:01:10.438588', '', NULL, 'V6IVRgxl');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (139, '人员基础信心实时同步接口AppSecrect', 'person.liveupdate.call.appsecrect', '958082f4479cab0d6f623e09809ab948c2ec8f9c', 'N', 'admin', '2020-04-26 14:01:34.023937', '', NULL, '服务端为当前客户端调用接口授权的AppSecrect');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (140, '人员基础信息实时同步客户端渠道编码', 'person.liveupdate.channelCode', 'eyecool1', 'N', 'admin', '2020-04-26 14:01:59.011366', '', NULL, '服务端为当前客户端调用接口分配的渠道编码');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (141, '人员基础信息实时同步最大更新标识', 'person.liveupdate.max.serianum', '0', 'N', 'admin', '2020-04-26 14:02:22.315699', '', NULL, '人员基础信息实时同步上一次执行后的最大更新标识，初始值为0，下一次同步会传入这个数，同步完成后自动保存当前同步的最大标识，不需要（不可以）手动修改');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (142, '人员基础信息实时同步最大更新时间', 'person.liveupdate.max.updatetime', '1970-01-01 00:00:00', 'N', 'admin', '2020-04-26 14:03:23.054173', '', NULL, '人员基础信息实时同步上一次执行后的最大更新时间，初始值为1970-01-01 00:00:00，下一次同步会传入这个数，同步完成后自动保存当前同步的最大更新时间，不需要（不可以）手动修改');
-- ----------------------------
-- 数据来源字典值配置
-- ----------------------------
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (374, 4, '实时同步', 'LIVEUPDATE', 'apply_data_source', NULL, 'primary', 'N', '0', 'admin', '2020-04-26 14:03:59.849277', '', NULL, '数据来源--实时同步');
-- ----------------------------
-- 人员基础信息实时同步定时任务
-- ----------------------------
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (17, '人员基础信息实时同步', 'DEFAULT', 'personLiveUpdateTask.execute()', '0 0 0/1 * * ? *', '1', '1', '1', 'admin', '2020-04-26 14:04:42.105694', '', NULL, '人员基础信息实时同步，暂定每小时执行一次,具体周期可以调整cron表达式修改');
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME17', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', 'false', 'true', 'false', 'false', E'\\254\\355\\000\\005sr\\000\\025org.quartz.JobDataMap\\237\\260\\203\\350\\277\\251\\260\\313\\002\\000\\000xr\\000&org.quartz.utils.StringKeyDirtyFlagMap\\202\\010\\350\\303\\373\\305](\\002\\000\\001Z\\000\\023allowsTransientDataxr\\000\\035org.quartz.utils.DirtyFlagMap\\023\\346.\\255(v\\012\\316\\002\\000\\002Z\\000\\005dirtyL\\000\\003mapt\\000\\017Ljava/util/Map;xp\\001sr\\000\\021java.util.HashMap\\005\\007\\332\\301\\303\\026`\\321\\003\\000\\002F\\000\\012loadFactorI\\000\\011thresholdxp?@\\000\\000\\000\\000\\000\\014w\\010\\000\\000\\000\\020\\000\\000\\000\\001t\\000\\017TASK_PROPERTIESsr\\000\\036com.ruoyi.quartz.domain.SysJob\\000\\000\\000\\000\\000\\000\\000\\001\\002\\000\\010L\\000\\012concurrentt\\000\\022Ljava/lang/String;L\\000\\016cronExpressionq\\000~\\000\\011L\\000\\014invokeTargetq\\000~\\000\\011L\\000\\010jobGroupq\\000~\\000\\011L\\000\\005jobIdt\\000\\020Ljava/lang/Long;L\\000\\007jobNameq\\000~\\000\\011L\\000\\015misfirePolicyq\\000~\\000\\011L\\000\\006statusq\\000~\\000\\011xr\\000''com.ruoyi.common.core.domain.BaseEntity\\000\\000\\000\\000\\000\\000\\000\\001\\002\\000\\007L\\000\\010createByq\\000~\\000\\011L\\000\\012createTimet\\000\\020Ljava/util/Date;L\\000\\006paramsq\\000~\\000\\003L\\000\\006remarkq\\000~\\000\\011L\\000\\013searchValueq\\000~\\000\\011L\\000\\010updateByq\\000~\\000\\011L\\000\\012updateTimeq\\000~\\000\\014xpt\\000\\005adminppt\\000h\\344\\272\\272\\345\\221\\230\\345\\237\\272\\347\\241\\200\\344\\277\\241\\346\\201\\257\\345\\256\\236\\346\\227\\266\\345\\220\\214\\346\\255\\245\\357\\274\\214\\346\\232\\202\\345\\256\\232\\346\\257\\217\\345\\260\\217\\346\\227\\266\\346\\211\\247\\350\\241\\214\\344\\270\\200\\346\\254\\241,\\345\\205\\267\\344\\275\\223\\345\\221\\250\\346\\234\\237\\345\\217\\257\\344\\273\\245\\350\\260\\203\\346\\225\\264cron\\350\\241\\250\\350\\276\\276\\345\\274\\217\\344\\277\\256\\346\\224\\271pppt\\000\\0011t\\000\\0170 0 0/1 * * ? *t\\000\\036personLiveUpdateTask.execute()t\\000\\007DEFAULTsr\\000\\016java.lang.Long;\\213\\344\\220\\314\\217#\\337\\002\\000\\001J\\000\\005valuexr\\000\\020java.lang.Number\\206\\254\\225\\035\\013\\224\\340\\213\\002\\000\\000xp\\000\\000\\000\\000\\000\\000\\000\\021t\\000\\036\\344\\272\\272\\345\\221\\230\\345\\237\\272\\347\\241\\200\\344\\277\\241\\346\\201\\257\\345\\256\\236\\346\\227\\266\\345\\220\\214\\346\\255\\245t\\000\\0011t\\000\\0011x\\000');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME17', 'DEFAULT', 'TASK_CLASS_NAME17', 'DEFAULT', NULL, 1587884400000, -1, 5, 'PAUSED', 'CRON', 1587881082000, 0, NULL, -1, E'\\\\x');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME17', 'DEFAULT', '0 0 0/1 * * ? *', 'Asia/Shanghai');


-- ----------------------------
-- 重置序列
-- ----------------------------
SELECT setval('sys_config_config_id_seq', 142, true);
SELECT setval('sys_menu_menu_id_seq', 3395, true);
SELECT setval('sys_job_id_seq', 17, true);
SELECT setval('sys_dict_data_id_seq', 374, true);