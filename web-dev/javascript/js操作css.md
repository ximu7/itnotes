[TOC]

---

# 获取样式

## 元素对象宽高位置距离等属性

如offsetWidht、cilentWidht、scrollWidth……

示例：`let width=obj.offsetWidht`

注意：

-   只能获取属性值（**只读**）
-   （这些宽高距离的）值是数字

## style对象的属性

-   获取所有样式（样式的内容，字符串形式）：cssText 

     示例：`obj.style.cssText`  

- 获取单项样式

  示例：`obj.style.width`

注意：

-   需要用属性名cssFloat代替float（float是js关键字）
-   取得的属性值带有**单位**（如果有单位）
-   只能获取**行内样式**（html标签中的样式）
-   可以获取和设置（**可读可写**）

## getComputedStyle()  方法

获取当前元素所有**最终**使用的CSS属性值。

 ie8-使用 `getCurrentStyle`（**元素对象的方法**）

接收两个参数：元素对象和要匹配的伪元素的字符串（普通元素省略或null）

示例：`let style=window.getComputedStyle(obj,null)`

**返回一个对象**，可用以下方式使用该对象：

-   通过属性名获取相应属性值
    示例：`window.getComputedStyle(obj, null).color;`  

-   getPropertyCSSValue()方法

    接收一个参数：属性名（带引号，不要是用驼峰法书写）

    返回一个好汉给定属性值的CSSValue对象，该对象有3个属性：primitiveType、cssText和cssValueType。

    示例：`window.getComputedStyle(obj,null).getPropertyCSSValue('color').cssText`

- getPropertyValue()方法
    可以获取CSS样式**申明**对象上的属性值（直接属性名称）
    接收一个参数：属性名（带引号，不要是用驼峰法书写）
    示例：`window.getComputedStyle(obj, null).getPropertyValue("background-color");`



注意：

- 全局对象的方法
- 只能获取样式（**只读**）
- 能获取默认、继承的属性
- 返回的值带有单位（如果有）
- **获取最终样式值**


## getClientRects()方法和getBoundingClientRect()方法

元素对象的方法。

### getClientRects() 获取元素矩形区域

获取元素占据页面的所有矩形区域

返回值一个TextRectangle对象集合，包含：top left bottom right width height 六个属性（上下左右宽高）

示例： `let rectCollection = obj.getClientRects();`

注意：

-   只用于**行内元素**
-   只能获取样式（**只读**）

### getBoundingClientRect()获取元素位置

于获得页面中某个元素的左，上，右和下分别相对浏览器视窗的位置。

返回值一个对象，具有6个属性：top,lef,right,bottom,width,height。

示例：`let eleInfo= obj.getBoundingClientRect();`

注意：

-   获取的位置是元素**相对于的视口的位置**

    right是指元素**右边界距窗口最左边的距离**，bottom是指**元素下边界距窗口最上面的距离**。

- 只能获取样式（**只读**）

## CSSStyleSheets对象的属性和方法

`document.styleSheets`返回文档的样式表列表（样式表对象的集合）。
示例：`document.styleSheets`
属性：cssRules，是一个类数组对象CSSStyleRule，其元素是包含样式表中CSS规则。
CSSStyleRule对象的属性：cssRules 
`document.styleSheets.cssRules`
cssRules 属性，返回**类数组对象**，该对象其包含样式表中所有 CSS 规则。

cssRules对象的属性（获取的属性值是字符串）

- cssText  返回该条规则
  示例:`document.styleSheets[0].cssRules[0].cssText`以下类推
- style.cssText 返回该条规则的**所有**样式声明
- style.[attr]   返回某个属性  
  示例：`document.styleSheets[0].cssRules[0].style.width`
- selectorText  返回该条规则的选择器
- parentRule 返回包含规则（如果有，如 @media 块中的样式规则）
  ……

  注意： 以上属性**只读**

# 设置样式

## 直接设置属性

某些元素如img可以直接设置css样式：
示例：`obj.setAttribute('width','100%')`或`obj.width='100%'`
## style属性

set/removeAttribute()设置style属性的值
示例：`obj.setAttribute('style','widht:100px!important')`
##  style对象的属性和方法

用法参照上文styel对象
-   cssText，使用字符串形式设置样式
-   单一样式    
    注意：
    - **带上单位**（如果需要）
    - 使用驼峰形式或将属性名（带引号）写在中括号[]中

### setProperty()方法和removeProperty方法

setProperty()接收两个参数：属性名和属性值

示例：`obj.style.setProperty('padding','1px 2px 2px 1px')`

remoeProperty()方法接收一个参数：属性名

示例：`obj.style.removeProperty('color')`

##   class/id

给元素对象增/改/删className或者idName。相应的class/id设置有相关样式。
- set/removeAttribute()方法
   示例： `obj.setAttribute('class','className') `  `obj.removeAttribute('class',className)` 
- className属性
   示例：`obj.className=className`
- set/removeNamedItem()方法
   示例：
```javascript
let attrName=document.createAttribute('class');
let attrName.nodeValue='className';//一个已经存在的class
obj.attributes.setNamedItem(attrName)
```
  	`obj.attributes.removeNamedItem(attrName)`

## style标签/节点

- innerHTML或textContent 写入/清空
- style节点增/删
  ……
## 样式表（link标签/节点）

- addRule()方法和insertRule()方法
  接收两个参数：规则和内容
- link节点
  示例（添加样式表）：
```javascript
let linkNew=document.creatElement('link');
linkNew=setAttribute('rel','stylesheet');
linkNew=setAttribute('hreft','new.css');
document.head.appendChild(link);
```
- innerHTML
- 更改link的href
  ……
### CSSStyleSheets对象的属性和方法

-   disable 属性：打开或关闭一张样式表。
  示例：`document.styleSheets[0].disabled`
-   delteRule()方法和insertRule()方法
   CSSStyleSheets()方法返回的对象（CSSStyleRule类数组对象）的方法。
    ie使用addRule()和removeRule()
-   deleteRule()接收一个参数：cssRules的下标（某条规则的序号/位置）
    示例：`document.styleSheets[0].delete(0)`
-   insertRule()接收两个参数：样式规则和插入位置（cssRules的下标）
    示例：`document.styleSheets[0].insertRule("left-col{float:left;color:red},1)`

## innerHTML(textContent)

- innerHTML写入样式表
  示例：`document.getElementByTagName('head')[0].innerHTML+= <link rel="stylesheet" href="new.css">`
- innerHTML或textContent增/删style标签  更改style标签的内容
  参照上面

- innerHTML（新建元素节点）中写入行内样式/id/class

  示例：`obj.innerHTML=<span style="color:red">red</span>`
  ……
  ……
  ……
