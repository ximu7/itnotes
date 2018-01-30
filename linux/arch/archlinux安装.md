[TOC]

# 准备工作

## 工具和必要技能

- 划分一定量的磁盘空间用于linux安装（推荐至少30G）

- **在bios设置中关闭启设置中的安全启动**（如有没有该设置则略过，对archlinux使用安全启动可参考[archwiki-Secure Boot](https://wiki.archlinux.org/index.php/Secure_Boot_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)))

- 互联网（安装需要联网）

- U盘（使用u盘安装方便许多）

- [Arch Linux 系统镜像](https://www.archlinux.org/download/)（在该页面根据国家和地区选择网站，下载**.iso**文件）

- nano或vim基本操作技能（安装过程中编辑配置文件）

- 启动盘制作工具（制作启动盘）

  - 如果设备支持UEFI，直接将下载的系统镜像文件（解压或挂载到虚拟光驱后）的内容复制的U盘根目录即可。（建议）

  - windows下可使用[usbwriter](https://sourceforge.net/projects/usbwriter/)、[poweriso](http://www.poweriso.com)、[winsetupfromusb](http://www.winsetupfromusb.com/)等工具。

  - Linux/OSX下可使用dd命令。示例：

    ```shell
    dd if=/path/arch.iso of=/dev/sdb bs=10M
    ```
    `/path/arch.iso`是archlinux的ISO文件的路径，`sdx`是U盘的设备编号如sda、sdb、sdc等（可插上优盘后在终端用`df -h`命令查看），`10M`是读写块的大小（默认512b）。

---

插上U盘启动盘，使用USB启动（不同设备方法不同），计算机载入U盘上的系统后，回车选择**第一项**（默认）进入，等待一切载入完毕……

## 分区和挂载

可以先使用`lsblk`查看所有硬盘情况，使用`fdisk -l /dev/sda`查看硬盘a的情况（硬盘b则为`/dev/sdb` ），确定系统安装位置。

分区工具`cfdisk`的简单使用：

- 查看整个磁盘的情况 `cfdisk /dev/sda` （第二块硬盘则是`cfdisk /dev/sdb` ）
- 利用箭头进行上下左右移动，选中项会高亮显示，回车键确定操作。
- `New`用于新建分区，输入新建分区的大小并回车，建立了一个分区。
- `Delete`删除当前选中的分区。
- `Type`选择分区类型。
- `Write`用于保存操作。
- `quit`退出（直接输入`q`亦可）。

如果硬盘未进行划分，执行cfdisk即会提示选择分区方式，如今[建议使用GPT](https://wiki.archlinux.org/index.php/Partitioning_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E9.80.89.E6.8B.A9GPT_.E8.BF.98.E6.98.AF_MBR) 。以下基于GPT+UEFI叙述创建分区（MBR在其中亦有说明）。

---

### 分区建立和格式化

- [EFI系统分区](https://wiki.archlinux.org/index.php/EFI_System_Partition_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))（又称为esp，以下均以esp称呼）

  GPT使用esp引导系统，在linux中将esp挂在的`/boot` ，linux的启动文件置于该分区中。

  - 如果不存在esp，创建一个**类型为`EFI system`的分区**（以下假设esp使用`/dev/sda1`） ，并对其格式化：

    ```shell
    mkfs.vfat /dev/sda1    #1. 格式化esp
    ```

  - 如果已经存在一个esp（例如已经有一个Windows系统，且打算保留），则不要对其进行格式化，否则造成其他系统无法启动。


- 其他分区

  - 使用`cfdisk`新建**root分区**（推荐20G以上，假设为`/dev/sda2`）home分区（最好单独分区,假设为`/dev/sda3`）和swap分区（可选，假设为`/dev/sda4`）等，然后格式化各个分区：

    ```shell
      mkfs.ext4 /dev/sda2    #格式化root
      mkfs.ext4 /dev/sda3    #格式化home
      mkswap /dev/sda4       #格式话swap
    ```

  - LVM分区法

      这里使用lvm，将root、home和swap均放置到一个卷组（vg）中。（LVM相关查看[archwiki:lvm](https://wiki.archlinux.org/index.php/LVM_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))）

      先用`cfdisk`建立一个分区（假设为`/dev/sda2` ），再**建立物理卷->建立卷组->建立逻辑卷**->格式化逻辑卷：

    ```shell
      #1.建立物理卷：在 /dev/sda2建立物理卷
      pvcreate /dev/sda2
      #2.建立卷组：新建名为linux的卷组并将sda2加入到卷组中
      vgcreate linux /dev/sda2
      #3.建立逻辑卷：在linux卷组中建立root、swap和home逻辑卷
      lvcreate -L 30G linux -n root
      lvcreate -L 4G linux -n swap
      lvcreate -L 100G linux -n home
      # lvcreate -l +100%FREE linux -n home  #3.2.1  用linux卷组中所有剩余空间建立home逻辑卷

      mkfs.ext4 /dev/mapper/Linux-root    #格式化root
      mkfs.ext4 /dev/mapper/Linux-home    #格式化home
      mkswap /dev/mapper/Linux-swap       #格式化swap
    ```


### 分区挂载

- 一般分区法
```shell
mount /dev/sda2 /mnt         #挂载root分区
mkdir /mnt/boot /mnt/home    #建立boot和home挂载点
mount /dev/sda1 /mnt/boot    #挂载esp到/boot
mount /dev/sda3 /mnt/home    #挂载home分区到/home
swapon /dev/sda4        #激活swap
```

- lvm分区法

```shell
mount /dev/mapper/linux-root /mnt    #挂载root分区
mkdir /mnt/boot /mnt/home    #建立boot和home挂载点
mount /dev/sda1 /mnt/boot    #挂载esp到/boot
mount /dev/mapper/linux-home /mnt/home    #挂载home逻辑卷到/home
swapon /dev/mapper/linux-swap    #激活swap
```
# 基础安装

以下安装过程中遇到需要选择的地方，如不清楚如何选择，可直接回车。

## 配置镜像源

在安装前最好选择较快的镜像，以加快下载速度。
编辑` /etc/pacman.d/mirrorlist`，选择首选源（按所处国家地区关键字索搜选择，如搜索china），将其添加到文件开头，保存并退出。一些中国地区镜像源如：

```
Server = https://mirrors.ustc.edu.cn/archlinux/repo/os/arch
Server = https://mirrors.163.com/archlinux/repo/os/arch
```

## 连接网络

```shell
dhcpcd    #有线网络
wifi-menu    #无线网络 执行后会扫描网络 选择网络并连接即可
ping -c 5 z.cn  #可先测试连接情况
```

## 安装基础系统

```shell
pacstrap /mnt base base-devel
```
## 建立fstab文件

```shell
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab    # 检查生成的 /mnt/etc/fstab 文件是否正确
```
## 进入系统

```shell
arch-chroot /mnt
```

## 激活lvm2钩子

**使用了lvm安装，需要执行该步骤**，否则跳过。

编辑/etc/mkinitcpio.conf文件，找到类似字样：

>HOOKS="base udev autodetect modconf block  filesystems keyboard fsck"

在block 和 filesystems之间添加**`lvm2`**（注意lvm2和block及filesystems之间有一个空格），类似：

> HOOKS="base udev autodetect modconf block lvm2 filesystems keyboard fsck"

再执行：
```shell
mkinitcpio -p linux
```

## 用户管理

- 用户和密码
```shell
passwd     #设置或更改root用户密码  接着输入两次密码（密码不会显示出来）
useradd -m -g users -s /bin/bash user1    #添加新普通用户  user1是新建的用户名
passwd user1    #设置或更改user1用户密码 接着输入两次密码
```

- sudo用户


```shell
chmod u+w /etc/sudoers
echo  'user1 ALL=(ALL) ALL' >> /etc/sudoers    #将user1加入sudo
```
## 设置时区

windows用户还需**参考后文[windows和linux统一使用UTC](#windows和linux统一使用UTC)** 。
```shell
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime    # 设置时区 示例为中国东八区标准时间--Asia/Shanghai
hwclock --systohc --utc     #使用utc时间 推荐
```
## 主机名

```shell
echo MyPC > /etc/hostname
```
MyPC是要设置的主机名。

## 网络配置

```shell
systemctl enable dhcpcd    #开机自启动有线网络  当然也可以手动执行 dhcpcd 连接
pacman -S iw wpa_supplicant dialog    #无线网络需要安装这些工具
```

参看[网络配置](https://wiki.archlinux.org/index.php/Network_configuration_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))了解更多。

注意：linux自带的`linux-frimware`已经支持大多数驱动，如果某些设置不能使用，参看[archwiki:网络驱动](https://wiki.archlinux.org/index.php/Wireless_network_configuration_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.AE.89.E8.A3.85_driver.2Ffirmware)

## 系统引导

```shell
#安装引导程序 grub 和 efi管理工具
pacman -S grub efibootmgr --noconfirm
# 如安装有多系统 需安装 os-prober
pacman -S os-prober
# 安装引导  使用了efi的情况
grub-install --efi-directory=/boot --bootloader-id=grub
# 生成引导配置
grub-mkconfig -o /boot/grub/grub.cfg
```

**注意**：os-prober可能需要在系统安装完毕后，**重启**进入系统**再次执行**生成**引导配置命令**就能检测到其他系统。

至此基础的系统安装完成，可以连续按两次`ctrl`+`d` ，输入`reboot`重启并拔出u盘。

提醒：如果使用多系统，安装了os-prober，**重启后再后执行一次**：

```shell
grub-mkconfig -o /boot/grub/grub.cfg
```

如果双系统用户直接进入了Windows系统，可参看[选择grub为第一启动项](#选择grub为第一启动项) 。



# 系统配置

## 图形界面

### 显卡驱动

首先需要了解设备的显卡信息，也可是使用`lspci | grep VGA`查看。根据显卡情况安装驱动：

```shell
pacman -S xf86-video-vesa     #通用显卡
pacman -S xf86-video-intel     #intel集成显卡
pacman -S xf86-video-ati        #amd/ati
pacman -S nvidia                       #nvidia
```
双显卡设备，可参看后文[双显卡管理](#双显卡管理)。

### 桌面环境/窗口管理器

安装一个[桌面环境](https://wiki.archlinux.org/index.php/Desktop_environment_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))或者[窗口管理器](https://wiki.archlinux.org/index.php/Window_manager_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))。

- 桌面环境，如[Plasma](https://wiki.archlinux.org/index.php/KDE_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))或者[Gnome](https://wiki.archlinux.org/index.php/GNOME_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))：

```shell
pacman -S plasma sddm --noconfirm && systemctl enable sddm
pacman -S gnome gdm --noconfirm && systemctl enable gdm
```
- 窗口管理器，如[i3wm](https://wiki.archlinux.org/index.php/I3_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))或[openbox](https://wiki.archlinux.org/index.php/Openbox_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

```shell
pacman -S xorg-server xorg-xinit  --noconfirm    #安装窗口管理器也必须安装这两个包
pacman -S i3
pacman -S awesome
```

窗口管理还需要自行配置[显示管理器](https://wiki.archlinux.org/index.php/Display_manager_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))和[xinitrc](https://wiki.archlinux.org/index.php/Xinitrc_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

### 字体

参看[archwiki:fonts](https://wiki.archlinux.org/index.php/Fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))选择安装字体。

- 终端等宽字体，如`ttf-dejavu`
- 数学和符号字体，如`ttf-symbola`（包含emoji表情，emoji也可安装`noto-fonts-emoji` ）
- 中文字体参看下文[中文显示](#中文显示)。

### 中文本地化

参看[ArchLinux中文本地化](https://wiki.archlinux.org/index.php/Arch_Linux_Localization_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- Locale设置

编辑`/etc/locale.gen`，根据本地化需求移除对应行前面的注释符号（＃），[Locale](https://wiki.archlinux.org/index.php/Locale_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)) 决定了可使用的语言、书写习惯和字符集。以中文用户常用locale为例，选择英文（美国）UTF-8、简体中文GBK、简体中文UTF-8和繁体中文UTF-8，去掉这些行之前前面#号：

```shell
en_US.UTF-8 UTF-8
zh_CN.GBK
zh_CN.UTF-8 UTF-8
zh_TW.UTF-8 UTF-8
```

保存退出后执行：

```shell
locale-gen
```

#### 中文显示

安装中文字体如：

```shell
pacman -S wqy-micorhei    #文泉驿微米黑
pacman -S adobe-source-han-sans-cn-fonts    # 思源黑体
pacman -S ttf-arphic-uming    #文鼎明体
```

更多字体参看[中日韩越字体](https://wiki.archlinux.org/index.php/Fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E4.B8.AD.E6.97.A5.E9.9F.A9.E8.B6.8A.E6.96.87.E5.AD.97) ，中文显示异体字形参看该文的[修正简体中文显示为异体（日文）字形](https://wiki.archlinux.org/index.php/Arch_Linux_Localization_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E4.B8.AD.E6.96.87.E5.AD.97.E4.BD.93) 。

#### 中文输入

可选择[fcitx](https://wiki.archlinux.org/index.php/Fcitx_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))或[ibus](https://wiki.archlinux.org/index.php/IBus_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))。

- fcitx本体带有：拼音（主流双拼支持）、二笔、五笔（支持五笔拼音混输）等，

```shell
pacman -S fcitx  fcitx-im fcitx-configtool     #安装fcitx

pacman -S fcitx-cloudping        #云拼音插件（推荐拼音用户安装）
pacman -S fctix-rime                    #rime中州韵（即小狼毫/鼠须管）引擎
pacman -S fcitx-libpinyin           #智能拼音（支持搜狗词库）
pacman -S fcitx-sogoupinyin    #可使用搜狗拼音（自带云拼音）
```

环境变量设置：在`/etc/environment`添加

> export GTK_IM_MODULE=fcitx
>
> export QT_IM_MODULE=fcitx
>
> export XMODIFIERS="@im=fcitx"

- ibus

```shell
pacman -S ibus  ibus-qt        #ibus本体 ibus-qt保证在qt环境中使用正常
pacman -S ibus-pinyin         #拼音
pacman -S ibus-libpinyin    #智能拼音（支持搜狗词库）
pacman -S ibus-rim               #rime
```

初次启用：

```shell
ibus-setup
```

环境变量设置：在`/etc/environment`添加：

> export GTK_IM_MODULE=ibus
>
> export XMODIFIERS=@im=ibus
>
> export QT_IM_MODULE=ibus

## 声音

**桌面环境用户可略过**。

窗口管理器用户可以安装`alsa-utils`管理声音，安装该包后笔记本可以使用相应的快捷键进行控制。更多信息查看[ALSA安装设置](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

```shell
pacman -S alsa-utils
alsamixer    #安装上一个包后可使用该命令控制声音设备
```

## 软件包管理器

###pacman

更多信息查看[archwiki:pacman]((https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- 常用命令
```shell
pacman -Syu    #升级整个系统
pacman -S name    #安装软件
pacman -Ss words    #查询有某关键字的软件 words即是要查询的关键字
pacman -R name    #移除某软件但不移除其依赖
pacman -Qi name   #查看已经安装的某软件的信息
```


- pacman 设置
  配置文件在`/etc/pacman.conf`，编辑该文件：

  - 彩色输出：取消`#Color`中的#号。

  - 升级前对比版本：取消`#VerbosePkgLists`中的#号。

  - 社区镜像源：在末尾添加相应的源，[中国地区社区源archlinuxcn](https://github.com/archlinuxcn/mirrorlist-repo)

    例如添加archlinuxcn.org的源

    > [archlinuxcn]
    >
    > SigLevel = Optional TrustedOnly
    >
    > Server = http://repo.archlinuxcn.org/$arch

    添加完后执行： `pacman -Syu archlinuxcn-keyring`。

### AUR和yaourt

AUR(Arch User Repository）是为用户而建、由用户主导的Arch软件仓库。aur软件可以通过yaourt等辅助管理器搜索、下载和安装，或者从[aur.archlinux.org](https：//aur.archlinux.org)中搜索下载，用户自己通过makepkg生成包，再由pacman安装。

- aur工具yaourt
```
pacman -Syu yaourt
```
注：**yaourt前不能使用sudo，root用户也不能使用yaourt** ，卸载软件依然使用pacman相关命令。yaourt基本命令：

```shell
yaourt words    #搜索关键字 words是要搜索的关键字
yaourt -Syua    #更新整个系统
yaourt -S name    #安装软件
yaourt -Qdt    #查找孤儿包
```
此外可使用 [pacman图形化的前端工具](https://wiki.archlinux.org/index.php/Graphical_pacman_frontends_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))，如tkpacman：

```shell
yaourt -S tkpacman vte
```

## 设备连接

### 触摸板

**桌面用户无需安装**，窗口管理器用户安装：

```shell
pacman -S xf86-input-synaptics
```
### 蓝牙

**桌面用户忽略该小节**。窗口管理器用户：

```shell
pacman -S bluez
systemctl enable bluetooth
usermod -aG lp user1    #user1是当前用户名
```
蓝牙控制：命令行控制安装`bluez-utils`，使用参考[通过命令行工具配置蓝牙](https://wiki.archlinux.org/index.php/Bluetooth_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E9.80.9A.E8.BF.87.E5.91.BD.E4.BB.A4.E8.A1.8C.E5.B7.A5.E5.85.B7.E9.85.8D.E7.BD.AE.E8.93.9D.E7.89.99)；或者安装[蓝牙图形界面工具]((https://wiki.archlinux.org/index.php/Bluetooth_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.9B.BE.E5.BD.A2.E5.8C.96.E5.89.8D.E7.AB.AF))如`blueberry`。

### NTFS分区

桌面环境的文件管理器一般都能读取NTFS分区的内容，但不一定能能够写入。可使用`ntfs-3g`挂载：

```shell
pacman -S ntfs-3g       #安装
mkdir /mnt/ntfs          #在/mnt下创建一个名为ntfs挂载点
lsblk                                 #查看要挂载的ntfs分区 假如此ntfs分区为/dev/sda5
ntfs-3g /dev/sda5 /mnt/ntfs       #挂载分区
```
### U盘和MTP设备

桌面环境一般能自动挂载。窗口管理器用户：

- 使用[udisk](https://wiki.archlinux.org/index.php/Udisks_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))和libmtp

```shell
pacman -S udiskie udevil
systemctl enable devmon@username.service    #username是用户名
pacman -S libmtp
```
​	在/media目录下即可看到挂载的移动设备。

- 使用gvfs gvfs-mtp（xfce、lxde等桌面如果不能挂在mtp，也可安装`gvfs-mtp` ）

```shell
pacman -S gvfs    #可自动挂载u盘
pacman -S gvfs-mtp    #可自动挂载mtp设备
```

# 其他配置(问题解决)

## 选择grub为第一启动项

安装系统后重启，**直接进入了windows** ，因为windows的引导程序bootloader并不会将linux启动项加入到启动选择中，且windows的引导程序处于硬盘启动的默认项。
进入BIOS，找到启动设置，**将硬盘启动的默认启动项改为grub（一般BIOS中按f5上调选项，f10保存）**。

## 无法启动图形界面

参看前文[图形界面](#图形界面) 。原因可能是：

- 没有安装显卡驱动（双显卡用户需安装两个驱动）
- 没有正确安装图形界面
- 没有自启动图形管理器或xinintrc书写错误

## 非root用户（普通用户）无法启动startx

重装一次`xorg-server`

## 关闭windows快速启动

**windows快速启动导致无法进入Linux**。**windows开启了快速启动可能导致linux下无法挂载**，提示如

>The disk contains an unclean file system (0, 0).
>Metadata kept in Windows cache, refused to mount.

等内容。需要在windows里面的 电源选项管理 > 系统设置 > 当电源键按下时做什么， 去掉勾选启用快速启动。
或者直接在cmd中运行：`powercfg /h off`。

## 高分辨率（HIDPI）屏幕字体过小

桌面环境设置中可调整。参考[archwiki-hidpi](https://wiki.archlinux.org/index.php/HiDPI)

## 蜂鸣声（beep/错误提示音）
去除按键错误时、按下tab扩展时、锁屏/注销等出现的“哔～”警告声。参考[archwiki-speaker](https://wiki.archlinux.org/index.php/PC_speaker)
```shell
rmmod pcspkr    #暂时关闭
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf   #直接屏蔽
```
## 双显卡管理

如果不需要运行大量耗费GPU资源的程序，可以禁用独立显卡，只使用核心显卡。

可执行以下命令关闭独立显卡：

```shell
su    #必须切换到root用户才能执行下一条命令
echo OFF > /sys/kernel/debug/vgaswitcheroo/switch  #注意，如果使用了bbswtich那么应该是没有这个文件的！
```
或者屏蔽独立显卡相关模块，如nvidia设备执行：

```shell
lsmod | grep nvidia | cut -d ' ' -f 1 > /tmp/nvidia
lsmod | grep  nouveau | cut -d ' ' -f 1 > > /tmp/nvidia
sort -n /tmp/nvidia | uniq >  /tmp/nvidia.conf#去重
sed -i 's/^\w*$/blacklist &/g' /tmp/nvidia.conf  #添加blacklist
sudo cp /tmp/nvidia.conf /etc/modprobe.d/nvidia.conf  #移动
```

重启后，`lspci |grep NVIDIA`检查NVIDIA开启情况。如果输出内容后面的括号中出现了` (rev ff)` 字样则表示该显卡已关闭。



在Linux中可使用以下方法来切换显卡。参看相关资料：

- [prime](https://wiki.archlinux.org/index.php/PRIME_%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29)（NVIDIA和ATI均支持）
- [NVIDIA optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))（NVIDIA的方案，这里主要推荐以下两个）
  - [bumblebee](https://wiki.archlinux.org/index.php/Bumblebee_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
  - [nvidia-xrun](https://github.com/Witko/nvidia-xrun)（该方案支持Vulkan接口）

## 科学上网

- hosts：在`/etc/hosts`文件中加入hosts内容即可，可参考[googelhosts](https://github.com/googlehosts/hosts) 。

  ```shell
  echo "alias hosts='sudo wget https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts'"  >> ~/.bashrc  && source ~/.bashrc
  ```

  执行`hosts`即可从指定网址更新。

- lantern：安装`lantern`

- [shadowsocks项目](https://github.com/shadowsocks)
  - [archwiki:shadowsock(简体中文)](https://wiki.archlinux.org/index.php/Shadowsocks_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

  - socks代理 — proxychains

    配置：编辑/etc/proxychains.conf文件，设置`socks5 127.0.0.1 1080` 。

    使用：`proxychains [命令或者程序名]`

## SSD固态硬盘相关

参看：[Solid State Drives](https://wiki.archlinux.org/index.php/Solid_State_Drives_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))和[ssd固态硬盘优化](../ssd固态硬盘优化.md)

## windows和linux统一使用UTC

Windows使用本地时间（Localtime），而Linux则使用UTC（Coordinated Universal Time ，世界协调时），更改windows注册表使windows也使用utc时间。
1. 在windwos新建文件`utc.reg`，写入：

```reg
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation]
"RealTimeIsUniversal"=dword:00000001
```
保存后，双击该文件运行，以写入注册表。

2. windows调整为正确时间后，重启系统，在BIOS中根据当地所用的标准时间来设置正确的UTC时间。（例如在中国使用的北京时间是东八区时间，根据当前北京时间，将BIOS时间前调8小时）。

## wayland

wayland不会读取.xprofile和xinitrc等xorg的环境变量配置文件，故而不要将某些软件的相关设置写入到上诉文件中，可写入/etc/profile、 /etc/bash.bashrc 和/etc/environment。参考[archwiki-wayland](https://wiki.archlinux.org/index.php/Wayland)、[archwiki-环境变量](https://wiki.archlinux.org/index.php/Environment_variables_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.AE.9A.E4.B9.89.E5.8F.98.E9.87.8F)和[wayland主页](https://wayland.freedesktop.org/)

## 笔记本电源管理

参看[laptop笔记本相关](../laptop笔记本相关.md)

# 常用软件

参考看：[archwiki:软件列表](https://wiki.archlinux.org/index.php/List_of_applications_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))、[awesome linux softwares](https://github.com/LewisVo/Awesome-Linux-Software)、[我的软件列表](../我的软件列表.md)、[gnome配置](../gnome配置.md)……