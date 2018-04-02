[TOC]

# border-width的默认值

默认值为medium，宽度为3px。（可能）因为`border-style:double`（双线风格边框）需要3px才能识别。

# border-style图形妙用

## IE下的CSS圆

（`border-style:dotted;`的虚线边框在IE下是圆形构成）：

*父元素overflow:hidden;子元素设置比父元素width小1px的dotted风格边框。*

```css
.parent-box{
    width:100px;height:100px;/*需要设置的圆形直径（宽度）*/
    overflow:hidden;/*多余内容隐藏掉*/
}
.child-dotted{
    width:100%;height:100%;/*同父元素宽高*/
    border:99px dotted red; /*设置上dotted风格的边框*/
}
```

## 三道杠

```css
  .box{
      width:120px;height:120px;
      border-top:60px double;/*上方使用dounble双线风格绘出两条*/
      border-bottom:20px solid;/*下方borde绘出r第三条*/
  }
```

## border和三角形
如左上直角的三角：
```css
.triangle{
    border-width:10px 20px;
    border-style:solid;
    border-color:red red transparent transparent;
}
```
下三角：
```css
.triangle{
  	width:100px;height:100px;
  	border:100px solid;
  	border-color:red transparent transparent transparent;
}
```

# border-color特性

  没有制定border-color的时候，会使用color的颜色做边框色。



# border透明边框

## 辅助background-postion定位

*如利用设置透明右边框，设置距离右侧50px的background-position定位。*

```css
.img-postion{
    border-right:50px solid transparent;
    background-position:100% 50px;
}
```
## 增加复选框点击相应区域大小

*边框使用盒阴影(inset)，原先border设置透明。*

```css
.checkbox{
  border:2px solid transparent;
  box-shadow:inset 0 1px,inset 1px 0,inset -1px 0,inset 0 -1px;
  background-color:#fff;
  background-clip:content-box;
  color:red;
}
```

# border布局

border设置等高布局：

*用（左右）边框模拟一栏，结合负的margin值将内容定位到border上，实现box这一栏的高度和其边框模拟的这一栏高度一致。（限制：border不能设置百分比）*

```css
.box-column2{
  border-left:500px solid #222;/*左边设置一定宽度的边框用来模拟一栏*/
}
.left-column1{
  width:500px;
  margin-left:-500px;/*设置负的margin值将内容放置到border模拟的栏上去*/
  float:left;
}
```



# 表格边框单线显示

表格单元格的边框默认是双线边框，显示为单一的边框：

在`table`上应用`border-collapse:collapse;`即可。