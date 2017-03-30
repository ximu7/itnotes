[TOC]

# 安装配置

- 安装docker（包名docker)

- 启动docker服务`systemctl start docker`

- 查看docker状态`docker info`

  使用非root账户运行docker`usermod -aG docker username`或`gpasswd -a user docker`，重新登入系统使之生效（或使用`newgrp docker`立即使其生效)

  ​

# 镜像使用

- 列出所有镜像`docker images`
- 删除镜像`docker rmi [image name]`

## 从仓库获取镜像

-  查找镜像docker search [key words]


   从[DockerHub](https://hub.docker.com/explore/)安装：`docker pull [options] [docker registry ]<resposiory name>:<tag name>`

   示例：

```shell
docker pull base/archlinux    #archlinux镜像
docker pull nginx    #nginx镜像
docker pull unbuntu:17.04    #ubuntu 17.04镜像   17.04是tag name
```

## Dockerfile构建镜像

- Dockerfile文件编写

> Dockerfile 是一个文本文件，其内包含了一条条的指令(Instruction)，每一条指令构建一层,因此每一条指令的内容,就是描述该层应当如何构建。

Dockerfile文件内容示例：

```dockerfile
# nginx in arch
FROM archlinux
MAINTAINER levinit "xx@yy.com"
RUN buildDeps=pacman -Syu nginx
RUN echo '<h1>Hello Docker!</h1>'  >  /usr/share/nginx/html/index.html
RUN systemctl start nginx
EXPOSE 80
```

默认情况下，RUN指令会在shell里使用命令包装器/bin/sh -c来执行，如果平台不支持shell，则无法运行，为了避免该情况，可以使用**exec格式的RUN**。

示例：`RUN ['pacman =','-Syy','nginx']`



-  `build`命令

  `docker build -t='levinit/nginxArch:v1'`

  v1是标签名(tag name)，如果没有设置标签名，则**默认使用latest标签**。

  添加更为详细的信息

  ```shell
  docker build -t='levinit/nginxArch:v1'\
  git@github.com:docker/webserver
  ```

  - `--no-cache`略过缓存功能，示例：`docker build --no-cache -t='levinit/nginxArch'`

  更多详细内容查看[Dockerfile官方文档](https://docs.docker.com/engine/reference/builder/)    [Dockerfile最佳实践](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)

## commit方法构建镜像

对已有镜像建立容器-->运行该容器-->进入容器进行相关修改-->退出容器-->使用`commit`命令进行创建。`docker commit [options] <docker name or docker id> [<resposiory name>[:<tag name>]]`

如在该容器arch中安装配置了nginx，退出后执行`docker commit arch  levinit/NginxArch`

添加该镜像的详细信息示例：

```shell
docker commit \
--author "levinit" \
--message "archlinux with nignx" \
webserver \
nginx:v2
sha256:07e33465974800ce65751acc279adc6ed2dc5ed4e0838f8b86f0c87aa
1795214
```

# 容器运行

## 容器操作

- 新建一个容器

  `docker create -it base/archlinux`

- 新（建立并）运行一个容器

  `docker run -it base/archlinux /bin/bash`


base/archlinux 要使用的基础镜像，-i交互式操作，-t打开终端，/bin/bash使用bash。

  - `--rm`参数可以在退出容器后将其删除

    `docker run -it --rm base/archlinux /bin/bash`

  - `--name [docker name]`可以给容器命名

    `docker run --name arch -it base/archlinux /bin/bash`

    `arch`是容器名，容器名只能使用数字、字母、点号、横线和下划线。

    - 重命名`docker rename [old name] [new name] `

- `-h HOSTNAME or --hostname=HOSTNAME`  配置容器主机名

  `docker run --name arch --hostname=arch -it base/archlinux /bin/bash`

- 运行、重启、停止和登录（正在运行的）容器

  - 运行一个停止的容器`docker start [docker name or docker id]`

    以守护进程运行容器：添加`-d`选项

    示例：

  ```shell
  docker start arch    #运行一个名为arch的容器
  docker start aa3ad76f0f4e     #运行id为aa3ad76f0f4e的容器
  ```

  后续示例使用**arch**代之一个容器的名字。

  - 登录
    - `attach`
    - `docker exec -it arch bash`
  - 重启`restart`
    - 自动重启
      - 始终重启`--restart=always`
      - 指定重启次数`--restart=on-failure:5`
  - 停止`stop`

- 在容器内运行进程`docker exec -d arch /etc/example`

  `/etc/example`是要运行的文件的路径。

- 删除容器`docker rm [docker name or docker id]`

  - 删除所有容器

    ````
     docker rm `docker ps -a -q`
    ````

- 退出容器：使用exit或C^d

## 容器状态

- 查询容器`docker ps -a`

  `-a`可以查看所有的容器，不使用`-a`则只能查看正在运行的容器。

- 容器详情`docker inspect arch`（返回json形式数据）

  - `-f`或`--format` 获取指定信息

    示例

    ```shell
    docker inspect --format='{{ .State.Running}}' arch    #a查看docker是否运行
     #查看ip地址
    docker inspect --format '{{.NetworkSettings.IPAddress}}'\
    arch
    ```

- 查看日志`docker logs arch`

  - `-f`监控docker日志
  - `-t`日志添加事件戳
  - `--tail [n] `最近的n条日志 `docker logs --tail 0  -f bg_docker`监控最新的日志

- 查看容器内部进程`docker top arch`

  ​

  ​

---

docker中 启动所有的容器命令

`docker start $(docker ps -a | awk '{ print $1}' | tail -n +2)`

docker中    关闭所有的容器命令

`docker stop $(docker ps -a | awk '{ print $1}' | tail -n +2)`

docker中 删除所有的容器命令

`docker rm $(docker ps -a | awk '{ print $1}' | tail -n +2)`

docker中    删除所有的镜像

`docker rmi $(docker images | awk '{print $3}' |tail -n +2)`