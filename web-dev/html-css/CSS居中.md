速览：
- 内联
    - 水平居中：text-align:center
    - 垂直居中：
        - 上下等padding值
        - line-height=height
        - vertical-align:middle（inline-block水平的元素）

- 块级
    - 定位+50%偏移
        - 知悉元素宽高，精确计算负margin值
        - 可不知悉元素宽高，transform的translate-50%
    - 定位+上下左右0偏移+margin:auto
    - 弹性盒子flex
        - 仅需父元素display:flex+align-items:center+justify-content:center
        - 父元素display:flex+子元素magrin:auto
    - object-fit（针对可替换元素如img video table）
[TOC]

 ---

注：“已知”/“未知”意思是对元素设置样式时知道/不知道（或者需要知道/不需要知道）元素的宽高，未知宽高不需要考虑精确计算相关数值。

# 内联元素的水平居中(块级父元素text-align:center)

父元素（块级）设置：
```css
.parent-element {
  text-align: center;
}
```

# 内联元素的垂直居中(上下等padding值)

多行内容居中，且容器高度可变（否则得精确计算padding值）：
```css
.center-element{
  padding-top:10px;
  padding-bottom:10px;
}
```

# 内联元素的垂直居中（与块级父元素height值相等的line-height值）
要居中的元素的line-heigth值和块级父元素的height值一样：
```css
.parent-element{
  width:80%;;height:100px;
}
.center-element{
  line-height: 100px;
}
```

# 内联-块级元素的垂直居中(vertical-align:middle)
*vertical-align仅作用于inline-block水平的元素，但是在inline元素和inline-block元素混排时（如图片加文字）,inline-block元素设置vertical-align后影响inline水平元素的位置改变。*
对要进行居中的元素设置：
```css
.center-element{
  vertical-aling-middle;
}
```

# 块级元素的水平居中(margin:0 auto)
   *不设置元素宽度，其会撑满整个容器，无法看出居中效果。*
```css
.center-element {
  width:100px;height:100px;
  margin: 0 auto;
}
```

# 已知宽度和高度的块级元素的居中（计算固定值进行绝对定位）

*对其父元素设置相对定位，对要居中的子元素设置绝对定位，然后设置50%top值和height值一半的margin-top值：*

```css
.parent-element {
  position: relative;
}
.center-element {
  position: absolute;
  height: 100px;width:100px;
  top: 50%;left:50%;
  margin-top:-50px;
  margin-left:-50px;
}
```

# 未知宽度和高度的块级元素的居中（绝对定位+50%值偏移）

对其父元素设置相对定位，对要居中的子元素设置绝对定位，然后设置50%的top值和50%的left值以及-50%的translate值：

```css
.parent-element {
  position: relative;
}
.center-element {
  position: absolute;
  top: 50%;left:50%;
  transform: translate(-50%,-50%);
}
```

# 未知宽度和高度的元素的完全居中（上下左右为0+margin:auto的绝对定位）

父元素设置相对定位，子元素设置绝对定位且值为0的上下左右定位和值为auto的margin：

```css
.parent-element{
  positon:relative;
}
.center-element{
  positon:absolute;
  top:0;bottom:0;left:0;right:0;
  margin:auto;
}
```

# 弹性盒子内部元素居中（父元素display:flex+align-items:center+justify-content:center）
要居中的元素的父元素设置：
```css
.parent-element{
  display:flex;
  justify-content:center;/*水平轴上居中*/
  align-items:center;/*垂直轴上居中*/
}
```

# 弹性盒子内部元素居中（父元素display:flex+子元素magrin:auto）
要居中的元素的父元素设置`display:flex`，要居中的元素设置`margin:auto`：
```css
.parent{
  display:flex;
  width:100px;height:100px;
}
.child{
  margin: auto;
  width: 50px;height: 50px;
}
```

# 可替换元素使用object-fit完全居中

**object-fit 只能用于『可替换元素』(replaced element) 。***(比如： img、 object、 video 和 表单元素，如textarea、 input，audio 和 canvas在一些特殊情况下，也可以作为可替换元素。)*
**在使用 object-fit 时，一定要设定元素的size，也就是 width 和 height。**
另，还有相应的object-positon属性（默认值是`50% 50%`，也就是居中），对元素定位控制，类似background-postion。
```css
.center-element{
	object-fit:fill|cover|contain|none|scale-down;
/*其属性值，分别是填充（默认）、包含、覆盖（可能被裁剪）、无变化（保持原状）和等比例缩放*/
}
```