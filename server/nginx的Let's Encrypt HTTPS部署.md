nginx的Let's Encrypt HTTPS部署

1. 关掉Nginx。
   `service nginx stop`

2. 安装Let's Encrypt。

   `git clone https://github.com/letsencrypt/letsencrypt`

3. 生成SSL证书
   `cd letsencrypt && ./letsencrypt-auto certonly --standalone`

运行standalone插件后，Let's Encrypt会进入初始化阶段，需要先后输入个人邮箱和域名信息。

证书生成，有包含如下内容的提示信息：
>IMPORTANT NOTES:
>Congratulations! Your certificate and chain have been saved at /etc/letsencrypt/live/example.com/fullchain.pem. 
>Your cert will expire on 20xx-xx-xx. To obtain a new version of the certificate in the future, simply run Let's Encrypt again.

这段文字提示了证书的存放位置（/etc/letsencrypt/live/example.com/fullchain.pem）和过期日期（20xx-xx-xx）。

4. 配置Nginx
   修改我们的虚拟主机配置文件，在listen后面把80改成443，并加SSL配置信息，然后在下面加入证书和密钥地址。
   示例：
```nginx
        listen 443 ssl;
        ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        ssl_ciphers AES256+EECDH:AES256+EDH:!aNULL;
```
如果要使的http都解析到htts可以使用重定向强制跳转，在虚拟主机配置文件例再添加一个sever，内容示例：
```nginx
server{
    listen 80;
    server_name example.com www.example.com;
    add_header Strict-Transport-Security max-age=15768000;
    return 301 https://$server_name$request_uri;
}
```
或者
```nginx
server { 
    listen  80;  
    server_name example.com;  
    rewrite ^(.*)$  https://$host$1 permanent;  
}  
```
保存，退出。

重启Nginx。