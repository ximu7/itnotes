[TOC]

# 无线连接

## Wi-Fi
一般地，安装`linux-firmware` 即可，许多发行版会默认安装此包，如果安装主流的桌面环境，也会自动安装它。

还可以尝试`linux-firmware-iwlwifi`(也可能名为`firmware-iwlwifi`) ，此软件包为intel相关网卡驱动。

一些网卡可能需要寻找相应的驱动，可到其官网寻找支持，或者以网卡名、具体型号加firmware作为关键字搜索解决方案。可使用｀lspci | grep Network｀查看具体显卡情况。

其他解决思路：换网卡；使用免驱动安装的usb网卡。

## 蓝牙

一般地，安装`bluez`即可，一些发行版会默认安装此包，如果安装主流的桌面环境，也会自动安装它。

特别的驱动解决思路参考上文“wi-fi”。

可以参考这篇文章- [archwifi-蓝牙](https://wiki.archlinux.org/index.php/Bluetooth_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

# rfkill

某些情况下，wifi或者蓝牙被关闭（尤其是硬关闭）但是又找不打开的方法，可以使用`rfkill`这个工具解决，常用命令：

```shell
rfkill list    #查看所有无线设备的状态
rfkill unblock all    #启用所有设备
rfkill --help    #查看rfkill相关命令
```

# 触摸板

一般安装桌面环境（如gnome、plasma等等）会自动安装上触摸板相关驱动；如果使用的一些窗口管理器（如i3wm、awesom）则可能需要自行安装。

安装驱动 ` xf86-input-synaptics` 

如果从其他桌面环境改用gnome作为桌面环境，则要用`libinput` 替换掉 ` xf86-input-synaptics` （GNOME 目前不再支持 [synaptics](https://wiki.archlinux.org/index.php/Synaptics)），卸载掉 `xf86-input-synaptics`。

# 节电

## 按键和笔记本盖子的电源响应动作 

针对按下电源相关按钮（如挂起/休眠/电源等按键）和盖上笔记本盖子等行为而响应的电源动作。

systemd 能够处理某些电源相关的事件，编辑 /etc/systemd/logind.conf 可进行配置，其主要包含以下事件：

- HandlePowerKey：按下电源键
- HandleSleepKey：按下挂起键
- HandleHibernateKey: 按下休眠键
- HandleLidSwitch：合上笔记本盖
- HandleLidSwitchDocked：插上扩展坞或者连接外部显示器情况下合上笔记本盖子

取值可以是 ignore、poweroff、reboot、halt、suspend、hibernate、hybrid-sleep、lock 或 kexec。

其中：

- poweroff和halt均是关机（具体实现有区别）

- supspend是挂起（暂停），设备通电，内容保存在内存中

- hybernate是休眠，设备断电（同关机状态），内容保存在硬盘中

- hybrid-sleep是混合睡眠，设备通电，内容保存在硬盘和内存中

- lock是锁屏

- kexec是从当前正在运行的内核直接引导到一个新内核（多用于升级了内核的情况下）

- ignore是忽略该动作，即不进行任何电源事件响应

注意，系统默认设置为：

```shell
HandlePowerKey=poweroff    #按下电源键关机
HandleSuspendKey=suspend    #按下挂起键挂起（暂停）
HandleHibernateKey=hibernate    #按下休眠键休眠
HandleLidSwitch=suspend    #盖上笔记本盖子挂起
```

例如要设置盖上笔记本盖子进行休眠，在该文件中配置：

```shell
HandleLidSwitch=hibernate
```

保存文件后，执行 `systemctl restart systemd-logind` 使其生效。

注意：**一些Linux发行版可能需要自行对休眠进行配置，参考后文“休眠配置”**，或者借助pm-utils之类的工具实现。
桌面环境带有的电源管理工具能管理上述（部分）动作的电源响应事件。

## 电池低电量的电源相应动作

如希望在电池电量极低的时候自动关机，可以通过修改`/etc/UPower/UPower.conf`相关配置，示例，在电量低至%5时自动休眠：

```shell
PercentageLow=15  #<=15%低电量
PercentageCritical=10  #<=10%警告电量
PercentageAction=5  #<=5%执行动作（即CriticalPowerAction)的电量
CriticalPowerAction=PowerOff #(在本示例中是电量<=5%）执行休眠
```

CriticalPowerAction的取值有Poweroff、Hibernate和Hybid-sleep。

更多配置项参考该文件中的说明。


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

- [powertop](https://github.com/fenrus75/powertop)    intel处理器使用的电源管理工具

  执行`sudo powertop --auto-tune` 即可启动自行调节，如果希望使其开机自启动，可以编写脚本使其开机运行，或者自建一个systemd启动服务项：

  使用sudo或root用户新建`/etc/systemd/system/powertop.service`文件，写入内容：

  ```shell
  [Unit]
  Description=Powertop tunings

  [Service]
  ExecStart=/usr/bin/powertop --auto-tune
  RemainAfterExit=true

  [Install]
  WantedBy=multi-user.target
  ```

  然后执行`systemctl enable powertop`即可。

  参考[archwiki-powertop](https://wiki.archlinux.org/index.php/Powertop)

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

使用方法：

编辑/etc/default/grub，在`GRUB_CMDLINE_LINUX_DEFAULT`一行添加`intel_pstate=enable`，例如该行原有内容是：

> GRUB_CMDLINE_LINUX_DEFAULT=”quiet”

添加添加`intel_pstate=enable`后即是：

> GRUB_CMDLINE_LINUX_DEFAULT=”quiet intel_pstate=enable”

然后执行`sudo grub-mkconfig -o /boot/grub/grub.cfg` ，重启生效。

## 休眠配置

1.  合适大小的swap分区

   休眠（hibernate）需要将内存中的内容写入磁盘的swap分区，如果swap分区大小比当前休眠所需空间小，则无法保证能够正确地休眠。具体的swap的大小根据个人使用情况（要休眠时的内存占用）而定。

   因此，如果 swap 分区过小，需增大 swap分区或减小 `/sys/power/image_size` 。

   注意：brtfs格式无法设置swap分区；这里的swap是swap分区而不包括swap file的情况。

2.  在bootloader 中增加resume内核参数

   需要添加`resume=/dev/sdxY` (sdxY 是 swap分区的名字) ，让系统在启动时读取swap分区中的内容。

   例如，使用了grub2作为bootloader，swap的分区是/dev/sda3。

   编辑`/etc/default/grub` 文件，在`GRUB_CMDLINE_LINUX_DEFAULT`中添加`resume=/dev/sda3` ，假如该行的原有内容是：

   > GRUB_CMDLINE_LINUX_DEFAULT=”quiet intel_pstate=enable”

   添加resume参数后就是：

   > GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable resume=/dev/sda3"

   然后更新 grub 配置 `grub-mkconfig -o /boot/grub/grub.cfg`

3.  配置 initramfs的resume钩子

   编辑 `/etc/mkinitcpio.conf` ，在`HOOKS`行中添加`resume`钩子：

   例如该行原有内容是：

   > HOOKS="base udev autodetect modconf block filesystems keyboard fsck"

   添加`resume`后就是：

   > HOOKS="base udev resume autodetect modconf block filesystems keyboard fsck"

   注意：如果使用lvm分区，需要将`resume`放在`lvm`后面，示例：

   > HOOKS="base udev autodetect modconf block lvm2 resume filesystems keyboard fsck"

   重新生成 initramfs 镜像: `mkinitcpio -p linux`

## 独显管理

**个人建议**使用闭源驱动，更建议**一般使用场景**下关闭独显。

如果不需要运行大量耗费GPU资源的程序，可以禁用独立显卡，只使用核心显卡。

- 执行以下命令关闭独立显卡

  ```shell
  su    #必须切换到root用户才能执行下一条命令
  echo OFF > /sys/kernel/debug/vgaswitcheroo/switch  #注意，如果使用了bbswtich那么应该是没有这个文件的！
  ```
  检查NVIDIA开启情况：`lspci |grep NVIDIA`

  如果输出内容后面的括号中出现了` (rev ff)` 字样则表示该显卡已关闭。


在Linux中可使用以下方法来切换显卡。参看相关资料：

- [prime](https://wiki.archlinux.org/index.php/PRIME_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29)（NVIDIA和ATI均支持）
- [NVIDIA optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))（NVIDIA的方案，这里主要推荐以下两个）
  - [bumblebee](https://wiki.archlinux.org/index.php/Bumblebee_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
  - [nvidia-xrun](https://github.com/Witko/nvidia-xrun)（更推荐，该方案支持Vulkan接口。配置方法参考[archlinux安装](arch/archlinux安装.md)中其他配置-双显卡管理。）

### 配置bbswitch+nvidia-xrun

使用方法：

1.  切换到tty
2.  登录
3.  运行`nvidia-xrun 程序名`

#### bbswitch

安装bbswitch后在终端执行以下命令即可：

```shell
#开机自动加载bbswitch模块
sudo echo 'bbswitch ' > /etc/modules-load.d/bbswitch
#设置bbswitch模块参数
sudo echo 'options bbswitch load_state=0' > /etc/modprobe.d/bbswitch.conf 
#获取模块名
lsmod | grep nvidia | cut -d ' ' -f 1 > /tmp/nvidia
lsmod | grep  nouveau | cut -d ' ' -f 1 > > /tmp/nvidia
sort -n /tmp/nvidia | uniq >  /tmp/nvidia.conf#去重
sed -i 's/^\w*$/blacklist &/g' /tmp/nvidia.conf  #添加blacklist
sudo cp /tmp/nvidia.conf /etc/modprobe.d/nvidia.conf  #移动
```

执行以上命令即可进入下一小节(nvidia-xrun），本节其余内容是对上述命令的详细介绍：

1. 开机自动加载bbswitch模块

   添加文件`/etc/modules-load.d/bbswitch` ，写入内容`bbswitch`。

2. 设置bbswitch模块参数

   添加`/etc/modprobe.d/bbswitch.conf `文件，写入内容`options bbswitch load_state=0 `

3. 添加nvidia相关模块到黑名单

   使用`lsmod |grep nvidia`和`lsmod | grep nouveau`找出所有的相关模块的名字；新建文件`/etc/modprobe.d/nvidia.conf ` ，在其中添加模块黑名单。

   黑名单写法：每行以`blacklist`开头，然后一个空格，其后写上一个模块名。

   检查：重启后使用`lspci grep NVIDIA`和`cat /proc/acpi/bbswitch`检查关闭情况。

   ​

使用以下命令控制bbswitch进行开关显卡：

```shell
sudo tee /proc/acpi/bbswitch <<<OFF  #关闭独立显卡
sudo tee /proc/acpi/bbswitch <<<ON  #开启独立显卡
```

#### nvidia-xrun

1. 安装[nvidia-xrun](https://github.com/Witko/nvidia-xrun)

   ```shell
   yaourt -S nvidia-xrun  #或者nvidia-xrun-git
   ```

2. 配置nvidia-xrun

   如果安装nvidia-xrun完毕后，`/etc/X11/nvidia-xorg.conf`可能已经自动配置完成，检查该文件，如果其中的内容包含下文`/etc/X11/nvidia-xorg.conf.d/30-nvidia.conf`的类似内容，则无需再进行配置，直接进行下一步“配置xrun运行的窗口管理器”。

   - 设置NVIDIA设备的总线ID

     获取ID：一般的设备的总线ID是`1:0:0`，为了确保正确，使用一下命令获取ID:

     ```shell
     lspci | grep NVIDIA
     ```

     在输出内容中第行首即可看到ID。

     新增文件`/etc/X11/nvidia-xorg.conf.d/30-nvidia.conf` ，添加类似如下内容：

     ```shell
     Section "Device"
         Identifier "nvidia"
         Driver "nvidia"
         BusID "PCI:1:0:0"
     EndSection
     ```

     上面的PCI即是获取到的总线ID。

3. 配置xrun运行的窗口管理器

   安装一个窗口管理器例如[openbox](https://wiki.archlinux.org/index.php/Openbox_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)) 、 [i3wm](https://wiki.archlinux.org/index.php/I3_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

   该窗口管理器/桌面**只是用来单独承载需要使用xrun运行的程序**。当然如果系统上本来就使用的窗口管理器或轻量桌面，可不必再安装。

   编辑~/.nvidia-xinitrc，例如使用openbox，在其中添加：

   > openbox-session

   运行`nvidia-xrun `可以启动openbox并使用NVIDIA渲染。