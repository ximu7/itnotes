## loader

- CSS相关
  - style-loader  将样表插入html

  - css-loader  处理css文件

  - less-loader和sass-loader（sass-loader还需要安装node-sass）  处理less和sass/scss等

    如果要将less/sass/scss和scss混合使用，且要在less/sass/scss中`@import`css的情况：可将css作为被引用的模块使用，使用scss作为主文件来引入各个样式模块，编写规则时只需要针对less/sass/scss即可。示例：

    项目有样式模块：a.css和b.scss和主样式文件main.scss，在主样式文件中引入样式模块：

    ```scss
    @import a.css
    @import b.scss
    ```

    webpack配置文件解析scss即可（以下仅为配置文件部分内容，示例使用了抽离css的插件[extract-text-webpack-plugin](#plugin)）：

    ```javascript
    module:{
            rules:[
                {
                    test:/\.scss$/,
                    use:ExtractTextPlugin.extract({
                        fallback:'style-loader',
                        use:['css-loader','sass-loader']    
                    })
                }
            ]
        }
    ```

- url-loader和file-loader  处理各种文件

  url-loader包含fileloader，可以将图片base64化。

- es6相关

  babel-loader babel-core babel-preset-env  简易开发过程中关闭（编译代码速度慢）

## plugin

- clean-webpack-plugin  每次使用webpack打包时自动清除指定文件夹中的内容

  ```javascript
  plugins:[
    new cleanWebpackPlugin(['dist'])
  ]
  ```

- webpack-dev-server  配合webpack的简单web服务器

- extract-text-webpack-plugin  抽离CSS样式（webpack默认是将css直接注入到html中

  ）

  简单rule示例：

  ```javascript
  test: /\.css$/,
          use: extractTextWebpackPlugin.extract({
            fallback: 'style-loader', // 抽离失败时使用插入到hmtl的方法
            use: 'css-loader' // 使用css-loader
          })
  ```

- html-webpack-plugin  生成html页面（多个html页面项目时尤为需要）

- 内置 webpack.optimize.CommonsChunkPlugin 提取公共模块

- uglifyjs-webpack-plugin 压缩代码

- 调用模块的别名ProvidePlugin，例如想在js中用`$`，如果通过webpack加载，需要将`$`与jQuery对应起来