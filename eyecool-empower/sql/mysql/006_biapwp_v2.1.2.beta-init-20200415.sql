-- ----------------------------
-- 执行此SQL文件需要修改如下数据库名为实际的数据库名称
-- ----------------------------
SET @schemaName = 'biapwp';

-- ----------------------------
-- 创建表分区存储过程(按天或者按月分区)
-- par_name_format:'%Y%m%d'或者'%Y%m'
-- 按月区分，day_value要传入某个月的最后一天
-- ----------------------------
DELIMITER $$
CREATE PROCEDURE sp_create_partition (day_value datetime, tb_schema varchar(128),tb_name varchar(128),par_name_format varchar(20))
BEGIN
  DECLARE par_name varchar(32);
  DECLARE par_value varchar(32);
  DECLARE _err int(1);
  DECLARE par_exist int(1);
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND SET _err = 1;
  START TRANSACTION;
    SET par_name = CONCAT('p', DATE_FORMAT(day_value, par_name_format));
    SELECT
      COUNT(1) INTO par_exist
    FROM information_schema.PARTITIONS
    WHERE TABLE_SCHEMA = tb_schema AND TABLE_NAME = tb_name AND PARTITION_NAME = par_name;
    IF (par_exist = 0) THEN
      SET par_value = DATE_FORMAT(day_value, '%Y-%m-%d');
      SET @alter_sql = CONCAT('alter table ', tb_name, ' add PARTITION (PARTITION ', par_name, ' VALUES LESS THAN (TO_DAYS("', par_value, '")+1))');
      PREPARE stmt1 FROM @alter_sql;
      EXECUTE stmt1;
    END IF;
  END
$$
	
	
-- ----------------------------
-- 删除表分区存储过程,用于删除过期分区(按天或者按月分区)
-- par_name_format:'%Y%m%d'或者'%Y%m'
-- ----------------------------
CREATE PROCEDURE sp_drop_partition (day_value datetime, tb_schema varchar(128), tb_name varchar(128),par_name_format varchar(20))
BEGIN
  DECLARE str_day varchar(64);
  DECLARE _err int(1);
  DECLARE done int DEFAULT 0;
  DECLARE par_name varchar(64);
  DECLARE cur_partition_name CURSOR FOR
  SELECT
    partition_name
  FROM INFORMATION_SCHEMA.PARTITIONS
  WHERE TABLE_SCHEMA = tb_schema AND table_name = tb_name
  ORDER BY partition_ordinal_position;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND SET _err = 1;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
  SET str_day = DATE_FORMAT(day_value, par_name_format);
  OPEN cur_partition_name;
  REPEAT
    FETCH cur_partition_name INTO par_name;
    IF (str_day > SUBSTRING(par_name, 2)) THEN
      SET @alter_sql = CONCAT('alter table ', tb_name, ' drop PARTITION ', par_name);
      PREPARE stmt1 FROM @alter_sql;
      EXECUTE stmt1;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_partition_name;
END
$$

/*==============================================================*/
/* Table: 接口请求报文历史表(分区表)	                            */
/*==============================================================*/
drop table if exists base_request_his_record;
create table base_request_his_record
(
   id                   varchar(48) not null comment '主键',
   trans_code           varchar(48) comment '交易码',
   trans_title          varchar(48) comment '交易标题',
   received_time        datetime not null comment '请求时间',
   request_msg          longtext comment '请求报文',
   client_ip            varchar(48) comment '客户端IP',
   send_time            datetime not null comment '响应时间',
   response_msg         longtext not null comment '响应报文',
   time_used            bigint not null comment '耗时(ms)',
   status_code          varchar(48) not null default '0' comment '状态码',
   trans_url            varchar(255) comment '交易请求路径',
   class_method         varchar(255) comment '处理方法',
   channel_code         varchar(255) comment '渠道编码',
   primary key (id, received_time)
) PARTITION BY RANGE (TO_DAYS(received_time)) (
PARTITION p0 VALUES LESS THAN (0)
);
ALTER TABLE base_request_his_record COMMENT '接口请求报文历史日志表';
CALL sp_create_partition(DATE_ADD(NOW(), INTERVAL - 2 DAY), @schemaName, 'base_request_his_record','%Y%m%d');
CALL sp_create_partition(DATE_ADD(NOW(), INTERVAL - 1 DAY), @schemaName, 'base_request_his_record','%Y%m%d');
CALL sp_create_partition(NOW(), @schemaName, 'base_request_his_record','%Y%m%d');
CALL sp_create_partition(DATE_ADD(NOW(), INTERVAL + 1 DAY), @schemaName, 'base_request_his_record','%Y%m%d');
CALL sp_create_partition(DATE_ADD(NOW(), INTERVAL + 2 DAY), @schemaName, 'base_request_his_record','%Y%m%d');

/*==============================================================*/
/* 普通表转分区表(人脸1：1历史日志表)	                            */
/*==============================================================*/
alter table person_face_match_his_log drop primary key;
alter table person_face_match_his_log add primary key ( id, received_time ) ;
DROP TABLE IF EXISTS person_face_match_his_log_tmp;
CREATE TABLE person_face_match_his_log_tmp (
  id varchar(48) NOT NULL COMMENT '主键',
  handle_seq varchar(48) NOT NULL COMMENT '平台流水号',
  received_seq varchar(48) NOT NULL COMMENT '业务流水号',
  unique_id varchar(48) DEFAULT NULL COMMENT '人员标识',
  dept_id bigint(20) DEFAULT NULL COMMENT '部门ID',
  channel_code varchar(255) DEFAULT NULL COMMENT '渠道编码',
  scene_image varchar(255) NOT NULL COMMENT '现场照路径',
  online_image varchar(255) DEFAULT NULL COMMENT '联网核查照路径',
  chip_image varchar(255) DEFAULT NULL COMMENT '芯片照路径',
  stock_image varchar(255) DEFAULT NULL COMMENT '底库照路径',
  scene_online_score double DEFAULT NULL COMMENT '现场照与联网核查照比对分值',
  scene_chip_score double DEFAULT NULL COMMENT '现场照与芯片照比对分值',
  scene_stock_score double DEFAULT NULL COMMENT '现场照与库底库照比对分值',
  online_chip_score double DEFAULT NULL COMMENT '联网核查照与芯片照比对分值',
  scene_online_result varchar(1) DEFAULT NULL COMMENT '现场照与联网核查照比对结果(0通过，1未通过)',
  scene_chip_result varchar(1) DEFAULT NULL COMMENT '现场照与芯片照比对结果(0通过，1未通过)',
  scene_stock_result varchar(1) DEFAULT NULL COMMENT '现场照与库底库照比对结果(0通过，1未通过)',
  online_chip_result varchar(1) DEFAULT NULL COMMENT '联网核查照与芯片照比对结果(0通过，1未通过)',
  checklive_result varchar(1) DEFAULT NULL COMMENT '现场照件检活结果(0通过，1未通过)',
  result varchar(1) DEFAULT NULL COMMENT '比对结果(0通过，1未通过)',
  broker varchar(48) DEFAULT NULL COMMENT '交易发起人',
  received_time datetime NOT NULL COMMENT '请求时间',
  time_used bigint(20) DEFAULT NULL COMMENT '耗时(ms)',
  server_id varchar(255) DEFAULT NULL COMMENT '服务器标识',
  vendor_code varchar(255) DEFAULT NULL COMMENT '厂商',
  algs_version varchar(255) DEFAULT NULL COMMENT '算法版本',
  tenant varchar(255) DEFAULT 'standard' COMMENT '租户',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  batch_date datetime DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY ( id, received_time ) 
) PARTITION BY RANGE (TO_DAYS(received_time)) (
PARTITION p0 VALUES LESS THAN (0)
) ;
ALTER TABLE person_face_match_his_log_tmp COMMENT '人员人脸比对历史日志表';

call sp_create_partition(last_day(curdate()),@schemaName,'person_face_match_his_log_tmp','%Y%m');
call sp_create_partition(date_sub(date_sub(date_format(now(),'%y-%m-%d'),interval extract(day from now()) day),interval -2 month),@schemaName,'person_face_match_his_log_tmp','%Y%m');

SET @pddl = concat('alter table person_face_match_his_log_tmp exchange partition p',DATE_FORMAT(now(),'%Y%m'), ' with table person_face_match_his_log');
PREPARE stmt FROM @pddl;/*定义预处理语句*/
EXECUTE stmt;/*执行预处理语句*/
DEALLOCATE PREPARE stmt;/*释放预处理语句*/

drop table if exists person_face_match_his_log;
alter table person_face_match_his_log_tmp rename to person_face_match_his_log;

/*==============================================================*/
/* 普通表转分区表(人脸1：N历史日志表)	                            */
/*==============================================================*/
alter table person_face_search_his_log drop primary key;
alter table person_face_search_his_log add primary key ( id, received_time ) ;
DROP TABLE IF EXISTS person_face_search_his_log_tmp;
CREATE TABLE person_face_search_his_log_tmp (
  id varchar(48) NOT NULL COMMENT '主键',
  handle_seq varchar(48) NOT NULL COMMENT '平台流水号',
  received_seq varchar(48) NOT NULL COMMENT '业务流水号',
  scene_type varchar(1) NOT NULL COMMENT '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N，3：子系统日志回传)',
  unique_id varchar(48) DEFAULT NULL COMMENT '人员标识',
  dept_id bigint(20) DEFAULT NULL COMMENT '部门ID',
  channel_code varchar(255) DEFAULT NULL COMMENT '渠道编码',
  sub_treasury_code varchar(255) DEFAULT NULL COMMENT '分库编码',
  sub_treasury_name varchar(255) DEFAULT NULL COMMENT '分库名称',
  scene_image varchar(255) NOT NULL COMMENT '现场照路径',
  stock_image varchar(255) DEFAULT NULL COMMENT '底库照路径',
  take_photo1 varchar(255) DEFAULT NULL COMMENT '抓拍图1路径',
  take_photo2 varchar(255) DEFAULT NULL COMMENT '抓拍图2路径',
  scene_stock_score double DEFAULT NULL COMMENT '分值',
  checklive_result varchar(1) DEFAULT NULL COMMENT '现场照件检活结果(0通过，1未通过)',
  result varchar(1) DEFAULT NULL COMMENT '结果(0通过，1未通过)',
  belong_to_stranger_lib varchar(1) DEFAULT 'N' COMMENT '识别结果是否属于陌生人库(数据字典 Y：是，N：否)',
  later_update_person varchar(1) DEFAULT 'N' COMMENT '人员标识是否后期维护(数据字典 Y：是，N：否)',
  broker varchar(48) DEFAULT NULL COMMENT '交易发起人',
  device_code varchar(255) DEFAULT NULL COMMENT '设备编码',
  device_name varchar(255) DEFAULT NULL COMMENT '设备名称',
  device_ip varchar(255) DEFAULT NULL COMMENT '设备IP',
  device_longitude double DEFAULT NULL COMMENT '设备经度(东经)',
  device_dimension double DEFAULT NULL COMMENT '设备维度(北纬)',
  received_time datetime NOT NULL COMMENT '请求时间',
  time_used bigint(20) DEFAULT NULL COMMENT '耗时(ms)',
  server_id varchar(255) DEFAULT NULL COMMENT '服务器标识',
  vendor_code varchar(255) DEFAULT NULL COMMENT '厂商',
  algs_version varchar(255) DEFAULT NULL COMMENT '算法版本',
  tenant varchar(255) DEFAULT 'standard' COMMENT '租户',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  batch_date datetime DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
   PRIMARY KEY ( id, received_time ) 
) PARTITION BY RANGE (TO_DAYS(received_time)) (
PARTITION p0 VALUES LESS THAN (0)
) ;
ALTER TABLE person_face_search_his_log_tmp COMMENT '人员人脸搜索历史日志表';

call sp_create_partition(last_day(curdate()),@schemaName,'person_face_search_his_log_tmp','%Y%m');
call sp_create_partition(date_sub(date_sub(date_format(now(),'%y-%m-%d'),interval extract(day from now()) day),interval -2 month),@schemaName,'person_face_search_his_log_tmp','%Y%m');

SET @pddl = concat('alter table person_face_search_his_log_tmp exchange partition p',DATE_FORMAT(now(),'%Y%m'), ' with table person_face_search_his_log');
PREPARE stmt FROM @pddl;/*定义预处理语句*/
EXECUTE stmt;/*执行预处理语句*/
DEALLOCATE PREPARE stmt;/*释放预处理语句*/

drop table if exists person_face_search_his_log;
alter table person_face_search_his_log_tmp rename to person_face_search_his_log;


/*==============================================================*/
/* 普通表转分区表(指纹1：1历史日志表)	                            */
/*==============================================================*/
alter table person_finger_match_his_log drop primary key;
alter table person_finger_match_his_log add primary key ( id, received_time ) ;
DROP TABLE IF EXISTS person_finger_match_his_log_tmp;
CREATE TABLE person_finger_match_his_log_tmp (
  id varchar(48) NOT NULL COMMENT '主键',
  handle_seq varchar(48) NOT NULL COMMENT '平台流水号',
  received_seq varchar(48) NOT NULL COMMENT '业务流水号',
  unique_id varchar(48) DEFAULT NULL COMMENT '人员标识',
  dept_id bigint(20) DEFAULT NULL COMMENT '部门ID',
  channel_code varchar(255) DEFAULT NULL COMMENT '渠道编码',
  finger_no varchar(2) DEFAULT NULL COMMENT '手指编码',
  scene_image varchar(255) NOT NULL COMMENT '现场照路径',
  stock_image varchar(255) DEFAULT NULL COMMENT '底库照路径',
  scene_stock_score double DEFAULT NULL COMMENT '现场照与库底库照比对分值',
  scene_stock_result varchar(1) DEFAULT NULL COMMENT '现场照与库底库照比对结果(0通过，1未通过)',
  result varchar(1) DEFAULT NULL COMMENT '比对结果(0通过，1未通过)',
  broker varchar(48) DEFAULT NULL COMMENT '交易发起人',
  received_time datetime NOT NULL COMMENT '请求时间',
  time_used bigint(20) DEFAULT NULL COMMENT '耗时(ms)',
  server_id varchar(255) DEFAULT NULL COMMENT '服务器标识',
  vendor_code varchar(255) DEFAULT NULL COMMENT '厂商',
  algs_version varchar(255) DEFAULT NULL COMMENT '算法版本',
  tenant varchar(255) DEFAULT 'standard' COMMENT '租户',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  batch_date datetime DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id, received_time ) 
) PARTITION BY RANGE (TO_DAYS(received_time)) (
PARTITION p0 VALUES LESS THAN (0)
) ;
ALTER TABLE person_finger_match_his_log_tmp COMMENT '人员指纹比对历史日志表'; 

call sp_create_partition(last_day(curdate()),@schemaName,'person_finger_match_his_log_tmp','%Y%m');
call sp_create_partition(date_sub(date_sub(date_format(now(),'%y-%m-%d'),interval extract(day from now()) day),interval -2 month),@schemaName,'person_finger_match_his_log_tmp','%Y%m');

SET @pddl = concat('alter table person_finger_match_his_log_tmp exchange partition p',DATE_FORMAT(now(),'%Y%m'), ' with table person_finger_match_his_log');
PREPARE stmt FROM @pddl;/*定义预处理语句*/
EXECUTE stmt;/*执行预处理语句*/
DEALLOCATE PREPARE stmt;/*释放预处理语句*/

drop table if exists person_finger_match_his_log;
alter table person_finger_match_his_log_tmp rename to person_finger_match_his_log;

/*==============================================================*/
/* 普通表转分区表(指纹1：N历史日志表)	                            */
/*==============================================================*/
alter table person_finger_search_his_log drop primary key;
alter table person_finger_search_his_log add primary key ( id, received_time ) ;
drop table if exists person_finger_search_his_log_tmp;
CREATE TABLE person_finger_search_his_log_tmp (
 id varchar(48) NOT NULL COMMENT '主键',
  handle_seq varchar(48) NOT NULL COMMENT '平台流水号',
  received_seq varchar(48) NOT NULL COMMENT '业务流水号',
  scene_type varchar(1) NOT NULL COMMENT '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N)',
  unique_id varchar(48) DEFAULT NULL COMMENT '人员标识',
  dept_id bigint(20) DEFAULT NULL COMMENT '部门ID',
  channel_code varchar(255) DEFAULT NULL COMMENT '渠道编码',
  sub_treasury_code varchar(255) DEFAULT NULL COMMENT '分库编码',
  sub_treasury_name varchar(255) DEFAULT NULL COMMENT '分库名称',
  finger_no varchar(2) DEFAULT NULL COMMENT '手指编码',
  scene_image varchar(255) NOT NULL COMMENT '现场照路径',
  stock_image varchar(255) DEFAULT NULL COMMENT '底库照路径',
  scene_stock_score double DEFAULT NULL COMMENT '分值',
  result varchar(1) DEFAULT NULL COMMENT '结果(0通过，1未通过)',
  broker varchar(48) DEFAULT NULL COMMENT '交易发起人',
  received_time datetime NOT NULL COMMENT '请求时间',
  time_used bigint(20) DEFAULT NULL COMMENT '耗时(ms)',
  server_id varchar(255) DEFAULT NULL COMMENT '服务器标识',
  vendor_code varchar(255) DEFAULT NULL COMMENT '厂商',
  algs_version varchar(255) DEFAULT NULL COMMENT '算法版本',
  tenant varchar(255) DEFAULT 'standard' COMMENT '租户',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  batch_date datetime DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id, received_time ) 
) PARTITION BY RANGE (TO_DAYS(received_time)) (
PARTITION p0 VALUES LESS THAN (0)
) ;
ALTER TABLE person_finger_search_his_log_tmp COMMENT '人员指纹搜索历史日志表';

call sp_create_partition(last_day(curdate()),@schemaName,'person_finger_search_his_log_tmp','%Y%m');
call sp_create_partition(date_sub(date_sub(date_format(now(),'%y-%m-%d'),interval extract(day from now()) day),interval -2 month),@schemaName,'person_finger_search_his_log_tmp','%Y%m');

SET @pddl = concat('alter table person_finger_search_his_log_tmp exchange partition p',DATE_FORMAT(now(),'%Y%m'), ' with table person_finger_search_his_log');
PREPARE stmt FROM @pddl;/*定义预处理语句*/
EXECUTE stmt;/*执行预处理语句*/
DEALLOCATE PREPARE stmt;/*释放预处理语句*/

drop table if exists person_finger_search_his_log;
alter table person_finger_search_his_log_tmp rename to person_finger_search_his_log;

/*==============================================================*/
/* 普通表转分区表(虹膜1：1历史日志表)	                            */
/*==============================================================*/
alter table person_iris_match_his_log drop primary key;
alter table person_iris_match_his_log add primary key ( id, received_time ) ;
DROP TABLE IF EXISTS person_iris_match_his_log_tmp;
CREATE TABLE person_iris_match_his_log_tmp (
  id varchar(48) NOT NULL COMMENT '主键',
  handle_seq varchar(48) NOT NULL COMMENT '平台流水号',
  received_seq varchar(48) NOT NULL COMMENT '业务流水号',
  unique_id varchar(48) DEFAULT NULL COMMENT '人员标识',
  dept_id bigint(20) DEFAULT NULL COMMENT '部门ID',
  channel_code varchar(255) DEFAULT NULL COMMENT '渠道编码',
  scene_left_image varchar(255) DEFAULT NULL COMMENT '现场左眼照路径',
  scene_right_image varchar(255) DEFAULT NULL COMMENT '现场右眼照路径',
  stock_left_image varchar(255) DEFAULT NULL COMMENT '底库左眼照路径',
  stock_right_image varchar(255) DEFAULT NULL COMMENT '底库右眼照路径',
  scene_lstock_score double DEFAULT NULL COMMENT '左眼现场照与库底库照比对分值',
  scene_lstock_result varchar(1) DEFAULT NULL COMMENT '左眼现场照与库底库照比对结果(0通过，1未通过)',
  scene_rstock_score double DEFAULT NULL COMMENT '右眼现场照与库底库照比对分值',
  scene_rstock_result varchar(1) DEFAULT NULL COMMENT '右眼现场照与库底库照比对结果(0通过，1未通过)',
  result varchar(1) DEFAULT NULL COMMENT '比对结果(0通过，1未通过)',
  result_strategy varchar(1) DEFAULT NULL COMMENT '结果策略(1:与， 2:或)',
  broker varchar(48) DEFAULT NULL COMMENT '交易发起人',
  received_time datetime NOT NULL COMMENT '请求时间',
  time_used bigint(20) DEFAULT NULL COMMENT '耗时(ms)',
  server_id varchar(255) DEFAULT NULL COMMENT '服务器标识',
  vendor_code varchar(255) DEFAULT NULL COMMENT '厂商',
  algs_version varchar(255) DEFAULT NULL COMMENT '算法版本',
  tenant varchar(255) DEFAULT 'standard' COMMENT '租户',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  batch_date datetime DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id, received_time ) 
) PARTITION BY RANGE (TO_DAYS(received_time)) (
PARTITION p0 VALUES LESS THAN (0)
) ;
ALTER TABLE person_iris_match_his_log_tmp COMMENT '人员虹膜比对历史日志表';

call sp_create_partition(last_day(curdate()),@schemaName,'person_iris_match_his_log_tmp','%Y%m');
call sp_create_partition(date_sub(date_sub(date_format(now(),'%y-%m-%d'),interval extract(day from now()) day),interval -2 month),@schemaName,'person_iris_match_his_log_tmp','%Y%m');

SET @pddl = concat('alter table person_iris_match_his_log_tmp exchange partition p',DATE_FORMAT(now(),'%Y%m'), ' with table person_iris_match_his_log');
PREPARE stmt FROM @pddl;/*定义预处理语句*/
EXECUTE stmt;/*执行预处理语句*/
DEALLOCATE PREPARE stmt;/*释放预处理语句*/

drop table if exists person_iris_match_his_log;
alter table person_iris_match_his_log_tmp rename to person_iris_match_his_log;

/*==============================================================*/
/* 普通表转分区表(虹膜1：N历史日志表)	                            */
/*==============================================================*/
alter table person_iris_search_his_log drop primary key;
alter table person_iris_search_his_log add primary key ( id, received_time ) ;
DROP TABLE IF EXISTS person_iris_search_his_log_tmp;
CREATE TABLE person_iris_search_his_log_tmp (
  id varchar(48) NOT NULL COMMENT '主键',
  handle_seq varchar(48) NOT NULL COMMENT '平台流水号',
  received_seq varchar(48) NOT NULL COMMENT '业务流水号',
  scene_type varchar(1) NOT NULL COMMENT '类型(数据字典 1：基础信息入库1:N，2：比对搜索接口1:N)',
  unique_id varchar(48) DEFAULT NULL COMMENT '人员标识',
  dept_id bigint(20) DEFAULT NULL COMMENT '部门ID',
  channel_code varchar(255) DEFAULT NULL COMMENT '渠道编码',
  sub_treasury_code varchar(255) DEFAULT NULL COMMENT '分库编码',
  sub_treasury_name varchar(255) DEFAULT NULL COMMENT '分库名称',
  scene_left_image varchar(255) DEFAULT NULL COMMENT '现场左眼照路径',
  scene_right_image varchar(255) DEFAULT NULL COMMENT '现场右眼照路径',
  stock_left_image varchar(255) DEFAULT NULL COMMENT '底库左眼照路径',
  stock_right_image varchar(255) DEFAULT NULL COMMENT '底库右眼照路径',
  scene_lstock_score double DEFAULT NULL COMMENT '左眼现场照与库底库照比对分值',
  scene_lstock_result varchar(1) DEFAULT NULL COMMENT '左眼现场照与库底库照比对结果(0通过，1未通过)',
  scene_rstock_score double DEFAULT NULL COMMENT '右眼现场照与库底库照比对分值',
  scene_rstock_result varchar(1) DEFAULT NULL COMMENT '右眼现场照与库底库照比对结果(0通过，1未通过)',
  result varchar(1) DEFAULT NULL COMMENT '结果(0通过，1未通过)',
  result_strategy varchar(1) DEFAULT NULL COMMENT '结果策略(1:与， 2:或)',
  broker varchar(48) DEFAULT NULL COMMENT '交易发起人',
  received_time datetime NOT NULL COMMENT '请求时间',
  time_used bigint(20) DEFAULT NULL COMMENT '耗时(ms)',
  server_id varchar(255) DEFAULT NULL COMMENT '服务器标识',
  vendor_code varchar(255) DEFAULT NULL COMMENT '厂商',
  algs_version varchar(255) DEFAULT NULL COMMENT '算法版本',
  tenant varchar(255) DEFAULT 'standard' COMMENT '租户',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  batch_date datetime DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id, received_time ) 
) PARTITION BY RANGE (TO_DAYS(received_time)) (
PARTITION p0 VALUES LESS THAN (0)
) ;
ALTER TABLE person_iris_search_his_log_tmp COMMENT '人员虹膜搜索历史日志表';

call sp_create_partition(last_day(curdate()),@schemaName,'person_iris_search_his_log_tmp','%Y%m');
call sp_create_partition(date_sub(date_sub(date_format(now(),'%y-%m-%d'),interval extract(day from now()) day),interval -2 month),@schemaName,'person_iris_search_his_log_tmp','%Y%m');

SET @pddl = concat('alter table person_iris_search_his_log_tmp exchange partition p',DATE_FORMAT(now(),'%Y%m'), ' with table person_iris_search_his_log');
PREPARE stmt FROM @pddl;/*定义预处理语句*/
EXECUTE stmt;/*执行预处理语句*/
DEALLOCATE PREPARE stmt;/*释放预处理语句*/

drop table if exists person_iris_search_his_log;
alter table person_iris_search_his_log_tmp rename to person_iris_search_his_log;

-- ----------------------------
-- 渠道信息详情和接口历史报文信息菜单权限配置
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3384, '渠道管理_渠道信息详情', 3123, 6, '#', 'menuItem', 'F', '0', 'scene:info:detail', '#', 'admin', '2020-04-09 16:18:57', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3385, '历史报文', 108, 4, '/system/hisrecord', 'menuItem', 'C', '0', 'system:hisrecord:view', '#', 'admin', '2020-04-09 16:50:16', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3386, '历史报文查询', 3385, 1, '#', 'menuItem', 'F', '0', 'system:hisrecord:list', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:29:07', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3387, '历史报文新增', 3385, 2, '#', 'menuItem', 'F', '0', 'system:hisrecord:add', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:29:27', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3388, '历史报文修改', 3385, 3, '#', 'menuItem', 'F', '0', 'system:hisrecord:edit', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:29:43', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3389, '历史报文删除', 3385, 4, '#', 'menuItem', 'F', '0', 'system:hisrecord:remove', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:29:56', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3390, '历史报文导出', 3385, 5, '#', 'menuItem', 'F', '0', 'system:hisrecord:export', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:30:09', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3391, '历史报文详细', 3385, 6, '#', 'menuItem', 'F', '0', 'system:hisrecord:detail', '#', 'admin', '2019-11-07 17:30:56', '', NULL, '');


/*==============================================================*/
/* 接口报文日志定时任务	                            */
/*==============================================================*/
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (16, '接口报文历史数据分区维护', 'DEFAULT', 'requestRecordTask.clearAndAddPartition(\'biapwp\',15)', '0 0 0 * * ? *', '1', '1', '0', 'admin', '2020-04-10 10:46:11', 'admin', '2020-04-10 15:39:58', '每天凌晨00:00:00执行(第一个参数时数据库名，第二个参数是保留天数)\r\n注意：尽量不要修改这个cron表达式，否则可能导致历史日志存储失败');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (17, '接口报文日志迁移', 'DEFAULT', 'requestRecordTask.migrateRequestRecord()', '0 0 0 * * ? *', '1', '1', '0', 'admin', '2020-04-10 15:40:58', 'admin', '2020-04-10 15:41:27', '每天凌晨00:00:00迁移');
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME16', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B597419030000787077080000017161FAFD3878707400B8E6AF8FE5A4A9E5878CE699A830303A30303A3030E689A7E8A18C28E7ACACE4B880E4B8AAE58F82E695B0E697B6E695B0E68DAEE5BA93E5908DEFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE4BF9DE79599E5A4A9E695B0290D0AE6B3A8E6848FEFBC9AE5B0BDE9878FE4B88DE8A681E4BFAEE694B9E8BF99E4B8AA63726F6EE8A1A8E8BEBEE5BC8FEFBC8CE590A6E58899E58FAFE883BDE5AFBCE887B4E58E86E58FB2E697A5E5BF97E5AD98E582A8E5A4B1E8B4A57070707400013174000D3020302030202A202A203F202A740033726571756573745265636F72645461736B2E636C656172416E64416464506172746974696F6E2827626961707770272C31352974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000010740024E68EA5E58FA3E68AA5E69687E58E86E58FB2E695B0E68DAEE58886E58CBAE7BBB4E68AA474000131740001307800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME17', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001716308DF10787074001AE6AF8FE5A4A9E5878CE699A830303A30303A3030E8BF81E7A7BB7070707400013174000D3020302030202A202A203F202A740028726571756573745265636F72645461736B2E6D696772617465526571756573745265636F7264282974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000011740018E68EA5E58FA3E68AA5E69687E697A5E5BF97E8BF81E7A7BB74000131740001307800);
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME16', 'DEFAULT', 'TASK_CLASS_NAME16', 'DEFAULT', NULL, 1586534400000, -1, 5, 'WAITING', 'CRON', 1586510235000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME17', 'DEFAULT', 'TASK_CLASS_NAME17', 'DEFAULT', NULL, 1586534400000, -1, 5, 'WAITING', 'CRON', 1586510235000, 0, NULL, -1, '');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME16', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME17', 'DEFAULT', '0 0 0 * * ? *', 'Asia/Shanghai');

/*==============================================================*/
/* 清除比对历史日志定时任务	                            		*/
/*==============================================================*/
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (18, '维护和清理人脸1:1比对历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearFaceMatchLog(365,false,\'biapwp\')', '0 0 1 * * ? *', '1', '1', '0', 'admin', '2020-04-14 17:37:28', '', '2020-04-14 17:37:31', '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名）');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (19, '维护和清理人脸1:N搜索历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearFaceSearchLog(365,false,\'biapwp\')', '0 0 1 * * ? *', '1', '1', '0', 'admin', '2020-04-14 17:38:34', 'admin', '2020-04-14 17:41:02', '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名）');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (20, '维护和清理指纹1:1比对历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearFingerMatchLog(365,false,\'biapwp\')', '0 0 1 * * ? *', '1', '1', '0', 'admin', '2020-04-14 17:38:59', 'admin', '2020-04-14 17:41:05', '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名）');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (21, '维护和清理指纹1:N搜索历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearFingerSearchLog(365,false,\'biapwp\')', '0 0 1 * * ? *', '1', '1', '0', 'admin', '2020-04-14 17:39:24', 'admin', '2020-04-14 17:41:08', '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名）');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (22, '维护和清理虹膜1:1比对历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearIrisMatchLog(365,false,\'biapwp\')', '0 0 1 * * ? *', '1', '1', '0', 'admin', '2020-04-14 17:39:59', 'admin', '2020-04-14 17:41:10', '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名）');
INSERT INTO sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (23, '维护和清理虹膜1:N搜索历史日志', 'DEFAULT', 'clearBioMatchLogTask.clearIrisSearchLog(365,false,\'biapwp\')', '0 0 1 * * ? *', '1', '1', '0', 'admin', '2020-04-14 17:40:16', 'admin', '2020-04-14 17:41:13', '每天凌晨01:00:00执行（第一个参数是日志保留天数；第二个参数是是否只删除日志图片，true表示只删除服务器上的图片，保留日志；第三个参数表示数据库名）');

INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME18', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E70707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897070707400013174000D3020302031202A202A203F202A740031636C65617242696F4D617463684C6F675461736B2E636C656172466163654D617463684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000012740021E6B885E999A4E4BABAE884B8313A31E6AF94E5AFB9E58E86E58FB2E697A5E5BF9774000131740001317800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME19', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740032636C65617242696F4D617463684C6F675461736B2E636C656172466163655365617263684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000013740021E6B885E999A4E4BABAE884B8313A4EE6909CE7B4A2E58E86E58FB2E697A5E5BF9774000131740001307800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME20', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740033636C65617242696F4D617463684C6F675461736B2E636C65617246696E6765724D617463684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000014740021E6B885E999A4E68C87E7BAB9313A31E6AF94E5AFB9E58E86E58FB2E697A5E5BF9774000131740001307800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME21', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740034636C65617242696F4D617463684C6F675461736B2E636C65617246696E6765725365617263684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000015740021E6B885E999A4E68C87E7BAB9313A4EE6909CE7B4A2E58E86E58FB2E697A5E5BF9774000131740001307800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME22', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740031636C65617242696F4D617463684C6F675461736B2E636C656172497269734D617463684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000016740021E6B885E999A4E899B9E8869C313A31E6AF94E5AFB9E58E86E58FB2E697A5E5BF9774000131740001307800);
INSERT INTO qrtz_job_details(sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME23', 'DEFAULT', NULL, 'com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001E636F6D2E72756F79692E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E000978720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707070707400AEE6AF8FE5A4A9E5878CE699A830313A30303A3030E689A7E8A18CEFBC88E7ACACE4B880E4B8AAE58F82E695B0E698AFE697A5E5BF97E4BF9DE79599E5A4A9E695B0EFBC8CE7ACACE4BA8CE4B8AAE58F82E695B0E698AFE698AFE590A6E58FAAE588A0E999A4E697A5E5BF97E59BBEE78987EFBC8C74727565E8A1A8E7A4BAE58FAAE588A0E999A4E69C8DE58AA1E599A8E4B88AE79A84E59BBEE78987EFBC8CE4BF9DE79599E697A5E5BF97EFBC897074000561646D696E707400013174000D3020302031202A202A203F202A740032636C65617242696F4D617463684C6F675461736B2E636C656172497269735365617263684C6F67283336352C66616C73652974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000017740021E6B885E999A4E899B9E8869C313A4EE6909CE7B4A2E58E86E58FB2E697A5E5BF9774000131740001307800);
	
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME18', 'DEFAULT', 'TASK_CLASS_NAME18', 'DEFAULT', NULL, 1586883600000, -1, 5, 'WAITING', 'CRON', 1586857047000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME19', 'DEFAULT', 'TASK_CLASS_NAME19', 'DEFAULT', NULL, 1586883600000, -1, 5, 'WAITING', 'CRON', 1586857262000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME20', 'DEFAULT', 'TASK_CLASS_NAME20', 'DEFAULT', NULL, 1586883600000, -1, 5, 'WAITING', 'CRON', 1586857265000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME21', 'DEFAULT', 'TASK_CLASS_NAME21', 'DEFAULT', NULL, 1586883600000, -1, 5, 'WAITING', 'CRON', 1586857268000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME22', 'DEFAULT', 'TASK_CLASS_NAME22', 'DEFAULT', NULL, 1586883600000, -1, 5, 'WAITING', 'CRON', 1586857270000, 0, NULL, -1, '');
INSERT INTO qrtz_triggers(sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME23', 'DEFAULT', 'TASK_CLASS_NAME23', 'DEFAULT', NULL, 1586883600000, -1, 5, 'WAITING', 'CRON', 1586857273000, 0, NULL, -1, '');

INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME18', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME19', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME20', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME21', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME22', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
INSERT INTO qrtz_cron_triggers(sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME23', 'DEFAULT', '0 0 1 * * ? *', 'Asia/Shanghai');
