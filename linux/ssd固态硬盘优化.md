固态硬盘优化技巧

-   禁用文件系统日志（不建议）

    **明显缺点是非正常卸载分区（即断电后，内核锁定等）会造成数据丢失。**

- 分区对齐
     现代发行版几乎分区的时候都用了4k对齐。
     对齐检查：
```bash
parted /dev/sda
align-check optimal 1         
```
​	使用图形界面的gaparted可以调整对齐。

-   TRIM

     TRIM支持的文件系统：Ext4、Btrfs、JFS、VFAT，XFS。

     *VFAT 只有挂载参数为'discard'(而不是fstrim)时才支持 TRIM 。*

     TRIM需utils-linux包。

     **检验TRIM支持**
     需要hdparm。

     ```shell
     hdparm -I /dev/sda | grep TRIM
           //得到类似信息  *    Data Set Management TRIM supported (limit 1 block)
     ```

     有几种TRIM支持的规格，因此，输出内容取决于驱动器支持什么。

     **执行TRIM**

     ```shell
     fstrim -v /home   #对home分区执行trim
     fstrim -v /
     ```

     *为了方便可以使用cron进行自动定期TRIM或者写入使用alias将其.bashrc手动TRIM。*

- swap分区swapiness

    将swapiness的值改得非常低（如1）会减少内存的交换，从而提升一些系统上的响应度。
```shell
cat /proc/sys/vm/swappiness    #检查swappiness值
sysctl vm.swappiness=1    #临时设置为1
```
​	为了长久保存设置可新建一个`/etc/sysctl.d/99-sysctl.conf`文件，修改swappiness为1：     
```
vm.swappiness=1
vm.vfs_cache_pressure=50
```

-   频繁读取的分区（如`/var`）放置于HDD

- 频繁读取的文件置于内存

    注：内存没用完，linux不会去用交换区。

    `df -h`可查看使用tmpfs的情况。

    注：/tmp已经默认使用tmpfs，无需设置。

    **浏览器的cache使用tmpfs**

    -   firefox在地址栏中输入 about:config 后回车，然后点击右键新建一个 String ， name 为 browser.cache.disk.parent_directory ， value 为 /dev/shm/firefox。

    - Chromium/Chrome找到Chrmium（或Chrmoe）程序图标所在位置，如"/usr/share/applications/chromium.desktop"，修改该文件中`Exec`一行为`Exec=/usr/bin/chromium --disk-cache-dir="/dev/shm/chromium/"` 。

        /usr/shar/applications下的图标需要root权限才能更改，可以先赋予777权限`sudo chmod 777 /usr/share/applications/chromium.desktop`；更改完后再还原权限`sudo chmod 644 /usr/share/applications/chromium.desktop`。

        或者复制`/usr/share/applications/chromium.desktop`到`~/.local/share/applications/chromium.desktop`，再对其修改。

另：有 [anything-sync-daemon](https://aur.archlinux.org/packages/anything-sync-daemon/)允许用户将**任意** 目录使用相同的基本逻辑和安全防护措施同步入内存。