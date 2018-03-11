[TOC]

各个设备情况：

- target server**目标**服务器：

  内网ip192.168.0.100  能够访问外网的代理服务器

- proxy server**外网代理**服务器：

  外网ip   x.x.x.x

- any client客户端

  处于另一内网  欲ssh登录到**目标**服务器

为了省去输入密码的麻烦，可先将目标服务器和客户端的公钥都发放到外网代理服务器中：

```shell
ssh-copy-id -p <port> <username>@<ip>
```

# 使用ssh反向代理

1. 在**目标**服务器上操作

   - 目标服务器：
     - ssh端口22；
     - 用户名`userN`
   - 外网代理服务器
     - ssh端口22
     - 要被目标服务器绑定的端口`9876`
     - 用户名`userO`

   ```shell
   ssh -fCNR 9876:localhost:22 user1@x.x.x.x
   ```

   提示：如果外网代理服务器端口不是默认的22，使用`-p`指定端口。

2. 在**外网代理**服务器上操作

   - 外网代理服务处器
     - 要被转发到本地的端口`6789`

   ```shell
   ssh -fCNL "*:6789:localhost:9876' localhost
   ```

3. 登录到目标服务器--要登录目标服务器的客户端

   ```shell
   ssh -p 6789 userN@x.x.x.x
   ```

   注意：

   - 这里的用户名是目标服务器上的用户名而不是代理服务器上的用户名。
   - 有的云服务器会有安全组规则，如果端口不能访问，需要开启要使用的端口。

---

附，ssh相关参数说明：

> -p：指定远程主机端口
>
> -f：后台执行ssh指令
>
> -C：请求压缩所有数据
>
> -N：不执行远程指令
>
> -R：转发远程主机某个端口到本地某个端口
>
> -L：转发本地某个端口到远程主机某个端口

# 使用autossh工具

1. 在目标服务器配置autossh

   首先在目标服务器安装`autossh`工具。然后使用autossh配置反向隧道：

   - 目标服务器：
     - ssh端口22；
     - 用户名`userN`
   - 外网代理服务器
     - ssh端口22
     - 要被目标服务器绑定的端口`9876`
     - 要被转发到本地的端口`6789`
     - 用户名`userO`

   ```shell
   autossh -M 9876 -fN -o  -R x.x.x.x:6789:localhost:22 userO@x.x.x.x

   #使用一些参数的示例
   autossh -M 9876 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R x.x.x.x:6789:localhost:22 userO@x.x.x.x
   ```

   autossh更多参数可查看其帮助。

2. 登录到目标服务器

   ```shell
   ssh -p 6789 userN@x.x.x.x
   ```

   ​