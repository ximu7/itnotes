[TOC]

# 简介

## 常用模块

一般情况下要安装的npm模块有：

```
npm install --dev webpack webpack-cli style-loader css-loader url-loader file-loader html-webpack-plugin mini-css-extract-plugin
```

- webpack工具：webpack webpck-cli

  要使用webpack需要在`package.json`中的scripts下添加指令，例如：

  ```json
    "scripts": {
      "start": "webpack-serve --hot --open-app --port 8888",
      "build": "webpack --config webpack.config.js"
    }
  ```

- css：style-loader css-loaer url-loader mini-extract-plugin

  

- html：html-webpack-plugin

- 文件：url-loader file-loader





## webapck配置文件解读

基本结构：

```javascript
//各种import(require)
import xxx from 'xxxx';

webapcConfig = {
  //模式
  mode: 'production', //或development
    
  //入口文件--打包文件的来源
  entry: {}, 

  //出口文件--打包生成的文件
  output: {},
    
  //模块
  module: {
    rules: []  //各种规则
  }, 
  
   //插件
  plugins: {},
  
   //优化(webpack内置)
  optimization: {},
    
     
  //开发辅助(webpack内置)
  devtool: 'source-map' //调试时使用source map
    
  //其他常用配置项目
};
export default webpackConfig;
```

### entry

入口文件（js）配置。默认路径为`./src`，默认入口文件是`index.js`（如果不指定entry）。

```javascript
  entry: {
    app: './index.js', // index.js打包后将变成app.js
    util: './common/util.js',
    service: ['./service/info.js','./service/host.js'] //这两个文件将合并为service.js
  },
```

### output

打包的目标位置，所有文件都将默认被打包到指定文件夹下。默认路径为`./dist`。

```javascript
output: {
    // publicPath: '/', // web服务的根目录 绝对路径 注意末尾必须有/
    filename: 'js/[name].js' //打包后的js文件的命名方式
    chunkFilename: 'js/[name]-[hash].js' //按需加载模块的打包的名称
  },
```

`[name]`表示使用原名称，`[hash]`表示添加生成的hash值（`[hash:3]`使用生成的hash值的前三位）。

### module

#### rules

loader的配置内容放置于webpack配置文件中module对象下的rules对象内。

### plugins

各种插件，plugins的配置内容放置于plugins内。

- plugin需要需要在配置文件前面引用

  例如要使用html-webpack-plugin：

  先引用该插件，例如`const htmlWebpackPlugin=require('html-webpack-plugin')`

  然后再实例化使用`new htmlWebpackPlugin()`

### optimizition

压缩代码。

分割代码块。

```javascript
optimization: {
  //minimize:true //压缩 如果mode位production则自动启用
  //chunk 提取模块
  runtimeChunk: 'single',  //按runtime提取
  
  splitChunks: {  //分割代码块
    chunks: 'all',
 
    cacheGroups: {
      default: {
        enforce: true,
        priority: 1
      },
      vendors: {
        test: /[\\/]node_modules[\\/]/,
        priority: 2,
          name: 'vendors',
          enforce: true,
          chunks: 'all'
      }
    }
  }
}
```

### devtool

内置，开发调试的辅助，例如设置值为`sourcemap`方便迅速定位代码。参看官方文档devtool部分。

# 常用loader和plugins

一些插件需要在rules和plugins内同时配置（如提取css的mini-css-extract-plugin)

## HTML

### html-webpack-plugin

将指定模板文件（默认ejs）生成为html页面，并将符合条件的entry中的js模块（及其他文件）使用`<script src="xxx">`的方式插入到生成的html中。

该示例中，`/src/index.html`将生成为output指定目录下的`index.html`（output默认为项目根目录下的`dist`内，如果未更改默认目录，该html也就为`dist/index.html`）：

```javascript
new htmlWebpackPlugin({
  template: './src/index.html',  //模板来源
  filename: 'index.html',  //生成位置
  favicon: './src/ico.png',  //在在head标签内插入link指定favicon
  title:'主页',  //在head标签内插入title标签
  // chunks: ['util'], // 本页面自动嵌入的js模块
  //excludechunks:[], //本页面不使用的js模块
  minify: {  //压缩参数
    // collapseWhitespace: true, 
    // removeComments: true
  }
})
```

生成多个页面时多次使用`new htmlWebpackPlugin`即可。



注意：如果模板文件使用html，html文件中非ejs语法内容将不被解析。常见的就是配置了`html-loader`，在html文件中引用其他资源。
例如该示例中，该html文件中引用了另一个html文件，希望通过`html-loader`的解析而将另一个html文件拼接进来，如果该html文件又被当作html-webpack-plugin配置中的模板文件，则会无法被解析。

```javascript
<%= require('./common/header.html') %>
```

可以选以下方法解决：

- 模板文件均改用ejs

- 去掉webpack配置中html-loader相关内容，html模板文件内单独指定`html-loader`进行解析

  ```javascript
  <%= require('html-loader!./common/header.html') %>
  ```

### html-loader

可以加将html文件内容当作字符串处理，例如填充页面的公用html部分。具体配置使用参见官方文档。

## CSS

### style-loader

将css文件插入html的`<style></style>`标签中 一般配合css-loader使用。

在rules中配置，参照下文中的配置。

### css-loader

解析`@import` 和 `url()`

1. 在rules中配置，参照下文的配置。

2. 在js文件中使用import（或require）css文件。

   ```javascript
   import css1 from '/path/to/css1.css'
   //或
   const css1=require('/path/to/css1.css')
   //然而实际上一般css1这个变量后续也不会使用，因此一般如下进行引用
   import '/path/to/css1.css'
   ```

#### postcss-loader及常用插件

  （sass使用sass-loader和node-sass，less使用less-loader和less）

提示：postcss支持`.postcss`、`.pcss`、`.sss`和`.css`后缀。

postcss常用辅助插件（参看[github:postcss](https://github.com/postcss/postcss/blob/master/README-cn.md)）：

  - autoprefixer  添加不同浏览器前缀（使用[Can I use](https://caniuse.com/)数据）
  - precss  可以在使用像sass/less等预处理语言的特性
  - postcss-import 监听并编译@import引用的css文件
  - postcss-sorting 给规则的内容以及@规则排序
  - postcss-cssnext 允许使用未来的 CSS 特性（实验性特性）

`postcss.config.js`配置文件示例，放置于项目根目录下：

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

webpack中的配置参看下文。

#### mini-css-extract-plugin

将css内容提取为文件，使用`<link>`标签插入到html。

需要在rules中配置各种css-loder使用，并在plugins中示例化使用。

参看下面的配置：

  ```javascript
const miniCssExtractPlugin=require('min-css-extrac-plugin')
module.exports = {
  entry: {},
  output: {},
  modules: {
    rules: [
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              // minimize: true
            }
          },
          {
            loader: 'postcss-loader',
            options: {
              config: {
                path: './postcss.config.js' //postcss的配置文件
              }
            }
          }
        ]
      }
    ]
  },
  plugins:{
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      // both options are optional
        filename: "[name].css",
        chunkFilename: "[id].css"
      })
  }
};
  ```

### JavaScript

#### 编译ES6的babel-loader相关

安装`babel-loader`、 `babel-core`和 ` babel-preset-env`（如果使用class类需安装`babel-plugin-transform-class-properties`）

```javascript
{
  test: /\.js$/,
  exclude: /(node_modules|browser_components)/,
  use: {
    loader: 'babel-loader,
    options: {
      cacheDirectory:true,
      presets: ['@babel/preset-env'],
      plugins: ['@babel/transform-runtime']
    }
  },
  cacheDirectory: true
}
```

配置内容已经存在项目目录下的babel配置文件中（如.babelrc），则不必要再重复添加preset或plugins等配置。。

注意：编译代码速度慢，建议在开发过程中关闭babel（除非该特性在测试的浏览器上不支持）

#### expose-loader暴露全局依赖模块

将模块暴露到全局（成为全局变量），用以调试或者支持依赖其他全局库的库，例如jquery。有两种使用方法以，使用jQuery为例：

- 直接引用jquery并暴露为全局变量`$`

  ```javascript
  import $ from 'expose-loader?jquery'
  //或使用require()
  //require("expose-loader?$!jquery");
  ```

- 在loaders中配置(仅适用于react模块)

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

### file-loader和url-loader处理各种文件

file-loader对引用的各种文件资源进行打包处理（例如字体、图片）。

url-loader包含file-loader，url-loader主要用于处理小图片，其可以将小于配置中指定大小的图片base64化，以减少HTTP请求。（如下面的示例，小于8192B的图片将被处理为base64字符串，大于8192B则使用file-loader处理）

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

### copy-webpack-plugin复制文件

将指定文件复制到目标（打包文件目录下）路径处。例如希望将src/fonts目录复制到src/dist/fonts，

```javascript
new copyWebpackPlugin([{from:'./src/fonts',to:'img'}])
```

### clean-webpack-plugin自动清空文件

每次使用webpack打包时自动清除指定文件夹中的内容

```javascript
plugins:[
  new cleanWebpackPlugin(['dist'])
]
```

# 其他

## 使用font-awesome

安装`font-awesome``

1. ``modules`中`rules`下添加规则：

   ```javascript
         //fontawesome-woff
         {
           test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,   //直接写成woff*也可以
           loader: 'url-loader?limit=10000&mimetype=application/font-woff'
         },
         //fontawesome-fft&eot
         {
           test: /\.(ttf|eot)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
           loader: 'file-loader'
         },
   ```

   注意，该规则应该放在css相关rules后面。

2. 在js文件中引用css即可，示例：

   ```javascript
   import '../node_modules/font-awesome/css/font-awesome.min.css'
   ```

## 开发服务器webpack-serve

当更改代码后，会进行热更新，同步刷新浏览器。

参看[webpack-serve](https://github.com/webpack-contrib/webpack-serve)

### ~~proxy代理请求~~

~~例如用于开发中模拟数据请求。这里以上文proxy配置为例，简单介绍使用webpack-dever配合http-server（（可安装在项目的"devDependencies"里，也可以使用全局安装）进行模拟数据服务的搭建配置。~~

~~假如：项目源码目录在项目目录下的src文件中，模拟数据在src/mock中~~

- ~~src/  源码目录~~
  - ~~mock/  模拟数据目录~~
    - ~~data.json  一个模拟数据文件~~
  - ~~index.js  项目入口文件~~
  - ~~...各种其他文件~~
- ~~webpack.config.js  项目webpack配置文件~~
- ~~package.json  项目配置文件~~
- server.sh  一个方便启动模拟数据服务器和webpack-dev-server的脚本文件（见后文）  
- ~~...其他文件~~



~~现在终端中，所在路径为项目根目录（即src所在目录）：~~

1. ~~运行http-server，指定端口为8888，web服务根目录为src`http-server /src -p 8888`~~

2. ~~运行`webpack-dev-server`~~

3. ~~在项目中的请求就会转发到http-server下~~

   ~~在上文配置中，`localhost:8888/mock/`下的请求，会转发到`localhost:8080/mock`下。示例：~~

   ```javascript
   //some codes...
   $.ajax({type:'get',url:'./mock/data.json',success:fn})
   //some codes...
   ```

   ~~运行项目后，ajax请求地址是`localhost:8888/mock/data.json` ，根据配置，该请求被转发到http-server服务上的`loalhost:8888/mock/data.json`~~

~~为了方便使用，可建立一个名为server.sh的shell脚本，里面写入：~~

```shell
#!/bin/sh
nohup http-server /src -p 8888 &
npm start  #如用yarn 则是yarn start
```

~~给脚本赋予可执行权限`chmod +x ./server.sh`。 这样，以后只需在（终端中）项目根目录下执行`./server.sh`即可启动服务，进行开发调试啦。~~

~~另，http-server运行命令中添加`--cors`可使用cors（跨域资源共享）：`http-server --cors` 。~~
