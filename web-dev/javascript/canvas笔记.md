[TOC]


canvas学习笔记。
`<canvas>`标签定义一个图形容器，通过脚本（如Javascript）绘制完成。

# 绘制准备
步骤：创建画布-获取画布-获取画笔。
创建画布即是建立canvas这个图形容器，获取画笔指的是利用canvas的`getContext(contextID)`方法获取context对象，context是一个封装了很多绘图功能的对象。
示例：
```
//1.  HTML创建画布
<canvas id="canvas"></canvas>
//2.  JavaScript获取画布和获取画笔
<script>var canvas=document.getElementById("canvas");
var context=canvas.getContext("2d");</script>
```
说明：
设置畫布外觀示例：
```html
<canvas id="canvas" width="300" height="300" style="border: 1px solid olive;display:block;margin:50px auto;>
你的浏览器不支持canvas（这段文字将在不支持canvas的浏览器上出现）</canvas> 
```

- !**canvas标签是一个内联元素。**
- !canvas画布默认是透明的。
- canvas的宽高也可以在JavaScript中使用canvas的`.width`方法和`.height`方法进行设定。
- `getContext("2d")`是返回一个用来绘制二维图形的环境类型，以下以2d为基础介绍。（3d即三维与二维使用了不同的绘制环境）

# 绘制方法
绘制图形均是使用画笔对象（上示例中的var context）的方法进行操作。

- 坐标系
  canvas以**左上角**为坐标轴的原点（0,0），沿着水平方向右（x）和垂直方向向下（y）伸展。

## 路径设置

canvas是**基于状态的绘制**，绘制前需要确定状态——利用坐标系确定画笔绘制的路径：
```javascript
context.moveTo(x,y)；//移动画笔到指定坐标点 起始绘制点
context.lineTo(x,y)；//移动画笔到新的坐标点 停止绘制点
```

## 画笔选择
设置画笔的样式：
```javascript
context.lineWidth=number;//一个数值 线条粗细
context.strokeStyle="color|gradient|pattern";//笔触风格 定义线条或者图形边框的颜色、渐变对象或填充图像对象
context.fillStyle="color|gradient|pattern";//填充风格 定义线条或者图形边框的颜色、渐变对象或填充图像对象
```
## 确定绘制
将根据设置的路径和画笔进行绘制：
```javascript
context.fill();//填充
context.stroke();//描边
```

---
# 路径分隔和状态处理

- 路径分隔
  不同的路径需要间隔开来，使用：
```javascript
context.beginPath();//开始新的绘制
context.closePath();//结束绘制
```
不同的绘制路径代码最好用以上方法**前后**包裹。
分隔不同绘制路径，可避免后方路径的状态设置覆盖前面路径的状态设置。如果**绘制闭合图形，不使用`closePath();`会导致闭合缺口**（笔画越粗越明显）。

- 状态处理
```javascript
context.save();//保存画布状态到堆栈
context.restore();//恢复存储的画布状态
```

# 线条
- 线条样式：
1. 端点风格（线条的帽子）
   `context.lineCap="butt|round|square";` 定义线条端点的样式。

   - butt：默认值，端点是垂直于线段边缘的平直边缘。
   - round：端点是在线段边缘处以线宽为直径的半圆。
   - square：端点是在选段边缘处以线宽为长、以一半线宽为宽的矩形。

2. 拐点风格
   `context.lineJoin="miter|bevel|round";`定义两条线条相交产生的拐角（连接）处的样式。

   - miter：默认值，在连接处边缘延长相接。miterLimit：角长和线宽所允许的最大比例(默认是10)。
   - bevel：连接处是一个对角线斜角。
   - round：连接处是一个圆。

3. 线条粗细
   `context.lineWidth=number;`值为一个数字，默认值为1.0。

4. 最大斜接长度
   `context.miterLimit=number;`
   设置或返回最大斜接长度。值是正数。规定最大斜接长度。如果斜接长度超过 miterLimit 的值，边角会以 lineJoin 的 "bevel" 类型来显示。

# 填充样式
## 填充颜色
`context.fillStyle="color";`填充单一颜色

## 颜色渐变
分为线性渐变（LinearGradient）和径向渐变（RadialGradient）。
```javascript
//1. 添加渐变线：
//用于线性渐变。设定起始坐标（x1,y1）和结束的坐标（x2,y2）。
var grd = context.createLinearGradient(x1,y1,x2,y2);
//用于径向渐变。x,y为圆心坐标，r为半径。
var grd = context.createRadialGradient(x0,y0,r0,x1,y1,r1);/
//2. 为渐变线添加关键色
grd.addColorStop(stop,color);//stop是0-1之间的浮点数，代表代表颜色断点到(xstart,ystart)的距离占整个渐变色长度是比例。
//3. 应用渐变：
context.fillStyle = grd;
context.strokeStyle = grd;
```
## 填充纹理
纹理其实就是图案的重复，填充图案通过`createPattern(img,repeat-style)`方法实现。img是一个Image对象实例，repeat-style是重复类型：

- 平面上重复：repeat;
- x轴上重复：repeat-x;
- y轴上重复：repeat-y;
- 不使用重复：no-repeat;
```javascript
//1.创建Image对象
var img=new Image();
//2.指定Image对象实例img的图片来源
img.src="path.jpg"
//3.应用图片进行纹理填充
var  pattern = context.createPattern(img,"repeat");
context.fillStyle = pattern;
```

# 曲线
## 圆弧

- 标准圆弧
  arc()方法，示例：
  `context.arc(x,y,radius,startAngle,endAngle,anticlockwise)`
  x,y是圆心坐标，radius是半径。
  startAngle、endAngle使用的是**弧度值**，不是角度值，弧度的规定是绝对的。

anticlockwise表示绘制的方法，包括顺时针（false）和逆时针（true）绘制，默认是顺时针（false）。

- 使用切点绘制圆弧
  arcTo()方法，示例：
  `context.arcTo(x1,y1,x2,y2,r);`
  x1,y1和x2,y2分别是两个切点的坐标，radius是圆弧半径。圆弧的起点与当前路径的位置到(x1, y1)点的直线相切，圆弧的终点与(x1, y1)点到(x2, y2)的直线相切。

## 贝塞尔曲线
贝塞尔曲线是一条由起始点、终止点和控制点所确定的曲线。n阶贝塞尔曲线就有n-1个控制点。

- 二次贝塞尔曲线（quadraticCurve）
  `context.quadraticCurveTo(cpx,cpy,x,y);`
  cpx,cpy是控制点（control point）坐标，x,y是中止点坐标。

- 三次贝塞尔曲线（bezierCurve）
  context.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y);

# 矩形
使用`rect(x,y,width,height);`规划矩形的路径（x,y为起始坐标点，widht和height是矩形的宽高），也可以使用更简便的方法：
```javascript
context.fillRect(x,y,width,height);
context.stroke(x,y,width,height);
```
再配合选择的画笔样式进行绘制。

- 擦除：`context.clearRect();` 在给定的矩形内清除指定的矩形区域。

# 图形变换

## 平移、旋转和缩放
- 平移：`context.translate(x,y);`
  x,y是要平移到的目标坐标。
- 旋转：`context.rotate(deg);`
  deg是弧度，旋转是以坐标系的原点（0，0）为圆心进行的顺时针旋转。
- 缩放：`context.scale(sx,sy);`
  sx和sy分别是水平方向和垂直方向上对象的缩放倍数。
  **！注意：缩放并非缩放的是图像，而是整个坐标系、整个画布。**
  缩放时，图像左上角坐标的位置也会对应缩放（左上角坐标为0,0除外）。
  缩放时，图像线条的粗细也会对应缩放。

## 矩阵

> a c e
> b d f
> 0 0 1

canvas的矩阵方法：`context.transform(a,b,c,d,e,f);`
ad（1和4）缩放，bc（2和3）倾斜，ef（5和6）位移。
|  参数  |   意义    |
| :--: | :-----: |
|  a   | 水平缩放(1) |
|  b   | 水平倾斜(0) |
|  c   | 垂直倾斜(0) |
|  d   | 垂直缩放(1) |
|  e   | 水平位移(0) |
|  f   | 垂直位移(0) |

可以：

使用context.transform (1,0,0,1,dx,dy)代替context.translate(dx,dy)
使用context.transform(sx,0,0,sy,0,0)代替context.scale(sx, sy)
使用context.transform(0,b,c,0,0,0)来实现倾斜效果。

！每次变换完毕后继续变换，新的变换是基于新坐标系进行的，为了避免使用混乱，在每次变换后最好
**将坐标系平移回原点，即调用translate(-x,-y)**，
或者
**在每次变换之前使用context.save()，在每次绘制后使用context.restore()**。

# 文本

- 显示：
```javascript
//1. 使用`font`设置字体
context.font = "50px serif";
//2. 使用`fillStyle`设置字体颜色
context.fillStyle = "#00AAAA";
 //3. 使用`fillText()`方法显示字体。
 context.fillText("《CANVAS》",50,300);
```
font的属性值和CSS中的一致。

- 渲染
      `context.fillText(String,x,y,[maxlen]);`与`context.strokeText(String,x,y,[maxlen]);`
      String是要显示的文字（字符串，使用引号），x,y是开始显示的坐标点，maxlen是最大长度（可以不写）
      *fillText和strokeText这两个方法也可以使用fillStyle与strokeStyle代替。*

- 对齐
      同CSS中对齐的属性值一致。
    - 水平：`context.textAlign="center|end|left|right|start";`
    - 垂直：`context.textBaseline="alphabetic|top|hanging|middle|ideographic|bottom";`

- 度量
      度量文本的长度，可用于如判断字符长度超出一定值的时候使用换行显示（配合fillText/strokeText使用）。
      `context.measureText(text).width;`

# 阴影与透明
- 阴影
  同CSS阴影类似。
```javascript
context.shadowColor = "red";//阴影颜色
context.shadowOffsetX = 5;//阴影x轴位移
context.shadowOffsetY = 5;//阴影y轴位移
context.shadowBlur= 2;//阴影模糊半径
```

- 透明
  `context.globalAlpha=number;` 
  globalAlpha用于设置**全局透明**,取值是0到1之间的浮点数。


# 图像的绘制、合成和裁剪

- 绘制
  `context.drawImage();`可以引入图像、画布、视频，并对其进行缩放或裁剪。

一共有三种表现形式：

1. 三参数：context.drawImage(img,x,y)
2. 五参数：context.drawImage(img,x,y,width,height)
3. 九参数：context.drawImage(img,sx,sy,swidth,sheight,x,y,width,height)

三参数的是标准形式，可用于加载图像、画布或视频；五参数的除了可以加载图像还可以对图像进行指定宽高的缩放；九参数的除了缩放，还可以裁剪。

|   参数    |           描述           |
| :-----: | :--------------------: |
|   img   |    规定要使用的图像、画布或视频。     |
|   sx    |    可选。开始剪切的 x 坐标位置。    |
|   sy    |    可选。开始剪切的 y 坐标位置。    |
| swidth  |      可选。被剪切图像的宽度。      |
| sheight |      可选。被剪切图像的高度。      |
|    x    |   在画布上放置图像的 x 坐标位置。    |
|    y    |   在画布上放置图像的 y 坐标位置。    |
|  width  | 可选。要使用的图像的宽度。（伸展或缩小图像） |
| height  | 可选。要使用的图像的高度。（伸展或缩小图像） |

- 图像合成
  两个图像重合的时候就涉及到了对这两个图像的合成处理。使用`context.globalCompositeOperation`设置或返回如何将一个源（新的）图像绘制到目标（已有）的图像上。
  （源图像指将被放置到画布上的绘图，目标图像 指已经在画布上的绘图。）

|        值         |                  描述                  |
| :--------------: | :----------------------------------: |
|   source-over    |           默认。在目标图像上显示源图像。            |
|   source-atop    |   在目标图像顶部显示源图像。源图像位于目标图像之外的部分是不可见。   |
|    source-in     | 在目标图像中显示源图像。只有目标图像内的源图像部分会显示，目标图像透明。 |
|    source-out    | 在目标图像之外显示源图像。只会显示目标图像之外源图像部分，目标图像透明。 |
| destination-over |            在源图像上方显示目标图像。             |
| destination-atop |   在源图像顶部显示目标图像。源图像之外的目标图像部分不会被显示。    |
|  destination-in  | 在源图像中显示目标图像。只有源图像内的目标图像部分会被显示，源图像透明。 |
| destination-out  | 在源图像外显示目标图像。只有源图像外的目标图像部分会被显示，源图像透明。 |
|     lighter      |             显示源图像和目标图像。              |
|       copy       |            显示源图像。忽略目标图像。             |
|       xor        |         使用异或操作对源图像与目标图像进行组合。         |

- 裁剪
  `context.clip();`先在画布内使用路径，使用裁剪使之只绘制该路径内所包含区域的图像，不绘制路径外的图像。
  **裁剪是对画布进行的，裁切后的画布不能恢复到原来的大小。**
  **要保证最后仍然能在canvas最初定义的大小下绘图需要注意save()和restore()。**

# 非零环绕
笔画复杂交错的循环路径图形存在着多个相交的子路径，需要对其填充（fill）时必须要判断，可以使用非零环绕原则来辅助判断哪块区域是里面，哪块区域是外面。

>非零环绕规则（Nonzero Winding Number Rule） ：使多边形的边变为矢量。 将环绕数初始化为零。

canvas填充使用非零环绕方法：
给图形确定一条路径，“一笔画”且“不走重复路线”。
>非零环绕规则计数器：
>将计数器初始化为0，每当这个线段与路径上的直线或曲线相交时，就改变计数器的值：
>如果是与路径顺时针相交时，那么计数器就加1， 如果是与路径逆时针相交时，那么计数器就减1。
>如果计数器始终不为0，那么此区域就在路径范围里面，在调用fill()方法时，浏览器就会对其进行填充。如果最终值是0，那么此区域就不在路径范围内，浏览器就不会对其进行填充。



