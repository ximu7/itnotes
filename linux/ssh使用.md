- ssh登录

```bash
ssh username@ip     #username用户名, ip（或者url）主机地址 
ssh -p 2333 username@ip     #-p指定端口（更改了默认端口时使用
```
---

**ssh使用密钥免密码登录**

- 生成密钥
```shell
ssh-keygen -t rsa   #-t 指定加密类型rsa/dsa,默认
ssh-keygen     #相当于 ssh-keygen -t rsa
```
- 上传密钥

  ssh-copy-id
```shell
ssh-copy-id username@ip
#-i指定一个公钥（有多个公钥时使用）
ssh-copy-id -i ~/.ssh/test.pub username@ip
```

上传时和首次登录时需要输入密码。

如果已经上传秘钥还是不能免密码登录，可能时权限问题，服务器上用户的**~/.ssh/authorized_keys文件的权限设为600**，**~/.ssh文件夹权限设为700**  

```shell
chomd 600 authorized_keys
chmod 700 .ssh
```



其他添加方法

​	手动添加：

​		添加公钥到服务端~/.ssh/authorized_keys文件内

​		首先上传公钥文件id_rsa.pub到目标主机(如使用ftp上传)，然后将id_rsa.pub内	容添加到~/.ssh/authorized_keys中。

   

​	使用scp上传

​	scp是基于ssh的远程复制，	使用类似cp命令。如需	指定端口使用-P，且需要紧跟在scp之后。

```bash
#将当前目录下test文件复制到远程主机登录用户的主目录下scp username@ip:~/test ./ 
#将远程主机登录用户主目录下test文件复制到当前目录scp
scp root@ip:~/root/abc  ./
#复制本地公钥到远程主机 并将其命名为authorized_keys
scp ~/.ssh/id_rsa.pub root@ip:/root/.ssh/authorized_keys
#指定端口需要紧跟在scp之后
scp -P 999 ~/.ssh/id_rsa.pub root@ip:/root.ssh/authorized_keys
```

---

- 使用pem证书登录
  将ssh-keygen生成的id_rsa文件（私钥）重命名为.pem后缀的文件。
  使用.pem需要禁用ssh设置中的`PasswordAuthentication`。
  编辑vim /etc/ssh/sshd_config，找到`# PasswordAuthentication yes`一行 ,改为
  `:PasswordAuthentication no`。
  重启ssh服务
