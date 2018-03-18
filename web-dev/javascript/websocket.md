# 简介

> `WebSocket`对象提供了用于创建和管理 [WebSocket](https://developer.mozilla.org/zh-CN/docs/Web/API/WebSockets_API) 连接，以及可以通过该连接发送和接收数据的 API。

WebSocket协议缩写是ws，如果进行了加密，则是wss。

WebSocket是一个**持久化**的协议

> 在WebSocket API中，浏览器和服务器只需要完成一次握手，两者之间就直接可以建立持久性的连接，并进行双向数据传输。

WebSocket协议可以让服务端向客户端主动通信，向客户端推送消息，而HTTP协议只能是客户端向服务端请求而获取消息。

- 工作原理

  第一次连接使用HTTP协议，连接后升级为websocket协议：

  浏览器<---HTTP协议--->服务器 ==> 浏览器<---web socket协议--->服务器

WebSocket协议的握手兼容于HTTP的，使用HTTP的`Upgrade`设置可以将连接从HTTP升级到WebSocket。附nginx配置websocket简单示例：

```nginx
location /wsapp/ {
    proxy_pass https://wsapp.xx.xxx; 
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

# websocket创建

- websocket对象

  ```javascript
  const socket=new WebSocket('ws://127.0.0.1:8000');
  ```

  ​

