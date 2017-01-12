# CSS

- firefox49+支持**-webkit**前缀的css属性。
- `background-clip:text`：使用text属性值可以把**文本内容之外的背景**裁剪掉。
- 硬件加速小技巧：
  - canvas代替简单图形
  - transform：translate3d(0,0,0)（transform会使得该图层渲染时触发硬件加速）。

-   将表格默认的双线边框改为单线边框：`table`标签上设置`border-collapse:collapse;`（[w3cschool:border-collapse](http://www.w3school.com.cn/cssref/pr_tab_border-collapse.asp))。

- 网站的favorite icon的要支持ie10及以下时，需要在rel属性中写上`shortcut`，`<link rel="shortcut icon" href="/path/to/favicon.ico">`。（ie不支持png格式）

- **有的空元素**不支持伪元素（**浏览器支持有差异**），例如：`img`、`select`、`textarea`、`input`；

- 伪元素必须设置content属性，content的值是特殊字符时，需使用`\`加上该字符的unicode码。

- 文字三面环绕（上+下+左或右）图片需要将图片插到文字中间。（文字四面环绕图片恐怕得期待`float:center`在未来出现。或者用稍微复杂点的布局，或者使用[CSS shapes](http://www.w3cplus.com/blog/tags/365.html)）

- 可使用`appearance:none;`去select掉默认样式。

- 表单刷新后重置：标签上添加属性`autocomplete="off"`禁止自动补全。（可在多个标签的父级标签如form上添加该属性使多个标签重置）

- z-index仅用于**使用了定位的元素**：relative、fixed和absolute。

  无效的情况：

  -   父元素`position:relative`；

  -   元素进行了浮动（非`float:none` ）；

  -   元素没有position属性（非`position:static`）。

  解决方法：父元素`position:relative`改为`position:absolute`；浮动元素添加position属性（如relative，absolute等）；浮动元素去除浮动。

- figure标签具有`margin:1em 40px`的默认样式。ul标签具有`padding-start:40px`和`margin-befor:1em;margin-after:1em`的默认样式。
