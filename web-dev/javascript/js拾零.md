[TOC]

# 事件

- 下拉框（select）选项（option）的事件：**只**需再select上添加change事件即可，在change事件的方法中使用options（select下各个option的集合）的属性和方法来对不同option进行种操作。（chrome不支持在option上添加的click事件，firefox支持）

- 获取select下拉列表中当前被选中的option的内容（option标签之间的文本）的方法：（以下例子中oS代表当前select对象）

    - 获取**options对象中被选中的项的value值**：`oS.options[oS.options.selectedIndex].value`

      selectedIndex是当前被选中的option的下标

    - **select对象的value值**：`oS.value`

      选择了新的option项，select的value会随之改变。​

- 阻止冒泡是`event.stopPropagation()`，阻止默认行为是`event.preventDefault(); `。

    - 在jQuery中return false相当于同时使用event.preventDefault和event.stopPropagation；
    - 原生js使用`return false`只会阻止默认行为并阻止默认行为。

- 事件委托中获取触发事件的子元素的下标（index)：遍历子元素，判断和事件目标（even.target）相等的元素，获得该元素的下标。

```javascript
  let index = 0;
  		for (let i = 0; i < obj.oL.length; i++) {
          		if (e.target === obj.oL[x]) {
                  		index = i;
              	}
           }
```

# 字符串

- slice,substr和substring切割字符串。它们都接收两个参数，区别：
    - slice和substring接收的是**起始位置和结束位置**(不包括结束位置，前开后闭区间)；substr接收的则是**起始位置和所要返回的字符串长度**。
    - substring是以两个参数中较小一个作为起始位置，较大的参数作为结束位置。
    - 当接收的参数是负数时：slice会将它字符串的长度与对应的负数相加，结果作为参数；substr则仅仅是将第一个参数与字符串长度相加后的结果作为第一个参数；substring则干脆将负参数都直接转换为0。


-   `num.toLocaleString('zh-Hans-CN-u-nu-hanidec',{useGrouping:false})`(num是一个阿拉伯数字)可以将数字转为简体中文格式。*此方法只会对数字逐一转换，并不会出现进制单位如“百”，{useGrouping:false}是为了删除每三位一个逗号分割的情况。*


# 数组

-   filter方法会不会改变原始数组；sort方法会改变原始数组。
-   array.splice在**删除**元素的情况下返回一个含有删除元素的数组。


# DOM

-   style可以**获取或设置相应的值** （可读写），如obj.style.width，**获取的值带单位** （如果有）如px，style对象**只能获取行内的**style属性的值（写在标签中的属性 当然写入style也是行内的）。
    元素对象的obj.offsetWidth等相关属性**只能获取** （只读）相应的值，获取的值不带单位。
-   *只是获取或写入文本**应使用`textContent`属性而不是`innerHTML`属性。(IE9+)


- img和li标签后会出现空白文本节点（在html代码中的空白会被浏览器误认为空的文本节点），使用时注意判断nodeType或者使用children（操纵元素节点的情况）或者用类似如下方法清除掉空白节点：

  ```javascript
  function cleanWhitespace(oEelement){  
           for(var i=0;i<oEelement.childNodes.length;i++){  
           		var node=oEelement.childNodes[i];  
          	 	if(node.nodeType==3 && !/\S/.test(node.nodeValue)){  
                  		node.parentNode.removeChild(node)  
              }  
        }  
   }  
  ```

  ​

- HTML事件处理程序中，在不传参（不传入context）的情况下，其调用的函数中的this指向window，可以将this作为参数传入，以获取触发事件的节点对象。

  ```html
  <button onclick="clickBtn1()">this是什么</button>
  <script>
  function clickBtn1(){
          alert(this);//this指向window
      }
  </script>
  <button onclick="clickBtn2(this)">this是什么</button>
  <script>
  function clickBtn2(obj){
          alert(obj);//obj指向该button
      }
  </script>	
  ```

- float是javascript关键字，js中操作style的float属性应该使用cssFloat代替（在非标准ie中使用styleFloat）。

- **事件**处理程序和**定时器**的方法会改变this指向。**事件**处理程序中的this指向触发事件的元素；**定时器**中的this指向window（定时器方法定义在window下）。

  - **构造函数**中的this指向新创建的对象。
  - 全局范围内this指向window
  - 对象方法调用中的this指向该对象（obj.test()中，this指向obj）