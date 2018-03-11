- 最小化安装后联网

  `cd /etc/sysconfig/network-scripts/  `编辑第一个（一般是ifcg-eth0）将最后一行的`onboot`的值由`no`改成`yes`

- 常用源

  - epel
  - yum-utils

  可以直接使用yum安装这些源

  ``` shell
  yum repolist  #查看所有yum源
  yum install epel-release  yum-utils #安装
  yum makecache  #更新yum 缓存
  yum update  #更新一下
  ```

- 关闭防火墙　`systemctl stop firewalld.service && systemctl disable firewalld.service`

- 关闭selinux

  - 查看selinux状态  `getenforce`
  - 临时关闭：`setenforce 0`
  - 永久关闭：编辑`/etc/sysconfig/selinux`，将其中的`SELINUX=enforcing`修改为`SELINUX=disabled`，重启后生效（也可执行`setenforce 0`暂时关闭）。