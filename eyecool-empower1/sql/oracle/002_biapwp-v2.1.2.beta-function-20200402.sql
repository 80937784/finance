/*===========================================================================*/
/* 函数 ，代替mysql的find_in_set																						 */
/* 例如： select * from sys_dept where FIND_IN_SET (101,ancestors) <> 0			 */
/*  mysql可接受0或其它number做为where 条件，oracle只接受表达式做为where 条件 */
/*===========================================================================*/
CREATE 
	OR REPLACE FUNCTION find_in_set( arg1 IN varchar2, arg2 IN VARCHAR ) RETURN number IS Result number;
BEGIN
	SELECT
		instr( ',' || arg2 || ',', ',' || arg1 || ',' ) INTO Result 
	FROM
		DUAL;
	RETURN ( Result );

END find_in_set;