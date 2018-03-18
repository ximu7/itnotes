> IPMI（智能平台管理接口）是一种开放标准的硬件管理接口规格，定义了**嵌入式管理子系统**进行通信的特定方法。IPMI 信息通过基板管理控制器 (BMC)（位于 IPMI 规格的硬件组件上）进行交流。使用低级硬件智能管理而不使用操作系统进行管理。



# 配置

1. 在BIOS中启用IPMI over LAN功能。

2. 安装`ipmitool`工具。

3. 启用`ipmi`服务

4. 设置impi网络参数

  假如该设备目前IP为192.168.1.10，网关为192.168.1.1，则为其配置一个该网段（192.168.1.0--192.168.1.255）中未被分配使用的IP（可以先ping一下想要设置的IP以确认其是否正被使用），示例：

  ```shell
  ipmitool lan set 1 ipaddr 192.168.1.100  #IP
  ipmitool lan set 1 netmask 255.255.255.0  #子网掩码
  ipmitool lan set 1 defgw ipaddr 192.168.1.1  #网关
  ipmitool lan set 1 access on  #启用 （off为关闭）
  ipmitool lan print  #查看配置信息
  ```

- 设置管理用户

  假如设置一个admin用户，密码也为admin，示例：

  ```shell
  ipmitool lan set 1 admin #设置用户admin
  ipmitool lan set 1 password admin  #设置admin密码
  ipmitool user list 1 # 查看当前用户列表
  ```

- 检查

  ```shell
  ping 192.168.1.100
  ipmitool -H 192.168.1.100 -U admin power status  #会返回power is on
  ```

# WEB管理

浏览器开启https://你IPMI的IP地址（例如本文中为https://192.168.1.100），输入用户名和密码（本文示例中用户名和密码均为admin），即可登录web管理界面。

在web管理界面可以对设备进行电源管理、镜像挂载、固件升级、网络配置、设备实时画面查看等等操作，就如同身处该设备旁边一般。

提示：如果要使用远程控制中的重定向控制台（Console Redirection），需要安装Java运行环境（JRE）。在点击启用控制台（launch Console）后会提示下载lunch.jnlp文件，下载该文件并打开，会运行一个Java Viwer独立窗口。