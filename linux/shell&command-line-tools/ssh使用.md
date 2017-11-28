[TOC]

# ssh登录

```bash
ssh username@ip     #username用户名, ip（或者url）主机地址 
ssh -p 2333 username@ip     #-p指定端口（更改了默认端口时使用
```
## ssh使用密钥免密码登录

### 生成密钥`ssh-keygen`

```shell
ssh-keygen -t rsa   #-t 指定加密类型rsa/dsa,默认
ssh-keygen     #相当于 ssh-keygen -t rsa
```
### 上传密钥

#### `ssh-copy-id`上传

```shell
ssh-copy-id username@ip
#-i指定一个公钥（有多个公钥时使用）
ssh-copy-id -i ~/.ssh/test.pub username@ip
```

---

#### 手动添加公钥（FTP/SCP等）

将客户端生成的**`id_rsa.pub`内容**添加到服务端的`~/.ssh/authorized_keys`中。

- 使用ftp工具上传  略

- 使用scp命令上传

  scp是基于ssh的远程复制，使用类似cp命令。

  附常用相关选项（注意：选项要紧跟scp后，不要放到命令末尾）

  - -P  指定远程主机的端口号
  - -C  使用压缩
  - -r  递归方式复制（即复制文件夹下所有内容）
  - -p  保留文件的权限、修改时间、最后访问时间
  - -q  静默模式（不显示复制进度）
  - -F  指定配置文件

  ```shell
  #将当前目录下test文件复制到远程主机登录用户的主目录下scp username@ip:~/test ./ 
  #将远程主机登录用户主目录下test文件复制到当前目录scp
  scp root@ip:~/root/abc  ./
  #复制本地公钥到远程主机 并将其命名为authorized_keys
  scp ~/.ssh/id_rsa.pub root@ip:/root/.ssh/authorized_keys
  #指定端口需要紧跟在scp之后
  scp -P 999 ~/.ssh/id_rsa.pub root@ip:/root.ssh/authorized_keys
  ```


### 注意事项

- 上传时和上传后的首次登录需要输入密码。

- 如果已经上传秘钥还是不能免密码登录，可能时权限问题，服务器上用户的**~/.ssh/authorized_keys文件的权限设为600**，**~/.ssh文件夹权限设为700**

  ```shell
  chomd 600 authorized_keys
  chmod 700 .ssh
  ```