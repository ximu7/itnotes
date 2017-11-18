说明：

- **须知某些情况不设置元素宽高，无法看出居中效果，也就无所谓居中与否**。示例代码只是写出了该居中方法所需要的那部分样式，不一定写出了宽高（以及边框等）样式。
- 示例代码中，`.center-element`表示要被居中的元素，`parent-element` 表示要居中的元素的父元素。
- **inline元素**，准确来说，是不可替换（non-replace）的inline元素，**不能设置竖直方向上的margin和padding**。（参看[margin规定](http://www.w3.org/TR/CSS2/box.html#margin-properties)和[padding规定](http://www.w3.org/TR/CSS2/box.html#padding-propertie) ，之所以不能设置padding，是因为padding的值是根据目标元素的width计算出来的，而inline中的non-replace元素的width是不确定的。）


- CSS兼容性情况未作说明，具体自行查阅。
- 推荐使用那些不必使用到精确数值的方法。

[TOC]

---

# margin/padding值设置居中

最基础的方法是设置**精确的**padding（父元素上）或margin（子元素上）**值**使得子元素居中，这里不再示例。以下方法使用更加容易：

## clac计算数值

margin值为父容器宽/高的50%减去自身宽/高的50%：

```css
.center-element{
  width: 20rem;height: 20rem;
  margin-left:calc(50% - 10rem);
  margin-top:calc(50% - 10rem);
}
```

注意：inline水平的元素margin/padding设置**仅在左右方向上有效**。

## margin:0 auto左右居中

要居中的**块级元素（block）**元素设置`margin:0 auto` 。

注意：**对浮动元素、绝对定位和固定定位的元素无效** 。（注意：使用绝对定位+[偏移量0+margin:auto](偏移量0+margin:auto)方法中使用了四个方向的值为0偏移量例外）

# text-align:center水平居中

在**块级父元素**设置text-aling:center，其**inline或inline-block**子元素会进居中。

# line-height垂直居中

用于**单行的行内（inline）元素**的垂直居中，将要居中的元素的line-heigth值设置为和其**块级父元素**的height值一样。
```css
.parent-element{
  height:100px;
}
.center-element{
  line-height: 100px;
}
```

>  对于块级元素，line-height指定了其内部元素line-boxes的最小高度。

# vertical-align:middle垂直居中

要居中的元素上设置：`vertical-align:middle` 。

适用于：

- inline或inline-block元素
- 表格单元格（table-cell）元素
- [`::first-letter`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/::first-letter) 和 [`::first-line`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/::first-line) 伪元素

注意：

**inline/linline-block元素的vertical-align取值与基线（baseline）有关**(vertical-align的默认值就是baseline) ，基线是（该字体中）**英文小写字母X的下端**所在的水平线。

> 该属性定义了行内元素的基线相对于该元素所在行的基线的垂直对齐

设置为middle也不一定是真正的对齐，不同风格的字体常有不同的baseline标准，设置为middle值其实是将**该元素的中垂点**与其**父元素基线高度+父元素中小写字母x的高度的一半**的位置对齐。

# 表格内容居中

- 表格式布局：根据语义化原则，使用表格布局非表格的内容已不再合适，而且表格的`<td>` `<th>`标签的align和valign属性已经是HTML的废除标签属性，**建议不要使用**。
- 非表格元素模拟表格：可以使用`display:table-cell` 模拟其为一个表格，由于不建议使用废除的align和valign标签属性，故而也就`vertical-align:middle` 垂直居中具有实用性，将元素模拟成表格进行垂直居中意义也不大了，因此**建议不要使用**。
- 真正的表格，**表格内容的居中**：
  - 水平：`text-align:center` 
  - 垂直：`vertical-align:middle`
  - 也可以使用margin/pading等其他方法来控制表格内容的居中

# position:absolute居中

最基础的方法是计算出父容器宽/高与要居中的子元素宽/高的差值，然后将差值除以2得到精确的值，用以设置left/right和top/bottom的偏移量，但是这种方法**灵活性差**。不再示例。

## 偏移量50%+负margin值

**设置50%的水平和垂直偏移，然后设置的margin-top和margin-left值是要居中元素自身宽/高的一半的负数** ：

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
该方法还是需要子元素自身的宽高，以下两种方法无需使用父容器确切的宽/高值，也无需使用要居中元素自身确切的宽高值：

## 偏移量0+margin:auto

父元素设置相对或绝对定位；要居中的子元素设置绝对定位，所有偏移量为0，外边距为auto：

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
## 偏移量50%+负translate值

使用css3的位移(transform:translate)方式，将设置了50%偏移的子元素”往回“移动自身宽高的一半：

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

# flex弹性布局居中

- 在父元素上设置相关属性即可使子元素居中：

```css
.parent-element{
  display:flex; /*使用flex盒子*/
  justify-content:center;/*水平轴上居中*/
  align-content:center;/*垂直轴上居中*/
}
```

注意：如果有多个子元素，默认情况下子元素会成一排分布在父元素容器中，因为flex默认子元素不折行显示（`flex-wrap: nowrap` ），使用`flex-wrap: wrap`可使子元素自动折行显示。（下同）

- 父元素设置为弹性容器`display:flex`，子元素设置`magrin:auto` ：

```css
.parent{
  display:flex;
}
.child{
  margin: auto;
}
```

# object-fit和object-postion居中

**object-fit 只能用于『可替换元素』(replaced element) **，用以

> 指定替换元素的内容应该如何适应到其使用的高度和宽度确定的框。

一般用做图片的样式。它有着类似background-image的用法：

```css
.center-element{
	object-fit:fill|cover|contain|none|scale-down;
/*其属性值，分别是填充（默认）、包含、覆盖（可能被裁剪）、无变化（保持原状）和等比例缩放*/
}
```
而object-positon属性默认值是`50% 50%`，也就是居中(也就是要求居中的情况不用写这个属性了……），对元素定位控制，类似background-postion。
