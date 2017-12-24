nginx的[Let's Encrypt HTTPS](https://github.com/certbot/certbot)部署

1. 安装Let's Encrypt。

   安装`certbot`这个软件

   或者下载源码：`git clone https://github.com/certbot/certbot.git`

2. 生成SSL证书

   如果是安装的`certbot`，执行`certbot certonly`按照引导进行操作即可。

   如果是下载的源代码，在其目录中执行`./cerbot-auto`按照提示进行操作。也可以直接指定参数，例如：

   ```shell
   #为已经在运行的网站设置SSl证书使用-d进行指定域名即可
   ./certbot-auto --apache -d example.com -d www.example.com -d other.example.net
   #获取一个独立的ssl证书使用--standalone参数并设置邮箱  后续进行手动配置
   ./certbot-auto certonly --standalone --email admin@example.com -d example.com -d www.example.com -d other.example.net
   ./certbot-auto --help all    #获取所有帮助
   ```

   证书相关内容将生成在`/etc/letsencrypt/live/`目录下。

3. 配置

   - web服务器

     以Nginx为例，修改虚拟主机配置文件（server中的内容），将**监听端口改为`443 ssl`**（ 若要使用http2，在ssl后加上http2即可），并加SSL配置信息（证书和密钥的路径），配置示例：

     ```nginx
     listen  443 ssl http2;
     ssl_certificate  /etc/letsencrypt/live/xx.xxx/fullchain.pem;
     ssl_certificate_key  /etc/letsencrypt/live/xx.xx/privkey.pem;
     ssl_session_cache  shared:SSL:1m;
     ssl_session_timeout  10m;
     ssl_ciphers HIGH:!aNULL:!MD5;
     ssl_prefer_server_ciphers on;
     ```

     使http都解析到htts可以使用重定向强制跳转，在虚拟主机配置文件中再添加一个sever：

     ```nginx
     server{
         server_name example.com;
         add_header Strict-Transport-Security max-age=15768000;
         return 301 https://$server_name$request_uri;
     }
     ```

     或者

     ```nginx
     server{
         server_name example.com;
         rewrite ^(.*)$ https://$host$1 permanent;
     }
     ```

     保存，退出，重启Nginx。

   - FTP

     以vsftpd为例，生成一个standalone的ssl，然后在`/etc/vfstpd.conf`中添加相关配置：

     ```shell
     ssl_enable=YES  #开启ssl
     # allow_anon_ssl=NO
     # force_local_data_ssl=NO
     force_local_logins_ssl=YES
     #选择一个ssl版本
     ssl_sslv3=YES
     #ssl_tlsv1=YES
     #ssl_sslv2=YES
     rsa_cert_file=/xxx/fullchain.pem  #填写正确的路径
     rsa_private_key_file=/xxx/privatekey.pem  #填写正确的路径
     ```



4. 自动更新证书

   证书有使用期限，失效后需要重新生成。可以使用crontab建立周期任务更新证书：

   ```shell
   30 2 1 * * /usr/bin/certbot renew >> /var/log/le-renew.log 
   35 2 1 * * /usr/bin/systemctl reload nginx
   ```
