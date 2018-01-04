webpack常用配置简单示例

[TOC]

# loader

loader配置放在module下的`loaders:[]`内。

webpack的loader配置是从上往下，从右往左读取的，且后读取的配置会覆盖先前的配置。

## CSS

- style-loader  将样表插入html

- css-loader  处理css文件

- postcss-loader及常用插件

  - autoprefixer  浏览器前缀自动补全
  - precss  可以在使用像sass/less等预处理语言的特性（不必再使用sass/less的loader，文件扩展名依然用.css）
  - postcss-import 监听@import引用的css文件

  webpack为配置示例（loader中css相关部分，示例使用了抽离css的插件[extract-text-webpack-plugin](#plugin)）：

  ```javascript
  {
    test: /\.css$/,
    use: extractTextWebpackPlugin.extract({
      use: [
         {
            loader: 'css-loader',
            options: {
              // minimize: true
            }
          },
          {
            loader: 'postcss-loader',
            options: {
              config: { path: './postcss.config.js' //postcss的配置文件
               }
            }
          }]
    })
  }
  ```

  postcss的配置文件：

  ```javascript
  module.exports = {
    plugins: [
      'autoprefixer': {
        browsers: ['last 5 version','Android >= 5.0'],
        cascade: true,//是否美化属性值 默认：true 
        remove: true //是否去掉不必要的前缀 默认：true 
      },
      'precss',
      'postcss-import'
    ]
  }
  ```

## 处理各种文件

url-loader和file-loader ，url-loader包含fileloader，可以将图片base64化（见下方配置示例——图片超过limit的值（单位byte）将不会进行base64转换而使用file-loader）。

```javascript
{
  test: /\.(gif|png|jpg|svg|webp)$/,
  use: [
    {
      loader: 'url-loader',
      options: {
        limit: 8192, 
        name: 'img/[name].[ext]'
      }
    }
  ]
}
```

## ES6编译

babel-loader babel-core babel-preset-env（一般使用preset-env预设即可，如果使用class类，需要安装babel-plugin-transform-class-properties）

```javascript
{
  test: /\.jsx?$/, //jsx亦可
  // exclude: /node_modules/,
  include: path.resolve(__dirname, 'src'),
  use: {
    loader: 'babel-loader'
  }
}
```

注意：编译代码速度慢，建议在开发过程中关闭babel（除非该特性在测试的浏览器上不支持）

## expose-loader 暴露全局依赖模块

将模块暴露到全局（成为全局变量），用以调试或者支持依赖其他全局库的库，例如jquery。有两种使用方法以，使用jQuery为例：

- 无需配置

  首先使用npm/yarn安装jQuery，然在要使用jQuery的文件引入：

  ```javascript
  import $ from 'expose-loader?$!jquery'
  ```


- 在loaders中配置

  ```javascript
  {
    test: require.resolve('jquery'),
    use: [{
      loader: 'expose-loader',
      options: 'jQuery'  //对应window.jQuery
    },
    {
      loader: 'expose-loader',
      options: '$'  //对应window.$
    }
  }
  ```

# plugin

plugin的配置放在module下的`plugin[]`内。注意在配置文件前面引入要使用的模块。

## clean-webpack-plugin 自动清空目标文件

每次使用webpack打包时自动清除指定文件夹中的内容

```javascript
plugins:[
  new cleanWebpackPlugin(['dist'])
]
```
## webpack-dev-server

配合webpack的简单web服务器。webpack-dev-server的配置直接在module下，`plugins[]`外。

```javascript
devServer: {
    open: true,
    //contentBase: '/',
    // inline:true,
    port:8888,
    publicPath: '/' //服务器路径
  }
```

## extract-text-webpack-plugin  抽离CSS样式

1. 在loader中配置，见上文loader-css中的示例

2. 在`plugins[]`中配置：

   ```javascript
   new ExtractTextPlugin('css/[name].css'),
   ```

## html-webpack-plugin  生成html页面

多个html页面项目时尤为需要

```javascript
new htmlWebpackPlugin({
  template: './src/index.html',
  filename: 'index.html',
  favicon: './src/ico.png',
  // chunks: ['util'], // 本页面自动嵌入的模块
  //excludechunks:[], //本页面不使用的模块
  minify: {
    // collapseWhitespace: true,
    // removeComments: true
  }
})
```

## webpack.optimize.CommonsChunkPlugin 提取公共模块

该模块内置。

```javascript
new webpack.optimize.CommonsChunkPlugin({
  name: 'common', //将entry中的名为common模块提取出来
  filename: 'js/base.js' //要提取到的路径
}),
```

## uglifyjs-webpack-plugin 压缩JavaScript代码

简易开发环境不使用。

```javascript
new webpack.optimize.UglifyJsPlugin()
```