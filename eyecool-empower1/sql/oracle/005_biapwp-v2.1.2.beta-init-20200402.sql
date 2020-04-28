﻿/*==============================================================*/ 
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     2020/4/2 14:34:11                            */
/*==============================================================*/

/*=============================================================*/
/* Table: 定时任务调度表                                        */
/*==============================================================*/
CREATE sequence S_sys_job INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_job (
	job_id NUMBER ( 6 ) NOT NULL,
	job_name VARCHAR2 ( 64 ) DEFAULT '' NOT NULL,
	job_group VARCHAR2 ( 64 ) DEFAULT 'DEFAULT' NOT NULL,
	invoke_target VARCHAR2 ( 500 ) NOT NULL,
	cron_expression VARCHAR2 ( 255 ) DEFAULT '',
	misfire_policy VARCHAR2 ( 20 ) DEFAULT '3',
	concurrent CHAR ( 1 ) DEFAULT '1',
	status CHAR ( 1 ) DEFAULT '0',
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT '',
	constraint PK_SYS_JOB primary key ( job_id, job_name, job_group ) 
);
COMMENT ON TABLE sys_job IS '定时任务调度表';
COMMENT ON COLUMN sys_job.job_id IS '任务ID';
COMMENT ON COLUMN sys_job.job_name IS '任务名称';
COMMENT ON COLUMN sys_job.job_group IS '任务组名';
COMMENT ON COLUMN sys_job.invoke_target IS '调用目标字符串';
COMMENT ON COLUMN sys_job.cron_expression IS 'cron执行表达式';
COMMENT ON COLUMN sys_job.misfire_policy IS '计划执行错误策略（1立即执行 2执行一次 3放弃执行）';
COMMENT ON COLUMN sys_job.concurrent IS '是否并发执行（0允许 1禁止）';
COMMENT ON COLUMN sys_job.status IS '状态（0正常 1暂停）';
COMMENT ON COLUMN sys_job.create_by IS '创建者';
COMMENT ON COLUMN sys_job.create_time IS '创建时间';
COMMENT ON COLUMN sys_job.update_by IS '更新者';
COMMENT ON COLUMN sys_job.update_time IS '更新时间';
COMMENT ON COLUMN sys_job.remark IS '备注信息';
/*==============================================================*/
/* Table: 定时任务调度日志表                                    */
/*==============================================================*/
CREATE sequence S_sys_job_log INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_job_log (
	job_log_id NUMBER ( 6 ) NOT NULL,
	job_name VARCHAR2 ( 64 ) NOT NULL,
	job_group VARCHAR2 ( 64 ) NOT NULL,
	invoke_target VARCHAR2 ( 500 ) NOT NULL,
	job_message VARCHAR2 ( 500 ) DEFAULT NULL,
	status CHAR ( 1 ) DEFAULT '0',
	exception_info VARCHAR2 ( 2000 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	constraint PK_SYS_JOB_LOG primary key ( job_log_id ) 
);
COMMENT ON TABLE sys_job_log IS '定时任务调度日志表';
COMMENT ON COLUMN sys_job_log.job_log_id IS '任务日志ID';
COMMENT ON COLUMN sys_job_log.job_name IS '任务名称';
COMMENT ON COLUMN sys_job_log.job_group IS '任务组名';
COMMENT ON COLUMN sys_job_log.invoke_target IS '调用目标字符串';
COMMENT ON COLUMN sys_job_log.job_message IS '日志信息';
COMMENT ON COLUMN sys_job_log.status IS '执行状态（0正常 1失败）';
COMMENT ON COLUMN sys_job_log.exception_info IS '异常信息';
COMMENT ON COLUMN sys_job_log.create_time IS '创建时间';
/*==============================================================*/
/* Table: qrtz_blob_triggers                                  */
/*==============================================================*/
CREATE TABLE qrtz_blob_triggers (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	trigger_name VARCHAR2 ( 150 ) NOT NULL,
	trigger_group VARCHAR2 ( 100 ) NOT NULL,
	blob_data BLOB,
	constraint PK_QRTZ_BLOB_TRIGGERS primary key ( sched_name, trigger_name, trigger_group ) 
);
COMMENT ON TABLE qrtz_blob_triggers IS 'Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)';
/*==============================================================*/
/* Table: qrtz_calendars                                        */
/*==============================================================*/
CREATE TABLE qrtz_calendars (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	calendar_name VARCHAR2 ( 150 ) NOT NULL,
	calendar BLOB NOT NULL,
	constraint PK_QRTZ_CALENDARS primary key ( sched_name, calendar_name ) 
);
COMMENT ON TABLE qrtz_calendars IS '以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围';
/*==============================================================*/
/* Table: qrtz_cron_triggers                                  */
/*==============================================================*/
CREATE TABLE qrtz_cron_triggers (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	trigger_name VARCHAR2 ( 150 ) NOT NULL,
	trigger_group VARCHAR2 ( 100 ) NOT NULL,
	cron_expression VARCHAR2 ( 200 ) NOT NULL,
	time_zone_id VARCHAR2 ( 80 ) DEFAULT NULL,
	constraint PK_QRTZ_CRON_TRIGGERS primary key ( sched_name, trigger_name, trigger_group ) 
);
COMMENT ON TABLE qrtz_cron_triggers IS '存储 Cron Trigger，包括 Cron 表达式和时区信息';
/*==============================================================*/
/* Table: qrtz_fired_triggers                                 */
/*==============================================================*/
CREATE TABLE qrtz_fired_triggers (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	entry_id VARCHAR2 ( 95 ) NOT NULL,
	trigger_name VARCHAR2 ( 200 ) NOT NULL,
	trigger_group VARCHAR2 ( 200 ) NOT NULL,
	instance_name VARCHAR2 ( 200 ) NOT NULL,
	fired_time INTEGER NOT NULL,
	sched_time INTEGER NOT NULL,
	priority INTEGER NOT NULL,
	state VARCHAR2 ( 16 ) NOT NULL,
	job_name VARCHAR2 ( 200 ) DEFAULT NULL,
	job_group VARCHAR2 ( 200 ) DEFAULT NULL,
	is_nonconcurrent VARCHAR2 ( 1 ) DEFAULT NULL,
	requests_recovery VARCHAR2 ( 1 ) DEFAULT NULL,
	constraint PK_QRTZ_FIRED_TRIGGERS primary key ( sched_name, entry_id ) 
);
COMMENT ON TABLE qrtz_fired_triggers IS '存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息';
/*==============================================================*/
/* Table: qrtz_job_details                                    */
/*==============================================================*/
CREATE TABLE qrtz_job_details (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	job_name VARCHAR2 ( 150 ) NOT NULL,
	job_group VARCHAR2 ( 100 ) NOT NULL,
	description VARCHAR2 ( 250 ) DEFAULT NULL,
	job_class_name VARCHAR2 ( 250 ) NOT NULL,
	is_durable VARCHAR2 ( 1 ) NOT NULL,
	is_nonconcurrent VARCHAR2 ( 1 ) NOT NULL,
	is_update_data VARCHAR2 ( 1 ) NOT NULL,
	requests_recovery VARCHAR2 ( 1 ) NOT NULL,
	job_data BLOB,
	constraint PK_QRTZ_JOB_DETAILS primary key ( sched_name, job_name, job_group ) 
);
COMMENT ON TABLE qrtz_job_details IS '存储每一个已配置的 jobDetail 的详细信息';
/*==============================================================*/
/* Table: qrtz_locks                                          */
/*==============================================================*/
CREATE TABLE qrtz_locks ( sched_name VARCHAR2 ( 100 ) NOT NULL, lock_name VARCHAR2 ( 40 ) NOT NULL, constraint PK_QRTZ_LOCKS primary key ( sched_name, lock_name ) );
COMMENT ON TABLE qrtz_locks IS '存储程序的悲观锁的信息(假如使用了悲观锁)';
/*==============================================================*/
/* Table: qrtz_paused_trigger_grps                            */
/*==============================================================*/
CREATE TABLE qrtz_paused_trigger_grps ( sched_name VARCHAR2 ( 100 ) NOT NULL, trigger_group VARCHAR2 ( 100 ) NOT NULL, constraint PK_QRTZ_PAUSED_TRIGGER_GRPS primary key ( sched_name, trigger_group ) );
COMMENT ON TABLE qrtz_paused_trigger_grps IS '存储已暂停的 Trigger 组的信息';
/*==============================================================*/
/* Table: qrtz_scheduler_state                                */
/*==============================================================*/
CREATE TABLE qrtz_scheduler_state (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	instance_name VARCHAR2 ( 150 ) NOT NULL,
	last_checkin_time INTEGER NOT NULL,
	checkin_interval INTEGER NOT NULL,
	constraint PK_QRTZ_SCHEDULER_STATE primary key ( sched_name, instance_name ) 
);
COMMENT ON TABLE qrtz_scheduler_state IS ' 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例';
/*==============================================================*/
/* Table: qrtz_simple_triggers                                */
/*==============================================================*/
CREATE TABLE qrtz_simple_triggers (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	trigger_name VARCHAR2 ( 150 ) NOT NULL,
	trigger_group VARCHAR2 ( 100 ) NOT NULL,
	repeat_count INTEGER NOT NULL,
	repeat_interval INTEGER NOT NULL,
	times_triggered INTEGER NOT NULL,
	constraint PK_QRTZ_SIMPLE_TRIGGERS primary key ( sched_name, trigger_name, trigger_group ) 
);
COMMENT ON TABLE qrtz_simple_triggers IS '存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数';
/*==============================================================*/
/* Table: qrtz_simprop_triggers                               */
/*==============================================================*/
CREATE TABLE qrtz_simprop_triggers (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	trigger_name VARCHAR2 ( 150 ) NOT NULL,
	trigger_group VARCHAR2 ( 100 ) NOT NULL,
	str_prop_1 VARCHAR2 ( 512 ) DEFAULT NULL,
	str_prop_2 VARCHAR2 ( 512 ) DEFAULT NULL,
	str_prop_3 VARCHAR2 ( 512 ) DEFAULT NULL,
	int_prop_1 INTEGER DEFAULT NULL,
	int_prop_2 INTEGER DEFAULT NULL,
	long_prop_1 INTEGER DEFAULT NULL,
	long_prop_2 INTEGER DEFAULT NULL,
	dec_prop_1 NUMBER ( 13, 4 ) DEFAULT NULL,
	dec_prop_2 NUMBER ( 13, 4 ) DEFAULT NULL,
	bool_prop_1 VARCHAR2 ( 1 ) DEFAULT NULL,
	bool_prop_2 VARCHAR2 ( 1 ) DEFAULT NULL,
	constraint PK_QRTZ_SIMPROP_TRIGGERS primary key ( sched_name, trigger_name, trigger_group ) 
);
/*==============================================================*/
/* Table: qrtz_triggers                                       */
/*==============================================================*/
CREATE TABLE qrtz_triggers (
	sched_name VARCHAR2 ( 100 ) NOT NULL,
	trigger_name VARCHAR2 ( 150 ) NOT NULL,
	trigger_group VARCHAR2 ( 100 ) NOT NULL,
	job_name VARCHAR2 ( 150 ) NOT NULL,
	job_group VARCHAR2 ( 100 ) NOT NULL,
	description VARCHAR2 ( 250 ) DEFAULT NULL,
	next_fire_time INTEGER DEFAULT NULL,
	prev_fire_time INTEGER DEFAULT NULL,
	priority INTEGER DEFAULT NULL,
	trigger_state VARCHAR2 ( 16 ) NOT NULL,
	trigger_type VARCHAR2 ( 8 ) NOT NULL,
	start_time INTEGER NOT NULL,
	end_time INTEGER DEFAULT NULL,
	calendar_name VARCHAR2 ( 200 ) DEFAULT NULL,
	misfire_instr SMALLINT DEFAULT NULL,
	job_data BLOB,
	constraint PK_QRTZ_TRIGGERS primary key ( sched_name, trigger_name, trigger_group )
);
COMMENT ON TABLE qrtz_triggers IS '存储已配置的 Trigger 的信息';
ALTER TABLE qrtz_triggers ADD constraint qrtz_triggers_ibfk_1 foreign key ( sched_name, job_name, job_group ) references qrtz_job_details ( sched_name, job_name, job_group );
/*==============================================================*/
/* Table: 代码生成业务表                                        */
/*==============================================================*/
CREATE sequence S_gen_table INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE gen_table (
	table_id NUMBER ( 6 ) NOT NULL,
	table_name VARCHAR2 ( 200 ) DEFAULT '',
	table_comment VARCHAR2 ( 500 ) DEFAULT '',
	class_name VARCHAR2 ( 100 ) DEFAULT '',
	tpl_category VARCHAR2 ( 200 ) DEFAULT 'crud',
	package_name VARCHAR2 ( 100 ) DEFAULT NULL,
	module_name VARCHAR2 ( 30 ) DEFAULT NULL,
	business_name VARCHAR2 ( 30 ) DEFAULT NULL,
	function_name VARCHAR2 ( 50 ) DEFAULT NULL,
	function_author VARCHAR2 ( 50 ) DEFAULT NULL,
	options VARCHAR2 ( 1000 ) DEFAULT NULL,
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT NULL,
	constraint PK_GEN_TABLE primary key ( table_id ) 
);
COMMENT ON TABLE gen_table IS '代码生成业务表';
COMMENT ON COLUMN gen_table.table_id IS '编号';
COMMENT ON COLUMN gen_table.table_name IS '表名称';
COMMENT ON COLUMN gen_table.table_comment IS '表描述';
COMMENT ON COLUMN gen_table.class_name IS '实体类名称';
COMMENT ON COLUMN gen_table.tpl_category IS '使用的模板（crud单表操作 tree树表操作）';
COMMENT ON COLUMN gen_table.package_name IS '生成包路径';
COMMENT ON COLUMN gen_table.module_name IS '生成模块名';
COMMENT ON COLUMN gen_table.business_name IS '生成业务名';
COMMENT ON COLUMN gen_table.function_name IS '生成功能名';
COMMENT ON COLUMN gen_table.function_author IS '生成功能作者';
COMMENT ON COLUMN gen_table.options IS '其它生成选项';
COMMENT ON COLUMN gen_table.create_by IS '创建者';
COMMENT ON COLUMN gen_table.create_time IS '创建时间';
COMMENT ON COLUMN gen_table.update_by IS '更新者';
COMMENT ON COLUMN gen_table.update_time IS '更新时间';
COMMENT ON COLUMN gen_table.remark IS '备注';
/*==============================================================*/
/* Table: 代码生成业务表字段                                    */
/*==============================================================*/
CREATE sequence S_gen_table_column INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE gen_table_column (
	column_id NUMBER ( 6 ) NOT NULL,
	table_id VARCHAR2 ( 64 ) DEFAULT NULL,
	column_name VARCHAR2 ( 200 ) DEFAULT NULL,
	column_comment VARCHAR2 ( 500 ) DEFAULT NULL,
	column_type VARCHAR2 ( 100 ) DEFAULT NULL,
	java_type VARCHAR2 ( 500 ) DEFAULT NULL,
	java_field VARCHAR2 ( 200 ) DEFAULT NULL,
	is_pk CHAR ( 1 ) DEFAULT NULL,
	is_increment CHAR ( 1 ) DEFAULT NULL,
	is_required CHAR ( 1 ) DEFAULT NULL,
	is_insert CHAR ( 1 ) DEFAULT NULL,
	is_edit CHAR ( 1 ) DEFAULT NULL,
	is_list CHAR ( 1 ) DEFAULT NULL,
	is_query CHAR ( 1 ) DEFAULT NULL,
	query_type VARCHAR2 ( 200 ) DEFAULT 'EQ',
	html_type VARCHAR2 ( 200 ) DEFAULT NULL,
	dict_type VARCHAR2 ( 200 ) DEFAULT '',
	sort INTEGER DEFAULT NULL,
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	constraint PK_GEN_TABLE_COLUMN primary key ( column_id ) 
);
COMMENT ON TABLE gen_table_column IS '代码生成业务表字段';
COMMENT ON COLUMN gen_table_column.column_id IS '编号';
COMMENT ON COLUMN gen_table_column.table_id IS '归属表编号';
COMMENT ON COLUMN gen_table_column.column_name IS '列名称';
COMMENT ON COLUMN gen_table_column.column_comment IS '列描述';
COMMENT ON COLUMN gen_table_column.column_type IS '列类型';
COMMENT ON COLUMN gen_table_column.java_type IS 'JAVA类型';
COMMENT ON COLUMN gen_table_column.java_field IS 'JAVA字段名';
COMMENT ON COLUMN gen_table_column.is_pk IS '是否主键（1是）';
COMMENT ON COLUMN gen_table_column.is_increment IS '是否自增（1是）';
COMMENT ON COLUMN gen_table_column.is_required IS '是否必填（1是）';
COMMENT ON COLUMN gen_table_column.is_insert IS '是否为插入字段（1是）';
COMMENT ON COLUMN gen_table_column.is_edit IS '是否编辑字段（1是）';
COMMENT ON COLUMN gen_table_column.is_list IS '是否列表字段（1是）';
COMMENT ON COLUMN gen_table_column.is_query IS '是否查询字段（1是）';
COMMENT ON COLUMN gen_table_column.query_type IS '查询方式（等于、不等于、大于、小于、范围）';
COMMENT ON COLUMN gen_table_column.html_type IS '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）';
COMMENT ON COLUMN gen_table_column.dict_type IS '字典类型';
COMMENT ON COLUMN gen_table_column.sort IS '排序';
COMMENT ON COLUMN gen_table_column.create_by IS '创建者';
COMMENT ON COLUMN gen_table_column.create_time IS '创建时间';
COMMENT ON COLUMN gen_table_column.update_by IS '更新者';
COMMENT ON COLUMN gen_table_column.update_time IS '更新时间';
/*==============================================================*/
/* Table: 参数配置表                                         */
/*==============================================================*/
CREATE sequence S_sys_config INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_config (
	config_id NUMBER ( 6 ) NOT NULL,
	config_name VARCHAR2 ( 100 ) DEFAULT '',
	config_key VARCHAR2 ( 100 ) DEFAULT '',
	config_value VARCHAR2 ( 500 ) DEFAULT '',
	config_type CHAR ( 1 ) DEFAULT 'N',
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT NULL,
	constraint PK_SYS_CONFIG primary key ( config_id ) 
);
COMMENT ON TABLE sys_config IS '参数配置表';
COMMENT ON COLUMN sys_config.config_id IS '参数主键';
COMMENT ON COLUMN sys_config.config_name IS '参数名称';
COMMENT ON COLUMN sys_config.config_key IS '参数键名';
COMMENT ON COLUMN sys_config.config_value IS '参数键值';
COMMENT ON COLUMN sys_config.config_type IS '系统内置（Y是 N否）';
COMMENT ON COLUMN sys_config.create_by IS '创建者';
COMMENT ON COLUMN sys_config.create_time IS '创建时间';
COMMENT ON COLUMN sys_config.update_by IS '更新者';
COMMENT ON COLUMN sys_config.update_time IS '更新时间';
COMMENT ON COLUMN sys_config.remark IS '备注';
/*==============================================================*/
/* Table: 部门表                                            */
/*==============================================================*/
CREATE sequence S_sys_dept INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_dept (
	dept_id NUMBER ( 6 ) NOT NULL,
	parent_id INTEGER DEFAULT 0,
	ancestors VARCHAR2 ( 50 ) DEFAULT '',
	dept_code VARCHAR2 ( 50 ) DEFAULT NULL,
	dept_name VARCHAR2 ( 30 ) DEFAULT '',
	order_num INTEGER DEFAULT 0,
	leader VARCHAR2 ( 20 ) DEFAULT NULL,
	phone VARCHAR2 ( 11 ) DEFAULT NULL,
	email VARCHAR2 ( 50 ) DEFAULT NULL,
	status CHAR ( 1 ) DEFAULT '0',
	del_flag CHAR ( 1 ) DEFAULT '0',
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	constraint PK_SYS_DEPT primary key ( dept_id ) 
);
COMMENT ON TABLE sys_dept IS '部门表';
COMMENT ON COLUMN sys_dept.dept_id IS '部门id';
COMMENT ON COLUMN sys_dept.parent_id IS '父部门id';
COMMENT ON COLUMN sys_dept.ancestors IS '祖级列表';
COMMENT ON COLUMN sys_dept.dept_code IS '部门编码';
COMMENT ON COLUMN sys_dept.dept_name IS '部门名称';
COMMENT ON COLUMN sys_dept.order_num IS '显示顺序';
COMMENT ON COLUMN sys_dept.leader IS '负责人';
COMMENT ON COLUMN sys_dept.phone IS '联系电话';
COMMENT ON COLUMN sys_dept.email IS '邮箱';
COMMENT ON COLUMN sys_dept.status IS '部门状态（0正常 1停用）';
COMMENT ON COLUMN sys_dept.del_flag IS '删除标志（0代表存在 2代表删除）';
COMMENT ON COLUMN sys_dept.create_by IS '创建者';
COMMENT ON COLUMN sys_dept.create_time IS '创建时间';
COMMENT ON COLUMN sys_dept.update_by IS '更新者';
COMMENT ON COLUMN sys_dept.update_time IS '更新时间';
/*==============================================================*/
/* Table: 字典数据表                                       */
/*==============================================================*/
CREATE sequence S_sys_dict_data INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_dict_data (
	dict_code NUMBER ( 6 ) NOT NULL,
	dict_sort INTEGER DEFAULT 0,
	dict_label VARCHAR2 ( 100 ) DEFAULT '',
	dict_value VARCHAR2 ( 100 ) DEFAULT '',
	dict_type VARCHAR2 ( 100 ) DEFAULT '',
	css_class VARCHAR2 ( 100 ) DEFAULT NULL,
	list_class VARCHAR2 ( 100 ) DEFAULT NULL,
	is_default CHAR ( 1 ) DEFAULT 'N',
	status CHAR ( 1 ) DEFAULT '0',
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT NULL,
	constraint PK_SYS_DICT_DATA primary key ( dict_code ) 
);
COMMENT ON TABLE sys_dict_data IS '字典数据表';
COMMENT ON COLUMN sys_dict_data.dict_code IS '字典编码';
COMMENT ON COLUMN sys_dict_data.dict_sort IS '字典排序';
COMMENT ON COLUMN sys_dict_data.dict_label IS '字典标签';
COMMENT ON COLUMN sys_dict_data.dict_value IS '字典键值';
COMMENT ON COLUMN sys_dict_data.dict_type IS '字典类型';
COMMENT ON COLUMN sys_dict_data.css_class IS '样式属性（其他样式扩展）';
COMMENT ON COLUMN sys_dict_data.list_class IS '表格回显样式';
COMMENT ON COLUMN sys_dict_data.is_default IS '是否默认（Y是 N否）';
COMMENT ON COLUMN sys_dict_data.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN sys_dict_data.create_by IS '创建者';
COMMENT ON COLUMN sys_dict_data.create_time IS '创建时间';
COMMENT ON COLUMN sys_dict_data.update_by IS '更新者';
COMMENT ON COLUMN sys_dict_data.update_time IS '更新时间';
COMMENT ON COLUMN sys_dict_data.remark IS '备注';
/*==============================================================*/
/* Table: 字典类型表                                            */
/*==============================================================*/
CREATE sequence S_sys_dict_type INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_dict_type (
	dict_id NUMBER ( 6 ) NOT NULL,
	dict_name VARCHAR2 ( 100 ) DEFAULT '',
	dict_type VARCHAR2 ( 100 ) DEFAULT '',
	status CHAR ( 1 ) DEFAULT '0',
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT NULL,
	constraint PK_SYS_DICT_TYPE primary key ( dict_id ),
	constraint dict_type UNIQUE ( dict_type ) 
);
COMMENT ON TABLE sys_dict_type IS '字典类型表';
COMMENT ON COLUMN sys_dict_type.dict_id IS '字典主键';
COMMENT ON COLUMN sys_dict_type.dict_name IS '字典名称';
COMMENT ON COLUMN sys_dict_type.dict_type IS '字典类型';
COMMENT ON COLUMN sys_dict_type.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN sys_dict_type.create_by IS '创建者';
COMMENT ON COLUMN sys_dict_type.create_time IS '创建时间';
COMMENT ON COLUMN sys_dict_type.update_by IS '更新者';
COMMENT ON COLUMN sys_dict_type.update_time IS '更新时间';
COMMENT ON COLUMN sys_dict_type.remark IS '备注';
/*==============================================================*/
/* Table: 系统访问记录                                      */
/*==============================================================*/
CREATE sequence S_sys_logininfor INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_logininfor (
	info_id NUMBER ( 6 ) NOT NULL,
	login_name VARCHAR2 ( 50 ) DEFAULT '',
	ipaddr VARCHAR2 ( 50 ) DEFAULT '',
	login_location VARCHAR2 ( 255 ) DEFAULT '',
	browser VARCHAR2 ( 50 ) DEFAULT '',
	os VARCHAR2 ( 50 ) DEFAULT '',
	status CHAR ( 1 ) DEFAULT '0',
	msg VARCHAR2 ( 255 ) DEFAULT '',
	login_time DATE DEFAULT NULL,
	constraint PK_SYS_LOGININFOR primary key ( info_id ) 
);
COMMENT ON TABLE sys_logininfor IS '系统访问记录';
COMMENT ON COLUMN sys_logininfor.info_id IS '访问ID';
COMMENT ON COLUMN sys_logininfor.login_name IS '登录账号';
COMMENT ON COLUMN sys_logininfor.ipaddr IS '登录IP地址';
COMMENT ON COLUMN sys_logininfor.login_location IS '登录地点';
COMMENT ON COLUMN sys_logininfor.browser IS '浏览器类型';
COMMENT ON COLUMN sys_logininfor.os IS '操作系统';
COMMENT ON COLUMN sys_logininfor.status IS '登录状态（0成功 1失败）';
COMMENT ON COLUMN sys_logininfor.msg IS '提示消息';
COMMENT ON COLUMN sys_logininfor.login_time IS '访问时间';
/*==============================================================*/
/* Table: 菜单权限表                                            */
/*==============================================================*/
CREATE sequence S_sys_menu INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_menu (
	menu_id NUMBER ( 6 ) NOT NULL,
	menu_name VARCHAR2 ( 50 ) NOT NULL,
	parent_id INTEGER DEFAULT 0,
	order_num INTEGER DEFAULT 0,
	url VARCHAR2 ( 200 ) DEFAULT '#',
	target VARCHAR2 ( 20 ) DEFAULT '',
	menu_type CHAR ( 1 ) DEFAULT '',
	visible CHAR ( 1 ) DEFAULT '0',
	perms VARCHAR2 ( 100 ) DEFAULT NULL,
	icon VARCHAR2 ( 100 ) DEFAULT '#',
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT '',
	constraint PK_SYS_MENU primary key ( menu_id ) 
);
COMMENT ON TABLE sys_menu IS '菜单权限表';
COMMENT ON COLUMN sys_menu.menu_id IS '菜单ID';
COMMENT ON COLUMN sys_menu.menu_name IS '菜单名称';
COMMENT ON COLUMN sys_menu.parent_id IS '父菜单ID';
COMMENT ON COLUMN sys_menu.order_num IS '显示顺序';
COMMENT ON COLUMN sys_menu.url IS '请求地址';
COMMENT ON COLUMN sys_menu.target IS '打开方式（menuItem页签 menuBlank新窗口）';
COMMENT ON COLUMN sys_menu.menu_type IS '菜单类型（M目录 C菜单 F按钮）';
COMMENT ON COLUMN sys_menu.visible IS '菜单状态（0显示 1隐藏）';
COMMENT ON COLUMN sys_menu.perms IS '权限标识';
COMMENT ON COLUMN sys_menu.icon IS '菜单图标';
COMMENT ON COLUMN sys_menu.create_by IS '创建者';
COMMENT ON COLUMN sys_menu.create_time IS '创建时间';
COMMENT ON COLUMN sys_menu.update_by IS '更新者';
COMMENT ON COLUMN sys_menu.update_time IS '更新时间';
COMMENT ON COLUMN sys_menu.remark IS '备注';
/*==============================================================*/
/* Table: 通知公告表                                          */
/*==============================================================*/
CREATE sequence S_sys_notice INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_notice (
	notice_id NUMBER ( 6 ) NOT NULL,
	notice_title VARCHAR2 ( 50 ) NOT NULL,
	notice_type CHAR ( 1 ) NOT NULL,
	notice_content VARCHAR2 ( 2000 ) DEFAULT NULL,
	status CHAR ( 1 ) DEFAULT '0',
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 255 ) DEFAULT NULL,
	constraint PK_SYS_NOTICE primary key ( notice_id ) 
);
COMMENT ON TABLE sys_notice IS '通知公告表';
COMMENT ON COLUMN sys_notice.notice_id IS '公告ID';
COMMENT ON COLUMN sys_notice.notice_title IS '公告标题';
COMMENT ON COLUMN sys_notice.notice_type IS '公告类型（1通知 2公告）';
COMMENT ON COLUMN sys_notice.notice_content IS '公告内容';
COMMENT ON COLUMN sys_notice.status IS '公告状态（0正常 1关闭）';
COMMENT ON COLUMN sys_notice.create_by IS '创建者';
COMMENT ON COLUMN sys_notice.create_time IS '创建时间';
COMMENT ON COLUMN sys_notice.update_by IS '更新者';
COMMENT ON COLUMN sys_notice.update_time IS '更新时间';
COMMENT ON COLUMN sys_notice.remark IS '备注';
/*==============================================================*/
/* Table: 操作日志记录                                       */
/*==============================================================*/
CREATE sequence S_sys_oper_log INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_oper_log (
	oper_id NUMBER ( 6 ) NOT NULL,
	title VARCHAR2 ( 50 ) DEFAULT '',
	business_type INTEGER DEFAULT 0,
	method VARCHAR2 ( 100 ) DEFAULT '',
	request_method VARCHAR2 ( 10 ) DEFAULT '',
	operator_type INTEGER DEFAULT 0,
	oper_name VARCHAR2 ( 50 ) DEFAULT '',
	dept_name VARCHAR2 ( 50 ) DEFAULT '',
	oper_url VARCHAR2 ( 255 ) DEFAULT '',
	oper_ip VARCHAR2 ( 50 ) DEFAULT '',
	oper_location VARCHAR2 ( 255 ) DEFAULT '',
	oper_param VARCHAR2 ( 2000 ) DEFAULT '',
	json_result VARCHAR2 ( 2000 ) DEFAULT '',
	status INTEGER DEFAULT 0,
	error_msg VARCHAR2 ( 2000 ) DEFAULT '',
	oper_time DATE DEFAULT NULL,
	constraint PK_SYS_OPER_LOG primary key ( oper_id ) 
);
COMMENT ON TABLE sys_oper_log IS '操作日志记录';
COMMENT ON COLUMN sys_oper_log.oper_id IS '日志主键';
COMMENT ON COLUMN sys_oper_log.title IS '模块标题';
COMMENT ON COLUMN sys_oper_log.business_type IS '业务类型（0其它 1新增 2修改 3删除）';
COMMENT ON COLUMN sys_oper_log.method IS '方法名称';
COMMENT ON COLUMN sys_oper_log.request_method IS '请求方式';
COMMENT ON COLUMN sys_oper_log.operator_type IS '操作类别（0其它 1后台用户 2手机端用户）';
COMMENT ON COLUMN sys_oper_log.oper_name IS '操作人员';
COMMENT ON COLUMN sys_oper_log.dept_name IS '部门名称';
COMMENT ON COLUMN sys_oper_log.oper_url IS '请求URL';
COMMENT ON COLUMN sys_oper_log.oper_ip IS '主机地址';
COMMENT ON COLUMN sys_oper_log.oper_location IS '操作地点';
COMMENT ON COLUMN sys_oper_log.oper_param IS '请求参数';
COMMENT ON COLUMN sys_oper_log.json_result IS '返回参数';
COMMENT ON COLUMN sys_oper_log.status IS '操作状态（0正常 1异常）';
COMMENT ON COLUMN sys_oper_log.error_msg IS '错误消息';
COMMENT ON COLUMN sys_oper_log.oper_time IS '操作时间';
/*==============================================================*/
/* Table: 岗位信息表                                            */
/*==============================================================*/
CREATE sequence S_sys_post INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_post (
	post_id NUMBER ( 6 ) NOT NULL,
	post_code VARCHAR2 ( 64 ) NOT NULL,
	post_name VARCHAR2 ( 50 ) NOT NULL,
	post_sort INTEGER NOT NULL,
	status CHAR ( 1 ) NOT NULL,
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT NULL,
	constraint PK_SYS_POST primary key ( post_id ) 
);
COMMENT ON TABLE sys_post IS '岗位信息表';
COMMENT ON COLUMN sys_post.post_id IS '岗位ID';
COMMENT ON COLUMN sys_post.post_code IS '岗位编码';
COMMENT ON COLUMN sys_post.post_name IS '岗位名称';
COMMENT ON COLUMN sys_post.post_sort IS '显示顺序';
COMMENT ON COLUMN sys_post.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN sys_post.create_by IS '创建者';
COMMENT ON COLUMN sys_post.create_time IS '创建时间';
COMMENT ON COLUMN sys_post.update_by IS '更新者';
COMMENT ON COLUMN sys_post.update_time IS '更新时间';
COMMENT ON COLUMN sys_post.remark IS '备注';
/*==============================================================*/
/* Table: 角色信息表                                            */
/*==============================================================*/
CREATE sequence S_sys_role INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_role (
	role_id NUMBER ( 6 ) NOT NULL,
	role_name VARCHAR2 ( 30 ) NOT NULL,
	role_key VARCHAR2 ( 100 ) NOT NULL,
	role_sort INTEGER NOT NULL,
	data_scope CHAR ( 1 ) DEFAULT '1',
	status CHAR ( 1 ) NOT NULL,
	del_flag CHAR ( 1 ) DEFAULT '0',
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT NULL,
	constraint PK_SYS_ROLE primary key ( role_id ) 
);
COMMENT ON TABLE sys_role IS '角色信息表';
COMMENT ON COLUMN sys_role.role_id IS '角色ID';
COMMENT ON COLUMN sys_role.role_name IS '角色名称';
COMMENT ON COLUMN sys_role.role_key IS '角色权限字符串';
COMMENT ON COLUMN sys_role.role_sort IS '显示顺序';
COMMENT ON COLUMN sys_role.data_scope IS '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）';
COMMENT ON COLUMN sys_role.status IS '角色状态（0正常 1停用）';
COMMENT ON COLUMN sys_role.del_flag IS '删除标志（0代表存在 2代表删除）';
COMMENT ON COLUMN sys_role.create_by IS '创建者';
COMMENT ON COLUMN sys_role.create_time IS '创建时间';
COMMENT ON COLUMN sys_role.update_by IS '更新者';
COMMENT ON COLUMN sys_role.update_time IS '更新时间';
COMMENT ON COLUMN sys_role.remark IS '备注';
/*==============================================================*/
/* Table: 角色和部门关联表                                       */
/*==============================================================*/
CREATE TABLE sys_role_dept ( role_id INTEGER NOT NULL, dept_id INTEGER NOT NULL, constraint PK_SYS_ROLE_DEPT primary key ( role_id, dept_id ) );
COMMENT ON TABLE sys_role_dept IS '角色和部门关联表';
COMMENT ON COLUMN sys_role_dept.role_id IS '角色ID';
COMMENT ON COLUMN sys_role_dept.dept_id IS '部门ID';
/*==============================================================*/
/* Table: 角色和菜单关联表                                       */
/*==============================================================*/
CREATE TABLE sys_role_menu ( role_id INTEGER NOT NULL, menu_id INTEGER NOT NULL, constraint PK_SYS_ROLE_MENU primary key ( role_id, menu_id ) );
COMMENT ON TABLE sys_role_menu IS '角色和菜单关联表';
COMMENT ON COLUMN sys_role_menu.role_id IS '角色ID';
COMMENT ON COLUMN sys_role_menu.menu_id IS '菜单ID';
/*==============================================================*/
/* Table: 用户信息表                                            */
/*==============================================================*/
CREATE sequence S_sys_user INCREMENT BY 1 START WITH 1 nomaxvalue nominvalue cache 20;
CREATE TABLE sys_user (
	user_id NUMBER ( 6 ) NOT NULL,
	dept_id INTEGER DEFAULT NULL,
	login_name VARCHAR2 ( 30 ) NOT NULL,
	user_name VARCHAR2 ( 30 ) DEFAULT '',
	user_type VARCHAR2 ( 2 ) DEFAULT '00',
	email VARCHAR2 ( 50 ) DEFAULT '',
	phonenumber VARCHAR2 ( 11 ) DEFAULT '',
	sex CHAR ( 1 ) DEFAULT '0',
	avatar VARCHAR2 ( 100 ) DEFAULT '',
	password VARCHAR2 ( 50 ) DEFAULT '',
	salt VARCHAR2 ( 20 ) DEFAULT '',
	status CHAR ( 1 ) DEFAULT '0',
	del_flag CHAR ( 1 ) DEFAULT '0',
	login_ip VARCHAR2 ( 50 ) DEFAULT '',
	login_date DATE DEFAULT NULL,
	create_by VARCHAR2 ( 64 ) DEFAULT '',
	create_time DATE DEFAULT NULL,
	update_by VARCHAR2 ( 64 ) DEFAULT '',
	update_time DATE DEFAULT NULL,
	remark VARCHAR2 ( 500 ) DEFAULT NULL,
	constraint PK_SYS_USER primary key ( user_id ) 
);
COMMENT ON TABLE sys_user IS '用户信息表';
COMMENT ON COLUMN sys_user.user_id IS '用户ID';
COMMENT ON COLUMN sys_user.dept_id IS '部门ID';
COMMENT ON COLUMN sys_user.login_name IS '登录账号';
COMMENT ON COLUMN sys_user.user_name IS '用户昵称';
COMMENT ON COLUMN sys_user.user_type IS '用户类型（00系统用户）';
COMMENT ON COLUMN sys_user.email IS '用户邮箱';
COMMENT ON COLUMN sys_user.phonenumber IS '手机号码';
COMMENT ON COLUMN sys_user.sex IS '用户性别（0男 1女 2未知）';
COMMENT ON COLUMN sys_user.avatar IS '头像路径';
COMMENT ON COLUMN sys_user.password IS '密码';
COMMENT ON COLUMN sys_user.salt IS '盐加密';
COMMENT ON COLUMN sys_user.status IS '帐号状态（0正常 1停用）';
COMMENT ON COLUMN sys_user.del_flag IS '删除标志（0代表存在 2代表删除）';
COMMENT ON COLUMN sys_user.login_ip IS '最后登陆IP';
COMMENT ON COLUMN sys_user.login_date IS '最后登陆时间';
COMMENT ON COLUMN sys_user.create_by IS '创建者';
COMMENT ON COLUMN sys_user.create_time IS '创建时间';
COMMENT ON COLUMN sys_user.update_by IS '更新者';
COMMENT ON COLUMN sys_user.update_time IS '更新时间';
COMMENT ON COLUMN sys_user.remark IS '备注';
/*==============================================================*/
/* Table: 在线用户记录                                     */
/*==============================================================*/
CREATE TABLE sys_user_online (
	sessionId VARCHAR2 ( 50 ) DEFAULT '' NOT NULL,
	login_name VARCHAR2 ( 50 ) DEFAULT '',
	dept_name VARCHAR2 ( 50 ) DEFAULT '',
	ipaddr VARCHAR2 ( 50 ) DEFAULT '',
	login_location VARCHAR2 ( 255 ) DEFAULT '',
	browser VARCHAR2 ( 50 ) DEFAULT '',
	os VARCHAR2 ( 50 ) DEFAULT '',
	status VARCHAR2 ( 10 ) DEFAULT '',
	start_timestamp DATE DEFAULT NULL,
	last_access_time DATE DEFAULT NULL,
	expire_time INTEGER DEFAULT 0,
	constraint PK_SYS_USER_ONLINE primary key ( sessionId ) 
);
COMMENT ON TABLE sys_user_online IS '在线用户记录';
COMMENT ON COLUMN sys_user_online.sessionId IS '用户会话id';
COMMENT ON COLUMN sys_user_online.login_name IS '登录账号';
COMMENT ON COLUMN sys_user_online.dept_name IS '部门名称';
COMMENT ON COLUMN sys_user_online.ipaddr IS '登录IP地址';
COMMENT ON COLUMN sys_user_online.login_location IS '登录地点';
COMMENT ON COLUMN sys_user_online.browser IS '浏览器类型';
COMMENT ON COLUMN sys_user_online.os IS '操作系统';
COMMENT ON COLUMN sys_user_online.status IS '在线状态on_line在线off_line离线';
COMMENT ON COLUMN sys_user_online.start_timestamp IS 'session创建时间';
COMMENT ON COLUMN sys_user_online.last_access_time IS 'session最后访问时间';
COMMENT ON COLUMN sys_user_online.expire_time IS '超时时间，单位为分钟';
/*==============================================================*/
/* Table: 用户与岗位关联表                                       */
/*==============================================================*/
CREATE TABLE sys_user_post ( user_id INTEGER NOT NULL, post_id INTEGER NOT NULL, constraint PK_SYS_USER_POST primary key ( user_id, post_id ) );
COMMENT ON TABLE sys_user_post IS '用户与岗位关联表';
COMMENT ON COLUMN sys_user_post.user_id IS '用户ID';
COMMENT ON COLUMN sys_user_post.post_id IS '岗位ID';
/*==============================================================*/
/* Table: 用户和角色关联表                                       */
/*==============================================================*/
CREATE TABLE sys_user_role ( user_id INTEGER NOT NULL, role_id INTEGER NOT NULL, constraint PK_SYS_USER_ROLE primary key ( user_id, role_id ) );
COMMENT ON TABLE sys_user_role IS '用户和角色关联表';
COMMENT ON COLUMN sys_user_role.user_id IS '用户ID';
COMMENT ON COLUMN sys_user_role.role_id IS '角色ID';
/*==============================================================*/
/* Table: 基础数据_应用系统接口授权表                           */
/*==============================================================*/
CREATE TABLE base_app_interface_auth (
	id VARCHAR2 ( 48 ) NOT NULL,
	app_id VARCHAR2 ( 48 ) NOT NULL,
	trans_code VARCHAR2 ( 255 ) NOT NULL,
	trans_end_time DATE,
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	remark VARCHAR2 ( 255 ),
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_APP_INTERFACE_AUTH primary key ( id ) 
);
COMMENT ON TABLE base_app_interface_auth IS '基础数据_应用系统接口授权表';
COMMENT ON COLUMN base_app_interface_auth.id IS '主键';
COMMENT ON COLUMN base_app_interface_auth.app_id IS '应用系统主键';
COMMENT ON COLUMN base_app_interface_auth.trans_code IS '接口交易码(数据字典)';
COMMENT ON COLUMN base_app_interface_auth.trans_end_time IS '交易有效截止时间';
COMMENT ON COLUMN base_app_interface_auth.tenant IS '租户';
COMMENT ON COLUMN base_app_interface_auth.remark IS '备注';
COMMENT ON COLUMN base_app_interface_auth.create_by IS '创建人';
COMMENT ON COLUMN base_app_interface_auth.update_by IS '修改人';
COMMENT ON COLUMN base_app_interface_auth.create_time IS '创建时间';
COMMENT ON COLUMN base_app_interface_auth.update_time IS '修改时间';
COMMENT ON COLUMN base_app_interface_auth.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 基础数据_应用系统管理表                                */
/*==============================================================*/
CREATE TABLE base_app_manage (
	id VARCHAR2 ( 48 ) NOT NULL,
	app_key VARCHAR2 ( 255 ) NOT NULL,
	app_secret VARCHAR2 ( 255 ) NOT NULL,
	app_desc VARCHAR2 ( 255 ),
	remark VARCHAR2 ( 255 ),
	built_in VARCHAR2 ( 1 ) DEFAULT 'N' NOT NULL,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_APP_MANAGE primary key ( id ) 
);
COMMENT ON TABLE base_app_manage IS '基础数据_应用系统管理表';
COMMENT ON COLUMN base_app_manage.id IS '主键';
COMMENT ON COLUMN base_app_manage.app_key IS '应用系统键值';
COMMENT ON COLUMN base_app_manage.app_secret IS '应用系统密钥';
COMMENT ON COLUMN base_app_manage.app_desc IS '应用系统描述';
COMMENT ON COLUMN base_app_manage.remark IS '备注';
COMMENT ON COLUMN base_app_manage.built_in IS '是否内置(Y ：是，N：否)';
COMMENT ON COLUMN base_app_manage.create_by IS '创建人';
COMMENT ON COLUMN base_app_manage.update_by IS '修改人';
COMMENT ON COLUMN base_app_manage.create_time IS '创建时间';
COMMENT ON COLUMN base_app_manage.update_time IS '修改时间';
COMMENT ON COLUMN base_app_manage.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 基础数据_人员证件信息                               */
/*==============================================================*/
CREATE TABLE base_person_cert (
	id VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ) NOT NULL,
	cert_type VARCHAR2 ( 3 ) NOT NULL,
	cert_num VARCHAR2 ( 255 ) NOT NULL,
	cert_name VARCHAR2 ( 64 ),
	cert_validity VARCHAR2 ( 48 ),
	gender CHAR ( 1 ),
	bth_date VARCHAR2 ( 48 ),
	nation VARCHAR2 ( 3 ),
	address VARCHAR2 ( 255 ),
	cert_authority VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	operate_id VARCHAR2 ( 255 ),
	cert_img VARCHAR2 ( 255 ),
	enterschool_img VARCHAR2 ( 255 ),
	inschool_img VARCHAR2 ( 255 ),
	graduate_img VARCHAR2 ( 255 ),
	remark VARCHAR2 ( 255 ),
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_PERSON_CERT primary key ( id ) 
);
COMMENT ON TABLE base_person_cert IS '基础数据_人员证件信息';
COMMENT ON COLUMN base_person_cert.id IS '主键';
COMMENT ON COLUMN base_person_cert.unique_id IS '人员标识';
COMMENT ON COLUMN base_person_cert.cert_type IS '证件类型（字典国标）';
COMMENT ON COLUMN base_person_cert.cert_num IS '证件号码';
COMMENT ON COLUMN base_person_cert.cert_name IS '证件姓名';
COMMENT ON COLUMN base_person_cert.cert_validity IS '证件有效期';
COMMENT ON COLUMN base_person_cert.gender IS '性别：0-女  1-男  2-未知';
COMMENT ON COLUMN base_person_cert.bth_date IS '出生日期';
COMMENT ON COLUMN base_person_cert.nation IS '民族';
COMMENT ON COLUMN base_person_cert.address IS '家庭住址';
COMMENT ON COLUMN base_person_cert.cert_authority IS '发证机关';
COMMENT ON COLUMN base_person_cert.tenant IS '租户';
COMMENT ON COLUMN base_person_cert.operate_id IS '操作管理员ID，用于权限控制(有多个的话用“,”分割)';
COMMENT ON COLUMN base_person_cert.cert_img IS '证件照';
COMMENT ON COLUMN base_person_cert.enterschool_img IS '入学照片';
COMMENT ON COLUMN base_person_cert.inschool_img IS '在校照片';
COMMENT ON COLUMN base_person_cert.graduate_img IS '毕业照片';
COMMENT ON COLUMN base_person_cert.remark IS '备注';
COMMENT ON COLUMN base_person_cert.create_by IS '创建人';
COMMENT ON COLUMN base_person_cert.update_by IS '修改人';
COMMENT ON COLUMN base_person_cert.create_time IS '创建时间';
COMMENT ON COLUMN base_person_cert.update_time IS '修改时间';
COMMENT ON COLUMN base_person_cert.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 基础数据_人脸图像信息                                  */
/*==============================================================*/
CREATE TABLE base_person_face (
	id VARCHAR2 ( 48 ) NOT NULL,
	person_id VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ) NOT NULL,
	feature VARCHAR2 ( 4000 ) NOT NULL,
	feature_md5 VARCHAR2 ( 255 ),
	quality_score BINARY_DOUBLE,
	image_url VARCHAR2 ( 255 ) NOT NULL,
	coordinate VARCHAR2 ( 48 ),
	vendor_code VARCHAR2 ( 48 ),
	algs_version VARCHAR2 ( 48 ),
	encrypted CHAR ( 1 ) DEFAULT '0',
	datasource VARCHAR2 ( 48 ) DEFAULT 'INTERFACE' NOT NULL,
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	operate_id VARCHAR2 ( 255 ),
	remark VARCHAR2 ( 255 ),
	status CHAR ( 1 ) DEFAULT '0' NOT NULL,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_PERSON_FACE primary key ( id ) 
);
COMMENT ON TABLE base_person_face IS '基础数据_人脸图像信息';
COMMENT ON COLUMN base_person_face.id IS '主键';
COMMENT ON COLUMN base_person_face.person_id IS '关联人员主键(基础信息_人员信息表ID)';
COMMENT ON COLUMN base_person_face.unique_id IS '人员标识';
COMMENT ON COLUMN base_person_face.feature IS '人脸特征';
COMMENT ON COLUMN base_person_face.feature_md5 IS '人脸特征MD5';
COMMENT ON COLUMN base_person_face.quality_score IS '图像质量得分';
COMMENT ON COLUMN base_person_face.image_url IS '人脸图像路径';
COMMENT ON COLUMN base_person_face.coordinate IS '人脸坐标';
COMMENT ON COLUMN base_person_face.vendor_code IS '厂商';
COMMENT ON COLUMN base_person_face.algs_version IS '算法版本';
COMMENT ON COLUMN base_person_face.encrypted IS '是否加密： 1-加密 0-不加密';
COMMENT ON COLUMN base_person_face.datasource IS '数据来源：INTERFACE-接口 IMP-导入 HTTP-HTTP接口';
COMMENT ON COLUMN base_person_face.tenant IS '租户';
COMMENT ON COLUMN base_person_face.operate_id IS '操作管理员ID，用于权限控制(有多个的话用“,”分割)';
COMMENT ON COLUMN base_person_face.remark IS '备注';
COMMENT ON COLUMN base_person_face.status IS '状态：0-有效  1:无效';
COMMENT ON COLUMN base_person_face.create_by IS '创建人';
COMMENT ON COLUMN base_person_face.update_by IS '修改人';
COMMENT ON COLUMN base_person_face.create_time IS '创建时间';
COMMENT ON COLUMN base_person_face.update_time IS '修改时间';
COMMENT ON COLUMN base_person_face.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 基础数据_指纹图像信息                                 */
/*==============================================================*/
CREATE TABLE base_person_finger (
	id VARCHAR2 ( 48 ) NOT NULL,
	person_id VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ) NOT NULL,
	finger_no VARCHAR2 ( 2 ) NOT NULL,
	coercive_position VARCHAR2 ( 2 ) DEFAULT '0' NOT NULL,
	feature VARCHAR2 ( 4000 ) NOT NULL,
	feature_md5 VARCHAR2 ( 255 ),
	quality_score BINARY_DOUBLE,
	image_url VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 48 ),
	algs_version VARCHAR2 ( 48 ),
	encrypted CHAR ( 1 ) DEFAULT '0',
	datasource VARCHAR2 ( 48 ) DEFAULT 'INTERFACE' NOT NULL,
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	operate_id VARCHAR2 ( 255 ),
	remark VARCHAR2 ( 255 ),
	status CHAR ( 1 ) DEFAULT '0' NOT NULL,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_PERSON_FINGER primary key ( id ) 
);
COMMENT ON TABLE base_person_finger IS '基础数据_指纹图像信息';
COMMENT ON COLUMN base_person_finger.id IS '主键';
COMMENT ON COLUMN base_person_finger.person_id IS '关联人员主键(基础信息_人员信息表ID)';
COMMENT ON COLUMN base_person_finger.unique_id IS '人员标识';
COMMENT ON COLUMN base_person_finger.finger_no IS '手指编号';
COMMENT ON COLUMN base_person_finger.coercive_position IS '胁迫位';
COMMENT ON COLUMN base_person_finger.feature IS '指纹特征';
COMMENT ON COLUMN base_person_finger.feature_md5 IS '指纹特征MD5';
COMMENT ON COLUMN base_person_finger.quality_score IS '图像质量得分';
COMMENT ON COLUMN base_person_finger.image_url IS '指纹图像路径';
COMMENT ON COLUMN base_person_finger.vendor_code IS '厂商';
COMMENT ON COLUMN base_person_finger.algs_version IS '算法版本';
COMMENT ON COLUMN base_person_finger.encrypted IS '是否加密： 1-加密 0-不加密';
COMMENT ON COLUMN base_person_finger.datasource IS '数据来源：INTERFACE-接口 IMP-导入 HTTP-HTTP接口';
COMMENT ON COLUMN base_person_finger.tenant IS '租户';
COMMENT ON COLUMN base_person_finger.operate_id IS '操作管理员ID，用于权限控制(有多个的话用“,”分割)';
COMMENT ON COLUMN base_person_finger.remark IS '备注';
COMMENT ON COLUMN base_person_finger.status IS '状态：0-有效  1:无效';
COMMENT ON COLUMN base_person_finger.create_by IS '创建人';
COMMENT ON COLUMN base_person_finger.update_by IS '修改人';
COMMENT ON COLUMN base_person_finger.create_time IS '创建时间';
COMMENT ON COLUMN base_person_finger.update_time IS '修改时间';
COMMENT ON COLUMN base_person_finger.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 基础数据_人员基础信息                                   					*/
/*==============================================================*/
CREATE TABLE base_person_info (
	id VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ) NOT NULL,
	name VARCHAR2 ( 64 ),
	sex CHAR ( 1 ),
	phone VARCHAR2 ( 48 ),
	card_no VARCHAR2 ( 255 ),
	account VARCHAR2 ( 255 ),
	email VARCHAR2 ( 255 ),
	dept_id INTEGER,
	datasource VARCHAR2 ( 48 ) DEFAULT 'INTERFACE' NOT NULL,
	flag CHAR ( 1 ) DEFAULT '1',
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	operate_id VARCHAR2 ( 255 ),
	status CHAR ( 1 ) DEFAULT '0' NOT NULL,
	remark VARCHAR2 ( 255 ),
	update_seria_num INTEGER,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_PERSON_INFO primary key ( id ) 
);
COMMENT ON TABLE base_person_info IS '基础数据_人员基础信息';
COMMENT ON COLUMN base_person_info.id IS '主键';
COMMENT ON COLUMN base_person_info.unique_id IS '人员标识';
COMMENT ON COLUMN base_person_info.name IS '姓名';
COMMENT ON COLUMN base_person_info.sex IS '性别：0-女 1-男 2-未知';
COMMENT ON COLUMN base_person_info.phone IS '手机';
COMMENT ON COLUMN base_person_info.card_no IS '卡号';
COMMENT ON COLUMN base_person_info.account IS '账号';
COMMENT ON COLUMN base_person_info.email IS '邮箱';
COMMENT ON COLUMN base_person_info.dept_id IS '部门ID';
COMMENT ON COLUMN base_person_info.datasource IS '数据来源：INTERFACE-接口 IMP-导入 HTTP-HTTP接口';
COMMENT ON COLUMN base_person_info.flag IS '人员标记：1-正常 2-红名单 3-黑名单';
COMMENT ON COLUMN base_person_info.tenant IS '租户';
COMMENT ON COLUMN base_person_info.operate_id IS '操作管理员ID，用于权限控制(有多个的话用“,”分割)';
COMMENT ON COLUMN base_person_info.status IS '状态：0-有效  1:无效';
COMMENT ON COLUMN base_person_info.remark IS '备注';
COMMENT ON COLUMN base_person_info.update_seria_num IS '人员更新标识流水码';
COMMENT ON COLUMN base_person_info.create_by IS '创建人';
COMMENT ON COLUMN base_person_info.update_by IS '修改人';
COMMENT ON COLUMN base_person_info.create_time IS '创建时间';
COMMENT ON COLUMN base_person_info.update_time IS '修改时间';
COMMENT ON COLUMN base_person_info.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 基础数据_虹膜图像信息                                  */
/*==============================================================*/
CREATE TABLE base_person_iris (
	id VARCHAR2 ( 48 ) NOT NULL,
	person_id VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ) NOT NULL,
	eye_code VARCHAR2 ( 2 ) NOT NULL,
	feature CLOB NOT NULL,
	feature_md5 VARCHAR2 ( 255 ),
	quality_score BINARY_DOUBLE,
	image_url VARCHAR2 ( 255 ) NOT NULL,
	vendor_code VARCHAR2 ( 48 ),
	algs_version VARCHAR2 ( 48 ),
	encrypted CHAR ( 1 ) DEFAULT '0',
	datasource VARCHAR2 ( 48 ) DEFAULT 'INTERFACE' NOT NULL,
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	operate_id VARCHAR2 ( 255 ),
	remark VARCHAR2 ( 255 ),
	status CHAR ( 1 ) DEFAULT '0' NOT NULL,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_PERSON_IRIS primary key ( id ) 
);
COMMENT ON TABLE base_person_iris IS '基础数据_虹膜图像信息';
COMMENT ON COLUMN base_person_iris.id IS '主键';
COMMENT ON COLUMN base_person_iris.person_id IS '关联人员主键(基础信息_人员信息表ID)';
COMMENT ON COLUMN base_person_iris.unique_id IS '人员标识';
COMMENT ON COLUMN base_person_iris.eye_code IS '眼睛编码(L/R)';
COMMENT ON COLUMN base_person_iris.feature IS '虹膜特征';
COMMENT ON COLUMN base_person_iris.feature_md5 IS '虹膜特征MD5';
COMMENT ON COLUMN base_person_iris.quality_score IS '图像质量得分';
COMMENT ON COLUMN base_person_iris.image_url IS '虹膜图像路径';
COMMENT ON COLUMN base_person_iris.vendor_code IS '厂商';
COMMENT ON COLUMN base_person_iris.algs_version IS '算法版本';
COMMENT ON COLUMN base_person_iris.encrypted IS '是否加密： 1-加密 0-不加密';
COMMENT ON COLUMN base_person_iris.datasource IS '数据来源：INTERFACE-接口 IMP-导入 HTTP-HTTP接口';
COMMENT ON COLUMN base_person_iris.tenant IS '租户';
COMMENT ON COLUMN base_person_iris.operate_id IS '操作管理员ID，用于权限控制(有多个的话用“,”分割)';
COMMENT ON COLUMN base_person_iris.remark IS '备注';
COMMENT ON COLUMN base_person_iris.status IS '状态：0-有效  1:无效';
COMMENT ON COLUMN base_person_iris.create_by IS '创建人';
COMMENT ON COLUMN base_person_iris.update_by IS '修改人';
COMMENT ON COLUMN base_person_iris.create_time IS '创建时间';
COMMENT ON COLUMN base_person_iris.update_time IS '修改时间';
COMMENT ON COLUMN base_person_iris.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 人员和陌生人关系表                       				*/
/*==============================================================*/
CREATE TABLE base_person_stranger_relation (
	id VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ) NOT NULL,
	stranger_id VARCHAR2 ( 48 ) NOT NULL,
	create_time DATE,
	batch_date DATE,
	constraint PK_BASE_PERSON_STRANGER_RELATI primary key ( id ) 
);
COMMENT ON TABLE base_person_stranger_relation IS '人员和陌生人关系表';
COMMENT ON COLUMN base_person_stranger_relation.id IS '主键';
COMMENT ON COLUMN base_person_stranger_relation.unique_id IS '唯一标识';
COMMENT ON COLUMN base_person_stranger_relation.stranger_id IS '陌生人ID';
COMMENT ON COLUMN base_person_stranger_relation.create_time IS '创建时间';
COMMENT ON COLUMN base_person_stranger_relation.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 基础数据_二维码信息                                   */
/*==============================================================*/
CREATE TABLE base_qr_code (
	id VARCHAR2 ( 48 ) NOT NULL,
	scene VARCHAR2 ( 255 ),
	content VARCHAR2 ( 1000 ) NOT NULL,
	img_path VARCHAR2 ( 255 ) NOT NULL,
	internal_pic VARCHAR2 ( 255 ),
	remark VARCHAR2 ( 255 ),
	status CHAR ( 1 ) DEFAULT '0' NOT NULL,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_QR_CODE primary key ( id ) 
);
COMMENT ON TABLE base_qr_code IS '基础数据_二维码信息';
COMMENT ON COLUMN base_qr_code.id IS '主键';
COMMENT ON COLUMN base_qr_code.scene IS '应用场景';
COMMENT ON COLUMN base_qr_code.content IS '二维码内容';
COMMENT ON COLUMN base_qr_code.img_path IS '二维码路径';
COMMENT ON COLUMN base_qr_code.internal_pic IS '内置图片';
COMMENT ON COLUMN base_qr_code.remark IS '备注';
COMMENT ON COLUMN base_qr_code.status IS '状态：0-有效  1:无效';
COMMENT ON COLUMN base_qr_code.create_by IS '创建人';
COMMENT ON COLUMN base_qr_code.update_by IS '修改人';
COMMENT ON COLUMN base_qr_code.create_time IS '创建时间';
COMMENT ON COLUMN base_qr_code.update_time IS '修改时间';
COMMENT ON COLUMN base_qr_code.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 基础数据_接口请求报文信息                             */
/*==============================================================*/
CREATE TABLE base_request_record (
	id VARCHAR2 ( 48 ) NOT NULL,
	trans_code VARCHAR2 ( 48 ),
	trans_title VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	request_msg CLOB,
	client_ip VARCHAR2 ( 48 ),
	send_time DATE NOT NULL,
	response_msg CLOB NOT NULL,
	time_used INTEGER NOT NULL,
	status_code VARCHAR2 ( 48 ) DEFAULT '0' NOT NULL,
	trans_url VARCHAR2 ( 255 ),
	class_method VARCHAR2 ( 255 ),
	channel_code VARCHAR2 ( 255 ),
	constraint PK_BASE_REQUEST_RECORD primary key ( id ) 
);
COMMENT ON TABLE base_request_record IS '基础数据_接口请求报文信息';
COMMENT ON COLUMN base_request_record.id IS '主键';
COMMENT ON COLUMN base_request_record.trans_code IS '交易码';
COMMENT ON COLUMN base_request_record.trans_title IS '交易标题';
COMMENT ON COLUMN base_request_record.received_time IS '请求时间';
COMMENT ON COLUMN base_request_record.request_msg IS '请求报文';
COMMENT ON COLUMN base_request_record.client_ip IS '客户端IP';
COMMENT ON COLUMN base_request_record.send_time IS '响应时间';
COMMENT ON COLUMN base_request_record.response_msg IS '响应报文';
COMMENT ON COLUMN base_request_record.time_used IS '耗时(ms)';
COMMENT ON COLUMN base_request_record.status_code IS '状态码';
COMMENT ON COLUMN base_request_record.trans_url IS '交易请求路径';
COMMENT ON COLUMN base_request_record.class_method IS '处理方法';
COMMENT ON COLUMN base_request_record.channel_code IS '渠道编码';
/*==============================================================*/
/* Table: 陌生人人脸信息			                            */
/*==============================================================*/
CREATE TABLE base_stranger_face (
	id VARCHAR2 ( 48 ) NOT NULL,
	feature VARCHAR2 ( 4000 ) NOT NULL,
	quality_score BINARY_DOUBLE,
	image_url VARCHAR2 ( 255 ) NOT NULL,
	vendor_code VARCHAR2 ( 48 ),
	algs_version VARCHAR2 ( 48 ),
	encrypted CHAR ( 1 ) DEFAULT '0',
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	remark VARCHAR2 ( 255 ),
	status CHAR ( 1 ) DEFAULT '0' NOT NULL,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_BASE_STRANGER_FACE_INFO primary key ( id ) 
);
COMMENT ON TABLE base_stranger_face_info IS '陌生人人脸信息';
COMMENT ON COLUMN base_stranger_face_info.id IS '主键';
COMMENT ON COLUMN base_stranger_face_info.feature IS '人脸特征';
COMMENT ON COLUMN base_stranger_face_info.quality_score IS '图像质量得分';
COMMENT ON COLUMN base_stranger_face_info.image_url IS '人脸图像路径';
COMMENT ON COLUMN base_stranger_face_info.vendor_code IS '厂商';
COMMENT ON COLUMN base_stranger_face_info.algs_version IS '算法版本';
COMMENT ON COLUMN base_stranger_face_info.encrypted IS '是否加密： 1-加密 0-不加密';
COMMENT ON COLUMN base_stranger_face_info.tenant IS '租户';
COMMENT ON COLUMN base_stranger_face_info.remark IS '备注';
COMMENT ON COLUMN base_stranger_face_info.status IS '状态：0-有效  1:无效';
COMMENT ON COLUMN base_stranger_face_info.create_by IS '创建人';
COMMENT ON COLUMN base_stranger_face_info.update_by IS '修改人';
COMMENT ON COLUMN base_stranger_face_info.create_time IS '创建时间';
COMMENT ON COLUMN base_stranger_face_info.update_time IS '修改时间';
COMMENT ON COLUMN base_stranger_face_info.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 渠道管理_渠道业务表                                    */
/*==============================================================*/
CREATE TABLE channel_business (
	id VARCHAR2 ( 48 ) NOT NULL,
	channel_id VARCHAR2 ( 48 ) NOT NULL,
	person_id VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ) NOT NULL,
	busi_code_first VARCHAR2 ( 255 ),
	busi_code_second VARCHAR2 ( 255 ),
	busi_code_third VARCHAR2 ( 255 ),
	face_mode VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	finger_mode VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	iris_mode VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	fvein_mode VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	phone VARCHAR2 ( 48 ),
	datasource VARCHAR2 ( 48 ) DEFAULT 'INTERFACE' NOT NULL,
	locked VARCHAR2 ( 1 ) DEFAULT 'N',
	lock_time DATE,
	status CHAR ( 1 ) DEFAULT '0' NOT NULL,
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	remark VARCHAR2 ( 255 ),
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_CHANNEL_BUSINESS primary key ( id ) 
);
COMMENT ON TABLE channel_business IS '渠道管理_渠道业务表';
COMMENT ON COLUMN channel_business.id IS '主键';
COMMENT ON COLUMN channel_business.channel_id IS '渠道主键';
COMMENT ON COLUMN channel_business.person_id IS '人员主键';
COMMENT ON COLUMN channel_business.unique_id IS '人员唯一标识';
COMMENT ON COLUMN channel_business.busi_code_first IS '业务号1';
COMMENT ON COLUMN channel_business.busi_code_second IS '业务号2';
COMMENT ON COLUMN channel_business.busi_code_third IS '业务号3';
COMMENT ON COLUMN channel_business.face_mode IS '开通人脸(数据字典:0-不开通 1-开通)';
COMMENT ON COLUMN channel_business.finger_mode IS '开通指纹(数据字典:0-不开通 1-开通)';
COMMENT ON COLUMN channel_business.iris_mode IS '开通虹膜(数据字典:0-不开通 1-开通)';
COMMENT ON COLUMN channel_business.fvein_mode IS '开通指静脉(数据字典:0-不开通 1-开通)';
COMMENT ON COLUMN channel_business.phone IS '手机号';
COMMENT ON COLUMN channel_business.datasource IS '数据来源(数据字典:INTERFACE-接口 IMP-导入 HTTP-HTTP接口)';
COMMENT ON COLUMN channel_business.locked IS '是否锁定(数据字典:N-否 Y-是)';
COMMENT ON COLUMN channel_business.lock_time IS '锁定时间';
COMMENT ON COLUMN channel_business.status IS '状态(数据字典:0-有效  1:无效)';
COMMENT ON COLUMN channel_business.tenant IS '租户';
COMMENT ON COLUMN channel_business.remark IS '备注';
COMMENT ON COLUMN channel_business.create_by IS '创建人';
COMMENT ON COLUMN channel_business.update_by IS '修改人';
COMMENT ON COLUMN channel_business.create_time IS '创建时间';
COMMENT ON COLUMN channel_business.update_time IS '修改时间';
COMMENT ON COLUMN channel_business.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 渠道管理_渠道信息表                                   */
/*==============================================================*/
CREATE TABLE channel_info (
	id VARCHAR2 ( 48 ) NOT NULL,
	channel_code VARCHAR2 ( 255 ) NOT NULL,
	channel_name VARCHAR2 ( 255 ) NOT NULL,
	channel_key VARCHAR2 ( 1000 ),
	concurrent INTEGER,
	face_mode VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	finger_mode VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	iris_mode VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	fvein_mode VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	enable_multi_faces VARCHAR2 ( 1 ) DEFAULT 'N',
	search_n VARCHAR2 ( 1 ) DEFAULT '2',
	put_without_check VARCHAR2 ( 1 ) DEFAULT 'N',
	be_return_feature VARCHAR2 ( 1 ) DEFAULT 'N',
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	remark VARCHAR2 ( 255 ),
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_CHANNEL_INFO primary key ( id ) 
);
COMMENT ON TABLE channel_info IS '渠道管理_渠道信息表';
COMMENT ON COLUMN channel_info.id IS '主键';
COMMENT ON COLUMN channel_info.channel_code IS '渠道编码(唯一)';
COMMENT ON COLUMN channel_info.channel_name IS '渠道名称';
COMMENT ON COLUMN channel_info.channel_key IS '渠道密钥';
COMMENT ON COLUMN channel_info.concurrent IS '并发量';
COMMENT ON COLUMN channel_info.face_mode IS '开通人脸(数据字典:0-不开通 1-开通)';
COMMENT ON COLUMN channel_info.finger_mode IS '开通指纹(数据字典:0-不开通 1-开通)';
COMMENT ON COLUMN channel_info.iris_mode IS '开通虹膜(数据字典:0-不开通 1-开通)';
COMMENT ON COLUMN channel_info.fvein_mode IS '开通指静脉(数据字典:0-不开通 1-开通)';
COMMENT ON COLUMN channel_info.enable_multi_faces IS '是否支持多人脸(数据字典:N-否 Y-是)';
COMMENT ON COLUMN channel_info.search_n IS '1-N识别方式(数据字典:1-校验分库、2-校验渠道库、3-校验全库,4-依次校验)';
COMMENT ON COLUMN channel_info.put_without_check IS '是否强制入库(数据字典:N-否 Y-是)';
COMMENT ON COLUMN channel_info.be_return_feature IS '是否返回特征(数据字典:N-否 Y-是)';
COMMENT ON COLUMN channel_info.tenant IS '租户';
COMMENT ON COLUMN channel_info.remark IS '备注';
COMMENT ON COLUMN channel_info.create_by IS '创建人';
COMMENT ON COLUMN channel_info.update_by IS '修改人';
COMMENT ON COLUMN channel_info.create_time IS '创建时间';
COMMENT ON COLUMN channel_info.update_time IS '修改时间';
COMMENT ON COLUMN channel_info.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 渠道管理_渠道参数表                                       */
/*==============================================================*/
CREATE TABLE channel_param (
	id VARCHAR2 ( 48 ) NOT NULL,
	channel_id VARCHAR2 ( 48 ) NOT NULL,
	param_code VARCHAR2 ( 255 ) NOT NULL,
	param_name VARCHAR2 ( 255 ),
	param_value VARCHAR2 ( 255 ) NOT NULL,
	bio_attest_type VARCHAR2 ( 1 ) NOT NULL,
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	remark VARCHAR2 ( 255 ),
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_CHANNEL_PARAM primary key ( id ) 
);
COMMENT ON TABLE channel_param IS '渠道管理_渠道参数表';
COMMENT ON COLUMN channel_param.id IS '主键';
COMMENT ON COLUMN channel_param.channel_id IS '渠道主键';
COMMENT ON COLUMN channel_param.param_code IS '参数编码(唯一)';
COMMENT ON COLUMN channel_param.param_name IS '参数名称';
COMMENT ON COLUMN channel_param.param_value IS '参数键值';
COMMENT ON COLUMN channel_param.bio_attest_type IS '认证类型(数据字典::0-人脸  1指纹 2虹膜 3指静脉)';
COMMENT ON COLUMN channel_param.tenant IS '租户';
COMMENT ON COLUMN channel_param.remark IS '备注';
COMMENT ON COLUMN channel_param.create_by IS '创建人';
COMMENT ON COLUMN channel_param.update_by IS '修改人';
COMMENT ON COLUMN channel_param.create_time IS '创建时间';
COMMENT ON COLUMN channel_param.update_time IS '修改时间';
COMMENT ON COLUMN channel_param.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 渠道管理_分库业务表                                   */
/*==============================================================*/
CREATE TABLE channel_subtreasury_busi (
	id VARCHAR2 ( 48 ) NOT NULL,
	channel_id VARCHAR2 ( 48 ) NOT NULL,
	sub_treasury_code VARCHAR2 ( 100 ) NOT NULL,
	sub_treasury_name VARCHAR2 ( 100 ) NOT NULL,
	person_id VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ) NOT NULL,
	datasource VARCHAR2 ( 48 ) DEFAULT 'INTERFACE' NOT NULL,
	status CHAR ( 1 ) DEFAULT '0' NOT NULL,
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	remark VARCHAR2 ( 255 ),
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_CHANNEL_SUBTREASURY_BUSI primary key ( id ) 
);
COMMENT ON TABLE channel_subtreasury_busi IS '渠道管理_分库业务表';
COMMENT ON COLUMN channel_subtreasury_busi.id IS '主键';
COMMENT ON COLUMN channel_subtreasury_busi.channel_id IS '渠道主键';
COMMENT ON COLUMN channel_subtreasury_busi.sub_treasury_code IS '分库号(渠道编码_编号)';
COMMENT ON COLUMN channel_subtreasury_busi.sub_treasury_name IS '分库名称';
COMMENT ON COLUMN channel_subtreasury_busi.person_id IS '人员主键';
COMMENT ON COLUMN channel_subtreasury_busi.unique_id IS '人员唯一标识';
COMMENT ON COLUMN channel_subtreasury_busi.datasource IS '数据来源(数据字典:INTERFACE-接口 IMP-导入 HTTP-HTTP接口)';
COMMENT ON COLUMN channel_subtreasury_busi.status IS '状态(数据字典:0-有效  1:无效)';
COMMENT ON COLUMN channel_subtreasury_busi.tenant IS '租户';
COMMENT ON COLUMN channel_subtreasury_busi.remark IS '备注';
COMMENT ON COLUMN channel_subtreasury_busi.create_by IS '创建人';
COMMENT ON COLUMN channel_subtreasury_busi.update_by IS '修改人';
COMMENT ON COLUMN channel_subtreasury_busi.create_time IS '创建时间';
COMMENT ON COLUMN channel_subtreasury_busi.update_time IS '修改时间';
COMMENT ON COLUMN channel_subtreasury_busi.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 设备信息表                                  */
/*==============================================================*/
CREATE TABLE client_device_info (
	id VARCHAR2 ( 48 ) NOT NULL,
	device_name VARCHAR2 ( 255 ) NOT NULL,
	device_no VARCHAR2 ( 48 ) NOT NULL,
	device_addr VARCHAR2 ( 255 ),
	device_type VARCHAR2 ( 3 ),
	device_ip VARCHAR2 ( 48 ),
	device_port INTEGER,
	device_mac VARCHAR2 ( 48 ),
	ext_info VARCHAR2 ( 4000 ),
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_CLIENT_DEVICE_INFO primary key ( id ) 
);
COMMENT ON TABLE client_device_info IS '设备信息表';
COMMENT ON COLUMN client_device_info.id IS '主键';
COMMENT ON COLUMN client_device_info.device_name IS '设备名称';
COMMENT ON COLUMN client_device_info.device_no IS '设备编号';
COMMENT ON COLUMN client_device_info.device_addr IS '设备安装地点';
COMMENT ON COLUMN client_device_info.device_type IS '设备类型(字典数据)';
COMMENT ON COLUMN client_device_info.device_ip IS '设备IP';
COMMENT ON COLUMN client_device_info.device_port IS '设备端口';
COMMENT ON COLUMN client_device_info.device_mac IS '设备Mac';
COMMENT ON COLUMN client_device_info.ext_info IS '设备扩展信息';
COMMENT ON COLUMN client_device_info.create_by IS '创建人';
COMMENT ON COLUMN client_device_info.update_by IS '修改人';
COMMENT ON COLUMN client_device_info.create_time IS '创建时间';
COMMENT ON COLUMN client_device_info.update_time IS '修改时间';
COMMENT ON COLUMN client_device_info.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 升级任务表                                */
/*==============================================================*/
CREATE TABLE client_upgrade_info (
	id VARCHAR2 ( 48 ) NOT NULL,
	version_id VARCHAR2 ( 48 ) NOT NULL,
	device_id VARCHAR2 ( 48 ) NOT NULL,
	upgrade_time DATE,
	upgrade_count_limit INTEGER NOT NULL,
	execute_count INTEGER DEFAULT 0 NOT NULL,
	task_index INTEGER NOT NULL,
	execute_result VARCHAR2 ( 1 ) DEFAULT '1' NOT NULL,
	roll_back VARCHAR2 ( 1 ) DEFAULT 'N' NOT NULL,
	status VARCHAR2 ( 1 ) DEFAULT '0' NOT NULL,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_CLIENT_UPGRADE_INFO primary key ( id ) 
);
COMMENT ON TABLE client_upgrade_info IS '升级任务表';
COMMENT ON COLUMN client_upgrade_info.id IS '主键';
COMMENT ON COLUMN client_upgrade_info.version_id IS '版本主键';
COMMENT ON COLUMN client_upgrade_info.device_id IS '设备主键';
COMMENT ON COLUMN client_upgrade_info.upgrade_time IS '更新时间(如果为空，表示立即更新)';
COMMENT ON COLUMN client_upgrade_info.upgrade_count_limit IS '升级次数上限';
COMMENT ON COLUMN client_upgrade_info.execute_count IS '执行次数';
COMMENT ON COLUMN client_upgrade_info.task_index IS '任务排序';
COMMENT ON COLUMN client_upgrade_info.execute_result IS '执行结果(1:待执行，2：成功，3：失败，4：跳过)';
COMMENT ON COLUMN client_upgrade_info.roll_back IS '是否降级安装(Y：是，N：否)';
COMMENT ON COLUMN client_upgrade_info.status IS '任务状态(0：正常，1：停用)';
COMMENT ON COLUMN client_upgrade_info.create_by IS '创建人';
COMMENT ON COLUMN client_upgrade_info.update_by IS '修改人';
COMMENT ON COLUMN client_upgrade_info.create_time IS '创建时间';
COMMENT ON COLUMN client_upgrade_info.update_time IS '修改时间';
COMMENT ON COLUMN client_upgrade_info.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 升级日志表				                                  */
/*==============================================================*/
CREATE TABLE client_upgrade_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	version_id VARCHAR2 ( 48 ) NOT NULL,
	device_id VARCHAR2 ( 48 ) NOT NULL,
	upgrade_info_id VARCHAR2 ( 48 ) NOT NULL,
	before_app_name VARCHAR2 ( 48 ),
	after_app_name VARCHAR2 ( 48 ) NOT NULL,
	device_name VARCHAR2 ( 255 ),
	device_no VARCHAR2 ( 48 ) NOT NULL,
	before_version VARCHAR2 ( 48 ),
	after_version VARCHAR2 ( 48 ) NOT NULL,
	upgrade_status CHAR ( 1 ) NOT NULL,
	client_time DATE,
	server_time DATE,
	time_used INTEGER,
	fail_reason VARCHAR2 ( 500 ),
	create_time DATE,
	batch_date DATE,
	constraint PK_CLIENT_UPGRADE_LOG primary key ( id ) 
);
COMMENT ON TABLE client_upgrade_log IS '升级日志表';
COMMENT ON COLUMN client_upgrade_log.id IS '主键';
COMMENT ON COLUMN client_upgrade_log.version_id IS '版本主键';
COMMENT ON COLUMN client_upgrade_log.device_id IS '设备主键';
COMMENT ON COLUMN client_upgrade_log.upgrade_info_id IS '升级任务主键';
COMMENT ON COLUMN client_upgrade_log.before_app_name IS '升级前APP名';
COMMENT ON COLUMN client_upgrade_log.after_app_name IS '升级后APP名';
COMMENT ON COLUMN client_upgrade_log.device_name IS '设备名称';
COMMENT ON COLUMN client_upgrade_log.device_no IS '设备编号';
COMMENT ON COLUMN client_upgrade_log.before_version IS '升级前版本';
COMMENT ON COLUMN client_upgrade_log.after_version IS '升级后版本';
COMMENT ON COLUMN client_upgrade_log.upgrade_status IS '更新状态(1:待下载，2：待更新，3：更新成功，4：更新失败，5：跳过)';
COMMENT ON COLUMN client_upgrade_log.client_time IS '升级时前端时间';
COMMENT ON COLUMN client_upgrade_log.server_time IS '升级时后端时间';
COMMENT ON COLUMN client_upgrade_log.time_used IS '升级耗时(单位s)';
COMMENT ON COLUMN client_upgrade_log.fail_reason IS '失败原因';
COMMENT ON COLUMN client_upgrade_log.create_time IS '创建时间';
COMMENT ON COLUMN client_upgrade_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 版本信息表                                      */
/*==============================================================*/
CREATE TABLE client_version (
	id VARCHAR2 ( 48 ) NOT NULL,
	app_name VARCHAR2 ( 48 ) NOT NULL,
	version VARCHAR2 ( 48 ) NOT NULL,
	description VARCHAR2 ( 255 ),
	path VARCHAR2 ( 255 ) NOT NULL,
	file_size INTEGER NOT NULL,
	type CHAR ( 1 ) NOT NULL,
	filename VARCHAR2 ( 255 ) NOT NULL,
	md5 CHAR ( 10 ) NOT NULL,
	create_by VARCHAR2 ( 64 ),
	update_by VARCHAR2 ( 64 ),
	create_time DATE,
	update_time DATE,
	batch_date DATE,
	constraint PK_CLIENT_VERSION primary key ( id ) 
);
COMMENT ON TABLE client_version IS '版本信息表';
COMMENT ON COLUMN client_version.id IS '主键';
COMMENT ON COLUMN client_version.app_name IS 'APP名';
COMMENT ON COLUMN client_version.version IS '版本号';
COMMENT ON COLUMN client_version.description IS '版本描述';
COMMENT ON COLUMN client_version.path IS '升级文件';
COMMENT ON COLUMN client_version.file_size IS '版本大小(B)';
COMMENT ON COLUMN client_version.type IS '版本类型(0：全量，1：增量)';
COMMENT ON COLUMN client_version.filename IS '源文件名';
COMMENT ON COLUMN client_version.md5 IS '文件MD5';
COMMENT ON COLUMN client_version.create_by IS '创建人';
COMMENT ON COLUMN client_version.update_by IS '修改人';
COMMENT ON COLUMN client_version.create_time IS '创建时间';
COMMENT ON COLUMN client_version.update_time IS '修改时间';
COMMENT ON COLUMN client_version.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 钉钉微应用                                */
/*==============================================================*/
CREATE TABLE msg_ding_application (
	id VARCHAR2 ( 48 ) NOT NULL,
	team_id VARCHAR2 ( 255 ) NOT NULL,
	corp_id VARCHAR2 ( 255 ) NOT NULL,
	app_name VARCHAR2 ( 255 ) NOT NULL,
	agent_id VARCHAR2 ( 255 ) NOT NULL,
	app_key VARCHAR2 ( 255 ) NOT NULL,
	app_secrect VARCHAR2 ( 255 ) NOT NULL,
	short_des VARCHAR2 ( 255 ),
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_DING_APPLICATION primary key ( id ) 
);
COMMENT ON TABLE msg_ding_application IS '钉钉微应用';
COMMENT ON COLUMN msg_ding_application.id IS '主键';
COMMENT ON COLUMN msg_ding_application.team_id IS '团队(企业)主键';
COMMENT ON COLUMN msg_ding_application.corp_id IS '团队(企业)CorpId';
COMMENT ON COLUMN msg_ding_application.app_name IS '微应用名称';
COMMENT ON COLUMN msg_ding_application.agent_id IS '微应用agentId';
COMMENT ON COLUMN msg_ding_application.app_key IS '微应用AppKey';
COMMENT ON COLUMN msg_ding_application.app_secrect IS '微应用AppSecrect';
COMMENT ON COLUMN msg_ding_application.short_des IS '微应用简介';
COMMENT ON COLUMN msg_ding_application.create_time IS '创建时间';
COMMENT ON COLUMN msg_ding_application.update_time IS '更新时间';
/*==============================================================*/
/* Table: 钉钉团队(企业)                                       */
/*==============================================================*/
CREATE TABLE msg_ding_team (
	id VARCHAR2 ( 48 ) NOT NULL,
	corp_id VARCHAR2 ( 255 ) NOT NULL,
	team_name VARCHAR2 ( 255 ) NOT NULL,
	team_des VARCHAR2 ( 500 ),
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_DING_TEAM primary key ( id ) 
);
COMMENT ON TABLE msg_ding_team IS '钉钉团队(企业)';
COMMENT ON COLUMN msg_ding_team.id IS '主键';
COMMENT ON COLUMN msg_ding_team.corp_id IS '团队(企业)CorpId';
COMMENT ON COLUMN msg_ding_team.team_name IS '团队(企业)名称';
COMMENT ON COLUMN msg_ding_team.team_des IS '团队(企业)说明';
COMMENT ON COLUMN msg_ding_team.create_time IS '创建时间';
COMMENT ON COLUMN msg_ding_team.update_time IS '更新时间';
/*==============================================================*/
/* Table: 消息历史日志                                         */
/*==============================================================*/
CREATE TABLE msg_his_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	notice_method VARCHAR2 ( 1 ) NOT NULL,
	msg_subject VARCHAR2 ( 255 ),
	msg_content VARCHAR2 ( 4000 ),
	has_annex VARCHAR2 ( 1 ) DEFAULT 'N' NOT NULL,
	from_user VARCHAR2 ( 255 ),
	to_user VARCHAR2 ( 4000 ),
	offical_account_id VARCHAR2 ( 48 ),
	offical_account_name VARCHAR2 ( 255 ),
	scene_remark VARCHAR2 ( 48 ),
	result_status VARCHAR2 ( 1 ) NOT NULL,
	err_msg VARCHAR2 ( 255 ),
	json_response VARCHAR2 ( 4000 ),
	create_time DATE,
	constraint PK_MSG_HIS_LOG primary key ( id ) 
);
COMMENT ON TABLE msg_his_log IS '消息历史日志';
COMMENT ON COLUMN msg_his_log.id IS '主键';
COMMENT ON COLUMN msg_his_log.received_seq IS '业务流水号';
COMMENT ON COLUMN msg_his_log.notice_method IS '通知方式(1：短信，2：邮件，3：微信，4：钉钉)';
COMMENT ON COLUMN msg_his_log.msg_subject IS '消息主题';
COMMENT ON COLUMN msg_his_log.msg_content IS '消息内容';
COMMENT ON COLUMN msg_his_log.has_annex IS '是否包含附件(Y：是，N：否)';
COMMENT ON COLUMN msg_his_log.from_user IS '发信人标识';
COMMENT ON COLUMN msg_his_log.to_user IS '收件人标识(多个使用“,”分隔)';
COMMENT ON COLUMN msg_his_log.offical_account_id IS '公众(企业)号标识';
COMMENT ON COLUMN msg_his_log.offical_account_name IS '公众(企业)号名称';
COMMENT ON COLUMN msg_his_log.scene_remark IS '场景标识';
COMMENT ON COLUMN msg_his_log.result_status IS '发送状态(0：成功，1：失败)';
COMMENT ON COLUMN msg_his_log.err_msg IS '错误信息';
COMMENT ON COLUMN msg_his_log.json_response IS '发送结果json';
COMMENT ON COLUMN msg_his_log.create_time IS '创建时间';
/*==============================================================*/
/* Table: 消息日志                                             */
/*==============================================================*/
CREATE TABLE msg_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	notice_method VARCHAR2 ( 1 ) NOT NULL,
	msg_subject VARCHAR2 ( 255 ),
	msg_content VARCHAR2 ( 4000 ),
	has_annex VARCHAR2 ( 1 ) DEFAULT 'N' NOT NULL,
	from_user VARCHAR2 ( 255 ),
	to_user VARCHAR2 ( 4000 ),
	offical_account_id VARCHAR2 ( 48 ),
	offical_account_name VARCHAR2 ( 255 ),
	scene_remark VARCHAR2 ( 48 ),
	result_status VARCHAR2 ( 1 ) NOT NULL,
	err_msg VARCHAR2 ( 255 ),
	json_response VARCHAR2 ( 4000 ),
	create_time DATE,
	constraint PK_MSG_LOG primary key ( id ) 
);
COMMENT ON TABLE msg_log IS '消息日志';
COMMENT ON COLUMN msg_log.id IS '主键';
COMMENT ON COLUMN msg_log.received_seq IS '业务流水号';
COMMENT ON COLUMN msg_log.notice_method IS '通知方式(1：短信，2：邮件，3：微信，4：钉钉)';
COMMENT ON COLUMN msg_log.msg_subject IS '消息主题';
COMMENT ON COLUMN msg_log.msg_content IS '消息内容';
COMMENT ON COLUMN msg_log.has_annex IS '是否包含附件(Y：是，N：否)';
COMMENT ON COLUMN msg_log.from_user IS '发信人标识';
COMMENT ON COLUMN msg_log.to_user IS '收件人标识(多个使用“,”分隔)';
COMMENT ON COLUMN msg_log.offical_account_id IS '公众(企业)号标识';
COMMENT ON COLUMN msg_log.offical_account_name IS '公众(企业)号名称';
COMMENT ON COLUMN msg_log.scene_remark IS '场景标识';
COMMENT ON COLUMN msg_log.result_status IS '发送状态(0：成功，1：失败)';
COMMENT ON COLUMN msg_log.err_msg IS '错误信息';
COMMENT ON COLUMN msg_log.json_response IS '发送结果json';
COMMENT ON COLUMN msg_log.create_time IS '创建时间';
/*==============================================================*/
/* Table: 消息日志附件                                       */
/*==============================================================*/
CREATE TABLE msg_log_annex (
	id VARCHAR2 ( 48 ) NOT NULL,
	log_id VARCHAR2 ( 48 ) NOT NULL,
	file_name VARCHAR2 ( 255 ) NOT NULL,
	file_path VARCHAR2 ( 255 ) NOT NULL,
	file_md5 VARCHAR2 ( 48 ) NOT NULL,
	create_time DATE,
	constraint PK_MSG_LOG_ANNEX primary key ( id ) 
);
COMMENT ON TABLE msg_log_annex IS '消息日志附件';
COMMENT ON COLUMN msg_log_annex.id IS '主键';
COMMENT ON COLUMN msg_log_annex.log_id IS '消息日志ID';
COMMENT ON COLUMN msg_log_annex.file_name IS '源文件名称';
COMMENT ON COLUMN msg_log_annex.file_path IS '文件路径';
COMMENT ON COLUMN msg_log_annex.file_md5 IS '文件MD5';
COMMENT ON COLUMN msg_log_annex.create_time IS '创建时间';
/*==============================================================*/
/* Table: 邮箱配置                                   */
/*==============================================================*/
CREATE TABLE msg_mail_property (
	id VARCHAR2 ( 48 ) NOT NULL,
	host VARCHAR2 ( 255 ) NOT NULL,
	port INTEGER,
	username VARCHAR2 ( 255 ) NOT NULL,
	password VARCHAR2 ( 255 ) NOT NULL,
	email_addr VARCHAR2 ( 255 ) NOT NULL,
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_MAIL_PROPERTY primary key ( id ) 
);
COMMENT ON TABLE msg_mail_property IS '邮箱配置';
COMMENT ON COLUMN msg_mail_property.id IS '主键';
COMMENT ON COLUMN msg_mail_property.host IS 'SMTP服务地址';
COMMENT ON COLUMN msg_mail_property.port IS 'SMTP服务端口';
COMMENT ON COLUMN msg_mail_property.username IS '登录用户名';
COMMENT ON COLUMN msg_mail_property.password IS '登录授权码';
COMMENT ON COLUMN msg_mail_property.email_addr IS '发件邮箱';
COMMENT ON COLUMN msg_mail_property.create_time IS '创建时间';
COMMENT ON COLUMN msg_mail_property.update_time IS '更新时间';
/*==============================================================*/
/* Table: 微信公众号                                 */
/*==============================================================*/
CREATE TABLE msg_offical_account (
	id VARCHAR2 ( 48 ) NOT NULL,
	app_id VARCHAR2 ( 500 ) NOT NULL,
	app_secrect VARCHAR2 ( 500 ) NOT NULL,
	app_name VARCHAR2 ( 500 ) NOT NULL,
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_OFFICAL_ACCOUNT primary key ( id ) 
);
COMMENT ON TABLE msg_offical_account IS '微信公众号';
COMMENT ON COLUMN msg_offical_account.id IS '主键';
COMMENT ON COLUMN msg_offical_account.app_id IS 'AppId';
COMMENT ON COLUMN msg_offical_account.app_secrect IS 'AppSecrect';
COMMENT ON COLUMN msg_offical_account.app_name IS '公众号名称';
COMMENT ON COLUMN msg_offical_account.create_time IS '创建时间';
COMMENT ON COLUMN msg_offical_account.update_time IS '更新时间';
/*==============================================================*/
/* Table: 微信用户					                           */
/*==============================================================*/
CREATE TABLE msg_offical_account_user (
	id VARCHAR2 ( 48 ) NOT NULL,
	offical_account_id VARCHAR2 ( 48 ),
	app_id VARCHAR2 ( 48 ) NOT NULL,
	open_id VARCHAR2 ( 255 ) NOT NULL,
	wx_name VARCHAR2 ( 255 ) NOT NULL,
	head_img_url VARCHAR2 ( 500 ),
	phone VARCHAR2 ( 30 ),
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_OFFICAL_ACCOUNT_USER primary key ( id ) 
);
COMMENT ON TABLE msg_offical_account_user IS '微信用户';
COMMENT ON COLUMN msg_offical_account_user.id IS '主键';
COMMENT ON COLUMN msg_offical_account_user.offical_account_id IS '公众号ID';
COMMENT ON COLUMN msg_offical_account_user.app_id IS '公众号AppId';
COMMENT ON COLUMN msg_offical_account_user.open_id IS '微信标识';
COMMENT ON COLUMN msg_offical_account_user.wx_name IS '微信名称';
COMMENT ON COLUMN msg_offical_account_user.head_img_url IS '微信头像';
COMMENT ON COLUMN msg_offical_account_user.phone IS '绑定手机';
COMMENT ON COLUMN msg_offical_account_user.create_time IS '创建时间';
COMMENT ON COLUMN msg_offical_account_user.update_time IS '更新时间';
/*==============================================================*/
/* Table: 短信云账户			                               */
/*==============================================================*/
CREATE TABLE msg_sms_cloud_account (
	id VARCHAR2 ( 48 ) NOT NULL,
	app_id VARCHAR2 ( 500 ) NOT NULL,
	app_secrect VARCHAR2 ( 500 ) NOT NULL,
	app_name VARCHAR2 ( 500 ) NOT NULL,
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_SMS_CLOUD_ACCOUNT primary key ( id ) 
);
COMMENT ON TABLE msg_sms_cloud_account IS '短信云账户';
COMMENT ON COLUMN msg_sms_cloud_account.id IS '主键';
COMMENT ON COLUMN msg_sms_cloud_account.app_id IS 'AppId';
COMMENT ON COLUMN msg_sms_cloud_account.app_secrect IS 'AppSecrect';
COMMENT ON COLUMN msg_sms_cloud_account.app_name IS '账户说明';
COMMENT ON COLUMN msg_sms_cloud_account.create_time IS '创建时间';
COMMENT ON COLUMN msg_sms_cloud_account.update_time IS '更新时间';
/*==============================================================*/
/* Table: 消息模板                                       */
/*==============================================================*/
CREATE TABLE msg_template (
	id VARCHAR2 ( 48 ) NOT NULL,
	template_name VARCHAR2 ( 255 ) NOT NULL,
	offical_id VARCHAR2 ( 48 ),
	content VARCHAR2 ( 1000 ) NOT NULL,
	notice_method VARCHAR2 ( 1 ) NOT NULL,
	offical_account_id VARCHAR2 ( 48 ),
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_TEMPLATE primary key ( id ) 
);
COMMENT ON TABLE msg_template IS '消息模板';
COMMENT ON COLUMN msg_template.id IS '主键';
COMMENT ON COLUMN msg_template.template_name IS '模板名称';
COMMENT ON COLUMN msg_template.offical_id IS '模板官方ID';
COMMENT ON COLUMN msg_template.content IS '模板内容';
COMMENT ON COLUMN msg_template.notice_method IS '通知方式(1：短信，2：邮件，3：微信，4：钉钉)';
COMMENT ON COLUMN msg_template.offical_account_id IS '公众号|云账户ID';
COMMENT ON COLUMN msg_template.create_time IS '创建时间';
COMMENT ON COLUMN msg_template.update_time IS '更新时间';
/*==============================================================*/
/* Table: 微信公众号菜单                                    */
/*==============================================================*/
CREATE TABLE msg_weixin_menu (
	id VARCHAR2 ( 48 ) NOT NULL,
	offical_account_id VARCHAR2 ( 500 ) NOT NULL,
	app_id VARCHAR2 ( 500 ) NOT NULL,
	menu_json VARCHAR2 ( 4000 ) NOT NULL,
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_WEIXIN_MENU primary key ( id ) 
);
COMMENT ON TABLE msg_weixin_menu IS '微信公众号菜单';
COMMENT ON COLUMN msg_weixin_menu.id IS '主键';
COMMENT ON COLUMN msg_weixin_menu.offical_account_id IS '公众号主键';
COMMENT ON COLUMN msg_weixin_menu.app_id IS '公众号AppId';
COMMENT ON COLUMN msg_weixin_menu.menu_json IS '菜单JSON';
COMMENT ON COLUMN msg_weixin_menu.create_time IS '创建时间';
COMMENT ON COLUMN msg_weixin_menu.update_time IS '更新时间';
/*==============================================================*/
/* Table: 微信公众号菜单回复                              */
/*==============================================================*/
CREATE TABLE msg_weixin_menu_reply (
	id VARCHAR2 ( 48 ) NOT NULL,
	offical_account_id VARCHAR2 ( 500 ) NOT NULL,
	app_id VARCHAR2 ( 500 ) NOT NULL,
	menu_btn_key VARCHAR2 ( 255 ) NOT NULL,
	res_type VARCHAR2 ( 2 ) DEFAULT '1' NOT NULL,
	reply_content VARCHAR2 ( 4000 ),
	create_time DATE,
	update_time DATE,
	constraint PK_MSG_WEIXIN_MENU_REPLY primary key ( id ) 
);
COMMENT ON TABLE msg_weixin_menu_reply IS '微信公众号菜单回复';
COMMENT ON COLUMN msg_weixin_menu_reply.id IS '主键';
COMMENT ON COLUMN msg_weixin_menu_reply.offical_account_id IS '公众号主键';
COMMENT ON COLUMN msg_weixin_menu_reply.app_id IS '公众号AppId';
COMMENT ON COLUMN msg_weixin_menu_reply.menu_btn_key IS '菜单按钮Key';
COMMENT ON COLUMN msg_weixin_menu_reply.res_type IS '响应类型(1：文本回复)';
COMMENT ON COLUMN msg_weixin_menu_reply.reply_content IS '回复内容';
COMMENT ON COLUMN msg_weixin_menu_reply.create_time IS '创建时间';
COMMENT ON COLUMN msg_weixin_menu_reply.update_time IS '更新时间';
/*==============================================================*/
/* Table: 人员人脸比对历史日志表                          */
/*==============================================================*/
CREATE TABLE person_face_match_his_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	scene_image VARCHAR2 ( 255 ) NOT NULL,
	online_image VARCHAR2 ( 255 ),
	chip_image VARCHAR2 ( 255 ),
	stock_image VARCHAR2 ( 255 ),
	scene_online_score BINARY_DOUBLE,
	scene_chip_score BINARY_DOUBLE,
	scene_stock_score BINARY_DOUBLE,
	online_chip_score BINARY_DOUBLE,
	scene_online_result VARCHAR2 ( 1 ),
	scene_chip_result VARCHAR2 ( 1 ),
	scene_stock_result VARCHAR2 ( 1 ),
	online_chip_result VARCHAR2 ( 1 ),
	checklive_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_FACE_MATCH_HIS_LOG primary key ( id, received_time ) 
) PARTITION BY RANGE (received_time)
(partition p_197001 values less than(to_date('1970-02-01','YYYY-MM-DD')));;
COMMENT ON TABLE person_face_match_his_log IS '人员人脸比对历史日志表';
COMMENT ON COLUMN person_face_match_his_log.id IS '主键';
COMMENT ON COLUMN person_face_match_his_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_face_match_his_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_face_match_his_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_face_match_his_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_face_match_his_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_face_match_his_log.scene_image IS '现场照路径';
COMMENT ON COLUMN person_face_match_his_log.online_image IS '联网核查照路径';
COMMENT ON COLUMN person_face_match_his_log.chip_image IS '芯片照路径';
COMMENT ON COLUMN person_face_match_his_log.stock_image IS '底库照路径';
COMMENT ON COLUMN person_face_match_his_log.scene_online_score IS '现场照与联网核查照比对分值';
COMMENT ON COLUMN person_face_match_his_log.scene_chip_score IS '现场照与芯片照比对分值';
COMMENT ON COLUMN person_face_match_his_log.scene_stock_score IS '现场照与库底库照比对分值';
COMMENT ON COLUMN person_face_match_his_log.online_chip_score IS '联网核查照与芯片照比对分值';
COMMENT ON COLUMN person_face_match_his_log.scene_online_result IS '现场照与联网核查照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_his_log.scene_chip_result IS '现场照与芯片照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_his_log.scene_stock_result IS '现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_his_log.online_chip_result IS '联网核查照与芯片照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_his_log.checklive_result IS '现场照件检活结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_his_log.result IS '比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_his_log.broker IS '交易发起人';
COMMENT ON COLUMN person_face_match_his_log.received_time IS '请求时间';
COMMENT ON COLUMN person_face_match_his_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_face_match_his_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_face_match_his_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_face_match_his_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_face_match_his_log.tenant IS '租户';
COMMENT ON COLUMN person_face_match_his_log.create_time IS '创建时间';
COMMENT ON COLUMN person_face_match_his_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
CALL sp_create_partition(LAST_DAY(sysdate), 'person_face_match_his_log','YYYYMM');
CALL sp_create_partition(LAST_DAY(ADD_MONTHS(sysdate,1)), 'person_face_match_his_log','YYYYMM');
/*==============================================================*/
/* Table: 人员人脸比对日志表                               */
/*==============================================================*/
CREATE TABLE person_face_match_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	scene_image VARCHAR2 ( 255 ) NOT NULL,
	online_image VARCHAR2 ( 255 ),
	chip_image VARCHAR2 ( 255 ),
	stock_image VARCHAR2 ( 255 ),
	scene_online_score BINARY_DOUBLE,
	scene_chip_score BINARY_DOUBLE,
	scene_stock_score BINARY_DOUBLE,
	online_chip_score BINARY_DOUBLE,
	scene_online_result VARCHAR2 ( 1 ),
	scene_chip_result VARCHAR2 ( 1 ),
	scene_stock_result VARCHAR2 ( 1 ),
	online_chip_result VARCHAR2 ( 1 ),
	checklive_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_FACE_MATCH_LOG primary key ( id ) 
);
COMMENT ON TABLE person_face_match_log IS '人员人脸比对日志表';
COMMENT ON COLUMN person_face_match_log.id IS '主键';
COMMENT ON COLUMN person_face_match_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_face_match_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_face_match_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_face_match_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_face_match_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_face_match_log.scene_image IS '现场照路径';
COMMENT ON COLUMN person_face_match_log.online_image IS '联网核查照路径';
COMMENT ON COLUMN person_face_match_log.chip_image IS '芯片照路径';
COMMENT ON COLUMN person_face_match_log.stock_image IS '底库照路径';
COMMENT ON COLUMN person_face_match_log.scene_online_score IS '现场照与联网核查照比对分值';
COMMENT ON COLUMN person_face_match_log.scene_chip_score IS '现场照与芯片照比对分值';
COMMENT ON COLUMN person_face_match_log.scene_stock_score IS '现场照与库底库照比对分值';
COMMENT ON COLUMN person_face_match_log.online_chip_score IS '联网核查照与芯片照比对分值';
COMMENT ON COLUMN person_face_match_log.scene_online_result IS '现场照与联网核查照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_log.scene_chip_result IS '现场照与芯片照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_log.scene_stock_result IS '现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_log.online_chip_result IS '联网核查照与芯片照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_log.checklive_result IS '现场照件检活结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_log.result IS '比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_match_log.broker IS '交易发起人';
COMMENT ON COLUMN person_face_match_log.received_time IS '请求时间';
COMMENT ON COLUMN person_face_match_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_face_match_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_face_match_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_face_match_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_face_match_log.tenant IS '租户';
COMMENT ON COLUMN person_face_match_log.create_time IS '创建时间';
COMMENT ON COLUMN person_face_match_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 人员人脸搜索历史日志表                         */
/*==============================================================*/
CREATE TABLE person_face_search_his_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	scene_type VARCHAR2 ( 1 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	sub_treasury_code VARCHAR2 ( 255 ),
	sub_treasury_name VARCHAR2 ( 255 ),
	scene_image VARCHAR2 ( 255 ) NOT NULL,
	stock_image VARCHAR2 ( 255 ),
	take_photo1 VARCHAR2 ( 255 ),
	take_photo2 VARCHAR2 ( 255 ),
	scene_stock_score BINARY_DOUBLE,
	checklive_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	belong_to_stranger_lib VARCHAR2 ( 1 ) DEFAULT 'N',
	later_update_person VARCHAR2 ( 1 ) DEFAULT 'N',
	broker VARCHAR2 ( 48 ),
	device_code VARCHAR2 ( 255 ),
	device_name VARCHAR2 ( 255 ),
	device_ip VARCHAR2 ( 255 ),
	device_longitude BINARY_DOUBLE,
	device_dimension BINARY_DOUBLE,
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_FACE_SEARCH_HIS_LOG primary key ( id, received_time) 
) PARTITION BY RANGE (received_time)
(partition p_197001 values less than(to_date('1970-02-01','YYYY-MM-DD')));
COMMENT ON TABLE person_face_search_his_log IS '人员人脸搜索历史日志表';
COMMENT ON COLUMN person_face_search_his_log.id IS '主键';
COMMENT ON COLUMN person_face_search_his_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_face_search_his_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_face_search_his_log.scene_type IS '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N，3：子系统日志回传)';
COMMENT ON COLUMN person_face_search_his_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_face_search_his_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_face_search_his_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_face_search_his_log.sub_treasury_code IS '分库编码';
COMMENT ON COLUMN person_face_search_his_log.sub_treasury_name IS '分库名称';
COMMENT ON COLUMN person_face_search_his_log.scene_image IS '现场照路径';
COMMENT ON COLUMN person_face_search_his_log.stock_image IS '底库照路径';
COMMENT ON COLUMN person_face_search_his_log.take_photo1 IS '抓拍图1路径';
COMMENT ON COLUMN person_face_search_his_log.take_photo2 IS '抓拍图2路径';
COMMENT ON COLUMN person_face_search_his_log.scene_stock_score IS '分值';
COMMENT ON COLUMN person_face_search_his_log.checklive_result IS '现场照件检活结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_search_his_log.result IS '结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_search_his_log.belong_to_stranger_lib IS '识别结果是否属于陌生人库(数据字典 Y：是，N：否)';
COMMENT ON COLUMN person_face_search_his_log.later_update_person IS '人员标识是否后期维护(数据字典 Y：是，N：否)';
COMMENT ON COLUMN person_face_search_his_log.broker IS '交易发起人';
COMMENT ON COLUMN person_face_search_his_log.device_code IS '设备编码';
COMMENT ON COLUMN person_face_search_his_log.device_name IS '设备名称';
COMMENT ON COLUMN person_face_search_his_log.device_ip IS '设备IP';
COMMENT ON COLUMN person_face_search_his_log.device_longitude IS '设备j经度(东经)';
COMMENT ON COLUMN person_face_search_his_log.device_dimension IS '设备维度(北纬)';
COMMENT ON COLUMN person_face_search_his_log.received_time IS '请求时间';
COMMENT ON COLUMN person_face_search_his_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_face_search_his_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_face_search_his_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_face_search_his_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_face_search_his_log.tenant IS '租户';
COMMENT ON COLUMN person_face_search_his_log.create_time IS '创建时间';
COMMENT ON COLUMN person_face_search_his_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
CALL sp_create_partition(LAST_DAY(sysdate), 'person_face_search_his_log','YYYYMM');
CALL sp_create_partition(LAST_DAY(ADD_MONTHS(sysdate,1)), 'person_face_search_his_log','YYYYMM');
/*==============================================================*/
/* Table: 人员人脸搜索日志表                             */
/*==============================================================*/
CREATE TABLE person_face_search_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	scene_type VARCHAR2 ( 1 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	sub_treasury_code VARCHAR2 ( 255 ),
	sub_treasury_name VARCHAR2 ( 255 ),
	scene_image VARCHAR2 ( 255 ) NOT NULL,
	stock_image VARCHAR2 ( 255 ),
	take_photo1 VARCHAR2 ( 255 ),
	take_photo2 VARCHAR2 ( 255 ),
	scene_stock_score BINARY_DOUBLE,
	checklive_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	belong_to_stranger_lib VARCHAR2 ( 1 ) DEFAULT 'N',
	later_update_person VARCHAR2 ( 1 ) DEFAULT 'N',
	broker VARCHAR2 ( 48 ),
	device_code VARCHAR2 ( 255 ),
	device_name VARCHAR2 ( 255 ),
	device_ip VARCHAR2 ( 255 ),
	device_longitude BINARY_DOUBLE,
	device_dimension BINARY_DOUBLE,
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_FACE_SEARCH_LOG primary key ( id ) 
);
COMMENT ON TABLE person_face_search_log IS '人员人脸搜索日志表';
COMMENT ON COLUMN person_face_search_log.id IS '主键';
COMMENT ON COLUMN person_face_search_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_face_search_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_face_search_log.scene_type IS '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N，3：子系统日志回传)';
COMMENT ON COLUMN person_face_search_log.unique_id IS '人员标识(识别结果)';
COMMENT ON COLUMN person_face_search_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_face_search_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_face_search_log.sub_treasury_code IS '分库编码';
COMMENT ON COLUMN person_face_search_log.sub_treasury_name IS '分库名称';
COMMENT ON COLUMN person_face_search_log.scene_image IS '现场照路径';
COMMENT ON COLUMN person_face_search_log.stock_image IS '底库照路径';
COMMENT ON COLUMN person_face_search_log.take_photo1 IS '抓拍图1路径';
COMMENT ON COLUMN person_face_search_log.take_photo2 IS '抓拍图2路径';
COMMENT ON COLUMN person_face_search_log.scene_stock_score IS '分值';
COMMENT ON COLUMN person_face_search_log.checklive_result IS '现场照件检活结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_search_log.result IS '结果(0通过，1未通过)';
COMMENT ON COLUMN person_face_search_log.belong_to_stranger_lib IS '识别结果是否属于陌生人库(数据字典 Y：是，N：否)';
COMMENT ON COLUMN person_face_search_log.later_update_person IS '人员标识是否后期维护(数据字典 Y：是，N：否)';
COMMENT ON COLUMN person_face_search_log.broker IS '交易发起人';
COMMENT ON COLUMN person_face_search_log.device_code IS '设备编码';
COMMENT ON COLUMN person_face_search_log.device_name IS '设备名称';
COMMENT ON COLUMN person_face_search_log.device_ip IS '设备IP';
COMMENT ON COLUMN person_face_search_log.device_longitude IS '设备j经度(东经)';
COMMENT ON COLUMN person_face_search_log.device_dimension IS '设备维度(北纬)';
COMMENT ON COLUMN person_face_search_log.received_time IS '请求时间';
COMMENT ON COLUMN person_face_search_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_face_search_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_face_search_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_face_search_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_face_search_log.tenant IS '租户';
COMMENT ON COLUMN person_face_search_log.create_time IS '创建时间';
COMMENT ON COLUMN person_face_search_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 人员指纹比对历史日志表                        */
/*==============================================================*/
CREATE TABLE person_finger_match_his_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	finger_no VARCHAR2 ( 2 ),
	scene_image VARCHAR2 ( 255 ) NOT NULL,
	stock_image VARCHAR2 ( 255 ),
	scene_stock_score BINARY_DOUBLE,
	scene_stock_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_FINGER_MATCH_HIS_LOG primary key ( id,received_time ) 
) PARTITION BY RANGE (received_time)
(partition p_197001 values less than(to_date('1970-02-01','YYYY-MM-DD')));
COMMENT ON TABLE person_finger_match_his_log IS '人员指纹比对历史日志表';
COMMENT ON COLUMN person_finger_match_his_log.id IS '主键';
COMMENT ON COLUMN person_finger_match_his_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_finger_match_his_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_finger_match_his_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_finger_match_his_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_finger_match_his_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_finger_match_his_log.finger_no IS '手指编码';
COMMENT ON COLUMN person_finger_match_his_log.scene_image IS '现场照路径';
COMMENT ON COLUMN person_finger_match_his_log.stock_image IS '底库照路径';
COMMENT ON COLUMN person_finger_match_his_log.scene_stock_score IS '现场照与库底库照比对分值';
COMMENT ON COLUMN person_finger_match_his_log.scene_stock_result IS '现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_finger_match_his_log.result IS '比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_finger_match_his_log.broker IS '交易发起人';
COMMENT ON COLUMN person_finger_match_his_log.received_time IS '请求时间';
COMMENT ON COLUMN person_finger_match_his_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_finger_match_his_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_finger_match_his_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_finger_match_his_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_finger_match_his_log.tenant IS '租户';
COMMENT ON COLUMN person_finger_match_his_log.create_time IS '创建时间';
COMMENT ON COLUMN person_finger_match_his_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
CALL sp_create_partition(LAST_DAY(sysdate), 'person_finger_match_his_log','YYYYMM');
CALL sp_create_partition(LAST_DAY(ADD_MONTHS(sysdate,1)), 'person_finger_match_his_log','YYYYMM');
/*==============================================================*/
/* Table: 人员指纹比对日志表                             */
/*==============================================================*/
CREATE TABLE person_finger_match_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	finger_no VARCHAR2 ( 2 ),
	scene_image VARCHAR2 ( 255 ) NOT NULL,
	stock_image VARCHAR2 ( 255 ),
	scene_stock_score BINARY_DOUBLE,
	scene_stock_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_FINGER_MATCH_LOG primary key ( id ) 
);
COMMENT ON TABLE person_finger_match_log IS '人员指纹比对日志表';
COMMENT ON COLUMN person_finger_match_log.id IS '主键';
COMMENT ON COLUMN person_finger_match_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_finger_match_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_finger_match_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_finger_match_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_finger_match_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_finger_match_log.finger_no IS '手指编码';
COMMENT ON COLUMN person_finger_match_log.scene_image IS '现场照路径';
COMMENT ON COLUMN person_finger_match_log.stock_image IS '底库照路径';
COMMENT ON COLUMN person_finger_match_log.scene_stock_score IS '现场照与库底库照比对分值';
COMMENT ON COLUMN person_finger_match_log.scene_stock_result IS '现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_finger_match_log.result IS '比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_finger_match_log.broker IS '交易发起人';
COMMENT ON COLUMN person_finger_match_log.received_time IS '请求时间';
COMMENT ON COLUMN person_finger_match_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_finger_match_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_finger_match_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_finger_match_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_finger_match_log.tenant IS '租户';
COMMENT ON COLUMN person_finger_match_log.create_time IS '创建时间';
COMMENT ON COLUMN person_finger_match_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 人员指纹搜索历史日志表                       */
/*==============================================================*/
CREATE TABLE person_finger_search_his_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	scene_type VARCHAR2 ( 1 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	sub_treasury_code VARCHAR2 ( 255 ),
	sub_treasury_name VARCHAR2 ( 255 ),
	finger_no VARCHAR2 ( 2 ),
	scene_image VARCHAR2 ( 255 ) NOT NULL,
	stock_image VARCHAR2 ( 255 ),
	scene_stock_score BINARY_DOUBLE,
	result VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_FINGER_SEARCH_HIS_LO primary key ( id, received_time ) 
) PARTITION BY RANGE (received_time)
(partition p_197001 values less than(to_date('1970-02-01','YYYY-MM-DD')));
COMMENT ON TABLE person_finger_search_his_log IS '人员指纹搜索历史日志表';
COMMENT ON COLUMN person_finger_search_his_log.id IS '主键';
COMMENT ON COLUMN person_finger_search_his_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_finger_search_his_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_finger_search_his_log.scene_type IS '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N)';
COMMENT ON COLUMN person_finger_search_his_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_finger_search_his_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_finger_search_his_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_finger_search_his_log.sub_treasury_code IS '分库编码';
COMMENT ON COLUMN person_finger_search_his_log.sub_treasury_name IS '分库名称';
COMMENT ON COLUMN person_finger_search_his_log.finger_no IS '手指编码';
COMMENT ON COLUMN person_finger_search_his_log.scene_image IS '现场照路径';
COMMENT ON COLUMN person_finger_search_his_log.stock_image IS '底库照路径';
COMMENT ON COLUMN person_finger_search_his_log.scene_stock_score IS '分值';
COMMENT ON COLUMN person_finger_search_his_log.result IS '结果(0通过，1未通过)';
COMMENT ON COLUMN person_finger_search_his_log.broker IS '交易发起人';
COMMENT ON COLUMN person_finger_search_his_log.received_time IS '请求时间';
COMMENT ON COLUMN person_finger_search_his_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_finger_search_his_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_finger_search_his_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_finger_search_his_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_finger_search_his_log.tenant IS '租户';
COMMENT ON COLUMN person_finger_search_his_log.create_time IS '创建时间';
COMMENT ON COLUMN person_finger_search_his_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
CALL sp_create_partition(LAST_DAY(sysdate), 'person_finger_search_his_log','YYYYMM');
CALL sp_create_partition(LAST_DAY(ADD_MONTHS(sysdate,1)), 'person_finger_search_his_log','YYYYMM');
/*==============================================================*/
/* Table: 人员指纹搜索日志表                           */
/*==============================================================*/
CREATE TABLE person_finger_search_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	scene_type VARCHAR2 ( 1 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	sub_treasury_code VARCHAR2 ( 255 ),
	sub_treasury_name VARCHAR2 ( 255 ),
	finger_no VARCHAR2 ( 2 ),
	scene_image VARCHAR2 ( 255 ) NOT NULL,
	stock_image VARCHAR2 ( 255 ),
	scene_stock_score BINARY_DOUBLE,
	result VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_FINGER_SEARCH_LOG primary key ( id ) 
);
COMMENT ON TABLE person_finger_search_log IS '人员指纹搜索日志表';
COMMENT ON COLUMN person_finger_search_log.id IS '主键';
COMMENT ON COLUMN person_finger_search_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_finger_search_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_finger_search_log.scene_type IS '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N)';
COMMENT ON COLUMN person_finger_search_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_finger_search_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_finger_search_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_finger_search_log.sub_treasury_code IS '分库编码';
COMMENT ON COLUMN person_finger_search_log.sub_treasury_name IS '分库名称';
COMMENT ON COLUMN person_finger_search_log.finger_no IS '手指编码';
COMMENT ON COLUMN person_finger_search_log.scene_image IS '现场照路径';
COMMENT ON COLUMN person_finger_search_log.stock_image IS '底库照路径';
COMMENT ON COLUMN person_finger_search_log.scene_stock_score IS '分值';
COMMENT ON COLUMN person_finger_search_log.result IS '结果(0通过，1未通过)';
COMMENT ON COLUMN person_finger_search_log.broker IS '交易发起人';
COMMENT ON COLUMN person_finger_search_log.received_time IS '请求时间';
COMMENT ON COLUMN person_finger_search_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_finger_search_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_finger_search_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_finger_search_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_finger_search_log.tenant IS '租户';
COMMENT ON COLUMN person_finger_search_log.create_time IS '创建时间';
COMMENT ON COLUMN person_finger_search_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 人员虹膜比对历史日志表                         */
/*==============================================================*/
CREATE TABLE person_iris_match_his_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	scene_left_image VARCHAR2 ( 255 ),
	scene_right_image VARCHAR2 ( 255 ),
	stock_left_image VARCHAR2 ( 255 ),
	stock_right_image VARCHAR2 ( 255 ),
	scene_lstock_score BINARY_DOUBLE,
	scene_lstock_result VARCHAR2 ( 1 ),
	scene_rstock_score BINARY_DOUBLE,
	scene_rstock_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	result_strategy VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_IRIS_MATCH_HIS_LOG primary key ( id,received_time ) 
) PARTITION BY RANGE (received_time)
(partition p_197001 values less than(to_date('1970-02-01','YYYY-MM-DD')));
COMMENT ON TABLE person_iris_match_his_log IS '人员虹膜比对历史日志表';
COMMENT ON COLUMN person_iris_match_his_log.id IS '主键';
COMMENT ON COLUMN person_iris_match_his_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_iris_match_his_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_iris_match_his_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_iris_match_his_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_iris_match_his_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_iris_match_his_log.scene_left_image IS '现场左眼照路径';
COMMENT ON COLUMN person_iris_match_his_log.scene_right_image IS '现场右眼照路径';
COMMENT ON COLUMN person_iris_match_his_log.stock_left_image IS '底库左眼照路径';
COMMENT ON COLUMN person_iris_match_his_log.stock_right_image IS '底库右眼照路径';
COMMENT ON COLUMN person_iris_match_his_log.scene_lstock_score IS '左眼现场照与库底库照比对分值';
COMMENT ON COLUMN person_iris_match_his_log.scene_lstock_result IS '左眼现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_match_his_log.scene_rstock_score IS '右眼现场照与库底库照比对分值';
COMMENT ON COLUMN person_iris_match_his_log.scene_rstock_result IS '右眼现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_match_his_log.result IS '比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_match_his_log.result_strategy IS '结果策略(1:与， 2:或)';
COMMENT ON COLUMN person_iris_match_his_log.broker IS '交易发起人';
COMMENT ON COLUMN person_iris_match_his_log.received_time IS '请求时间';
COMMENT ON COLUMN person_iris_match_his_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_iris_match_his_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_iris_match_his_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_iris_match_his_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_iris_match_his_log.tenant IS '租户';
COMMENT ON COLUMN person_iris_match_his_log.create_time IS '创建时间';
COMMENT ON COLUMN person_iris_match_his_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
CALL sp_create_partition(LAST_DAY(sysdate), 'person_iris_match_his_log','YYYYMM');
CALL sp_create_partition(LAST_DAY(ADD_MONTHS(sysdate,1)), 'person_iris_match_his_log','YYYYMM');
/*==============================================================*/
/* Table: 人员虹膜比对日志表                              */
/*==============================================================*/
CREATE TABLE person_iris_match_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	scene_left_image VARCHAR2 ( 255 ),
	scene_right_image VARCHAR2 ( 255 ),
	stock_left_image VARCHAR2 ( 255 ),
	stock_right_image VARCHAR2 ( 255 ),
	scene_lstock_score BINARY_DOUBLE,
	scene_lstock_result VARCHAR2 ( 1 ),
	scene_rstock_score BINARY_DOUBLE,
	scene_rstock_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	result_strategy VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_IRIS_MATCH_LOG primary key ( id ) 
);
COMMENT ON TABLE person_iris_match_log IS '人员虹膜比对日志表';
COMMENT ON COLUMN person_iris_match_log.id IS '主键';
COMMENT ON COLUMN person_iris_match_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_iris_match_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_iris_match_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_iris_match_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_iris_match_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_iris_match_log.scene_left_image IS '现场左眼照路径';
COMMENT ON COLUMN person_iris_match_log.scene_right_image IS '现场右眼照路径';
COMMENT ON COLUMN person_iris_match_log.stock_left_image IS '底库左眼照路径';
COMMENT ON COLUMN person_iris_match_log.stock_right_image IS '底库右眼照路径';
COMMENT ON COLUMN person_iris_match_log.scene_lstock_score IS '左眼现场照与库底库照比对分值';
COMMENT ON COLUMN person_iris_match_log.scene_lstock_result IS '左眼现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_match_log.scene_rstock_score IS '右眼现场照与库底库照比对分值';
COMMENT ON COLUMN person_iris_match_log.scene_rstock_result IS '右眼现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_match_log.result IS '比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_match_log.result_strategy IS '结果策略(1:与， 2:或)';
COMMENT ON COLUMN person_iris_match_log.broker IS '交易发起人';
COMMENT ON COLUMN person_iris_match_log.received_time IS '请求时间';
COMMENT ON COLUMN person_iris_match_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_iris_match_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_iris_match_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_iris_match_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_iris_match_log.tenant IS '租户';
COMMENT ON COLUMN person_iris_match_log.create_time IS '创建时间';
COMMENT ON COLUMN person_iris_match_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 人员虹膜搜索历史日志表                         */
/*==============================================================*/
CREATE TABLE person_iris_search_his_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	scene_type VARCHAR2 ( 1 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	sub_treasury_code VARCHAR2 ( 255 ),
	sub_treasury_name VARCHAR2 ( 255 ),
	scene_left_image VARCHAR2 ( 255 ),
	scene_right_image VARCHAR2 ( 255 ),
	stock_left_image VARCHAR2 ( 255 ),
	stock_right_image VARCHAR2 ( 255 ),
	scene_lstock_score BINARY_DOUBLE,
	scene_lstock_result VARCHAR2 ( 1 ),
	scene_rstock_score BINARY_DOUBLE,
	scene_rstock_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	result_strategy VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_IRIS_SEARCH_HIS_LOG primary key ( id,received_time ) 
) PARTITION BY RANGE (received_time)
(partition p_197001 values less than(to_date('1970-02-01','YYYY-MM-DD')));
COMMENT ON TABLE person_iris_search_his_log IS '人员虹膜搜索历史日志表';
COMMENT ON COLUMN person_iris_search_his_log.id IS '主键';
COMMENT ON COLUMN person_iris_search_his_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_iris_search_his_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_iris_search_his_log.scene_type IS '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N)';
COMMENT ON COLUMN person_iris_search_his_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_iris_search_his_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_iris_search_his_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_iris_search_his_log.sub_treasury_code IS '分库编码';
COMMENT ON COLUMN person_iris_search_his_log.sub_treasury_name IS '分库名称';
COMMENT ON COLUMN person_iris_search_his_log.scene_left_image IS '现场左眼照路径';
COMMENT ON COLUMN person_iris_search_his_log.scene_right_image IS '现场右眼照路径';
COMMENT ON COLUMN person_iris_search_his_log.stock_left_image IS '底库左眼照路径';
COMMENT ON COLUMN person_iris_search_his_log.stock_right_image IS '底库右眼照路径';
COMMENT ON COLUMN person_iris_search_his_log.scene_lstock_score IS '左眼现场照与库底库照比对分值';
COMMENT ON COLUMN person_iris_search_his_log.scene_lstock_result IS '左眼现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_search_his_log.scene_rstock_score IS '右眼现场照与库底库照比对分值';
COMMENT ON COLUMN person_iris_search_his_log.scene_rstock_result IS '右眼现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_search_his_log.result IS '结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_search_his_log.result_strategy IS '结果策略(1:与， 2:或)';
COMMENT ON COLUMN person_iris_search_his_log.broker IS '交易发起人';
COMMENT ON COLUMN person_iris_search_his_log.received_time IS '请求时间';
COMMENT ON COLUMN person_iris_search_his_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_iris_search_his_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_iris_search_his_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_iris_search_his_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_iris_search_his_log.tenant IS '租户';
COMMENT ON COLUMN person_iris_search_his_log.create_time IS '创建时间';
COMMENT ON COLUMN person_iris_search_his_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
CALL sp_create_partition(LAST_DAY(sysdate), 'person_iris_search_his_log','YYYYMM');
CALL sp_create_partition(LAST_DAY(ADD_MONTHS(sysdate,1)), 'person_iris_search_his_log','YYYYMM');
/*==============================================================*/
/* Table: 人员虹膜搜索日志表	                              */
/*==============================================================*/
CREATE TABLE person_iris_search_log (
	id VARCHAR2 ( 48 ) NOT NULL,
	handle_seq VARCHAR2 ( 48 ) NOT NULL,
	received_seq VARCHAR2 ( 48 ) NOT NULL,
	scene_type VARCHAR2 ( 1 ) NOT NULL,
	unique_id VARCHAR2 ( 48 ),
	dept_id INTEGER,
	channel_code VARCHAR2 ( 255 ),
	sub_treasury_code VARCHAR2 ( 255 ),
	sub_treasury_name VARCHAR2 ( 255 ),
	scene_left_image VARCHAR2 ( 255 ),
	scene_right_image VARCHAR2 ( 255 ),
	stock_left_image VARCHAR2 ( 255 ),
	stock_right_image VARCHAR2 ( 255 ),
	scene_lstock_score BINARY_DOUBLE,
	scene_lstock_result VARCHAR2 ( 1 ),
	scene_rstock_score BINARY_DOUBLE,
	scene_rstock_result VARCHAR2 ( 1 ),
	result VARCHAR2 ( 1 ),
	result_strategy VARCHAR2 ( 1 ),
	broker VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	time_used INTEGER,
	server_id VARCHAR2 ( 255 ),
	vendor_code VARCHAR2 ( 255 ),
	algs_version VARCHAR2 ( 255 ),
	tenant VARCHAR2 ( 255 ) DEFAULT 'standard',
	create_time DATE,
	batch_date DATE,
	constraint PK_PERSON_IRIS_SEARCH_LOG primary key ( id ) 
);
COMMENT ON TABLE person_iris_search_log IS '人员虹膜搜索日志表';
COMMENT ON COLUMN person_iris_search_log.id IS '主键';
COMMENT ON COLUMN person_iris_search_log.handle_seq IS '平台流水号';
COMMENT ON COLUMN person_iris_search_log.received_seq IS '业务流水号';
COMMENT ON COLUMN person_iris_search_log.scene_type IS '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N)';
COMMENT ON COLUMN person_iris_search_log.unique_id IS '人员标识';
COMMENT ON COLUMN person_iris_search_log.dept_id IS '部门ID';
COMMENT ON COLUMN person_iris_search_log.channel_code IS '渠道编码';
COMMENT ON COLUMN person_iris_search_log.sub_treasury_code IS '分库编码';
COMMENT ON COLUMN person_iris_search_log.sub_treasury_name IS '分库名称';
COMMENT ON COLUMN person_iris_search_log.scene_left_image IS '现场左眼照路径';
COMMENT ON COLUMN person_iris_search_log.scene_right_image IS '现场右眼照路径';
COMMENT ON COLUMN person_iris_search_log.stock_left_image IS '底库左眼照路径';
COMMENT ON COLUMN person_iris_search_log.stock_right_image IS '底库右眼照路径';
COMMENT ON COLUMN person_iris_search_log.scene_lstock_score IS '左眼现场照与库底库照比对分值';
COMMENT ON COLUMN person_iris_search_log.scene_lstock_result IS '左眼现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_search_log.scene_rstock_score IS '右眼现场照与库底库照比对分值';
COMMENT ON COLUMN person_iris_search_log.scene_rstock_result IS '右眼现场照与库底库照比对结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_search_log.result IS '结果(0通过，1未通过)';
COMMENT ON COLUMN person_iris_search_log.result_strategy IS '结果策略(1:与， 2:或)';
COMMENT ON COLUMN person_iris_search_log.broker IS '交易发起人';
COMMENT ON COLUMN person_iris_search_log.received_time IS '请求时间';
COMMENT ON COLUMN person_iris_search_log.time_used IS '耗时(ms)';
COMMENT ON COLUMN person_iris_search_log.server_id IS '服务器标识';
COMMENT ON COLUMN person_iris_search_log.vendor_code IS '厂商';
COMMENT ON COLUMN person_iris_search_log.algs_version IS '算法版本';
COMMENT ON COLUMN person_iris_search_log.tenant IS '租户';
COMMENT ON COLUMN person_iris_search_log.create_time IS '创建时间';
COMMENT ON COLUMN person_iris_search_log.batch_date IS '定时任务执行时间(执行定时任务时使用此字段)';
/*==============================================================*/
/* Table: 组织机构中间表                                    */
/*==============================================================*/
CREATE TABLE sync_office_info (
	id VARCHAR2 ( 100 ) NOT NULL,
	office_name VARCHAR2 ( 150 ),
	office_en VARCHAR2 ( 100 ),
	parent_id VARCHAR2 ( 100 ) DEFAULT '0',
	office_address VARCHAR2 ( 20 ),
	office_phone VARCHAR2 ( 20 ),
	status CHAR ( 1 ) DEFAULT '0',
	create_time DATE NOT NULL,
	update_time DATE NOT NULL,
	constraint PK_SYNC_OFFICE_INFO primary key ( id ) 
);
COMMENT ON TABLE sync_office_info IS '组织机构中间表';
COMMENT ON COLUMN sync_office_info.id IS '主键';
COMMENT ON COLUMN sync_office_info.office_name IS '部门名称';
COMMENT ON COLUMN sync_office_info.office_en IS '部门英文名称';
COMMENT ON COLUMN sync_office_info.parent_id IS '隶属部门号（默认是0）';
COMMENT ON COLUMN sync_office_info.office_address IS '部门地址';
COMMENT ON COLUMN sync_office_info.office_phone IS '部门联系电话';
COMMENT ON COLUMN sync_office_info.status IS '部门状态（0正常 1停用）';
COMMENT ON COLUMN sync_office_info.create_time IS '创建时间';
COMMENT ON COLUMN sync_office_info.update_time IS '更新时间';
/*==============================================================*/
/* View: 生物特征比对、搜索交易视图（用于实时交易推送）        */
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
	person_face_match_log UNION
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
	person_face_search_log UNION
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
	person_finger_match_log UNION
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
	person_finger_search_log UNION
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
	person_iris_match_log UNION
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
	person_iris_search_log WITH read only;
COMMENT ON TABLE view_person_bio_trans IS '生物特征比对、搜索交易视图(用于实时交易推送)';
COMMENT ON COLUMN view_person_bio_trans.handle_seq IS '平台流水号';
COMMENT ON COLUMN view_person_bio_trans.received_seq IS '业务流水号';
COMMENT ON COLUMN view_person_bio_trans.channel_code IS '渠道编码';
COMMENT ON COLUMN view_person_bio_trans.received_time IS '请求时间';
COMMENT ON COLUMN view_person_bio_trans.time_used IS '耗时(ms)';
COMMENT ON COLUMN view_person_bio_trans.result IS '比对结果(0通过，1未通过)';
COMMENT ON COLUMN view_person_bio_trans.unique_id IS '人员标识';
COMMENT ON COLUMN view_person_bio_trans.broker IS '交易发起人';
COMMENT ON COLUMN view_person_bio_trans.create_time IS '创建时间';


-- ----------------------------
-- 渠道业务表和分库业务表,添加组合唯一索引
-- ----------------------------
CREATE UNIQUE INDEX channelIdPersonIdUnique ON channel_business (channel_id, person_id);
CREATE UNIQUE INDEX cIdSubCodePIdUnique ON channel_subtreasury_busi (channel_id,sub_treasury_code, person_id);
-- ----------------------------
-- 人员基础信息表添加唯一索引
-- ----------------------------
CREATE UNIQUE INDEX personInfoUniqueIdIndex ON base_person_info (unique_id);
-- ----------------------------
-- 人脸信息表表添加正常索引
-- ----------------------------
CREATE UNIQUE INDEX facePersonIdIndex ON base_person_face (person_id);
-- ----------------------------
-- 指纹信息表表添加正常索引
-- ----------------------------
CREATE UNIQUE INDEX fingerPersonIdIndex ON base_person_finger (person_id);
-- ----------------------------
-- 虹膜信息表表添加正常索引
-- ----------------------------
CREATE UNIQUE INDEX irisPersonIdIndex ON base_person_iris (person_id);

/*==============================================================*/
/* Table: 基础数据_接口请求历史报文                          					*/
/*==============================================================*/
CREATE TABLE base_request_his_record (
	id VARCHAR2 ( 48 ) NOT NULL,
	trans_code VARCHAR2 ( 48 ),
	trans_title VARCHAR2 ( 48 ),
	received_time DATE NOT NULL,
	request_msg CLOB,
	client_ip VARCHAR2 ( 48 ),
	send_time DATE NOT NULL,
	response_msg CLOB NOT NULL,
	time_used INTEGER NOT NULL,
	status_code VARCHAR2 ( 48 ) DEFAULT '0' NOT NULL,
	trans_url VARCHAR2 ( 255 ),
	class_method VARCHAR2 ( 255 ),
	channel_code VARCHAR2 ( 255 ),
	constraint PK_BASE_REQUEST_HIS_RECORD primary key ( id, received_time ) 
) PARTITION BY RANGE (received_time)
(partition p_19700101 values less than(to_date('1970-01-01','YYYY-MM-DD')));
COMMENT ON TABLE base_request_his_record IS '接口请求历史报文';
COMMENT ON COLUMN base_request_his_record.id IS '主键';
COMMENT ON COLUMN base_request_his_record.trans_code IS '交易码';
COMMENT ON COLUMN base_request_his_record.trans_title IS '交易标题';
COMMENT ON COLUMN base_request_his_record.received_time IS '请求时间';
COMMENT ON COLUMN base_request_his_record.request_msg IS '请求报文';
COMMENT ON COLUMN base_request_his_record.client_ip IS '客户端IP';
COMMENT ON COLUMN base_request_his_record.send_time IS '响应时间';
COMMENT ON COLUMN base_request_his_record.response_msg IS '响应报文';
COMMENT ON COLUMN base_request_his_record.time_used IS '耗时(ms)';
COMMENT ON COLUMN base_request_his_record.status_code IS '状态码';
COMMENT ON COLUMN base_request_his_record.trans_url IS '交易请求路径';
COMMENT ON COLUMN base_request_his_record.class_method IS '处理方法';
COMMENT ON COLUMN base_request_his_record.channel_code IS '渠道编码';
-- 作用是：允许分区表的分区键是可更新。
-- 当某一行更新时，如果更新的是分区列，并且更新后的列植不属于原来的这个分区，
-- 如果开启了这个选项，就会把这行从这个分区中 delete 掉，并加到更新后所属的分区，此时就会发生 rowid 的改变。
-- 相当于一个隐式的 delete + insert ，但是不会触发 insert/delete 触发器。
ALTER TABLE base_request_his_record enable ROW movement;
CALL sp_create_partition(sysdate - 2, 'base_request_his_record','YYYYMMDD');
CALL sp_create_partition(sysdate - 1, 'base_request_his_record','YYYYMMDD');
CALL sp_create_partition(sysdate, 'base_request_his_record','YYYYMMDD');
CALL sp_create_partition(sysdate + 1, 'base_request_his_record','YYYYMMDD');
CALL sp_create_partition(sysdate + 2, 'base_request_his_record','YYYYMMDD');


INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('1', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('2', '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '初始化密码 123456');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('3', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '深黑主题theme-dark，浅色主题theme-light，深蓝主题theme-blue');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('4', '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-02 13:44:46', 'SYYYY-MM-DD HH24:MI:SS'), '是否开启注册用户功能');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('100', '二维码图片文件夹', 'basedata.qrcode.dir', './eyecool/biapwp/basedata/qrcode/', 'N', 'admin', TO_DATE('2019-10-16 19:12:27', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:14:14', 'SYYYY-MM-DD HH24:MI:SS'), '基础数据-二维码图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('101', '人脸图片文件夹', 'basedata.face.dir', './eyecool/biapwp/basedata/face/', 'N', 'admin', TO_DATE('2019-10-23 14:23:57', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:14:08', 'SYYYY-MM-DD HH24:MI:SS'), '基础数据--人脸图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('102', '指纹图片文件夹', 'basedata.finger.dir', './eyecool/biapwp/basedata/finger/', 'N', 'admin', TO_DATE('2019-10-24 00:03:19', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:13:02', 'SYYYY-MM-DD HH24:MI:SS'), '基础数据--指纹图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('103', '虹膜图片文件夹', 'basedata.iris.dir', './eyecool/biapwp/basedata/iris/', 'N', 'admin', TO_DATE('2019-10-24 10:09:54', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:56', 'SYYYY-MM-DD HH24:MI:SS'), '基础数据--虹膜图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('104', '人脸图片质量检测阈值', 'basedata.face.quality.detect.threshold', '60', 'N', 'admin', TO_DATE('2019-10-24 10:11:38', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:13:54', 'SYYYY-MM-DD HH24:MI:SS'), '人脸图片质量检测阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('105', '证件照文件夹', 'basedata.cert.dir', './eyecool/biapwp/basedata/cert/', 'N', 'admin', TO_DATE('2019-10-24 14:24:18', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:46', 'SYYYY-MM-DD HH24:MI:SS'), '证件照文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('106', '人脸1:1比对阈值', 'basedata.face.compare.threshold', '60', 'N', 'admin', TO_DATE('2019-10-29 12:00:06', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:37', 'SYYYY-MM-DD HH24:MI:SS'), '人脸1:1比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('107', '指纹1:1比对阈值', 'basedata.finger.compare.threshold', '60', 'N', 'admin', TO_DATE('2019-10-29 12:00:27', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:31', 'SYYYY-MM-DD HH24:MI:SS'), '指纹1:1比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('108', '虹膜1:1比对阈值', 'basedata.iris.compare.threshold', '60', 'N', 'admin', TO_DATE('2019-10-29 12:00:41', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:27', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜1:1比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('109', '人脸自助采集页面标题', 'basedata.face.collect.page.title', '人脸图像自助采集', 'N', 'admin', TO_DATE('2019-10-29 12:01:06', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:23', 'SYYYY-MM-DD HH24:MI:SS'), '人脸自助采集页面标题');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('110', '人脸自助采集默认登录用户密码', 'basedata.face.collect.login.pwd', 'collect', 'N', 'admin', TO_DATE('2019-10-29 12:01:25', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:17', 'SYYYY-MM-DD HH24:MI:SS'), '人脸自助采集默认登录用户密码');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('111', '重复虹膜阈值', 'basedata.iris.repeat.threshold', '95', 'N', 'admin', TO_DATE('2019-11-14 18:06:08', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-06 14:27:39', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜重复阈值(比对得分超过阈值认为重复)');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('112', '重复指纹阈值', 'basedata.finger.repeat.threshold', '90', 'N', 'admin', TO_DATE('2019-11-14 18:07:16', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:09', 'SYYYY-MM-DD HH24:MI:SS'), '重复指纹阈值(比对得分超过阈值认为重复)');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('113', '基础数据接口并发量', 'basedata.interface.concurrent', '1000', 'N', 'admin', TO_DATE('2019-11-18 10:01:07', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:12:05', 'SYYYY-MM-DD HH24:MI:SS'), '基础数据接口请求并发量');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('114', '人脸自助采集校验是否校验证件库', 'basedata.face.collect.validte.cert', 'N', 'N', 'admin', TO_DATE('2019-11-18 11:05:42', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-06 15:23:16', 'SYYYY-MM-DD HH24:MI:SS'), '人脸自助采集校验不存在底库是否校验证件库(Y/N)');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('115', '人脸1-N搜索图片文件夹', 'busi.face.searchN.dir', './eyecool/busi/face/search/', 'N', 'admin', TO_DATE('2019-11-20 14:27:03', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:11:54', 'SYYYY-MM-DD HH24:MI:SS'), '人脸1-N搜索图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('116', '人脸1-N搜索比对阈值', 'basedata.face.searchN.threshold', '80', 'N', 'admin', TO_DATE('2019-11-20 14:28:50', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:11:49', 'SYYYY-MM-DD HH24:MI:SS'), '人脸1-N搜索比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('117', '指纹图片质量检测阈值', 'basedata.finger.quality.detect.threshold', '60', 'N', 'admin', TO_DATE('2019-11-21 16:43:18', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-02-28 11:24:10', 'SYYYY-MM-DD HH24:MI:SS'), '指纹图片质量检测阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('118', '人脸检活阈值', 'basedata.face.checklive.threshold', '998', 'N', 'admin', TO_DATE('2019-11-21 16:44:33', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-01-15 10:20:11', 'SYYYY-MM-DD HH24:MI:SS'), '人脸检活阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('119', '指纹1-N搜索图片文件夹', 'busi.finger.searchN.dir', './eyecool/busi/finger/search/', 'N', 'admin', TO_DATE('2019-11-25 15:33:35', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:11:25', 'SYYYY-MM-DD HH24:MI:SS'), '指纹1-N搜索图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('120', '虹膜1-N搜索图片文件夹', 'busi.iris.searchN.dir', './eyecool/busi/iris/search/', 'N', 'admin', TO_DATE('2019-11-25 15:34:50', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:11:16', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜1-N搜索图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('121', '指纹1-N搜索比对阈值', 'basedata.finger.searchN.threshold', '80', 'N', 'admin', TO_DATE('2019-11-25 15:47:24', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:11:08', 'SYYYY-MM-DD HH24:MI:SS'), '指纹1-N搜索比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('122', '虹膜1-N搜索比对阈值', 'basedata.iris.searchN.threshold', '80', 'N', 'admin', TO_DATE('2019-11-25 15:48:04', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:11:04', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜1-N搜索比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('123', '人脸1:1认证图片文件夹', 'busi.face.compare.dir', './eyecool/busi/face/compare/', 'N', 'admin', TO_DATE('2019-11-26 17:19:17', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:10:42', 'SYYYY-MM-DD HH24:MI:SS'), '人脸1:1认证图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('124', '指纹1:1认证图片文件夹', 'busi.finger.compare.dir', './eyecool/busi/finger/compare/', 'N', 'admin', TO_DATE('2019-11-26 17:22:17', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:10:37', 'SYYYY-MM-DD HH24:MI:SS'), '指纹1:1认证图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('125', '虹膜1:1认证图片文件夹', 'busi.iris.compare.dir', './eyecool/busi/iris/compare/', 'N', 'admin', TO_DATE('2019-11-26 17:22:53', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:10:24', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜1:1认证图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('126', '虹膜1:1比对结果策略', 'busi.iris.compare.result.strategy', '1', 'N', 'admin', TO_DATE('2019-11-28 10:54:40', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-03 14:10:31', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜1:1比对结果策略（1：左眼&&右眼 2：左眼||右眼）');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('127', '人脸入库是否进行1-N校验', 'basedata.face.add.isValidN', 'N', 'N', 'admin', TO_DATE('2019-12-10 10:40:45', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-26 13:09:21', 'SYYYY-MM-DD HH24:MI:SS'), '人脸入库是否进行1-N校验(Y/N)，用于新增、修改、自助采集');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('128', '虹膜1:N搜索结果策略', 'busi.iris.searchN.result.strategy', '2', 'N', 'admin', TO_DATE('2019-12-16 15:57:47', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-16 15:58:05', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜1:N搜索结果策略（1：左眼&&右眼 2：左眼||右眼）');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('129', '自助签约默认登录用户密码', 'busi.self.open.login.pwd', 'selfopen', 'N', 'admin', TO_DATE('2019-12-26 11:48:18', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '自助签约默认登录用户密码');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('130', '指纹入库是否进行1-N校验', 'basedata.finger.add.isValidN', 'N', 'N', 'admin', TO_DATE('2019-12-26 14:42:48', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-26 14:43:30', 'SYYYY-MM-DD HH24:MI:SS'), '指纹入库是否进行1-N校验(Y/N)， 用于新增、修改');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('131', '虹膜入库是否进行1-N校验', 'basedata.iris.add.isValidN', 'N', 'N', 'admin', TO_DATE('2019-12-26 14:43:13', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-26 14:43:47', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜入库是否进行1-N校验(Y/N)， 用于新增、修改');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('132', '设备APP版本文件存放文件夹', 'device.version.file.dir', './eyecool/device/version/', 'N', 'admin', TO_DATE('2019-12-27 13:30:34', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-01-02 08:26:12', 'SYYYY-MM-DD HH24:MI:SS'), '设备APP版本文件存放文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES ('133', '消息通知附件存放位置', 'msg.attachment.dir', './eyecool/msg/attachment/', 'N', 'admin', TO_DATE('2020-03-27 15:18:31', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-27 16:27:38', 'SYYYY-MM-DD HH24:MI:SS'), '消息通知附件存放位置');



INSERT INTO sys_dept(dept_id, parent_id, ancestors, dept_code, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time, update_by, update_time) VALUES ('99', '100', '0,100', 'default', '默认部门', '0', '眼神', '15888888888', 'eyecool@eyecool.cn', '0', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-01-10 11:31:27', 'SYYYY-MM-DD HH24:MI:SS'));
INSERT INTO sys_dept(dept_id, parent_id, ancestors, dept_code, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time, update_by, update_time) VALUES ('100', '0', '0', NULL, '眼神科技', '0', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-02-24 14:50:54', 'SYYYY-MM-DD HH24:MI:SS'));



INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('1', '用户性别', 'sys_user_sex', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '用户性别列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('2', '菜单状态', 'sys_show_hide', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '菜单状态列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('3', '系统开关', 'sys_normal_disable', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '系统开关列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('4', '任务状态', 'sys_job_status', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '任务状态列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('5', '任务分组', 'sys_job_group', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '任务分组列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('6', '系统是否', 'sys_yes_no', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '系统是否列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('7', '通知类型', 'sys_notice_type', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '通知类型列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('8', '通知状态', 'sys_notice_status', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '通知状态列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('9', '操作类型', 'sys_oper_type', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '操作类型列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('10', '系统状态', 'sys_common_status', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '登录状态列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('100', '数据来源', 'apply_data_source', '0', 'admin', TO_DATE('2019-10-17 09:35:37', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '数据来源');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('101', '人员标记', 'apply_person_flag', '0', 'admin', TO_DATE('2019-10-17 09:41:53', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '人员标记');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('102', '是否加密', 'apply_encrypted', '0', 'admin', TO_DATE('2019-10-23 10:29:19', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '是否加密');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('103', '手指编码', 'bio_finger_code', '0', 'admin', TO_DATE('2019-10-21 11:11:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '手指编码');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('104', '身份证指纹', 'bio_idcard_finger', '0', 'admin', TO_DATE('2019-10-21 11:26:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '身份证指纹');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('105', '眼睛编码', 'bio_eye_code', '0', 'admin', TO_DATE('2019-10-21 17:42:46', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '眼睛编码');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('106', '证件类型', 'sys_cert_type', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('107', '证件照片类型', 'cert_photo_type', '0', 'admin', TO_DATE('2019-10-24 14:52:57', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-25 13:21:06', 'SYYYY-MM-DD HH24:MI:SS'), '证件照片类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('108', '民族', 'sys_nation', '0', 'admin', TO_DATE('2019-10-24 15:07:30', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '民族');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('109', '生物信息图片类型', 'bio_photo_type', '0', 'admin', TO_DATE('2019-10-25 13:20:32', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-25 13:20:46', 'SYYYY-MM-DD HH24:MI:SS'), '生物信息图片类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('110', '生物特征开通状态', 'bio_mode_status', '0', 'admin', TO_DATE('2019-10-29 11:24:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '生物特征开通状态');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('112', '渠道1-N识别方式', 'search_n_type', '0', 'admin', TO_DATE('2019-10-29 11:53:03', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-28 16:09:30', 'SYYYY-MM-DD HH24:MI:SS'), '1-N识别方式');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('113', 'HTTP交易接口', 'http_interface', '0', 'admin', TO_DATE('2019-10-29 15:01:34', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-07 17:10:22', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('115', '渠道管理认证类型', 'channel_bio_attest_type', '0', 'admin', TO_DATE('2019-11-01 09:59:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '渠道管理认证类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('116', '渠道管理数据来源', 'channel_business_source', '0', 'admin', TO_DATE('2019-11-04 09:28:47', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '渠道管理数据来源');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('117', '生物认证识别结果', 'bio_result', '0', 'admin', TO_DATE('2019-11-26 13:58:56', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-26 14:02:52', 'SYYYY-MM-DD HH24:MI:SS'), '生物认证识别结果');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('118', '生物特征1-N日志场景类型', 'search_log_type', '0', 'admin', TO_DATE('2019-11-27 10:22:09', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-27 10:22:23', 'SYYYY-MM-DD HH24:MI:SS'), '生物特征1-N日志场景类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('119', '虹膜1:1比对结果策略', 'iris_match_result_strategy', '0', 'admin', TO_DATE('2019-11-28 10:31:21', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '虹膜1:1比对结果策略(左&&右 ，左||右)');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('120', '前端设备APP版本类型', 'app_version_type', '0', 'admin', TO_DATE('2019-12-27 12:09:48', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '前端设备APP版本类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('121', '设备类型', 'client_device_type', '0', 'admin', TO_DATE('2019-12-27 16:15:32', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('122', '设备升级状态', 'device_upgrade_status', '0', 'admin', TO_DATE('2019-12-30 13:47:16', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备升级状态');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('123', '设备升级任务结果', 'device_upgrade_result', '0', 'admin', TO_DATE('2020-02-19 15:06:58', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备升级任务结果');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('124', '消息通知方式', 'msg_notice_method', '0', 'admin', TO_DATE('2020-03-17 15:22:11', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '消息通知方式');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('125', '消息发送模式', 'msg_type', '0', 'admin', TO_DATE('2020-03-17 15:25:18', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-23 13:15:01', 'SYYYY-MM-DD HH24:MI:SS'), '消息发送模式');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('126', '消息推送结果', 'msg_result', '0', 'admin', TO_DATE('2020-03-19 11:18:37', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '消息推送结果');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('127', '邮件类型', 'msg_mail_type', '0', 'admin', TO_DATE('2020-03-23 10:37:21', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '邮件类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('128', '钉钉消息类型', 'msg_dingtalk_type', '0', 'admin', TO_DATE('2020-04-01 09:32:20', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉消息类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES ('129', '钉钉媒体文件类型', 'msg_dingtalk_media_type', '0', 'admin', TO_DATE('2020-04-01 11:48:30', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉媒体文件类型');





INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('1', '1', '男', '0', 'sys_user_sex', NULL, NULL, 'Y', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '性别男');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('2', '2', '女', '1', 'sys_user_sex', NULL, NULL, 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '性别女');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('3', '3', '未知', '2', 'sys_user_sex', NULL, NULL, 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '性别未知');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('4', '1', '显示', '0', 'sys_show_hide', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '显示菜单');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('5', '2', '隐藏', '1', 'sys_show_hide', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '隐藏菜单');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('6', '1', '正常', '0', 'sys_normal_disable', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '正常状态');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('7', '2', '停用', '1', 'sys_normal_disable', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '停用状态');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('8', '1', '正常', '0', 'sys_job_status', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '正常状态');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('9', '2', '暂停', '1', 'sys_job_status', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '停用状态');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('10', '1', '默认', 'DEFAULT', 'sys_job_group', NULL, NULL, 'Y', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '默认分组');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('11', '2', '系统', 'SYSTEM', 'sys_job_group', NULL, NULL, 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '系统分组');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('12', '1', '是', 'Y', 'sys_yes_no', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '系统默认是');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('13', '2', '否', 'N', 'sys_yes_no', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '系统默认否');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('14', '1', '通知', '1', 'sys_notice_type', NULL, 'warning', 'Y', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '通知');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('15', '2', '公告', '2', 'sys_notice_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '公告');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('16', '1', '正常', '0', 'sys_notice_status', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '正常状态');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('17', '2', '关闭', '1', 'sys_notice_status', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '关闭状态');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('18', '99', '其他', '0', 'sys_oper_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '其他操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('19', '1', '新增', '1', 'sys_oper_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '新增操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('20', '2', '修改', '2', 'sys_oper_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '修改操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('21', '3', '删除', '3', 'sys_oper_type', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '删除操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('22', '4', '授权', '4', 'sys_oper_type', NULL, 'primary', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '授权操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('23', '5', '导出', '5', 'sys_oper_type', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '导出操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('24', '6', '导入', '6', 'sys_oper_type', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '导入操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('25', '7', '强退', '7', 'sys_oper_type', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '强退操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('26', '8', '生成代码', '8', 'sys_oper_type', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '生成操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('27', '9', '清空数据', '9', 'sys_oper_type', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '清空操作');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('28', '1', '成功', '0', 'sys_common_status', NULL, 'primary', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '正常状态');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('29', '2', '失败', '1', 'sys_common_status', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '停用状态');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('100', '1', '内部接口', 'INTERFACE', 'apply_data_source', NULL, 'success', 'Y', '0', 'admin', TO_DATE('2019-10-17 09:36:31', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 11:07:25', 'SYYYY-MM-DD HH24:MI:SS'), '数据来源--接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('101', '2', '数据导入', 'IMP', 'apply_data_source', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-10-17 09:37:03', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-23 20:46:33', 'SYYYY-MM-DD HH24:MI:SS'), '数据来源--数据导入');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('102', '3', 'HTTP接口', 'HTTP', 'apply_data_source', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2019-10-17 09:37:52', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-22 20:37:13', 'SYYYY-MM-DD HH24:MI:SS'), '数据来源--HTTP');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('103', '1', '正常', '1', 'apply_person_flag', NULL, 'success', 'Y', '0', 'admin', TO_DATE('2019-10-17 09:42:46', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-18 13:57:32', 'SYYYY-MM-DD HH24:MI:SS'), '人员标记--正常');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('104', '2', '红名单', '2', 'apply_person_flag', NULL, 'primary', 'N', '0', 'admin', TO_DATE('2019-10-17 09:43:21', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-18 13:57:25', 'SYYYY-MM-DD HH24:MI:SS'), '人员标记--红名单');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('105', '3', '黑名单', '3', 'apply_person_flag', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2019-10-17 09:43:40', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-18 13:57:18', 'SYYYY-MM-DD HH24:MI:SS'), '人员标记--黑名单');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('106', '1', '加密', '1', 'apply_encrypted', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2019-10-23 10:30:27', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 11:06:21', 'SYYYY-MM-DD HH24:MI:SS'), '是否加密-加密');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('107', '2', '不加密', '0', 'apply_encrypted', NULL, 'success', 'N', '0', 'admin', TO_DATE('2019-10-23 10:30:57', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 11:05:23', 'SYYYY-MM-DD HH24:MI:SS'), '是否加密-不加密');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('167', '1', '左手拇指', '16', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:12:37', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:40:15', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-左手拇指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('168', '2', '左手食指', '17', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:13:18', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:40:21', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-左手食指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('169', '3', '左手中指', '18', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:14:12', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:40:42', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-左手中指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('170', '4', '左手环指', '19', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:14:43', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:40:52', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-左手无名指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('171', '5', '左手小指', '20', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:15:28', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:40:58', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-左手小指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('172', '6', '右手拇指', '11', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:16:02', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:39:03', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-右手拇指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('173', '7', '右手食指', '12', 'bio_finger_code', NULL, NULL, 'Y', '0', 'admin', TO_DATE('2019-10-21 11:16:20', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:39:20', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-右手食指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('174', '8', '右手中指', '13', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:16:47', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:39:32', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-右手中指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('175', '9', '右手环指', '14', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:17:10', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:39:46', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-右手无名指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('176', '10', '右手小指', '15', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:17:51', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-12 10:39:58', 'SYYYY-MM-DD HH24:MI:SS'), '手指编码-右手小指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('179', '1', '身份证指纹A', 'A', 'bio_idcard_finger', NULL, NULL, 'Y', '0', 'admin', TO_DATE('2019-10-21 11:26:39', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '身份证指纹A');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('180', '2', '身份证指纹B', 'B', 'bio_idcard_finger', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 11:26:56', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '身份证指纹B');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('181', '1', '左眼', 'L', 'bio_eye_code', NULL, NULL, 'Y', '0', 'admin', TO_DATE('2019-10-21 17:43:12', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '眼睛编码-左眼');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('182', '2', '右眼', 'R', 'bio_eye_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-21 17:43:30', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '眼睛编码-右眼');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('183', '1', '居民身份证', '111', 'sys_cert_type', NULL, 'default', 'Y', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-居民身份证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('184', '2', '临时居民身份证', '112', 'sys_cert_type', NULL, 'primary', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-临时居民身份证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('185', '3', '户口簿', '113', 'sys_cert_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-户口簿');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('186', '4', '军官证', '114', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-军官证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('187', '5', '警官证', '123', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-警官证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('188', '6', '学生证', '133', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-学生证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('189', '7', '外交护照', '411', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-外交护照');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('190', '8', '公务护照', '412', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-公务护照');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('191', '9', '因公普通护照', '413', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-因公普通护照');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('192', '10', '护照', '414', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-普通护照');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('193', '11', '入出境通行证', '416', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-入出境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('194', '12', '外国人出入境证', '417', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-外国人出入境证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('195', '13', '海员证', '419', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-海员证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('263', '46', '德昂族', '46', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('264', '47', '保安族', '47', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('265', '48', '裕固族', '48', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('266', '49', '京族', '49', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('267', '50', '塔塔尔族', '50', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('268', '51', '独龙族', '51', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('269', '52', '鄂伦春族', '52', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('270', '53', '赫哲族', '53', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('271', '54', '门巴族', '54', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('272', '55', '珞巴族', '55', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('273', '56', '基诺族', '56', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('274', '57', '穿青人族', '81', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('275', '58', '其他', '97', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('276', '59', '外国血统', '98', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('277', '1', '人脸图片', '1', 'bio_photo_type', NULL, NULL, 'Y', '0', 'admin', TO_DATE('2019-10-25 13:21:32', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '生物信息图片类型-人脸图片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('278', '2', '指纹图片', '2', 'bio_photo_type', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-25 13:22:33', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '生物信息图片类型-指纹图片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('279', '3', '虹膜图片', '3', 'bio_photo_type', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-25 13:22:51', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '生物信息图片类型-虹膜图片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('280', '1', '开通', '1', 'bio_mode_status', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2019-10-29 11:25:39', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '生物特征开通状态-开通');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('281', '2', '不开通', '0', 'bio_mode_status', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2019-10-29 11:26:10', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '生物特征开通状态-不开通');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('285', '1', '校验分库', '1', 'search_n_type', NULL, 'primary', 'N', '0', 'admin', TO_DATE('2019-10-29 11:53:38', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-12 16:48:46', 'SYYYY-MM-DD HH24:MI:SS'), '1-N识别方式-校验分库');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('286', '2', '校验渠道库', '2', 'search_n_type', NULL, 'warning', 'Y', '0', 'admin', TO_DATE('2019-10-29 11:54:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-12 16:48:39', 'SYYYY-MM-DD HH24:MI:SS'), '1-N识别方式-校验渠道库');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('287', '3', '校验全库', '3', 'search_n_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2019-10-29 11:54:35', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-12 16:48:34', 'SYYYY-MM-DD HH24:MI:SS'), '1-N识别方式-校验全库');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('288', '1', '新增人员信息', 'PERSON_INFO_INSERT', 'http_interface', NULL, NULL, 'Y', '0', 'admin', TO_DATE('2019-10-29 15:03:39', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-02-25 09:49:22', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口-新增人员信息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('291', '1', '人脸', '0', 'channel_bio_attest_type', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2019-11-01 10:01:15', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-01 10:01:48', 'SYYYY-MM-DD HH24:MI:SS'), '人脸');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('292', '2', '指纹', '1', 'channel_bio_attest_type', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2019-11-01 10:01:38', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '指纹');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('293', '3', '虹膜', '2', 'channel_bio_attest_type', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2019-11-01 10:02:15', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '虹膜');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('294', '4', '指静脉', '3', 'channel_bio_attest_type', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2019-11-01 10:02:34', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '指静脉');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('295', '1', '接口', 'INTERFACE', 'channel_business_source', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2019-11-04 09:29:39', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('296', '2', '导入', 'IMP', 'channel_business_source', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2019-11-04 09:30:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '导入');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('297', '3', 'HTTP接口', 'HTTP', 'channel_business_source', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2019-11-04 09:30:33', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('298', '2', '修改人员信息', 'PERSON_INFO_UPDATE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-07 17:12:18', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--修改人员信息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('299', '3', '删除人员信息', 'PERSON_INFO_DELETE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-07 17:13:14', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--删除人员信息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('300', '4', '查询人员信息', 'PERSON_INFO_SELECT', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-07 17:13:44', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--查询人员信息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('301', '11', '右手不确定指位', '97', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-12 10:41:59', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '手指编码--右手不确定指位');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('302', '12', '左手不确定指位', '98', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-12 10:42:38', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '手指编码--左手不确定指位');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('303', '13', '其他不确定指位', '99', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-12 10:43:14', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '手指编码--其他不确定指位');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('305', '1', '证件照片', '0', 'cert_photo_type', NULL, NULL, 'Y', '0', 'admin', TO_DATE('2019-11-13 16:58:30', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件照片类型--证件照片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('306', '5', '开通人脸功能', 'PERSON_FACE_OPEN', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:48:21', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-14 17:48:39', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口--开通人脸');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('307', '6', '关闭人脸功能', 'PERSON_FACE_CLOSE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:49:12', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--关闭人脸');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('308', '7', '人脸识别(1:N)', 'PERSON_FACE_RECOG', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:50:11', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--人脸识别(1:N)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('309', '8', '人脸认证(1:1)', 'PERSON_FACE_VERIFY', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:50:43', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--人脸认证(1:1)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('310', '9', '开通指纹功能', 'PERSON_FINGER_OPEN', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:51:31', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--开通指纹');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('311', '10', '关闭指纹功能', 'PERSON_FINGER_CLOSE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:52:06', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--关闭指纹');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('312', '11', '指纹识别(1:N)', 'PERSON_FINGER_RECOG', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:52:56', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-14 17:53:07', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口--指纹识别(1:N)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('313', '12', '指纹认证(1:1)', 'PERSON_FINGER_VERIFY', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:54:03', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--指纹认证(1:1)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('314', '13', '开通虹膜功能', 'PERSON_IRIS_OPEN', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:54:46', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--开通虹膜');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('315', '14', '关闭虹膜功能', 'PERSON_IRIS_CLOSE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:55:28', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--关闭虹膜');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('316', '15', '虹膜识别(1:N)', 'PERSON_IRIS_RECOG', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:56:11', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--虹膜识别(1:N)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('317', '16', '虹膜认证(1:1)', 'PERSON_IRIS_VERIFY', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:56:40', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--虹膜认证(1:1)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('318', '17', '开通指静脉功能', 'PERSON_FVEIN_OPEN', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:57:25', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-14 17:58:03', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口--开通指静脉');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('319', '18', '关闭指静脉功能', 'PERSON_FVEIN_CLOSE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:57:47', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-14 17:58:00', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口--关闭指静脉');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('320', '19', '指静脉识别(1:N)', 'PERSON_FVEIN_RECOG', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:58:43', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--指静脉识别(1:N)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('321', '20', '指静脉认证(1:1)', 'PERSON_FVEIN_VERIFY', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:59:23', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--指静脉认证(1:1)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('322', '21', '短信推送功能', 'MESSAGE_SEND_SMS', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 17:59:56', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-14 18:00:03', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口--短信推送');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('323', '22', '微信服务号推送', 'MESSAGE_SEND_WECHAT', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 18:00:36', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--微信服务号推送');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('324', '23', '邮件推送功能', 'MESSAGE_SEND_EMAIL', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-11-14 18:01:05', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--邮件推送功能');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('325', '1', '通过', '0', 'bio_result', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2019-11-26 14:01:33', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-28 17:48:00', 'SYYYY-MM-DD HH24:MI:SS'), '生物认证识别结果--通过');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('326', '2', '未通过', '1', 'bio_result', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2019-11-26 14:02:07', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-26 14:03:53', 'SYYYY-MM-DD HH24:MI:SS'), '生物认证识别结果--未通过');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('327', '1', '基础信息入库1:N', '1', 'search_log_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2019-11-27 10:23:38', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-27 14:28:23', 'SYYYY-MM-DD HH24:MI:SS'), '生物特征1-N日志场景类型--基础信息入库1:N');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('328', '2', '比对搜索接口1:N', '2', 'search_log_type', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2019-11-27 10:24:37', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-27 14:28:30', 'SYYYY-MM-DD HH24:MI:SS'), '生物特征1-N日志场景类型--1:N比对搜索接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('329', '1', '与策略', '1', 'iris_match_result_strategy', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2019-11-28 10:32:05', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '虹膜1:1比对结果策略--与策略');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('330', '2', '或策略', '2', 'iris_match_result_strategy', NULL, 'success', 'N', '0', 'admin', TO_DATE('2019-11-28 10:32:40', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '虹膜1:1比对结果策略--或策略');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('331', '24', '人员数据实时更新', 'PERSON_LIVE_UPDATE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-12-05 16:43:53', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-10 17:24:01', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口--人员数据实时更新');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('332', '4', '依次校验', '4', 'search_n_type', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2019-12-10 13:37:54', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-12 16:48:51', 'SYYYY-MM-DD HH24:MI:SS'), '按照分库->渠道库->全库依次查询，查询到即返回');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('333', '3', '子系统日志回传', '3', 'search_log_type', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-12-10 14:10:38', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-10 14:11:23', 'SYYYY-MM-DD HH24:MI:SS'), '生物特征1-N日志场景类型--子系统日志回传');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('334', '25', '人脸识别日志回传', 'PERSON_FACE_SEARCH_LOG_BAK', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-12-10 17:23:49', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-13 16:05:07', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口--人脸识别日志回传');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('335', '26', '获取人脸特征', 'PERSON_FACE_FEATURE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-12-13 16:04:49', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--获取人脸特征');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('336', '27', '分库操作功能', 'PERSON_SUB_TREASURY_OPERATE', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-12-23 17:03:03', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--分库操作功能');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('337', '1', '全量', '0', 'app_version_type', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2019-12-27 12:10:43', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '前端设备APP版本类型--全量');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('338', '2', '增量', '1', 'app_version_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2019-12-27 12:11:02', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '前端设备APP版本类型--增量');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('340', '1', '待下载', '1', 'device_upgrade_status', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2019-12-30 13:47:49', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-30 13:51:22', 'SYYYY-MM-DD HH24:MI:SS'), '设备升级状态--待下载');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('341', '2', '待更新', '2', 'device_upgrade_status', NULL, 'primary', 'N', '0', 'admin', TO_DATE('2019-12-30 13:48:11', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-30 13:49:30', 'SYYYY-MM-DD HH24:MI:SS'), '设备升级状态--待更新');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('342', '3', '更新成功', '3', 'device_upgrade_status', NULL, 'success', 'N', '0', 'admin', TO_DATE('2019-12-30 13:49:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备升级状态--更新成功');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('343', '4', '更新失败', '4', 'device_upgrade_status', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2019-12-30 13:50:23', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备升级状态--更新失败');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('344', '5', '跳过', '5', 'device_upgrade_status', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2019-12-30 13:51:06', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备升级状态--跳过');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('345', '28', '设备版本更新信号接口', 'CLIENT_UPGRADE_SIGNAL', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-12-31 17:27:54', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--设备版本更新信号接口（是否需要更新）');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('346', '29', '设备版本下载接口', 'CLIENT_VERSION_DOWNLOAD', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-12-31 17:28:40', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-31 17:28:47', 'SYYYY-MM-DD HH24:MI:SS'), 'HTTP交易接口--设备版本下载接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('347', '30', '设备版本更新结果回写', 'CLIENT_UPGRADE_RESULT_BAK', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-12-31 17:30:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--设备版本更新结果回写');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('348', '1', '待执行', '1', 'device_upgrade_result', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2020-02-19 15:07:49', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-02-20 09:25:13', 'SYYYY-MM-DD HH24:MI:SS'), '设备升级任务结果--待执行');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('349', '2', '成功', '2', 'device_upgrade_result', NULL, 'success', 'Y', '0', 'admin', TO_DATE('2020-02-19 15:08:14', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备升级任务结果--成功');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('350', '3', '失败', '3', 'device_upgrade_result', NULL, 'danger', 'Y', '0', 'admin', TO_DATE('2020-02-19 15:08:33', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备升级任务结果--失败');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('351', '4', '跳过', '4', 'device_upgrade_result', NULL, 'warning', 'Y', '0', 'admin', TO_DATE('2020-02-19 15:08:51', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '设备升级任务结果--跳过');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('352', '1', '短信', '1', 'msg_notice_method', NULL, 'info', 'Y', '0', 'admin', TO_DATE('2020-03-17 15:22:36', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-17 15:24:09', 'SYYYY-MM-DD HH24:MI:SS'), '消息通知方式--短信');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('353', '2', '邮件', '2', 'msg_notice_method', NULL, 'success', 'N', '0', 'admin', TO_DATE('2020-03-17 15:23:14', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '消息通知方式--邮件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('354', '3', '微信', '3', 'msg_notice_method', NULL, 'primary', 'N', '0', 'admin', TO_DATE('2020-03-17 15:23:59', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-17 15:24:18', 'SYYYY-MM-DD HH24:MI:SS'), '消息通知方式--微信');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('355', '4', '钉钉', '4', 'msg_notice_method', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2020-03-17 15:24:38', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '消息通知方式--钉钉');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('356', '1', '普通发送', '1', 'msg_type', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2020-03-17 15:28:44', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-23 13:15:24', 'SYYYY-MM-DD HH24:MI:SS'), '消息类型--普通发送');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('357', '2', '模板发送', '2', 'msg_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2020-03-17 15:29:07', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-23 13:15:16', 'SYYYY-MM-DD HH24:MI:SS'), '消息类型--模板发送');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('358', '1', '成功', '0', 'msg_result', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2020-03-19 11:20:15', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-19 11:20:51', 'SYYYY-MM-DD HH24:MI:SS'), '消息推送结果--成功');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('359', '2', '失败', '1', 'msg_result', NULL, 'danger', 'N', '0', 'admin', TO_DATE('2020-03-19 11:20:41', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '消息推送结果--失败');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('360', '1', '文本邮件', '1', 'msg_mail_type', NULL, 'success', 'Y', '0', 'admin', TO_DATE('2020-03-23 10:37:45', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '邮件类型--文本邮件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('361', '2', 'HTML邮件', '2', 'msg_mail_type', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2020-03-23 10:38:13', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '邮件类型--HTML邮件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('362', '1', '文本消息', 'text', 'msg_dingtalk_type', NULL, 'primary', 'Y', '0', 'admin', TO_DATE('2020-04-01 09:32:49', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-01 09:32:55', 'SYYYY-MM-DD HH24:MI:SS'), '钉钉消息类型--文本消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('363', '2', 'Markdown消息', 'markdown', 'msg_dingtalk_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2020-04-01 09:33:25', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉消息类型--Markdown消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('364', '3', '链接消息', 'link', 'msg_dingtalk_type', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2020-04-01 09:34:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉消息类型--链接消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('365', '1', '图片文件', 'image', 'msg_dingtalk_media_type', NULL, 'success', 'Y', '0', 'admin', TO_DATE('2020-04-01 11:49:07', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-01 11:49:58', 'SYYYY-MM-DD HH24:MI:SS'), '钉钉媒体文件类型--图片文件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('366', '2', '语音文件', 'voice', 'msg_dingtalk_media_type', NULL, 'primary', 'N', '0', 'admin', TO_DATE('2020-04-01 11:49:46', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉媒体文件类型--语音文件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('367', '3', '普通文件', 'file', 'msg_dingtalk_media_type', NULL, 'warning', 'N', '0', 'admin', TO_DATE('2020-04-01 11:50:28', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉媒体文件类型--普通文件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('368', '4', '图片消息', 'image', 'msg_dingtalk_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2020-04-01 12:29:48', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉消息类型--图片消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('369', '5', '语音消息', 'voice', 'msg_dingtalk_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2020-04-01 12:30:22', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉消息类型--语音消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('370', '6', '普通文件消息', 'file', 'msg_dingtalk_type', NULL, 'success', 'N', '0', 'admin', TO_DATE('2020-04-01 12:30:55', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '钉钉消息类型--普通文件消息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('371', '31', '钉钉推送功能', 'MESSAGE_SEND_DING', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2020-04-01 19:38:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--钉钉推送功能');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('372', '32', '钉钉推送结果查询', 'MESSAGE_SEND_DING_RESULT', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2020-04-01 19:38:48', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--钉钉推送结果查询');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('373', '33', '钉钉媒体文件上传', 'MESSAGE_DING_MEDIA_UPLOAD', 'http_interface', NULL, NULL, 'N', '0', 'admin', TO_DATE('2020-04-01 19:39:27', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, 'HTTP交易接口--钉钉媒体文件上传');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('196', '14', '台湾居民来往大陆通行证', '511', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-台湾居民来往大陆通行');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('197', '15', '往来港澳通行证', '513', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-往来港澳通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('198', '16', '回乡证', '516', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-回乡证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('199', '17', '大陆居民往来台湾通行证', '517', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-大陆居民往来台湾通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('200', '18', '中朝边境地区出入境通行证', '733', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-中朝边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('201', '19', '中蒙边境地区出入境通行证', '736', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-中蒙边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('202', '20', '中缅边境地区出入境通行证', '738', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-中缅边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('203', '21', '云南省边境地区境外边民入出境证', '740', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-云南省边境地区境外边民入出境证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('204', '22', '中尼边境地区出入境通行证', '741', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-中尼边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('205', '23', '中越边境地区出入境通行证', '743', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-中越边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('206', '24', '中老边境地区出入境通行证', '745', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-中老边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('207', '25', '中印边境地区出入境通行证', '747', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-中印边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('208', '26', '其他', '990', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-其他');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('209', '27', '军人证', '991', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-军人证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('210', '28', '港澳台居住证', '992', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-港澳台居住证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('211', '29', '外国人居住证', '993', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-外国人居住证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('212', '30', '越南身份证', '994', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-越南身份证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('213', '31', '边民证', '995', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-边民证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('214', '32', '无证件', '999', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', TO_DATE('2019-08-01 10:11:50', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '证件类型-无证件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('215', '2', '入学照片', '1', 'cert_photo_type', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-24 14:53:44', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-13 16:58:37', 'SYYYY-MM-DD HH24:MI:SS'), '证件照片类型-入学照片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('216', '3', '在校照片', '2', 'cert_photo_type', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-24 14:54:10', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-13 16:58:42', 'SYYYY-MM-DD HH24:MI:SS'), '证件照片类型-在校照片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('217', '4', '毕业照片', '3', 'cert_photo_type', NULL, NULL, 'N', '0', 'admin', TO_DATE('2019-10-24 14:54:37', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-13 16:58:46', 'SYYYY-MM-DD HH24:MI:SS'), '证件照片类型-毕业照片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('218', '1', '汉族', '01', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('219', '2', '蒙古族', '02', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('220', '3', '回族', '03', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('221', '4', '藏族', '04', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('222', '5', '维吾尔族', '05', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('223', '6', '苗族', '06', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('224', '7', '彝族', '07', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('225', '8', '壮族', '08', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('226', '9', '布依族', '09', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('227', '10', '朝鲜族', '10', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('228', '11', '满族', '11', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('229', '12', '侗族', '12', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('230', '13', '瑶族', '13', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('231', '14', '白族', '14', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('232', '15', '土家族', '15', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('233', '16', '哈尼族', '16', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('234', '17', '哈萨克族', '17', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('235', '18', '傣族', '18', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('236', '19', '黎族', '19', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('237', '20', '傈僳族', '20', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('238', '21', '佤族', '21', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('239', '22', '畲族', '22', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('240', '23', '高山族', '23', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('241', '24', '拉祜族', '24', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('242', '25', '水族', '25', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('243', '26', '东乡族', '26', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('244', '27', '纳西族', '27', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('245', '28', '景颇族', '28', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('246', '29', '柯尔克孜族', '29', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('247', '30', '土族', '30', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('248', '31', '达斡尔族', '31', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('249', '32', '仫佬族', '32', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('250', '33', '羌族', '33', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('251', '34', '布朗族', '34', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('252', '35', '撒拉族', '35', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('253', '36', '毛南族', '36', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('254', '37', '仡佬族', '37', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('255', '38', '锡伯族', '38', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('256', '39', '阿昌族', '39', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('257', '40', '普米族', '40', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('258', '41', '塔吉克族', '41', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('259', '42', '怒族', '42', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('260', '43', '乌孜别克族', '43', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('261', '44', '俄罗斯族', '44', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES ('262', '45', '鄂温克族', '45', 'sys_nation', NULL, 'info', 'N', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '民族');





INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1', '系统管理', '0', '1', '#', NULL, 'M', '0', NULL, 'fa fa-gear', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '系统管理目录');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('2', '系统监控', '0', '2', '#', NULL, 'M', '0', NULL, 'fa fa-video-camera', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '系统监控目录');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3', '系统工具', '0', '3', '#', NULL, 'M', '0', NULL, 'fa fa-bars', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '系统工具目录');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('5', '基础数据', '0', '5', '#', NULL, 'M', '0', NULL, 'fa fa-database', 'admin', TO_DATE('2019-10-16 16:51:24', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('6', '场景接入', '0', '6', '#', NULL, 'M', '0', NULL, 'fa fa-database', 'admin', TO_DATE('2019-10-16 16:51:24', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '场景接入目录');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('100', '用户管理', '1', '1', '/system/user', NULL, 'C', '0', 'system:user:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '用户管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('101', '角色管理', '1', '2', '/system/role', NULL, 'C', '0', 'system:role:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '角色管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('102', '菜单管理', '1', '3', '/system/menu', NULL, 'C', '0', 'system:menu:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '菜单管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('103', '部门管理', '1', '4', '/system/dept', NULL, 'C', '0', 'system:dept:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '部门管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('104', '岗位管理', '1', '5', '/system/post', NULL, 'C', '0', 'system:post:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '岗位管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('105', '字典管理', '1', '6', '/system/dict', NULL, 'C', '0', 'system:dict:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '字典管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('106', '参数设置', '1', '7', '/system/config', NULL, 'C', '0', 'system:config:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '参数设置菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('107', '通知公告', '1', '8', '/system/notice', NULL, 'C', '0', 'system:notice:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '通知公告菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('108', '日志管理', '1', '9', '#', NULL, 'M', '0', NULL, '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '日志管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('109', '在线用户', '2', '1', '/monitor/online', NULL, 'C', '0', 'monitor:online:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '在线用户菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('110', '定时任务', '2', '2', '/monitor/job', NULL, 'C', '0', 'monitor:job:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '定时任务菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('111', '数据监控', '2', '3', '/monitor/data', NULL, 'C', '0', 'monitor:data:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '数据监控菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('112', '服务监控', '2', '3', '/monitor/server', NULL, 'C', '0', 'monitor:server:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '服务监控菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('113', '表单构建', '3', '1', '/tool/build', NULL, 'C', '0', 'tool:build:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '表单构建菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('114', '代码生成', '3', '2', '/tool/gen', NULL, 'C', '0', 'tool:gen:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '代码生成菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('115', '系统接口', '3', '3', '/tool/swagger', 'menuItem', 'C', '1', 'tool:swagger:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-01-07 13:12:47', 'SYYYY-MM-DD HH24:MI:SS'), '系统接口菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('500', '操作日志', '108', '1', '/monitor/operlog', NULL, 'C', '0', 'monitor:operlog:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '操作日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('501', '登录日志', '108', '2', '/monitor/logininfor', NULL, 'C', '0', 'monitor:logininfor:view', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '登录日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1000', '用户查询', '100', '1', '#', NULL, 'F', '0', 'system:user:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1001', '用户新增', '100', '2', '#', NULL, 'F', '0', 'system:user:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1002', '用户修改', '100', '3', '#', NULL, 'F', '0', 'system:user:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1003', '用户删除', '100', '4', '#', NULL, 'F', '0', 'system:user:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1004', '用户导出', '100', '5', '#', NULL, 'F', '0', 'system:user:export', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1005', '用户导入', '100', '6', '#', NULL, 'F', '0', 'system:user:import', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1006', '重置密码', '100', '7', '#', NULL, 'F', '0', 'system:user:resetPwd', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1007', '角色查询', '101', '1', '#', NULL, 'F', '0', 'system:role:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1008', '角色新增', '101', '2', '#', NULL, 'F', '0', 'system:role:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1009', '角色修改', '101', '3', '#', NULL, 'F', '0', 'system:role:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1010', '角色删除', '101', '4', '#', NULL, 'F', '0', 'system:role:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1011', '角色导出', '101', '5', '#', NULL, 'F', '0', 'system:role:export', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1012', '菜单查询', '102', '1', '#', NULL, 'F', '0', 'system:menu:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1013', '菜单新增', '102', '2', '#', NULL, 'F', '0', 'system:menu:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1014', '菜单修改', '102', '3', '#', NULL, 'F', '0', 'system:menu:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1015', '菜单删除', '102', '4', '#', NULL, 'F', '0', 'system:menu:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1016', '部门查询', '103', '1', '#', NULL, 'F', '0', 'system:dept:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1017', '部门新增', '103', '2', '#', NULL, 'F', '0', 'system:dept:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1018', '部门修改', '103', '3', '#', NULL, 'F', '0', 'system:dept:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1019', '部门删除', '103', '4', '#', NULL, 'F', '0', 'system:dept:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1020', '岗位查询', '104', '1', '#', NULL, 'F', '0', 'system:post:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1021', '岗位新增', '104', '2', '#', NULL, 'F', '0', 'system:post:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1022', '岗位修改', '104', '3', '#', NULL, 'F', '0', 'system:post:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1023', '岗位删除', '104', '4', '#', NULL, 'F', '0', 'system:post:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1024', '岗位导出', '104', '5', '#', NULL, 'F', '0', 'system:post:export', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1025', '字典查询', '105', '1', '#', NULL, 'F', '0', 'system:dict:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1026', '字典新增', '105', '2', '#', NULL, 'F', '0', 'system:dict:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1027', '字典修改', '105', '3', '#', NULL, 'F', '0', 'system:dict:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1028', '字典删除', '105', '4', '#', NULL, 'F', '0', 'system:dict:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1029', '字典导出', '105', '5', '#', NULL, 'F', '0', 'system:dict:export', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1030', '参数查询', '106', '1', '#', NULL, 'F', '0', 'system:config:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1031', '参数新增', '106', '2', '#', NULL, 'F', '0', 'system:config:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1032', '参数修改', '106', '3', '#', NULL, 'F', '0', 'system:config:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1033', '参数删除', '106', '4', '#', NULL, 'F', '0', 'system:config:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1034', '参数导出', '106', '5', '#', NULL, 'F', '0', 'system:config:export', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1035', '公告查询', '107', '1', '#', NULL, 'F', '0', 'system:notice:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1036', '公告新增', '107', '2', '#', NULL, 'F', '0', 'system:notice:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1037', '公告修改', '107', '3', '#', NULL, 'F', '0', 'system:notice:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1038', '公告删除', '107', '4', '#', NULL, 'F', '0', 'system:notice:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1039', '操作查询', '500', '1', '#', NULL, 'F', '0', 'monitor:operlog:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1040', '操作删除', '500', '2', '#', NULL, 'F', '0', 'monitor:operlog:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3086', '证件详细', '3078', '8', '#', 'menuItem', 'F', '0', 'basedata:cert:detail', '#', 'admin', TO_DATE('2019-10-24 14:57:25', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3087', '报文信息', '108', '3', '/system/record', NULL, 'C', '0', 'system:record:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '基础数据_接口请求报文信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3088', '报文查询', '3087', '1', '#', 'menuItem', 'F', '0', 'system:record:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-07 17:29:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3089', '报文新增', '3087', '2', '#', 'menuItem', 'F', '0', 'system:record:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-07 17:29:27', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3090', '报文修改', '3087', '3', '#', 'menuItem', 'F', '0', 'system:record:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-07 17:29:43', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3091', '报文删除', '3087', '4', '#', 'menuItem', 'F', '0', 'system:record:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-07 17:29:56', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3092', '报文导出', '3087', '5', '#', 'menuItem', 'F', '0', 'system:record:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-07 17:30:09', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3099', '图片下载', '3028', '7', '#', 'menuItem', 'F', '0', 'basedata:personInfo:download', '#', 'admin', TO_DATE('2019-10-25 13:25:10', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-25 23:41:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3100', '人员详细', '3028', '6', '#', 'menuItem', 'F', '0', 'basedata:personInfo:detail', '#', 'admin', TO_DATE('2019-10-25 23:40:48', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3101', '人员导入', '3028', '8', '#', 'menuItem', 'F', '0', 'basedata:personInfo:import', '#', 'admin', TO_DATE('2019-10-28 09:12:03', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3102', '自助采集', '5', '6', '/basedata/face/collect', 'menuItem', 'C', '0', 'basedata:face:collect', '#', 'admin', TO_DATE('2019-10-29 12:04:43', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3103', '自助采集保存', '3102', '1', '#', 'menuItem', 'F', '0', 'basedata:face:collect:save', '#', 'admin', TO_DATE('2019-10-29 12:16:31', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3104', '系统维护', '3177', '1', '/basedata/app', 'menuItem', 'C', '0', 'basedata:app:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-29 12:05:31', 'SYYYY-MM-DD HH24:MI:SS'), '应用系统菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3105', '应用系统查询', '3104', '1', '#', NULL, 'F', '0', 'basedata:app:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3106', '应用系统新增', '3104', '2', '#', NULL, 'F', '0', 'basedata:app:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3107', '应用系统修改', '3104', '3', '#', NULL, 'F', '0', 'basedata:app:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3108', '应用系统删除', '3104', '4', '#', NULL, 'F', '0', 'basedata:app:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3109', '应用系统导出', '3104', '5', '#', NULL, 'F', '0', 'basedata:app:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3111', '接口授权', '3177', '2', '/basedata/app/auth', 'menuItem', 'C', '0', 'basedata:appauth:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-29 11:54:28', 'SYYYY-MM-DD HH24:MI:SS'), '应用系统接口授权菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3112', '接口授权查询', '3111', '1', '#', NULL, 'F', '0', 'basedata:appauth:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3113', '接口授权新增', '3111', '2', '#', NULL, 'F', '0', 'basedata:appauth:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3114', '接口授权修改', '3111', '3', '#', NULL, 'F', '0', 'basedata:appauth:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3115', '接口授权删除', '3111', '4', '#', NULL, 'F', '0', 'basedata:appauth:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3116', '接口授权导出', '3111', '5', '#', NULL, 'F', '0', 'basedata:appauth:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3117', '渠道参数', '6', '3', '/scene/param', 'menuItem', 'C', '0', 'scene:param:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-05 14:18:31', 'SYYYY-MM-DD HH24:MI:SS'), '渠道管理_渠道参数菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3118', '渠道管理_渠道参数查询', '3117', '1', '#', NULL, 'F', '0', 'scene:param:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3119', '渠道管理_渠道参数新增', '3117', '2', '#', NULL, 'F', '0', 'scene:param:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3120', '渠道管理_渠道参数修改', '3117', '3', '#', NULL, 'F', '0', 'scene:param:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3121', '渠道管理_渠道参数删除', '3117', '4', '#', NULL, 'F', '0', 'scene:param:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3122', '渠道管理_渠道参数导出', '3117', '5', '#', NULL, 'F', '0', 'scene:param:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3123', '渠道信息', '6', '1', '/scene/info', 'menuItem', 'C', '0', 'scene:info:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-05 14:17:47', 'SYYYY-MM-DD HH24:MI:SS'), '渠道管理_渠道信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3124', '渠道管理_渠道信息查询', '3123', '1', '#', NULL, 'F', '0', 'scene:info:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3125', '渠道管理_渠道信息新增', '3123', '2', '#', NULL, 'F', '0', 'scene:info:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3126', '渠道管理_渠道信息修改', '3123', '3', '#', NULL, 'F', '0', 'scene:info:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3127', '渠道管理_渠道信息删除', '3123', '4', '#', NULL, 'F', '0', 'scene:info:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3128', '渠道管理_渠道信息导出', '3123', '5', '#', NULL, 'F', '0', 'scene:info:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3135', '渠道业务', '6', '2', '/scene/business', 'menuItem', 'C', '0', 'scene:business:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-05 14:18:25', 'SYYYY-MM-DD HH24:MI:SS'), '渠道管理_渠道业务菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3136', '渠道管理_渠道业务查询', '3135', '1', '#', NULL, 'F', '0', 'scene:business:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3137', '渠道管理_渠道业务新增', '3135', '2', '#', NULL, 'F', '0', 'scene:business:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3138', '渠道管理_渠道业务修改', '3135', '3', '#', NULL, 'F', '0', 'scene:business:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3139', '渠道管理_渠道业务删除', '3135', '4', '#', NULL, 'F', '0', 'scene:business:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3140', '渠道管理_渠道业务导出', '3135', '5', '#', NULL, 'F', '0', 'scene:business:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3141', '报文详细', '3087', '6', '#', 'menuItem', 'F', '0', 'system:record:detail', '#', 'admin', TO_DATE('2019-11-07 17:30:56', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3142', '一键更新', '3057', '7', '#', 'menuItem', 'F', '0', 'basedata:face:updatefeature', '#', 'admin', TO_DATE('2019-11-22 15:12:58', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3143', '一键更新', '3064', '7', '#', 'menuItem', 'F', '0', 'basedata:finger:updatefeature', '#', 'admin', TO_DATE('2019-11-22 15:13:26', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3144', '一键更新', '3071', '7', '#', 'menuItem', 'F', '0', 'basedata:iris:updatefeature', '#', 'admin', TO_DATE('2019-11-22 15:13:52', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3145', '人脸比对日志', '3149', '1', '/log/faceMatch', 'menuItem', 'C', '0', 'log:faceMatch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-26 11:57:29', 'SYYYY-MM-DD HH24:MI:SS'), '人脸比对日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3146', '人脸比对日志查询', '3145', '1', '#', NULL, 'F', '0', 'log:faceMatch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3147', '人脸比对日志删除', '3145', '2', '#', NULL, 'F', '0', 'log:faceMatch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3148', '人脸比对日志导出', '3145', '3', '#', NULL, 'F', '0', 'log:faceMatch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3149', '业务日志', '6', '5', '#', 'menuItem', 'M', '0', NULL, '#', 'admin', TO_DATE('2019-11-26 11:57:09', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-19 12:01:53', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3151', '指纹比对日志', '3149', '3', '/log/fingerMatch', 'menuItem', 'C', '0', 'log:fingerMatch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-27 10:20:15', 'SYYYY-MM-DD HH24:MI:SS'), '人员指纹比对日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3152', '指纹比对日志查询', '3151', '1', '#', NULL, 'F', '0', 'log:fingerMatch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3153', '指纹比对日志删除', '3151', '2', '#', NULL, 'F', '0', 'log:fingerMatch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3154', '指纹比对日志导出', '3151', '3', '#', NULL, 'F', '0', 'log:fingerMatch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3155', '人脸比对日志详细', '3145', '4', '#', 'menuItem', 'F', '0', 'log:faceMatch:detail', '#', 'admin', TO_DATE('2019-11-26 14:53:31', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3214', '版本信息删除', '3210', '4', '#', NULL, 'F', '0', 'client:version:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3215', '版本信息导出', '3210', '5', '#', NULL, 'F', '0', 'client:version:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3216', '设备管理', '0', '8', '#', 'menuItem', 'M', '0', NULL, 'fa fa-gears', 'admin', TO_DATE('2019-12-27 11:37:32', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-27 11:38:58', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3217', '设备信息', '3216', '1', '/client/device', 'menuItem', 'C', '0', 'client:device:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-27 15:59:57', 'SYYYY-MM-DD HH24:MI:SS'), '设备信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3218', '设备信息查询', '3217', '1', '#', NULL, 'F', '0', 'client:device:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3219', '设备信息新增', '3217', '2', '#', NULL, 'F', '0', 'client:device:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3220', '设备信息修改', '3217', '3', '#', NULL, 'F', '0', 'client:device:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3221', '设备信息删除', '3217', '4', '#', NULL, 'F', '0', 'client:device:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3222', '设备信息导出', '3217', '5', '#', NULL, 'F', '0', 'client:device:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3223', '升级任务', '3216', '1', '/client/upgradeInfo', 'menuItem', 'C', '0', 'client:upgradeInfo:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-27 17:05:26', 'SYYYY-MM-DD HH24:MI:SS'), '升级任务菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3224', '升级任务查询', '3223', '1', '#', NULL, 'F', '0', 'client:upgradeInfo:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3225', '升级任务新增', '3223', '2', '#', NULL, 'F', '0', 'client:upgradeInfo:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3226', '升级任务修改', '3223', '3', '#', NULL, 'F', '0', 'client:upgradeInfo:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3227', '升级任务删除', '3223', '4', '#', NULL, 'F', '0', 'client:upgradeInfo:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3228', '升级任务导出', '3223', '5', '#', NULL, 'F', '0', 'client:upgradeInfo:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3229', '升级日志', '3216', '1', '/client/upgradeLog', 'menuItem', 'C', '0', 'client:upgradeLog:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-30 13:37:48', 'SYYYY-MM-DD HH24:MI:SS'), '升级日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3230', '升级日志查询', '3229', '1', '#', NULL, 'F', '0', 'client:upgradeLog:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3231', '升级日志删除', '3229', '2', '#', NULL, 'F', '0', 'client:upgradeLog:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3232', '升级日志导出', '3229', '3', '#', NULL, 'F', '0', 'client:upgradeLog:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3233', '生成请求唯一码', '3199', '2', '#', 'menuItem', 'F', '0', 'tools:interface:getNonce', '#', 'admin', TO_DATE('2020-01-02 17:31:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3234', '历史日志', '6', '6', '#', 'menuItem', 'M', '0', NULL, '#', 'admin', TO_DATE('2020-01-06 15:27:56', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3239', '人脸比对历史日志', '3234', '1', '/hislog/faceMatch', NULL, 'C', '0', 'hislog:faceMatch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '人脸比对历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3240', '人脸比对历史日志查询', '3239', '1', '#', NULL, 'F', '0', 'hislog:faceMatch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3241', '人脸比对历史日志删除', '3239', '2', '#', NULL, 'F', '0', 'hislog:faceMatch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3242', '人脸比对历史日志导出', '3239', '3', '#', NULL, 'F', '0', 'hislog:faceMatch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3243', '人脸比对历史日志详细', '3239', '4', '#', 'menuItem', 'F', '0', 'hislog:faceMatch:detail', '#', 'admin', TO_DATE('2020-01-06 15:40:16', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3244', '指纹搜索历史日志', '3234', '4', '/hislog/fingerSearch', 'menuItem', 'C', '0', 'hislog:fingerSearch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-01-06 16:33:29', 'SYYYY-MM-DD HH24:MI:SS'), '指纹搜索历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3245', '指纹搜索历史日志查询', '3244', '1', '#', NULL, 'F', '0', 'hislog:fingerSearch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3246', '指纹搜索历史日志删除', '3244', '2', '#', NULL, 'F', '0', 'hislog:fingerSearch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3247', '指纹搜索历史日志导出', '3244', '3', '#', NULL, 'F', '0', 'hislog:fingerSearch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3248', '指纹搜索历史日志修改', '3244', '4', '#', NULL, 'F', '0', 'hislog:fingerSearch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3249', '人脸搜索历史日志', '3234', '2', '/hislog/faceSearch', NULL, 'C', '0', 'hislog:faceSearch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '人脸搜索历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3250', '人脸搜索历史日志查询', '3249', '1', '#', NULL, 'F', '0', 'hislog:faceSearch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3251', '人脸搜索历史日志删除', '3249', '2', '#', NULL, 'F', '0', 'hislog:faceSearch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3252', '人脸搜索历史日志导出', '3249', '3', '#', NULL, 'F', '0', 'hislog:faceSearch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3253', '人脸搜索历史日志详细', '3249', '4', '#', NULL, 'F', '0', 'hislog:faceSearch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3254', '指纹比对历史日志', '3234', '3', '/hislog/fingerMatch', NULL, 'C', '0', 'hislog:fingerMatch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '指纹比对历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3255', '指纹比对历史日志查询', '3254', '1', '#', NULL, 'F', '0', 'hislog:fingerMatch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3256', '指纹比对历史日志删除', '3254', '2', '#', NULL, 'F', '0', 'hislog:fingerMatch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3257', '指纹比对历史日志导出', '3254', '3', '#', NULL, 'F', '0', 'hislog:fingerMatch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3258', '指纹比对历史日志详细', '3254', '4', '#', NULL, 'F', '0', 'hislog:fingerMatch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3259', '虹膜比对历史日志', '3234', '5', '/hislog/irisMatch', NULL, 'C', '0', 'hislog:irisMatch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜比对历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3260', '虹膜比对历史日志查询', '3259', '1', '#', NULL, 'F', '0', 'hislog:irisMatch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3261', '虹膜比对历史日志删除', '3259', '2', '#', NULL, 'F', '0', 'hislog:irisMatch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3262', '虹膜比对历史日志导出', '3259', '3', '#', NULL, 'F', '0', 'hislog:irisMatch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3263', '虹膜比对历史日志详细', '3259', '4', '#', NULL, 'F', '0', 'hislog:irisMatch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3264', '虹膜搜索历史日志', '3234', '6', '/hislog/irisSearch', NULL, 'C', '0', 'hislog:irisSearch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜搜索历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3265', '虹膜搜索历史日志查询', '3264', '1', '#', NULL, 'F', '0', 'hislog:irisSearch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3266', '虹膜搜索历史日志删除', '3264', '2', '#', NULL, 'F', '0', 'hislog:irisSearch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3267', '虹膜搜索历史日志导出', '3264', '3', '#', NULL, 'F', '0', 'hislog:irisSearch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3268', '虹膜搜索历史日志详细', '3264', '4', '#', NULL, 'F', '0', 'hislog:irisSearch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3269', '陌生人人脸', '5', '8', '/basedata/stranger', 'menuItem', 'C', '0', 'basedata:stranger:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-01-17 10:06:04', 'SYYYY-MM-DD HH24:MI:SS'), '陌生人人脸菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3156', '指纹比对日志详细', '3151', '4', '#', 'menuItem', 'F', '0', 'log:fingerMatch:detail', '#', 'admin', TO_DATE('2019-11-26 14:53:58', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3157', '人脸搜索日志', '3149', '2', '/log/faceSearch', 'menuItem', 'C', '0', 'log:faceSearch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-27 10:20:26', 'SYYYY-MM-DD HH24:MI:SS'), '人脸搜索日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3158', '人脸搜索日志查询', '3157', '1', '#', NULL, 'F', '0', 'log:faceSearch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3159', '人脸搜索日志删除', '3157', '2', '#', NULL, 'F', '0', 'log:faceSearch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3160', '人脸搜索日志导出', '3157', '3', '#', NULL, 'F', '0', 'log:faceSearch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3161', '人脸搜索日志详细', '3157', '4', '#', NULL, 'F', '0', 'log:faceSearch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3162', '指纹搜索日志', '3149', '4', '/log/fingerSearch', 'menuItem', 'C', '0', 'log:fingerSearch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-27 14:25:18', 'SYYYY-MM-DD HH24:MI:SS'), '指纹搜索日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3163', '指纹搜索日志查询', '3162', '1', '#', NULL, 'F', '0', 'log:fingerSearch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3164', '指纹搜索日志删除', '3162', '2', '#', NULL, 'F', '0', 'log:fingerSearch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3165', '指纹搜索日志导出', '3162', '3', '#', NULL, 'F', '0', 'log:fingerSearch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3166', '指纹搜索日志详细', '3162', '4', '#', NULL, 'F', '0', 'log:fingerSearch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3167', '虹膜比对日志', '3149', '5', '/log/irisMatch', 'menuItem', 'C', '0', 'log:irisMatch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-28 10:13:39', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜比对日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3168', '虹膜比对日志查询', '3167', '1', '#', NULL, 'F', '0', 'log:irisMatch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3169', '虹膜比对日志删除', '3167', '2', '#', NULL, 'F', '0', 'log:irisMatch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3170', '虹膜比对日志导出', '3167', '3', '#', NULL, 'F', '0', 'log:irisMatch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3171', '虹膜比对日志详细', '3167', '4', '#', NULL, 'F', '0', 'log:irisMatch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3172', '虹膜搜索日志', '3149', '6', '/log/irisSearch', NULL, 'C', '0', 'log:irisSearch:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜搜索日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3173', '虹膜搜索日志查询', '3172', '1', '#', NULL, 'F', '0', 'log:irisSearch:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3174', '虹膜搜索日志删除', '3172', '2', '#', NULL, 'F', '0', 'log:irisSearch:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3175', '虹膜搜索日志导出', '3172', '3', '#', NULL, 'F', '0', 'log:irisSearch:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3176', '虹膜搜索日志详细', '3172', '4', '#', NULL, 'F', '0', 'log:irisSearch:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3177', '应用系统', '0', '7', '#', NULL, 'M', '0', NULL, 'fa fa-sitemap', 'admin', TO_DATE('2019-11-29 11:53:17', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-11-29 11:53:41', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3178', '比对操作', '6', '7', '#', 'menuItem', 'M', '0', NULL, '#', 'admin', TO_DATE('2019-11-29 13:19:07', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-01-06 15:28:15', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3179', '人脸1:1比对', '3178', '1', '/match/face/matchOne', 'menuItem', 'C', '0', 'match:faceMatchOne:view', '#', 'admin', TO_DATE('2019-11-29 13:20:25', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:11:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3180', '人脸1:N比对', '3178', '2', '/match/face/matchN', 'menuItem', 'C', '0', 'match:faceMatchN:view', '#', 'admin', TO_DATE('2019-11-29 13:21:23', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:11:14', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3181', '人脸图片比对', '3178', '3', '/match/face/compareTwo', 'menuItem', 'C', '0', 'match:faceCompareTwo:view', '#', 'admin', TO_DATE('2019-11-29 13:22:13', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:11:31', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3182', '指纹1:1比对', '3178', '4', '/match/finger/matchOne', 'menuItem', 'C', '0', 'match:fingerMatchOne:view', '#', 'admin', TO_DATE('2019-11-29 13:20:25', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:11:45', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3183', '指纹1:N比对', '3178', '5', '/match/finger/matchN', 'menuItem', 'C', '0', 'match:fingerMatchN:view', '#', 'admin', TO_DATE('2019-11-29 13:21:23', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:11:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3184', '指纹图片比对', '3178', '6', '/match/finger/compareTwo', 'menuItem', 'C', '0', 'match:fingerCompareTwo:view', '#', 'admin', TO_DATE('2019-11-29 13:22:13', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:12:15', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3185', '虹膜1:1比对', '3178', '7', '/match/iris/matchOne', 'menuItem', 'C', '0', 'match:irisMatchOne:view', '#', 'admin', TO_DATE('2019-11-29 13:20:25', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:12:28', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3186', '虹膜1:N比对', '3178', '8', '/match/iris/matchN', 'menuItem', 'C', '0', 'match:irisMatchN:view', '#', 'admin', TO_DATE('2019-11-29 13:21:23', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:12:40', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3187', '虹膜图片比对', '3178', '9', '/match/iris/compareTwo', 'menuItem', 'C', '0', 'match:irisCompareTwo:view', '#', 'admin', TO_DATE('2019-11-29 13:22:13', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:12:53', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3188', '人脸特征提取', '3178', '10', '/match/face/personFeature', 'menuItem', 'C', '0', 'match:personFeature:view', '#', 'admin', TO_DATE('2019-11-29 13:20:25', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-02 10:11:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3197', 'SQL查询', '3', '4', '/tools/sqlExecutor/select', 'menuItem', 'C', '0', 'tools:sqlExecutor:view', '#', 'admin', TO_DATE('2019-12-17 14:14:39', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3198', '接口测试', '3', '5', '/tools/interface/httpTest', 'menuItem', 'C', '0', 'tools:interface:view', '#', 'admin', TO_DATE('2019-12-17 14:35:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3199', '生成签名', '3', '6', '/tools/interface/generateSign', 'menuItem', 'C', '0', 'tools:interface:viewSign', '#', 'admin', TO_DATE('2019-12-18 15:47:41', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-18 16:20:37', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3200', '接口调用', '3198', '1', '#', 'menuItem', 'F', '0', 'tools:interface:call', '#', 'admin', TO_DATE('2019-12-18 16:20:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3201', '生成签名', '3199', '1', '#', 'menuItem', 'F', '0', 'tools:interface:generateSign', '#', 'admin', TO_DATE('2019-12-18 16:21:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3202', '分库业务', '6', '4', '/scene/subtreasury', 'menuItem', 'C', '0', 'scene:subtreasury:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-19 12:01:41', 'SYYYY-MM-DD HH24:MI:SS'), '分库业务菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3203', '分库业务查询', '3202', '1', '#', NULL, 'F', '0', 'scene:subtreasury:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3204', '分库业务新增', '3202', '2', '#', NULL, 'F', '0', 'scene:subtreasury:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3205', '分库业务修改', '3202', '3', '#', NULL, 'F', '0', 'scene:subtreasury:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3206', '分库业务删除', '3202', '4', '#', NULL, 'F', '0', 'scene:subtreasury:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3207', '分库业务导出', '3202', '5', '#', NULL, 'F', '0', 'scene:subtreasury:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3208', '自助签约', '6', '8', '/scene/busi/selfopen/face?channelCode=eyecool', 'menuItem', 'C', '1', NULL, '#', 'admin', TO_DATE('2019-12-26 11:10:59', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-01-06 15:28:26', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3209', '保存自助签约', '3208', '1', '#', 'menuItem', 'F', '0', 'scene:busi:selfopen:save', '#', 'admin', TO_DATE('2019-12-26 11:36:11', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-26 11:41:36', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3210', '版本信息', '3216', '1', '/client/version', 'menuItem', 'C', '0', 'client:version:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-27 11:39:47', 'SYYYY-MM-DD HH24:MI:SS'), '版本信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3211', '版本信息查询', '3210', '1', '#', NULL, 'F', '0', 'client:version:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3212', '版本信息新增', '3210', '2', '#', NULL, 'F', '0', 'client:version:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3213', '版本信息修改', '3210', '3', '#', NULL, 'F', '0', 'client:version:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1041', '详细信息', '500', '3', '#', NULL, 'F', '0', 'monitor:operlog:detail', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1042', '日志导出', '500', '4', '#', NULL, 'F', '0', 'monitor:operlog:export', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1043', '登录查询', '501', '1', '#', NULL, 'F', '0', 'monitor:logininfor:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1044', '登录删除', '501', '2', '#', NULL, 'F', '0', 'monitor:logininfor:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1045', '日志导出', '501', '3', '#', NULL, 'F', '0', 'monitor:logininfor:export', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1046', '账户解锁', '501', '4', '#', NULL, 'F', '0', 'monitor:logininfor:unlock', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1047', '在线查询', '109', '1', '#', NULL, 'F', '0', 'monitor:online:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1048', '批量强退', '109', '2', '#', NULL, 'F', '0', 'monitor:online:batchForceLogout', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1049', '单条强退', '109', '3', '#', NULL, 'F', '0', 'monitor:online:forceLogout', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1050', '任务查询', '110', '1', '#', NULL, 'F', '0', 'monitor:job:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1051', '任务新增', '110', '2', '#', NULL, 'F', '0', 'monitor:job:add', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1052', '任务修改', '110', '3', '#', NULL, 'F', '0', 'monitor:job:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1053', '任务删除', '110', '4', '#', NULL, 'F', '0', 'monitor:job:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1054', '状态修改', '110', '5', '#', NULL, 'F', '0', 'monitor:job:changeStatus', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1055', '任务详细', '110', '6', '#', NULL, 'F', '0', 'monitor:job:detail', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1056', '任务导出', '110', '7', '#', NULL, 'F', '0', 'monitor:job:export', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1057', '生成查询', '114', '1', '#', NULL, 'F', '0', 'tool:gen:list', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1058', '生成修改', '114', '2', '#', NULL, 'F', '0', 'tool:gen:edit', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1059', '生成删除', '114', '3', '#', NULL, 'F', '0', 'tool:gen:remove', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1060', '预览代码', '114', '4', '#', NULL, 'F', '0', 'tool:gen:preview', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('1061', '生成代码', '114', '5', '#', NULL, 'F', '0', 'tool:gen:code', '#', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3021', '二维码管理', '5', '7', '/basedata/qrcode', 'menuItem', 'C', '0', 'basedata:qrcode:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-29 12:05:03', 'SYYYY-MM-DD HH24:MI:SS'), '二维码管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3022', '二维码查询', '3021', '1', '#', NULL, 'F', '0', 'basedata:qrcode:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3023', '二维码新增', '3021', '2', '#', NULL, 'F', '0', 'basedata:qrcode:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3024', '二维码修改', '3021', '3', '#', NULL, 'F', '0', 'basedata:qrcode:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3025', '二维码删除', '3021', '4', '#', NULL, 'F', '0', 'basedata:qrcode:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3026', '二维码导出', '3021', '5', '#', NULL, 'F', '0', 'basedata:qrcode:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3028', '人员管理', '5', '1', '/basedata/personInfo', NULL, 'C', '0', 'basedata:personInfo:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '人员管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3029', '人员查询', '3028', '1', '#', NULL, 'F', '0', 'basedata:personInfo:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3030', '人员新增', '3028', '2', '#', NULL, 'F', '0', 'basedata:personInfo:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3031', '人员修改', '3028', '3', '#', NULL, 'F', '0', 'basedata:personInfo:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3032', '人员删除', '3028', '4', '#', NULL, 'F', '0', 'basedata:personInfo:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3033', '人员导出', '3028', '5', '#', NULL, 'F', '0', 'basedata:personInfo:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3057', '人脸管理', '5', '2', '/basedata/face', NULL, 'C', '0', 'basedata:face:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '人脸菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3058', '人脸查询', '3057', '1', '#', NULL, 'F', '0', 'basedata:face:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3059', '人脸新增', '3057', '2', '#', NULL, 'F', '0', 'basedata:face:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3060', '人脸修改', '3057', '3', '#', NULL, 'F', '0', 'basedata:face:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3061', '人脸删除', '3057', '4', '#', NULL, 'F', '0', 'basedata:face:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3062', '人脸导出', '3057', '5', '#', NULL, 'F', '0', 'basedata:face:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3063', '人脸详细', '3057', '6', '#', 'menuItem', 'F', '0', 'basedata:face:detail', '#', 'admin', TO_DATE('2019-10-23 22:13:08', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3064', '指纹管理', '5', '3', '/basedata/finger', 'menuItem', 'C', '0', 'basedata:finger:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-23 23:15:13', 'SYYYY-MM-DD HH24:MI:SS'), '指纹菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3065', '指纹查询', '3064', '1', '#', NULL, 'F', '0', 'basedata:finger:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3066', '指纹新增', '3064', '2', '#', NULL, 'F', '0', 'basedata:finger:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3067', '指纹修改', '3064', '3', '#', NULL, 'F', '0', 'basedata:finger:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3068', '指纹删除', '3064', '4', '#', NULL, 'F', '0', 'basedata:finger:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3069', '指纹导出', '3064', '5', '#', NULL, 'F', '0', 'basedata:finger:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3070', '指纹详细', '3064', '6', '#', NULL, 'F', '0', 'basedata:finger:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3071', '虹膜管理', '5', '4', '/basedata/iris', 'menuItem', 'C', '0', 'basedata:iris:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-24 11:53:29', 'SYYYY-MM-DD HH24:MI:SS'), '虹膜菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3072', '虹膜查询', '3071', '1', '#', NULL, 'F', '0', 'basedata:iris:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3073', '虹膜新增', '3071', '2', '#', NULL, 'F', '0', 'basedata:iris:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3074', '虹膜修改', '3071', '3', '#', NULL, 'F', '0', 'basedata:iris:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3075', '虹膜删除', '3071', '4', '#', NULL, 'F', '0', 'basedata:iris:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3076', '虹膜导出', '3071', '5', '#', NULL, 'F', '0', 'basedata:iris:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3077', '虹膜详细', '3071', '6', '#', NULL, 'F', '0', 'basedata:iris:detail', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3078', '证件管理', '5', '5', '/basedata/cert', NULL, 'C', '0', 'basedata:cert:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '证件菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3079', '证件查询', '3078', '1', '#', NULL, 'F', '0', 'basedata:cert:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3080', '证件新增', '3078', '2', '#', NULL, 'F', '0', 'basedata:cert:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3081', '证件修改', '3078', '3', '#', NULL, 'F', '0', 'basedata:cert:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3082', '证件删除', '3078', '4', '#', NULL, 'F', '0', 'basedata:cert:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3083', '证件导出', '3078', '5', '#', NULL, 'F', '0', 'basedata:cert:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3084', '证件导入', '3078', '6', '#', 'menuItem', 'F', '0', 'basedata:cert:import', '#', 'admin', TO_DATE('2019-10-24 14:39:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3085', '证件下载', '3078', '7', '#', 'menuItem', 'F', '0', 'basedata:cert:download', '#', 'admin', TO_DATE('2019-10-24 14:39:36', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3354', '云账户新增', '3352', '2', '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:add', '#', 'admin', TO_DATE('2020-03-30 12:05:46', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3355', '云账户修改', '3352', '3', '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:edit', '#', 'admin', TO_DATE('2020-03-30 12:06:16', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3356', '云账户删除', '3352', '4', '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:delete', '#', 'admin', TO_DATE('2020-03-30 12:06:40', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3357', '云账户导出', '3352', '5', '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:export', '#', 'admin', TO_DATE('2020-03-30 12:07:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3358', '公众号菜单', '3348', '3', '/msg/weixinMenu', 'menuItem', 'C', '0', 'msg:weixinMenu:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 12:52:39', 'SYYYY-MM-DD HH24:MI:SS'), '微信公众号菜单菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3359', '微信公众号菜单查询', '3358', '1', '#', NULL, 'F', '0', 'msg:weixinMenu:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3360', '微信公众号菜单新增', '3358', '2', '#', NULL, 'F', '0', 'msg:weixinMenu:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3361', '微信公众号菜单修改', '3358', '3', '#', NULL, 'F', '0', 'msg:weixinMenu:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3362', '微信公众号菜单删除', '3358', '4', '#', NULL, 'F', '0', 'msg:weixinMenu:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3363', '微信公众号菜单导出', '3358', '5', '#', NULL, 'F', '0', 'msg:weixinMenu:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3364', '菜单响应', '3348', '4', '/msg/weixinMenuReply', 'menuItem', 'C', '0', 'msg:weixinMenuReply:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 12:53:29', 'SYYYY-MM-DD HH24:MI:SS'), '微信公众号菜单回复菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3365', '微信公众号菜单回复查询', '3364', '1', '#', NULL, 'F', '0', 'msg:weixinMenuReply:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3366', '微信公众号菜单回复新增', '3364', '2', '#', NULL, 'F', '0', 'msg:weixinMenuReply:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3367', '微信公众号菜单回复修改', '3364', '3', '#', NULL, 'F', '0', 'msg:weixinMenuReply:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3368', '微信公众号菜单回复删除', '3364', '4', '#', NULL, 'F', '0', 'msg:weixinMenuReply:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3369', '微信公众号菜单回复导出', '3364', '5', '#', NULL, 'F', '0', 'msg:weixinMenuReply:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3370', '钉钉团队', '3351', '1', '/msg/dingTeam', 'menuItem', 'C', '0', 'msg:dingTeam:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 16:30:40', 'SYYYY-MM-DD HH24:MI:SS'), '钉钉团队(企业)菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3371', '钉钉团队(企业)查询', '3370', '1', '#', NULL, 'F', '0', 'msg:dingTeam:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3372', '钉钉团队(企业)新增', '3370', '2', '#', NULL, 'F', '0', 'msg:dingTeam:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3373', '钉钉团队(企业)修改', '3370', '3', '#', NULL, 'F', '0', 'msg:dingTeam:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3374', '钉钉团队(企业)删除', '3370', '4', '#', NULL, 'F', '0', 'msg:dingTeam:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3375', '钉钉团队(企业)导出', '3370', '5', '#', NULL, 'F', '0', 'msg:dingTeam:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3376', '钉钉微应用', '3351', '2', '/msg/dingApplication', 'menuItem', 'C', '0', 'msg:dingApplication:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 16:29:47', 'SYYYY-MM-DD HH24:MI:SS'), '钉钉微应用菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3377', '钉钉微应用查询', '3376', '1', '#', NULL, 'F', '0', 'msg:dingApplication:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3378', '钉钉微应用新增', '3376', '2', '#', NULL, 'F', '0', 'msg:dingApplication:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3379', '钉钉微应用修改', '3376', '3', '#', NULL, 'F', '0', 'msg:dingApplication:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3380', '钉钉微应用删除', '3376', '4', '#', NULL, 'F', '0', 'msg:dingApplication:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3381', '钉钉微应用导出', '3376', '5', '#', NULL, 'F', '0', 'msg:dingApplication:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3382', '发送钉钉', '3337', '4', '/msg/send/dingtalk', 'menuItem', 'C', '0', 'msg:send:dingtalk', '#', 'admin', TO_DATE('2020-04-01 09:29:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3383', '钉钉媒体上传', '3337', '5', '/msg/send//dingtalk/upload', 'menuItem', 'C', '0', 'msg:send:uploadDingMedia', '#', 'admin', TO_DATE('2020-04-01 11:51:25', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3270', '陌生人人脸查询', '3269', '1', '#', NULL, 'F', '0', 'basedata:stranger:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3271', '陌生人人脸删除', '3269', '2', '#', NULL, 'F', '0', 'basedata:stranger:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3272', '陌生人人脸导出', '3269', '3', '#', NULL, 'F', '0', 'basedata:stranger:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3273', '陌生人人脸详细', '3269', '4', '#', 'menuItem', 'F', '0', 'basedata:stranger:detail', '#', 'admin', TO_DATE('2020-01-17 10:40:25', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3274', '版本文件下载', '3210', '6', '#', 'menuItem', 'F', '0', 'client:version:download', '#', 'admin', TO_DATE('2020-02-11 14:53:59', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3281', '部门中间表', '1', '10', '/system/office', NULL, 'C', '0', 'system:office:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), '组织机构菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3282', '部门查询', '3281', '1', '#', NULL, 'F', '0', 'system:office:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3283', '轨迹查看', '3028', '9', '#', 'menuItem', 'F', '0', 'basedata:personInfo:track', '#', 'admin', TO_DATE('2020-02-14 16:47:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3296', '消息附件', '3332', '8', '/msg/annex', 'menuItem', 'C', '0', 'msg:annex:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 11:10:04', 'SYYYY-MM-DD HH24:MI:SS'), '消息日志附件菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3297', '消息日志附件查询', '3296', '1', '#', NULL, 'F', '0', 'msg:annex:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3300', '消息日志附件删除', '3296', '2', '#', 'menuItem', 'F', '0', 'msg:annex:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-19 10:11:56', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3301', '消息日志附件导出', '3296', '3', '#', 'menuItem', 'F', '0', 'msg:annex:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-19 10:12:06', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3302', '历史日志', '3332', '9', '/msg/hislog', 'menuItem', 'C', '0', 'msg:hislog:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 11:11:43', 'SYYYY-MM-DD HH24:MI:SS'), '消息历史日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3303', '消息历史日志查询', '3302', '1', '#', NULL, 'F', '0', 'msg:hislog:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3306', '消息历史日志删除', '3302', '2', '#', 'menuItem', 'F', '0', 'msg:hislog:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-19 10:12:41', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3307', '消息历史日志导出', '3302', '3', '#', 'menuItem', 'F', '0', 'msg:hislog:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-19 10:12:49', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3308', '消息日志', '3332', '7', '/msg/log', 'menuItem', 'C', '0', 'msg:log:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 11:11:21', 'SYYYY-MM-DD HH24:MI:SS'), '消息日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3309', '消息日志查询', '3308', '1', '#', NULL, 'F', '0', 'msg:log:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3312', '消息日志删除', '3308', '2', '#', 'menuItem', 'F', '0', 'msg:log:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-19 10:12:24', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3313', '消息日志导出', '3308', '3', '#', 'menuItem', 'F', '0', 'msg:log:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-19 10:12:32', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3314', '消息模板', '3332', '6', '/msg/template', 'menuItem', 'C', '0', 'msg:template:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 11:11:10', 'SYYYY-MM-DD HH24:MI:SS'), '消息模板菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3315', '消息模板查询', '3314', '1', '#', NULL, 'F', '0', 'msg:template:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3316', '消息模板新增', '3314', '2', '#', NULL, 'F', '0', 'msg:template:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3317', '消息模板修改', '3314', '3', '#', NULL, 'F', '0', 'msg:template:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3318', '消息模板删除', '3314', '4', '#', NULL, 'F', '0', 'msg:template:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3319', '消息模板导出', '3314', '5', '#', NULL, 'F', '0', 'msg:template:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3320', '微信公众号', '3348', '1', '/msg/officalAccount', 'menuItem', 'C', '0', 'msg:officalAccount:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 11:06:56', 'SYYYY-MM-DD HH24:MI:SS'), '微信公众号菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3321', '公众号查询', '3320', '1', '#', NULL, 'F', '0', 'msg:officalAccount:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3322', '公众号新增', '3320', '2', '#', NULL, 'F', '0', 'msg:officalAccount:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3323', '公众号修改', '3320', '3', '#', NULL, 'F', '0', 'msg:officalAccount:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3324', '公众号删除', '3320', '4', '#', NULL, 'F', '0', 'msg:officalAccount:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3325', '公众号导出', '3320', '5', '#', NULL, 'F', '0', 'msg:officalAccount:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3326', '公众号用户', '3348', '2', '/msg/officalAccountUser', 'menuItem', 'C', '0', 'msg:officalAccountUser:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 12:55:02', 'SYYYY-MM-DD HH24:MI:SS'), '微信公众号用户菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3327', '公众号用户查询', '3326', '1', '#', NULL, 'F', '0', 'msg:officalAccountUser:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3329', '公众号用户修改', '3326', '3', '#', NULL, 'F', '0', 'msg:officalAccountUser:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3331', '公众号用户导出', '3326', '5', '#', NULL, 'F', '0', 'msg:officalAccountUser:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3332', '消息通知', '0', '9', '#', 'menuItem', 'M', '0', NULL, 'fa fa-commenting', 'admin', TO_DATE('2020-03-17 15:13:22', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-17 15:14:06', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3333', '消息日志附件下载', '3296', '4', '#', 'menuItem', 'F', '0', 'msg:annex:download', '#', 'admin', TO_DATE('2020-03-19 10:09:30', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-19 10:12:15', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3334', '消息附件下载', '3308', '4', '#', 'menuItem', 'F', '0', 'msg:log:download', '#', 'admin', TO_DATE('2020-03-19 10:17:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3335', '消息附件下载', '3302', '4', '#', 'menuItem', 'F', '0', 'msg:hislog:download', '#', 'admin', TO_DATE('2020-03-19 10:18:33', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3336', '发送邮件', '3337', '2', '/msg/send/mail', 'menuItem', 'C', '0', 'msg:send:mail', '#', 'admin', TO_DATE('2020-03-20 15:24:45', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-23 12:30:09', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3337', '消息推送', '3332', '1', '#', 'menuItem', 'M', '0', NULL, '#', 'admin', TO_DATE('2020-03-20 21:35:23', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-20 21:39:27', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3338', '发送短信', '3337', '1', '/msg/send/sms', 'menuItem', 'C', '0', 'msg:send:sms', '#', 'admin', TO_DATE('2020-03-23 12:30:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3339', '邮箱配置', '3350', '6', '/msg/mailProperty', 'menuItem', 'C', '0', 'msg:mailProperty:view', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 11:08:53', 'SYYYY-MM-DD HH24:MI:SS'), '邮箱配置菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3340', '邮箱配置查询', '3339', '1', '#', NULL, 'F', '0', 'msg:mailProperty:list', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3341', '邮箱配置新增', '3339', '2', '#', NULL, 'F', '0', 'msg:mailProperty:add', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3342', '邮箱配置修改', '3339', '3', '#', NULL, 'F', '0', 'msg:mailProperty:edit', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3343', '邮箱配置删除', '3339', '4', '#', NULL, 'F', '0', 'msg:mailProperty:remove', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3344', '邮箱配置导出', '3339', '5', '#', NULL, 'F', '0', 'msg:mailProperty:export', '#', 'admin', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3345', '发送微信', '3337', '3', '/msg/send/weixin', 'menuItem', 'C', '0', 'msg:send:weixin', '#', 'admin', TO_DATE('2020-03-24 17:59:54', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3347', '公众号用户拉取', '3326', '2', '#', 'menuItem', 'F', '0', 'msg:officalAccountUser:pull', '#', 'admin', TO_DATE('2020-03-27 10:34:02', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3348', '微信通知', '3332', '4', '#', 'menuItem', 'M', '0', NULL, '#', 'admin', TO_DATE('2020-03-30 11:05:53', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-03-30 11:08:41', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3349', '短信通知', '3332', '2', '#', 'menuItem', 'M', '0', NULL, '#', 'admin', TO_DATE('2020-03-30 11:08:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3350', '邮件通知', '3332', '3', '#', 'menuItem', 'M', '0', NULL, '#', 'admin', TO_DATE('2020-03-30 11:08:34', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3351', '钉钉通知', '3332', '5', '#', 'menuItem', 'M', '0', NULL, '#', 'admin', TO_DATE('2020-03-30 11:09:32', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3352', '短信云账户', '3349', '1', 'msg/smsCloudAccount', 'menuItem', 'C', '0', 'msg:smsCloudAccount:view', '#', 'admin', TO_DATE('2020-03-30 12:03:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3353', '云账户查询', '3352', '1', '#', 'menuItem', 'F', '0', 'msg:smsCloudAccount:list', '#', 'admin', TO_DATE('2020-03-30 12:05:18', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3384', '渠道管理_渠道信息详情', '3123', '6', '#', 'menuItem', 'F', '0', 'scene:info:detail', '#', 'admin', TO_DATE('2020-04-09 16:18:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3385', '历史报文', '108', '4', '/system/hisrecord', 'menuItem', 'C', '0', 'system:hisrecord:view', '#', 'admin', TO_DATE('2020-04-09 16:18:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3386', '历史报文查询', '3385', '1', '#', 'menuItem', 'F', '0', 'system:hisrecord:list', '#', 'admin', TO_DATE('2020-04-09 16:18:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3387', '历史报文新增', '3385', '2', '#', 'menuItem', 'F', '0', 'system:hisrecord:add', '#', 'admin', TO_DATE('2020-04-09 16:18:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3388', '历史报文修改', '3385', '3', '#', 'menuItem', 'F', '0', 'system:hisrecord:edit', '#', 'admin', TO_DATE('2020-04-09 16:18:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3389', '历史报文删除', '3385', '4', '#', 'menuItem', 'F', '0', 'system:hisrecord:remove', '#', 'admin',TO_DATE('2020-04-09 16:18:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3390', '历史报文导出', '3385', '5', '#', 'menuItem', 'F', '0', 'system:hisrecord:export', '#', 'admin', TO_DATE('2020-04-09 16:18:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES ('3391', '历史报文详细', '3385', '6', '#', 'menuItem', 'F', '0', 'system:hisrecord:detail', '#', 'admin', TO_DATE('2020-04-09 16:18:57', 'SYYYY-MM-DD HH24:MI:SS'),  NULL, NULL, NULL);
UPDATE SYS_MENU SET TARGET = 'menuItem' WHERE url != '#';


INSERT INTO sys_notice(notice_id, notice_title, notice_type, notice_content, status, create_by, create_time, update_by, update_time, remark) VALUES ('1', '温馨提醒：2018-07-01 智慧园区平台新版本发布啦', '2', '新版本内容', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '管理员');
INSERT INTO sys_notice(notice_id, notice_title, notice_type, notice_content, status, create_by, create_time, update_by, update_time, remark) VALUES ('2', '维护通知：2018-07-01 智慧园区平台系统凌晨维护', '1', '维护内容', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '管理员');


INSERT INTO sys_post(post_id, post_code, post_name, post_sort, status, create_by, create_time, update_by, update_time, remark) VALUES ('1', 'ceo', '董事长', '1', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_post(post_id, post_code, post_name, post_sort, status, create_by, create_time, update_by, update_time, remark) VALUES ('2', 'se', '项目经理', '2', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_post(post_id, post_code, post_name, post_sort, status, create_by, create_time, update_by, update_time, remark) VALUES ('3', 'hr', '人力资源', '3', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO sys_post(post_id, post_code, post_name, post_sort, status, create_by, create_time, update_by, update_time, remark) VALUES ('4', 'user', '普通员工', '4', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), NULL);


INSERT INTO sys_role(role_id, role_name, role_key, role_sort, data_scope, status, del_flag, create_by, create_time, update_by, update_time, remark) VALUES ('1', '管理员', 'admin', '1', '1', '0', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '管理员');
INSERT INTO sys_role(role_id, role_name, role_key, role_sort, data_scope, status, del_flag, create_by, create_time, update_by, update_time, remark) VALUES ('2', '普通角色', 'common', '2', '2', '0', '0', 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), '普通角色');
INSERT INTO sys_role(role_id, role_name, role_key, role_sort, data_scope, status, del_flag, create_by, create_time, update_by, update_time, remark) VALUES ('100', '自助采集', 'collect', '3', '1', '0', '0', 'admin', TO_DATE('2019-10-29 12:15:09', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-29 12:16:53', 'SYYYY-MM-DD HH24:MI:SS'), '人脸图像自助采集');
INSERT INTO sys_role(role_id, role_name, role_key, role_sort, data_scope, status, del_flag, create_by, create_time, update_by, update_time, remark) VALUES ('101', '自助签约', 'selfsign', '4', '1', '0', '0', 'admin', TO_DATE('2019-12-26 11:34:49', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-26 11:43:25', 'SYYYY-MM-DD HH24:MI:SS'), '渠道业务自助签约');

INSERT INTO sys_user(user_id, dept_id, login_name, user_name, user_type, email, phonenumber, sex, avatar, password, salt, status, del_flag, login_ip, login_date, create_by, create_time, update_by, update_time, remark) VALUES ('1', '99', 'admin', 'admin', '00', 'ry@163.com', '15888888888', '1', NULL, '29c67a30398638269fe600f73a054934', '111111', '0', '0', '192.168.60.93', TO_DATE('2020-04-03 15:03:45', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2018-03-16 11:33:00', 'SYYYY-MM-DD HH24:MI:SS'), 'ry', TO_DATE('2020-04-03 15:03:44', 'SYYYY-MM-DD HH24:MI:SS'), '管理员');
INSERT INTO sys_user(user_id, dept_id, login_name, user_name, user_type, email, phonenumber, sex, avatar, password, salt, status, del_flag, login_ip, login_date, create_by, create_time, update_by, update_time, remark) VALUES ('102', '99', 'collect', '自助采集', '00', 'collect@eyecool.cn', '13000000000', '0', NULL, 'b8f3bb60f7496291ea1adc687762e437', 'fcf963', '0', '0', '192.168.63.244', TO_DATE('2020-02-19 15:08:32', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-10-29 12:19:55', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-02-27 15:08:50', 'SYYYY-MM-DD HH24:MI:SS'), '照片自助采集时，平台自动登录使用');
INSERT INTO sys_user(user_id, dept_id, login_name, user_name, user_type, email, phonenumber, sex, avatar, password, salt, status, del_flag, login_ip, login_date, create_by, create_time, update_by, update_time, remark) VALUES ('104', '99', 'selfopen', '自助签约', '00', 'selfopen@eyecool.cn', '13000000001', '0', NULL, '8141d10f763e5ae3734960ed9fc5b37f', 'c6fd88', '0', '0', '192.168.60.137', TO_DATE('2019-12-26 11:47:41', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-26 11:44:54', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2019-12-26 11:49:38', 'SYYYY-MM-DD HH24:MI:SS'), NULL);

INSERT INTO sys_user_role(user_id, role_id) VALUES ('1', '1');
INSERT INTO sys_user_role(user_id, role_id) VALUES ('102', '100');
INSERT INTO sys_user_role(user_id, role_id) VALUES ('104', '101');


INSERT INTO base_qr_code(id, scene, content, img_path, internal_pic, remark, status, create_by, update_by, create_time, update_time, batch_date) VALUES ('155935941299520', '人脸图像自助采集', 'http://192.168.63.8:8765/biapwp/basedata/face/collect', './eyecool/biapwp/basedata/qrcode/20191224/010292ca-ca74-420b-bdeb-86663c736b12.jpg', NULL, '人脸图像自助采集', '0', NULL, NULL, TO_DATE('2019-10-29 12:19:53', 'SYYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-12-24 09:57:41', 'SYYYY-MM-DD HH24:MI:SS'), NULL);
INSERT INTO base_qr_code(id, scene, content, img_path, internal_pic, remark, status, create_by, update_by, create_time, update_time, batch_date) VALUES ('161675642016064', '人脸服务自助开通', 'http://192.168.63.8:8765/biapwp/scene/busi/selfopen/face?channelCode=eyecool', './eyecool/biapwp/basedata/qrcode/20200102/4604b5e7-7531-4c17-91c7-16115a2d139f.jpg', NULL, '渠道下人脸服务自助开通（签约或解约）', '0', NULL, NULL, TO_DATE('2020-01-02 09:19:29', 'SYYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-02 09:19:43', 'SYYYY-MM-DD HH24:MI:SS'), NULL);

INSERT INTO base_app_manage(id, app_key, app_secret, app_desc, built_in, remark, create_by, update_by, create_time, update_time, batch_date) VALUES ('161672168315200', 'n4QJ3OHW', '91e08faa94fec1e53501c0e738b3376f856526f8', '设备版本升级', 'Y', '设备版本升级', 'admin', NULL, TO_DATE('2020-01-02 08:22:57', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL);



INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('103', '指纹1:N识别搜索日志迁移', 'DEFAULT', 'logMigrationbTask.migrateFingerSearchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-03 17:19:20', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-03 17:21:06', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00执行一次');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('104', '虹膜1:1认证比对日志迁移', 'DEFAULT', 'logMigrationbTask.migrateIrisMatchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-03 17:20:12', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-03 17:21:04', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00执行一次');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('106', '组织机构同步', 'DEFAULT', 'syncDeptInfoTask.executeSync()', '0 0 0 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-03 17:20:56', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-03 17:21:00', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00执行一次');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('107', '消息通知推送日志迁移', 'DEFAULT', 'mgLogMigrateTask.migrateMsgSendLog()', '0 0 0 * * ? *', '1', '1', '1', 'admin', TO_DATE('2020-04-03 17:21:32', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '每天凌晨00:00:00执行一次');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('101', '人脸1:N识别搜索日志迁移', 'DEFAULT', 'logMigrationbTask.migrateFaceSearchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-03 17:18:28', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-03 17:18:55', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00执行一次');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('102', '指纹1:1认证比对日志迁移', 'DEFAULT', 'logMigrationbTask.migrateFingerMatchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-03 17:18:51', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-03 17:18:59', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00执行一次');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('105', '虹膜1:N识别搜索日志迁移', 'DEFAULT', 'logMigrationbTask.migrateIrisSearchLog()', '0 0 0 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-03 17:20:34', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-03 17:21:03', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00执行一次');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('100', '人脸1:1认证比对日志迁移', 'DEFAULT', 'logMigrationbTask.migrateFaceMatchLog()', '0 0 0 * * ? *', '1', '1', '1', 'admin', TO_DATE('2020-04-03 17:35:46', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-03 17:06:10', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00执行一次');


INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME103', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A74002A6C6F674D6967726174696F6E625461736B2E6D69677261746546696E6765725365617263684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000067740021E68C87E7BAB9313A4EE8AF86E588ABE6909CE7B4A2E697A5E5BF97E8BF81E7A7BB74000131740001317800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME104', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400276C6F674D6967726174696F6E625461736B2E6D696772617465497269734D617463684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000068740021E899B9E8869C313A31E8AEA4E8AF81E6AF94E5AFB9E697A5E5BF97E8BF81E7A7BB74000131740001317800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME106', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A74001E73796E6344657074496E666F5461736B2E6578656375746553796E63282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000006A740012E7BB84E7BB87E69CBAE69E84E5908CE6ADA574000131740001317800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME107', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400246D674C6F674D6967726174655461736B2E6D6967726174654D736753656E644C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000006B74001EE6B688E681AFE9809AE79FA5E68EA8E98081E697A5E5BF97E8BF81E7A7BB74000131740001317800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME105', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400286C6F674D6967726174696F6E625461736B2E6D696772617465497269735365617263684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000069740021E899B9E8869C313A4EE8AF86E588ABE6909CE7B4A2E697A5E5BF97E8BF81E7A7BB74000131740001317800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME101', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400286C6F674D6967726174696F6E625461736B2E6D696772617465466163655365617263684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000065740021E4BABAE884B8313A4EE8AF86E588ABE6909CE7B4A2E697A5E5BF97E8BF81E7A7BB74000131740001317800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME102', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400296C6F674D6967726174696F6E625461736B2E6D69677261746546696E6765724D617463684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000066740021E68C87E7BAB9313A31E8AEA4E8AF81E6AF94E5AFB9E697A5E5BF97E8BF81E7A7BB74000131740001317800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME100', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7070740020E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18CE4B880E6ACA17070707400013174000D3020302030202A202A203F202A7400276C6F674D6967726174696F6E625461736B2E6D696772617465466163654D617463684C6F67282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000006C740021E4BABAE884B8313A31E8AEA4E8AF81E6AF94E5AFB9E697A5E5BF97E8BF81E7A7BB74000131740001317800'));


INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME103', 'DEFAULT', 'TASK_CLASS_NAME103', 'DEFAULT', NULL, '1585929600000', '-1', '5', 'WAITING', 'CRON', '1585905411000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME104', 'DEFAULT', 'TASK_CLASS_NAME104', 'DEFAULT', NULL, '1585929600000', '-1', '5', 'WAITING', 'CRON', '1585905463000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME106', 'DEFAULT', 'TASK_CLASS_NAME106', 'DEFAULT', NULL, '1585929600000', '-1', '5', 'WAITING', 'CRON', '1585905508000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME107', 'DEFAULT', 'TASK_CLASS_NAME107', 'DEFAULT', NULL, '1585929600000', '-1', '5', 'WAITING', 'CRON', '1585905543000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME101', 'DEFAULT', 'TASK_CLASS_NAME101', 'DEFAULT', NULL, '1585929600000', '-1', '5', 'WAITING', 'CRON', '1585905359000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME102', 'DEFAULT', 'TASK_CLASS_NAME102', 'DEFAULT', NULL, '1585929600000', '-1', '5', 'WAITING', 'CRON', '1585905383000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME105', 'DEFAULT', 'TASK_CLASS_NAME105', 'DEFAULT', NULL, '1585929600000', '-1', '5', 'WAITING', 'CRON', '1585905485000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME100', 'DEFAULT', 'TASK_CLASS_NAME100', 'DEFAULT', NULL, '1585929600000', '-1', '5', 'WAITING', 'CRON', '1585906398000', '0', NULL, '-1', NULL);


INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME103', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME104', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME106', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME107', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME100', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME101', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME102', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME105', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');

INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('120', '接口报文历史数据分区维护', 'DEFAULT', 'requestRecordTask.clearAndAddPartition('''',15)', '0 0 0 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-14 12:17:43', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-14 12:18:08', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00执行(第一个参数时数据库名没有用，第二个参数是保留天数)
注意：尽量不要修改这个cron表达式，否则可能导致历史日志存储失败');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('121', '接口报文日志迁移', 'DEFAULT', 'requestRecordTask.migrateRequestRecord()', '0 0 0 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-14 12:18:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2020-04-14 12:18:07', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨00:00:00迁移');

INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME121', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E707074001AE6AF8FE5A4A9E5878CE699A830303A30303A3030E8BF81E7A7BB7070707400013174000D3020302030202A202A203F202A740028726571756573745265636F72645461736B2E6D696772617465526571756573745265636F7264282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000079740018E68EA5E58FA3E68AA5E69687E697A5E5BF97E8BF81E7A7BB74000131740001317800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME120', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E70707400C1E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18C28E7ACACE4B880E4B8AAE58F82E695B0E697B6E695B0E68DAEE5BA93E5908DE6B2A1E69C89E794A8EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE4BF9DE79599E5A4A9E695B0290D0AE6B3A8E6848FEFBC9AE5B0BDE9878FE4B88DE8A681E4BFAEE694B9E8BF99E4B8AA63726F6EE8A1A8E8BEBEE5BC8FEFBC8CE590A6E58899E58FAFE883BDE5AFBCE887B4E58E86E58FB2E697A5E5BF97E5AD98E582A8E5A4B1E8B4A57070707400013174000D3020302030202A202A203F202A74002D726571756573745265636F72645461736B2E636C656172416E64416464506172746974696F6E2827272C31352974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000078740024E68EA5E58FA3E68AA5E69687E58E86E58FB2E695B0E68DAEE58886E58CBAE7BBB4E68AA474000131740001317800'));

INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME120', 'DEFAULT', 'TASK_CLASS_NAME120', 'DEFAULT', NULL, '1586880000000', '-1', '5', 'WAITING', 'CRON', '1586837710000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME121', 'DEFAULT', 'TASK_CLASS_NAME121', 'DEFAULT', NULL, '1586880000000', '-1', '5', 'WAITING', 'CRON', '1586837731000', '0', NULL, '-1', NULL);

INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME120', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME121', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');


INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('123', '维护和清理人脸1:N搜索历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearFaceSearchLog(365,false,'''')', '0 0 1 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-14 17:17:26', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-14 17:27:55', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名,oracle不需要传）');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('122', '维护和清理人脸1:1比对历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearFaceMatchLog(365,false,'''')', '0 0 1 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-14 17:00:48', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-14 17:27:51', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名,oracle不需要传）');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('124', '维护和清理指纹1:1比对历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearFingerMatchLog(365,false,'''')', '0 0 1 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-14 17:18:42', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-14 17:27:59', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名,oracle不需要传）');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('125', '维护和清理指纹1:N搜索历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearFingerSearchLog(365,false,'''')', '0 0 1 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-14 17:20:23', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-14 17:28:02', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名,oracle不需要传）');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('126', '维护和清理虹膜1:1比对历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearIrisMatchLog(365,false,'''')', '0 0 1 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-14 17:26:14', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-14 17:28:06', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名,oracle不需要传）');
INSERT INTO SYS_JOB(JOB_ID, JOB_NAME, JOB_GROUP, INVOKE_TARGET, CRON_EXPRESSION, MISFIRE_POLICY, CONCURRENT, STATUS, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('127', '维护和清理虹膜1:N搜索历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearIrisSearchLog(365,false,'''')', '0 0 1 * * ? *', '1', '1', '0', 'admin', TO_DATE('2020-04-14 17:27:08', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-14 17:28:09', 'SYYYY-MM-DD HH24:MI:SS'), '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名,oracle不需要传）');

INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME122', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740031636C65617242696F4D617463684C6F675461736B2E636C656172466163654D617463684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000007A740021E6B885E999A4E4BABAE884B8313A31E6AF94E5AFB9E58E86E58FB2E697A5E5BF9774000131740001307800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME126', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740031636C65617242696F4D617463684C6F675461736B2E636C656172497269734D617463684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000007E740021E6B885E999A4E899B9E8869C313A31E6AF94E5AFB9E58E86E58FB2E697A5E5BF9774000131740001307800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME125', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740034636C65617242696F4D617463684C6F675461736B2E636C65617246696E6765725365617263684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000007D740021E6B885E999A4E68C87E7BAB9313A4EE6909CE7B4A2E58E86E58FB2E697A5E5BF9774000131740001307800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME123', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740032636C65617242696F4D617463684C6F675461736B2E636C656172466163655365617263684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000007B740021E6B885E999A4E4BABAE884B8313A4EE6909CE7B4A2E58E86E58FB2E697A5E5BF9774000131740001307800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME127', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740032636C65617242696F4D617463684C6F675461736B2E636C656172497269735365617263684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000007F740021E6B885E999A4E899B9E8869C313A4EE6909CE7B4A2E58E86E58FB2E697A5E5BF9774000131740001307800'));
INSERT INTO QRTZ_JOB_DETAILS(SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME124', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', HEXTORAW('ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740033636C65617242696F4D617463684C6F675461736B2E636C65617246696E6765724D617463684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000007C740021E6B885E999A4E68C87E7BAB9313A31E6AF94E5AFB9E58E86E58FB2E697A5E5BF9774000131740001307800'));

INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME125', 'DEFAULT', 'TASK_CLASS_NAME125', 'DEFAULT', NULL, '1586883600000', '-1', '5', 'WAITING', 'CRON', '1586856329000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME122', 'DEFAULT', 'TASK_CLASS_NAME122', 'DEFAULT', NULL, '1586883600000', '-1', '5', 'WAITING', 'CRON', '1586856318000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME126', 'DEFAULT', 'TASK_CLASS_NAME126', 'DEFAULT', NULL, '1586883600000', '-1', '5', 'WAITING', 'CRON', '1586856333000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME123', 'DEFAULT', 'TASK_CLASS_NAME123', 'DEFAULT', NULL, '1586883600000', '-1', '5', 'WAITING', 'CRON', '1586856322000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME127', 'DEFAULT', 'TASK_CLASS_NAME127', 'DEFAULT', NULL, '1586883600000', '-1', '5', 'WAITING', 'CRON', '1586856336000', '0', NULL, '-1', NULL);
INSERT INTO QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME124', 'DEFAULT', 'TASK_CLASS_NAME124', 'DEFAULT', NULL, '1586883600000', '-1', '5', 'WAITING', 'CRON', '1586856326000', '0', NULL, '-1', NULL);

INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME126', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME122', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME125', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME123', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME124', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO QRTZ_CRON_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME127', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');

INSERT INTO SYS_CONFIG(CONFIG_ID, CONFIG_NAME, CONFIG_KEY, CONFIG_VALUE, CONFIG_TYPE, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('134', '人脸1-N识别日志保存是否比对去重', 'busi.face.searchN.log.save.distinct', 'N', 'N', 'admin', TO_DATE('2020-04-15 13:18:29', 'SYYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2020-04-15 13:18:33', 'SYYYY-MM-DD HH24:MI:SS'), '人脸1-N日识别可能存在短时间内（例如5s）连续识别到一个人的情况，是否对识别日志去重处理（Y：是，N：否），是就只保存第一次识别的记录');
INSERT INTO SYS_CONFIG(CONFIG_ID, CONFIG_NAME, CONFIG_KEY, CONFIG_VALUE, CONFIG_TYPE, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK) VALUES ('135', '人脸1-N识别日志保存比对去重时间', 'busi.face.searchN.log.duplicate.time', '6000', 'N', 'admin', TO_DATE('2020-04-15 13:19:10', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, '人脸1-N日志保存去重时间,在此时间内连续识别到一个人，则认为是重复识别，只保存一条识别日志,单位为ms');

drop sequence S_sys_job;
CREATE sequence S_sys_job INCREMENT BY 1 START WITH 128 nomaxvalue nominvalue cache 20;
drop sequence S_sys_config;
CREATE sequence S_sys_config INCREMENT BY 1 START WITH 136 nomaxvalue nominvalue cache 20;
drop sequence S_sys_dept;
CREATE sequence S_sys_dept INCREMENT BY 1 START WITH 101 nomaxvalue nominvalue cache 20;
drop sequence S_sys_dict_data;
CREATE sequence S_sys_dict_data INCREMENT BY 1 START WITH 374 nomaxvalue nominvalue cache 20;
drop sequence S_sys_dict_type;
CREATE sequence S_sys_dict_type INCREMENT BY 1 START WITH 130 nomaxvalue nominvalue cache 20;
drop sequence S_sys_menu;
CREATE sequence S_sys_menu INCREMENT BY 1 START WITH 3392 nomaxvalue nominvalue cache 20;
drop sequence S_sys_notice;
CREATE sequence S_sys_notice INCREMENT BY 1 START WITH 3 nomaxvalue nominvalue cache 20;
drop sequence S_sys_post;
CREATE sequence S_sys_post INCREMENT BY 1 START WITH 5 nomaxvalue nominvalue cache 20;
drop sequence S_sys_role;
CREATE sequence S_sys_role INCREMENT BY 1 START WITH 102 nomaxvalue nominvalue cache 20;
drop sequence S_sys_user;
CREATE sequence S_sys_user INCREMENT BY 1 START WITH 105 nomaxvalue nominvalue cache 20;