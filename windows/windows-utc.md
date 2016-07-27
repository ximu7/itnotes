windows使用utc时间

- 新建一个.reg文件，如utc-time.reg,文件内加入如下内容：

```reg
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation]
"RealTimeIsUniversal"=dword:00000001
```

保存该文件。

- 双击运行该文件。
- 重启进入BIOS设置时间为当前的UTC标准时间，如东八区——以北京时间为例——其UTC标准时间即是北京时间减去8个小时。注意考虑（可能存在的）夏令时问题。