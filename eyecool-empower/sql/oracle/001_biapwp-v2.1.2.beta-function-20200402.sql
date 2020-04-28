/*=============================================================*/ 
/* 删除对象函数（drop if exists                                */
/*==============================================================*/
CREATE 
	OR REPLACE PROCEDURE proc_dropifexists ( p_table IN varchar2 ) IS v_count number ( 10 );
BEGIN
SELECT
	count( * ) INTO v_count 
FROM
	user_tables 
WHERE
	table_name = upper( p_table );
IF
	v_count > 0 THEN
	EXECUTE immediate 'drop table ' || p_table || ' purge';

END IF;
END proc_dropifexists;