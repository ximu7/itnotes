[TOC]

示例中，网桥名为`br0` ，有线网卡设备名为`eth0` ，无线网卡设备名为`wlo1`（网卡设备名可使用`ip addr`命令查看）。

# 创建网桥

参看[ArchLinux-wiki:Network bridge](https://wiki.archlinux.org/index.php/Network_bridge_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E9.80.9A.E8.BF.87_bridge-utils)

本文主要记录使用`bridge-utils`和`iproute2`建立网桥的方法（此外还能使用`netctl` 、`systemd-network`、`NetworkManager`进行网桥搭建）。

该部分示例中为使用有线网络端口搭建，若使用无线网络连接，须先进行相关配置——[网桥使用无线网络端口](#网桥使用无线网络端口) 。

## bridge-utils

需要安装`bridge-utils` 。

- 创建流程：

  1. 创建网桥

     ```shell
     brctl addbr br0
     ```

  2. 添加一个设备到网桥

     ```shell
     brctl addif br0 eth0
     ```

  3. 启动网桥

     ```shell
     ip link set up dev br0
     ```

  4. 分配ip地址

     ```shell
     ip addr add dev br0 192.168.10.100/24
     ```

- 其他常用命令

  bridge-utils的命令格式是`brctl [commonds]` ，更多命令查看`brctl --help` 。

  - 显示当前已存在的网桥`brctl show`

  - 删除网桥`delbr`

    ```shell
    ip link set dev br0 down  #删除网桥前先关闭启动的网桥
    brctl delbr br0  #删除名为br0的网桥
    ```

## iproute2

该工具包含在`ip`软件包中。

- 创建流程：

  1. 创建网桥  

     ```shell
     ip link add name br0 type bridge
     ```

  2. 启动网桥

     ```shell
     ip link set up dev br0
     ```

  3. 添加一个设备到网桥

     ```shell
     ip link set dev eth0 promisc on  #将该端口设置为混杂模式
     ip link set dev eth0 up  #启动该端口
     ip link set dev eth0 master br0  #将该端口添加到网桥中
     ```

  4. 分配ip地址

     ```shell
     ip addr add dev br0 192.168.10.100/24
     ```

- 其他命令：

  - 显示当前已存在的网桥 `bridge link show`  （ bridge 工具包含在iproute2中）

  - 删除网桥

    ```shell
    ip link set eth0 promisc off  #关闭端口混杂模式
    ip link set eth0 down  #关闭端口
    ip link set dev eth0 nomaster  #恢复该端口设置（创建是设置了master）
    ip link delete br0 type bridge  #删除网桥br0
    ```

注意：创建的网桥在重启系统后就不存在了，可以但创建网桥的命令写成脚本放到/etc/profile.d下令其在系统启动后自动创建。