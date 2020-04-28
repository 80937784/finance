-- ----------------------------
-- 消息历史日志表
-- ----------------------------
CREATE TABLE msg_his_log  (
  id varchar(48) NOT NULL COMMENT '主键',
  received_seq varchar(48) NOT NULL COMMENT '业务流水号',
  notice_method varchar(1) NOT NULL COMMENT '通知方式(1：短信，2：邮件，3：微信，4：钉钉)',
  msg_subject varchar(255) NULL DEFAULT NULL COMMENT '消息主题',
  msg_content varchar(4000) NULL DEFAULT NULL COMMENT '消息内容',
  has_annex varchar(1) NOT NULL DEFAULT 'N' COMMENT '是否包含附件(Y：是，N：否)',
  from_user varchar(255) NULL DEFAULT NULL COMMENT '发信人标识',
  to_user varchar(4000) NULL DEFAULT NULL COMMENT '收件人标识(多个使用“,”分隔)',
  offical_account_id varchar(48) NULL DEFAULT NULL COMMENT '公众(企业)号标识',
  offical_account_name varchar(255) NULL DEFAULT NULL COMMENT '公众(企业)号名称',
  scene_remark varchar(48) NULL DEFAULT NULL COMMENT '场景标识',
  result_status varchar(1) NOT NULL COMMENT '发送状态(0：成功，1：失败)',
  err_msg varchar(255) NULL DEFAULT NULL COMMENT '错误信息',
  json_response varchar(4000) NULL DEFAULT NULL COMMENT '发送结果json',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '消息历史日志';

-- ----------------------------
-- 消息日志表
-- ----------------------------
CREATE TABLE msg_log  (
  id varchar(48) NOT NULL COMMENT '主键',
  received_seq varchar(48) NOT NULL COMMENT '业务流水号',
  notice_method varchar(1) NOT NULL COMMENT '通知方式(1：短信，2：邮件，3：微信，4：钉钉)',
  msg_subject varchar(255) NULL DEFAULT NULL COMMENT '消息主题',
  msg_content varchar(4000) NULL DEFAULT NULL COMMENT '消息内容',
  has_annex varchar(1) NOT NULL DEFAULT 'N' COMMENT '是否包含附件(Y：是，N：否)',
  from_user varchar(255) NULL DEFAULT NULL COMMENT '发信人标识',
  to_user varchar(4000) NULL DEFAULT NULL COMMENT '收件人标识(多个使用“,”分隔)',
  offical_account_id varchar(48) NULL DEFAULT NULL COMMENT '公众(企业)号标识',
  offical_account_name varchar(255) NULL DEFAULT NULL COMMENT '公众(企业)号名称',
  scene_remark varchar(48) NULL DEFAULT NULL COMMENT '场景标识',
  result_status varchar(1) NOT NULL COMMENT '发送状态(0：成功，1：失败)',
  err_msg varchar(255) NULL DEFAULT NULL COMMENT '错误信息',
  json_response varchar(4000) NULL DEFAULT NULL COMMENT '发送结果json',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '消息日志';


-- ----------------------------
-- 消息附件表
-- ----------------------------
CREATE TABLE msg_log_annex  (
  id varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  log_id varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '消息日志ID',
  file_name varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '源文件名称',
  file_path varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件路径',
  file_md5 varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件MD5',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (id) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '消息日志附件';


-- ----------------------------
-- 邮箱配置表
-- ----------------------------
CREATE TABLE msg_mail_property  (
  id varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  host varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'SMTP服务地址',
  port int(11) NULL DEFAULT NULL COMMENT 'SMTP服务端口',
  username varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录用户名',
  password varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录授权码',
  email_addr varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发件邮箱',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '邮箱配置';


-- ----------------------------
-- 微信公众号表
-- ----------------------------
CREATE TABLE msg_offical_account  (
  id varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  app_id varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'AppId',
  app_secrect varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'AppSecrect',
  app_name varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公众号(云账户)名称',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '微信公众号';

-- ----------------------------
-- 微信公众号用户表
-- ----------------------------
CREATE TABLE msg_offical_account_user  (
  id varchar(48) NOT NULL COMMENT '主键',
  offical_account_id varchar(48) NULL DEFAULT NULL COMMENT '公众号ID',
  app_id varchar(48) NOT NULL COMMENT '公众号AppId',
  open_id varchar(255) NOT NULL COMMENT '微信标识',
  wx_name varchar(255) NOT NULL COMMENT '微信名称',
  head_img_url varchar(500) NULL DEFAULT NULL COMMENT '微信头像',
  phone varchar(30) NULL DEFAULT NULL COMMENT '绑定手机',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '微信用户';

-- ----------------------------
-- 短信云账户表
-- ----------------------------
CREATE TABLE msg_sms_cloud_account  (
  id varchar(48) NOT NULL COMMENT '主键',
  app_id varchar(500) NOT NULL COMMENT 'AppId',
  app_secrect varchar(500) NOT NULL COMMENT 'AppSecrect',
  app_name varchar(500) NOT NULL COMMENT '账户说明',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '短信云账户';

-- ----------------------------
-- 消息模板表
-- ----------------------------
CREATE TABLE msg_template  (
  id varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  template_name varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '模板名称',
  offical_id varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '模板官方ID',
  content varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '模板内容',
  notice_method varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '通知方式(1：短信，2：邮件，3：微信，4：钉钉)',
  offical_account_id varchar(48) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公众(企业)号ID',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '消息模板';


-- ----------------------------
-- 微信公众号菜单表
-- ----------------------------
CREATE TABLE msg_weixin_menu  (
  id varchar(48) NOT NULL COMMENT '主键',
  offical_account_id varchar(500) NOT NULL COMMENT '公众号主键',
  app_id varchar(500) NOT NULL COMMENT '公众号AppId',
  menu_json varchar(4000) NOT NULL COMMENT '菜单JSON',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '微信公众号菜单';


-- ----------------------------
-- 微信公众号菜单点击回复内容表
-- ----------------------------
CREATE TABLE msg_weixin_menu_reply  (
  id varchar(48) NOT NULL COMMENT '主键',
  offical_account_id varchar(500) NOT NULL COMMENT '公众号主键',
  app_id varchar(500) NOT NULL COMMENT '公众号AppId',
  menu_btn_key varchar(255) NOT NULL COMMENT '菜单按钮Key',
  res_type varchar(2) NOT NULL DEFAULT '1' COMMENT '响应类型(1：文本回复)',
  reply_content varchar(4000) NULL DEFAULT NULL COMMENT '回复内容',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '微信公众号菜单回复';



-- ----------------------------
-- 钉钉团队(企业)表
-- ----------------------------
CREATE TABLE msg_ding_team  (
  id varchar(48) NOT NULL COMMENT '主键',
  corp_id varchar(255) NOT NULL COMMENT '团队(企业)CorpId',
  team_name varchar(255) NOT NULL COMMENT '团队(企业)名称',
  team_des varchar(500) NULL DEFAULT NULL COMMENT '团队(企业)说明',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '钉钉团队(企业)';


-- ----------------------------
-- 钉钉微应用表
-- ----------------------------
CREATE TABLE msg_ding_application  (
  id varchar(48) NOT NULL COMMENT '主键',
  team_id varchar(255) NOT NULL COMMENT '团队(企业)主键',
  corp_id varchar(255) NOT NULL COMMENT '团队(企业)CorpId',
  app_name varchar(255) NOT NULL COMMENT '微应用名称',
  agent_id varchar(255) NOT NULL COMMENT '微应用agentId',
  app_key varchar(255) NOT NULL COMMENT '微应用AppKey',
  app_secrect varchar(255) NOT NULL COMMENT '微应用AppSecrect',
  short_des varchar(255) NULL DEFAULT NULL COMMENT '微应用简介',
  create_time datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (id) USING BTREE
) COMMENT = '钉钉微应用';


-- ----------------------------
-- 添加字典表数据
-- ----------------------------
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (124, '消息通知方式', 'msg_notice_method', '0', 'admin', '2020-03-17 15:22:11', '', NULL, '消息通知方式');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (125, '消息发送模式', 'msg_type', '0', 'admin', '2020-03-17 15:25:18', 'admin', '2020-03-23 13:15:01', '消息发送模式');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (126, '消息推送结果', 'msg_result', '0', 'admin', '2020-03-19 11:18:37', '', NULL, '消息推送结果');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (127, '邮件类型', 'msg_mail_type', '0', 'admin', '2020-03-23 10:37:21', '', NULL, '邮件类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (128, '钉钉消息类型', 'msg_dingtalk_type', '0', 'admin', '2020-04-01 09:32:20', '', NULL, '钉钉消息类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (129, '钉钉媒体文件类型', 'msg_dingtalk_media_type', '0', 'admin', '2020-04-01 11:48:30', '', NULL, '钉钉媒体文件类型');

INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (352, 1, '短信', '1', 'msg_notice_method', '', 'info', 'Y', '0', 'admin', '2020-03-17 15:22:36', 'admin', '2020-03-17 15:24:09', '消息通知方式--短信');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (353, 2, '邮件', '2', 'msg_notice_method', NULL, 'success', 'N', '0', 'admin', '2020-03-17 15:23:14', '', NULL, '消息通知方式--邮件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (354, 3, '微信', '3', 'msg_notice_method', '', 'primary', 'N', '0', 'admin', '2020-03-17 15:23:59', 'admin', '2020-03-17 15:24:18', '消息通知方式--微信');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (355, 4, '钉钉', '4', 'msg_notice_method', NULL, 'warning', 'N', '0', 'admin', '2020-03-17 15:24:38', '', NULL, '消息通知方式--钉钉');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (356, 1, '普通发送', '1', 'msg_type', '', 'primary', 'Y', '0', 'admin', '2020-03-17 15:28:44', 'admin', '2020-03-23 13:15:24', '消息类型--普通发送');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (357, 2, '模板发送', '2', 'msg_type', '', 'success', 'N', '0', 'admin', '2020-03-17 15:29:07', 'admin', '2020-03-23 13:15:16', '消息类型--模板发送');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (358, 1, '成功', '0', 'msg_result', '', 'primary', 'Y', '0', 'admin', '2020-03-19 11:20:15', 'admin', '2020-03-19 11:20:51', '消息推送结果--成功');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (359, 2, '失败', '1', 'msg_result', NULL, 'danger', 'N', '0', 'admin', '2020-03-19 11:20:41', '', NULL, '消息推送结果--失败');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (360, 1, '文本邮件', '1', 'msg_mail_type', NULL, 'success', 'Y', '0', 'admin', '2020-03-23 10:37:45', '', NULL, '邮件类型--文本邮件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (361, 2, 'HTML邮件', '2', 'msg_mail_type', NULL, 'warning', 'N', '0', 'admin', '2020-03-23 10:38:13', '', NULL, '邮件类型--HTML邮件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (362, 1, '文本消息', 'text', 'msg_dingtalk_type', '', 'primary', 'Y', '0', 'admin', '2020-04-01 09:32:49', 'admin', '2020-04-01 09:32:55', '钉钉消息类型--文本消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (363, 2, 'Markdown消息', 'markdown', 'msg_dingtalk_type', NULL, 'success', 'N', '0', 'admin', '2020-04-01 09:33:25', '', NULL, '钉钉消息类型--Markdown消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (364, 3, '链接消息', 'link', 'msg_dingtalk_type', NULL, 'warning', 'N', '0', 'admin', '2020-04-01 09:34:04', '', NULL, '钉钉消息类型--链接消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (365, 1, '图片文件', 'image', 'msg_dingtalk_media_type', '', 'success', 'Y', '0', 'admin', '2020-04-01 11:49:07', 'admin', '2020-04-01 11:49:58', '钉钉媒体文件类型--图片文件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (366, 2, '语音文件', 'voice', 'msg_dingtalk_media_type', NULL, 'primary', 'N', '0', 'admin', '2020-04-01 11:49:46', '', NULL, '钉钉媒体文件类型--语音文件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (367, 3, '普通文件', 'file', 'msg_dingtalk_media_type', NULL, 'warning', 'N', '0', 'admin', '2020-04-01 11:50:28', '', NULL, '钉钉媒体文件类型--普通文件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (368, 4, '图片消息', 'image', 'msg_dingtalk_type', NULL, 'info', 'N', '0', 'admin', '2020-04-01 12:29:48', '', NULL, '钉钉消息类型--图片消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (369, 5, '语音消息', 'voice', 'msg_dingtalk_type', NULL, 'success', 'N', '0', 'admin', '2020-04-01 12:30:22', '', NULL, '钉钉消息类型--语音消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (370, 6, '普通文件消息', 'file', 'msg_dingtalk_type', NULL, 'success', 'N', '0', 'admin', '2020-04-01 12:30:55', '', NULL, '钉钉消息类型--普通文件消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (371, 31, '钉钉推送功能', 'MESSAGE_SEND_DING', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2020-04-01 19:38:17', '', NULL, 'HTTP交易接口--钉钉推送功能');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (372, 32, '钉钉推送结果查询', 'MESSAGE_SEND_DING_RESULT', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2020-04-01 19:38:48', '', NULL, 'HTTP交易接口--钉钉推送结果查询');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (373, 33, '钉钉媒体文件上传', 'MESSAGE_DING_MEDIA_UPLOAD', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2020-04-01 19:39:27', '', NULL, 'HTTP交易接口--钉钉媒体文件上传');


-- ----------------------------
-- 添加菜单数据
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3296, '消息附件', 3332, 8, '/msg/annex', 'menuItem', 'C', '0', 'msg:annex:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 11:10:04', '消息日志附件菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3297, '消息日志附件查询', 3296, 1, '#', '', 'F', '0', 'msg:annex:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3300, '消息日志附件删除', 3296, 2, '#', 'menuItem', 'F', '0', 'msg:annex:remove', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-19 10:11:56', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3301, '消息日志附件导出', 3296, 3, '#', 'menuItem', 'F', '0', 'msg:annex:export', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-19 10:12:06', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3302, '历史日志', 3332, 9, '/msg/hislog', 'menuItem', 'C', '0', 'msg:hislog:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 11:11:43', '消息历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3303, '消息历史日志查询', 3302, 1, '#', '', 'F', '0', 'msg:hislog:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3306, '消息历史日志删除', 3302, 2, '#', 'menuItem', 'F', '0', 'msg:hislog:remove', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-19 10:12:41', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3307, '消息历史日志导出', 3302, 3, '#', 'menuItem', 'F', '0', 'msg:hislog:export', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-19 10:12:49', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3308, '消息日志', 3332, 7, '/msg/log', 'menuItem', 'C', '0', 'msg:log:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 11:11:21', '消息日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3309, '消息日志查询', 3308, 1, '#', '', 'F', '0', 'msg:log:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3312, '消息日志删除', 3308, 2, '#', 'menuItem', 'F', '0', 'msg:log:remove', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-19 10:12:24', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3313, '消息日志导出', 3308, 3, '#', 'menuItem', 'F', '0', 'msg:log:export', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-19 10:12:32', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3314, '消息模板', 3332, 6, '/msg/template', 'menuItem', 'C', '0', 'msg:template:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 11:11:10', '消息模板菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3315, '消息模板查询', 3314, 1, '#', '', 'F', '0', 'msg:template:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3316, '消息模板新增', 3314, 2, '#', '', 'F', '0', 'msg:template:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3317, '消息模板修改', 3314, 3, '#', '', 'F', '0', 'msg:template:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3318, '消息模板删除', 3314, 4, '#', '', 'F', '0', 'msg:template:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3319, '消息模板导出', 3314, 5, '#', '', 'F', '0', 'msg:template:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3320, '微信公众号', 3348, 1, '/msg/officalAccount', 'menuItem', 'C', '0', 'msg:officalAccount:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 11:06:56', '微信公众号菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3321, '公众号查询', 3320, 1, '#', '', 'F', '0', 'msg:officalAccount:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3322, '公众号新增', 3320, 2, '#', '', 'F', '0', 'msg:officalAccount:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3323, '公众号修改', 3320, 3, '#', '', 'F', '0', 'msg:officalAccount:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3324, '公众号删除', 3320, 4, '#', '', 'F', '0', 'msg:officalAccount:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3325, '公众号导出', 3320, 5, '#', '', 'F', '0', 'msg:officalAccount:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3326, '公众号用户', 3348, 2, '/msg/officalAccountUser', 'menuItem', 'C', '0', 'msg:officalAccountUser:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 12:55:02', '微信公众号用户菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3327, '公众号用户查询', 3326, 1, '#', '', 'F', '0', 'msg:officalAccountUser:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3329, '公众号用户修改', 3326, 3, '#', '', 'F', '0', 'msg:officalAccountUser:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3331, '公众号用户导出', 3326, 5, '#', '', 'F', '0', 'msg:officalAccountUser:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3332, '消息通知', 0, 9, '#', 'menuItem', 'M', '0', '', 'fa fa-commenting', 'admin', '2020-03-17 15:13:22', 'admin', '2020-03-17 15:14:06', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3333, '消息日志附件下载', 3296, 4, '#', 'menuItem', 'F', '0', 'msg:annex:download', '#', 'admin', '2020-03-19 10:09:30', 'admin', '2020-03-19 10:12:15', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3334, '消息附件下载', 3308, 4, '#', 'menuItem', 'F', '0', 'msg:log:download', '#', 'admin', '2020-03-19 10:17:17', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3335, '消息附件下载', 3302, 4, '#', 'menuItem', 'F', '0', 'msg:hislog:download', '#', 'admin', '2020-03-19 10:18:33', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3336, '发送邮件', 3337, 2, '/msg/send/mail', 'menuItem', 'C', '0', 'msg:send:mail', '#', 'admin', '2020-03-20 15:24:45', 'admin', '2020-03-23 12:30:09', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3337, '消息推送', 3332, 1, '#', 'menuItem', 'M', '0', '', '#', 'admin', '2020-03-20 21:35:23', 'admin', '2020-03-20 21:39:27', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3338, '发送短信', 3337, 1, '/msg/send/sms', 'menuItem', 'C', '0', 'msg:send:sms', '#', 'admin', '2020-03-23 12:30:00', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3339, '邮箱配置', 3350, 6, '/msg/mailProperty', 'menuItem', 'C', '0', 'msg:mailProperty:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 11:08:53', '邮箱配置菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3340, '邮箱配置查询', 3339, 1, '#', '', 'F', '0', 'msg:mailProperty:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3341, '邮箱配置新增', 3339, 2, '#', '', 'F', '0', 'msg:mailProperty:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3342, '邮箱配置修改', 3339, 3, '#', '', 'F', '0', 'msg:mailProperty:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3343, '邮箱配置删除', 3339, 4, '#', '', 'F', '0', 'msg:mailProperty:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3344, '邮箱配置导出', 3339, 5, '#', '', 'F', '0', 'msg:mailProperty:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3345, '发送微信', 3337, 3, '/msg/send/weixin', 'menuItem', 'C', '0', 'msg:send:weixin', '#', 'admin', '2020-03-24 17:59:54', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3347, '公众号用户拉取', 3326, 2, '#', 'menuItem', 'F', '0', 'msg:officalAccountUser:pull', '#', 'admin', '2020-03-27 10:34:02', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3348, '微信通知', 3332, 4, '#', 'menuItem', 'M', '0', '', '#', 'admin', '2020-03-30 11:05:53', 'admin', '2020-03-30 11:08:41', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3349, '短信通知', 3332, 2, '#', 'menuItem', 'M', '0', NULL, '#', 'admin', '2020-03-30 11:08:17', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3350, '邮件通知', 3332, 3, '#', 'menuItem', 'M', '0', NULL, '#', 'admin', '2020-03-30 11:08:34', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3351, '钉钉通知', 3332, 5, '#', 'menuItem', 'M', '0', NULL, '#', 'admin', '2020-03-30 11:09:32', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3352, '短信云账户', 3349, 1, 'msg/smsCloudAccount', 'menuItem', 'C', '0', 'msg:smsCloudAccount:view', '#', 'admin', '2020-03-30 12:03:07', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3353, '云账户查询', 3352, 1, '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:list', '#', 'admin', '2020-03-30 12:05:18', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3354, '云账户新增', 3352, 2, '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:add', '#', 'admin', '2020-03-30 12:05:46', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3355, '云账户修改', 3352, 3, '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:edit', '#', 'admin', '2020-03-30 12:06:16', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3356, '云账户删除', 3352, 4, '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:delete', '#', 'admin', '2020-03-30 12:06:40', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3357, '云账户导出', 3352, 5, '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:export', '#', 'admin', '2020-03-30 12:07:00', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3358, '公众号菜单', 3348, 3, '/msg/weixinMenu', 'menuItem', 'C', '0', 'msg:weixinMenu:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 12:52:39', '微信公众号菜单菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3359, '微信公众号菜单查询', 3358, 1, '#', '', 'F', '0', 'msg:weixinMenu:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3360, '微信公众号菜单新增', 3358, 2, '#', '', 'F', '0', 'msg:weixinMenu:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3361, '微信公众号菜单修改', 3358, 3, '#', '', 'F', '0', 'msg:weixinMenu:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3362, '微信公众号菜单删除', 3358, 4, '#', '', 'F', '0', 'msg:weixinMenu:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3363, '微信公众号菜单导出', 3358, 5, '#', '', 'F', '0', 'msg:weixinMenu:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3364, '菜单响应', 3348, 4, '/msg/weixinMenuReply', 'menuItem', 'C', '0', 'msg:weixinMenuReply:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 12:53:29', '微信公众号菜单回复菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3365, '微信公众号菜单回复查询', 3364, 1, '#', '', 'F', '0', 'msg:weixinMenuReply:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3366, '微信公众号菜单回复新增', 3364, 2, '#', '', 'F', '0', 'msg:weixinMenuReply:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3367, '微信公众号菜单回复修改', 3364, 3, '#', '', 'F', '0', 'msg:weixinMenuReply:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3368, '微信公众号菜单回复删除', 3364, 4, '#', '', 'F', '0', 'msg:weixinMenuReply:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3369, '微信公众号菜单回复导出', 3364, 5, '#', '', 'F', '0', 'msg:weixinMenuReply:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3370, '钉钉团队', 3351, 1, '/msg/dingTeam', 'menuItem', 'C', '0', 'msg:dingTeam:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 16:30:40', '钉钉团队(企业)菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3371, '钉钉团队(企业)查询', 3370, 1, '#', '', 'F', '0', 'msg:dingTeam:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3372, '钉钉团队(企业)新增', 3370, 2, '#', '', 'F', '0', 'msg:dingTeam:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3373, '钉钉团队(企业)修改', 3370, 3, '#', '', 'F', '0', 'msg:dingTeam:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3374, '钉钉团队(企业)删除', 3370, 4, '#', '', 'F', '0', 'msg:dingTeam:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3375, '钉钉团队(企业)导出', 3370, 5, '#', '', 'F', '0', 'msg:dingTeam:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3376, '钉钉微应用', 3351, 2, '/msg/dingApplication', 'menuItem', 'C', '0', 'msg:dingApplication:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2020-03-30 16:29:47', '钉钉微应用菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3377, '钉钉微应用查询', 3376, 1, '#', '', 'F', '0', 'msg:dingApplication:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3378, '钉钉微应用新增', 3376, 2, '#', '', 'F', '0', 'msg:dingApplication:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3379, '钉钉微应用修改', 3376, 3, '#', '', 'F', '0', 'msg:dingApplication:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3380, '钉钉微应用删除', 3376, 4, '#', '', 'F', '0', 'msg:dingApplication:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3381, '钉钉微应用导出', 3376, 5, '#', '', 'F', '0', 'msg:dingApplication:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3382, '发送钉钉', 3337, 4, '/msg/send/dingtalk', 'menuItem', 'C', '0', 'msg:send:dingtalk', '#', 'admin', '2020-04-01 09:29:04', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3383, '钉钉媒体上传', 3337, 5, '/msg/send//dingtalk/upload', 'menuItem', 'C', '0', 'msg:send:uploadDingMedia', '#', 'admin', '2020-04-01 11:51:25', '', NULL, '');


-- ----------------------------
-- 参数设置
-- ----------------------------
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (133, '消息通知附件存放位置', 'msg.attachment.dir', './eyecool/msg/attachment/', 'N', 'admin', '2020-03-27 15:18:31', 'admin', '2020-03-27 16:27:38', '消息通知附件存放位置');

-- ----------------------------
-- 消息日志迁移定时任务
-- ----------------------------
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (15, '消息通知推送日志迁移', 'DEFAULT', 'mgLogMigrateTask.migrateMsgSendLog()', '0 0 0 * * ? *', '1', '1', '1', 'admin', '2020-03-27 15:05:39', 'admin', '2020-03-27 15:06:13', '每天凌晨00:00:00执行一次');
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME15', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001711ACF81B87870740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400246D674C6F674D6967726174655461736B2E6D6967726174654D736753656E644C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000000F74001EE6B688E681AFE9809AE79FA5E68EA8E98081E697A5E5BF97E8BF81E7A7BB74000131740001317800);
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME15', 'DEFAULT', 'TASK_CLASS_NAME15', 'DEFAULT', NULL, 1585324800000, -1, 5, 'PAUSED', 'CRON', 1585300618000, 0, NULL, -1, '');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME15', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');

-- ----------------------------
-- 删除旧版本消息推送表
-- ----------------------------
DROP TABLE IF EXISTS  mail_info;
DROP TABLE IF EXISTS  mail_send;
DROP TABLE IF EXISTS  sms_message_send;
DROP TABLE IF EXISTS  sms_service_configure;
DROP TABLE IF EXISTS  trade_error_log;
DROP TABLE IF EXISTS  trade_log;
DROP TABLE IF EXISTS  trade_request_param;
DROP TABLE IF EXISTS  wx_message_send;
DROP TABLE IF EXISTS  wx_message_template;
DROP TABLE IF EXISTS  wx_public_configure;
DROP TABLE IF EXISTS  wx_user_group;
DROP TABLE IF EXISTS  wx_user_info;


-- ----------------------------
-- 删除旧版本消息推送菜单信息
-- ----------------------------
DELETE FROM sys_menu WHERE menu_id = 4;
DELETE FROM sys_menu WHERE menu_id = 2000;
DELETE FROM sys_menu WHERE menu_id = 2001;
DELETE FROM sys_menu WHERE menu_id = 2002;
DELETE FROM sys_menu WHERE menu_id = 2003;
DELETE FROM sys_menu WHERE menu_id = 2004;
DELETE FROM sys_menu WHERE menu_id = 2005;
DELETE FROM sys_menu WHERE menu_id = 2006;
DELETE FROM sys_menu WHERE menu_id = 2007;
DELETE FROM sys_menu WHERE menu_id = 2008;
DELETE FROM sys_menu WHERE menu_id = 2009;
DELETE FROM sys_menu WHERE menu_id = 2010;
DELETE FROM sys_menu WHERE menu_id = 2011;
DELETE FROM sys_menu WHERE menu_id = 3000;
DELETE FROM sys_menu WHERE menu_id = 3001;
DELETE FROM sys_menu WHERE menu_id = 3002;
DELETE FROM sys_menu WHERE menu_id = 3003;
DELETE FROM sys_menu WHERE menu_id = 3004;
DELETE FROM sys_menu WHERE menu_id = 3005;
DELETE FROM sys_menu WHERE menu_id = 3006;
DELETE FROM sys_menu WHERE menu_id = 3007;
DELETE FROM sys_menu WHERE menu_id = 3008;
DELETE FROM sys_menu WHERE menu_id = 3009;
DELETE FROM sys_menu WHERE menu_id = 3010;
DELETE FROM sys_menu WHERE menu_id = 3011;
DELETE FROM sys_menu WHERE menu_id = 3012;
DELETE FROM sys_menu WHERE menu_id = 3013;
DELETE FROM sys_menu WHERE menu_id = 3014;
DELETE FROM sys_menu WHERE menu_id = 3015;
DELETE FROM sys_menu WHERE menu_id = 3016;
DELETE FROM sys_menu WHERE menu_id = 3017;
DELETE FROM sys_menu WHERE menu_id = 3018;
DELETE FROM sys_menu WHERE menu_id = 3019;
DELETE FROM sys_menu WHERE menu_id = 3020;
DELETE FROM sys_menu WHERE menu_id = 3039;
DELETE FROM sys_menu WHERE menu_id = 3040;
DELETE FROM sys_menu WHERE menu_id = 3041;
DELETE FROM sys_menu WHERE menu_id = 3042;
DELETE FROM sys_menu WHERE menu_id = 3043;
DELETE FROM sys_menu WHERE menu_id = 3044;
DELETE FROM sys_menu WHERE menu_id = 3045;
DELETE FROM sys_menu WHERE menu_id = 3046;
DELETE FROM sys_menu WHERE menu_id = 3047;
DELETE FROM sys_menu WHERE menu_id = 3048;
DELETE FROM sys_menu WHERE menu_id = 3049;
DELETE FROM sys_menu WHERE menu_id = 3050;
DELETE FROM sys_menu WHERE menu_id = 3284;
DELETE FROM sys_menu WHERE menu_id = 3285;
DELETE FROM sys_menu WHERE menu_id = 3286;
DELETE FROM sys_menu WHERE menu_id = 3287;
DELETE FROM sys_menu WHERE menu_id = 3288;
DELETE FROM sys_menu WHERE menu_id = 3289;
DELETE FROM sys_menu WHERE menu_id = 3290;
DELETE FROM sys_menu WHERE menu_id = 3291;
DELETE FROM sys_menu WHERE menu_id = 3292;
DELETE FROM sys_menu WHERE menu_id = 3293;
DELETE FROM sys_menu WHERE menu_id = 3294;
DELETE FROM sys_menu WHERE menu_id = 3295;


-- ----------------------------
-- 同步官方代码表结构微调
-- ----------------------------
ALTER TABLE sys_user MODIFY COLUMN user_name varchar(30) NULL DEFAULT '' COMMENT '用户昵称' AFTER login_name;
ALTER TABLE sys_user MODIFY COLUMN user_type varchar(2) NULL DEFAULT '00' COMMENT '用户类型（00系统用户 01注册用户）' AFTER user_name;

-- ----------------------------
-- 同步官方代码添加配置字段
-- ----------------------------
insert into sys_config values(4, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false',         'Y', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '是否开启注册用户功能');

-- ----------------------------
-- 同步官方代码调整字典数据
-- ----------------------------
delete from sys_dict_data where dict_type = 'sys_oper_type';
delete from sys_dict_data where dict_type = 'sys_common_status';
insert into sys_dict_data values(18, 99, '其他',     '0',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '其他操作');
insert into sys_dict_data values(19, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(20, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '修改操作');
insert into sys_dict_data values(21, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '删除操作');
insert into sys_dict_data values(22, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '授权操作');
insert into sys_dict_data values(23, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '导出操作');
insert into sys_dict_data values(24, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '导入操作');
insert into sys_dict_data values(25, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '强退操作');
insert into sys_dict_data values(26, 8,  '生成代码', '8',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '生成操作');
insert into sys_dict_data values(27, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '清空操作');
insert into sys_dict_data values(28, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(29, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '停用状态');

-- ----------------------------
-- 修改列名(版本信息表size字段，适应多数据库,避免oracle关键字)
-- ----------------------------
ALTER TABLE client_version CHANGE COLUMN size file_size bigint(20) NOT NULL COMMENT '版本大小(B)' AFTER path;

/*==============================================================*/
/* 人脸1-N识别日志保存去重参数设置	                            */
/*==============================================================*/
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (134, '人脸1-N识别日志保存是否比对去重', 'busi.face.searchN.log.save.distinct', 'N', 'N', 'admin', '2020-04-15 13:09:41', 'admin', '2020-04-15 13:10:48', '人脸1-N日识别可能存在短时间内（例如5s）连续识别到一个人的情况，是否对识别日志去重处理（Y：是，N：否），是就只保存第一次识别的记录');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (135, '人脸1-N识别日志保存比对去重时间', 'busi.face.searchN.log.duplicate.time', '6000', 'N', 'admin', '2020-04-15 13:10:35', 'admin', '2020-04-15 13:10:45', '人脸1-N日志保存去重时间,在此时间内连续识别到一个人，则认为是重复识别，只保存一条识别日志,单位为ms');

