我的vscode配置使用记录（web开发向）。

---

[TOC]

---

# 快捷键shortcuts

`ctrl+k ctrl+s`进入快捷键设置。
快捷键手册下载:[linux](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf) | [windows](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf) | [macos](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-macos.pdf)

# 自定义代码片段snippets

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
  - [htmlhint](https://github.com/yaniswang/HTMLHint)     校验html代码


- CSS
  - can i use        检查HMTL5、CSS3、SVG和JS API的兼容性  
  - stylelint         CSS/SCSS/Less的语法检查 
  - css peek         在HTML的id/class上查看CSS样式
- JavaScript
  - javascript(es6) code snippets          js(es6)代码片段  
  - [eslint](https://github.com/eslint/eslint)  语法检查  
  - vue 2 snippets         vue.js 2代码片段
- php
  - php-intellisense  智能提示
- 调试
  - preview          markdown、html、jade……的预**览**
  - debugger for chrome      在chrome调试  
  - debugger for firefox        在firefox调试  
  - code runer       多种语言的代码运行器  
  - php-debug     配合php的xdebug插件和php服务器进行调试
  - php-server    php服务器
- 其他辅助
  - npm intelisense          npm 自动补全  
  - path intellisense          路径自动补全  
  - bracket pair colorizer  成对括号显示不同的色彩  
  - vs color picker        选色盘和取色器（限windows)
  - projects manager         项目管理  
  - settings sync         同步vscode的设置、主题、代码片段……  

---

- eslint语法检查

  安装eslint：`npm install -g eslint`

  配置.eslintrc.json规则文件

- htmlhint语法检查

  安装htmlhint:`npm install   -g htmlhint`

  配置.htmlhintrc规则文件

---

# 调试

- html纯静态页面预览可以使用preview插件（默认快捷键`ctrl+k-v`）预览。（preview支持markdown、jade、css等等）

- `code runner`插件支持多种语言的调试。还支持代码片段（选中代码后运行，默认快捷键`ctrl+alt+n` ）

- php-debug+xdebug+php-server调试php

  安装xdebug，启用`/etc/php/php.conf/xdebug.ini`文件中的所有配置项。f5启动调试。

  然后调出命令输入框（ctrl-shift+p或f1）,查找Serve Project with PHP命令并执行，按下右上角php-server按钮（或者执行server project with php）启动服务器即可在浏览器中进行调试。

-   使用自带调试（默认快捷键`f5`）功能，需要根据不同的调试环境需要安装相应的套件，如：

  - nodejs       --nodejs

  - `debug for chrome`      -- chrome/chromium

  - `debug for firefox`        --firefox

