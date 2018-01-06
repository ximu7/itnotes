[TOC]

# 基本

- 数据类型判断
  - `typeof xx`  仅用于基本类型判断  ！注意：
    - null是object
    - 数组是object
    - 能够判断function
  - `xx.constractor`  通过构造函数判断
  - `xx instanceof Array`  判断是否为某类型
  - `Object.prototype.toString.call(xx)==='[object Array]'`   最保险的判断
- Math.ramdom()生成的小数位数不是固定的


- 容易被误用作标识符的JavaScript关键字：float、class、top

  在获取/设置元素的style属性时，浮动应该使用`cssFloat`而不是`float`

- setTimeout的时间即使设置为0也会执行

  ```javascript
  setTimeout(function(){console.log(2)},0);  //后打印该行
  console.log(1);  //先打印该行
  ```


## 字符串

- String对象的方法：slice,substr和substring
  - slice还可用于数组
  - slice和substring的参数是**起始位置**和**结束位置**， substr的参数是**起始位置****和**要返回的字符串长度**。
  - substring的始终以两个参数中较小一个作为起始位置。
  - 当接收的参数是负数时：
    - slice：将字符串的长度与对应的负数相加的结果作为参数
    - substring：负参数转换为0
    - substr：将第一个参数与字符串长度相加后的结果作为第一个参数


- `num.toLocaleString('zh-Hans-CN-u-nu-hanidec',{useGrouping:false})`(num是一个阿拉伯数字)可以将数字转为简体中文格式。

  *此方法只会对数字逐一转换，并不会出现进制单位如“百”，{useGrouping:false}是为了删除每三位一个逗号分割的情况。*

## 数组

- filter方法会不会改变原始数组；sort方法会改变原始数组。
- array.splice在**删除**元素的情况下返回一个含有删除元素的数组。
- 使用set对数组去重很方便。

## DOM

- 元素对象的obj.offsetWidth等相关属性**只能获取** （只读）相应的值，获取的值**不带单位**。

##  事件

- `DOMContentLoad`事件在所有节点加载完毕后就会触发，很多时候可用其代替`load`

- 下拉框select的选项option的选择不要用click事件（chrome不支持在option上添加的click事件，firefox支持）

    应该在select监听使用change事件，在事件处理函数中使用options对象的属性和方法来对不同option进行种操作。

    - 获取**options对象中被选中的项的value值**：`oS.options[oS.options.selectedIndex].value`

      selectedIndex是当前被选中的option的下标

    - **select对象的value值**：`oS.value`

      选择了新的option项，select的value会随之改变。​

- 阻止冒泡是`event.stopPropagation()`，阻止默认行为是`event.preventDefault(); `。

    - 在jQuery中return false相当于同时使用event.preventDefault和event.stopPropagation；
    - 原生js使用`return false`只会阻止默认行为并阻止默认行为。

- 解除事件绑定

    - 不再使用的事件绑定应该适时解除
    - 如果在某事件处理函数中对另一节点使用DOM2级进行事件绑定，务必记得对另一节点的事件绑定适时解除（或者改用DOM0级事件进行覆盖），否则该事件处理函数反复调用时会造成事件累加
