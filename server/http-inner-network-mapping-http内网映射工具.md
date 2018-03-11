[TOC]

# ngrok

1. 安装[ngrok](https://ngrok.com/)

2. 部署authtoken

   注册ngrok帐号（或使用github/google快捷方式登录后自动注册为新用户），获取一个当前用户的authtoken。

   （windows用户打开ngrok，Unix/Linux用户打开终端）安装authtoken:`ngrok -authtoken yourtoken`

   yourtoken指的是注册后获取的authtoken，登录后在[Get Started](https://dashboard.ngrok.com/get-started)页面可以获取。

3. 启动服务

   首先启动web服务器，然后启动ngrok服务：`ngrok http 80`（80是web服务器的端口，根据具体情况修改）

   在浏览器打开[localhost:4040](http://localhost:4040)（或者[127.0.0.1:4040](http://127.0.0.1：4040)），即可看到外网访问链接。

**付费用户**还可以设置固定子域名，`ngrok http -subdomain name 80`（name是要设置的子域名），直接访问name.ngrok.io即可。

# localtunnel

安装localtunel需要[nodejs](http://nodejs.cn/download/)

1. 安装localtunnel

   使用npm安装：`npm install -g localtunnel`

2. 启动服务

   首先开启web服务器，然后开启localtunel服务：`lt -p  80 -o`（80是web服务器的端口，根据具体情况修改）

   启动服务后，系统默认浏览器会自动访问该网站（因为使用了-o参数）。

   可使用-s参数指定子域名：`lt -p 80 -s test999 -o`（使用test999.localtunel.me访问）

选项：

| 选项                | 说明                   |
| ----------------- | -------------------- |
| --port 或 -p       | 本地web服务端口（**必须**指定）  |
| --host 或 -h       | 提供转发的主机（参看下文自建服务器）   |
| --local-host 或 -l | 本地主机                 |
| --open 或-o        | 自动在浏览器开启             |
| --subdomain 或-s   | 子域名（不使用该选项则会生成随机子域名） |

## 自建localtunnel服务器

[localtunnel-server项目地址](https://github.com/localtunnel/server)

```shell
git clone git://github.com/defunctzombie/localtunnel-server.git
cd localtunnel-server
npm install
bin/server --port 1234    #指定端口为1234
```

这样就可以在使用localtunnel服务时使用该自己的域名进行访问（以取代项目组提供的localtunel.me）：`lt --port 80 -h http://yourdomain.com:1234 -s test -o`（通过test.youdomain.com访问）。

选项（在localtunnel）

| 选项            | 说明                  |
| ------------- | ------------------- |
| --port        | 指定监听端口（默认80）        |
| --secure      | 使用https（默认不使用）      |
| --max-sockets | 同时建立转发服务的上限数（默认10个） |