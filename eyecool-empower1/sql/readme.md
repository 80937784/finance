# SQL文件命名和同步说明

> 智慧园区生物识别身份认证平台

## 1、命名规范说明

​	  序号_biapwp-系统版本-功能说明-日期.sql

​      例如: 001_biapwp-v2.0.0.beat-init-20191224.sql

## 2、版本SQL同步说明

​		(1) 在进行SQL同步时，从升级之前版本的下一个版本的第一个SQL文件开始同步，依次同步到更新版本的		最后一个SQL文件截止即可。

​		(2) 一般当前部署包的最后一个SQL脚本即为当前版本的最后一个脚本，SQL脚本版本号<=当前版本号！

​		(3) 举例说明,SQL脚本列表如下

​	   			001_biapwp-v2.0.0.beat-quartz_20191223.sql

​				   002_biapwp-v2.0.0.beat-initSysData_20191223.sql

​				   003_biapwp-v2.0.1.beat-addMenu_20191224.sql

​				   004_biapwp-v2.0.2.beat-addDictData_20191224.sql

​				   005_biapwp-v2.0.2.beat-addDictData_20191224.sql

​				   006_biapwp-v2.0.3.beat-addSysConfig_20191224.sql

​                   007_biapwp-v2.0.3.beat-addDictData_20191224.sql

​         更新的系统版本为v2.0.1 -> v2.0.3, 则：

​    			从v2.0.2版本对应的第一个SQL【004_biapwp-v2.0.2.beat-addDictData_20191224.sql】 开始同步，

​				同步到v2.0.3版本对应的最后一个SQL【007_biapwp-v2.0.3.beat-addDictData_20191224.sql】即可\

## 3、 特殊脚本说明

​          (1)、MYSQL数据库脚本006_biapwp_v2.1.2.beta-init-20200415.sql在执行前需要确认数据库名称是否和脚				  本第一行默认的名称一致，不一致需要修改为实际的数据库名称。

​		  (2)、Oracle数据库脚本001~004必须单个有序执行，不允许复制到一个文件执行，否则可能导致失败。

