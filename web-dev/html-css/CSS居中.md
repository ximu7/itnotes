说明：

- 示例代码中，`.center-element`表示要被居中的元素，`parent-element` 表示要居中的元素的父元素。
- 须知某些情况不设置父元素宽高，无法看出子元素的居中效果，也就无所谓居中与否。示例代码只是为了减少长度，没有写出父元素的宽高（以及颜色边框等样式）。
- CSS兼容性情况未作说明，具体自行查阅。

[TOC]

---

# margin/padding值设置居中

最基础的方法是设置合适的margin/pading值，无论是精确到像素，或者是相对单位em、rem、vm、vh、百分比算出居中位置。

```css
/*一个没有设置宽高元素（肯定不差inline元素）内部内容的居中*/
.parent-element{
    padding:10px;
}
/*一个没有设置宽高元素（肯定不差inline元素）内部内容的居中*/
.center-element{
    margin:5rem;
}

```

## clac计算

margin值为父容器宽/高的50%减去自身宽/高的50%：

```css
.center-element{
  width: 20rem;height: 20rem;
  margin-left:calc(50% - 10rem);
  margin-top:calc(50% - 10rem);
}
```

注意：inline水平的元素margin/padding设置**仅在左右方向上有效**。

## margin:auto

注意：**对浮动元素、绝对定位和固定定位的元素无效**。

```css
.center-element {
  width:100px;height:100px;
  margin: 0 auto;
}
```

# text-align:center水平居中

在**块级父元素**设置`text-aling:center`，其行内水平（display为inline或inline-block）的子元素会进居中。

inline-block元素对外呈现inline特性（对内部呈现block特性），故而同inline水平元素一样受父元素text-align属性影响。

```css
.parent-element {
  text-align: center;
}
```

# line-height垂直居中

用于单行的行内元素的垂直居中，将要居中的元素的line-heigth值设置为和其块级父元素的height值一样。
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

vertical-align适用于
> 行内元素（inline）或表格单元格（table-cell）元素的垂直对齐方式。
> 也适用于[`::first-letter`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/::first-letter) 和 [`::first-line`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/::first-line) 伪元素。

对于inline元素，middle取值不算真的居中，而是**该元素中垂线与父元素的基线加上小写x一半的高度值**对齐；对于table-cell元素，middle取值则是单元格内容的垂直居中。

该属性多用在图文混排时，确定（父元素内）图片与旁边文字在垂直方向上的对齐方式；或者是设置了display:table-cell的元素内容的垂直居中（见下文“使用表格居中”）

```css
.center-element{
  vertical-aling-middle;
}
```

# 表格内容居中

根据语义化原则，使用表格布局非表格的内容已不再合适，而且表格的`<td>` `<th>`标签的align和valign属性已经是HTML的废除标签属性，不建议继续使用。

对于展示的（真正的）表格，其内容水平居中可以用`text-align:center` ，垂直居中可以用`vertical-align:middle`，当然，也可以使用margin/pading等其他方法来控制表格内容的居中。

对于非表格元素，可以使用`display:table-cell` 模拟其为一个表格，由于不建议使用废除的align和valign标签属性，故而也就`vertical-align:middle` 垂直居中具有实用性，将元素模拟成表格进行垂直居中意义也不大了。

# position定位元素居中

针对position不为static的元素。

​        最基础的方法是计算出父容器宽/高与要居中的子元素宽/高的差值，然后除以2精确得到宽高，但是这种方法灵活性太差。不再示例。

不使用确切的偏移量和外边距值，可以使代码适配性、复用性更好，维护也更容易。

改进方法是**设置50%的水平和垂直偏移，然后设置的margin-top和margin-left值是要居中元素自身宽/高的一半的负数**，这样可以摆脱对父容器确切宽/高值的依赖。

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
进一步改进，无需使用父容器确切的宽/高值，也无需使用要居中元素自身确切的宽高值：

## translate:transform方法

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
## 偏移值0+margin:auto

父元素设置定位后，要居中的子元素设置绝对定位，所有偏移量为0，外边距为auto：

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

# flex弹性布局居中

- 在父元素上设置相关属性即可使子元素居中：

```css
.parent-element{
  display:flex;
  justify-content:center;/*水平轴上居中*/
  align-items:center;/*垂直轴上居中*/
}
```

- 将父元素设置为弹性容器`display:flex`，子元素设置`magrin:auto`， 子元素将水平垂直居中：

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