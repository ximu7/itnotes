CSS3新特性整理

------

[]括起来的内容表示可选项，|分隔的项目表示所有可使用的项。默认值可省略。

[TOC]

# 尺寸size

## 用户调整尺寸resize

`resize: none|both|horizontal|vertical;`

## 响应式尺寸response size

`max/min-width/height`

注意：应用于图片时，尺寸大小不可能变化到大于其原始大小。

# 盒子box

## 盒阴影box-shadow
`box-shadow: h-shadow v-shadow [blur] [spread] [color] [inset|outset]`

## 盒子类型box-sizing
`box-sizing: content-box|border-box|inherit`

## 轮廓距离outline-offset
`outline-offset: length|inherit`
轮廓框架在 border 边缘外的偏移。Outlines在两个方面不同于边框：Outlines 不占用空间； Outlines 可能非矩形。


## 边框圆角border-radius
`border-radius:px|em|%|rem`

## 边框图像border-image
`border-image: border-image-source border-image-slice border-image-repeat`

  **图片来源、图片偏移值和图片铺排方式是必须的三个值。**  border-image用于设置:
- `border-image-source: url()|none`
- `border-image-slice: number|%|fill`
- `border-image-repeat: stetch（默认）|repeat|round|space|initial|inherit`
- `border-image-width:number|%|auto`
- `border-image-outset: length|number`注意：number是倍数值。

## 弹性盒子flexbox

弹性盒子由弹性容器(Flex container)和弹性子元素(Flex item)组成。

### 弹性容器flex-container

`display:flex`或`display: inline-flex`
弹性容器内包含了一个或多个弹性子元素。弹性子元素通常在弹性盒子内一行显示。
**默认**情况每个容器只有一行。

### 弹性子元素flex-items

- 子元素排列方式

  `flex-flow: flex-direction flex-wrap|initial|inherit;`

  - 子元素排列方向

    `flex-direction: row|row-reverse|column|column-reverse|initial|inherit;`

  - 子元素换行方式

    `flex-wrap: nowrap|wrap|wrap-reverse|initial|inherit;`

- 子元素在主轴（横轴）的对齐方式

  `justify-content: flex-start|flex-end|center|space-between|space-around|initial|inherit;`

- 子元素在侧轴（纵轴）的对齐方式

  `align-items: stretch|center|flex-start|flex-end|baseline|initial|inherit;`

- 多行子元素侧轴对齐

  `align-content: stretch|center|flex-start|flex-end|space-between|space-around|initial|inherit;`

  在弹性容器内的各项没有占用交叉轴上所有可用的空间时对齐容器内的各项（垂直），（各项将紧挨一起而不会像align-items一样各项中有空白空间），align-content属性只适用于**多行**的flex容器（否则没有渲染效果）。

- 子元素出现的順序

  `order: number|initial|inherit;`

- 子元素单独的对齐方式

  `align-self: auto|stretch|center|flex-start|flex-end|baseline|initial|inherit;`

  该属性需写在子元素的样式上。

- 子元素空间分配

  `flex: flex-grow flex-shrink flex-basis|auto|initial|inherit;`

  该属性需写在子元素的样式上。

  - 弹性盒子伸缩基准值`flex-basis: number|auto|initial|inherit;`
  - 弹性盒子的扩展比率`flex-grow: number|initial|inherit;`
  - 弹性盒子的收缩比率`flex-shrink: number|initial|inherit;`
# 背景background

## 背景图像background-image

- 图像来源

  `background-image: url()`

- 背景尺寸

  `background-size: length|percentage|cover|contain;`

- 背景区域

  `background-origin: padding-box|border-box|content-box;`

- 背景绘制`background-clip: border-box|padding-box|content-box;`

## 渐变gradient

渐变的颜色值后可跟上（空格隔开）百分比，用以确定颜色的百分比分布值。

- 线性渐变linear-gradient

  `background: linear-gradient(direction color-stop1 color-stop2, ...);`

  direction 指定渐变的方向（或角度）。


- 重复的线性渐变：如`background: repeating-linear-gradient(direction color-stop1  color-stop2 ...);`

- 径向渐变radial-gradient

  `background: radial-gradient(shape size position start-color  ...  last-color);`

  shape确定圆的类型:    ellipse （默认），椭圆形的径向渐变； circle 圆形的径向渐变。size定义渐变的大小：farthest-corner (默认) |closest-side |closest-corner|farthest-side；position 定义渐变的位置：center（默认）|top|bottom


- 重复径向渐变如：`background: repeatin-gradial-gradient(shape size position  start-color  ... last-color);`

# 文本效果text effect

- 文本阴影

  `text-shadow: h-shadow v-shadow [blur] [color];`

- 文本溢出

  `text-overflow: clip|ellipsis|string;`

- 文本轮廓

  `text-outline: thickness [blur] [color];`

- 文本换行

  `text-wrap: normal|none|unrestricted|suppress;`

- 长文本换行断词

  `word-wrap: normal|break-word;`

- 非中日韩文本断行

  `word-break: normal|break-all|keep-all;`

……

# 网络字体@font-face

```css
@font-face{
  font-family:font-name;/*规定字体的名称*/
  src:url(xx);/*字体来源地址*/
  font-stretch：/*如何拉伸字体 可选*/
  font-style: /*文字风格 可选*/
  font-weight: /*字体粗细 可选*/
  unicode-range：/*定义字体支持的 UNICODE 字符范围（默认是 "U+0-10FFFF"） 可选*/
}
```

# 变换transform

## 变换基准点transform-origin

`transform-origin: x-axis y-axis z-axis;`

用于更改转换元素的位置。x-axis|y-axis|z-axis设置试图被置于x|y|z轴的何处。

- x-axis:left|center|right|length|%

- y-axis:top|bottom|center|length|%

- z-axis:lenght

## 变换元素呈现方式transform-style

`transform-style: flat|preserve-3d;`

flat所有子元素在2D平面呈现。preserve-3d所有子元素在3D空间中呈现。

## 2D变换2d transform

`transform:none|transform-function``

- 位移`translate(x,y)`
- 旋转`rotate(angle)`
- 缩放`scale(x-nmber,[y-number])`
- 倾斜`skew(x-angle,[y-angle])`
- 矩阵`martrix(a,b,c,d,e,f)`

> a db ec f

坐标(x,y)在的算法：

> x=ax+cy+ey=bx+dy+f

tanslate(x,y)--matrix(1,0,0,1,x,y)

scale(x,y)---matrix(x,0,0,y,0,0)

skew(x,y)---matrix(1,tan(θy),tan(θx),1,0,0)

rotate(θ)---matrix(cosθ,sinθ,-sinθ,cosθ,0,0)

## 3D变换3d transform

`transform:none|transform-function`

transform-function变换方法包括：

- 位移`translate3d(x,y,z)`

- 旋转`rotate3d(x,y,z,angle)`

- 缩放`scale3d(x-nmber,y-number,z-number)`

- 矩阵`martrix(a,b,c,d,e,f,h,i,j,k,l,m,n,o,p,q)`

- 透视`perspective(n|none)`n是像素值，书写不带px单位。

- 3D元素透视基准`perspective-origin: x-axis y-axis;`

  3D 元素所基于的 X 轴和 Y 轴。x-axis定义该视图在 x 轴上的位置（默认值：50%）： left|center|right|length|%y-axis定义该视图在 y 轴上的位置（默认值：50%）： top|center|bottom|length|%


- 3D元素背面可见性`backface-visibility: visible|hidden;`



**2D和3D变换都可以单独设置一个轴的变换方式，如`translateX(x)`。**

# 过渡transition

过渡是元素从一种样式逐渐改变为另一种的效果。要实现效果，必须对该元素规定两项内容：

- 指定要添加效果的CSS属性

- 指定效果的持续时间。

同时还需要再设置该元素过渡效果的触发方式（如hover），并在该触发方式的样式内写入过渡效果完毕后的状态。例：
```html
<div></div><!--要应用过渡效果的元素-->
<style> 
div{
	width:100px;height:100px;background:red;
	transition: width 2s;/*该元素需要实现的过渡效果：针对宽度变化，过渡时间持续2秒*/
}
div:hover{/*当悬停在该元素上触发效果*/
	width:300px;/*过渡效果完毕后的状态*/
}
</style>
```

简写方法：`transiton：property duration [timing-function] [delay];`

- 过渡应用的属性`transition-property: none|all|property;`
  property定义应用过渡效果的 CSS 属性名称列表，all则会应用到所有CSS属性上。
- 过渡耗时`transition-duration: time;`
- 过渡速度变化曲线`transition-timing-function: linear|ease|ease-in|ease-out|ease-in-out|cubic-bezier(n,n,n,n);`
- 过渡延迟时间`transition-delay: time;`

# 动画@keyframes

一个动画效果包括两部分CSS样式：动画规则部分规定动画的具体实现方式，动画属性部分用以绑定动画规则以及设置该绑定的动画。

## 动画规则animation rule

`@keyframes animationname {keyframes-selector {css-styles;}}`

- animationname 	必需的 定义animation的名称。
- keyframes-selector 必需的 动画持续时间的百分比：0-100%|from (和0%相同)|to (和100%相同)
- css-styles 必需的 一个或多个合法的CSS样式属性

## 动画属性 animation properties

`animation: name duration [timing-function] [delay] [iteration-count] [direction] [fill-mode] [play-state];`

- 动画名称`animation-name: *keyframename*|none;`

animation-name 属性为 @keyframes 动画指定名称。

- 动画耗时`animation-duration:time;`

- 动画速度变化曲线：`animation-timing-function: linear|ease|ease-in|ease-out|ease-in-out|cubic-bezier(n,n,n,n);`

- 动画延迟时间`animation-delay: *time*;`

- 动画播放次数`animation-iteration-count: n|infinite;`

  n是播放的次数（阿拉伯数字），infinite是无限次播放。

- 动画反向播放`animation-direction: normal|reverse|alternate|alternate-reverse|initial|inherit;`

  - reverse反向播放
  - alternate 动画在奇数次（1、3、5...）正向播放，在偶数次（2、4、6...）反向播放。
  - alternate-reverse 动画在奇数次（1、3、5...）反向播放，在偶数次（2、4、6...）正向播放。

- 动画运行状态`animation-play-state: paused|running;`

# 媒体查询@media

css语法：`@media not|only|all mediatype and (expression){css-style}`

也可以link样式文件：`<link rel="stylesheet" media="mediatype and|not|only (expressions)" href="cssname.css">`
mediatype媒体类型：all|screen|print|speech
expression属性：width/height|min/max-width/height|device-width/height|max/min-reslution等等。
媒体查询可用于检测如：
- viewport(视窗) 的宽度与高度
- 设备的宽度与高度
- 朝向 (智能手机横屏，竖屏) 。
- 分辨率

# 多列columns

- 列宽和列数`columns: column-width column-count;`

  - 列宽`column-width: auto|length;`
  - 列数`column-count: n|auto;`

- 列间距`column-gap: length|normal;`
  normal 指定一个列之间的普通差距。 W3C建议1EM值。

- 列间样式`column-rule: column-rule-width column-rule-style column-rule-color;`
  - `column-rule-width` 设置列中之间的宽度规则
  - `column-rule-style` 设置列中之间的样式规则
  - `column-rule-color` 设置列中之间的颜色规则

- 跨列数`column-span: 1|all;`

- 列填充`column-fill: balance|auto;`

  balance 	列长短平衡。浏览器应尽量减少改变列的长度

# 图片滤镜image filter

`filter: none | blur() | brightness() | contrast() | drop-shadow() | grayscale() | hue-rotate() | invert() | opacity() | saturate() | sepia() | url();`

- blur(px) 	高斯模糊 这个参数可设置css长度值(但不接受百分比值） 默认0
- brightness(%) 亮度 默认1
- contrast(%) 对比度 默认1
- drop-shadow(h-shadow v-shadow blur spread color)  阴影效果（接受<shadow>(在CSS3背景中定义)类型的值，除了"inset"关键字）
  该函数与已有的box-shadow box-shadow属性很相似；*不同之处在于，通过滤镜，一些浏览器为了更好的性能会提供硬件加速。*
- grayscale(%) 灰度 默认0
- hue-rotate(deg) 色相旋转 默认0deg
- invert(%) 反转输入图像 默认是0
- opacity(%) 透明度 默认1 
  该函数与已有的opacity属性很相似，*不同之处在于通过filter，一些浏览器为了提升性能会提供硬件加速。*
- saturate(%)  饱和度 默认。
  - sepia(%) 转换为深褐色 默认0
- url() URL函数接受一个XML文件，该文件设置了 一个SVG滤镜，且可以包含一个锚点来指定一个具体的滤镜元素。例如：`filter: url(svg-url#element-id)`