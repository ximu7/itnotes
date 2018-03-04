提示：

- 要重装的设备需要能连接到互联网，如果其不能连接到互联网，可在其所处的局域网中搭建私有源。

  安装web服务器如apache/nginx，挂载DVD镜像但web根目录下。

- 内存过小可能无法成功（centos实测1G内存失败）



1. ssh登录到该设备

2. 下载`vmlinuz`和`initrd.img`放置于`/boot`目录下

   - 不同的发行版，这两个文件的名字可略有出入，例如`vmlinz-linux`和`initramfs-linux.img`。
   - 这两个文件可以从镜像源网站中直接获取，或者从下载的系统镜像文件中提取。
   - 给予`initrd.img`600权限，`vmlinuz`755权限。

3. 修改grub启动项

   1. 制作grub启动项

      查看`grub.cfg`文件（可能是`/etc/grub.cfg`、`/etc/grub2/grub.cfg`、`/boot/grub/grub.cfg`等），找到`### BEGIN /etc/grub.d/10_linux ###`行下的`menuentry `项，复制该部分，在`/etc/grub.d/40_custom`文件中添加上文复制的内容，作出部分修改（大部分内容可省略，注意下面注释的部分是重要部分），示例：

      ```shell
      menuentry "remote reinstall" {
              set root=(hd0,msdos1)  #与第1步中查看到内容要一致
              # repo地址 vncpassword ip gateway nameserver
              linux /vmlinuz repo=http://mirrors.aliyun.com/centos/7/os/x86_64/ vnc vncpassword=password ip=192.168.100.3 netmask=255.255.255.0 gateway=192.168.100.1 nameserver=192.168.100.1 noselinux headless xfs panic=60
              initrd /initrd.img
      }
      ```

      提示：

      - 获取ip  `ip addr`
      - 获取gateway  `arp -a`或`ip route`
      - 获取nameserver `cat /etc/resolv.conf`

   2. 修改grub默认启动项

      在`/etc/default/grub`修改或添加`GRUB_DEFAULT="remote reinstall"`，然后重新生成grub.cfg

      ```shell
      #不同的发行版 命令可能为grub-mkconfig
      grub2-mkconfig -o /boot/grub2/grub.cfg  #注意grub.cfg路径正确
      ```

   3. 重启系统`reboot`，系统会自动从上面配置的`remote install`项目启动。使用vnc连接，进行系统安装操作即可。

      上文设置的vnc地址：`172.18.229.218:5901`，密码`password`