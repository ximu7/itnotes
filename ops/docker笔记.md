[TOC]

# 简介

docker是一种Linux 容器（Linux Containers，缩写为 LXC）解决方案。

容器与虚拟机：

> 传统虚拟机技术是虚拟出一套硬件后，在其上运行一个完整操作系统，在该系统上再运行所需应用进程；而容器内的应用进程直接运行于**宿主的内核** ，容器内没有自己的内核，而且也没有进行硬件虚拟。因此容器要比传统虚拟机更为轻便。

Docker 包括三个基本概念：

- 镜像( Image）
- 容器( Container）
- 仓库( Repository）

> Docker 把应用程序及其依赖，打包在镜像文件中。Docker 根据 image 文件生成容器的实例。同一个 image 文件，可以生成多个同时运行的容器实例。

# 安装配置

- 安装docker
- 启用docker服务`systemctl start docker`

## 非root用户使用docker

要将该用户添加到docker组中：

```shell
usermod -aG docker username
#或
gpasswd -a user docker
#重新登入系统或使用以下命令使其立即生效：
newgrp docker
```

## 修改存放目录

默认情况下，Docker镜像和容器的默认存放位置为:`/var/lib/docker`，可`docker info | grep 'Root Dir'`命令查看。

假如要设定的存放路径为`/home/docker/` ，可使用以下方法：

- 使用软链接

  将要设定的存放路径链接到当前的存放位置。

  ```shell
  mv /var/lib/docker /home/docker
  ln -sf /home/docker /var/lib/docker
  ```

- 指定存放路径参数

  `docker --graph=/home/docker -d`

- 修改全局配置文件

  各个操作系统中的存放位置不一致， Ubuntu 中的位置是：`/etc/default/docker`，在 CentOS 中的位置是：`/etc/sysconfig/docker`。

  在配置文件中添加：

  ```shell
  OPTIONS=--graph="/root/data/docker" -H fd://
  ```

  如果系统有selinux并已经开启，则添加关闭selinux的参数：

  ```shell
  OPTIONS=--graph="/root/data/docker" --selinux-enabled -H fd://
  ```

## docker信息

- 查看docker状态`docker info`
- 查看镜像、容器、数据卷所占用的空间`docker system df`

# 镜像操作

- 列出本地镜像`docker images`

  - 虚悬镜像`docker image ls -f dangling=true`

    由于新旧镜像同名，旧镜像名称会被取消，从而出现仓库名、标签均为 `<none>` 的镜像。

- 删除镜像`docker image rm`

## 从仓库获取镜像

 这里是指从[DockerHub](https://hub.docker.com/explore/)仓库获取。

-  搜寻 `docker search [关键词]`

-  安装 `docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]`

   ```shell
   docker pull base/archlinux    #archlinux
   docker pull centos    #centos
   docker pull unbuntu:17.04    #ubuntu 17.04
   ```


## Dockerfile构建镜像

### Dockerfile文件

> Dockerfile 是一个文本文件，其内包含了一条条的指令(Instruction)，每一条指令构建一层,因此每一条指令的内容,就是描述该层应当如何构建。

Dockerfile文件内容示例：

```dockerfile
FROM archlinux  #指定基础镜像 scratch是空白镜像
MAINTAINER levinit "xx@yy.com"  #维护者
RUN buildDeps=pacman -Syu nginx  #RUN后面是要执行的命令
RUN echo '<h1>Hello Docker!</h1>'  >  /usr/share/nginx/html/index.html
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
```

Dockerfile 中每一个指令都会建立一层，因此有必要尽可能减少命令条数，例如使用`&&`将几条`RUN`指令合成一条。

其他常用指令：

- COPY
- ADD
- CMD
- ENTRYPOINT
- ENV
- VOLUME
- EXPOSE
- WORKDIR
- USER
- HEALTHCHECK
- ONBUILD

### 构建镜像

  `docker build -t='levinit/nginxArch:v1'`

  v1是标签名(tag name)，如果没有设置标签名，则**默认使用latest标签**。

  添加更为详细的信息

  ```shell
  docker build -t='levinit/nginxArch:v1'\
  git@github.com:docker/webserver
  ```

  - `--no-cache`略过缓存功能，示例：`docker build --no-cache -t='levinit/nginxArch'`

  更多详细内容查看[Dockerfile官方文档](https://docs.docker.com/engine/reference/builder/)    [Dockerfile最佳实践](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)

# 容器操作

## 容器状态

```shell
#查询容器 不使用-a则只能查看正在运行的容器。
docker ps -a
#容器详情
docker inspect 容器名或容器id
#容器日志
docker logs 容器名或容器id
```

## 创建、运行和删除

```shell
#创建容器
docker create -it base/archlinux
docker create -it --name 容器名 base/archlinux
#创建并运行容器
docker run -d -it --rm --name 容器名 --hostname 主机名 base/archlinux /bin/bash

#删除一个容器
docker rm 容器名或容器ID
#删除所有容器
docker rm `docker ps -a -q`
```

在run后指定该容器基于的镜像

- `-i`交互式操作
- `-t`打开终端


- `--name`参数给容器命名
  - 容器重命名`docker rename 原名 新名`

- `-d`以守护进程
- `--rm`使用后删除容器
- `--hostname`设置主机名
- `/bin/bash`指定使用bash

## 启动、进入、重启和停止

```shell
docker start 容器名或容器ID
docker attach 容器名或容器ID
docker stop 容器名或容器ID
docker restart 容器名或容器ID
```

- start 开启容器
- attach 连接到开启的容器
- restart 重启
  - 始终重启`--restart=always`
  - 指定重启次数`--restart=on-failure:5`


- stop 停止



