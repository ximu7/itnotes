 部署lnmp环境

[TOC]

LNMP（linux,nginx,mariadb,php）部署，以下默认在root权限下操作，以centos７为例。

## 安装

- 安装nmp(nginx-mariadb-php)

`yum install nginx mariadb-server php php-fpm`

- 设置开机启动并立即启动服务：

`systemctl enable nginx mariadb php-fpm && systemctl start nginx mariadb php-fpm`

- 可安装phpmyadmin方便管理mariadb数据库：

`yum install phpmyadmin`


## 配置

### mariadb配置

`mysql_secure_installation`

回车>根据提示输入Y>输入2次密码(不建议无密码)>回车>根据提示一路输入Y>最后出现：Thanks for using MariaDB!

### php配置
编辑**/etc/php.ini**文件，找到如**session.save_path**行，去掉注释，修改如下：

`session.save_path = "/var/lib/php/session"`

查看session目录是否存在，如果不存在，则手工创建 ： 
```shell
ls /var/lib/php/session
mkdir /var/lib/php/session
```
为确保权限符合，更改session目录文件权限：

`chown nginx:nginx /var/lib/php/session -R`

### phpmyadmin配置

复制phpMyAdmin目录到nginx根目录，以根目录为/srv/web为例：

`cp /usr/share/phpMyAdmin/ /srv/web/phpMyAdmin;`

！说明：centos以yum安装的phpmyadmin在/usr/share/目录下，archlinux的在/usr/share/webapps/目录下，其余发行版根据情操作。

phpMyAdmin可改为phpmyadmin或者其他便于操作的名字。如果更改了名字，那么nginx的配置时要改为相应的目录名称。

×也可软链接phpmyadmin目录：

`ln -sf /usr/share/phpMyAdmin /srv/web/phpMyAdmin`


### php-fpm配置
编辑/**etc/php-fpm.d/www.conf**如下：
```p
user = nginx #修改用户为nginx
group = nginx #修改组为nginx
```

### nginx配置

编辑/etc/nginx/conf.d/下的.conf文件，如果/etc/nginx/conf.d/中没有任何conf文件，下新建一个.conf文件，如website.conf，内容如下(据情况修改)：
```nginx
server {
  listen 80;#端口
  server_name www.xxx.com;#服务器名
  root /srv/web;#ngnix默认的主目录，可根据具体情况修改
  index index.php index.html;#默认主页
  location ~ \.php$ {#php解析
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
  }
}
```

*禁止通过ip直接访问网站，防止恶意解析，添加一个新的server：
```nginx
server{
        listen 80;
        server_name ip;#写上ip地址
        return 444;
}
```
在通过ip地址访问时会返回444http状态码，服务器不会返回信息给客户端，并且会关闭连接。
*


***权限问题**：nginx主目录的权限要求文件权限644，文件夹755，所有者为nginx的执行用户（默认是nginx组的nginx）,以根目录为/srv/web为例：

```shell
chown -R nginx.nginx /srv/web/
find /srv/web/ -type f -exec chmod 644 {} \;
find /srv/web/ -type d -exec chmod 755 {} \;
```
可以将3条命令写入bashrc以alias方式存储方便执行，如写进/etc/bashrc,nano.bashrc,再文件末尾写入：
`alias webroot='chown -R nginx.nginx /srv/web/ && find /srv/web/ -type d -exec chmod 755 {} \; && find /srv/web/ -type f -exec chmod 644 {} \;'`
保存并执行source /etc/bashrc 使其生效。以后遇到权限问题，只要执行webroot就可以了。

## 测试

配置完后，测试前重启所有服务：

`systemctl restart nginx mariadb php-fpm`

- 测试nginx：

`nginx -t`  

成功则返回如下内容：
>nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
>nginx: configuration file /etc/nginx/nginx.conf test is successful

- 登录网站测试，在浏览器打开域名或IP。

- 测试php解析：
  添加phpinfo.php测试文件到根目录，其内容为：

```php
<?php
phpinfo();
?>
```
保存后，打开网站，例如网址是xxx.com，浏览xxx.com/info.php，就可以看到php详情页面。

- mariadb测试，以主目录下phpMyAdmin名字未更改为例，例如网址是xxx.com，浏览xxx.com/phpMyAdmin进入到mariadb的登录页面，用户名root，密码是mariadb配置时输入的密码。


