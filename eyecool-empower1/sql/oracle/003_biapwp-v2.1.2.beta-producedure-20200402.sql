-- ----------------------------
-- 创建表分区存储过程(按天或者按月分区)
-- par_name_format:'YYYYMMDD'或者'YYYYMM'
-- 按月区分，day_value要传入某个月的最后一天
-- ----------------------------
CREATE OR REPLACE
PROCEDURE sp_create_partition (day_value DATE, tb_name varchar2,par_name_format varchar2)
AS
	v_SqlExec VARCHAR2(2000); 
	v_PartName VARCHAR2(20);
	v_PartDateStr VARCHAR2(20);  
	v_ParExists INTEGER;
 begin
	v_ParExists := 0;
	v_PartName:= 'p_'||to_char(day_value,par_name_format);
	v_PartDateStr:= to_char(day_value + 1, 'YYYY-MM-DD');
	SELECT COUNT(*) INTO v_ParExists FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = upper(tb_name) AND PARTITION_NAME = upper(v_PartName);
	IF v_ParExists=0 THEN
	  v_SqlExec:='alter table '||tb_name||' add PARTITION ' || v_PartName || ' VALUES LESS THAN (to_date('''||v_PartDateStr||''',''YYYY-MM-DD''))';
    DBMS_Utility.Exec_DDL_Statement(v_SqlExec);
	END IF;
 END sp_create_partition;