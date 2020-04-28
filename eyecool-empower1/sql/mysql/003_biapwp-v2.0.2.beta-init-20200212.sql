-- ----------------------------
-- 1、部门表添加“部门编码”字段	     
-- ----------------------------
ALTER TABLE sys_dept ADD COLUMN dept_code varchar(50)  NULL DEFAULT NULL COMMENT '部门编码' AFTER ancestors;
-- ----------------------------
-- 2、组织机构中间表    
-- ----------------------------
DROP TABLE IF EXISTS sync_office_info;
CREATE TABLE sync_office_info (
id VARCHAR ( 100 ) NOT NULL COMMENT '主键',
office_name VARCHAR ( 150 ) COMMENT '部门名称',
office_en VARCHAR ( 100 ) COMMENT '部门英文名称',
parent_id VARCHAR ( 100 ) DEFAULT '0' COMMENT '隶属部门号（默认是0）',
office_address VARCHAR ( 20 ) COMMENT '部门地址',
office_phone VARCHAR ( 11 ) COMMENT '部门联系电话',
STATUS CHAR ( 1 ) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
create_time datetime NOT NULL COMMENT '创建时间',
update_time datetime NOT NULL COMMENT '更新时间',
PRIMARY KEY ( id ) 
) ROW_FORMAT = Dynamic;
ALTER TABLE sync_office_info COMMENT '组织机构中间表';
-- ----------------------------
-- 3、组织机构菜单数据  
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3281, '部门中间表', 1, 10, '/system/office', '', 'C', '0', 'system:office:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '组织机构菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3282, '部门查询', 3281, 1, '#', '', 'F', '0', 'system:office:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
-- ----------------------------
-- 4、组织机构同步定时任务
-- ----------------------------
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME12', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C7870707070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17074000561646D696E707400013174000D3020302030202A202A203F202A74001E73796E6344657074496E666F5461736B2E6578656375746553796E63282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000000C740012E7BB84E7BB87E69CBAE69E84E5908CE6ADA574000131740001317800);
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME12', 'DEFAULT', 'TASK_CLASS_NAME12', 'DEFAULT', NULL, 1581696000000, -1, 5, 'PAUSED', 'CRON', 1581649453000, 0, NULL, -1, '');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (12, '组织机构同步', 'DEFAULT', 'syncDeptInfoTask.executeSync()', '0 0 0 * * ? *', '1', '1', '1', 'admin', '2020-02-14 11:03:07', 'admin', '2020-02-14 11:04:09', '每天凌晨00:00:00执行一次');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME12', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
-- ----------------------------
-- 5、二维码出初始化数据（人脸图像自助采集和人脸图像自助开通，具体使用时需要修改IP和端口，人脸图像自助开通还需要修改为对应的渠道） 
-- ----------------------------
INSERT INTO base_qr_code(id, scene, content, img_path, internal_pic, remark, status, create_by, update_by, create_time, update_time, batch_date) VALUES ('155935941299520', '人脸图像自助采集', 'http://192.168.63.8:8765/biapwp/basedata/face/collect', './eyecool/biapwp/basedata/qrcode/20191224/010292ca-ca74-420b-bdeb-86663c736b12.jpg', NULL, '人脸图像自助采集', '0', NULL, NULL, '2019-10-29 12:19:53', '2019-12-24 09:57:41', NULL);
INSERT INTO base_qr_code(id, scene, content, img_path, internal_pic, remark, status, create_by, update_by, create_time, update_time, batch_date) VALUES ('161675642016064', '人脸服务自助开通', 'http://192.168.63.8:8765/biapwp/scene/busi/selfopen/face?channelCode=eyecool', './eyecool/biapwp/basedata/qrcode/20200102/4604b5e7-7531-4c17-91c7-16115a2d139f.jpg', NULL, '渠道下人脸服务自助开通（签约或解约）', '0', NULL, NULL, '2020-01-02 09:19:29', '2020-01-02 09:19:43', NULL);
-- ----------------------------
-- 6、人员轨迹查看按钮（菜单权限控制）
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3283, '轨迹查看', 3028, 9, '#', 'menuItem', 'F', '0', 'basedata:personInfo:track', '#', 'admin', '2020-02-14 16:47:07', '', NULL, '');
-- ----------------------------
-- 7、初始化一个默认部门(没有分配部门的人员统一设置为默认部门,其上级部门是顶级部门)
-- ----------------------------
INSERT INTO sys_dept(dept_id, parent_id, ancestors, dept_code, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time, update_by, update_time) VALUES (99, 100, '0,100', 'default', '默认部门', 0, '眼神', '15888888888', 'eyecool@eyecool.cn', '0', '0', 'admin', '2018-03-16 11:33:00', 'admin', '2020-01-10 11:31:27');
-- ----------------------------
-- 8、修改自助采集用户和自助开通人脸服务用户的部门为默认部门
-- ----------------------------
UPDATE sys_user SET dept_id = 99 WHERE login_name = 'collect' OR login_name = 'selfopen';
-- ----------------------------
-- 9、修改超级管理员部门为默认部门
-- ----------------------------
UPDATE sys_user SET dept_id = 99 WHERE user_id = 1;

-- ----------------------------
-- 1、渠道业务表和分库业务表字段长度修改，方便添加组合唯一索引(最大767byte)     
-- ----------------------------
ALTER TABLE channel_business MODIFY COLUMN unique_id varchar(48) NOT NULL COMMENT '人员唯一标识' AFTER person_id;
ALTER TABLE channel_subtreasury_busi MODIFY COLUMN unique_id varchar(48) NOT NULL COMMENT '人员唯一标识' AFTER person_id;
ALTER TABLE channel_subtreasury_busi MODIFY COLUMN sub_treasury_code varchar(100) NOT NULL COMMENT '分库号(渠道编码_编号)' AFTER channel_id;
ALTER TABLE channel_subtreasury_busi MODIFY COLUMN sub_treasury_name varchar(100) NOT NULL COMMENT '分库名称' AFTER sub_treasury_code;
-- ----------------------------
-- 2、渠道业务表和分库业务表,添加组合唯一索引(最大767byte)
-- ----------------------------
ALTER TABLE channel_business ADD UNIQUE INDEX channelIdPersonIdUnique (channel_id, person_id);
ALTER TABLE channel_subtreasury_busi ADD UNIQUE INDEX cIdSubCodePIdUnique (channel_id,sub_treasury_code, person_id);

-- ----------------------------
-- 1、修改设备升级任务表，添加字段    
-- ----------------------------
ALTER TABLE client_upgrade_info ADD COLUMN execute_count int(11) NOT NULL DEFAULT 0 COMMENT '执行次数' AFTER upgrade_count_limit;
ALTER TABLE client_upgrade_info ADD COLUMN task_index int(11) NOT NULL COMMENT '任务排序' AFTER execute_count;
ALTER TABLE client_upgrade_info ADD COLUMN execute_result varchar(1) NOT NULL DEFAULT '1' COMMENT '执行结果(1:待执行，2：成功，3：失败，4：跳过)' AFTER task_index;
ALTER TABLE client_upgrade_info ADD COLUMN roll_back varchar(1) NOT NULL DEFAULT 'N' COMMENT '是否降级安装(Y：是，N：否)' AFTER execute_result;
ALTER TABLE client_upgrade_info ADD COLUMN status varchar(1) NOT NULL DEFAULT '0' COMMENT '任务状态(0：正常，1：停用)' AFTER roll_back;
ALTER TABLE client_upgrade_info MODIFY COLUMN upgrade_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间(如果为空，表示立即更新)' AFTER device_id;
-- ----------------------------
-- 2、修改版本信息表，删除字段
-- ----------------------------
ALTER TABLE client_version DROP COLUMN version_index;
-- ----------------------------
-- 3、字典表添加【设备升级任务结果】字典类型和数据
-- ----------------------------
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (123, '设备升级任务结果', 'device_upgrade_result', '0', 'admin', '2020-02-19 15:06:58', '', NULL, '设备升级任务结果');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (348, 1, '待执行', '1', 'device_upgrade_result', '', 'info', 'Y', '0', 'admin', '2020-02-19 15:07:49', 'admin', '2020-02-20 09:25:13', '设备升级任务结果--待执行');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (349, 2, '成功', '2', 'device_upgrade_result', NULL, 'success', 'Y', '0', 'admin', '2020-02-19 15:08:14', '', NULL, '设备升级任务结果--成功');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (350, 3, '失败', '3', 'device_upgrade_result', NULL, 'danger', 'Y', '0', 'admin', '2020-02-19 15:08:33', '', NULL, '设备升级任务结果--失败');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (351, 4, '跳过', '4', 'device_upgrade_result', NULL, 'warning', 'Y', '0', 'admin', '2020-02-19 15:08:51', '', NULL, '设备升级任务结果--跳过');

-- ----------------------------
-- 1、基础数据(人脸、指纹、虹膜)添加特征值MD5字段    
-- ----------------------------
ALTER TABLE base_person_face ADD COLUMN feature_md5 varchar(255) NULL DEFAULT NULL AFTER feature;
ALTER TABLE base_person_finger ADD COLUMN feature_md5 varchar(255) NULL DEFAULT NULL AFTER feature;
ALTER TABLE base_person_iris ADD COLUMN feature_md5 varchar(255) NULL DEFAULT NULL AFTER feature;
-- ----------------------------
-- 2、渠道参数删除参数类型字段
-- ----------------------------
ALTER TABLE channel_param DROP COLUMN param_type;
-- ----------------------------
-- 3、删除[渠道参数类型数据]字典
-- ----------------------------
DELETE FROM sys_dict_data WHERE dict_code = 289 and dict_type = 'channel_param_type';
DELETE FROM sys_dict_data WHERE dict_code = 290 and dict_type = 'channel_param_type';
DELETE FROM sys_dict_type WHERE dict_id = 114 and dict_type = 'channel_param_type';
-- ----------------------------
-- 4、修改[数据来源]字典显示样式
-- ----------------------------
UPDATE sys_dict_data SET list_class = 'warning' where dict_type = 'apply_data_source' and dict_value = 'HTTP';
UPDATE sys_dict_data SET list_class = 'success' where dict_type = 'apply_data_source' and dict_value = 'INTERFACE';


-- ----------------------------
-- 1、渠道信息表字段修改，删除接口权限控制字段
-- ----------------------------
ALTER TABLE channel_info MODIFY COLUMN enable_multi_faces varchar(1) NULL DEFAULT 'N' COMMENT '是否支持多人脸(数据字典:N-否 Y-是)' AFTER fvein_mode;
ALTER TABLE channel_info DROP COLUMN auth_interface;
-- ----------------------------
-- 2、设备升级日志表添加“升级失败原因”字段
-- ----------------------------
ALTER TABLE client_upgrade_log ADD COLUMN fail_reason varchar(500) NULL DEFAULT NULL COMMENT '失败原因' AFTER time_used;


-- ----------------------------
-- 1、微信信息发送增加字段，保存消息类型和模版id
-- ----------------------------
ALTER TABLE wx_message_send ADD COLUMN message_type char(1) NOT NULL COMMENT '消息类型，1：普通信息；2:模版信息' AFTER err_msg;
ALTER TABLE wx_message_send ADD COLUMN template_id varchar(50) NULL DEFAULT NULL COMMENT '模版id' AFTER message_type;
ALTER TABLE wx_message_send ADD COLUMN redirect_url  varchar(255) NULL DEFAULT NULL COMMENT '信息重定向url' AFTER template_id;
ALTER TABLE wx_user_info ADD COLUMN phone varchar(48) DEFAULT NULL COMMENT '微信绑定手机号' AFTER wx_app_id;
ALTER TABLE wx_user_info ADD COLUMN channel_id varchar(48) DEFAULT NULL COMMENT '场景id' AFTER phone;

-- ----------------------------
-- 2、新增微信公众号配置表
-- ----------------------------
CREATE TABLE wx_public_configure  (
  id varchar(50) NOT NULL COMMENT '主键',
  public_name varchar(50) NOT NULL COMMENT '微信公众号名称',
  app_id varchar(500) NOT NULL COMMENT '微信服务appId',
  app_secret varchar(500) NOT NULL COMMENT '微信服务appSecret',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '微信公众号配置';

-- ----------------------------
-- 3、新增微信模版表
-- ----------------------------
CREATE TABLE wx_message_template  (
  id varchar(50) NOT NULL COMMENT '主键',
  template_id varchar(50) NOT NULL COMMENT '微信模版id',
  template_content varchar(500) NOT NULL COMMENT '微信模版',
  app_id varchar(500) NOT NULL COMMENT '微信服务appId',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '微信模版配置';
    
-- ----------------------------
-- 4、SQL菜单和按钮
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3284, '微信公众号配置', 3001, 1, '/wechat/configure', '', 'C', '0', 'wechat:configure:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '微信公众号配置菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3285, '微信公众号配置查询', 3284, 1, '#', '', 'F', '0', 'wechat:configure:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3286, '微信公众号配置新增', 3284, 2, '#', '', 'F', '0', 'wechat:configure:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3287, '微信公众号配置修改', 3284, 3, '#', '', 'F', '0', 'wechat:configure:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3288, '微信公众号配置删除', 3284, 4, '#', '', 'F', '0', 'wechat:configure:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3289, '微信公众号配置导出', 3284, 5, '#', '', 'F', '0', 'wechat:configure:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3290, '微信公众号模版配置', 3001, 1, '/wechat/template', '', 'C', '0', 'wechat:template:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '微信公众号模版菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3291, '微信公众号模版查询', 3290, 1, '#', '', 'F', '0', 'wechat:template:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3292, '微信公众号模版新增', 3290, 2, '#', '', 'F', '0', 'wechat:template:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3293, '微信公众号模版修改', 3290, 3, '#', '', 'F', '0', 'wechat:template:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3294, '微信公众号模版删除', 3290, 4, '#', '', 'F', '0', 'wechat:template:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3295, '微信公众号模版导出', 3290, 5, '#', '', 'F', '0', 'wechat:template:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
