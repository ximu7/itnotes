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

使用删除线的插件表示该插件提供的功能已在新版本中内置支持，无需安装。

`ctrl+shift+x`进入插件商店。

- HTML
  - ~~auto close tag~~  	  自动闭合HTML/XML标签
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
  - php-debug   调试php
  - php-server    php服务器
- 其他辅助
  - preview          markdown、html、jade等的预**览**
  - code runer       多种语言的代码运行器  
  - npm intelisense          npm 自动补全  
  - path intellisense          路径自动补全  
  - bracket pair colorizer  成对括号显示不同的色彩  
  - projects manager         项目管理  
  - settings sync         同步vscode的设置、主题、代码片段……  

---

- eslint语法检查

  安装eslint：`npm install -g eslint`

  配置.eslintrc.json规则文件

- htmlhint语法检查

  安装htmlhint:`npm install   -g htmlhint`

  配置.htmlhintrc规则文件
