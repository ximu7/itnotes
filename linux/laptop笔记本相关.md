# 无线连接
## Wi-Fi
一般地，安装`linux-firmware` 即可，许多发行版会默认安装此包，如果安装主流的桌面环境，也会自动安装它。

还可以尝试`linux-firmware-iwlwifi`(也可能名为`firmware-iwlwifi`) ,此软件包为intel相关网卡驱动。

一些网卡可能需要寻找相应的驱动，可到其官网寻找支持，或者以网卡名加firmware作为关键字搜索解决方案，当然有具体的型号作关键字亦可。可使用｀lspci | grep Network｀查看具体显卡情况。

其他解决思路：换网卡；使用usb网卡。

## 蓝牙

一般地，安装`bluez`即可，一些发行版会默认安装此包，如果安装主流的桌面环境，也会自动安装它。

特别的驱动解决思路参考上文“wi-fi”。

可以参考这篇[archwifi-蓝牙](https://wiki.archlinux.org/index.php/Bluetooth_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

# rfkill

有一种情况是wifi或者蓝牙可能被关闭而无法使用，但是又找不打开的方法，可以使用`rfkill`这个工具：

```shell
rfkill list    #查看所有无线设备的状态
rfkill unblock all    #启用所有设备
rfkill --help    #查看rfkill相关命令
```

# 触摸板

一般安装桌面环境（如gnome、plasma等等）会自动安装上触摸板相关驱动；如果使用的一些窗口管理器（如i3wm、awesom）则可能需要自行安装。

安装驱动 ` xf86-input-synaptics` 

如果又改用了gnome作为桌面环境，则要用`libinput` 替换掉 ` xf86-input-synaptics` （GNOME 目前不再支持 [synaptics](https://wiki.archlinux.org/index.php/Synaptics)），卸载掉 `xf86-input-synaptics`。

# 节电

## 电源管理工具

- 使用行为和电源策略管理工具

  即常见桌面环境带有的电源管理工具（如plasma的powerdevil），管理各种使用行为和电源策略 ，如使用电池时的亮度、灭屏时间、挂起、睡眠、盖上笔记本盖子的行为等等。

  如果使用窗口管理器（WM）或者使用的桌面环境（DE）没有电源管理工具，（目前）推荐使用mate桌面的电源管理工具`mate-power-manager` ，它没有多余的依赖且功能齐全。


较为高级的电源管理工具：

-  [tlp](https://github.com/linrunner/TLP)

  使用默认配置就很好，安装后执行`systemctl enable tlp` 即可。

  另可再安装tlp-rdw用以设置无线设备

  [tlp英文文档](http://linrunner.de/en/tlp/docs/tlp-configuration.html#rdw)

- [laptop-mode-tools](https://github.com/rickysarraf/laptop-mode-tools)  可对硬盘、cpu、usb、显示器、网络、音频设备等等进行配置，可参考[archwiki-Laptop Mode Tools (简体中文)](https://wiki.archlinux.org/index.php/Laptop_Mode_Tools_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.9B.BA.E6.80.81.E7.A1.AC.E7.9B.98)

- [powertop](https://github.com/fenrus75/powertop)

  intel处理器使用的电源管理工具，可参考[archwiki-powertop](https://wiki.archlinux.org/index.php/Powertop)

-  其他cpu频率管理工具，见下文处理器调频相关工具……

建议使用桌面环境的电源管理工具+tlp或laptop-mode-tools为主（二者功能齐全），如有需要可配合powertop和频率工具。

## 处理器调频

使一般是降低频率以**减少发热**，同时**降低风扇**转速以减少**噪音**，并**提升**笔记本的电池**续航**时间。不了解超频相关知识不建议超频。

在`/sys/devices/system/cpu`目录下有着cpu相关配置信息。如intel处理器的设备，其系统在`/sys/devices/system/cpu/intel_pstate` 目录下（可能存在）的文件规定着cpu运行频率相关参数，如：

- max_perf_pct    最高频率百分比，数字0 - 100
- min_perf_pct    最低频率百分比，数字0 - 100
- no_turbo    不开启睿频，数字0或1，1表示关闭

可对其进行修改以实现调频。

### 调频工具

一些调频工具：

- cpupower    属于Linux内核工具系列 但有的发行版不一定会默认安装

  安装后执行`cpupower frequency-info` 可查看到相关信息

- cpupower-gui    图形界面

- [gnome-shell-extension-cpupower](https://github.com/martin31821/cpupower)    可在[Gnome 插件网站](https://extensions.gnome.org/extension/945/cpu-power-manager/)找到此插件
  - archlinux可使用`yaourt gnome-shell-extension-cpupower-git`

一般搜索cpupower、freq、cpu加freq等关键字可以找到此类工具。

### 关闭睿频

linux发行版（可能）一般是开启了睿频（windows默认状态是没有开启睿频），可到相关专业网站查看该型号电脑的参数了解睿频情况。

可使用命令 ：`cat /sys/devices/system/cpu/intel_pstate/no_turbo` 查看睿频开启状态，如果显示0则表示开启睿频，显示1则表是关闭睿频。（intel）

手动调整：

- 如果bios支持，在bios中设置。

- 使用工具调节

  如上文提到的工具cpupower-gui，图形界面，操作简单。

- ` echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo`

  需要sudo或root权限。

重启后保持关闭睿频状态：

使用上述关闭方式（不含bios调整）在重启后被恢复成睿频开启状态，而有始终默认关闭睿频的需要，可以：

- 使用脚本让` sudo echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo` 在进入系统后自动执行

- 使用tlp或laptop-mode-tools等电源管理工具

  如tlp，编辑/etc/default/tlp，找到其中的两行CPU_BOOST，修改为：

  ```shell
  CPU_BOOST_ON_AC=0   #0表示关闭
  CPU_BOOST_ON_BAT=0    #1表示开启
  ```

- 使用cpupower调频工具

  编辑/etc/default/cpupower，找到`min_freq`.`max_freq` 这两行，去掉其注释的`#`， 填写好频率并保存

  ````shell
  min_freq="0.25GHz"    #最小频率
  max_freq="2.5GHz"    #最大频率
  ````

  例如非睿频状态是2.5ghz，就改写上2.5ghz。

  执行`systemctl enable cpupower.service` 使其生效。

以上方法使用一种即可，例如已经使用了tlp，就无需再使用cpupower规定最高频率了。

### intel_pstate

只针对intel处理器中**SandyBridge（含IvyBridge）及更新的构架**的CPU。intel构架列表：[List of Intel CPU microarchitectures](https://en.wikipedia.org/wiki/List_of_Intel_CPU_microarchitectures)。

援引：

> 其实**Linux内核**对CPU的工作频率管理，已经跟不上现代的CPU的需求，无法在效能与省电取得平衡，所以intel自己写了一段内核代 码，Intel_pstate……内核3.13中，已经放入这段代码，但没有默认启用（我猜是因为还有很多使用者，**还在使用SandyBridge之前的 CPU**）。

使用方法：编辑/etc/default/grub，将此行

> GRUB_CMDLINE_LINUX_DEFAULT=”quiet”

改成

> GRUB_CMDLINE_LINUX_DEFAULT=”quiet splash intel_pstate=enable”

当然，此行等号`=`后也可能是空的（根据不同情况），主要更改就是加上`intel_pstate=enable` 。

然后执行`sudo grub-config -o /boot/grub/grub.cfg` ，重启生效。

## 独显管理

**个人建议**使用闭源驱动，更建议**一般使用场景**下关闭独显。

- 如果不需要运行很吃GPU的程序，可以禁用独立显卡

  执行一下命令关闭独立显卡：

  ```shell
  su    #必须切换到root用户才能执行下一条命令
  echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
  ```

  **注意，如果使用了bbswtich那么应该是没有这个文件的！**

  如果使用`bbswitch`，只需要安装bbswitch后重启系统就可自动关闭独立显卡。

  查看显卡启用状态：

  ```shell
  lspci |grep NVIDIA    #nvidia显卡查看
  lspci |grep ATI    #ati显卡查看
  ```

  如果输出内容后面的括号中出现了` (rev ff)` 字样则表示该显卡已关闭。

- 显卡切换

  使用[Prime](https://wiki.archlinux.org/index.php/PRIME_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))（目前支持使用开源的nvidia驱动nouveau）

  nvidia还可以使用[bumblebee](https://wiki.archlinux.org/index.php/Bumblebee_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#Bumblebee:_Linux.E4.B8.8A.E7.9A.84_Optimus)