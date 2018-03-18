webpack常用配置简单示例

[TOC]

配置文件基本结构：

```javascript
//各种import(require)
//import xxx from 'xxxxx'
const webapcConfig={
  entry:{},
  output:{},
  module:{
    rules:[]
  },
  plugins:{},
  //其他常用配置项目
  devServer:{}, //webpack-dev-server
  devtool: 'source-map', //source map
  //......
   mode: 'production'  //或development
}
  
export default webpackConfig
```

# entry

入口文件（js）配置

```javascript
  entry: {
    app: './src/index.js', // index.js打包后将变成app.js
    util: './src/common/util.js',
    service: ['./src/service/info.js','./src/service/host.js'] //这两个文件将合并为service.js
  },
```

# output

打包的目标位置，所有文件都将默认被打包到指定文件夹下。

```javascript
output: {
    path: path.resolve(__dirname, 'dist'), //打包到dist文件夹
    // publicPath: '/', // web服务的根目录 绝对路径 注意末尾必须有/
    filename: 'js/[name].js' //打包后的js文件的命名方式
    chunkFilename: 'js/[name]-[hash].js' //按需加载模块的打包的名称
  },
```

`[name]`表示使用原名称，`[hash]`表示添加生成的hash值（`[hash:3]`使用生成的hash值的前三位）。

# loader

loader配置放在module下的`rules:[]`内。

webpack的loader配置是从上往下，从右往左读取的，且后读取的配置会覆盖先前的配置。

## CSS

- style-loader  将样表插入html

- css-loader  处理css文件
### postcss-loader及常用插件

  （sass使用sass-loader和node-sass，less使用less-loader和less）

  - autoprefixer  浏览器前缀自动补全
  - precss  可以在使用像sass/less等预处理语言的特性（不必再使用sass/less的loader，文件扩展名依然用.css）
  - postcss-import 监听@import引用的css文件
  - postcss-sorting 给规则的内容以及@规则排序
  - postcss-cssnext 未来的 CSS 特性（包括 autoprefixer）

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
  //或使用require()
  //require("expose-loader?$!jquery");
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

## copy-webpack-plugin

将指定文件复制到目标（打包文件目录下）路径处。例如希望将src/fonts目录复制到src/dist/fonts，

```javascript
new copyWebpackPlugin([{from:'./src/fonts',to:'img'}])
```

## clean-webpack-plugin 自动清空目标文件

每次使用webpack打包时自动清除指定文件夹中的内容

```javascript
plugins:[
  new cleanWebpackPlugin(['dist'])
]
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

## optimize.splitChunks 提取公共模块

该模块内置。

```javascript
new webpack.optimize.splitChunks({
  name: 'common', //将entry中的名为common模块提取出来
  filename: 'js/base.js' //要提取到的路径
}),
```
## 压缩JavaScript代码

uglifyjs-webpack-plugin或webpack-parallel-uglify-plugin

建议开发环境不使用。

导入插件后，在配置中new 一个即可，更多参数参看其文档。


# 开发的其他常用配置

## webpack-dev-server

提示：webpack-dev-server生成在内存众的各项资源可在http://localhost:8080/webpack-dev-server下查看（这里假设端口设置为8080）。

配合webpack的简单web服务器。webpack-dev-server的配置直接在module下，`plugins[]`外。

```javascript
 devServer: {
    open: true,
    //contentBase: '/',
    // hot:true,
    // hotOnly: true,
    // publicPath: '/', //服务器路径
    port: 8080,
    progress: true,
    stats: { colors: true },
    // host:'',
    proxy:  {
      '/mock/*': {
        target: 'http://localhost:8888', // 代理服务器路径
        // pathRewrite: { '^/api': '/' }, // 重写路径
        secure: false,
        changeOrigin: true
      }
    }
  }
```

### proxy代理请求

例如用于开发中模拟数据请求。这里以上文proxy配置为例，简单介绍使用webpack-dever配合http-server（（可安装在项目的"devDependencies"里，也可以使用全局安装）进行模拟数据服务的搭建配置。

假如：项目源码目录在项目目录下的src文件中，模拟数据在src/mock中

- src/  源码目录
  - mock/  模拟数据目录
    - data.json  一个模拟数据文件
  - index.js  项目入口文件
  - ...各种其他文件
- webpack.config.js  项目webpack配置文件
- package.json  项目配置文件
- server.sh  一个方便启动模拟数据服务器和webpack-dev-server的脚本文件（见后文）  
- ...其他文件



现在终端中，所在路径为项目根目录（即src所在目录）：

1. 运行http-server，指定端口为8888，web服务根目录为src`http-server /src -p 8888`

2. 运行`webpack-dev-server`

3. 在项目中的请求就会转发到http-server下

   在上文配置中，`localhost:8888/mock/`下的请求，会转发到`localhost:8080/mock`下。示例：

   ```javascript
   //some codes...
   $.ajax({type:'get',url:'./mock/data.json',success:fn})
   //some codes...
   ```

   运行项目后，ajax请求地址是`localhost:8888/mock/data.json` ，根据配置，该请求被转发到http-server服务上的`loalhost:8888/mock/data.json`

为了方便使用，可建立一个名为server.sh的shell脚本，里面写入：

```shell
#!/bin/sh
nohup http-server /src -p 8888 &
npm start  #如用yarn 则是yarn start
```

给脚本赋予可执行权限`chmod +x ./server.sh`。 这样，以后只需在（终端中）项目根目录下执行`./server.sh`即可启动服务，进行开发调试啦。

另，http-server运行命令中添加`--cors`可使用cors（跨域资源共享）：`http-server --cors` 。

## devtool

webpack自带，无需额外安装

```javascript
devtool: "source-map"
```

