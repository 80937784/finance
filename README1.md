# 一、智慧园区生物识别身份认证平台
## 1系统权限子系统
## 2设备子系统
## 3区域管理子系统 设置区域，基于顶层画区域图。  区域是否和部门数据权限挂钩呢？
## 4日终处理子系统 
## 5消息通知子系统
### 5.1邮件通知子系统
### 5.2微信通知子系统
### 5.3sms短信通知子系统
### 5.4钉钉通知子系统
## 6生物识别子系统
### 6.1人脸识别子系统   调用abis 时 如何通过参数化 控制 地址 ？目前应该是sdk 直接调用yml来获取的。
### 6.2指纹识别子系统
### 6.3虹膜识别子系统
    提供基础的库。靠唯一标识还是靠ID去关联呢？  纯粹的识别。 存个唯一标识？一个人存取多张？还是仅有一张呢？这个子系统其实abis 已经维护好了。也是ID去关联人的ID去？关联同一个人的ID时 怎么区分呢？
### 6.4指静脉识别子系统
### 6.5人脸动态识别子系统  
## 7基础数据子系统 与第三方同步或者手工维护或者二维码等进行维护。就维护一个人的信息。 人关联 部门ID ，其他人关联的时候都有ID。
## 8报表子系统  统计分析
## 9监控子系统   业务监控、大屏监控 、网络摄像头监控。
## 10图像存储子系统  可以基于fastDFS 进行存储。
## 11渠道场景子系统  专门维护接入的具体场景。是否设置具体的交易场景细节信息呢
## 12统计分析子系统
## 13门禁管理系统
## 14报文日志子系统 错误日志、异常日志都记录。甚至有数据权限，接入的场景都可以看到。
依赖于基础人（通过接口取人）、依赖于区域通过接口取区域、依赖于设备（通过接口取设备）  进行数据下发。这个关联是通过ID 还是IP等信息进行关联呢？比如说我设备更换了，或者 IP 更换了 怎么操作呢？
                   这种关系的维护，甚至控制回到到传统的刷卡方式开门（卡号信息）。
                   内部口，外部口。外部口走通讯。内部口走注解调用。          
                   批量门还有批量人的选择。
                   
系统之间的松耦合，注解内部调用。接口调用（HTTP\GRPC）,安全性。MQ队列的方式进行通讯？

组件:
1、调用V服务
2、报文日志。参考操作日志单独维护一个过滤器？通过注解实现？

