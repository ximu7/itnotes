[TOC]


本文极为详细地记录了ArchLinx系统的安装过程。包含了Windows+ArchLinux双系统处理，lvm多级存储管理Linux分区的方法，搭建图形界面和安装常用软件的介绍，相关问题的解决等等。

# 准备工作
## 工具
- 划分一定量的磁盘空间。（个人推荐至少30G）
- **在bios设置中关闭启设置中的安全启动。**（如有该设置）

---
### 安全启动Secure Boot
在UEFI  BIOS中,为了对抗感染MBR、BIOS的恶意软件, Windows 8以以上的Windows系统缺省将使用Secure  Boot，在启动过程中，任何要加载的模块必须签名(强制的)，UEFI固件会进行验证，没有签名或者无法验证的，将不会加载。只有部分linux系统发行版购买了该签名验证，在BIOS使用了安全启动的设备上需关闭安全启动以安装archlinux。

如需对archlinux使用安全启动，可参考[archwiki-Secure Boot](https://wiki.archlinux.org/index.php/Secure_Boot_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- 互联网。（安装过程需要联网）
- U盘。（使用u盘安装方便许多）
- [Arch Linux ISO文件](https://www.archlinux.org/download/)。（在该页china下的网站下载速度较快）
- 启动盘制作工具。（下文“制作启动盘）

---

### 制作启动盘

- windows可使用[usbwriter](https://sourceforge.net/projects/usbwriter/)、[poweriso](http://www.poweriso.com)、[winsetupfromusb](http://www.winsetupfromusb.com/)等工具。

- Linux/OSX可使用dd命令。示例：
```shell
dd if=/path/arch.iso of=/dev/sdb bs=10M
```
​	**if=**后面是/path/arch.iso是archlinux的ISO文件的路径，**of=**后的sdx是U盘的设备编号如sda、sdb、sdc等（可插上优盘后在终端用`df -h`命令查看，切记认真核查），**bs=**后是每秒写入数据大小。

---

- nano或vim基本操作技能。（安装过程中编辑配置文件）

  nano简单使用：

```shell
nano 文件名
#如
nano abc
```
​	保存`Ctrl+o`，查找`Ctrl+w`+回车，退出`Ctrl+x`，剪切`Ctrl+k`，粘贴`Ctrl+u`。

---

## 安装装备
插上U盘启动盘，使用USB启动（具体方法以设备不同而不同）。计算机载入U盘上的系统后，回车选择**第一项**（默认）进入，等待一切载入完毕……
### 硬盘分区
#### 规划准备
首先查看整个磁盘的情况（分区大小位置等），确定分区计划。
查看分区命令示例：
```shell
cfdisk /dev/sda    #查看第一块硬盘的分区情况
cfdisk    #同 cfdisk /dev/sda
cfdisk /dev/sdb    #查看第二块硬盘分区情况，第三块则是sdc以此类推
# 注意U盘也会占用一个磁盘号
```
cfdisk利用箭头进行上下左右移动，回车键选中/确定，q退出。

**以下的示例均以对/dev/sda硬盘进行分区和安装。**

执行`cfdisk`

再上下移动选中准备步骤中预先划分的空间，按下回车。

New用于新建分区，输入新建分区的大小并回车，就建立了一个分区。

Write用于保存操作。

**一般地**，建议（普通图形界面使用用户）划分以下分区：

- boot分区--引导分区，系统引导文件所在，是系统加载前读取的分区。
- root分区--根分区，系统文件所在，root用户目录所在。
- home分区--非root用户的默认目录，用户存放用户的一般文件、软件配置、某些缓存等等。
- swap分区--交换分区，如果**内存较大，可以不划分** （一般性使用，内存在4g以上可以不划分）。如果要使用系统休眠，或有运行大量耗费内存的工作而可能导致内存不足的情况最好划分。具体根据情况。如需系统休眠可划分4G左右，具体根据实际休眠时占用的内存大小而斟酌。

---

##### MBR、GPT、ESP、MSR、EFI和UEFI

MBR和GPT是磁盘分区架构

- MBR分区表：Master Boot Record，即硬盘主引导记录分区表。

  支持容量：2.1TB 以下。

  分区个数：4个主分区或三个主分区和一个扩展分区，扩展分区下可以有多个逻辑分区。

- GPT分区表：GPT，全局唯一标识分区表(GUID Partition  Table)。**只有基于UEFI平台的主板才支持GPT分区引导启动。**

  分区数量：没有限制，（但目前Windows最大仅支持128个GPT分区）。

  支持容量：18EB以下。

ESP和MSR是分区名称

- ESP分区：EFI system partition，用于采用了EFI  BIOS的电脑系统，用来启动操作系统。分区内存放引导管理程序、驱动程序、系统维护工具等。，**用GPT分区架构就会产生ESP分区**。

- MSR分区：即微软保留分区，是GPT磁盘上用于保留空间以备用的分区，例如在将磁盘转换为动态磁盘时需要使用这些分区空间。

  ​

- EFI：可扩展固件接口英文名Extensible Firmware Interface  的缩写，是**英特尔**推出的一种在未来的类PC的电脑系统中替代BIOS的升级方案。

- UEFI：新型UEFI，全称“统一的可扩展固件接口”(Unified Extensible Firmware Interface)，  是一种详细描述类型接口的标准。这种接口用于操作系统自动从预启动的操作环境，加载到一种操作系统上。UEFI是由EFI1.10为基础发展起来的，它的**所有者已不再是Intel**，而是Unified  EFI Form的国际组织。其主要目的是为了提供一组在 OS 加载之前（启动前）在所有平台上一致的、正确指定的启动服务，被看做是有近20多年历史的  BIOS 的继任者。

**windows下磁盘为mbr或gtp的查看方法**

打开文件管理器，点击上方“计算机”（或我的电脑）--选择“管理”--选择“磁盘管理”--点击“磁盘0”--右键--“属性”--“卷”,在磁盘分区形式一栏可见。

---

#### efi系统分区(esp)

上文已述，使用gpt分区架构才有esp，**如使用mbr分局架构则跳过该小节。**

esp假令为/dev/sda1，方便下面进行示例。

- **如果磁盘上不存在esp**则需要新建一个esp，假令为/dev/sda1，然后建立文件系统：

  ```shell
  mkfs.fat -F32 /dev/sda1
  # 或
  mkfs.vfat /dev/sda1
  ```

- **如果磁盘上已经存在esp**，可直接使用该esp**作为linux的boot分区，**最好不要随意格式化该分区或者删除该分区内容**（除非确知该操作的意义，esp内有其他系统的引导文件）。

  windows默认安装的情况下，其自动划分的esp大小是100M，勉强足够两个系统使用，不过也可利用磁盘工具对该分区进行扩容，一般efi分区前后会有一两个小分区（一般是windows 恢复分区和windows保留分区），可在windows恢复分区中划分出100M合并到efi分区上。

#### 一般分区法

**如使用lvm分区法则跳过本小节。**

按分为4个区示例，大小为建议大小：

- boot分区--200M

  注意：**使用gpt分区架构的磁盘，参考上文关于esp的相关说明**，

- root分区--建议至少20G

- home分区--根据需要划分。即使不怎么存放文件，安装软件较少，也建议10G以上。

- swap分区--根据实际需要划分。


#### LVM分区法

**如不使用lvm，则跳过本小节。**

参看[archwiki-lvm](https://wiki.archlinux.org/index.php/LVM_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

注意：**lvm中不能包含boot分区**，如使用mbr分区架构，需单独建立一个boot分区，使用gpt分区架构参考前文，使用esp作为boot分区。

---
**lvm介绍**

- lvm结构

  物理卷Physical volume (PV)即是硬盘分区（也可以是硬盘本身或者回环文件（loopback file）；

  卷组Volume group (VG)将一组物理卷收集为一个管理单元（一组）；

  逻辑卷Logical volume (LV)可看作卷组下的虚拟子卷，它（们）是一个卷组下划分的虚拟分区，即是用作安装linux的各个分区（如home分区）。

  ​

  （一个或多个）**物理卷组成**（一个）**卷组**;（一个）**卷组**包含（一个或多个）**逻辑卷**。

  pv-->vg<--lv

- lvm优点：富于弹性。 

  使用卷组(VG)，使众多硬盘空间看起来像一个大硬盘。 使用逻辑卷（LV），可以创建跨越众多硬盘空间的分区。可以动态调整逻辑卷(LV)。可以在线调整逻辑卷和卷组。可以创建快照。

---

分区示例

- 物理卷（PV）
```shell
pvcreate /dev/sda2    #在 /dev/sda2建立一个物理卷
pvcreate /dev/sda2 ssd   #可以在建立物理卷时为其起名
```

- 卷组（VG）
```shell
# 新建名linux的卷组并将物理卷/dev/sda2加入此卷组
vgcreate linux /dev/sda2 
# 将linux卷组扩增到磁盘c
vgextend linux /dev/sdc  
# 也可在创建卷组时一次加入多个物理卷
vgcreate linux /dev/sda2 /sda9 /dev/sdc
```

- 逻辑卷（LV）
```shell
lvcreate -L 20G linux -n root   # 作为root分区
lvcreate -L 4G linux -n swap    # 作为swap分区
lvcreate -L 100G linux -n home  # 作为home分区
```

附lvm查看命令，在创建lvm后进行检查。
```shell
lvmdiskscan    #lvm分区扫描
pvdisplay    #查看物理卷
vgdisplay    #查看卷组
lvdisplay    #查看逻辑卷
```

### 创建文件系统

- 一般分区法

```shell
  mkfs.vfat /dev/sda1    #boot分区
  mkfs.ext4 /dev/sda2    #home或root分区
  mkfs.ext4 /dev/sda3    #home或root分区
  mkswap /dev/sda4       #swap分区
```

- lvm分区法

```shell
mkfs.ext4 /dev/mapper/Linux-root    #home或root分区
mkfs.ext4 /dev/mapper/Linux-home    #home或root分区
mkswap /dev/mapper/Linux-swap    #swap分区
```
### 分区挂载  
- 一般分区法
```shell
mount /dev/sda2 /mnt    #挂在root分区
mkdir /mnt/boot    #建立boot挂载点
mkdir /mnt/home    #建立home挂载点
mount /dev/sda1 /mnt/boot    #挂在boot分区
mount /dev/sda3 /mnt/home    #挂在home分区
swapon /dev/sda4    #激活交换分区
```

- lvm分区法

```shell
mount /dev/mapper/linux-root /mnt   #挂载root分区
mkdir /mnt/home    #建立home挂载点
mkdir /mnt/boot    #建立boot挂载点
mount /dev/mapper/linux-home /mnt/home    #挂载home
mount /dev/sda1 /mnt/boot    #挂载boot
swapon /dev/mapper/linux-swap    #激活交换分区
```
### 配置镜像源

在安装前最好选择较快的镜像，以加快下载速度。
编辑` /etc/pacman.d/mirrorlist`，选择首选源（按所处国家地区关键字索搜选择，如搜索china），将其复制到文件最开头，保存并退出。

一些中国地区镜像源如：

>Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
>Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch
>Server = https://mirrors.163.com/archlinux/$repo/os/$arch


# 安装配置
以下安装过程中遇到需要选择的地方，如不清楚如何选择，可直接回车。
## 基础安装和配置

### 连接网络

```shell
dhcpcd    #有线网络
wifi-menu    #无线网络 执行后会扫描网络 选择网络并连接即可
# 测试连接情况
ping -c 4 z.cn
```

### 安装基础系统
```shell
pacstrap /mnt base base-devel
```
### 建立fstab文件
```shell
genfstab -U /mnt >> /mnt/etc/fstab
# 可检查生成的 /mnt/etc/fstab 文件是否正确
cat /mnt/etc/fstab
```
### 进入系统

```shell
arch-chroot /mnt
```

### 激活lvm2钩子

**使用了lvm安装，需要执行该步骤**。否则则跳过该小节。

编辑/etc/mkinitcpio.conf文件，找到类似字样：

>HOOKS="base udev autodetect modconf block  filesystems keyboard fsck"

在block 和 filesystems之间添加**`lvm2`**（注意lvm2和block及filesystems之间有一个空格），类似：

> HOOKS="base udev autodetect modconf block lvm2 filesystems keyboard fsck"

更改了mkinitcpio.conf文件，需执行：
```shell
mkinitcpio -p linux
```

### 系统引导
```shell
#安装引导程序 grub
pacman -S grub
# 如使用efi引导 需安装 efibootmgr
pacman -S efibootmgr
# 如安装有多系统 需安装 os-prober
pacman -S os-prober
# 安装引导 boot非esp
grub-install /dev/sda
# 安装引导 boot使用了esp
grub-install --efi-directory=/boot --bootloader-id=grub
# 生成引导配置
grub-mkconfig -o /boot/grub/grub.cfg
```

**注意**：os-prober可能需要在系统安装完毕后，重启进入系统**再次执行**生成配置命令方能检测到其他系统。


### 网络连接
- 有线
  **即插即用**的有线网络用户不必安装任何工具。
```shell
systemctl enable dhcpcd   #开机自启动dhcpcd服务
# 其他相关操作
systemctl disable dhcpcd    #删除开机自启动dhcpcd服务
systemctl stop dhcpcd    #停止dhcpcd服务
systemctl start dhcpcd    #开启dhcpcd服务
```

- ADSL 宽带
```shell
pacman -S rp-pppoe   #安装相应工具
pppoe-setup    #配置连接
systemctl start adsl    #启动连接服务
systemctl enable adsl    #开机自启动连接服务
```
- 无线

  注意：使用无线网络的用户在重启前务必对网络相关工具进行安装设置，否则重启系统后没有连接无线网络的工具。

  - 使用netctl管理

  ```shell
  pacman -S iw wpa_supplicant dialog    #安装相关工具
  wifi-menu    # 扫描wifi 然后选择并连接
  ```
  更多操作方法参见[archwiki-netclt](https://wiki.archlinux.org/index.php/Netctl_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

  - 使用**networkmanager管理**（其也可以用以管理有线网络）
  ```shell
  pacman -S networkmanager    #安装
  systemctl enable NetworkManager    #开启自启动服务
  #命令行连接方法 其中ssid是ssid(wifi名字 password是wifi密码
  nmcli dev wifi connect ssid password password
  ```
  更多操作方法参见或[archwiki-networkmanager](https://wiki.archlinux.org/index.php/NetworkManager_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

---
补充：网络管理器的图形界面工具

以上网络管理工具均是使用命令行连接配置，为了配置和轻松使用网络管理器，可使用图形工具管理。一般桌面环境均默认安装networkmanager+配套图形工具。

如果使用的窗口管理器或者使用的桌面没有默认安装的图形管理工具，可以自行安装相关工具，如：

```shell
pacman -S network-manager-applet  #networkmanager的图形工具
yaourt -S netctl-gui    #netctl的图形工具
```

注意：yaourt使用参考后文“aur工具yaourt”。

---



此时基本系统已经安装和配置完成，可以连按 Ctrl+D 退出安装，输入reboot可以拔掉U盘进行重启了。（当然也可以继续以下安装流程）
登陆系统时输入root然后两次回车即可（密码默认为空），可接着进行以下安装和配置。

### 用户管理

- 用户和密码
```shell
passwd   #设置或更改用户密码  接着输入两次密码（密码不会显示出来）
useradd -m -g users -s /bin/bash user1   #user1是新建的用户名
passwd user1   #设置或更改用户密码 接着输入两次密码
# 注意 linux命令行下，输入密码过程中不会有任何显示
```

- sudo用户
  允许让普通用户执行一些或者全部的root命令的一个工具。

  ---

  /etc/sudoer文件可能默认不能写入（即使是root用户），执行以下命令给予写权限：

```shell
chmod u+w /etc/sudoers
```
---

​	添加sudo用户，编辑/etc/sudoers，找到

> root ALL=(ALL) ALL

​	在其下添加（示例）：

> user1 ALL=(ALL) ALL

​	user1是用户的名称（根据实际填写）。保存退出。

注：下文示例中pacman命令使用root用户执行，或者是具有sudo权限的用户执行（需要在pacman前加`sudo `，注意sudo后有空格），不再赘述。

### 设置时间

win+linux双系统**参考后文“linux+windows 双系统时间设置”**
```shell
# 设置时区 示例为中国东八区标准时间--Asia/Shanghai（北京/上海/香港）
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 可使用tzselect进行地区名查询
hwclock --systohc --utc     #使用utc时间
hwclodk --systohc --local   #使用本地时间 不推荐
timedatectl  #查看各种时间的情况
date    #查看当前时间
```
注意：使用本地时间可能会引起某些不可修复的bug。

### 主机名
```shell
echo MyPC >> /etc/hostname
```
MyPC是要设置的主机名。

### 显卡驱动

首先需要了解设备地显卡情况，在linux命令行下可使用`lspci | grep VGA`查看

根据显卡情况安装：

```shell
pacman -S xf86-video-vesa    #通用显卡
pacman -S xf86-video-intel    #intel集成显卡
pacman -S xf86-video-ati    #amd/ati
pacman -S nvidia    #nvidia
# 老式nvidia显卡（一般2010以前）如GeForce 8000/9000、ION、FGeForce 6000/7000等等
pacman -S nvidia-304xx
```
具有NVIDIA的设备的用户，可参看后文“问题解决-NVIDIA”一节。

### 图形界面实现

- X-window
  Xorg 是 X11 窗口系统的一个开源实现。一**般安装桌面环境时会默认安装该服务。**
```shell
pacman -S xorg-server
```

- wayland

  Wayland是 Linux 的一个新的图形接口协议。使用 Wayland 需要更改或重新安装一部分系统中的软件。目前gnome、plasma正逐渐支持wayland（gnome默认使用wayland），要使用wayland也不必单独安装wayland，在安装桌面时会自动带上。更多关于 Wayland 的信息参见[archwiki-wayland](https://wiki.archlinux.org/index.php/Wayland)或[wayland主页](http://wayland.freedesktop.org/)。

### 桌面环境/窗口管理器

窗口管理器（WM）是图形用户界面的一部分。桌面环境（DE）一般由窗口管理器+其他组件构成，功能完善，更加易用。

- 桌面环境
  桌面环境按喜好选择，如：
```shell
pacman -S plasma    #plasma(kde5)
pacman -S gnome    #gnome3
pacman -S xfce4    #xfce4
pacman -S lxde    #lxde
```
等等。[更多桌面环境](https://wiki.archlinux.org/index.php/Desktop_environment_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- 启动桌面环境或者窗口管理器

  使用显示管理器（登陆管理器）

  安装启动管理器(桌面环境安装时一般默认带有启动管理器)，如：

```shell
pacman -S sddm    #plasma建议使用sddm
pacman -S gdm    #gnome建议使用gdm
pacman -S lxdm    #lxde建议使用lxdm
#lightdm是一个一个跨桌面环境的启动管理器
pacman -S lightdm lightdm-gtk-greeter
```
​	[更多显示管理器](https://wiki.archlinux.org/index.php/Display_manager_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

​	选择安装了一款显示管理器后，执行`systemctl enable xx`命令使其自启动，如：

```shell
systemctl enable sddm
```


​	startx启动

​	用于不适用显示管理器启动wm/de。只针对使用x-window。先安装xinit

```shell
pacman -S xorg-xinit
```
​	然后在要使用startx登录wm/de的用户的家目录下添加.xinitrc文件。`~/.xinitrc` 文件是 xinit 和它的前端 startx 第一次启动时会读取的脚本。
编辑～/.xinitrc，写入：
```
#!/bin/sh
exec i3
```
​	对应相应的桌面环境或窗口管理器写入exec命令，如：
​	使用i3写入`exec i3`，使用awesome写入`exec awesome`，使用xfce4写入`exec xfce4`。exec命令要置于此文件内容的末尾。更多参看[archwiki-xinit](https://wiki.archlinux.org/index.php/Xinitrc_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

### 声音

[高级 Linux 声音体系](https://en.wikipedia.org/wiki/zh:ALSA)（Advanced Linux Sound Architecture，**ALSA**）是Linux中提供声音设备驱动的内核组件。Arch 默认的内核已经通过一套模块提供了 ALSA，不必特别安装。

桌面环境默认安装相关组件，可跳过此小节。

- 声音管理工具 alsa-mixer

  一个命令行工具

```shell
pacman -S alsa-utils
# 使用alsamixer命令可在命令行下进行管理进行
# 笔记本可以使用相应的快捷键进行控制
```

### 软件包管理器
#### pacman
pacman是archlinux的软件包管理器。
- 常用命令
```shell
pacman -Syu    #升级整个系统
pacman -S name    #安装软件 name是软件的名字
pacman -Ss words    #查询有某关键字的软件 words即是要查询的关键字
pacman -R name    #移除某软件但不移除其依赖 name是软件的名字
pacman -Qi name   #查看已经安装的某软件的信息 name是软件的名字
```

[	spacman的wiki说明]((https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))。


- pacman 设置
  配置文件在`/etc/pacman.conf`，编辑该文件：

  - 彩色输出：取消`#Color`中的#号。

  - 升级前对比版本：取消`#VerbosePkgLists`#号。

  - 社区镜像源：在末尾添加相应的源，中国地区用户添加以下之一：

    archlinuxcn.org

    > [archlinuxcn]
    > SigLevel = Optional TrustedOnly
    > Server = http://repo.archlinuxcn.org/$arch

    或者中科大中文社区镜像:

    > [archlinuxcn]
    > Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch

    或者网易中文社区镜像：

    > [archlinuxcn]
    > Server = https://mirrors.163.com/archlinux-cn/$arch

    添加完后执行： `pacman -Syu archlinuxcn-keyring`。

#### 用户软件仓库aur
Arch用户软件仓库（Arch User Repository，AUR）是为用户而建、由用户主导的Arch软件仓库。创建AUR的初衷是方便用户维护和分享新软件包，并由官方定期从中挑选软件包进入community仓库，许多官方仓库软件包都来自AUR。

aur软件可以通过yaourt等管理器搜索、下载和安装，或者从[aur.archlinux.org](https：//aur.archlinux.org)中搜索下载，用户自己通过makepkg生成包，再由pacman安装。

aur相关工具安装前需要完成上面的archlinux社区源添加。

aur相关工具参见[archwiki-aurhelper](https://wiki.archlinux.org/index.php/AUR_helpers_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- aur投票工具aurvote

  可以对喜欢的aur包进行投票，一方面鼓励打包者，另一方面作为官方收录的一个参考。使用aurvote需要在[aur.archlinux.org](https://aur.archlinux.org)注册账号。

  ```shell
  pacman -S aurvote   #安装该工具
  aurvote --configure   #配置用户名密码
  ```


- aur工具yaourt
  一个社区为增加pacman对AUR的无缝访问而做的软件包管理工具。
  在/etc/pacman.conf添加了用户软件仓库的社区源后执行：
```
pacman -Syu yaourt
```
注：**yaourt前不能使用sudo，root用户也不能使用yaourt**。

​	yaourt命令：

```shell
yaourt words    #搜索关键字 words是要搜索的关键字
yaourt -Syua    #更新整个系统
yaourt -S name    #安装软件 name是软件名
yaourt -Qdt    #查找孤儿包
```
​	卸载软件依然使用pacman相关命令。更多参考`yaourt -h`。

---

附pacman GUI：
 [pacman图形化的前端工具](https://wiki.archlinux.org/index.php/Graphical_pacman_frontends_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))。
这里介绍tkpacman，安装：`yaourt -S tkpacman`

tkpacman使用提示：tkpacman安装卸载软件时需要开启terminal，其指定能够开启的terminal包括xfce4-terminal、mate-terminal、konsole、vte和roxterm，这在Tools-Options里面的terminal一览可以看到，建议将runasroot栏目设为sudo，或kdesu/gksu（安装相应的工具，gnome用gksu，kde用kdesu），这样安装卸载时相对方便，不用每次都在弹出的terminal中输入root密码。（点击右边三角行选择即可。

Ctrl Shift +（加号）增大字号，Ctrl -（减号）减小字号。

---

### 本地化
#### Locale设置

编辑`/etc/locale.gen`，根据本地化需求移除对应行前面的注释符号（＃），Locale 决定了软件使用的语言、书写习惯和字符集。
示例，选择了英文（美国）、简体中文(包括utf8和gbk编码)和繁体中文（utf8）编码，去掉这些行之前前面#号：

>en_US.UTF-8 UTF-8
>zh_CN.GBK
>zh_CN.UTF-8 UTF-8
>zh_TW.UTF-8 UTF-8

保存退出后执行：
```shell
locale-gen    #部署locale
```

#### 中文显示

- 显示语言

  桌面环境的设置可能中可能有语言的相关设置，无需进行以下的locale操作。

  设置全局中文locale：
```shell
echo LANG=zh_CN.UTF-8  > /etc/locale.conf    #设置简体中文
echo LANG=zh_TW.UTF-8 > /etc/locale.conf    #设置繁体中文
```
**不过这样会导致tty下中文乱码**（如果很少在tty下使用可以无视该问题），如果单独在图形界面设置中文则可避免，可在非root用户的**家目录下**的.bashrc、.profile、.xinitrc或.xprofile中设置自己的用户环境（若文件不存在可以新建），它们的差别是：

 >.bashrc: 每次终端时读取并运用里面的设置
 >.profile：每次启动系统的读取并运用里面的配置
 >.xinitrc: 每次startx启动X界面时读取并运用里面的设置
 >.xprofile: 每次使用lightdm等图形登录管理器时读取并运用里面的设置

*不过，在wayland下，.xinitrc和.xprofile会失效。*

例如在~/.xinitrc文件中指定locale信息，写入内容如：
>export LANG=zh_CN.UTF-8
>export LANGUAGE=zh_CN:en_US
>export LC_CTYPE=en_US.UTF-8

**以上内容要写在exec语句前。**

startx时手动选择语言的一种方法
在~/.bashrc中添加：
>alias x='export LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8 && startx'
>alias xtc='export LANG=zh_TW.UTF-8 LC_CTYPE=zh_TW.UTF-8 LC_MESSAGES=zh_TW.UTF-8 && startx'
>alias xsc='export LANG=zh_CN.UTF-8 LC_CTYPE=zh_CN.UTF-8 LC_MESSAGES=zh_CN.UTF-8 && startx'

然后执行`source ~/.bashrc`，以后在从tty登录x时可以直接输入x命令则进入英文环境，如果输入xsc则进入简体中文环境，如果输入xtc则进入繁体中文环境。

如果需要临时更改locale环境可以执行`export LANG=xx`等内容，xx即是具体locale名称如zh_CN.UTF-8

更多参见[archwiki-locale](https://wiki.archlinux.org/index.php/Arch_Linux_Localization_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)s)

- 中文字体
  主要是解决中文（或者说东亚文字CJKV--中日韩越）显示情况，根据喜好选择安装，如：
```shell
pacman -S wqy-micorhei    #文泉驿微米黑
# 思源黑体 谷歌和adobe开发 中日韩均包括
pacman -S adobe-source-han-sans-otc-fonts
# 思源宋体
pacman -S adobe-source-han-serif-otc-fonts
# 谷歌中日韩字体（可以认为是思源黑体谷歌版，二者差别微小）
pacman -S noto-fonts-cjk
pacman -S ttf-arphic-uming    #文鼎明体
```

注意，安装cjk字体合集的情况下，日文字体可能优先于中文字体显示，于是会看到一些中文异体字的情况，简单的解决方法是只安装优先中文字体的包，如针对简体中文：

```shell
pacman -S adobe-source-hans-sans-cn-fonts
pacman -S adobe-source-hans-serif-cn-fonts
yaourt -S notofonts-sc
```

这些包中同样包含繁体中文日韩越字体。

#### 中文输入

中文输入法工具安装和配置。
可选择fcitx或-ibus。

- fcitx
  fcitx本体带有：拼音（主流双拼支持）、二笔、五笔（支持五笔拼音混输）、晚风、冰蟾。
```shell
pacman -S fcitx-im   #fcitx输入法
pacman -S fcitx-configtool    #图形界面的配置工具
pacman -S fcitx-cloudping    #可使用云拼音插件
pacman -S fctix-rime    #可使用rime中州韵（即小狼毫/鼠须管）引擎
pacman -S fcitx-libpinyin    #可使用智能能拼音（支持搜狗词库）
pacman -S fcitx-sogoupinyin    #可使用搜狗拼音（自带云拼音）
```
rime引擎带有注音、明月拼音、仓颉等输入法，也可以导入码表增添新的输入法。

KDM、GDM、LightDM 等显示管理器的用户，在 ~/.xprofile添加以下内容；startx 与 slim 的用户，向 ~/.xinitrc，在 exec 语句前添加以下内容（以下内容添加到.xinitrc文件中的**exec 语句之前**）：

>export GTK_IM_MODULE=fcitx
>export QT_IM_MODULE=fcitx
>export XMODIFIERS="@im=fcitx"

更多参见[archwiki-fcitx](https://wiki.archlinux.org/index.php/Fcitx_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- ibus
  使用ibus进行输入，安装如：
```shell
pacman -S ibus  ibus-qt  #ibus本体 ibus-qt保证在qt环境中使用正常
pacman -S ibus-pinyin    #拼音
pacman -S ibus-libpinyin    #可选智能拼音
pacman -S ibus-rim    #可选 rime
```

初次启用：
```shell
ibus-setup
```
参照上文所述fcitx添加方法将以下内容添加到对应位置(如~/.xprofile)：

>export GTK_IM_MODULE=ibus
>export XMODIFIERS=@im=ibus
>export QT_IM_MODULE=ibus

更多参见[archwiki-ibus](https://wiki.archlinux.org/index.php/IBus_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

注意：**如使用wayland，fcitx或ibus的三行配置需要添加/etc/environment中**方可生效。


### 设备连接
根据具体设备情况安装。
#### 触摸板

一般地，桌面用户无需安装，桌面安装时已经默认安装该组件。

```shell
pacman -S libinput
```
#### 蓝牙

一般地，桌面用户无需安装，桌面安装时已经默认安装该组件。

```shell
pacman -S bluez   #提供蓝牙协议栈
systemctl enable bluetooth    #开启自启动蓝牙服务
systemctl start bluetooth    #启动蓝牙服务
```
蓝牙仅为 lp 用户组中的用户启用 bnep0 设备。如果想要加入蓝牙系统，需确认已将用户加入该组。
```shell
usermod -aG lp user1
```
user1是要加入lp用户组的用户。

- 蓝牙控制

  一般桌面环境带有相关控制工具，无需安装。

  命令行控制：
  bluez-utils 软件包提供 bluetoothctl 工具
```shell
pacman -S bluez-utils   #安装
bluetootctl    #进入控制
#bluetootctl控制主要命令如下：
power on    #打开控制器电源 默认是关闭的
power off   #关闭电源
devices   #获取要配对设备的 MAC 地址
scan on    #启用设备发现
agent on    #打开代理
pair MAC-Address    #MAC地址可利用devices获取（支持 tab 键补全）
connect MAC_address    #命令建立连接。
```

​	图形前端
​	gnome（及其衍生的mate/cinnamon/xfce等）使用`gnome-bluetooth`。要接收文件，必须安装 `gnome-user-share` 软件包。kde桌面使用`bluedevil`。`Blueberry`可用于所有桌面环境。它提供了配置工具（blueberry）和系统托盘程序（blueberry-tray）。

```shell
pacman -S gnome-bluetooth gnome-user-share
pacman -S bluedevil
pacman -S blueberry
# 如果要使用蓝牙耳机/音响 可能需要
pacman -S pulseaudio-bluetooth bluez-firmware
```

#### NTFS分区
有时候希望从linux上读写windows分区的文件。
- 手动挂载
```shell
pacman -S ntfs-3g    #安装用于挂载ntfs的工具
mkdir /mnt/ntfs    #在/mnt下创建一个名为ntfs挂载点
cfdisk    #查看要挂载的ntfs分区 假如此ntfs分区为/dev/sda5
ntfs-3g /dev/sda5 /mnt/ntfs    #挂载分区
```
为了使用方便可以在~/.bashrc中写入一条此命令的别名，编辑~/.bashrc，添加：
> alias win='ntfs-3g /dev/sda5 /mnt/ntfs

执行
```shell
source ~/.bashrc    #立即生效
以后想要挂载ntfs分区时只需执行win即可
win    #挂载磁盘
```

- 开机自动挂载
  编辑/etc/fstab，写入（假设cfdisk查看得ntfs分区是/dev/sda5）:
>/dev/sda5 /mnt/windows ntfs-3g uid=username,gid=users 0 0

​	其中的username是用户名，users是用户组。


#### U盘和MTP
为了自动挂载U盘和MTP设备（如手机），安装（桌面环境中一般无需安装）。

- 使用 udiskie udevil 和libmtp

```shell
pacman -S udiskie udevil
systemctl enable devmon@username.service    #username是用户名
pacman -S libmtp
```
​	在/media目录下即可看到挂载的移动设备
[更多参考](https://wiki.archlinux.org/index.php/Udisks_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- 使用gvfs gvfs-mtp

```shell
pacman -S gvfs    #可自动挂载u盘 在文件管理器中看到
pacman -S gvfs-mtp    #识别mtp设备
```

---
基础系统、基本软件和重要配置差不多完成了。此时可以重启了。

接上文提示：
如果使用多系统，安装了os-prober，**重启后务必再系统重启后执行一次**：
```shell
grub-mkconfig -o /boot/grub/grub.cfg
```
以找到其他系统（尤其是windows），下次重启就能在grub里看到其他系统了。

# 其他配置(问题解决)

## 选择grub为第一启动项

**开机直接进入了windows**
因为windows的引导程序bootloader并不会将linux启动项加入到启动选择中，且windows的引导程序处于硬盘启动的默认项。
进入BIOS，找到启动设置，**将硬盘启动的默认启动项改为grub（一般BIOS中按f5上调选项，f10保存）**。

## 无法启动图形界面

可能是

- 没有安装显卡驱动（双显卡用户需安装两个驱动）
- 没有正确安装图形界面（参看前文）
- 没有自启动图形管理器或xinintrc书写错误

## 非root用户（普通用户）无法启动startx

重装一次xorg-server

## 关闭windows快速启动

**windows快速启动导致无法进入Linux**。

**windows开启了快速启动可能导致linux下无法挂载**，提示如
>The disk contains an unclean file system (0, 0).
>Metadata kept in Windows cache, refused to mount.

等内容。需要在windows里面的 电源选项管理 > 系统设置 > 当电源键按下时做什么， 去掉勾选启用快速启动。
或者直接在cmd中运行：`powercfg /h off`。

## 高分辨率（HIDPI）屏幕字体过小

参考[archwiki-hidpi](https://wiki.archlinux.org/index.php/HiDPI)

使用高分辨时显示文字过小，可以通过桌面的设置进行调节，具体参照相应桌面环境的相关资料。
使用窗口管理器的用户也可以自行通过配置文件设置dpi。

编辑~/.Xresources（如没有此文件则添加之）,写入：
>Xft.dpi: 120
>Xft.autohint: 0
>Xft.lcdfilter: lcddefault
>Xft.hintstyle: hintfull
>Xft.hinting: 1
>Xft.antialias: 1
>Xft.rgba: rgb

其中第一行的xft.dpi:后的数字是要设置的dpi，根据实际情况填写。

然后在~/.xinitrc中写入：
>xrdb ~/.Xresource

注意写在exec语句之前。

附：DPI=(横向象素^2+纵向象素^2)^0.5/设备尺寸
其实就是勾股定理求出斜边再除以尺寸。
如：(1920^2+1080^2)^0.5/14=157（约等）。根据个人在DPI默认设为的1366*768的屏幕使用经验来看（字号一般设定的12），1920×1080的14寸屏幕dpi在120-130比较合适(字号设定的12)，当然要具体结合个人喜好调整。

## 蜂鸣声（beep/错误提示音）
去除按键错误时、按下tab扩展时、锁屏/注销等出现的“哔～”警告声。参照[archwiki-speaker](https://wiki.archlinux.org/index.php/PC_speaker)
（su或sudo模式）执行：
```shell
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
```
## 带Nvidia显卡的双显卡管理

参看相关资料：

- linux上的[英伟达NVIDIA](https://wiki.archlinux.org/index.php/NVIDIA_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
- [NVIDIA optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))技术
- 使用[bumblebee](https://wiki.archlinux.org/index.php/Bumblebee_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))切换双显卡（集成显卡和NVIDIA）
- 使用[prime](https://wiki.archlinux.org/index.php/PRIME_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29)动态切换显卡

这里使用bumblebee方案。

### bumblebee管理NVIDIA
bumblebee使用Optimus，使独立显卡按需渲染，并传输给集成显卡，集成显卡则负责显示功能。
bumblebee实现了：
利用独立显卡渲染程序，并通过集成显卡将图像显示在屏幕上（利用了 VirtualGL 或 primus 实现），相当于连接到了一个供独立显卡使用的 X 服务器。
独立显卡空闲的时候会被禁用。(利用bbswitch）

- 安装配置bumblee
  安装显卡驱动和bumblee等工具：
```shell
pacman -S bumblebee mesa xf86-video-intel nvidia bbswitch
pacman -S nvidia-settings   #可选 设置工具
gpasswd -a username bumblebee # 将当前用户添加到bumblee组
# 启用bumblebee服务 注意末尾有个d
systemctl start bumblebeed && systemctl enable bumblebeed
```
​	此处的username是指当前的用户名。

- 测试 Bumblebee 是否支持当前Optimus 系统
```shell
optirun glxgears -info    #执行后会出现测试图像
optirun glxspheres64    #如果上一条不起作用执行着一条
optirun glxspheres32    #如果是32位用户执行这一条
```
- 使用optimus让nvidia显卡渲染程序
  启动方法：
```shell
# optirun program-name
optirun 0ad   #运行0ad（一款3d基于历史的即时策略游戏）
```
- 打开nvidia控制面板（需安装nvidia-settings)
```shell
optirun -b none nvidia-settings -c :8
```

- bbswitch配置
  bbswitch会自动关闭 bumblebee 不再使用的 NVIDIA 显卡（当NVIDIA显卡未用于渲染任何程序时），**无须任何配置**。

  关机时启用NVIDIA显卡以确保重启后显卡正常工作，编辑/etc/systemd/system/nvidia-enable.service，添加如下内容：

>[Unit]
>Description=Enable NVIDIA card
>DefaultDependencies=no
>[Service]
>Type=oneshot
>ExecStart=/bin/sh -c 'echo ON > /proc/acpi/bbswitch'
>[Install]
>WantedBy=shutdown.target


然后以root权限运行：
```shell
systemctl enable nvidia-enable.service
```
以启用服务。 

检查nvidia显卡状态：
```shell
lspci | grep NVIDIA
```
如果看到有NVIDIA一行文字末尾括号中有**rev ff**字样，则表示NVIDIA显卡已经关闭。


## 科学上网
- hosts
  更改/etc/hosts文件。一个[github上的hosts项目](https://github.com/racaljk/hosts)，复制粘贴比较麻烦，执行：
```shell
sudo wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O /etc/hosts
```
即可更新。
不过每次输入一串命令也挺麻烦，快速更新hosts方法：
```shell
echo "alias hosts='sudo wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O etc/hosts'"  >> ~/.bashrc
source ~/.bashrc
```
以后只要执行`hosts`命令即可更新hosts内容。
注：进入谷歌搜索请使用[https://www.google.com/ncr](https://www.google.com/ncr)这个地址。
- shadowsocks
   - shadowsocks #shadowsocks简称ss
   - shadowsocks-qt5 #图形化ss前端
   - proxychains #可选 命令行使用的代理工具
     ss本身无法全局代理，需借助其他工具实现，比如有的桌面的设置里可以设置全局，也可以使用linux的iptables设置（不过略显麻烦），但是全局后，一些不需要代理联网的程序的联网速度会略差，最好是针对需要的软件单独代理，有的程序本身可以设置（如一些下载工具），有的程序只能借助其他的工具代理，下面介绍proxchains+ss对指定程序进行代理。
     浏览器可能需要插件才能设置代理，详见[archwiki-shadowsokcs](https://wiki.archlinux.org/index.php/Shadowsocks_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
     proxychains设置：
     在/etc/proxychains.conf文件添加：
>socks5 127.0.0.1 8080
>保存后即可使用。（shadowsock的设置里的local ip和local port也要设置成同proxychians中一致，如上文的127.0.0.1和1080）
>proxychains使用示例：
>确保ss正确开启。
```shell
proxychains chromium #使用proxychains+程序名
proxychains yaourt -Syua #proxychains+命令亦可
proxychians wget https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png
```
- 其他方法：如openvpn,xx-net,goagent等等。

## 内存盘tmpfs
简单地来说就是将内存当作一块磁盘用于读写，代替磁盘接管那些要频繁读写的文件夹，如tmp目录。使用tmps，优点是内存读写速度更快，可以一定程度减少磁盘读写，且tmpfs是缺点是内存断电不会存储信息。具体原理和使用可再互联网进行搜索，相关资料很多。

自行设置tmpfs还是比较繁琐的，所幸archlinux安装完成后，其实已经默认创建了几个tmpfs挂载点，可执行`df -h 查看。

浏览器使用相对频繁，这里简单地展示firefox和chromium的tmpfs设置：
- firefox
  在地址栏中输入 about:config 后回车，然后点击右键新建一个 String ， name 为 browser.cache.disk.parent_directory ， value 为 /dev/shm/firefox

- Chromium/Chrome
  只需要在起图标属性里加一个参数"– -disk-cache-dir="/dev/shm/chromium/" 。
  找到Chrmium（或Chrmoe）程序图标所在位置，如：/usr/share/applications/chromium.desktop"（具体路径根据实际情况），将该图标的属性中的执行命令改为"/usr/bin/chromium – -disk-cache-dir="/dev/shm/chrome/"

重启浏览器后，其目录将会启用，可以到/dev/shm/目录下看看是否存在。

## win+linux双系统时间设置

Windows使用本地时间（Localtime），而Linux则使用UTC（Coordinated Universal Time ，世界协调时）时间，虽然linux也可以设置成localetime，但是会造成一些程序始终使用UTC，带来许多麻烦。
协调方法无非是：
1.让二者都使用UTC
2. 让二者都使用localtime 
3. 在linux里使用错误的时区（linux对照windows时间基准调整时区）

推荐第一种。这里使用更改windows注册表的方法是windows使用utc时间。
新建一个空白文档 utc.reg（后缀是reg），写入：
```reg
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation]
"RealTimeIsUniversal"=dword:00000001
```
保存后，双击该文件运行，以写入注册表。
windows调整为正确时间后，在BIOS中根据当地所用的标准时间来设置正确的UTC时间（北京时间是东八区时间，将BIOS时间向前调整8小时）。

Linux中即可放心地设置使用UTC时间了。
## wayland

wayland不会读取.xprofile和xinitrc等xorg的环境变量配置文件，如上文的fcitx中所示，某些软件需要在全局变量的配置文件中进行相应的配置。

对全局变量来说是，其配置文件是/etc/profile、 /etc/bash.bashrc 和`/etc/environment，每个文件都有不同的限制，请根据需要选择要使用的文件：

> /etc/profile **仅**初始化登陆 shell 的环境变量。它可以执行脚本并支持 [Bash ](https://en.wikipedia.org/wiki/Bourne_shell)兼容 Shell。
>
> /etc/bash.bashrc **仅**初始化交互 shell，它也可以执行脚本但是只支持 Bash。
>
> /etc/environment 被 PAM-env 模块使用，和登陆与否，交互与否，Bash与否无关，所以无法使用脚本或通配符展开。仅接受 `*variable=value*` 格式。

参考[archwiki-wayland](https://wiki.archlinux.org/index.php/Wayland)、[archwiki-环境变量](https://wiki.archlinux.org/index.php/Environment_variables_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.AE.9A.E4.B9.89.E5.8F.98.E9.87.8F)和[wayland主页](https://wayland.freedesktop.org/)

## 笔记本电源管理

- [tlp](https://wiki.archlinux.org/index.php/TLP)
- [laptop mode tools](https://wiki.archlinux.org/index.php/Laptop_Mode_Tools_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
- [powertop](https://wiki.archlinux.org/index.php/Powertop)

# 常用软件

软件只列出包名，使用pacman或yaourt(如果pacman -Ss查询不到此软件时使用之）安装，包名可能有错误，最好使用yaourt查找软件关键字确定包名。
参见

- [软件列表](https://wiki.archlinux.org/index.php/List_of_applications_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
- [我的软件列表](../我的软件列表.md)
- [gnome配置](../gnome配置.md)