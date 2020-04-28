-- ----------------------------
-- 删除表分区存储过程,用于删除过期分区(按天或者按月分区)
-- par_name_format:'YYYYMMDD'或者'YYYYMM'
-- 按月区分，day_value要传入某个月的最后一天
-- ----------------------------
CREATE OR REPLACE
PROCEDURE sp_drop_partition(day_value DATE, tb_name varchar2,par_name_format varchar2) 
AS
 v_SqlExec VARCHAR2(2000);
 cursor cursor_part is
 select partition_name from user_tab_partitions
 WHERE table_name= upper(tb_name) AND SUBSTR(partition_name,3) < to_char(day_value, par_name_format) order by partition_position, partition_name;
 cursor_oldpart cursor_part%rowType;
 begin
 open cursor_part;
   loop
   fetch cursor_part into cursor_oldpart;
   exit when cursor_part%notfound;
   v_sqlexec:='ALTER TABLE '|| tb_name ||' DROP PARTITION '||cursor_oldpart.partition_name;
   DBMS_Utility.Exec_DDL_Statement(v_SqlExec);
   end loop;
   close cursor_part;
 END sp_drop_partition;