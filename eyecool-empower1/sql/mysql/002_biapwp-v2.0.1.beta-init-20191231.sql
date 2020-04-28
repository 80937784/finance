/*==============================================================*/
/* Table: 设备信息表                                        							*/
/*==============================================================*/
DROP TABLE IF EXISTS client_device_info;
CREATE TABLE client_device_info (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
device_name VARCHAR ( 255 ) NOT NULL COMMENT '设备名称',
device_no VARCHAR ( 48 ) NOT NULL COMMENT '设备编号',
device_addr VARCHAR ( 255 ) COMMENT '设备安装地点',
device_type VARCHAR ( 3 ) COMMENT '设备类型(字典数据)',
device_ip VARCHAR ( 48 ) COMMENT '设备IP',
device_port INT COMMENT '设备端口',
device_mac VARCHAR ( 48 ) COMMENT '设备Mac',
ext_info VARCHAR ( 4000 ) COMMENT '设备扩展信息',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE client_device_info COMMENT '设备信息表';


/*==============================================================*/
/* Table: 版本信息表		                                        */
/*==============================================================*/
DROP TABLE IF	EXISTS client_version;
CREATE TABLE client_version (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
app_name VARCHAR ( 48 ) NOT NULL COMMENT 'APP名',
version VARCHAR ( 48 ) NOT NULL COMMENT '版本号',
version_index INT NOT NULL COMMENT '版本排序(最新版本序号最大)',
description VARCHAR ( 255 ) COMMENT '版本描述',
path VARCHAR ( 255 ) NOT NULL COMMENT '升级文件',
size BIGINT NOT NULL COMMENT '版本大小(B)',
type CHAR ( 1 ) NOT NULL COMMENT '版本类型(0：全量，1：增量)',
filename VARCHAR ( 255 ) NOT NULL COMMENT '源文件名',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE client_version COMMENT '版本信息表';


/*==============================================================*/
/* Table: 升级任务表			                                    */
/*==============================================================*/
DROP TABLE IF	EXISTS client_upgrade_info;
CREATE TABLE client_upgrade_info (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
version_id VARCHAR ( 48 ) NOT NULL COMMENT '版本主键',
device_id VARCHAR ( 48 ) NOT NULL COMMENT '设备主键',
upgrade_time VARCHAR ( 255 ) COMMENT '更新时间(如果为空，表示立即升级,如果非空，指定时间段yyyy-mm-dd HH24:MM:SS)',
upgrade_count_limit INT NOT NULL COMMENT '升级次数上限',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE client_upgrade_info COMMENT '升级任务表';


/*==============================================================*/
/* Table: 升级日志表			                                    */
/*==============================================================*/
DROP TABLE IF EXISTS client_upgrade_log;
CREATE TABLE client_upgrade_log (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
version_id VARCHAR ( 48 ) NOT NULL COMMENT '版本主键',
device_id VARCHAR ( 48 ) NOT NULL COMMENT '设备主键',
upgrade_info_id VARCHAR ( 48 ) NOT NULL COMMENT '升级任务主键',
before_app_name VARCHAR ( 48 ) COMMENT '升级前APP名',
after_app_name VARCHAR ( 48 ) NOT NULL COMMENT '升级后APP名',
device_name VARCHAR ( 255 ) COMMENT '设备名称',
device_no VARCHAR ( 48 ) NOT NULL COMMENT '设备编号',
before_version VARCHAR ( 48 ) COMMENT '升级前版本',
after_version VARCHAR ( 48 ) NOT NULL COMMENT '升级后版本',
upgrade_status CHAR ( 1 ) NOT NULL COMMENT '更新状态(1:待下载，2：待更新，3：更新成功，4：更新失败，5：跳过)',
client_time datetime COMMENT '升级时前端时间',
server_time datetime COMMENT '升级时后端时间',
time_used INT COMMENT '升级耗时(单位s)',
create_time datetime COMMENT '创建时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE client_upgrade_log COMMENT '升级日志表';


ALTER TABLE client_version MODIFY COLUMN version_index int(255) NOT NULL AFTER version;
ALTER TABLE client_upgrade_log MODIFY COLUMN device_no varchar(48) NOT NULL COMMENT '设备编号' AFTER device_name;

-- ----------------------------
-- 1、系统配置表[sys_config]初始化数据
-- ----------------------------
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (129, '自助签约默认登录用户密码', 'busi.self.open.login.pwd', 'selfopen', 'N', 'admin', '2019-12-26 11:48:18', '', NULL, '自助签约默认登录用户密码');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (130, '指纹入库是否进行1-N校验', 'basedata.finger.add.isValidN', 'N', 'N', 'admin', '2019-12-26 14:42:48', 'admin', '2019-12-26 14:43:30', '指纹入库是否进行1-N校验(Y/N)， 用于新增、修改');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (131, '虹膜入库是否进行1-N校验', 'basedata.iris.add.isValidN', 'N', 'N', 'admin', '2019-12-26 14:43:13', 'admin', '2019-12-26 14:43:47', '虹膜入库是否进行1-N校验(Y/N)， 用于新增、修改');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (132, '设备APP版本文件存放文件夹', 'device.version.file.dir', './eyecool/device/version/', 'N', 'admin', '2019-12-27 13:30:34', '', NULL, '设备APP版本文件存放文件夹');

-- ----------------------------
-- 2、字典类型表[sys_dict_type]初始化数据(设备管理)
-- ----------------------------
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (120, '前端设备APP版本类型', 'app_version_type', '0', 'admin', '2019-12-27 12:09:48', '', NULL, '前端设备APP版本类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (121, '设备类型', 'client_device_type', '0', 'admin', '2019-12-27 16:15:32', '', NULL, '设备类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (122, '设备升级状态', 'device_upgrade_status', '0', 'admin', '2019-12-30 13:47:16', '', NULL, '设备升级状态');

-- ----------------------------
-- 3、字典数据表[sys_dict_data]初始化数据(设备管理)
-- ----------------------------
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (337, 1, '全量', '0', 'app_version_type', NULL, 'primary', 'Y', '0', 'admin', '2019-12-27 12:10:43', '', NULL, '前端设备APP版本类型--全量');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (338, 2, '增量', '1', 'app_version_type', NULL, 'success', 'N', '0', 'admin', '2019-12-27 12:11:02', '', NULL, '前端设备APP版本类型--增量');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (340, 1, '待下载', '1', 'device_upgrade_status', '', 'info', 'Y', '0', 'admin', '2019-12-30 13:47:49', 'admin', '2019-12-30 13:51:22', '设备升级状态--待下载');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (341, 2, '待更新', '2', 'device_upgrade_status', '', 'primary', 'N', '0', 'admin', '2019-12-30 13:48:11', 'admin', '2019-12-30 13:49:30', '设备升级状态--待更新');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (342, 3, '更新成功', '3', 'device_upgrade_status', NULL, 'success', 'N', '0', 'admin', '2019-12-30 13:49:57', '', NULL, '设备升级状态--更新成功');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (343, 4, '更新失败', '4', 'device_upgrade_status', NULL, 'danger', 'N', '0', 'admin', '2019-12-30 13:50:23', '', NULL, '设备升级状态--更新失败');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (344, 5, '跳过', '5', 'device_upgrade_status', NULL, 'warning', 'N', '0', 'admin', '2019-12-30 13:51:06', '', NULL, '设备升级状态--跳过');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (345, 28, '设备版本更新信号接口', 'CLIENT_UPGRADE_SIGNAL', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-12-31 17:27:54', '', NULL, 'HTTP交易接口--设备版本更新信号接口（是否需要更新）');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (346, 29, '设备版本下载接口', 'CLIENT_VERSION_DOWNLOAD', 'http_interface', '', '', 'N', '0', 'admin', '2019-12-31 17:28:40', 'admin', '2019-12-31 17:28:47', 'HTTP交易接口--设备版本下载接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (347, 30, '设备版本更新结果回写', 'CLIENT_UPGRADE_RESULT_BAK', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-12-31 17:30:04', '', NULL, 'HTTP交易接口--设备版本更新结果回写');


-- ----------------------------
-- 4、菜单表[sys_menu]初始化数据(设备管理和自助签约)
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3208, '自助签约', 6, 7, '/scene/busi/selfopen/face?channelCode=eyecool', 'menuItem', 'C', '1', '', '#', 'admin', '2019-12-26 11:10:59', 'admin', '2019-12-26 12:19:16', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3209, '保存自助签约', 3208, 1, '#', 'menuItem', 'F', '0', 'scene:busi:selfopen:save', '#', 'admin', '2019-12-26 11:36:11', 'admin', '2019-12-26 11:41:36', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3210, '版本信息', 3216, 1, '/client/version', 'menuItem', 'C', '0', 'client:version:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-12-27 11:39:47', '版本信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3211, '版本信息查询', 3210, 1, '#', '', 'F', '0', 'client:version:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3212, '版本信息新增', 3210, 2, '#', '', 'F', '0', 'client:version:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3213, '版本信息修改', 3210, 3, '#', '', 'F', '0', 'client:version:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3214, '版本信息删除', 3210, 4, '#', '', 'F', '0', 'client:version:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3215, '版本信息导出', 3210, 5, '#', '', 'F', '0', 'client:version:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3216, '设备管理', 0, 8, '#', 'menuItem', 'M', '0', '', 'fa fa-gears', 'admin', '2019-12-27 11:37:32', 'admin', '2019-12-27 11:38:58', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3217, '设备信息', 3216, 1, '/client/device', 'menuItem', 'C', '0', 'client:device:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-12-27 15:59:57', '设备信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3218, '设备信息查询', 3217, 1, '#', '', 'F', '0', 'client:device:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3219, '设备信息新增', 3217, 2, '#', '', 'F', '0', 'client:device:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3220, '设备信息修改', 3217, 3, '#', '', 'F', '0', 'client:device:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3221, '设备信息删除', 3217, 4, '#', '', 'F', '0', 'client:device:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3222, '设备信息导出', 3217, 5, '#', '', 'F', '0', 'client:device:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3223, '升级任务', 3216, 1, '/client/upgradeInfo', 'menuItem', 'C', '0', 'client:upgradeInfo:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-12-27 17:05:26', '升级任务菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3224, '升级任务查询', 3223, 1, '#', '', 'F', '0', 'client:upgradeInfo:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3225, '升级任务新增', 3223, 2, '#', '', 'F', '0', 'client:upgradeInfo:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3226, '升级任务修改', 3223, 3, '#', '', 'F', '0', 'client:upgradeInfo:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3227, '升级任务删除', 3223, 4, '#', '', 'F', '0', 'client:upgradeInfo:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3228, '升级任务导出', 3223, 5, '#', '', 'F', '0', 'client:upgradeInfo:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3229, '升级日志', 3216, 1, '/client/upgradeLog', 'menuItem', 'C', '0', 'client:upgradeLog:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-12-30 13:37:48', '升级日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3230, '升级日志查询', 3229, 1, '#', '', 'F', '0', 'client:upgradeLog:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3231, '升级日志删除', 3229, 2, '#', '', 'F', '0', 'client:upgradeLog:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3232, '升级日志导出', 3229, 3, '#', '', 'F', '0', 'client:upgradeLog:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_role(role_id, role_name, role_key, role_sort, data_scope, status, del_flag, create_by, create_time, update_by, update_time, remark) VALUES (101, '自助签约', 'selfsign', 4, '1', '0', '0', 'admin', '2019-12-26 11:34:49', 'admin', '2019-12-26 11:43:25', '渠道业务自助签约');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3233, '生成请求唯一码', 3199, 2, '#', 'menuItem', 'F', '0', 'tools:interface:getNonce', '#', 'admin', '2020-01-02 17:31:04', '', NULL, '');
UPDATE sys_menu SET menu_name = '动态人脸', parent_id = 0, order_num = 9, url = '#', target = 'menuItem', menu_type = 'M', visible = '0', perms = '', icon = 'fa fa-user', create_by = 'admin', create_time = '2019-10-10 09:39:32', update_by = 'admin', update_time = '2019-12-27 11:39:17', remark = '动态人脸' WHERE menu_id = 7;

-- ----------------------------
-- 4、自助签约角色用户相关
-- ----------------------------
INSERT INTO sys_role_menu(role_id, menu_id) VALUES (101, 6);
INSERT INTO sys_role_menu(role_id, menu_id) VALUES (101, 3208);
INSERT INTO sys_role_menu(role_id, menu_id) VALUES (101, 3209);
INSERT INTO sys_user(user_id, dept_id, login_name, user_name, user_type, email, phonenumber, sex, avatar, password, salt, status, del_flag, login_ip, login_date, create_by, create_time, update_by, update_time, remark) VALUES (104, 103, 'selfopen', '自助签约', '00', 'selfopen@eyecool.cn', '13000000001', '0', '', '8141d10f763e5ae3734960ed9fc5b37f', 'c6fd88', '0', '0', '192.168.60.137', '2019-12-26 11:47:41', 'admin', '2019-12-26 11:44:54', 'admin', '2019-12-26 11:49:38', '');
INSERT INTO sys_user_role(user_id, role_id) VALUES (104, 101);


/*==============================================================*/
/* Table: 人员人脸比对历史日志表                          						*/
/*==============================================================*/
DROP TABLE IF EXISTS person_face_match_his_log;
CREATE TABLE person_face_match_his_log (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
handle_seq VARCHAR ( 48 ) NOT NULL COMMENT '平台流水号',
received_seq VARCHAR ( 48 ) NOT NULL COMMENT '业务流水号',
unique_id VARCHAR ( 48 ) COMMENT '人员标识',
dept_id BIGINT ( 20 ) COMMENT '部门ID',
channel_code VARCHAR ( 255 ) COMMENT '渠道编码',
scene_image VARCHAR ( 255 ) NOT NULL COMMENT '现场照路径',
online_image VARCHAR ( 255 ) COMMENT '联网核查照路径',
chip_image VARCHAR ( 255 ) COMMENT '芯片照路径',
stock_image VARCHAR ( 255 ) COMMENT '底库照路径',
scene_online_score DOUBLE COMMENT '现场照与联网核查照比对分值',
scene_chip_score DOUBLE COMMENT '现场照与芯片照比对分值',
scene_stock_score DOUBLE COMMENT '现场照与库底库照比对分值',
online_chip_score DOUBLE COMMENT '联网核查照与芯片照比对分值',
scene_online_result VARCHAR ( 1 ) COMMENT '现场照与联网核查照比对结果(0通过，1未通过)',
scene_chip_result VARCHAR ( 1 ) COMMENT '现场照与芯片照比对结果(0通过，1未通过)',
scene_stock_result VARCHAR ( 1 ) COMMENT '现场照与库底库照比对结果(0通过，1未通过)',
online_chip_result VARCHAR ( 1 ) COMMENT '联网核查照与芯片照比对结果(0通过，1未通过)',
checklive_result VARCHAR ( 1 ) COMMENT '现场照件检活结果(0通过，1未通过)',
result VARCHAR ( 1 ) COMMENT '比对结果(0通过，1未通过)',
broker VARCHAR ( 48 ) COMMENT '交易发起人',
received_time datetime COMMENT '请求时间',
time_used BIGINT ( 20 ) COMMENT '耗时(ms)',
server_id VARCHAR ( 255 ) COMMENT '服务器标识',
vendor_code VARCHAR ( 255 ) COMMENT '厂商',
algs_version VARCHAR ( 255 ) COMMENT '算法版本',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
create_time datetime COMMENT '创建时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE person_face_match_his_log COMMENT '人员人脸比对历史日志表';


/*==============================================================*/
/* Table: 人员人脸搜索历史日志表		                            */
/*==============================================================*/
DROP TABLE IF EXISTS person_face_search_his_log;
CREATE TABLE person_face_search_his_log (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
handle_seq VARCHAR ( 48 ) NOT NULL COMMENT '平台流水号',
received_seq VARCHAR ( 48 ) NOT NULL COMMENT '业务流水号',
scene_type VARCHAR ( 1 ) NOT NULL COMMENT '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N，3：子系统日志回传)',
unique_id VARCHAR ( 48 ) COMMENT '人员标识',
dept_id BIGINT ( 20 ) COMMENT '部门ID',
channel_code VARCHAR ( 255 ) COMMENT '渠道编码',
sub_treasury_code VARCHAR ( 255 ) COMMENT '分库编码',
sub_treasury_name VARCHAR ( 255 ) COMMENT '分库名称',
scene_image VARCHAR ( 255 ) NOT NULL COMMENT '现场照路径',
stock_image VARCHAR ( 255 ) COMMENT '底库照路径',
take_photo1 VARCHAR ( 255 ) COMMENT '抓拍图1路径',
take_photo2 VARCHAR ( 255 ) COMMENT '抓拍图2路径',
scene_stock_score DOUBLE COMMENT '分值',
checklive_result VARCHAR ( 1 ) COMMENT '现场照件检活结果(0通过，1未通过)',
result VARCHAR ( 1 ) COMMENT '结果(0通过，1未通过)',
broker VARCHAR ( 48 ) COMMENT '交易发起人',
device_code VARCHAR ( 255 ) COMMENT '设备编码',
device_name VARCHAR ( 255 ) COMMENT '设备名称',
device_ip VARCHAR ( 255 ) COMMENT '设备IP',
received_time datetime COMMENT '请求时间',
time_used BIGINT ( 20 ) COMMENT '耗时(ms)',
server_id VARCHAR ( 255 ) COMMENT '服务器标识',
vendor_code VARCHAR ( 255 ) COMMENT '厂商',
algs_version VARCHAR ( 255 ) COMMENT '算法版本',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
create_time datetime COMMENT '创建时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE person_face_search_his_log COMMENT '人员人脸搜索历史日志表';


/*==============================================================*/
/* Table:人员指纹搜索历史日志表 				                    */
/*==============================================================*/
DROP TABLE IF	EXISTS person_finger_search_his_log;
CREATE TABLE person_finger_search_his_log (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
handle_seq VARCHAR ( 48 ) NOT NULL COMMENT '平台流水号',
received_seq VARCHAR ( 48 ) NOT NULL COMMENT '业务流水号',
scene_type VARCHAR ( 1 ) NOT NULL COMMENT '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N)',
unique_id VARCHAR ( 48 ) COMMENT '人员标识',
dept_id BIGINT ( 20 ) COMMENT '部门ID',
channel_code VARCHAR ( 255 ) COMMENT '渠道编码',
sub_treasury_code VARCHAR ( 255 ) COMMENT '分库编码',
sub_treasury_name VARCHAR ( 255 ) COMMENT '分库名称',
finger_no VARCHAR ( 2 ) COMMENT '手指编码',
scene_image VARCHAR ( 255 ) NOT NULL COMMENT '现场照路径',
stock_image VARCHAR ( 255 ) COMMENT '底库照路径',
scene_stock_score DOUBLE COMMENT '分值',
result VARCHAR ( 1 ) COMMENT '结果(0通过，1未通过)',
broker VARCHAR ( 48 ) COMMENT '交易发起人',
received_time datetime COMMENT '请求时间',
time_used BIGINT ( 20 ) COMMENT '耗时(ms)',
server_id VARCHAR ( 255 ) COMMENT '服务器标识',
vendor_code VARCHAR ( 255 ) COMMENT '厂商',
algs_version VARCHAR ( 255 ) COMMENT '算法版本',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
create_time datetime COMMENT '创建时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE person_finger_search_his_log COMMENT '人员指纹搜索历史日志表';



/*==============================================================*/
/* Table:人员指纹比对历史日志表		                            */
/*==============================================================*/
DROP TABLE IF EXISTS person_finger_match_his_log;
CREATE TABLE person_finger_match_his_log (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
handle_seq VARCHAR ( 48 ) NOT NULL COMMENT '平台流水号',
received_seq VARCHAR ( 48 ) NOT NULL COMMENT '业务流水号',
unique_id VARCHAR ( 48 ) COMMENT '人员标识',
dept_id BIGINT ( 20 ) COMMENT '部门ID',
channel_code VARCHAR ( 255 ) COMMENT '渠道编码',
finger_no VARCHAR ( 2 ) COMMENT '手指编码',
scene_image VARCHAR ( 255 ) NOT NULL COMMENT '现场照路径',
stock_image VARCHAR ( 255 ) COMMENT '底库照路径',
scene_stock_score DOUBLE COMMENT '现场照与库底库照比对分值',
scene_stock_result VARCHAR ( 1 ) COMMENT '现场照与库底库照比对结果(0通过，1未通过)',
result VARCHAR ( 1 ) COMMENT '比对结果(0通过，1未通过)',
broker VARCHAR ( 48 ) COMMENT '交易发起人',
received_time datetime COMMENT '请求时间',
time_used BIGINT ( 20 ) COMMENT '耗时(ms)',
server_id VARCHAR ( 255 ) COMMENT '服务器标识',
vendor_code VARCHAR ( 255 ) COMMENT '厂商',
algs_version VARCHAR ( 255 ) COMMENT '算法版本',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
create_time datetime COMMENT '创建时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE person_finger_match_his_log COMMENT '人员指纹比对历史日志表';


/*==============================================================*/ 
/* Table: 人员虹膜比对历史日志表 		                            */
/*==============================================================*/
DROP TABLE IF EXISTS person_iris_match_his_log;
CREATE TABLE person_iris_match_his_log (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
handle_seq VARCHAR ( 48 ) NOT NULL COMMENT '平台流水号',
received_seq VARCHAR ( 48 ) NOT NULL COMMENT '业务流水号',
unique_id VARCHAR ( 48 ) COMMENT '人员标识',
dept_id BIGINT ( 20 ) COMMENT '部门ID',
channel_code VARCHAR ( 255 ) COMMENT '渠道编码',
scene_left_image VARCHAR ( 255 ) COMMENT '现场左眼照路径',
scene_right_image VARCHAR ( 255 ) COMMENT '现场右眼照路径',
stock_left_image VARCHAR ( 255 ) COMMENT '底库左眼照路径',
stock_right_image VARCHAR ( 255 ) COMMENT '底库右眼照路径',
scene_lstock_score DOUBLE COMMENT '左眼现场照与库底库照比对分值',
scene_lstock_result VARCHAR ( 1 ) COMMENT '左眼现场照与库底库照比对结果(0通过，1未通过)',
scene_rstock_score DOUBLE COMMENT '右眼现场照与库底库照比对分值',
scene_rstock_result VARCHAR ( 1 ) COMMENT '右眼现场照与库底库照比对结果(0通过，1未通过)',
result VARCHAR ( 1 ) COMMENT '比对结果(0通过，1未通过)',
result_strategy VARCHAR ( 1 ) COMMENT '结果策略(1:与， 2:或)',
broker VARCHAR ( 48 ) COMMENT '交易发起人',
received_time datetime COMMENT '请求时间',
time_used BIGINT ( 20 ) COMMENT '耗时(ms)',
server_id VARCHAR ( 255 ) COMMENT '服务器标识',
vendor_code VARCHAR ( 255 ) COMMENT '厂商',
algs_version VARCHAR ( 255 ) COMMENT '算法版本',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
create_time datetime COMMENT '创建时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE person_iris_match_his_log COMMENT '人员虹膜比对历史日志表';


/*==============================================================*/ 
/* Table: 人员虹膜搜索历史日志表		                            */
/*==============================================================*/
DROP TABLE IF EXISTS person_iris_search_his_log;
CREATE TABLE person_iris_search_his_log (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
handle_seq VARCHAR ( 48 ) NOT NULL COMMENT '平台流水号',
received_seq VARCHAR ( 48 ) NOT NULL COMMENT '业务流水号',
scene_type VARCHAR ( 1 ) NOT NULL COMMENT '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N)',
unique_id VARCHAR ( 48 ) COMMENT '人员标识',
dept_id BIGINT ( 20 ) COMMENT '部门ID',
channel_code VARCHAR ( 255 ) COMMENT '渠道编码',
sub_treasury_code VARCHAR ( 255 ) COMMENT '分库编码',
sub_treasury_name VARCHAR ( 255 ) COMMENT '分库名称',
scene_left_image VARCHAR ( 255 ) COMMENT '现场左眼照路径',
scene_right_image VARCHAR ( 255 ) COMMENT '现场右眼照路径',
stock_left_image VARCHAR ( 255 ) COMMENT '底库左眼照路径',
stock_right_image VARCHAR ( 255 ) COMMENT '底库右眼照路径',
scene_lstock_score DOUBLE COMMENT '左眼现场照与库底库照比对分值',
scene_lstock_result VARCHAR ( 1 ) COMMENT '左眼现场照与库底库照比对结果(0通过，1未通过)',
scene_rstock_score DOUBLE COMMENT '右眼现场照与库底库照比对分值',
scene_rstock_result VARCHAR ( 1 ) COMMENT '右眼现场照与库底库照比对结果(0通过，1未通过)',
result VARCHAR ( 1 ) COMMENT '结果(0通过，1未通过)',
result_strategy VARCHAR ( 1 ) COMMENT '结果策略(1:与， 2:或)',
broker VARCHAR ( 48 ) COMMENT '交易发起人',
received_time datetime COMMENT '请求时间',
time_used BIGINT ( 20 ) COMMENT '耗时(ms)',
server_id VARCHAR ( 255 ) COMMENT '服务器标识',
vendor_code VARCHAR ( 255 ) COMMENT '厂商',
algs_version VARCHAR ( 255 ) COMMENT '算法版本',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
create_time datetime COMMENT '创建时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE person_iris_search_his_log COMMENT '人员虹膜搜索历史日志表';

-- ----------------------------
-- 1、菜单表[sys_menu]初始化数据(比对搜索历史日志)
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3234, '历史日志', 6, 6, '#', 'menuItem', 'M', '0', NULL, '#', 'admin', '2020-01-06 15:27:56', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3239, '人脸比对历史日志', 3234, 1, '/hislog/faceMatch', '', 'C', '0', 'hislog:faceMatch:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '人脸比对历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3240, '人脸比对历史日志查询', 3239, 1, '#', '', 'F', '0', 'hislog:faceMatch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3241, '人脸比对历史日志删除', 3239, 2, '#', '', 'F', '0', 'hislog:faceMatch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3242, '人脸比对历史日志导出', 3239, 3, '#', '', 'F', '0', 'hislog:faceMatch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3243, '人脸比对历史日志详细', 3239, 4, '#', 'menuItem', 'F', '0', 'hislog:faceMatch:detail', '#', 'admin', '2020-01-06 15:40:16', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3244, '指纹搜索历史日志', 3234, 4, '/hislog/fingerSearch', 'menuItem', 'C', '0', 'hislog:fingerSearch:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-01-06 16:33:29', '指纹搜索历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3245, '指纹搜索历史日志查询', 3244, 1, '#', '', 'F', '0', 'hislog:fingerSearch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3246, '指纹搜索历史日志删除', 3244, 2, '#', '', 'F', '0', 'hislog:fingerSearch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3247, '指纹搜索历史日志导出', 3244, 3, '#', '', 'F', '0', 'hislog:fingerSearch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3248, '指纹搜索历史日志修改', 3244, 4, '#', '', 'F', '0', 'hislog:fingerSearch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3249, '人脸搜索历史日志', 3234, 2, '/hislog/faceSearch', '', 'C', '0', 'hislog:faceSearch:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '人脸搜索历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3250, '人脸搜索历史日志查询', 3249, 1, '#', '', 'F', '0', 'hislog:faceSearch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3251, '人脸搜索历史日志删除', 3249, 2, '#', '', 'F', '0', 'hislog:faceSearch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3252, '人脸搜索历史日志导出', 3249, 3, '#', '', 'F', '0', 'hislog:faceSearch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3253, '人脸搜索历史日志详细', 3249, 4, '#', '', 'F', '0', 'hislog:faceSearch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3254, '指纹比对历史日志', 3234, 3, '/hislog/fingerMatch', '', 'C', '0', 'hislog:fingerMatch:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '指纹比对历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3255, '指纹比对历史日志查询', 3254, 1, '#', '', 'F', '0', 'hislog:fingerMatch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3256, '指纹比对历史日志删除', 3254, 2, '#', '', 'F', '0', 'hislog:fingerMatch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3257, '指纹比对历史日志导出', 3254, 3, '#', '', 'F', '0', 'hislog:fingerMatch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3258, '指纹比对历史日志详细', 3254, 4, '#', '', 'F', '0', 'hislog:fingerMatch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3259, '虹膜比对历史日志', 3234, 5, '/hislog/irisMatch', '', 'C', '0', 'hislog:irisMatch:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '虹膜比对历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3260, '虹膜比对历史日志查询', 3259, 1, '#', '', 'F', '0', 'hislog:irisMatch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3261, '虹膜比对历史日志删除', 3259, 2, '#', '', 'F', '0', 'hislog:irisMatch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3262, '虹膜比对历史日志导出', 3259, 3, '#', '', 'F', '0', 'hislog:irisMatch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3263, '虹膜比对历史日志详细', 3259, 4, '#', '', 'F', '0', 'hislog:irisMatch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3264, '虹膜搜索历史日志', 3234, 6, '/hislog/irisSearch', '', 'C', '0', 'hislog:irisSearch:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '虹膜搜索历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3265, '虹膜搜索历史日志查询', 3264, 1, '#', '', 'F', '0', 'hislog:irisSearch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3266, '虹膜搜索历史日志删除', 3264, 2, '#', '', 'F', '0', 'hislog:irisSearch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3267, '虹膜搜索历史日志导出', 3264, 3, '#', '', 'F', '0', 'hislog:irisSearch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3268, '虹膜搜索历史日志详细', 3264, 4, '#', '', 'F', '0', 'hislog:irisSearch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
UPDATE sys_menu SET menu_name = '场景接入', parent_id = 0, order_num = 6, url = '#', target = '', menu_type = 'M', visible = '0', perms = NULL, icon = 'fa fa-database', create_by = 'admin', create_time = '2019-10-16 16:51:24', update_by = '', update_time = NULL, remark = '场景接入目录' WHERE menu_id = 6;
UPDATE sys_menu SET menu_name = '比对操作', parent_id = 6, order_num = 7, url = '#', target = 'menuItem', menu_type = 'M', visible = '0', perms = '', icon = '#', create_by = 'admin', create_time = '2019-11-29 13:19:07', update_by = 'admin', update_time = '2020-01-06 15:28:15', remark = '' WHERE menu_id = 3178;
UPDATE sys_menu SET menu_name = '自助签约', parent_id = 6, order_num = 8, url = '/scene/busi/selfopen/face?channelCode=eyecool', target = 'menuItem', menu_type = 'C', visible = '1', perms = '', icon = '#', create_by = 'admin', create_time = '2019-12-26 11:10:59', update_by = 'admin', update_time = '2020-01-06 15:28:26', remark = '' WHERE menu_id = 3208;

-- ----------------------------
-- 2、日志迁移定时任务 初始化数据
-- ----------------------------
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME4', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C7870707070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17074000561646D696E707400013174000D3020302030202A202A203F202A7400276C6F674D6967726174696F6E625461736B2E6D696772617465466163654D617463684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000004740021E4BABAE884B8313A31E8AEA4E8AF81E6AF94E5AFB9E697A5E5BF97E8BF81E7A7BB74000131740001307800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME5', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400286C6F674D6967726174696F6E625461736B2E6D696772617465466163655365617263684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000005740021E4BABAE884B8313A4EE8AF86E588ABE6909CE7B4A2E697A5E5BF97E8BF81E7A7BB74000131740001317800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME6', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400296C6F674D6967726174696F6E625461736B2E6D69677261746546696E6765724D617463684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000006740021E68C87E7BAB9313A31E8AEA4E8AF81E6AF94E5AFB9E697A5E5BF97E8BF81E7A7BB74000131740001317800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME7', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A74002A6C6F674D6967726174696F6E625461736B2E6D69677261746546696E6765725365617263684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000007740021E68C87E7BAB9313A4EE8AF86E588ABE6909CE7B4A2E697A5E5BF97E8BF81E7A7BB74000131740001317800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME8', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400276C6F674D6967726174696F6E625461736B2E6D696772617465497269734D617463684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000008740021E899B9E8869C313A31E8AEA4E8AF81E6AF94E5AFB9E697A5E5BF97E8BF81E7A7BB74000131740001317800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME9', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400286C6F674D6967726174696F6E625461736B2E6D696772617465497269735365617263684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000009740021E899B9E8869C313A4EE8AF86E588ABE6909CE7B4A2E697A5E5BF97E8BF81E7A7BB74000131740001317800);
INSERT INTO qrtz_scheduler_state(sched_name, instance_name, last_checkin_time, checkin_interval) VALUES ('RuoyiScheduler', 'eyecool1578298991776', 1578369705923, 15000);
DELETE FROM qrtz_scheduler_state WHERE sched_name = 'RuoyiScheduler' AND instance_name = 'master1578286666940';
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME4', 'DEFAULT', 'TASK_CLASS_NAME4', 'DEFAULT', NULL, 1578412800000, -1, 5, 'WAITING', 'CRON', 1578368704000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME5', 'DEFAULT', 'TASK_CLASS_NAME5', 'DEFAULT', NULL, 1578412800000, -1, 5, 'WAITING', 'CRON', 1578368679000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME6', 'DEFAULT', 'TASK_CLASS_NAME6', 'DEFAULT', NULL, 1578412800000, -1, 5, 'WAITING', 'CRON', 1578368783000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME7', 'DEFAULT', 'TASK_CLASS_NAME7', 'DEFAULT', NULL, 1578412800000, -1, 5, 'WAITING', 'CRON', 1578368861000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME8', 'DEFAULT', 'TASK_CLASS_NAME8', 'DEFAULT', NULL, 1578412800000, -1, 5, 'WAITING', 'CRON', 1578368923000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME9', 'DEFAULT', 'TASK_CLASS_NAME9', 'DEFAULT', NULL, 1578412800000, -1, 5, 'WAITING', 'CRON', 1578368989000, 0, NULL, -1, '');
UPDATE qrtz_triggers SET job_name = 'TASK_CLASS_NAME1', job_group = 'DEFAULT', description = NULL, next_fire_time = 1578368240000, prev_fire_time = -1, priority = 5, trigger_state = 'PAUSED', trigger_type = 'CRON', start_time = 1578368232000, end_time = 0, calendar_name = NULL, misfire_instr = 2, job_data = '' WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME1' AND trigger_group = 'DEFAULT';
UPDATE qrtz_triggers SET job_name = 'TASK_CLASS_NAME2', job_group = 'DEFAULT', description = NULL, next_fire_time = 1578368235000, prev_fire_time = -1, priority = 5, trigger_state = 'PAUSED', trigger_type = 'CRON', start_time = 1578368232000, end_time = 0, calendar_name = NULL, misfire_instr = 2, job_data = '' WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME2' AND trigger_group = 'DEFAULT';
UPDATE qrtz_triggers SET job_name = 'TASK_CLASS_NAME3', job_group = 'DEFAULT', description = NULL, next_fire_time = 1578368240000, prev_fire_time = -1, priority = 5, trigger_state = 'PAUSED', trigger_type = 'CRON', start_time = 1578368233000, end_time = 0, calendar_name = NULL, misfire_instr = 2, job_data = '' WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME3' AND trigger_group = 'DEFAULT';
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (4, '人脸1:1认证比对日志迁移', 'DEFAULT', 'logMigrationbTask.migrateFaceMatchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', '2020-01-07 09:36:05', 'admin', '2020-01-07 11:45:03', '每天凌晨00:00:00执行一次');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (5, '人脸1:N识别搜索日志迁移', 'DEFAULT', 'logMigrationbTask.migrateFaceSearchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', '2020-01-07 11:44:38', '', '2020-01-07 11:45:07', '每天凌晨00:00:00执行一次');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (6, '指纹1:1认证比对日志迁移', 'DEFAULT', 'logMigrationbTask.migrateFingerMatchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', '2020-01-07 11:46:22', '', '2020-01-07 11:46:25', '每天凌晨00:00:00执行一次');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (7, '指纹1:N识别搜索日志迁移', 'DEFAULT', 'logMigrationbTask.migrateFingerSearchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', '2020-01-07 11:47:40', '', '2020-01-07 11:47:43', '每天凌晨00:00:00执行一次');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (8, '虹膜1:1认证比对日志迁移', 'DEFAULT', 'logMigrationbTask.migrateIrisMatchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', '2020-01-07 11:48:42', '', '2020-01-07 11:48:44', '每天凌晨00:00:00执行一次');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (9, '虹膜1:N识别搜索日志迁移', 'DEFAULT', 'logMigrationbTask.migrateIrisSearchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', '2020-01-07 11:49:48', '', '2020-01-07 11:49:50', '每天凌晨00:00:00执行一次');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME4', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME5', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME6', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME7', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME8', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME9', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');

-- ----------------------------
-- 3、删除系统默认的定时任务
-- ----------------------------
DELETE FROM qrtz_cron_triggers WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME1' AND trigger_group = 'DEFAULT';
DELETE FROM qrtz_cron_triggers WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME2' AND trigger_group = 'DEFAULT';
DELETE FROM qrtz_cron_triggers WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME3' AND trigger_group = 'DEFAULT';
INSERT INTO qrtz_scheduler_state(sched_name, instance_name, last_checkin_time, checkin_interval) VALUES ('RuoyiScheduler', 'WIN-S7KEV1SA17A1578368231445', 1578370580739, 15000);
UPDATE qrtz_scheduler_state SET last_checkin_time = 1578370771608, checkin_interval = 15000 WHERE sched_name = 'RuoyiScheduler' AND instance_name = 'eyecool1578298991776';
DELETE FROM qrtz_scheduler_state WHERE sched_name = 'RuoyiScheduler' AND instance_name = 'master1578286666940';
DELETE FROM qrtz_triggers WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME1' AND trigger_group = 'DEFAULT';
DELETE FROM qrtz_triggers WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME2' AND trigger_group = 'DEFAULT';
DELETE FROM qrtz_triggers WHERE sched_name = 'RuoyiScheduler' AND trigger_name = 'TASK_CLASS_NAME3' AND trigger_group = 'DEFAULT';
DELETE FROM sys_job WHERE job_id = 1 AND job_name = '系统默认（无参）' AND job_group = 'DEFAULT';
DELETE FROM sys_job WHERE job_id = 2 AND job_name = '系统默认（有参）' AND job_group = 'DEFAULT';
DELETE FROM sys_job WHERE job_id = 3 AND job_name = '系统默认（多参）' AND job_group = 'DEFAULT';
DELETE FROM qrtz_job_details WHERE sched_name = 'RuoyiScheduler' AND job_name = 'TASK_CLASS_NAME1' AND job_group = 'DEFAULT';
DELETE FROM qrtz_job_details WHERE sched_name = 'RuoyiScheduler' AND job_name = 'TASK_CLASS_NAME2' AND job_group = 'DEFAULT';
DELETE FROM qrtz_job_details WHERE sched_name = 'RuoyiScheduler' AND job_name = 'TASK_CLASS_NAME3' AND job_group = 'DEFAULT';


/*==============================================================*/
/* View: 人员实时交易(人脸、指纹、虹膜1:1和1:N日志)视图                          						*/
/*==============================================================*/
CREATE 
	OR REPLACE VIEW view_person_bio_trans AS SELECT
	handle_seq,
	received_seq,
	channel_code,
	received_time,
	time_used,
	result,
	unique_id,
	broker,
	create_time,
	'人脸' AS bio_type,
	'人脸1:1认证' AS busi_type 
FROM
	person_face_match_log UNION ALL
SELECT
	handle_seq,
	received_seq,
	channel_code,
	received_time,
	time_used,
	result,
	unique_id,
	broker,
	create_time,
	'人脸' AS bio_type,
	'人脸1:N识别' AS busi_type 
FROM
	person_face_search_log UNION ALL
SELECT
	handle_seq,
	received_seq,
	channel_code,
	received_time,
	time_used,
	result,
	unique_id,
	broker,
	create_time,
	'指纹' AS bio_type,
	'指纹1:1认证' AS busi_type 
FROM
	person_finger_match_log UNION ALL
SELECT
	handle_seq,
	received_seq,
	channel_code,
	received_time,
	time_used,
	result,
	unique_id,
	broker,
	create_time,
	'指纹' AS bio_type,
	'指纹1:N识别' AS busi_type 
FROM
	person_finger_search_log UNION ALL
SELECT
	handle_seq,
	received_seq,
	channel_code,
	received_time,
	time_used,
	result,
	unique_id,
	broker,
	create_time,
	'虹膜' AS bio_type,
	'虹膜1:1认证' AS busi_type 
FROM
	person_iris_match_log UNION ALL
SELECT
	handle_seq,
	received_seq,
	channel_code,
	received_time,
	time_used,
	result,
	unique_id,
	broker,
	create_time,
	'虹膜' AS bio_type,
	'虹膜1:N识别' AS busi_type 
FROM
	person_iris_search_log;
	
/*==============================================================*/
/* Table: 陌生人人脸信息表                          						    */
/*==============================================================*/
DROP TABLE IF EXISTS base_stranger_face;
CREATE TABLE base_stranger_face  (
  id varchar(48) NOT NULL COMMENT '主键',
  feature varchar(4000) NOT NULL COMMENT '人脸特征',
  quality_score double NULL DEFAULT NULL COMMENT '图像质量得分',
  image_url varchar(255) NOT NULL COMMENT '人脸图像路径',
  vendor_code varchar(48) NULL DEFAULT NULL COMMENT '厂商',
  algs_version varchar(48) NULL DEFAULT NULL COMMENT '算法版本',
  encrypted char(1) NULL DEFAULT '0' COMMENT '是否加密： 1-加密 0-不加密',
  tenant varchar(255) NULL DEFAULT 'standard' COMMENT '租户',
  remark varchar(255) NULL DEFAULT NULL COMMENT '备注',
  status char(1) NOT NULL DEFAULT '0' COMMENT '状态：0-有效  1:无效',
  create_by varchar(64) NULL DEFAULT NULL COMMENT '创建人',
  update_by varchar(64) NULL DEFAULT NULL COMMENT '修改人',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  batch_date datetime(0) NULL DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '陌生人人脸信息' ROW_FORMAT = Dynamic;

/*==============================================================*/
/* Table: 人员和陌生人关系表                      						    */
/*==============================================================*/
DROP TABLE IF EXISTS base_person_stranger_relation;
CREATE TABLE base_person_stranger_relation  (
  id varchar(48) NOT NULL COMMENT '主键',
  unique_id varchar(48) NOT NULL COMMENT '唯一标识',
  stranger_id varchar(48) NOT NULL COMMENT '陌生人ID',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  batch_date datetime(0) NULL DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '人员和陌生人关系表' ROW_FORMAT = Dynamic;

/*==============================================================*/
/* Table: 人脸识别日志表结构修改                      					    */
/*==============================================================*/
ALTER TABLE person_face_search_log ADD COLUMN belong_to_stranger_lib varchar(1) NULL DEFAULT 'N' COMMENT '识别结果是否属于陌生人库(数据字典 Y：是，N：否)' AFTER result;
ALTER TABLE person_face_search_log ADD COLUMN later_update_person varchar(1) NULL DEFAULT 'N' COMMENT '人员标识是否后期维护(数据字典 Y：是，N：否)' AFTER belong_to_stranger_lib;
ALTER TABLE person_face_search_log ADD COLUMN device_longitude double NULL DEFAULT NULL COMMENT '设备经度(东经)' AFTER device_ip;
ALTER TABLE person_face_search_log ADD COLUMN device_dimension double NULL DEFAULT NULL COMMENT '设备维度(北纬)' AFTER device_longitude;

/*==============================================================*/
/* Table: 人脸识别历史日志表结构修改                      					    */
/*==============================================================*/
ALTER TABLE person_face_search_his_log ADD COLUMN belong_to_stranger_lib varchar(1) NULL DEFAULT 'N' COMMENT '识别结果是否属于陌生人库(数据字典 Y：是，N：否)' AFTER result;
ALTER TABLE person_face_search_his_log ADD COLUMN later_update_person varchar(1) NULL DEFAULT 'N' COMMENT '人员标识是否后期维护(数据字典 Y：是，N：否)' AFTER belong_to_stranger_lib;
ALTER TABLE person_face_search_his_log ADD COLUMN device_longitude double NULL DEFAULT NULL COMMENT '设备经度(东经)' AFTER device_ip;
ALTER TABLE person_face_search_his_log ADD COLUMN device_dimension double NULL DEFAULT NULL COMMENT '设备维度(北纬)' AFTER device_longitude;

/*==============================================================*/
/* Table: 陌生人管理菜单                                     					    */
/*==============================================================*/
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3269, '陌生人人脸', 5, 8, '/basedata/stranger', 'menuItem', 'C', '0', 'basedata:stranger:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-01-17 10:06:04', '陌生人人脸菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3270, '陌生人人脸查询', 3269, 1, '#', '', 'F', '0', 'basedata:stranger:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3271, '陌生人人脸删除', 3269, 2, '#', '', 'F', '0', 'basedata:stranger:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3272, '陌生人人脸导出', 3269, 3, '#', '', 'F', '0', 'basedata:stranger:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3273, '陌生人人脸详细', 3269, 4, '#', 'menuItem', 'F', '0', 'basedata:stranger:detail', '#', 'admin', '2020-01-17 10:40:25', '', NULL, '');

-- ----------------------------
-- 1、版本信息表添加“文件MD5”字段	     
-- ----------------------------
ALTER TABLE client_version ADD COLUMN md5 varchar(255) NOT NULL COMMENT '文件MD5' AFTER filename;
-- ----------------------------
-- 2、添加版本文件下载权限按钮
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3274, '版本文件下载', 3210, 6, '#', 'menuItem', 'F', '0', 'client:version:download', '#', 'admin', '2020-02-11 14:53:59', '', NULL, '');
-- ----------------------------
-- 3、[base_app_manage]添加是否内置字段
-- ----------------------------
ALTER TABLE base_app_manage ADD COLUMN built_in varchar(1) NOT NULL DEFAULT 'N' COMMENT '是否内置(Y：是，N：否)' AFTER app_desc;
-- ----------------------------
-- 4、内置设备自动升级appKey和appSecrect(因设备输入容易出错，升级程序内置，内置appKey不能删除和编辑)
-- ----------------------------
INSERT INTO base_app_manage(id, app_key, app_secret, app_desc, built_in, remark, create_by, update_by, create_time, update_time, batch_date) VALUES ('161672168315200', 'n4QJ3OHW', '91e08faa94fec1e53501c0e738b3376f856526f8', '设备版本升级', 'Y', '设备版本升级', 'admin', NULL, '2020-01-02 08:22:57', NULL, NULL);
