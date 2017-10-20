> **事件是可以被 JavaScript 侦测到的行为。**

[TOC]

# 事件流

> 页面中接收事件的**顺序**。

## 事件流模型：冒泡 与 捕获

*假如目标元素是div*，二者的接收顺序分别如下：

- 冒泡：div>body>html>Document
- 捕获：Document>html>body>div

## DOM事件流

DOM标准采用捕获+冒泡。IE9、Firefox、Chrome、Opera、和Safari都支持DOM事件流。

DOM标准规定（DOM2级）事件流包括三个阶段，按顺序为：

1. 事件捕获阶段——**事件从Document开始传播**

   - 实际上浏览器是从window对象开始捕获的。
   - DOM2级事件标准规范规定事件捕获阶段不会涉及事件目标，但是浏览器会在捕获阶段也触发事件对象上的事件。（也就是有两次机会在目标对象上面操作事件）


2. 处于目标阶段——**事件在目标上发生并处理**（执行事件处理程序）

   注：事件处理会被看成是冒泡阶段的一部分。

3. 事件冒泡阶段——**事件传播回Document**

---
此外：
   > 所有的事件都要经过捕获阶段和处于目标阶段，但是有些事件会跳过冒泡阶段。

   例如：focus事件（获取焦点）和的blur事件（失去焦点）会跳过冒泡阶段。

# 事件处理程序

## HTML事件处理程序

在HTML标签中添加事件属性，该属性的值为要执行的脚本代码或者要调用的函数。

示例：

```html
<!-- 直接写上代码 -->
<input type="button" value="click me" onclick="alert('hi')" />
<!-- 调用方法 -->
<input type="button" value="click me" onclick="show()" />
<script type="text/javascript">
function show(){
	alert('hi');
}
</script>
```

## DOM0级事件处理程序

将函数赋值给一个事件处理程序的属性：首先取得要操作的对象；将一个函数赋值给该对象的事件处理程序。(事件名前面要用on，如click事件写成`onclick`)

删除事件处理程序方法：将事件处理程序属性设置为`null`;

```javascript
var ele=document.getElementById("btn");//取得一个id名为btn的元素对象
btn.onclick=function(){  //添加事件处理程序 
	alert('hi');
}
btn.onclick=null; // 删除事件处理程序 
```

实际上没有官方的DOM0标准，1998 年 10 月 才有W3C的推荐规范——DOM1级，DOM1级推出时并没有添加增加事件功能，而此前的事件功能的实现被习惯称为DOM0级。（IE4和Netscape 4.0这些浏览器最初支持的DHTML）。

## DOM2级事件处理程序

取得要操作的对象，向该对象使用`addEventListener("事件名",处理函数,false或true) `或 `removeEventListener("事件名",处理函数,false或true)`方法以添加或删除事件处理程序。

```javascript
var btn=document.getElementById("btn");
var fn=function(){  //事件处理的方法
	alert(this.id);
};
btn.addEventListener("click",fn,false);  //添加
btn.removeEventListener("click",fn,false);  //删除
```

IE8-使用`attachEvent()`和`deattatchEvent()`（事件名前面要用on，如click事件写成`onclick`）

## DOM3级事件处理程序

- DOM3添加一些新的事件（如XPath模块和加载与保存(Load and Save)模块）
- DOM3事件区分大小



# 事件对象

> 在触发DOM上的某个事件时，会在事件处理程序函数中会产生一个事件对象event，这个对象中包含着所有与事件有关的信息。

- 事件对象——W3C标准规定，事件对象通过事件函数的第一个参数（参数名随意）传入，兼容性写法：

```javascript
ele.onclick=function(ev){
    var e=ev||event;  //或window.event
  //some codes need Event object
}
```

或者定义一个获取事件对象的方法以便使用：

```javascript
getEvent: function(event) {
        return event ? event : window.event;
    }
```

- DOM2事件对象的属性

  - target    触发此事件的节点
  - currentTarget   事件监听器触发该事件的节点

  ---

  target和currentTarget：

  target在事件流的目标阶段；currentTarget可在事件流任何阶段。currentTarget是事件处理程序当前正在处理事件的那个元素，只有当事件流处在目标阶段的时候，两个的指向才是一样的。

  ---

  - timeStamp    事件生成的日期和时间
  - type    当前 Event 对象表示的事件的名称
  - bubbles    事件是否是起泡事件类型。
  - cancelable   事件是否可拥可取消的默认动作
  - eventPhase   事件传播的当前阶段

- DOM2事件对象方法

  - preventDefault() 	阻止事件的默认动作
  - stopPropagation()    中止事件传播
  - initEvent()    初始化新创建的 Event 对象的属性

附：兼容低版本IE的事件对象

- 事件对象的目标节点

  `event.target||event.srcElement`

- 阻止浏览器默认行为

  `event.preventDefault ? event.preventDefault() : (event.returnValue = false);`


- 阻止冒泡写法

  `event.stopPropagation ? event.stopPropagation() : (event.cancelBubble = true);`

# 事件委托

解决事件处理程序过多影响的情况。

例如对某ul下的多个li添加点击事件处理程序：

```javascript
var list = document.getElementById("lists");  //获取id为lists的ul对象
list.addHandler("click", function(ev) {  //给ul对象绑定事件处理程序
    var e=ev||event;
    var target = e.target;  //获取真正触发点击的元素

    switch(target.id) {  //针对每个元素添加不同的事件处理程序
        case "a":  //id为a的li元素
            location.href = "http://www.w3.org";
            break;
        case "b":  //id为b的li元素
            alert("Me");
            break;
        case "c":  //id为c的li元素
            alert("Hi");
            break;
    }
});
```