[TOC]

# 服务端

## 安装

安装`yp-tools` `ypserv` `ypbind` `rpcbind`

## 配置

### nis网域设定

编辑`/etc/sysconfig/network`，添加网域名称和端口，示例：

```shell
NISDOMAIN=cluster
YPSERV_ARGS="-p 1011"
```

###  主配置文件/etc/ypserv.conf

可选，可直接使用预设值。配置允许/禁止访问NIS服务器的网域，编辑`etc/ypserv.conf`，添加类似：

```shell
127.0.0.0/255.255.255.0     : * : * : none
192.168.100.0/255.255.255.0 : * : * : none
* : * : * : deny
```

### host配置/etc/host

可选。可配置服务器ip对应的域名方便访问，添加类似：

```shell
192.168.100.101  cluster
```

### nis密码修改

可选，该配置启用可启用NIS 用户端的密码修改功能。

centos的配置在`/etc/sysconfig/yppasswdd `，编辑该文件，修改配置，添加yppasswd的启用端口：

```shell
YPPASSWDD_ARGS="--port 1012"
```

## 启用相关服务

启用`ypserv` `yppasswdd` 

查看启用情况：

```shell
 rpcinfo -p localhost | grep -E '(portmapper|yp)'
 rpcinfo -u localhost ypserv
```

第一条查询命令会看到postmapper、 ypserv（该示例中为1011端口）、yppasswdd（该示例中为1012端口）的端口。第二条查询命令会看到类似：

> program 100004 version 1 ready and waiting
>
> program 100004 version 2 ready and waiting

## 建立用户帐号资料库

示例，先添加两个用户：

```shell
useradd -u 1001 user1
useradd -u 1002 user2
passwd user1
passwd user2
```

运行` /usr/lib64/yp/ypinit -m`生成用户帐号资料库：

- 第一次出现的`next host to add:`之后会自动填入当前系统主机名
- 第一次出现的`next host to add:`按下`ctrl`-`d`即可
- `is this correct?`询问时，如果信息无误，按下`y`即可。

如果运行出现错误则根据错误提示信息进行解决后再生成资料库。

# 客户端

## 安装

安装`ypbind` `yp-tools`

## 启用相关服务

`启用rpcbind`和`ypbind`服务。

## 配置

### 主配置文件/etc/yp.conf

编辑`/etc/yp.conf`，添加类似：

```shell
domain servername server 192.168.10.1
```

### 用户密码认证顺序配置/etc/nsswitch.conf 

`/etc/nsswitch.conf`用于管理系统中多个配置文件查找的顺序，系统将按照配置中的顺序去查找用户信息文件。

编辑该文件，在`passwd`、`shadow`和`group`添加`nis，类似

```shell
passwd:  files nis
shadow:  files nis
group:  files nis
```

### 系统认证文件 /etc/sysconfig/authconfig

编辑` /etc/sysconfig/authconfig`， 修改`USENIS`的值为`yes` 。



修改配置完成后重启`rpcbind`和`ypbind`服务。

## 连接测试

- 使用检测工具，如`yptest` `ypwhich` `ypcat` 。

  简单使用：

  ```shell
  yptest  #测试连接情况
  ypwhich  #显示服务器主机名
  ypwhich -x  #显示所有服务端与客户端连线共用的资料库
  ypcat hosts.byname  #查看服务端于客户端共用的hosts资料库内容
  ```

  ​

  - `yptest`会进行各项连接检测
  - `ypwhich`可以检查

- 如果连接成功，即可在客户端登录在服务端建立的账号。

  ```shell
  su - nis1  #切换到服务端建立的nis1账户
  # 登录成功
  whoami  #检查以下当前用户
  ```

- 在nis上修改用户相关参数

  - 修改密码 `yppasswd`   --功能同`passwd`
  - 修改shell  `ypchsh`  --功能同`chsh`
  - 修改finger  `ypchfn`  --功能同`chfn`

