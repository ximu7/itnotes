[TOC]

打包/解包或解压/压缩工具名一般和打包/压缩后的文件后缀名相同，如tar打包使用tar工具。

- 跨平台压缩推荐使用7z或zip（注意使用UTF-8格式！）
- tar打包压缩推荐配合xz（即最后制成.tar.xz文件），xz压缩率好，大多数linux都带有该工具。

# .zip

工具zip和unzip/unzip-iconv（unzip-iconv用法同unzip，只是多了一个-O参数可指定编码格式）

```shell
zip file.zip file  #打包
unzip file.zip  #解包
#指定编码格式(如gbk)避免乱码 需要安装unzip-iconv
unzip -O gbk
```

# .7z

工具p7zip

```shell
7za a  file.7z file  #压缩
7za x file.7z  #解压
```

# .rar

工具rar和unrar

```shell
rar a file.rar file  #压缩
unrar file.rar  #解压
```

# .tar

```shell
tar -cvf file  #打包
tar -xvf file.tar  #解包
```

- 在上面命令的参数后面加上：
  - `-z`可以在打包/解包时进行压缩/解压.tar.gz
  - `-j`可以在打包/解包时进行压缩/解压.tar.bz2
- .tar.xz需要先使用tar解包在使用xz解压（压缩则反向进行）

# .gz

```shell
gnuzip file.gz  #解压
gnuzip -d file.gz  #解压
gzip file  #压缩
```

# .bz2

```shell
#使用bzip2或bunzip2
bzip2 -z file  #压缩
bzip2 -d file.bz2  #解压
```
# .xz

```shell
xz -z file  #压缩
xz -d file.xz  #解压
```

# .rpm

解包

```shell
rpm2cpio file.rpm | cpio -div 
```

# .deb

解包

```shell
dpkg-deb --fsys-tarfile file.deb | tar xvf - ar p 
file.deb data.tar.gz | tar xvzf – 
#或
bsdtar -xJf file.deb
```

# .cpio.gz/.cgz

```shell
gzip -dc file.cgz | cpio -div  
```

# .cpio/cpio

```shell
cpio -div file.cpio 
#或
cpio -divc file.cpio 
```

# .a

```shell
tar xv file.a 
```

# .z

```shell
uncompress file.Z  
```
