#!/bin/bash
# 编辑/etc/mkinitcpio.conf文件，找到类似字样：
# HOOKS="base udev ... block  filesystems"
# 在block 和 filesystems之间添加lvm2（注意lvm2和block及filesystems之间有一个空格），保存退出。
# 更改了vkinitcpio.conf文件，需生成initramfs，执行：
# mkinitcpio -p linux

echo "添加中国地区的arch源"
echo -e "Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch\nServer = http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch\nServer = http://mirrors.163.com/archlinux/$repo/os/$arch\n" > /etc/pacman.d/mirrorlist

echo "安装基础系统"
pacstrap /mnt base base-devel

echo "生成fstab"
echo "" > /mnt/etc/fstab
genfstab -U /mnt >> /mnt/etc/fstab

echo "进入arch-chroot"
arch-chroot /mnt /bin/bash

echo "安装grub引导"
pacman -Syu efibootmgr grub os-prober  --noconfirm
grub-install --efi-directory=/boot --bootloader-id=Grub
grub-mkconfig -o /boot/grub/grub.cfg

echo "安装联网工具"
pacman -S networkmanager  --noconfirm
systemctl start NetworkManager

echo "安装显卡驱动"
pacman -S xf86-video-intel --noconfirm

pacman -S nvidia bbswitch bumblebee --noconfirm
gpasswd -a username bumblebee
systemctl enable bumblebeed

echo "设置AUR源并安装yaourt"
echo -e "Color\nVerbosePkgLists\n[archlinuxcn]\nServer=https://mirrors.ustc.edu.cn/archlinuxcn/$arch" >> /etc/pacman.conf
pacman -Syu archlinuxcn-keyring --noconfirm
pacman -S yaourt

echo "设置为东八区时间"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "设置中文locale"
echo  -e "en_US.UTF-8 UTF-8\nzh_CN.GBK\nzh_CN.UTF-8 UTF-8\nzh_TW.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "请设置一个root（超级权限）密码"
passwd
echo "重复输入两次 注意：输入过程中屏幕上不会有任何提示 每次输入完毕按下回车"

echo "添加一个用户名 yourname是你的用户名 添加命令：useradd -mg users -S /bin/bash yourname "
useradd -mg users -S /bin/bash
echo "添加用户密码 passwd yourname"

echo "安装gnome桌面 gnome调校工具 arc主题 numix图标 "
pacman -S gnome gnome-tweak-tool arc-gtk-theme numix-circle-icon-theme-git --noconfirm
pacman -Rscn gnome-contacts empathy gnome-dictionary --noconfirm
systemctl start gdm

echo "安装gnome程序分组管理工具"
pacman -S gnome-appfolder-manager --noconfirm

echo "安装软件管理中心"
pacman -S gnome-software --noconfirm

echo "安装fcitx中文输入"
pacman -S fcitx-configtool fcitx-im fcitx-sogoupinyin --noconfirm
echo -e "export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"\n" >> /etc/environment 

echo "安装浏览器"
pacman -S firefox --noconfirm

echo "安装压缩/解压工具"
pacman -Rscn unzip --noconfirm
pacman -S unzip-iconv p7zip unrar file-roller --noconfirm

echo "安装影音播放"
pacman -S netease-cloud-music gnome-music --noconfirm
# clementine deadbeef mpv moonplayer

echo "安装office工具"
pacman -S ttf-wps-fonts wps-office --noconfirm
# pacman -S libreoffice-fresh libreoffice-fresh-zh-CN --noconfirm

echo "安装markdown编辑器"
pacman -S typora --noconfirm
echo "安装evernote第三方工具"
pacman -S nixnote --noconfirm
echo "安装gedit记事本"
pacman -S gedit gedit-plugins --noconfirm

echo "安装有道词典"
pacman -S ydcv youdao-dict --noconfirm

echo "安装中国日历"
pacman -S chinese-calendar --noconfirm

echo "安装云盘"
pacman -S nutstore --noconfirm
pacman -S megasync --noconfirm
pacman -S bcloud-git --noconfirm

echo "安装电子邮件工具"
pacman -S geary --noconfirm

echo "安装即时通讯工具"
pacman -S electronic-wechat

echo "安装下载工具uget"
pacman -S wget uget aria2 --noconfirm

echo "安装科学上网工具 影梭shadowsocks"
pacman -S shodowsocks-qt5 proxychains --noconfirm
echo "socks5 	127.0.0.1 1080" > /etc/proxychains
echo "更新hosts进行科学上网"
wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O /etc/hosts

echo "安装编程工具"
pacman -S git diffuse gitg --noconfirm
pacman -S visual-studio-code --noconfirm
#atom
#idea webstorm pycharm
#eclipse 
#vim emacs

echo "安装neofetch"
pacman -S neofetch --neofetch

echo "安装笔记本电源管理优化工具tlp"
pacman -S tlp --noconfirm
systemctl enable tlp && systemctl start tlp

echo "你可以连续按下ctrl-d 然后输入reboot进行系统重启\n注意\n你可能需要在BIOS中对启动项顺序进行调整 在安装了windows系统的设备上可能会默认启用windows的引导程序\n你可能需要在BIOS中关闭安全启动选项 否则无法启动linux"







