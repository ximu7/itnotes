[TOC]

附ssh相关参数：

> -p：指定远程主机端口
>
> -f：后台执行ssh指令
>
> -C：请求压缩所有数据
>
> -N：不执行远程指令
>
> -D：绑定本地端口建立socket连接
>
> -R：远程端口转发--转发远程主机的某个端口到本机的某个端口
>
> -L：本地端口转发--转发本机某个端口到本地另一个端口
>
> -g：允许

# 远程登录

```bash
ssh <user>e@<host>     #<user>是用户名, <host>是该ssh服务器的主机地址 
ssh -p 2333 <user>@<host>     #-p指定端口（更改了默认端口22时需要使用）
```
如果省略用户名（和`@`），将会以当前用户名登录ssh服务器。

例如当前用户为root，执行`ssh <host>`将会以root用户登录该服务器，等同于`ssh root@<host>`。

## 使用密钥免密码登录

1. 生成密钥

   ```shell
   ssh-keygen   #相当于 ssh-keygen -t rsa  参数-t指定加密类型如果rsa/dsa
   ```

2. 上传密钥

   ```shell
   ssh-copy-id <user>@<host>
   ssh-copy-id -i ~/.ssh/test.pub <user>@<host>  #有多个公钥时可使用参数-i指定一个公钥
   ```

提示：上传时和上传后的首次登录需要输入密码。

---

手动添加公钥：

1. 将客户端生成的**`id_rsa.pub`**内容添加到服务端的`~/.ssh/authorized_keys`中。

2. 确保服务器上用户的**~/.ssh/authorized_keys文件的权限设为600**，**~/.ssh文件夹权限设为700** ：

   ```shell
   chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh
   ```

# 远程操作

直接在登录命令后添加命令可使该命令在远程主机上执行，示例如下：

```shell
ssh <user>@<host> 'whoami'
ssh <user>@<host> uname -rsa
ssh <user>@<host> 'mkdir -p .ssh && cat >> .ssh/authorized_keys' < ~/.ssh/id_rsa.pub
```

# 端口转发

## 绑定本地端口

```shell
ssh -fND 1080 <user>@<host>
```

为要使用该代理的应使用配置socks5代理：地址为`127.0.0.1`或`local<host>`，端口1080。

## 本地转发与远程转发

分别使用-L和-R进行本地转发和远程转发，命令格式：

```shell
ssh -L B  <host>:<port>:<host>:<port> <user>@<host>  #-R同理
```

下文示例使用本地转发和远程转发，实现从一个内网中的设备，通过外网代理服务器，访问到另一个内网中的服务器。

设备client---NAT--->公网代理proxy<---NAT--->ssh服务器Target

### 访问内网服务器

各个设备情况：

- target server**目标**服务器T
  - 内网 能够访问外网的代理服务器
  - 已开启sshd 假设端口为默认的22
- proxy server**外网代理**服务器P
  - 外网 ip x.x.x.x
  - 已开启sshd 假设端口为默认的22
  - 未被使用且已经放行的两个端口 假如为`9876`和`6789`
- any client客户端C
  - 处于另一内网 能连接外网 欲ssh登录到**目标**服务器

1. 远程转发——在**目标**服务器上操作

   将本机的22端口转发到外网代理服务器上的9876端口

   ```shell
   ssh -fCNR 9876:localhost:22 <userP>@<hostP>
   ```
   VNC同理，将vnc server的端口如5901转发到远程的代理服务器上即可，下不赘述。

   当然，在远程转发后，就可以在外网代理服务器上连接到目标服务器上了，在外网代理服务上连接：

   ```shell
   ssh -p 9876 <userT>@<hostT>
   ```

2. 本地转发——在**外网代理**服务器上操作

   将本机的6789端口转发到本机上和目标服务器通信的9876端口

   ```shell
   ssh -fCNL *:6789:localhost:9876 localhost
   ```

   `*`表示任意主机可访问

3. 登录到目标服务器--要登录目标服务器的客户端

   在其他任意可访问到外网代理服务器P的设备上，通过以下命令即可访问到目标服务器T：

   ```shell
   ssh -p 6789 <userT>@<hostP>
   ```

   注意：

   - 这里的用户名userT是目标服务器上的用户名而不是外网代理服务器上的用户名。
   - 有的云服务器会有安全组规则，如果端口不能访问，需要开启要使用的端口。

# SCP

scp是基于ssh的远程复制，使用**类似cp命令**。基本形式：

```shell
scp </path/to/local-file> <user>@<host>:</path/to/file>  #本地到远程
scp <user>@<host>:</path/to/file> </path/to/local-file>  #远程到本地
```

常用选项：

- -P  指定远程主机的端口号
- -C  使用压缩
- -r  递归方式复制（即复制文件夹下所有内容）
- -p  保留文件的权限、修改时间、最后访问时间
- -q  静默模式（不显示复制进度）
- -F  指定配置文件

示例——复制本地ssh公钥到远程主机：

```shell
#复制本地公钥到远程主机 并将其命名为authorized_keys
scp ~/.ssh/id_rsa.pub root@ip:/root/.ssh/authorized_keys
#指定端口需要紧跟在scp之后
scp -P 999 ~/.ssh/id_rsa.pub root@ip:/root.ssh/authorized_keys
```

# sftp

使用sftp协议可以同ssh服务器进行文件传输，访问地址类似：

> sftp://192.168.1.100:22/home/<user>/path/to/file