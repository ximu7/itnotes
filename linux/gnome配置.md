[TOC]

# shell扩展

需先安装有gome-tweak-tool。

可在https://extensions.gnome.org/中下载安装.注册该网站，浏览器会提示安装相应扩展。

*archlinux可以在aur中搜索[gnome-shell-extension](https://aur.archlinux.org/packages/?O=0&K=gnome-shell-extension)的关键字查找（以”插件名+shell“进行搜索，如`yaourt weather shell`）。*

一些扩展（部分扩展在gnome-shell-extensions这个包里面）：

- usertheme    启用后可自定义shell主题
- dash-to-dock    dock设置
- unite    将左下角通知栏融入顶部栏（仿unity风格）
- topicons plus    将左下角通知栏融入顶部栏
- taskbar    任务栏
- hide-top-bar  定义顶部栏隐藏策略
- pixel-saver    窗口最大化时将标题栏融合进顶部pannel
- coverflow-alt-tab    alt+tab进行切换时可显示大幅预览
- workspace-indicator    显示工作区序号
- top-panel-workspace-scroll    顶部栏上滚动鼠标滚轮可切换工作区
- drop-down-terminal    下拉式终端
- removable-drive-menu    显示可移除设备（如U盘）拔插提示
- places-status-indicator    显示文件管理器导航菜单
- netspeed或simple-netspeed    显示网速
- system-monitor    系统监控
- web-search-dialog    快捷搜索（可添加搜索引擎）
- weather    天气显示
- clipboard-indicator      剪切板工具（最多可存储50条记录）
- easyscreencast     截屏录屏
- screenshot    截屏
- audio-output-switcher    切换音频输出
- hibernate-status    增加休眠按钮
- cpupower    或 cpufreq 处理器调频控制
- clac    计算器
- randwall     壁纸切换
- caffeine     阻止桌面锁屏和系统暂停
- media-player  媒体播放信息显示及快捷控制（部分播放器可能不支持）

 附 media player indicator设置中l展示播放信息的pango设置示例：
```pango
<span foreground="#eb3f2f">{trackTitle}</span> --> <span foreground="#81c2d6">{trackAlbum}</span> @ <span foreground="#c3bed4">{trackArtist}</span>
```

 

# 主题外观

在[gnome-look](gnome-look.org)或源中可下载一些主题图标，也可是使用[ocsstore](https://www.linux-apps.com/p/1175480/)下载，一些主题如：

- gtk主题：arc united flat-plat candy paper vertex adapta osx-arc gnome-osx
- 图标主题：numix-circle papirus masalla paper flattr moka la-capitaine-icon-theme pinbadge
- 鼠标主题：osx-elcap xcursor-flatbed xcursor-numix numix-cursor-theme neoalien

# gnome系软件使用

## nautilus鹦鹉螺文件管理器

- 右键添加新建文件菜单
  在Templates文件夹中建立模板（如果对文件夹汉化过，则在“模板”文件夹内建立）。

  如建立.md类型文件：
  `touch ~/Templates/md.md`

- 已汉化文件夹恢复

  删除或更改~/.config下的user.dirs文件内容。

- 网络存储
  - webDav
    nautilus可添加webDav服务。[坚果云nutstore](http://www.jianguoyun.com)支持webDav。
  - 网盘插件
    - natilus-nutstore  坚果云的nautilus插件
    - nautilus-megasync  [Megasync](https://mega.nz/)的nautilus插件
    - nautilus-dropbox  [dropbox](https://www.dropbox.com/)的nautilus插件

## gnome terminal透明

在/.bashrc（zsh用户在/.zshrc）中写入：

```shell
if [ -n "$WINDOWID" ]; then
  TRANSPARENCY_HEX=$(printf 0x%x $((0xffffffff * 77/100)))
  xprop -id "$WINDOWID" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$TRANSPARENCY_HEX"
fi
```

65/100是透明系数（65%）。
注意：wayland中无效。

## 修改gnome屏幕录制时间上限

使用`ctrl`-`alt`-`shift`-`r`可以录制不超过30秒的短视频，可以使用dconf-editor修改`/org/gnome/settings-daemon/plugins/media-keys/max-screencast-length`的值。

## 修改夜光(nigh-light)色温值

gnome的设置中的夜光（night-light）默认色温值是4000，可使用dconf-editor修改`/org/gnome/settings-daemon/plugins/color/night-light-temperature`的值。

## 修改networkmanager网络热点（AP)密码

首先在网络设置中开启热点，会随机生成一串密码，然后关闭热点，再修改`etc/NetworkManager/system-connections/ap`文件中`psk=`后面的内容为想要修改的新密码。重启networkmanager后再开启热点就会使用修改后的密码。

## gnome相关软件

一些gnome系软件

- gnome-software   软件商店
- gedit的插件：gedit-code-assistance和gedit-plugins。
- file-roller 压缩解压打包
- geary   邮箱客户端 简洁
- gvfs-google  在nautilus 挂载GoogleDrive
- gitg    图形界面的git工具
- polari    IRC客户端
- vinagre   vnc客户端
- totem   视频播放器
- gnome-music   音乐播放器
- shotwell   数码相片管理工具
- epipthany gnome浏览器（webkit内核，可生成网页应用--其实就是快捷方式，编辑页面文件后保存时能够**自动刷新**）
- gnome-schedule   计划任务（cron图形端）
- gnome-search-tool  搜索工具(可所搜文件中的文字)
- gnome appfolder manager   管理应用程序文件夹

# 快捷键

在快捷键设置界面按下退格(backspace)可消除设定的快捷键。

某些使用频繁的功能利用快捷键比较方便。

- 一些默认的快捷键：

  Super+h                      隐藏当前窗口
  Super+Left/RIght     窗口平铺于左/右侧
  Super+v	                     显示通知清单

  Print                       截取当前屏幕为图片-更改为super+Print避免误按截图
  Shift+Print            截取指定区域为图片（使用鼠标拖选）
  Alt+Print		截取当前窗口为图片
  ​	以上三条指令分别加上Ctrl，则是截取图片到剪切板
  Shift+Ctrl+Alt+r   录制屏幕短视频
  ​	最多录制30秒，可中途按下再次Shift+Ctrl+Alt+r可停止录制
  ​

- 一些自行修改的快捷键：

  Super+f1/f2/f3/f4     切换到不同工作区
  Ctrl+f1/f2/f3/4          移动窗口到不同工作区
  Shift+Super+h          隐藏所有正常窗口（hidden)
  Super+f                      切换全屏状态(fullscreen)
  Shift++shif+r            改变窗口大小(re**size**)
  Super+shift+m         移动窗口(move)
  Super+e                     文件管理器nautilus
  Super+Return          gnome-terminal终端
  Super+g                    文件编辑器gedit
  Super+shift+s          文件搜索工具

# 电源管理

- 按下alt后，电池图标中的关机/重启按钮会变成暂停按钮。
- hibernate-status   扩展可以增加休眠等按钮。
- systemctl hybrid-sleep/hibernate/supend 命令分别是：混合睡眠（通电状态，保存到硬盘和内存）、休眠（关机状态，保存到硬盘）和睡眠（通电状态，保存到内存）。为了方便使用可将他们设置别名，在~/.bashrc中写入：

```
alias hs='systemctl hybrid-sleep'  #混合睡眠
alias hn='systemctl hibernate'    #休眠
alias sp='systemctl suspend'  #暂停（挂起)
```

- 笔记本用户推荐安装[tlp](https://wiki.archlinux.org/index.php/TLP)或者[laptop-mode-tools]()
- intel可安装[powertop](https://wiki.archlinux.org/index.php/Powertop)

# 使用技巧

*以下是没有更改默认设置的情况下*

-   `Alt+F2`    快速使用命令(`r`命令重启shell，`rt`命令重载shell主题）

-   开启application menu扩展可以在右上角添加分类程序菜单（默认`alt+f1`)

-   `Alt+Space`    可以弹出标题栏右键菜单

-   按住`Alt`键时关机按钮会变成暂停按钮（suspend）

-   鼠标滚轮/鼠标中键点击dock上的图标会打开一个程序的新窗口

    按住`Ctrl`时鼠标左键点击dock上的图标会打开一个程序的新窗口

-   拖动窗口到屏幕左/右边缘会平铺该窗口到屏幕左/右

-   gnome3.24自带夜光功能，无需使用redshift和xflux
