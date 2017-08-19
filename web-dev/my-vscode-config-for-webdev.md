我的vscode配置使用记录（web开发向）。

---

[TOC]

---

# 快捷键shortcuts

`ctrl+k ctrl+s`进入快捷键设置。
快捷键手册下载:[linux](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf) | [windows](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf) | [macos](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-macos.pdf)

# 代码片段snippets

自定代码片段示例：
```json
"console.log":{
  	"prefix":"cl",	//简写形式
  	"body":"console.log($0)",		//要展开的代码
  	"description":"console.log"    //描述信息，可不写
}
"function":{
	"prefix":"fn",
  	"body":[
      	"function $1 ($2){",
      	"$0",
      	"}"
  	]
}
```
其中`$n`（n代表一个自然数）的用法：

- 光标将按照`$1`，`$2`……的顺序访问。

- 使用片段时,每填写完一个位置后按下tab按顺序切换到下一个

- `$0`表示光标最终抵达的位置。

- 带默认值占位`${n:word}`。示例`${1:let}`表示在不对其修改（直接按tab跳过）的情况下，`$1`将以let显示。

- 默认情况下，自定义片段在代码提示列表中位置靠后，可在个人设置中，修改以下项：

  ```json
  editor.snippetsSuggestions		//可修改键值为top
  editor.tabCompletion		//可修改键值为true
  ```
# 设置

`ctrl+,`可进入设置。
要修改默认设置，可复制设置界面左侧窗口内相应配置到右侧个人设置或工作区设置（仅当前工作区有效）中，修改相应的值，可点按行号前面的铅笔图标选择值。

# 插件

`ctrl+shift+x`进入插件商店。

- HTML
  - auto close tag  	  自动闭合HTML/XML标签  
  - auto rename tag    自动修改HTML/XML的成对标签名  


- CSS
  - can i use        检查HMTL5、CSS3、SVG和JS API的兼容性  
  - stylelint         CSS/SCSS/Less的语法检查 
  - css peek         在HTML的id/class上查看CSS样式
- JavaScript
  - babel es6/es7          添加js babel es6/es7 语法高亮  
  - javascript(es6) code snippets          js(es6)代码片段  
  - eslint  eslint        语法检查  
  - vue 2 snippets         vue.js 2代码片段
- 调试
  - preview          markdown、html、jade……的预览
  - debugger for chrome      在chrome调试  
  - debugger for firefox        在firefox调试  
  - code runer       多种语言的代码运行器  
- 智能辅助
  - npm intelisense          npm 自动补全  
  - path intellisense          路径自动补全  
- bracket pair colorizer  成对括号显示不同的色彩  
- vs color picker        选色盘和取色器（限windows)
- dash      dash和zeal的文档查询  
- projects manager         项目管理  
- settings sync         同步vscode的设置、主题、代码片段……  
- translationtoolbox          划词翻译  
- vim         vim操作模式  

一些vscode内置的功能[**或许**]不需要专门装插件：

- 缩进辅助线（guides)
- html内支持css提示 (html css support)
- 文档注释(document this)
- 代码格式化
- 内置热门主题：
  - monokai（dimmed和dark）
  - solarized(dark和black)
  - tomorrow light blue

eslint语法检查

安装eslint：`npm install -g eslint`

types智能提示

安装types：`npm install -g types`

根据需要安装@types插件`@types/[moudelName]`到node_moudels，如：

```
npm i @types/jquery			//用于jquery
npm i @types/angular		//用于angular
npm i @types/node			//用于node
```



# 调试

- html静态页面预览可以使用preview插件（默认快捷键`ctrl+k-v`）预览。（preview还支持markdown、jade、css等等）

- `code runner`插件可以支持多种语言的调试，还支持代码片段（选中代码后运行，默认快捷键`ctrl+alt+n` ）

-   使用自带调试（默认快捷键`f5`）功能，需要根据不同的调试环境需要安装相应的套件，如：

  - nodejs       --nodejs

  - `debug for chrome`      -- chrome/chromium

  - `debug for firefox`        --firefox

  - dart  command line      --dart SDK

    ……

  按下f5后会弹出调试环境选项，选择一个调试环境后，会自动新建名为launch.json的文件并打开编辑窗口（launch.json位于当前工作区/项目的根目录下的.vscode文件夹中）,根据具体情况编辑该文件。右下角会有一个添加配置的按钮，可供选择并生成各种配置模板。

## lanch模式

配置文件中的 "request"默认取值是 "launch"，且称之为launch模式。

这是一个我用nginx+php-fpm+php测试某php为后端的html页面的launch.json的简洁示例：

  ```json
  {
      "version": "0.2.0",
      "configurations": [
          {
              "name": "Launch localhost",
              "type": "firefox",
              "request": "launch",
              "url": "http://localhost/app/index.html",
              "webRoot": "${workspaceRoot}/app"
          }
      ]
  }
  ```

  我要测试的页面在nginx上的位置/app/index.html，`${workspaceRoot}`变量指当前工作区的根目录。

  此外还有`${file}`变量值该文件的绝对路径，如需监听特定端口需要设定"port"的值。

  其余调试环境的配置大同小异，根据实际情况更改相应项。

## attach模式

launch模式的缺陷：launch模式调试时，vscode访客的身份打开一个新的 浏览器进程，浏览器原先安装的插件、缓存数据、历史记录等等都不会生效（类似打开了一个禁用插件的隐私浏览模式/无痕浏览模式）。

attach模式可以弥补这个缺陷。

attach模式下的launch.json（名字还是launch.json）示例：

```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "firefox",
            "request": "attach",
            "name": "firefox attatch",
            "port": 6666,
            "url": "http://localhost:6666/app/index.html",
            "webRoot": "${workspaceRoot}/app"
        }
    ]
}
```

