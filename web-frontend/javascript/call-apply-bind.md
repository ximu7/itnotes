- call和apply都是对函数的直接调用
  - call的参数必须一一写出
  - apply的第二个参数是一个数组
- bind方法返回的仍然是一个函数，对其调用时后面还需要添加()。

```javascript
call(参数,参数,参数)
apply(参数,[参数,参数])
bind(参数)()  //bind(参数)是不会调用执行的
```

