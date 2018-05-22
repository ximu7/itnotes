# 服务器端

## web服务器

如果只是搭建本机使用的源，可以略过本步骤。

搭建本地web服务器，例如使用apache或nginx，甚至http-server亦可。

这里假设web服务配置的根目录为`/srv/`，IP地址192.168.1.251

## 软件源

这里介绍以下方法将软件源放到`/srv/repo`文件夹：

- 使用发行版（本文指centos）的ISO文件（如centos的everything）
- 同步公共软件源
- 自定义软件内容的源

### 使用iso

挂载iso文件，假如iso为`~/centos.iso`

```shell
mount -o loop ~/centos.iso /srv/repo
```

### 同步公共软件源

使用rsync工具同步，需要该站点支持rsync协议，这里以[清华大学开源软件镜像](https://mirrors.tuna.tsinghua.edu.cn/)站--https://mirrors.tuna.tsinghua.edu.cn/为例。

1. 确保已经安装createrepo和rsync

2. 同步源软件源

   这里以centos7 x86_64为例，同步其基础的base、updates、extras源已经企业软件工具源epel，分别同步到`/srv/repo`目录下的同名目录中。

   1. 创建这些文件夹用以同步

      ```shell
      cd /srv/repo
      mkdir base updates extras epel
      ```

   2. 编写脚本`rsync-repo.sh`

      ```shell
      #!/bin/sh
      #centos repo rsync
      #base
      rsync -avz --exclude-from=./exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/os/x86_64/ /srv/repo/base/
      createrepo /srv/repo/base/

      #updates
      rsync -avz --exclude-from=./exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/updates/x86_64/ /srv/repo/updates/
      createrepo /srv/repo/updates/

      #extras
      rsync -avz --exclude-from=./exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/extras/x86_64/ /srv/repo/extras/
      createrepo /srv/repo/extras/

      #epel
      rsync -avz --exclude-from=./exclude.list rsync://mirrors.tuna.tsinghua.edu.cn/epel/7/x86_64/ /srv/repo/epel/
      createrepo /srv/repo/epel/
      ```

   3. 编写排除文件`exclude.list`--排除其软件源中那些并不是太需要的软件包

      ```shell
      SRPMS
      aarch64
      ppc64
      ppc64le
      debug
      repodata
      EFI
      LiveOS
      images
      isolinux
      CentOS_BuildTag
      EULA
      GPL
      RPM-GPG-KEY-CentOS-7
      RPM-GPG-KEY-CentOS-Testing-7
      ```

   4. 同步软件源

      ```shell
      chmod +x rsync-repo.sh
      ./rsync-repo.sh
      ```

      同步中……

### 自定义软件源

   放置一些单独的软件包。

   建立一个文件夹如`rpms`，将软件包放到文件下即可。

## repo文件

编写一个`local.repo`文件放置于`/srv`下。

如果该软件源仅为本机使用，则将下面的`http://`改为`file:///`。

```shell
[base-local]
name=local-repo-base
baseurl=http://192.168.1.251/repo
path=/base
enabled=1
gpgcheck=0

[updates-local]
name=local-repo-updates
baseurl=http://192.168.1.251/repo
path=/updates
enabled=1
gpgcheck=0

[extras-local]
name=local-repo-extras
baseurl=http://192.168.1.251/repo
path=/extras
enabled=1
gpgcheck=0

[epel-local]
name=local-repo-epel
baseurl=http://192.168.1.251/repo
path=/epel
enabled=1
gpgcheck=0

[rpms-local]
name=local-rpms
baseurl=http://192.168.1.251/repo
path=/rpms
enabled=1
gpgcheck=0
```

# 客户端

保险起见，先备份客户机上的`/etc/yum.repos.d`目录下的repo文件到其他位置（或者更改其后缀不为.repo）。

下载`local.repo`到客户机

```shell
curl -O /etc/yum.repos.d/local.repo http://192.168.1.251/local.repo
yum update
```

客户机就可以从服务器上下载软件包了。

   

   