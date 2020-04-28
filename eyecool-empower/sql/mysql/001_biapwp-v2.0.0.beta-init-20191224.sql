-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
drop table if exists QRTZ_JOB_DETAILS;
create table QRTZ_JOB_DETAILS (
    sched_name           varchar(100)    not null,
    job_name             varchar(150)    not null,
    job_group            varchar(100)    not null,
    description          varchar(250)    null,
    job_class_name       varchar(250)    not null,
    is_durable           varchar(1)      not null,
    is_nonconcurrent     varchar(1)      not null,
    is_update_data       varchar(1)      not null,
    requests_recovery    varchar(1)      not null,
    job_data             blob            null,
    primary key (sched_name,job_name,job_group)
) engine=innodb;

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
drop table if exists QRTZ_TRIGGERS;
create table QRTZ_TRIGGERS (
    sched_name           varchar(100)    not null,
    trigger_name         varchar(150)    not null,
    trigger_group        varchar(100)    not null,
    job_name             varchar(150)    not null,
    job_group            varchar(100)    not null,
    description          varchar(250)    null,
    next_fire_time       bigint(13)      null,
    prev_fire_time       bigint(13)      null,
    priority             integer         null,
    trigger_state        varchar(16)     not null,
    trigger_type         varchar(8)      not null,
    start_time           bigint(13)      not null,
    end_time             bigint(13)      null,
    calendar_name        varchar(200)    null,
    misfire_instr        smallint(2)     null,
    job_data             blob            null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,job_name,job_group) references QRTZ_JOB_DETAILS(sched_name,job_name,job_group)
) engine=innodb;

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
drop table if exists QRTZ_SIMPLE_TRIGGERS;
create table QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(100)    not null,
    trigger_name         varchar(150)    not null,
    trigger_group        varchar(100)    not null,
    repeat_count         bigint(7)       not null,
    repeat_interval      bigint(12)      not null,
    times_triggered      bigint(10)      not null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ---------------------------- 
drop table if exists QRTZ_CRON_TRIGGERS;
create table QRTZ_CRON_TRIGGERS (
    sched_name           varchar(100)    not null,
    trigger_name         varchar(150)    not null,
    trigger_group        varchar(100)    not null,
    cron_expression      varchar(200)    not null,
    time_zone_id         varchar(80),
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ---------------------------- 
drop table if exists QRTZ_BLOB_TRIGGERS;
create table QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(100)    not null,
    trigger_name         varchar(150)    not null,
    trigger_group        varchar(100)    not null,
    blob_data            blob            null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ---------------------------- 
drop table if exists QRTZ_CALENDARS;
create table QRTZ_CALENDARS (
    sched_name           varchar(100)    not null,
    calendar_name        varchar(150)    not null,
    calendar             blob            not null,
    primary key (sched_name,calendar_name)
) engine=innodb;

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ---------------------------- 
drop table if exists QRTZ_PAUSED_TRIGGER_GRPS;
create table QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(100)    not null,
    trigger_group        varchar(100)    not null,
    primary key (sched_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ---------------------------- 
drop table if exists QRTZ_FIRED_TRIGGERS;
create table QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(100)    not null,
    entry_id             varchar(95)     not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    instance_name        varchar(200)    not null,
    fired_time           bigint(13)      not null,
    sched_time           bigint(13)      not null,
    priority             integer         not null,
    state                varchar(16)     not null,
    job_name             varchar(200)    null,
    job_group            varchar(200)    null,
    is_nonconcurrent     varchar(1)      null,
    requests_recovery    varchar(1)      null,
    primary key (sched_name,entry_id)
) engine=innodb;

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ---------------------------- 
drop table if exists QRTZ_SCHEDULER_STATE; 
create table QRTZ_SCHEDULER_STATE (
    sched_name           varchar(100)    not null,
    instance_name        varchar(150)    not null,
    last_checkin_time    bigint(13)      not null,
    checkin_interval     bigint(13)      not null,
    primary key (sched_name,instance_name)
) engine=innodb;

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ---------------------------- 
drop table if exists QRTZ_LOCKS;
create table QRTZ_LOCKS (
    sched_name           varchar(120)    not null,
    lock_name            varchar(40)     not null,
    primary key (sched_name,lock_name)
) engine=innodb;

drop table if exists QRTZ_SIMPROP_TRIGGERS;
create table QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(100)    not null,
    trigger_name         varchar(150)    not null,
    trigger_group        varchar(100)    not null,
    str_prop_1           varchar(512)    null,
    str_prop_2           varchar(512)    null,
    str_prop_3           varchar(512)    null,
    int_prop_1           int             null,
    int_prop_2           int             null,
    long_prop_1          bigint          null,
    long_prop_2          bigint          null,
    dec_prop_1           numeric(13,4)   null,
    dec_prop_2           numeric(13,4)   null,
    bool_prop_1          varchar(1)      null,
    bool_prop_2          varchar(1)      null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb;

-- ----------------------------
-- 11、部门表
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  dept_id           bigint(20)      not null auto_increment    comment '部门id',
  parent_id         bigint(20)      default 0                  comment '父部门id',
  ancestors         varchar(50)     default ''                 comment '祖级列表',
  dept_name         varchar(30)     default ''                 comment '部门名称',
  order_num         int(4)          default 0                  comment '显示顺序',
  leader            varchar(20)     default null               comment '负责人',
  phone             varchar(11)     default null               comment '联系电话',
  email             varchar(50)     default null               comment '邮箱',
  status            char(1)         default '0'                comment '部门状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (dept_id)
) engine=innodb auto_increment=200 comment = '部门表';

-- ----------------------------
-- 12、初始化-部门表数据
-- ----------------------------
insert into sys_dept values(100,  0,   '0',          '眼神科技',   0, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(101,  100, '0,100',      '深圳总公司', 1, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(102,  100, '0,100',      '长沙分公司', 2, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(103,  101, '0,100,101',  '研发部门',   1, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(104,  101, '0,100,101',  '市场部门',   2, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(105,  101, '0,100,101',  '测试部门',   3, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(106,  101, '0,100,101',  '财务部门',   4, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(107,  101, '0,100,101',  '运维部门',   5, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(108,  102, '0,100,102',  '市场部门',   1, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');
insert into sys_dept values(109,  102, '0,100,102',  '财务部门',   2, '眼神', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00');


-- ----------------------------
-- 13、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id           bigint(20)      not null auto_increment    comment '用户ID',
  dept_id           bigint(20)      default null               comment '部门ID',
  login_name        varchar(30)     not null                   comment '登录账号',
  user_name         varchar(30)     not null                   comment '用户昵称',
  user_type         varchar(2)      default '00'               comment '用户类型（00系统用户）',
  email             varchar(50)     default ''                 comment '用户邮箱',
  phonenumber       varchar(11)     default ''                 comment '手机号码',
  sex               char(1)         default '0'                comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100)    default ''                 comment '头像路径',
  password          varchar(50)     default ''                 comment '密码',
  salt              varchar(20)     default ''                 comment '盐加密',
  status            char(1)         default '0'                comment '帐号状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(50)     default ''                 comment '最后登陆IP',
  login_date        datetime                                   comment '最后登陆时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (user_id)
) engine=innodb auto_increment=100 comment = '用户信息表';

-- ----------------------------
-- 14、初始化-用户信息表数据
-- ----------------------------
insert into sys_user values(1,  103, 'admin', '眼神', '00', 'ry@163.com', '15888888888', '1', '', '29c67a30398638269fe600f73a054934', '111111', '0', '0', '127.0.0.1', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '管理员');
insert into sys_user values(2,  105, 'ry',    '眼神', '00', 'ry@qq.com',  '15666666666', '1', '', '8e6d98b90472783cc73c17047ddccf36', '222222', '0', '0', '127.0.0.1', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '测试员');


-- ----------------------------
-- 15、岗位信息表
-- ----------------------------
drop table if exists sys_post;
create table sys_post
(
  post_id       bigint(20)      not null auto_increment    comment '岗位ID',
  post_code     varchar(64)     not null                   comment '岗位编码',
  post_name     varchar(50)     not null                   comment '岗位名称',
  post_sort     int(4)          not null                   comment '显示顺序',
  status        char(1)         not null                   comment '状态（0正常 1停用）',
  create_by     varchar(64)     default ''                 comment '创建者',
  create_time   datetime                                   comment '创建时间',
  update_by     varchar(64)     default ''			       comment '更新者',
  update_time   datetime                                   comment '更新时间',
  remark        varchar(500)    default null               comment '备注',
  primary key (post_id)
) engine=innodb comment = '岗位信息表';

-- ----------------------------
-- 16、初始化-岗位信息表数据
-- ----------------------------
insert into sys_post values(1, 'ceo',  '董事长',    1, '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_post values(2, 'se',   '项目经理',  2, '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_post values(3, 'hr',   '人力资源',  3, '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_post values(4, 'user', '普通员工',  4, '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');


-- ----------------------------
-- 17、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id           bigint(20)      not null auto_increment    comment '角色ID',
  role_name         varchar(30)     not null                   comment '角色名称',
  role_key          varchar(100)    not null                   comment '角色权限字符串',
  role_sort         int(4)          not null                   comment '显示顺序',
  data_scope        char(1)         default '1'                comment '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  status            char(1)         not null                   comment '角色状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (role_id)
) engine=innodb auto_increment=100 comment = '角色信息表';

-- ----------------------------
-- 18、初始化-角色信息表数据
-- ----------------------------
insert into sys_role values('1', '管理员',   'admin',  1, 1, '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '管理员');
insert into sys_role values('2', '普通角色', 'common', 2, 2, '0', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '普通角色');


-- ----------------------------
-- 19、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id           bigint(20)      not null auto_increment    comment '菜单ID',
  menu_name         varchar(50)     not null                   comment '菜单名称',
  parent_id         bigint(20)      default 0                  comment '父菜单ID',
  order_num         int(4)          default 0                  comment '显示顺序',
  url               varchar(200)    default '#'                comment '请求地址',
  target            varchar(20)     default ''                 comment '打开方式（menuItem页签 menuBlank新窗口）',
  menu_type         char(1)         default ''                 comment '菜单类型（M目录 C菜单 F按钮）',
  visible           char(1)         default 0                  comment '菜单状态（0显示 1隐藏）',
  perms             varchar(100)    default null               comment '权限标识',
  icon              varchar(100)    default '#'                comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (menu_id)
) engine=innodb auto_increment=2000 comment = '菜单权限表';

-- ----------------------------
-- 20、初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
insert into sys_menu values('1', '系统管理', '0', '1', '#', '', 'M', '0', '', 'fa fa-gear',         'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统管理目录');
insert into sys_menu values('2', '系统监控', '0', '2', '#', '', 'M', '0', '', 'fa fa-video-camera', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统监控目录');
insert into sys_menu values('3', '系统工具', '0', '3', '#', '', 'M', '0', '', 'fa fa-bars',         'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统工具目录');
-- 二级菜单
insert into sys_menu values('100',  '用户管理', '1', '1', '/system/user',          '', 'C', '0', 'system:user:view',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '用户管理菜单');
insert into sys_menu values('101',  '角色管理', '1', '2', '/system/role',          '', 'C', '0', 'system:role:view',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '角色管理菜单');
insert into sys_menu values('102',  '菜单管理', '1', '3', '/system/menu',          '', 'C', '0', 'system:menu:view',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '菜单管理菜单');
insert into sys_menu values('103',  '部门管理', '1', '4', '/system/dept',          '', 'C', '0', 'system:dept:view',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '部门管理菜单');
insert into sys_menu values('104',  '岗位管理', '1', '5', '/system/post',          '', 'C', '0', 'system:post:view',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '岗位管理菜单');
insert into sys_menu values('105',  '字典管理', '1', '6', '/system/dict',          '', 'C', '0', 'system:dict:view',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '字典管理菜单');
insert into sys_menu values('106',  '参数设置', '1', '7', '/system/config',        '', 'C', '0', 'system:config:view',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '参数设置菜单');
insert into sys_menu values('107',  '通知公告', '1', '8', '/system/notice',        '', 'C', '0', 'system:notice:view',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '通知公告菜单');
insert into sys_menu values('108',  '日志管理', '1', '9', '#',                     '', 'M', '0', '',                         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '日志管理菜单');
insert into sys_menu values('109',  '在线用户', '2', '1', '/monitor/online',       '', 'C', '0', 'monitor:online:view',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '在线用户菜单');
insert into sys_menu values('110',  '定时任务', '2', '2', '/monitor/job',          '', 'C', '0', 'monitor:job:view',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '定时任务菜单');
insert into sys_menu values('111',  '数据监控', '2', '3', '/monitor/data',         '', 'C', '0', 'monitor:data:view',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '数据监控菜单');
insert into sys_menu values('112',  '服务监控', '2', '3', '/monitor/server',       '', 'C', '0', 'monitor:server:view',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '服务监控菜单');
insert into sys_menu values('113',  '表单构建', '3', '1', '/tool/build',           '', 'C', '0', 'tool:build:view',          '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '表单构建菜单');
insert into sys_menu values('114',  '代码生成', '3', '2', '/tool/gen',             '', 'C', '0', 'tool:gen:view',            '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '代码生成菜单');
insert into sys_menu values('115',  '系统接口', '3', '3', '/tool/swagger',         '', 'C', '0', 'tool:swagger:view',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统接口菜单');
-- 三级菜单
insert into sys_menu values('500',  '操作日志', '108', '1', '/monitor/operlog',    '', 'C', '0', 'monitor:operlog:view',     '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '操作日志菜单');
insert into sys_menu values('501',  '登录日志', '108', '2', '/monitor/logininfor', '', 'C', '0', 'monitor:logininfor:view',  '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '登录日志菜单');
-- 用户管理按钮
insert into sys_menu values('1000', '用户查询', '100', '1',  '#', '',  'F', '0', 'system:user:list',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1001', '用户新增', '100', '2',  '#', '',  'F', '0', 'system:user:add',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1002', '用户修改', '100', '3',  '#', '',  'F', '0', 'system:user:edit',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1003', '用户删除', '100', '4',  '#', '',  'F', '0', 'system:user:remove',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1004', '用户导出', '100', '5',  '#', '',  'F', '0', 'system:user:export',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1005', '用户导入', '100', '6',  '#', '',  'F', '0', 'system:user:import',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1006', '重置密码', '100', '7',  '#', '',  'F', '0', 'system:user:resetPwd',    '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 角色管理按钮
insert into sys_menu values('1007', '角色查询', '101', '1',  '#', '',  'F', '0', 'system:role:list',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1008', '角色新增', '101', '2',  '#', '',  'F', '0', 'system:role:add',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1009', '角色修改', '101', '3',  '#', '',  'F', '0', 'system:role:edit',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1010', '角色删除', '101', '4',  '#', '',  'F', '0', 'system:role:remove',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1011', '角色导出', '101', '5',  '#', '',  'F', '0', 'system:role:export',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 菜单管理按钮
insert into sys_menu values('1012', '菜单查询', '102', '1',  '#', '',  'F', '0', 'system:menu:list',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1013', '菜单新增', '102', '2',  '#', '',  'F', '0', 'system:menu:add',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1014', '菜单修改', '102', '3',  '#', '',  'F', '0', 'system:menu:edit',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1015', '菜单删除', '102', '4',  '#', '',  'F', '0', 'system:menu:remove',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 部门管理按钮
insert into sys_menu values('1016', '部门查询', '103', '1',  '#', '',  'F', '0', 'system:dept:list',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1017', '部门新增', '103', '2',  '#', '',  'F', '0', 'system:dept:add',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1018', '部门修改', '103', '3',  '#', '',  'F', '0', 'system:dept:edit',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1019', '部门删除', '103', '4',  '#', '',  'F', '0', 'system:dept:remove',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 岗位管理按钮
insert into sys_menu values('1020', '岗位查询', '104', '1',  '#', '',  'F', '0', 'system:post:list',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1021', '岗位新增', '104', '2',  '#', '',  'F', '0', 'system:post:add',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1022', '岗位修改', '104', '3',  '#', '',  'F', '0', 'system:post:edit',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1023', '岗位删除', '104', '4',  '#', '',  'F', '0', 'system:post:remove',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1024', '岗位导出', '104', '5',  '#', '',  'F', '0', 'system:post:export',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 字典管理按钮
insert into sys_menu values('1025', '字典查询', '105', '1', '#', '',  'F', '0', 'system:dict:list',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1026', '字典新增', '105', '2', '#', '',  'F', '0', 'system:dict:add',          '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1027', '字典修改', '105', '3', '#', '',  'F', '0', 'system:dict:edit',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1028', '字典删除', '105', '4', '#', '',  'F', '0', 'system:dict:remove',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1029', '字典导出', '105', '5', '#', '',  'F', '0', 'system:dict:export',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 参数设置按钮
insert into sys_menu values('1030', '参数查询', '106', '1', '#', '',  'F', '0', 'system:config:list',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1031', '参数新增', '106', '2', '#', '',  'F', '0', 'system:config:add',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1032', '参数修改', '106', '3', '#', '',  'F', '0', 'system:config:edit',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1033', '参数删除', '106', '4', '#', '',  'F', '0', 'system:config:remove',    '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1034', '参数导出', '106', '5', '#', '',  'F', '0', 'system:config:export',    '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 通知公告按钮
insert into sys_menu values('1035', '公告查询', '107', '1', '#', '',  'F', '0', 'system:notice:list',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1036', '公告新增', '107', '2', '#', '',  'F', '0', 'system:notice:add',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1037', '公告修改', '107', '3', '#', '',  'F', '0', 'system:notice:edit',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1038', '公告删除', '107', '4', '#', '',  'F', '0', 'system:notice:remove',    '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 操作日志按钮
insert into sys_menu values('1039', '操作查询', '500', '1', '#', '',  'F', '0', 'monitor:operlog:list',    '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1040', '操作删除', '500', '2', '#', '',  'F', '0', 'monitor:operlog:remove',  '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1041', '详细信息', '500', '3', '#', '',  'F', '0', 'monitor:operlog:detail',  '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1042', '日志导出', '500', '4', '#', '',  'F', '0', 'monitor:operlog:export',  '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 登录日志按钮
insert into sys_menu values('1043', '登录查询', '501', '1', '#', '',  'F', '0', 'monitor:logininfor:list',         '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1044', '登录删除', '501', '2', '#', '',  'F', '0', 'monitor:logininfor:remove',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1045', '日志导出', '501', '3', '#', '',  'F', '0', 'monitor:logininfor:export',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1046', '账户解锁', '501', '4', '#', '',  'F', '0', 'monitor:logininfor:unlock',       '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 在线用户按钮
insert into sys_menu values('1047', '在线查询', '109', '1', '#', '',  'F', '0', 'monitor:online:list',             '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1048', '批量强退', '109', '2', '#', '',  'F', '0', 'monitor:online:batchForceLogout', '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1049', '单条强退', '109', '3', '#', '',  'F', '0', 'monitor:online:forceLogout',      '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 定时任务按钮
insert into sys_menu values('1050', '任务查询', '110', '1', '#', '',  'F', '0', 'monitor:job:list',                '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1051', '任务新增', '110', '2', '#', '',  'F', '0', 'monitor:job:add',                 '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1052', '任务修改', '110', '3', '#', '',  'F', '0', 'monitor:job:edit',                '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1053', '任务删除', '110', '4', '#', '',  'F', '0', 'monitor:job:remove',              '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1054', '状态修改', '110', '5', '#', '',  'F', '0', 'monitor:job:changeStatus',        '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1055', '任务详细', '110', '6', '#', '',  'F', '0', 'monitor:job:detail',              '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1056', '任务导出', '110', '7', '#', '',  'F', '0', 'monitor:job:export',              '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
-- 代码生成按钮
insert into sys_menu values('1057', '生成查询', '114', '1', '#', '',  'F', '0', 'tool:gen:list',     '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1058', '生成修改', '114', '2', '#', '',  'F', '0', 'tool:gen:edit',     '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1059', '生成删除', '114', '3', '#', '',  'F', '0', 'tool:gen:remove',   '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1060', '预览代码', '114', '4', '#', '',  'F', '0', 'tool:gen:preview',  '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_menu values('1061', '生成代码', '114', '5', '#', '',  'F', '0', 'tool:gen:code',     '#', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');


-- ----------------------------
-- 21、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id   bigint(20) not null comment '用户ID',
  role_id   bigint(20) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb comment = '用户和角色关联表';

-- ----------------------------
-- 22、初始化-用户和角色关联表数据
-- ----------------------------
insert into sys_user_role values ('1', '1');
insert into sys_user_role values ('2', '2');


-- ----------------------------
-- 23、角色和菜单关联表  角色1-N菜单
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id   bigint(20) not null comment '角色ID',
  menu_id   bigint(20) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb comment = '角色和菜单关联表';

-- ----------------------------
-- 24、初始化-角色和菜单关联表数据
-- ----------------------------
insert into sys_role_menu values ('2', '1');
insert into sys_role_menu values ('2', '2');
insert into sys_role_menu values ('2', '3');
insert into sys_role_menu values ('2', '100');
insert into sys_role_menu values ('2', '101');
insert into sys_role_menu values ('2', '102');
insert into sys_role_menu values ('2', '103');
insert into sys_role_menu values ('2', '104');
insert into sys_role_menu values ('2', '105');
insert into sys_role_menu values ('2', '106');
insert into sys_role_menu values ('2', '107');
insert into sys_role_menu values ('2', '108');
insert into sys_role_menu values ('2', '109');
insert into sys_role_menu values ('2', '110');
insert into sys_role_menu values ('2', '111');
insert into sys_role_menu values ('2', '112');
insert into sys_role_menu values ('2', '113');
insert into sys_role_menu values ('2', '114');
insert into sys_role_menu values ('2', '115');
insert into sys_role_menu values ('2', '500');
insert into sys_role_menu values ('2', '501');
insert into sys_role_menu values ('2', '1000');
insert into sys_role_menu values ('2', '1001');
insert into sys_role_menu values ('2', '1002');
insert into sys_role_menu values ('2', '1003');
insert into sys_role_menu values ('2', '1004');
insert into sys_role_menu values ('2', '1005');
insert into sys_role_menu values ('2', '1006');
insert into sys_role_menu values ('2', '1007');
insert into sys_role_menu values ('2', '1008');
insert into sys_role_menu values ('2', '1009');
insert into sys_role_menu values ('2', '1010');
insert into sys_role_menu values ('2', '1011');
insert into sys_role_menu values ('2', '1012');
insert into sys_role_menu values ('2', '1013');
insert into sys_role_menu values ('2', '1014');
insert into sys_role_menu values ('2', '1015');
insert into sys_role_menu values ('2', '1016');
insert into sys_role_menu values ('2', '1017');
insert into sys_role_menu values ('2', '1018');
insert into sys_role_menu values ('2', '1019');
insert into sys_role_menu values ('2', '1020');
insert into sys_role_menu values ('2', '1021');
insert into sys_role_menu values ('2', '1022');
insert into sys_role_menu values ('2', '1023');
insert into sys_role_menu values ('2', '1024');
insert into sys_role_menu values ('2', '1025');
insert into sys_role_menu values ('2', '1026');
insert into sys_role_menu values ('2', '1027');
insert into sys_role_menu values ('2', '1028');
insert into sys_role_menu values ('2', '1029');
insert into sys_role_menu values ('2', '1030');
insert into sys_role_menu values ('2', '1031');
insert into sys_role_menu values ('2', '1032');
insert into sys_role_menu values ('2', '1033');
insert into sys_role_menu values ('2', '1034');
insert into sys_role_menu values ('2', '1035');
insert into sys_role_menu values ('2', '1036');
insert into sys_role_menu values ('2', '1037');
insert into sys_role_menu values ('2', '1038');
insert into sys_role_menu values ('2', '1039');
insert into sys_role_menu values ('2', '1040');
insert into sys_role_menu values ('2', '1041');
insert into sys_role_menu values ('2', '1042');
insert into sys_role_menu values ('2', '1043');
insert into sys_role_menu values ('2', '1044');
insert into sys_role_menu values ('2', '1045');
insert into sys_role_menu values ('2', '1046');
insert into sys_role_menu values ('2', '1047');
insert into sys_role_menu values ('2', '1048');
insert into sys_role_menu values ('2', '1049');
insert into sys_role_menu values ('2', '1050');
insert into sys_role_menu values ('2', '1051');
insert into sys_role_menu values ('2', '1052');
insert into sys_role_menu values ('2', '1053');
insert into sys_role_menu values ('2', '1054');
insert into sys_role_menu values ('2', '1055');
insert into sys_role_menu values ('2', '1056');
insert into sys_role_menu values ('2', '1057');
insert into sys_role_menu values ('2', '1058');
insert into sys_role_menu values ('2', '1059');
insert into sys_role_menu values ('2', '1060');
insert into sys_role_menu values ('2', '1061');

-- ----------------------------
-- 25、角色和部门关联表  角色1-N部门
-- ----------------------------
drop table if exists sys_role_dept;
create table sys_role_dept (
  role_id   bigint(20) not null comment '角色ID',
  dept_id   bigint(20) not null comment '部门ID',
  primary key(role_id, dept_id)
) engine=innodb comment = '角色和部门关联表';

-- ----------------------------
-- 26、初始化-角色和部门关联表数据
-- ----------------------------
insert into sys_role_dept values ('2', '100');
insert into sys_role_dept values ('2', '101');
insert into sys_role_dept values ('2', '105');

-- ----------------------------
-- 27、用户与岗位关联表  用户1-N岗位
-- ----------------------------
drop table if exists sys_user_post;
create table sys_user_post
(
  user_id   bigint(20) not null comment '用户ID',
  post_id   bigint(20) not null comment '岗位ID',
  primary key (user_id, post_id)
) engine=innodb comment = '用户与岗位关联表';

-- ----------------------------
-- 28、初始化-用户与岗位关联表数据
-- ----------------------------
insert into sys_user_post values ('1', '1');
insert into sys_user_post values ('2', '2');


-- ----------------------------
-- 29、操作日志记录
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  oper_id           bigint(20)      not null auto_increment    comment '日志主键',
  title             varchar(50)     default ''                 comment '模块标题',
  business_type     int(2)          default 0                  comment '业务类型（0其它 1新增 2修改 3删除）',
  method            varchar(100)    default ''                 comment '方法名称',
  request_method    varchar(10)     default ''                 comment '请求方式',
  operator_type     int(1)          default 0                  comment '操作类别（0其它 1后台用户 2手机端用户）',
  oper_name         varchar(50)     default ''                 comment '操作人员',
  dept_name         varchar(50)     default ''                 comment '部门名称',
  oper_url          varchar(255)    default ''                 comment '请求URL',
  oper_ip           varchar(50)     default ''                 comment '主机地址',
  oper_location     varchar(255)    default ''                 comment '操作地点',
  oper_param        varchar(2000)   default ''                 comment '请求参数',
  json_result       varchar(2000)   default ''                 comment '返回参数',
  status            int(1)          default 0                  comment '操作状态（0正常 1异常）',
  error_msg         varchar(2000)   default ''                 comment '错误消息',
  oper_time         datetime                                   comment '操作时间',
  primary key (oper_id)
) engine=innodb auto_increment=100 comment = '操作日志记录';


-- ----------------------------
-- 30、字典类型表
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
  dict_id          bigint(20)      not null auto_increment    comment '字典主键',
  dict_name        varchar(100)    default ''                 comment '字典名称',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_id),
  unique (dict_type)
) engine=innodb auto_increment=100 comment = '字典类型表';

insert into sys_dict_type values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '用户性别列表');
insert into sys_dict_type values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '菜单状态列表');
insert into sys_dict_type values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统开关列表');
insert into sys_dict_type values(4,  '任务状态', 'sys_job_status',      '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '任务状态列表');
insert into sys_dict_type values(5,  '任务分组', 'sys_job_group',       '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '任务分组列表');
insert into sys_dict_type values(6,  '系统是否', 'sys_yes_no',          '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统是否列表');
insert into sys_dict_type values(7,  '通知类型', 'sys_notice_type',     '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '通知类型列表');
insert into sys_dict_type values(8,  '通知状态', 'sys_notice_status',   '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '通知状态列表');
insert into sys_dict_type values(9,  '操作类型', 'sys_oper_type',       '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '操作类型列表');
insert into sys_dict_type values(10, '系统状态', 'sys_common_status',   '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '登录状态列表');


-- ----------------------------
-- 31、字典数据表
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
  dict_code        bigint(20)      not null auto_increment    comment '字典编码',
  dict_sort        int(4)          default 0                  comment '字典排序',
  dict_label       varchar(100)    default ''                 comment '字典标签',
  dict_value       varchar(100)    default ''                 comment '字典键值',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  css_class        varchar(100)    default null               comment '样式属性（其他样式扩展）',
  list_class       varchar(100)    default null               comment '表格回显样式',
  is_default       char(1)         default 'N'                comment '是否默认（Y是 N否）',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_code)
) engine=innodb auto_increment=100 comment = '字典数据表';

insert into sys_dict_data values(1,  1,  '男',       '0',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '性别男');
insert into sys_dict_data values(2,  2,  '女',       '1',       'sys_user_sex',        '',   '',        'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '性别女');
insert into sys_dict_data values(3,  3,  '未知',     '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '性别未知');
insert into sys_dict_data values(4,  1,  '显示',     '0',       'sys_show_hide',       '',   'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '显示菜单');
insert into sys_dict_data values(5,  2,  '隐藏',     '1',       'sys_show_hide',       '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '隐藏菜单');
insert into sys_dict_data values(6,  1,  '正常',     '0',       'sys_normal_disable',  '',   'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(7,  2,  '停用',     '1',       'sys_normal_disable',  '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '停用状态');
insert into sys_dict_data values(8,  1,  '正常',     '0',       'sys_job_status',      '',   'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(9,  2,  '暂停',     '1',       'sys_job_status',      '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '停用状态');
insert into sys_dict_data values(10, 1,  '默认',     'DEFAULT', 'sys_job_group',       '',   '',        'Y', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '默认分组');
insert into sys_dict_data values(11, 2,  '系统',     'SYSTEM',  'sys_job_group',       '',   '',        'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统分组');
insert into sys_dict_data values(12, 1,  '是',       'Y',       'sys_yes_no',          '',   'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统默认是');
insert into sys_dict_data values(13, 2,  '否',       'N',       'sys_yes_no',          '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '系统默认否');
insert into sys_dict_data values(14, 1,  '通知',     '1',       'sys_notice_type',     '',   'warning', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '通知');
insert into sys_dict_data values(15, 2,  '公告',     '2',       'sys_notice_type',     '',   'success', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '公告');
insert into sys_dict_data values(16, 1,  '正常',     '0',       'sys_notice_status',   '',   'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(17, 2,  '关闭',     '1',       'sys_notice_status',   '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '关闭状态');
insert into sys_dict_data values(18, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(19, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '修改操作');
insert into sys_dict_data values(20, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '删除操作');
insert into sys_dict_data values(21, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '授权操作');
insert into sys_dict_data values(22, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '导出操作');
insert into sys_dict_data values(23, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '导入操作');
insert into sys_dict_data values(24, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '强退操作');
insert into sys_dict_data values(25, 8,  '生成代码', '8',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '生成操作');
insert into sys_dict_data values(26, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '清空操作');
insert into sys_dict_data values(27, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(28, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '停用状态');


-- ----------------------------
-- 32、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  config_id         int(5)          not null auto_increment    comment '参数主键',
  config_name       varchar(100)    default ''                 comment '参数名称',
  config_key        varchar(100)    default ''                 comment '参数键名',
  config_value      varchar(500)    default ''                 comment '参数键值',
  config_type       char(1)         default 'N'                comment '系统内置（Y是 N否）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (config_id)
) engine=innodb auto_increment=100 comment = '参数配置表';

insert into sys_config values(1, '主框架页-默认皮肤样式名称', 'sys.index.skinName',     'skin-blue',     'Y', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow' );
insert into sys_config values(2, '用户管理-账号初始密码',     'sys.user.initPassword',  '123456',        'Y', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '初始化密码 123456' );
insert into sys_config values(3, '主框架页-侧边栏主题',       'sys.index.sideTheme',    'theme-dark',    'Y', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '深黑主题theme-dark，浅色主题theme-light，深蓝主题theme-blue' );


-- ----------------------------
-- 33、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id        bigint(20)     not null auto_increment   comment '访问ID',
  login_name     varchar(50)    default ''                comment '登录账号',
  ipaddr         varchar(50)    default ''                comment '登录IP地址',
  login_location varchar(255)   default ''                comment '登录地点',
  browser        varchar(50)    default ''                comment '浏览器类型',
  os             varchar(50)    default ''                comment '操作系统',
  status         char(1)        default '0'               comment '登录状态（0成功 1失败）',
  msg            varchar(255)   default ''                comment '提示消息',
  login_time     datetime                                 comment '访问时间',
  primary key (info_id)
) engine=innodb auto_increment=100 comment = '系统访问记录';


-- ----------------------------
-- 34、在线用户记录
-- ----------------------------
drop table if exists sys_user_online;
create table sys_user_online (
  sessionId         varchar(50)   default ''                comment '用户会话id',
  login_name        varchar(50)   default ''                comment '登录账号',
  dept_name         varchar(50)   default ''                comment '部门名称',
  ipaddr            varchar(50)   default ''                comment '登录IP地址',
  login_location    varchar(255)  default ''                comment '登录地点',
  browser           varchar(50)   default ''                comment '浏览器类型',
  os                varchar(50)   default ''                comment '操作系统',
  status            varchar(10)   default ''                comment '在线状态on_line在线off_line离线',
  start_timestamp   datetime                                comment 'session创建时间',
  last_access_time  datetime                                comment 'session最后访问时间',
  expire_time       int(5)        default 0                 comment '超时时间，单位为分钟',
  primary key (sessionId)
) engine=innodb comment = '在线用户记录';


-- ----------------------------
-- 35、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id              bigint(20)    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default 'DEFAULT'          comment '任务组名',
  invoke_target       varchar(500)  not null                   comment '调用目标字符串',
  cron_expression     varchar(255)  default ''                 comment 'cron执行表达式',
  misfire_policy      varchar(20)   default '3'                comment '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  concurrent          char(1)       default '1'                comment '是否并发执行（0允许 1禁止）',
  status              char(1)       default '0'                comment '状态（0正常 1暂停）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 comment = '定时任务调度表';

insert into sys_job values(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams',        '0/10 * * * * ?', '3', '1', '1', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_job values(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')',  '0/15 * * * * ?', '3', '1', '1', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');
insert into sys_job values(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', '1', '1', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '');


-- ----------------------------
-- 36、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          bigint(20)     not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)    not null                   comment '任务名称',
  job_group           varchar(64)    not null                   comment '任务组名',
  invoke_target       varchar(500)   not null                   comment '调用目标字符串',
  job_message         varchar(500)                              comment '日志信息',
  status              char(1)        default '0'                comment '执行状态（0正常 1失败）',
  exception_info      varchar(2000)  default ''                 comment '异常信息',
  create_time         datetime                                  comment '创建时间',
  primary key (job_log_id)
) engine=innodb comment = '定时任务调度日志表';


-- ----------------------------
-- 37、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id         int(4)          not null auto_increment    comment '公告ID',
  notice_title      varchar(50)     not null                   comment '公告标题',
  notice_type       char(1)         not null                   comment '公告类型（1通知 2公告）',
  notice_content    varchar(2000)   default null               comment '公告内容',
  status            char(1)         default '0'                comment '公告状态（0正常 1关闭）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(255)    default null               comment '备注',
  primary key (notice_id)
) engine=innodb auto_increment=10 comment = '通知公告表';

-- ----------------------------
-- 38、初始化-公告信息表数据
-- ----------------------------
insert into sys_notice values('1', '温馨提醒：2018-07-01 平台新版本发布啦', '2', '新版本内容', '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '管理员');
insert into sys_notice values('2', '维护通知：2018-07-01 平台系统凌晨维护', '1', '维护内容',   '0', 'admin', '2018-03-16 11-33-00', 'ry', '2018-03-16 11-33-00', '管理员');


-- ----------------------------
-- 39、代码生成业务表
-- ----------------------------
drop table if exists gen_table;
create table gen_table (
  table_id          bigint(20)      not null auto_increment    comment '编号',
  table_name        varchar(200)    default ''                 comment '表名称',
  table_comment     varchar(500)    default ''                 comment '表描述',
  class_name        varchar(100)    default ''                 comment '实体类名称',
  tpl_category      varchar(200)    default 'crud'             comment '使用的模板（crud单表操作 tree树表操作）',
  package_name      varchar(100)                               comment '生成包路径',
  module_name       varchar(30)                                comment '生成模块名',
  business_name     varchar(30)                                comment '生成业务名',
  function_name     varchar(50)                                comment '生成功能名',
  function_author   varchar(50)                                comment '生成功能作者',
  options           varchar(1000)                              comment '其它生成选项',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (table_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表';


-- ----------------------------
-- 40、代码生成业务表字段
-- ----------------------------
drop table if exists gen_table_column;
create table gen_table_column (
  column_id         bigint(20)      not null auto_increment    comment '编号',
  table_id          varchar(64)                                comment '归属表编号',
  column_name       varchar(200)                               comment '列名称',
  column_comment    varchar(500)                               comment '列描述',
  column_type       varchar(100)                               comment '列类型',
  java_type         varchar(500)                               comment 'JAVA类型',
  java_field        varchar(200)                               comment 'JAVA字段名',
  is_pk             char(1)                                    comment '是否主键（1是）',
  is_increment      char(1)                                    comment '是否自增（1是）',
  is_required       char(1)                                    comment '是否必填（1是）',
  is_insert         char(1)                                    comment '是否为插入字段（1是）',
  is_edit           char(1)                                    comment '是否编辑字段（1是）',
  is_list           char(1)                                    comment '是否列表字段（1是）',
  is_query          char(1)                                    comment '是否查询字段（1是）',
  query_type        varchar(200)    default 'EQ'               comment '查询方式（等于、不等于、大于、小于、范围）',
  html_type         varchar(200)                               comment '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  dict_type         varchar(200)    default ''                 comment '字典类型',
  sort              int                                        comment '排序',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (column_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表字段';


-- ----------------------------
-- 41、基础数据_人员基础信息
-- ----------------------------
DROP TABLE IF EXISTS base_person_info;
CREATE TABLE base_person_info (
  id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
  unique_id VARCHAR ( 48 ) NOT NULL COMMENT '人员标识',
  name VARCHAR ( 64 ) NULL DEFAULT NULL COMMENT '姓名',
  sex CHAR ( 1 ) NULL DEFAULT NULL COMMENT '性别：0-男 1-女 2-未知',
  phone VARCHAR ( 48 ) NULL DEFAULT NULL COMMENT '手机',
  card_no VARCHAR ( 255 ) COMMENT '卡号',
  account VARCHAR ( 255 ) COMMENT '账号',
  email VARCHAR ( 255 ) COMMENT '邮箱',
  dept_id BIGINT ( 20 ) NULL DEFAULT NULL COMMENT '部门ID',
  datasource VARCHAR ( 48 ) NOT NULL DEFAULT 'INTERFACE' COMMENT '数据来源：INTERFACE-内部接口 IMP-导入 HTTP-HTTP接口',
  flag CHAR ( 1 ) NULL DEFAULT '1' COMMENT '人员标记：1-正常 2-红名单 3-黑名单',
  tenant VARCHAR ( 255 ) NULL DEFAULT 'standard' COMMENT '租户',
  operate_id VARCHAR ( 255 ) NULL DEFAULT NULL COMMENT '操作管理员ID，用于权限控制(有多个的话用“,”分割)',
  status CHAR ( 1 ) NOT NULL DEFAULT '0' COMMENT '状态：0-有效  1:无效',
  remark VARCHAR ( 255 ) NULL DEFAULT NULL COMMENT '备注',
  update_seria_num bigint(20) comment '人员更新标识流水码',
  create_by VARCHAR ( 64 ) NULL DEFAULT NULL COMMENT '创建人',
  update_by VARCHAR ( 64 ) NULL DEFAULT NULL COMMENT '修改人',
  create_time datetime NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime NULL DEFAULT NULL COMMENT '修改时间',
  batch_date datetime NULL DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY ( id ) USING BTREE 
) COMMENT = '基础数据_人员基础信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 42、证件表
-- ----------------------------
DROP TABLE IF EXISTS base_person_cert;
CREATE TABLE base_person_cert  (
  id varchar(48) NOT NULL COMMENT '主键',
  unique_id varchar(48) NOT NULL COMMENT '人员标识',
  cert_type varchar(3) NOT NULL COMMENT '证件类型（字典国标）',
  cert_num varchar(255) NOT NULL COMMENT '证件号码',
  cert_name varchar(64) NULL DEFAULT NULL COMMENT '证件姓名',
  cert_validity varchar(48) NULL DEFAULT NULL COMMENT '证件有效期',
  gender char(1) NULL DEFAULT NULL COMMENT '性别：0-男  1-女  2-未知',
  bth_date varchar(48) NULL DEFAULT NULL COMMENT '出生日期',
  nation varchar(3) NULL DEFAULT NULL COMMENT '民族',
  address varchar(255) NULL DEFAULT NULL COMMENT '家庭住址',
  cert_authority varchar(255) NULL DEFAULT NULL COMMENT '发证机关',
  cert_img varchar ( 255 ) NULL DEFAULT NULL COMMENT '证件照',
  tenant varchar(255) NULL DEFAULT 'standard' COMMENT '租户',
  operate_id varchar(255) NULL DEFAULT NULL COMMENT '操作管理员ID，用于权限控制(有多个的话用“,”分割)',
  enterschool_img varchar(255) NULL DEFAULT NULL COMMENT '入学照片',
  inschool_img varchar(255) NULL DEFAULT NULL COMMENT '在校照片',
  graduate_img varchar(255) NULL DEFAULT NULL COMMENT '毕业照片',
  remark varchar(255) NULL DEFAULT NULL COMMENT '备注',
  create_by varchar(64) NULL DEFAULT NULL COMMENT '创建人',
  update_by varchar(64) NULL DEFAULT NULL COMMENT '修改人',
  create_time datetime NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime NULL DEFAULT NULL COMMENT '修改时间',
  batch_date datetime NULL DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY (id) USING BTREE
)  COMMENT = '基础数据_人员证件信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 43、基础数据_人脸图像信息
-- ----------------------------
DROP TABLE IF EXISTS base_person_face;
CREATE TABLE base_person_face  (
  id varchar(48) NOT NULL COMMENT '主键',
  person_id varchar(48) NOT NULL COMMENT '关联人员主键(基础信息_人员信息表ID)',
  unique_id varchar(48) NOT NULL COMMENT '人员标识',
  feature varchar(4000) NOT NULL COMMENT '人脸特征',
  quality_score double NULL DEFAULT NULL COMMENT '图像质量得分',
  image_url varchar(255) NOT NULL COMMENT '人脸图像路径',
  coordinate varchar(48) NULL DEFAULT NULL COMMENT '人脸坐标',
  vendor_code varchar(48) NULL DEFAULT NULL COMMENT '厂商',
  algs_version varchar(48) NULL DEFAULT NULL COMMENT '算法版本',
  encrypted char(1) NULL DEFAULT '0' COMMENT '是否加密： 1-加密 0-不加密',
  datasource varchar(48) NOT NULL DEFAULT 'INTERFACE' COMMENT '数据来源：INTERFACE-内部接口 IMP-导入 HTTP-HTTP接口',
  tenant varchar(255) NULL DEFAULT 'standard' COMMENT '租户',
  operate_id varchar(255) NULL DEFAULT NULL COMMENT '操作管理员ID，用于权限控制(有多个的话用“,”分割)',
  remark varchar(255) NULL DEFAULT NULL COMMENT '备注',
  status char(1) NOT NULL DEFAULT '0' COMMENT '状态：0-有效  1:无效',
  create_by varchar(64) NULL DEFAULT NULL COMMENT '创建人',
  update_by varchar(64) NULL DEFAULT NULL COMMENT '修改人',
  create_time datetime NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime NULL DEFAULT NULL COMMENT '修改时间',
  batch_date datetime NULL DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY (id) USING BTREE
)  COMMENT = '基础数据_人脸图像信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 44、基础数据_指纹图像信息
-- ----------------------------
DROP TABLE IF EXISTS base_person_finger;
CREATE TABLE base_person_finger  (
  id varchar(48) NOT NULL COMMENT '主键',
  person_id varchar(48) NOT NULL COMMENT '关联人员主键(基础信息_人员信息表ID)',
  unique_id varchar(48) NOT NULL COMMENT '人员标识',
  finger_no varchar(2) NOT NULL COMMENT '手指编号',
  coercive_position varchar(2) NOT NULL DEFAULT '0' COMMENT '胁迫位',
  feature varchar(4000) NOT NULL COMMENT '指纹特征',
  quality_score double NULL DEFAULT NULL COMMENT '图像质量得分',
  image_url varchar(255) NULL COMMENT '指纹图像路径',
  vendor_code varchar(48) NULL DEFAULT NULL COMMENT '厂商',
  algs_version varchar(48) NULL DEFAULT NULL COMMENT '算法版本',
  encrypted char(1) NULL DEFAULT '0' COMMENT '是否加密： 1-加密 0-不加密',
  datasource varchar(48) NOT NULL DEFAULT 'INTERFACE' COMMENT '数据来源：INTERFACE-内部接口 IMP-导入 HTTP-HTTP接口',
  tenant varchar(255) NULL DEFAULT 'standard' COMMENT '租户',
  operate_id varchar(255) NULL DEFAULT NULL COMMENT '操作管理员ID，用于权限控制(有多个的话用“,”分割)',
  remark varchar(255) NULL DEFAULT NULL COMMENT '备注',
  status char(1) NOT NULL DEFAULT '0' COMMENT '状态：0-有效  1:无效',
  create_by varchar(64) NULL DEFAULT NULL COMMENT '创建人',
  update_by varchar(64) NULL DEFAULT NULL COMMENT '修改人',
  create_time datetime NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime NULL DEFAULT NULL COMMENT '修改时间',
  batch_date datetime NULL DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY (id) USING BTREE
)  COMMENT = '基础数据_指纹图像信息' ROW_FORMAT = Dynamic;


-- ----------------------------
-- 45、基础数据_虹膜图像信息
-- ----------------------------
DROP TABLE IF EXISTS base_person_iris;
CREATE TABLE base_person_iris  (
  id varchar(48) NOT NULL COMMENT '主键',
  person_id varchar(48) NOT NULL COMMENT '关联人员主键(基础信息_人员信息表ID)',
  unique_id varchar(48) NOT NULL COMMENT '人员标识',
  eye_code varchar(2) NOT NULL COMMENT '眼睛编码(L/R)',
  feature longtext NOT NULL COMMENT '虹膜特征',
  quality_score double NULL DEFAULT NULL COMMENT '图像质量得分',
  image_url varchar(255) NOT NULL COMMENT '虹膜图像路径',
  vendor_code varchar(48) NULL DEFAULT NULL COMMENT '厂商',
  algs_version varchar(48) NULL DEFAULT NULL COMMENT '算法版本',
  encrypted char(1) NULL DEFAULT '0' COMMENT '是否加密： 1-加密 0-不加密',
  datasource varchar(48) NOT NULL DEFAULT 'INTERFACE' COMMENT '数据来源：INTERFACE-内部接口 IMP-导入 HTTP-HTTP接口',
  tenant varchar(255) NULL DEFAULT 'standard' COMMENT '租户',
  operate_id varchar(255) NULL DEFAULT NULL COMMENT '操作管理员ID，用于权限控制(有多个的话用“,”分割)',
  remark varchar(255) NULL DEFAULT NULL COMMENT '备注',
  status char(1) NOT NULL DEFAULT '0' COMMENT '状态：0-有效  1:无效',
  create_by varchar(64) NULL DEFAULT NULL COMMENT '创建人',
  update_by varchar(64) NULL DEFAULT NULL COMMENT '修改人',
  create_time datetime NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime NULL DEFAULT NULL COMMENT '修改时间',
  batch_date datetime NULL DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY (id) USING BTREE
)  COMMENT = '基础数据_虹膜图像信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 46、基础数据_二维码信息
-- ----------------------------
DROP TABLE IF EXISTS base_qr_code;
CREATE TABLE base_qr_code  (
  id varchar(48) NOT NULL COMMENT '主键',
  scene varchar(255) NULL DEFAULT NULL COMMENT '应用场景',
  content varchar(1000) NOT NULL COMMENT '二维码内容',
  img_path varchar(255) NOT NULL COMMENT '二维码路径',
  internal_pic varchar(255) NULL DEFAULT NULL COMMENT '内置图片',
  remark varchar(255) NULL DEFAULT NULL COMMENT '备注',
  status char(1) NOT NULL DEFAULT '0' COMMENT '状态：0-有效  1:无效',
  create_by varchar(64) NULL DEFAULT NULL COMMENT '创建人',
  update_by varchar(64) NULL DEFAULT NULL COMMENT '修改人',
  create_time datetime NULL DEFAULT NULL COMMENT '创建时间',
  update_time datetime NULL DEFAULT NULL COMMENT '修改时间',
  batch_date datetime NULL DEFAULT NULL COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
  PRIMARY KEY (id) USING BTREE
)  COMMENT = '基础数据_二维码信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 47、接口请求报文信息
-- ----------------------------
DROP TABLE IF EXISTS base_request_record;
CREATE TABLE base_request_record  (
  id varchar(48) NOT NULL COMMENT '主键',
  trans_code varchar(48) DEFAULT NULL COMMENT '交易码',
  trans_title varchar(48) DEFAULT NULL COMMENT '交易标题',
  received_time datetime NOT NULL COMMENT '请求时间',
  request_msg longtext COMMENT '请求报文',
  client_ip varchar(48) DEFAULT NULL COMMENT '客户端IP',
  send_time datetime NOT NULL COMMENT '响应时间',
  response_msg longtext NOT NULL COMMENT '响应报文',
  time_used bigint(20) NOT NULL COMMENT '耗时(ms)',
  status_code varchar(48) NOT NULL DEFAULT '0' COMMENT '状态码',
  trans_url varchar(255) DEFAULT NULL COMMENT '交易请求路径',
  class_method varchar(255) DEFAULT NULL COMMENT '处理方法',
  channel_code varchar(255) DEFAULT NULL COMMENT '渠道编码',
  PRIMARY KEY (id) USING BTREE
)  COMMENT = '基础数据_接口请求报文信息' ROW_FORMAT = Dynamic;


-- ----------------------------
-- 48、基础数据_应用系统管理表
-- ----------------------------
DROP TABLE IF EXISTS base_app_manage;
CREATE TABLE base_app_manage (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
app_key VARCHAR ( 255 ) NOT NULL COMMENT '应用系统键值',
app_secret VARCHAR ( 255 ) NOT NULL COMMENT '应用系统密钥',
app_desc VARCHAR ( 255 ) COMMENT '应用系统描述',
remark VARCHAR ( 255 ) COMMENT '备注',
status CHAR ( 1 ) NOT NULL DEFAULT '0' COMMENT '状态(数据字典:0-有效  1:无效)',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE base_app_manage COMMENT '基础数据_应用系统管理表';


-- ----------------------------
-- 49、基础数据_应用系统接口授权表
-- ----------------------------
DROP TABLE IF EXISTS base_app_interface_auth;
CREATE TABLE base_app_interface_auth (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
app_id VARCHAR ( 48 ) NOT NULL COMMENT '应用系统主键',
trans_code VARCHAR ( 255 ) NOT NULL COMMENT '接口交易码(数据字典)',
trans_end_time datetime COMMENT '交易有效截止时间',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
remark VARCHAR ( 255 ) COMMENT '备注',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE base_app_interface_auth COMMENT '基础数据_应用系统接口授权表';


-- ----------------------------
-- 50、渠道管理_渠道信息表
-- ----------------------------
DROP TABLE IF EXISTS channel_info;
CREATE TABLE channel_info (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
channel_code VARCHAR ( 255 ) NOT NULL COMMENT '渠道编码(唯一)',
channel_name VARCHAR ( 255 ) NOT NULL COMMENT '渠道名称',
channel_key VARCHAR ( 1000 ) COMMENT '渠道密钥',
concurrent INT COMMENT '并发量',
face_mode VARCHAR ( 1 ) NOT NULL DEFAULT '1' COMMENT '开通人脸(数据字典:0-不开通 1-开通)',
finger_mode VARCHAR ( 1 ) NOT NULL DEFAULT '1' COMMENT '开通指纹(数据字典:0-不开通 1-开通)',
iris_mode VARCHAR ( 1 ) NOT NULL DEFAULT '1' COMMENT '开通虹膜(数据字典:0-不开通 1-开通)',
fvein_mode VARCHAR ( 1 ) NOT NULL DEFAULT '1' COMMENT '开通指静脉(数据字典:0-不开通 1-开通)',
enable_multi_faces VARCHAR ( 1 ) NOT NULL DEFAULT 'N' COMMENT '是否支持多人脸(数据字典:N-否 Y-是)',
search_n VARCHAR ( 1 ) DEFAULT '2' COMMENT '1-N识别方式(数据字典:1-校验分库、2-校验渠道库、3-校验全库, 4-依次校验)',
put_without_check VARCHAR ( 1 ) DEFAULT 'N' COMMENT '是否强制入库(数据字典:N-否 Y-是)',
be_return_feature VARCHAR ( 1 ) DEFAULT 'N' COMMENT '是否返回特征(数据字典:N-否 Y-是)',
auth_interface VARCHAR ( 512 ) COMMENT '授权接口(数据字典,多个接口交易码使用“,”分割)',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
remark VARCHAR ( 255 ) COMMENT '备注',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE channel_info COMMENT '渠道管理_渠道信息表';

-- ----------------------------
-- 51、渠道管理_渠道参数表
-- ----------------------------
DROP TABLE IF EXISTS channel_param;
CREATE TABLE channel_param (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
channel_id VARCHAR ( 48 ) NOT NULL COMMENT '渠道主键',
param_code VARCHAR ( 255 ) NOT NULL COMMENT '参数编码(唯一)',
param_name VARCHAR ( 255 ) COMMENT '参数名称',
param_value VARCHAR ( 255 ) NOT NULL COMMENT '参数键值',
param_type VARCHAR ( 1 ) NOT NULL COMMENT '参数类型(数据字典:0-控件参数 1-业务参数)',
bio_attest_type VARCHAR ( 1 ) NOT NULL COMMENT '认证类型(数据字典::0-人脸  1指纹 2虹膜 3指静脉)',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
remark VARCHAR ( 255 ) COMMENT '备注',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE channel_param COMMENT '渠道管理_渠道参数表';

-- ----------------------------
-- 52、渠道管理_渠道业务表
-- ----------------------------
DROP TABLE IF EXISTS channel_business;
CREATE TABLE channel_business (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
channel_id VARCHAR ( 48 ) NOT NULL COMMENT '渠道主键',
person_id VARCHAR ( 48 ) NOT NULL COMMENT '人员主键',
unique_id VARCHAR ( 255 ) NOT NULL COMMENT '人员唯一标识',
busi_code_first VARCHAR ( 255 ) COMMENT '业务号1',
busi_code_second VARCHAR ( 255 ) COMMENT '业务号2',
busi_code_third VARCHAR ( 255 ) COMMENT '业务号3',
face_mode VARCHAR ( 1 ) NOT NULL DEFAULT '1' COMMENT '开通人脸(数据字典:0-不开通 1-开通)',
finger_mode VARCHAR ( 1 ) NOT NULL DEFAULT '1' COMMENT '开通指纹(数据字典:0-不开通 1-开通)',
iris_mode VARCHAR ( 1 ) NOT NULL DEFAULT '1' COMMENT '开通虹膜(数据字典:0-不开通 1-开通)',
fvein_mode VARCHAR ( 1 ) NOT NULL DEFAULT '1' COMMENT '开通指静脉(数据字典:0-不开通 1-开通)',
phone VARCHAR ( 48 ) COMMENT '手机号',
datasource VARCHAR ( 48 ) NOT NULL DEFAULT 'INTERFACE' COMMENT '数据来源(数据字典:INTERFACE-内部接口 IMP-导入 HTTP-HTTP接口)',
locked VARCHAR ( 1 ) DEFAULT 'N' COMMENT '是否锁定(数据字典:N-否 Y-是)',
lock_time datetime COMMENT '锁定时间',
status CHAR ( 1 ) NOT NULL DEFAULT '0' COMMENT '状态(数据字典:0-有效  1:无效)',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
remark VARCHAR ( 255 ) COMMENT '备注',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE channel_business COMMENT '渠道管理_渠道业务表';

-- ----------------------------
-- 53、渠道管理_分库业务表
-- ----------------------------
DROP TABLE IF EXISTS channel_subtreasury_busi;
CREATE TABLE channel_subtreasury_busi (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
channel_id VARCHAR ( 48 ) NOT NULL COMMENT '渠道主键',
sub_treasury_code VARCHAR ( 255 ) NOT NULL COMMENT '分库号(渠道编码_编号)',
sub_treasury_name VARCHAR ( 255 ) NOT NULL COMMENT '分库名称',
person_id VARCHAR ( 48 ) NOT NULL COMMENT '人员主键',
unique_id VARCHAR ( 255 ) NOT NULL COMMENT '人员唯一标识',
datasource VARCHAR ( 48 ) NOT NULL DEFAULT 'INTERFACE' COMMENT '数据来源(数据字典:INTERFACE-内部接口 IMP-导入 HTTP-HTTP接口)',
status CHAR ( 1 ) NOT NULL DEFAULT '0' COMMENT '状态(数据字典:0-有效  1:无效)',
tenant VARCHAR ( 255 ) DEFAULT 'standard' COMMENT '租户',
remark VARCHAR ( 255 ) COMMENT '备注',
create_by VARCHAR ( 64 ) COMMENT '创建人',
update_by VARCHAR ( 64 ) COMMENT '修改人',
create_time datetime COMMENT '创建时间',
update_time datetime COMMENT '修改时间',
batch_date datetime COMMENT '定时任务执行时间(执行定时任务时使用此字段)',
PRIMARY KEY ( id ) 
);
ALTER TABLE channel_subtreasury_busi COMMENT '渠道管理_分库业务表';

-- ----------------------------
-- 54、人员人脸比对日志表
-- ----------------------------
DROP TABLE IF EXISTS person_face_match_log;
CREATE TABLE person_face_match_log (
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
ALTER TABLE person_face_match_log COMMENT '人员人脸比对日志表';


-- ----------------------------
-- 55、人员指纹比对日志表
-- ----------------------------
DROP TABLE IF EXISTS person_finger_match_log;
CREATE TABLE person_finger_match_log (
id VARCHAR ( 48 ) NOT NULL COMMENT '主键',
handle_seq VARCHAR ( 48 ) NOT NULL COMMENT '平台流水号',
received_seq VARCHAR ( 48 ) NOT NULL COMMENT '业务流水号',
unique_id VARCHAR ( 48 ) COMMENT '人员标识',
dept_id BIGINT ( 20 ) COMMENT '部门ID',
channel_code VARCHAR ( 255 ) COMMENT '渠道编码',
finger_no VARCHAR ( 2 )  COMMENT '手指编码',
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
ALTER TABLE person_finger_match_log COMMENT '人员指纹比对日志表';


-- ----------------------------
-- 56、人员人脸搜索日志表
-- ----------------------------
DROP TABLE IF EXISTS person_face_search_log;
CREATE TABLE person_face_search_log (
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
ALTER TABLE person_face_search_log COMMENT '人员人脸搜索日志表';

-- ----------------------------
-- 57、人员指纹搜索日志表
-- ----------------------------
DROP TABLE IF EXISTS person_finger_search_log;
CREATE TABLE person_finger_search_log (
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
ALTER TABLE person_finger_search_log COMMENT '人员指纹搜索日志表';


-- ----------------------------
-- 58、人员虹膜比对日志表
-- ----------------------------
DROP TABLE IF EXISTS person_iris_match_log;
CREATE TABLE person_iris_match_log (
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
ALTER TABLE person_iris_match_log COMMENT '人员虹膜比对日志表';

-- ----------------------------
-- 59、人员虹膜搜索日志表
-- ----------------------------
DROP TABLE IF EXISTS person_iris_search_log;
CREATE TABLE person_iris_search_log (
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
ALTER TABLE person_iris_search_log COMMENT '人员虹膜搜索日志表';

-- ----------------------------
-- 60、邮件具体收发信息表
-- ----------------------------
DROP TABLE IF EXISTS mail_info;
CREATE TABLE mail_info (
  mail_id varchar(50) NOT NULL COMMENT '主键',
  mail_accept_mail_address varchar(50) NOT NULL COMMENT '接收者邮箱地址',
  status char(1) DEFAULT NULL COMMENT '发送状态 0：成功，1：失败',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  send_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '发送时间',
  mail_send_id varchar(50) DEFAULT NULL COMMENT '所属发送记录',
  PRIMARY KEY (mail_id) USING BTREE
) COMMENT='具体收发信息' ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- 61、邮件发送表
-- ----------------------------
DROP TABLE IF EXISTS mail_send;
CREATE TABLE mail_send (
  mail_send_id varchar(50) NOT NULL COMMENT '主键',
  mail_send_accept_mail_address varchar(500) DEFAULT NULL COMMENT '接收人邮箱(多个;分开)',
  subject varchar(255) DEFAULT NULL COMMENT '消息主题',
  content text COMMENT '邮件内容',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  scene_code varchar(50) DEFAULT NULL COMMENT '场景代码',
  status char(1) DEFAULT NULL COMMENT '发送状态 0：成功，1：失败',
  mail_send_from varchar(50) NOT NULL COMMENT '发件人',
  PRIMARY KEY (mail_send_id) USING BTREE
) COMMENT='邮件发送' ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- 62、短信推送表
-- ----------------------------
DROP TABLE IF EXISTS sms_message_send;
CREATE TABLE sms_message_send (
  id varchar(50) NOT NULL COMMENT '主键',
  message_content varchar(500) DEFAULT NULL COMMENT '推送短信内容',
  to_user_phone varchar(500) NOT NULL COMMENT '短信收信人号码，群发;分隔',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  update_time datetime DEFAULT NULL COMMENT '修改时间',
  status char(1) DEFAULT NULL COMMENT '发送状态 ',
  scene_code varchar(50) DEFAULT NULL COMMENT '场景代码',
  create_by varchar(64) DEFAULT NULL COMMENT '创建人',
  update_by varchar(64) DEFAULT NULL COMMENT '修改人',
  sms_service_configure_id varchar(50) DEFAULT NULL COMMENT '短信服务提供商id',
  err_msg varchar(500) DEFAULT NULL COMMENT '错误信息',
  PRIMARY KEY (id) USING BTREE
) COMMENT='短信推送' ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- 63、短信服务商配置表
-- ----------------------------
DROP TABLE IF EXISTS sms_service_configure;
CREATE TABLE sms_service_configure (
  id varchar(50) NOT NULL COMMENT '主键',
  template_id varchar(50) NOT NULL COMMENT '短信模版id',
  template_content varchar(500) NOT NULL COMMENT '模版内容',
  service_provider varchar(50) NOT NULL COMMENT '短信服务提供商，新增服务商需后台重启，待商讨',
  auth_json varchar(500) NOT NULL COMMENT '短信服务授权json',
  PRIMARY KEY (id) USING BTREE
) COMMENT='短信服务商配置' ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- 64、微信服务号信息推送表
-- ----------------------------
DROP TABLE IF EXISTS wx_message_send;
CREATE TABLE wx_message_send (
  wx_message_send_id varchar(50) NOT NULL COMMENT '主键',
  message_content varchar(500) DEFAULT NULL COMMENT '推送消息内容',
  to_user_open_ids varchar(500) DEFAULT NULL COMMENT '推送消息接收人,多人;分隔',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  status char(1) DEFAULT NULL COMMENT '发送状态 ',
  scene_code varchar(50) DEFAULT NULL COMMENT '场景代码',
  err_msg varchar(500) DEFAULT NULL COMMENT '错误信息',
  PRIMARY KEY (wx_message_send_id) USING BTREE
) COMMENT='微信服务号信息推送' ROW_FORMAT=DYNAMIC;


-- ----------------------------
-- 65、微信分组信息表
-- ----------------------------
DROP TABLE IF EXISTS wx_user_group;
CREATE TABLE wx_user_group (
  wx_user_group_id int(10) NOT NULL COMMENT '主键',
  group_name varchar(500) DEFAULT NULL COMMENT '分组名称',
  user_count int(10) DEFAULT '0' COMMENT '分组人数',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  wx_app_id varchar(50) DEFAULT NULL COMMENT '微信appId',
  PRIMARY KEY (wx_user_group_id) USING BTREE
) COMMENT='微信分组信息' ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- 66、微信用户信息表
-- ----------------------------
DROP TABLE IF EXISTS wx_user_info;
CREATE TABLE wx_user_info (
  wx_user_info_id varchar(50) NOT NULL COMMENT '主键',
  nickname varchar(50) NOT NULL COMMENT '微信名称',
  headimgurl varchar(500) DEFAULT NULL COMMENT '用户头像',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  open_id varchar(50) NOT NULL COMMENT '微信唯一id',
  wx_user_group_id int(10) DEFAULT NULL COMMENT '所属用户分组',
  wx_app_id varchar(50) DEFAULT NULL COMMENT '所属微信appId',
  PRIMARY KEY (wx_user_info_id) USING BTREE
) COMMENT='微信用户信息' ROW_FORMAT=DYNAMIC;


-- ----------------------------
-- 67、系统配置表[sys_config]初始化数据
-- ----------------------------
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (100, '二维码图片文件夹', 'basedata.qrcode.dir', './eyecool/biapwp/basedata/qrcode/', 'N', 'admin', '2019-10-16 19:12:27', 'admin', '2019-12-03 14:14:14', '基础数据-二维码图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (101, '人脸图片文件夹', 'basedata.face.dir', './eyecool/biapwp/basedata/face/', 'N', 'admin', '2019-10-23 14:23:57', 'admin', '2019-12-03 14:14:08', '基础数据--人脸图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (102, '指纹图片文件夹', 'basedata.finger.dir', './eyecool/biapwp/basedata/finger/', 'N', 'admin', '2019-10-24 00:03:19', 'admin', '2019-12-03 14:13:02', '基础数据--指纹图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (103, '虹膜图片文件夹', 'basedata.iris.dir', './eyecool/biapwp/basedata/iris/', 'N', 'admin', '2019-10-24 10:09:54', 'admin', '2019-12-03 14:12:56', '基础数据--虹膜图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (104, '人脸图片质量检测阈值', 'basedata.face.quality.detect.threshold', '60', 'N', 'admin', '2019-10-24 10:11:38', 'admin', '2019-12-03 14:13:54', '人脸图片质量检测阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (105, '证件照文件夹', 'basedata.cert.dir', './eyecool/biapwp/basedata/cert/', 'N', 'admin', '2019-10-24 14:24:18', 'admin', '2019-12-03 14:12:46', '证件照文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (106, '人脸1:1比对阈值', 'basedata.face.compare.threshold', '60', 'N', 'admin', '2019-10-29 12:00:06', 'admin', '2019-12-03 14:12:37', '人脸1:1比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (107, '指纹1:1比对阈值', 'basedata.finger.compare.threshold', '60', 'N', 'admin', '2019-10-29 12:00:27', 'admin', '2019-12-03 14:12:31', '指纹1:1比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (108, '虹膜1:1比对阈值', 'basedata.iris.compare.threshold', '60', 'N', 'admin', '2019-10-29 12:00:41', 'admin', '2019-12-03 14:12:27', '虹膜1:1比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (109, '人脸自助采集页面标题', 'basedata.face.collect.page.title', '人脸图像自助采集', 'N', 'admin', '2019-10-29 12:01:06', 'admin', '2019-12-03 14:12:23', '人脸自助采集页面标题');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (110, '人脸自助采集默认登录用户密码', 'basedata.face.collect.login.pwd', 'collect', 'N', 'admin', '2019-10-29 12:01:25', 'admin', '2019-12-03 14:12:17', '人脸自助采集默认登录用户密码');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (111, '重复虹膜阈值', 'basedata.iris.repeat.threshold', '90', 'N', 'admin', '2019-11-14 18:06:08', 'admin', '2019-12-03 14:12:13', '虹膜重复阈值(比对得分超过阈值认为重复)');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (112, '重复指纹阈值', 'basedata.finger.repeat.threshold', '90', 'N', 'admin', '2019-11-14 18:07:16', 'admin', '2019-12-03 14:12:09', '重复指纹阈值(比对得分超过阈值认为重复)');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (113, '基础数据接口并发量', 'basedata.interface.concurrent', '1000', 'N', 'admin', '2019-11-18 10:01:07', 'admin', '2019-12-03 14:12:05', '基础数据接口请求并发量');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (114, '人脸自助采集校验是否校验证件库', 'basedata.face.collect.validte.cert', 'N', 'N', 'admin', '2019-11-18 11:05:42', 'admin', '2019-12-03 14:11:58', '人脸自助采集校验不存在底库是否校验证件库(Y/N)');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (115, '人脸1-N搜索图片文件夹', 'busi.face.searchN.dir', './eyecool/busi/face/search/', 'N', 'admin', '2019-11-20 14:27:03', 'admin', '2019-12-03 14:11:54', '人脸1-N搜索图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (116, '人脸1-N搜索比对阈值', 'basedata.face.searchN.threshold', '80', 'N', 'admin', '2019-11-20 14:28:50', 'admin', '2019-12-03 14:11:49', '人脸1-N搜索比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (117, '指纹图片质量检测阈值', 'basedata.finger.quality.detect.threshold', '80', 'N', 'admin', '2019-11-21 16:43:18', 'admin', '2019-12-03 14:11:39', '指纹图片质量检测阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (118, '人脸检活阈值', 'basedata.face.checklive.threshold', '80', 'N', 'admin', '2019-11-21 16:44:33', 'admin', '2019-12-03 14:11:35', '人脸检活阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (119, '指纹1-N搜索图片文件夹', 'busi.finger.searchN.dir', './eyecool/busi/finger/search/', 'N', 'admin', '2019-11-25 15:33:35', 'admin', '2019-12-03 14:11:25', '指纹1-N搜索图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (120, '虹膜1-N搜索图片文件夹', 'busi.iris.searchN.dir', './eyecool/busi/iris/search/', 'N', 'admin', '2019-11-25 15:34:50', 'admin', '2019-12-03 14:11:16', '虹膜1-N搜索图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (121, '指纹1-N搜索比对阈值', 'basedata.finger.searchN.threshold', '80', 'N', 'admin', '2019-11-25 15:47:24', 'admin', '2019-12-03 14:11:08', '指纹1-N搜索比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (122, '虹膜1-N搜索比对阈值', 'basedata.iris.searchN.threshold', '80', 'N', 'admin', '2019-11-25 15:48:04', 'admin', '2019-12-03 14:11:04', '虹膜1-N搜索比对阈值');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (123, '人脸1:1认证图片文件夹', 'busi.face.compare.dir', './eyecool/busi/face/compare/', 'N', 'admin', '2019-11-26 17:19:17', 'admin', '2019-12-03 14:10:42', '人脸1:1认证图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (124, '指纹1:1认证图片文件夹', 'busi.finger.compare.dir', './eyecool/busi/finger/compare/', 'N', 'admin', '2019-11-26 17:22:17', 'admin', '2019-12-03 14:10:37', '指纹1:1认证图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (125, '虹膜1:1认证图片文件夹', 'busi.iris.compare.dir', './eyecool/busi/iris/compare/', 'N', 'admin', '2019-11-26 17:22:53', 'admin', '2019-12-03 14:10:24', '虹膜1:1认证图片文件夹');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (126, '虹膜1:1比对结果策略', 'busi.iris.compare.result.strategy', '1', 'N', 'admin', '2019-11-28 10:54:40', 'admin', '2019-12-03 14:10:31', '虹膜1:1比对结果策略（1：左眼&&右眼 2：左眼||右眼）');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (127, '人脸入库是否进行1-N校验', 'basedata.face.add.isValidN', 'N', 'N', 'admin', '2019-12-10 10:40:45', 'admin', '2019-12-16 15:56:24', '人脸入库是否进行1-N校验(Y/N)');
INSERT INTO sys_config(config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark) VALUES (128, '虹膜1:N搜索结果策略', 'busi.iris.searchN.result.strategy', '2', 'N', 'admin', '2019-12-16 15:57:47', 'admin', '2019-12-16 15:58:05', '虹膜1:N搜索结果策略（1：左眼&&右眼 2：左眼||右眼）');


-- ----------------------------
-- 68、字典类型表[sys_dict_type]初始化数据
-- ----------------------------
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (100, '数据来源', 'apply_data_source', '0', 'admin', '2019-10-17 09:35:37', '', NULL, '数据来源');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (101, '人员标记', 'apply_person_flag', '0', 'admin', '2019-10-17 09:41:53', '', NULL, '人员标记');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (102, '是否加密', 'apply_encrypted', '0', 'admin', '2019-10-23 10:29:19', '', NULL, '是否加密');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (103, '手指编码', 'bio_finger_code', '0', 'admin', '2019-10-21 11:11:07', '', NULL, '手指编码');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (104, '身份证指纹', 'bio_idcard_finger', '0', 'admin', '2019-10-21 11:26:07', '', NULL, '身份证指纹');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (105, '眼睛编码', 'bio_eye_code', '0', 'admin', '2019-10-21 17:42:46', '', NULL, '眼睛编码');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (106, '证件类型', 'sys_cert_type', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型列表');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (107, '证件照片类型', 'cert_photo_type', '0', 'admin', '2019-10-24 14:52:57', 'admin', '2019-10-25 13:21:06', '证件照片类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (108, '民族', 'sys_nation', '0', 'admin', '2019-10-24 15:07:30', '', NULL, '民族');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (109, '生物信息图片类型', 'bio_photo_type', '0', 'admin', '2019-10-25 13:20:32', 'admin', '2019-10-25 13:20:46', '生物信息图片类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (110, '生物特征开通状态', 'bio_mode_status', '0', 'admin', '2019-10-29 11:24:57', '', NULL, '生物特征开通状态');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (112, '渠道1-N识别方式', 'search_n_type', '0', 'admin', '2019-10-29 11:53:03', 'admin', '2019-11-28 16:09:30', '1-N识别方式');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (113, 'HTTP交易接口', 'http_interface', '0', 'admin', '2019-10-29 15:01:34', 'admin', '2019-11-07 17:10:22', 'HTTP交易接口');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (114, '渠道管理参数类型', 'channel_param_type', '0', 'admin', '2019-11-01 09:53:53', 'admin', '2019-11-01 09:55:59', '渠道管理参数类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (115, '渠道管理认证类型', 'channel_bio_attest_type', '0', 'admin', '2019-11-01 09:59:17', '', NULL, '渠道管理认证类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (116, '渠道管理数据来源', 'channel_business_source', '0', 'admin', '2019-11-04 09:28:47', '', NULL, '渠道管理数据来源');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (117, '生物认证识别结果', 'bio_result', '0', 'admin', '2019-11-26 13:58:56', 'admin', '2019-11-26 14:02:52', '生物认证识别结果');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (118, '生物特征1-N日志场景类型', 'search_log_type', '0', 'admin', '2019-11-27 10:22:09', 'admin', '2019-11-27 10:22:23', '生物特征1-N日志场景类型');
INSERT INTO sys_dict_type(dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark) VALUES (119, '虹膜1:1比对结果策略', 'iris_match_result_strategy', '0', 'admin', '2019-11-28 10:31:21', '', NULL, '虹膜1:1比对结果策略(左&&右 ，左||右)');


-- ----------------------------
-- 69、字典数据表[sys_dict_data]初始化数据
-- ----------------------------
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (100, 1, '内部接口', 'INTERFACE', 'apply_data_source', '', 'info', 'Y', '0', 'admin', '2019-10-17 09:36:31', 'admin', '2019-12-02 11:07:25', '数据来源--接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (101, 2, '数据导入', 'IMP', 'apply_data_source', '', 'info', 'N', '0', 'admin', '2019-10-17 09:37:03', 'admin', '2019-10-23 20:46:33', '数据来源--数据导入');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (102, 3, 'HTTP接口', 'HTTP', 'apply_data_source', '', 'info', 'N', '0', 'admin', '2019-10-17 09:37:52', 'admin', '2019-10-22 20:37:13', '数据来源--HTTP');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (103, 1, '正常', '1', 'apply_person_flag', '', 'success', 'Y', '0', 'admin', '2019-10-17 09:42:46', 'admin', '2019-10-18 13:57:32', '人员标记--正常');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (104, 2, '红名单', '2', 'apply_person_flag', '', 'primary', 'N', '0', 'admin', '2019-10-17 09:43:21', 'admin', '2019-10-18 13:57:25', '人员标记--红名单');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (105, 3, '黑名单', '3', 'apply_person_flag', '', 'danger', 'N', '0', 'admin', '2019-10-17 09:43:40', 'admin', '2019-10-18 13:57:18', '人员标记--黑名单');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (106, 1, '加密', '1', 'apply_encrypted', '', 'primary', 'Y', '0', 'admin', '2019-10-23 10:30:27', 'admin', '2019-12-02 11:06:21', '是否加密-加密');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (107, 2, '不加密', '0', 'apply_encrypted', '', 'success', 'N', '0', 'admin', '2019-10-23 10:30:57', 'admin', '2019-12-02 11:05:23', '是否加密-不加密');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (167, 1, '左手拇指', '16', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:12:37', 'admin', '2019-11-12 10:40:15', '手指编码-左手拇指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (168, 2, '左手食指', '17', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:13:18', 'admin', '2019-11-12 10:40:21', '手指编码-左手食指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (169, 3, '左手中指', '18', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:14:12', 'admin', '2019-11-12 10:40:42', '手指编码-左手中指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (170, 4, '左手环指', '19', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:14:43', 'admin', '2019-11-12 10:40:52', '手指编码-左手无名指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (171, 5, '左手小指', '20', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:15:28', 'admin', '2019-11-12 10:40:58', '手指编码-左手小指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (172, 6, '右手拇指', '11', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:16:02', 'admin', '2019-11-12 10:39:03', '手指编码-右手拇指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (173, 7, '右手食指', '12', 'bio_finger_code', '', '', 'Y', '0', 'admin', '2019-10-21 11:16:20', 'admin', '2019-11-12 10:39:20', '手指编码-右手食指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (174, 8, '右手中指', '13', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:16:47', 'admin', '2019-11-12 10:39:32', '手指编码-右手中指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (175, 9, '右手环指', '14', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:17:10', 'admin', '2019-11-12 10:39:46', '手指编码-右手无名指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (176, 10, '右手小指', '15', 'bio_finger_code', '', '', 'N', '0', 'admin', '2019-10-21 11:17:51', 'admin', '2019-11-12 10:39:58', '手指编码-右手小指');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (179, 1, '身份证指纹A', 'A', 'bio_idcard_finger', '', '', 'Y', '0', 'admin', '2019-10-21 11:26:39', '', NULL, '身份证指纹A');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (180, 2, '身份证指纹B', 'B', 'bio_idcard_finger', '', '', 'N', '0', 'admin', '2019-10-21 11:26:56', '', NULL, '身份证指纹B');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (181, 1, '左眼', 'L', 'bio_eye_code', '', '', 'Y', '0', 'admin', '2019-10-21 17:43:12', '', NULL, '眼睛编码-左眼');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (182, 2, '右眼', 'R', 'bio_eye_code', '', '', 'N', '0', 'admin', '2019-10-21 17:43:30', '', NULL, '眼睛编码-右眼');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (183, 1, '居民身份证', '111', 'sys_cert_type', NULL, 'default', 'Y', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-居民身份证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (184, 2, '临时居民身份证', '112', 'sys_cert_type', NULL, 'primary', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-临时居民身份证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (185, 3, '户口簿', '113', 'sys_cert_type', NULL, 'success', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-户口簿');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (186, 4, '军官证', '114', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-军官证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (187, 5, '警官证', '123', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-警官证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (188, 6, '学生证', '133', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-学生证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (189, 7, '外交护照', '411', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-外交护照');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (190, 8, '公务护照', '412', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-公务护照');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (191, 9, '因公普通护照', '413', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-因公普通护照');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (192, 10, '护照', '414', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-普通护照');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (193, 11, '入出境通行证', '416', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-入出境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (194, 12, '外国人出入境证', '417', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-外国人出入境证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (195, 13, '海员证', '419', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-海员证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (196, 14, '台湾居民来往大陆通行证', '511', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-台湾居民来往大陆通行');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (197, 15, '往来港澳通行证', '513', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-往来港澳通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (198, 16, '回乡证', '516', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-回乡证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (199, 17, '大陆居民往来台湾通行证', '517', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-大陆居民往来台湾通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (200, 18, '中朝边境地区出入境通行证', '733', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-中朝边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (201, 19, '中蒙边境地区出入境通行证', '736', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-中蒙边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (202, 20, '中缅边境地区出入境通行证', '738', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-中缅边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (203, 21, '云南省边境地区境外边民入出境证', '740', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-云南省边境地区境外边民入出境证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (204, 22, '中尼边境地区出入境通行证', '741', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-中尼边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (205, 23, '中越边境地区出入境通行证', '743', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-中越边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (206, 24, '中老边境地区出入境通行证', '745', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-中老边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (207, 25, '中印边境地区出入境通行证', '747', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-中印边境地区出入境通行证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (208, 26, '其他', '990', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-其他');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (209, 27, '军人证', '991', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-军人证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (210, 28, '港澳台居住证', '992', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-港澳台居住证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (211, 29, '外国人居住证', '993', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-外国人居住证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (212, 30, '越南身份证', '994', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-越南身份证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (213, 31, '边民证', '995', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-边民证');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (214, 32, '无证件', '999', 'sys_cert_type', NULL, 'info', 'N', '0', 'admin', '2019-08-01 10:11:50', NULL, NULL, '证件类型-无证件');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (215, 2, '入学照片', '1', 'cert_photo_type', '', '', 'N', '0', 'admin', '2019-10-24 14:53:44', 'admin', '2019-11-13 16:58:37', '证件照片类型-入学照片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (216, 3, '在校照片', '2', 'cert_photo_type', '', '', 'N', '0', 'admin', '2019-10-24 14:54:10', 'admin', '2019-11-13 16:58:42', '证件照片类型-在校照片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (217, 4, '毕业照片', '3', 'cert_photo_type', '', '', 'N', '0', 'admin', '2019-10-24 14:54:37', 'admin', '2019-11-13 16:58:46', '证件照片类型-毕业照片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (218, 1, '汉族', '01', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (219, 2, '蒙古族', '02', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (220, 3, '回族', '03', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (221, 4, '藏族', '04', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (222, 5, '维吾尔族', '05', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (223, 6, '苗族', '06', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (224, 7, '彝族', '07', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (225, 8, '壮族', '08', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (226, 9, '布依族', '09', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (227, 10, '朝鲜族', '10', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (228, 11, '满族', '11', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (229, 12, '侗族', '12', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (230, 13, '瑶族', '13', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (231, 14, '白族', '14', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (232, 15, '土家族', '15', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (233, 16, '哈尼族', '16', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (234, 17, '哈萨克族', '17', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (235, 18, '傣族', '18', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (236, 19, '黎族', '19', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (237, 20, '傈僳族', '20', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (238, 21, '佤族', '21', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (239, 22, '畲族', '22', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (240, 23, '高山族', '23', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (241, 24, '拉祜族', '24', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (242, 25, '水族', '25', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (243, 26, '东乡族', '26', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (244, 27, '纳西族', '27', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (245, 28, '景颇族', '28', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (246, 29, '柯尔克孜族', '29', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (247, 30, '土族', '30', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (248, 31, '达斡尔族', '31', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (249, 32, '仫佬族', '32', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (250, 33, '羌族', '33', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (251, 34, '布朗族', '34', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (252, 35, '撒拉族', '35', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (253, 36, '毛南族', '36', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (254, 37, '仡佬族', '37', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (255, 38, '锡伯族', '38', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (256, 39, '阿昌族', '39', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (257, 40, '普米族', '40', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (258, 41, '塔吉克族', '41', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (259, 42, '怒族', '42', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (260, 43, '乌孜别克族', '43', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (261, 44, '俄罗斯族', '44', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (262, 45, '鄂温克族', '45', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (263, 46, '德昂族', '46', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (264, 47, '保安族', '47', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (265, 48, '裕固族', '48', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (266, 49, '京族', '49', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (267, 50, '塔塔尔族', '50', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (268, 51, '独龙族', '51', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (269, 52, '鄂伦春族', '52', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (270, 53, '赫哲族', '53', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (271, 54, '门巴族', '54', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (272, 55, '珞巴族', '55', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (273, 56, '基诺族', '56', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (274, 57, '穿青人族', '81', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (275, 58, '其他', '97', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (276, 59, '外国血统', '98', 'sys_nation', NULL, 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '民族');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (277, 1, '人脸图片', '1', 'bio_photo_type', NULL, NULL, 'Y', '0', 'admin', '2019-10-25 13:21:32', '', NULL, '生物信息图片类型-人脸图片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (278, 2, '指纹图片', '2', 'bio_photo_type', NULL, NULL, 'N', '0', 'admin', '2019-10-25 13:22:33', '', NULL, '生物信息图片类型-指纹图片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (279, 3, '虹膜图片', '3', 'bio_photo_type', NULL, NULL, 'N', '0', 'admin', '2019-10-25 13:22:51', '', NULL, '生物信息图片类型-虹膜图片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (280, 1, '开通', '1', 'bio_mode_status', NULL, 'primary', 'Y', '0', 'admin', '2019-10-29 11:25:39', '', NULL, '生物特征开通状态-开通');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (281, 2, '不开通', '0', 'bio_mode_status', NULL, 'danger', 'N', '0', 'admin', '2019-10-29 11:26:10', '', NULL, '生物特征开通状态-不开通');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (285, 1, '校验分库', '1', 'search_n_type', '', 'primary', 'N', '0', 'admin', '2019-10-29 11:53:38', 'admin', '2019-12-12 16:48:46', '1-N识别方式-校验分库');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (286, 2, '校验渠道库', '2', 'search_n_type', '', 'warning', 'Y', '0', 'admin', '2019-10-29 11:54:00', 'admin', '2019-12-12 16:48:39', '1-N识别方式-校验渠道库');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (287, 3, '校验全库', '3', 'search_n_type', '', 'success', 'N', '0', 'admin', '2019-10-29 11:54:35', 'admin', '2019-12-12 16:48:34', '1-N识别方式-校验全库');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (288, 1, '新增人员信息', 'PERSON_INFO_INSERT', 'http_interface', '', '', 'Y', '0', 'admin', '2019-10-29 15:03:39', 'admin', '2019-11-07 17:12:30', 'HTTP交易接口-新增人员信息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (289, 1, '控件参数', '0', 'channel_param_type', '', 'info', 'Y', '0', 'admin', '2019-11-01 09:55:29', 'admin', '2019-11-01 09:56:15', '控件参数');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (290, 2, '业务参数', '1', 'channel_param_type', NULL, 'info', 'Y', '0', 'admin', '2019-11-01 09:56:42', '', NULL, '业务参数');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (291, 1, '人脸', '0', 'channel_bio_attest_type', '', 'info', 'Y', '0', 'admin', '2019-11-01 10:01:15', 'admin', '2019-11-01 10:01:48', '人脸');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (292, 2, '指纹', '1', 'channel_bio_attest_type', NULL, 'info', 'Y', '0', 'admin', '2019-11-01 10:01:38', '', NULL, '指纹');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (293, 3, '虹膜', '2', 'channel_bio_attest_type', NULL, 'info', 'Y', '0', 'admin', '2019-11-01 10:02:15', '', NULL, '虹膜');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (294, 4, '指静脉', '3', 'channel_bio_attest_type', NULL, 'info', 'Y', '0', 'admin', '2019-11-01 10:02:34', '', NULL, '指静脉');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (295, 1, '接口', 'INTERFACE', 'channel_business_source', NULL, 'info', 'Y', '0', 'admin', '2019-11-04 09:29:39', '', NULL, '接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (296, 2, '导入', 'IMP', 'channel_business_source', NULL, 'info', 'Y', '0', 'admin', '2019-11-04 09:30:04', '', NULL, '导入');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (297, 3, 'HTTP接口', 'HTTP', 'channel_business_source', NULL, 'info', 'Y', '0', 'admin', '2019-11-04 09:30:33', '', NULL, 'HTTP接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (298, 2, '修改人员信息', 'PERSON_INFO_UPDATE', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-07 17:12:18', '', NULL, 'HTTP交易接口--修改人员信息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (299, 3, '删除人员信息', 'PERSON_INFO_DELETE', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-07 17:13:14', '', NULL, 'HTTP交易接口--删除人员信息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (300, 4, '查询人员信息', 'PERSON_INFO_SELECT', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-07 17:13:44', '', NULL, 'HTTP交易接口--查询人员信息');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (301, 11, '右手不确定指位', '97', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', '2019-11-12 10:41:59', '', NULL, '手指编码--右手不确定指位');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (302, 12, '左手不确定指位', '98', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', '2019-11-12 10:42:38', '', NULL, '手指编码--左手不确定指位');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (303, 13, '其他不确定指位', '99', 'bio_finger_code', NULL, NULL, 'N', '0', 'admin', '2019-11-12 10:43:14', '', NULL, '手指编码--其他不确定指位');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (305, 1, '证件照片', '0', 'cert_photo_type', NULL, NULL, 'Y', '0', 'admin', '2019-11-13 16:58:30', '', NULL, '证件照片类型--证件照片');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (306, 5, '开通人脸功能', 'PERSON_FACE_OPEN', 'http_interface', '', '', 'N', '0', 'admin', '2019-11-14 17:48:21', 'admin', '2019-11-14 17:48:39', 'HTTP交易接口--开通人脸');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (307, 6, '关闭人脸功能', 'PERSON_FACE_CLOSE', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:49:12', '', NULL, 'HTTP交易接口--关闭人脸');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (308, 7, '人脸识别(1:N)', 'PERSON_FACE_RECOG', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:50:11', '', NULL, 'HTTP交易接口--人脸识别(1:N)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (309, 8, '人脸认证(1:1)', 'PERSON_FACE_VERIFY', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:50:43', '', NULL, 'HTTP交易接口--人脸认证(1:1)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (310, 9, '开通指纹功能', 'PERSON_FINGER_OPEN', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:51:31', '', NULL, 'HTTP交易接口--开通指纹');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (311, 10, '关闭指纹功能', 'PERSON_FINGER_CLOSE', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:52:06', '', NULL, 'HTTP交易接口--关闭指纹');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (312, 11, '指纹识别(1:N)', 'PERSON_FINGER_RECOG', 'http_interface', '', '', 'N', '0', 'admin', '2019-11-14 17:52:56', 'admin', '2019-11-14 17:53:07', 'HTTP交易接口--指纹识别(1:N)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (313, 12, '指纹认证(1:1)', 'PERSON_FINGER_VERIFY', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:54:03', '', NULL, 'HTTP交易接口--指纹认证(1:1)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (314, 13, '开通虹膜功能', 'PERSON_IRIS_OPEN', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:54:46', '', NULL, 'HTTP交易接口--开通虹膜');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (315, 14, '关闭虹膜功能', 'PERSON_IRIS_CLOSE', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:55:28', '', NULL, 'HTTP交易接口--关闭虹膜');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (316, 15, '虹膜识别(1:N)', 'PERSON_IRIS_RECOG', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:56:11', '', NULL, 'HTTP交易接口--虹膜识别(1:N)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (317, 16, '虹膜认证(1:1)', 'PERSON_IRIS_VERIFY', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:56:40', '', NULL, 'HTTP交易接口--虹膜认证(1:1)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (318, 17, '开通指静脉功能', 'PERSON_FVEIN_OPEN', 'http_interface', '', '', 'N', '0', 'admin', '2019-11-14 17:57:25', 'admin', '2019-11-14 17:58:03', 'HTTP交易接口--开通指静脉');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (319, 18, '关闭指静脉功能', 'PERSON_FVEIN_CLOSE', 'http_interface', '', '', 'N', '0', 'admin', '2019-11-14 17:57:47', 'admin', '2019-11-14 17:58:00', 'HTTP交易接口--关闭指静脉');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (320, 19, '指静脉识别(1:N)', 'PERSON_FVEIN_RECOG', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:58:43', '', NULL, 'HTTP交易接口--指静脉识别(1:N)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (321, 20, '指静脉认证(1:1)', 'PERSON_FVEIN_VERIFY', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 17:59:23', '', NULL, 'HTTP交易接口--指静脉认证(1:1)');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (322, 21, '短信推送功能', 'MESSAGE_SEND_SMS', 'http_interface', '', '', 'N', '0', 'admin', '2019-11-14 17:59:56', 'admin', '2019-11-14 18:00:03', 'HTTP交易接口--短信推送');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (323, 22, '微信服务号推送', 'MESSAGE_SEND_WECHAT', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 18:00:36', '', NULL, 'HTTP交易接口--微信服务号推送');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (324, 23, '邮件推送功能', 'MESSAGE_SEND_EMAIL', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-11-14 18:01:05', '', NULL, 'HTTP交易接口--邮件推送功能');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (325, 1, '通过', '0', 'bio_result', '', 'primary', 'Y', '0', 'admin', '2019-11-26 14:01:33', 'admin', '2019-11-28 17:48:00', '生物认证识别结果--通过');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (326, 2, '未通过', '1', 'bio_result', '', 'danger', 'N', '0', 'admin', '2019-11-26 14:02:07', 'admin', '2019-11-26 14:03:53', '生物认证识别结果--未通过');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (327, 1, '基础信息入库1:N', '1', 'search_log_type', '', 'success', 'N', '0', 'admin', '2019-11-27 10:23:38', 'admin', '2019-11-27 14:28:23', '生物特征1-N日志场景类型--基础信息入库1:N');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (328, 2, '比对搜索接口1:N', '2', 'search_log_type', '', 'primary', 'Y', '0', 'admin', '2019-11-27 10:24:37', 'admin', '2019-11-27 14:28:30', '生物特征1-N日志场景类型--1:N比对搜索接口');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (329, 1, '与策略', '1', 'iris_match_result_strategy', NULL, 'primary', 'Y', '0', 'admin', '2019-11-28 10:32:05', '', NULL, '虹膜1:1比对结果策略--与策略');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (330, 2, '或策略', '2', 'iris_match_result_strategy', NULL, 'success', 'N', '0', 'admin', '2019-11-28 10:32:40', '', NULL, '虹膜1:1比对结果策略--或策略');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (331, 24, '人员数据实时更新', 'PERSON_LIVE_UPDATE', 'http_interface', '', '', 'N', '0', 'admin', '2019-12-05 16:43:53', 'admin', '2019-12-10 17:24:01', 'HTTP交易接口--人员数据实时更新');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (332, 4, '依次校验', '4', 'search_n_type', '', 'danger', 'N', '0', 'admin', '2019-12-10 13:37:54', 'admin', '2019-12-12 16:48:51', '按照分库->渠道库->全库依次查询，查询到即返回');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (333, 3, '子系统日志回传', '3', 'search_log_type', '', 'warning', 'N', '0', 'admin', '2019-12-10 14:10:38', 'admin', '2019-12-10 14:11:23', '生物特征1-N日志场景类型--子系统日志回传');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (334, 25, '人脸识别日志回传', 'PERSON_FACE_SEARCH_LOG_BAK', 'http_interface', '', '', 'N', '0', 'admin', '2019-12-10 17:23:49', 'admin', '2019-12-13 16:05:07', 'HTTP交易接口--人脸识别日志回传');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (335, 26, '获取人脸特征', 'PERSON_FACE_FEATURE', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-12-13 16:04:49', '', NULL, 'HTTP交易接口--获取人脸特征');
INSERT INTO sys_dict_data(dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark) VALUES (336, 27, '分库操作功能', 'PERSON_SUB_TREASURY_OPERATE', 'http_interface', NULL, NULL, 'N', '0', 'admin', '2019-12-23 17:03:03', '', NULL, 'HTTP交易接口--分库操作功能');

-- ----------------------------
-- 70、菜单表[sys_menu]初始化数据
-- ----------------------------
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (4, '消息推送', 0, 4, '#', '', 'M', '0', '', 'fa fa-share', 'admin', '2019-10-10 09:39:32', 'ry', '2019-10-10 09:39:48', '消息推送目录');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (5, '基础数据', 0, 5, '#', '', 'M', '0', NULL, 'fa fa-database', 'admin', '2019-10-16 16:51:24', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (6, '场景接入', 0, 6, '#', '', 'M', '0', NULL, 'fa fa-database', 'admin', '2019-10-16 16:51:24', '', NULL, '场景接入目录');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2000, '邮件发送', 3000, 1, '/mail/send', '', 'C', '0', 'mail:send:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '邮件发送日志记录菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2001, '邮件发送日志记录查询', 2000, 1, '#', '', 'F', '0', 'mail:send:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2002, '邮件发送日志记录新增', 2000, 2, '#', '', 'F', '0', 'mail:send:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2003, '邮件发送日志记录修改', 2000, 3, '#', '', 'F', '0', 'mail:send:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2004, '邮件发送日志记录删除', 2000, 4, '#', '', 'F', '0', 'mail:send:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2005, '邮件发送日志记录导出', 2000, 5, '#', '', 'F', '0', 'mail:send:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2006, '收发记录', 3000, 1, '/mail/info', '', 'C', '0', 'mail:info:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '单独收件人邮件发送记录菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2007, '单独收件人邮件发送记录查询', 2006, 1, '#', '', 'F', '0', 'mail:info:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2008, '单独收件人邮件发送记录新增', 2006, 2, '#', '', 'F', '0', 'mail:info:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2009, '单独收件人邮件发送记录修改', 2006, 3, '#', '', 'F', '0', 'mail:info:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2010, '单独收件人邮件发送记录删除', 2006, 4, '#', '', 'F', '0', 'mail:info:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2011, '单独收件人邮件发送记录导出', 2006, 5, '#', '', 'F', '0', 'mail:info:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3000, '邮件推送', 4, 1, '#', '', 'M', '0', '', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '日志管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3001, '微信推送', 4, 2, '#', '', 'M', '0', '', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '日志管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3002, '短信推送', 4, 3, '#', '', 'M', '0', '', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '日志管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3003, '信息推送', 3001, 1, '/wechat/send', '', 'C', '0', 'wechat:send:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '微信服务号信息推送日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3004, '微信服务号信息推送日志查询', 3003, 1, '#', '', 'F', '0', 'wechat:send:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3005, '微信服务号信息推送日志新增', 3003, 2, '#', '', 'F', '0', 'wechat:send:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3006, '微信服务号信息推送日志修改', 3003, 3, '#', '', 'F', '0', 'wechat:send:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3007, '微信服务号信息推送日志删除', 3003, 4, '#', '', 'F', '0', 'wechat:send:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3008, '微信服务号信息推送日志导出', 3003, 5, '#', '', 'F', '0', 'wechat:send:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3009, '用户信息', 3001, 1, '/wechat/info', '', 'C', '0', 'wechat:info:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '微信用户信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3010, '微信用户信息查询', 3009, 1, '#', '', 'F', '0', 'wechat:info:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3011, '微信用户信息新增', 3009, 2, '#', '', 'F', '0', 'wechat:info:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3012, '微信用户信息修改', 3009, 3, '#', '', 'F', '0', 'wechat:info:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3013, '微信用户信息删除', 3009, 4, '#', '', 'F', '0', 'wechat:info:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3014, '微信用户信息导出', 3009, 5, '#', '', 'F', '0', 'wechat:info:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3015, '用户分组', 3001, 1, '/wechat/group', '', 'C', '0', 'wechat:group:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '微信分组信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3016, '微信分组信息查询', 3015, 1, '#', '', 'F', '0', 'wechat:group:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3017, '微信分组信息新增', 3015, 2, '#', '', 'F', '0', 'wechat:group:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3018, '微信分组信息修改', 3015, 3, '#', '', 'F', '0', 'wechat:group:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3019, '微信分组信息删除', 3015, 4, '#', '', 'F', '0', 'wechat:group:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3020, '微信分组信息导出', 3015, 5, '#', '', 'F', '0', 'wechat:group:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3021, '二维码管理', 5, 7, '/basedata/qrcode', 'menuItem', 'C', '0', 'basedata:qrcode:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-10-29 12:05:03', '二维码管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3022, '二维码查询', 3021, 1, '#', '', 'F', '0', 'basedata:qrcode:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3023, '二维码新增', 3021, 2, '#', '', 'F', '0', 'basedata:qrcode:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3024, '二维码修改', 3021, 3, '#', '', 'F', '0', 'basedata:qrcode:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3025, '二维码删除', 3021, 4, '#', '', 'F', '0', 'basedata:qrcode:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3026, '二维码导出', 3021, 5, '#', '', 'F', '0', 'basedata:qrcode:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3028, '人员管理', 5, 1, '/basedata/personInfo', '', 'C', '0', 'basedata:personInfo:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '人员管理菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3029, '人员查询', 3028, 1, '#', '', 'F', '0', 'basedata:personInfo:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3030, '人员新增', 3028, 2, '#', '', 'F', '0', 'basedata:personInfo:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3031, '人员修改', 3028, 3, '#', '', 'F', '0', 'basedata:personInfo:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3032, '人员删除', 3028, 4, '#', '', 'F', '0', 'basedata:personInfo:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3033, '人员导出', 3028, 5, '#', '', 'F', '0', 'basedata:personInfo:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3039, '短信推送', 3002, 1, '/sms/send', '', 'C', '0', 'sms:send:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '短信推送菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3040, '短信推送查询', 3039, 1, '#', '', 'F', '0', 'sms:send:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3041, '短信推送新增', 3039, 2, '#', '', 'F', '0', 'sms:send:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3042, '短信推送修改', 3039, 3, '#', '', 'F', '0', 'sms:send:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3043, '短信推送删除', 3039, 4, '#', '', 'F', '0', 'sms:send:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3044, '短信推送导出', 3039, 5, '#', '', 'F', '0', 'sms:send:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3045, '服务商配置', 3002, 1, '/sms/configure', '', 'C', '0', 'sms:configure:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '短信服务商配置菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3046, '短信服务商配置查询', 3045, 1, '#', '', 'F', '0', 'sms:configure:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3047, '短信服务商配置新增', 3045, 2, '#', '', 'F', '0', 'sms:configure:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3048, '短信服务商配置修改', 3045, 3, '#', '', 'F', '0', 'sms:configure:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3049, '短信服务商配置删除', 3045, 4, '#', '', 'F', '0', 'sms:configure:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3050, '短信服务商配置导出', 3045, 5, '#', '', 'F', '0', 'sms:configure:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3057, '人脸管理', 5, 2, '/basedata/face', '', 'C', '0', 'basedata:face:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '人脸菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3058, '人脸查询', 3057, 1, '#', '', 'F', '0', 'basedata:face:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3059, '人脸新增', 3057, 2, '#', '', 'F', '0', 'basedata:face:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3060, '人脸修改', 3057, 3, '#', '', 'F', '0', 'basedata:face:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3061, '人脸删除', 3057, 4, '#', '', 'F', '0', 'basedata:face:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3062, '人脸导出', 3057, 5, '#', '', 'F', '0', 'basedata:face:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3063, '人脸详细', 3057, 6, '#', 'menuItem', 'F', '0', 'basedata:face:detail', '#', 'admin', '2019-10-23 22:13:08', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3064, '指纹管理', 5, 3, '/basedata/finger', 'menuItem', 'C', '0', 'basedata:finger:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-10-23 23:15:13', '指纹菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3065, '指纹查询', 3064, 1, '#', '', 'F', '0', 'basedata:finger:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3066, '指纹新增', 3064, 2, '#', '', 'F', '0', 'basedata:finger:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3067, '指纹修改', 3064, 3, '#', '', 'F', '0', 'basedata:finger:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3068, '指纹删除', 3064, 4, '#', '', 'F', '0', 'basedata:finger:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3069, '指纹导出', 3064, 5, '#', '', 'F', '0', 'basedata:finger:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3070, '指纹详细', 3064, 6, '#', '', 'F', '0', 'basedata:finger:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3071, '虹膜管理', 5, 4, '/basedata/iris', 'menuItem', 'C', '0', 'basedata:iris:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-10-24 11:53:29', '虹膜菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3072, '虹膜查询', 3071, 1, '#', '', 'F', '0', 'basedata:iris:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3073, '虹膜新增', 3071, 2, '#', '', 'F', '0', 'basedata:iris:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3074, '虹膜修改', 3071, 3, '#', '', 'F', '0', 'basedata:iris:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3075, '虹膜删除', 3071, 4, '#', '', 'F', '0', 'basedata:iris:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3076, '虹膜导出', 3071, 5, '#', '', 'F', '0', 'basedata:iris:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3077, '虹膜详细', 3071, 6, '#', '', 'F', '0', 'basedata:iris:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3078, '证件管理', 5, 5, '/basedata/cert', '', 'C', '0', 'basedata:cert:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '证件菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3079, '证件查询', 3078, 1, '#', '', 'F', '0', 'basedata:cert:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3080, '证件新增', 3078, 2, '#', '', 'F', '0', 'basedata:cert:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3081, '证件修改', 3078, 3, '#', '', 'F', '0', 'basedata:cert:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3082, '证件删除', 3078, 4, '#', '', 'F', '0', 'basedata:cert:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3083, '证件导出', 3078, 5, '#', '', 'F', '0', 'basedata:cert:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3084, '证件导入', 3078, 6, '#', 'menuItem', 'F', '0', 'basedata:cert:import', '#', 'admin', '2019-10-24 14:39:00', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3085, '证件下载', 3078, 7, '#', 'menuItem', 'F', '0', 'basedata:cert:download', '#', 'admin', '2019-10-24 14:39:36', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3086, '证件详细', 3078, 8, '#', 'menuItem', 'F', '0', 'basedata:cert:detail', '#', 'admin', '2019-10-24 14:57:25', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3087, '报文信息', 108, 3, '/system/record', '', 'C', '0', 'system:record:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '基础数据_接口请求报文信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3088, '报文查询', 3087, 1, '#', 'menuItem', 'F', '0', 'system:record:list', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:29:07', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3089, '报文新增', 3087, 2, '#', 'menuItem', 'F', '0', 'system:record:add', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:29:27', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3090, '报文修改', 3087, 3, '#', 'menuItem', 'F', '0', 'system:record:edit', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:29:43', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3091, '报文删除', 3087, 4, '#', 'menuItem', 'F', '0', 'system:record:remove', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:29:56', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3092, '报文导出', 3087, 5, '#', 'menuItem', 'F', '0', 'system:record:export', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-07 17:30:09', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3099, '图片下载', 3028, 7, '#', 'menuItem', 'F', '0', 'basedata:personInfo:download', '#', 'admin', '2019-10-25 13:25:10', 'admin', '2019-10-25 23:41:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3100, '人员详细', 3028, 6, '#', 'menuItem', 'F', '0', 'basedata:personInfo:detail', '#', 'admin', '2019-10-25 23:40:48', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3101, '人员导入', 3028, 8, '#', 'menuItem', 'F', '0', 'basedata:personInfo:import', '#', 'admin', '2019-10-28 09:12:03', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3102, '自助采集', 5, 6, '/basedata/face/collect', 'menuItem', 'C', '0', 'basedata:face:collect', '#', 'admin', '2019-10-29 12:04:43', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3103, '自助采集保存', 3102, 1, '#', 'menuItem', 'F', '0', 'basedata:face:collect:save', '#', 'admin', '2019-10-29 12:16:31', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3104, '系统维护', 3177, 1, '/basedata/app', 'menuItem', 'C', '0', 'basedata:app:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-29 12:05:31', '应用系统菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3105, '应用系统查询', 3104, 1, '#', '', 'F', '0', 'basedata:app:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3106, '应用系统新增', 3104, 2, '#', '', 'F', '0', 'basedata:app:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3107, '应用系统修改', 3104, 3, '#', '', 'F', '0', 'basedata:app:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3108, '应用系统删除', 3104, 4, '#', '', 'F', '0', 'basedata:app:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3109, '应用系统导出', 3104, 5, '#', '', 'F', '0', 'basedata:app:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3111, '接口授权', 3177, 2, '/basedata/app/auth', 'menuItem', 'C', '0', 'basedata:appauth:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-29 11:54:28', '应用系统接口授权菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3112, '接口授权查询', 3111, 1, '#', '', 'F', '0', 'basedata:appauth:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3113, '接口授权新增', 3111, 2, '#', '', 'F', '0', 'basedata:appauth:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3114, '接口授权修改', 3111, 3, '#', '', 'F', '0', 'basedata:appauth:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3115, '接口授权删除', 3111, 4, '#', '', 'F', '0', 'basedata:appauth:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3116, '接口授权导出', 3111, 5, '#', '', 'F', '0', 'basedata:appauth:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3117, '渠道参数', 6, 3, '/scene/param', 'menuItem', 'C', '0', 'scene:param:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-05 14:18:31', '渠道管理_渠道参数菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3118, '渠道管理_渠道参数查询', 3117, 1, '#', '', 'F', '0', 'scene:param:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3119, '渠道管理_渠道参数新增', 3117, 2, '#', '', 'F', '0', 'scene:param:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3120, '渠道管理_渠道参数修改', 3117, 3, '#', '', 'F', '0', 'scene:param:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3121, '渠道管理_渠道参数删除', 3117, 4, '#', '', 'F', '0', 'scene:param:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3122, '渠道管理_渠道参数导出', 3117, 5, '#', '', 'F', '0', 'scene:param:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3123, '渠道信息', 6, 1, '/scene/info', 'menuItem', 'C', '0', 'scene:info:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-05 14:17:47', '渠道管理_渠道信息菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3124, '渠道管理_渠道信息查询', 3123, 1, '#', '', 'F', '0', 'scene:info:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3125, '渠道管理_渠道信息新增', 3123, 2, '#', '', 'F', '0', 'scene:info:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3126, '渠道管理_渠道信息修改', 3123, 3, '#', '', 'F', '0', 'scene:info:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3127, '渠道管理_渠道信息删除', 3123, 4, '#', '', 'F', '0', 'scene:info:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3128, '渠道管理_渠道信息导出', 3123, 5, '#', '', 'F', '0', 'scene:info:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3135, '渠道业务', 6, 2, '/scene/business', 'menuItem', 'C', '0', 'scene:business:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-05 14:18:25', '渠道管理_渠道业务菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3136, '渠道管理_渠道业务查询', 3135, 1, '#', '', 'F', '0', 'scene:business:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3137, '渠道管理_渠道业务新增', 3135, 2, '#', '', 'F', '0', 'scene:business:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3138, '渠道管理_渠道业务修改', 3135, 3, '#', '', 'F', '0', 'scene:business:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3139, '渠道管理_渠道业务删除', 3135, 4, '#', '', 'F', '0', 'scene:business:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3140, '渠道管理_渠道业务导出', 3135, 5, '#', '', 'F', '0', 'scene:business:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3141, '报文详细', 3087, 6, '#', 'menuItem', 'F', '0', 'system:record:detail', '#', 'admin', '2019-11-07 17:30:56', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3142, '一键更新', 3057, 7, '#', 'menuItem', 'F', '0', 'basedata:face:updatefeature', '#', 'admin', '2019-11-22 15:12:58', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3143, '一键更新', 3064, 7, '#', 'menuItem', 'F', '0', 'basedata:finger:updatefeature', '#', 'admin', '2019-11-22 15:13:26', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3144, '一键更新', 3071, 7, '#', 'menuItem', 'F', '0', 'basedata:iris:updatefeature', '#', 'admin', '2019-11-22 15:13:52', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3145, '人脸比对日志', 3149, 1, '/log/faceMatch', 'menuItem', 'C', '0', 'log:faceMatch:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-26 11:57:29', '人脸比对日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3146, '人脸比对日志查询', 3145, 1, '#', '', 'F', '0', 'log:faceMatch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3147, '人脸比对日志删除', 3145, 2, '#', '', 'F', '0', 'log:faceMatch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3148, '人脸比对日志导出', 3145, 3, '#', '', 'F', '0', 'log:faceMatch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3149, '业务日志', 6, 5, '#', 'menuItem', 'M', '0', '', '#', 'admin', '2019-11-26 11:57:09', 'admin', '2019-12-19 12:01:53', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3151, '指纹比对日志', 3149, 3, '/log/fingerMatch', 'menuItem', 'C', '0', 'log:fingerMatch:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-27 10:20:15', '人员指纹比对日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3152, '指纹比对日志查询', 3151, 1, '#', '', 'F', '0', 'log:fingerMatch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3153, '指纹比对日志删除', 3151, 2, '#', '', 'F', '0', 'log:fingerMatch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3154, '指纹比对日志导出', 3151, 3, '#', '', 'F', '0', 'log:fingerMatch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3155, '人脸比对日志详细', 3145, 4, '#', 'menuItem', 'F', '0', 'log:faceMatch:detail', '#', 'admin', '2019-11-26 14:53:31', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3156, '指纹比对日志详细', 3151, 4, '#', 'menuItem', 'F', '0', 'log:fingerMatch:detail', '#', 'admin', '2019-11-26 14:53:58', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3157, '人脸搜索日志', 3149, 2, '/log/faceSearch', 'menuItem', 'C', '0', 'log:faceSearch:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-27 10:20:26', '人脸搜索日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3158, '人脸搜索日志查询', 3157, 1, '#', '', 'F', '0', 'log:faceSearch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3159, '人脸搜索日志删除', 3157, 2, '#', '', 'F', '0', 'log:faceSearch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3160, '人脸搜索日志导出', 3157, 3, '#', '', 'F', '0', 'log:faceSearch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3161, '人脸搜索日志详细', 3157, 4, '#', '', 'F', '0', 'log:faceSearch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3162, '指纹搜索日志', 3149, 4, '/log/fingerSearch', 'menuItem', 'C', '0', 'log:fingerSearch:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-27 14:25:18', '指纹搜索日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3163, '指纹搜索日志查询', 3162, 1, '#', '', 'F', '0', 'log:fingerSearch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3164, '指纹搜索日志删除', 3162, 2, '#', '', 'F', '0', 'log:fingerSearch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3165, '指纹搜索日志导出', 3162, 3, '#', '', 'F', '0', 'log:fingerSearch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3166, '指纹搜索日志详细', 3162, 4, '#', '', 'F', '0', 'log:fingerSearch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3167, '虹膜比对日志', 3149, 5, '/log/irisMatch', 'menuItem', 'C', '0', 'log:irisMatch:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-11-28 10:13:39', '虹膜比对日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3168, '虹膜比对日志查询', 3167, 1, '#', '', 'F', '0', 'log:irisMatch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3169, '虹膜比对日志删除', 3167, 2, '#', '', 'F', '0', 'log:irisMatch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3170, '虹膜比对日志导出', 3167, 3, '#', '', 'F', '0', 'log:irisMatch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3171, '虹膜比对日志详细', 3167, 4, '#', '', 'F', '0', 'log:irisMatch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3172, '虹膜搜索日志', 3149, 6, '/log/irisSearch', '', 'C', '0', 'log:irisSearch:view', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '虹膜搜索日志菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3173, '虹膜搜索日志查询', 3172, 1, '#', '', 'F', '0', 'log:irisSearch:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3174, '虹膜搜索日志删除', 3172, 2, '#', '', 'F', '0', 'log:irisSearch:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3175, '虹膜搜索日志导出', 3172, 3, '#', '', 'F', '0', 'log:irisSearch:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3176, '虹膜搜索日志详细', 3172, 4, '#', '', 'F', '0', 'log:irisSearch:detail', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3177, '应用系统', 0, 7, '#', '', 'M', '0', '', 'fa fa-sitemap', 'admin', '2019-11-29 11:53:17', 'admin', '2019-11-29 11:53:41', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3178, '比对操作', 6, 6, '#', 'menuItem', 'M', '0', '', '#', 'admin', '2019-11-29 13:19:07', 'admin', '2019-12-19 12:02:02', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3179, '人脸1:1比对', 3178, 1, '/match/face/matchOne', 'menuItem', 'C', '0', 'match:faceMatchOne:view', '#', 'admin', '2019-11-29 13:20:25', 'admin', '2019-12-02 10:11:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3180, '人脸1:N比对', 3178, 2, '/match/face/matchN', 'menuItem', 'C', '0', 'match:faceMatchN:view', '#', 'admin', '2019-11-29 13:21:23', 'admin', '2019-12-02 10:11:14', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3181, '人脸图片比对', 3178, 3, '/match/face/compareTwo', 'menuItem', 'C', '0', 'match:faceCompareTwo:view', '#', 'admin', '2019-11-29 13:22:13', 'admin', '2019-12-02 10:11:31', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3182, '指纹1:1比对', 3178, 4, '/match/finger/matchOne', 'menuItem', 'C', '0', 'match:fingerMatchOne:view', '#', 'admin', '2019-11-29 13:20:25', 'admin', '2019-12-02 10:11:45', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3183, '指纹1:N比对', 3178, 5, '/match/finger/matchN', 'menuItem', 'C', '0', 'match:fingerMatchN:view', '#', 'admin', '2019-11-29 13:21:23', 'admin', '2019-12-02 10:11:57', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3184, '指纹图片比对', 3178, 6, '/match/finger/compareTwo', 'menuItem', 'C', '0', 'match:fingerCompareTwo:view', '#', 'admin', '2019-11-29 13:22:13', 'admin', '2019-12-02 10:12:15', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3185, '虹膜1:1比对', 3178, 7, '/match/iris/matchOne', 'menuItem', 'C', '0', 'match:irisMatchOne:view', '#', 'admin', '2019-11-29 13:20:25', 'admin', '2019-12-02 10:12:28', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3186, '虹膜1:N比对', 3178, 8, '/match/iris/matchN', 'menuItem', 'C', '0', 'match:irisMatchN:view', '#', 'admin', '2019-11-29 13:21:23', 'admin', '2019-12-02 10:12:40', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3187, '虹膜图片比对', 3178, 9, '/match/iris/compareTwo', 'menuItem', 'C', '0', 'match:irisCompareTwo:view', '#', 'admin', '2019-11-29 13:22:13', 'admin', '2019-12-02 10:12:53', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3188, '人脸特征提取', 3178, 10, '/match/face/personFeature', 'menuItem', 'C', '0', 'match:personFeature:view', '#', 'admin', '2019-11-29 13:20:25', 'admin', '2019-12-02 10:11:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3197, 'SQL查询', 3, 4, '/tools/sqlExecutor/select', 'menuItem', 'C', '0', 'tools:sqlExecutor:view', '#', 'admin', '2019-12-17 14:14:39', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3198, '接口测试', 3, 5, '/tools/interface/httpTest', 'menuItem', 'C', '0', 'tools:interface:view', '#', 'admin', '2019-12-17 14:35:04', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3199, '生成签名', 3, 6, '/tools/interface/generateSign', 'menuItem', 'C', '0', 'tools:interface:viewSign', '#', 'admin', '2019-12-18 15:47:41', 'admin', '2019-12-18 16:20:37', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3200, '接口调用', 3198, 1, '#', 'menuItem', 'F', '0', 'tools:interface:call', '#', 'admin', '2019-12-18 16:20:17', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3201, '生成签名', 3199, 1, '#', 'menuItem', 'F', '0', 'tools:interface:generateSign', '#', 'admin', '2019-12-18 16:21:04', '', NULL, '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3202, '分库业务', 6, 4, '/scene/subtreasury', 'menuItem', 'C', '0', 'scene:subtreasury:view', '#', 'admin', '2018-03-01 00:00:00', 'admin', '2019-12-19 12:01:41', '分库业务菜单');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3203, '分库业务查询', 3202, 1, '#', '', 'F', '0', 'scene:subtreasury:list', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3204, '分库业务新增', 3202, 2, '#', '', 'F', '0', 'scene:subtreasury:add', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3205, '分库业务修改', 3202, 3, '#', '', 'F', '0', 'scene:subtreasury:edit', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3206, '分库业务删除', 3202, 4, '#', '', 'F', '0', 'scene:subtreasury:remove', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3207, '分库业务导出', 3202, 5, '#', '', 'F', '0', 'scene:subtreasury:export', '#', 'admin', '2018-03-01 00:00:00', 'ry', '2018-03-01 00:00:00', '');

-- ----------------------------
-- 71、人脸信息自助采集初始化数据(内置角色、用户、和角色菜单权限、用户职位关系、用户角色关系)
-- ----------------------------
INSERT INTO sys_role(role_id, role_name, role_key, role_sort, data_scope, status, del_flag, create_by, create_time, update_by, update_time, remark) VALUES (100, '自助采集', 'collect', 3, '1', '0', '0', 'admin', '2019-10-29 12:15:09', 'admin', '2019-10-29 12:16:53', '人脸图像自助采集');
INSERT INTO sys_role_menu(role_id, menu_id) VALUES (100, 5);
INSERT INTO sys_role_menu(role_id, menu_id) VALUES (100, 3102);
INSERT INTO sys_role_menu(role_id, menu_id) VALUES (100, 3103);
INSERT INTO sys_user(user_id, dept_id, login_name, user_name, user_type, email, phonenumber, sex, avatar, password, salt, status, del_flag, login_ip, login_date, create_by, create_time, update_by, update_time, remark) VALUES (102, 103, 'collect', '自助采集', '00', 'collect@eyecool.cn', '13000000000', '0', '', 'b8f3bb60f7496291ea1adc687762e437', 'fcf963', '0', '0', '192.168.60.136', '2019-10-29 12:24:22', 'admin', '2019-10-29 12:19:55', '', '2019-10-31 10:33:47', '照片自助采集时，平台自动登录使用');
INSERT INTO sys_user_post(user_id, post_id) VALUES (102, 4);
INSERT INTO sys_user_role(user_id, role_id) VALUES (102, 100);
