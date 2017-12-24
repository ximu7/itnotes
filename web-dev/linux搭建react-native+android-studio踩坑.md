参照[react native](https://facebook.github.io/react-native/docs/getting-started.html)文档的步骤进行安装，安装完毕后，打开Android Studio，导入你的项目项目（或者官方提供的实验项目AwesomeProject）文件夹，开启安卓虚拟机(Android Emulator，当然也可以选择真机调试）。

调试步骤——进入命令行，cd到项目文件夹下，中执行：

1. 项目运行`npm start`（使用yarn则是`yarn start` ）
2. 虚拟机启动
3. 连接虚拟机进行调试 `react-native run-anroid`

[TOC]

当然你也许会遇到以下问题：

#相关问题解决

- Thread(png-cruncher_20) has a null payload

  安装**lib32zl**(包名也可能是 **lib32zlib**)

- Error: java.util.concurrent.ExecutionException: java.lang.RuntimeException: AAPT process not ready to receive commands

  安装**lib32stdc++6**(如果没有6 也可以安装 **lib32stdc++5**)

  ​

  注意：对于以上两个软件安装，你可能需要手动开启lib32源（例如archlinux需要开启multilib源）。目前这两个软件还没法用64位的代替。

  提示：具体包名可在http://pkgs.org 搜索关键字查询。

- kvm相关（用以对模拟器加速）

  根据发行版安装qemu（具体包名可在http://pkgs.org 搜索关键字查询，或使用包管理器搜索关键字），启用kvm相关模组（一般会自动启用）。

  参阅文档[qemu](https://wiki.archlinux.org/index.php/QEMU_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.90.AF.E7.94.A8_KVM)  [kvm](https://wiki.archlinux.org/index.php/KVM_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.A6.82.E4.BD.95.E4.BD.BF.E7.94.A8KVM)  [kernel modules](https://wiki.archlinux.org/index.php/Kernel_modules_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E6.89.8B.E5.8A.A8.E5.8A.A0.E8.BD.BD.E5.8D.B8.E8.BD.BD)

  - kvm硬件支持情况

    `grep -E "(vmx|svm)" --color=always /proc/cpuinfo`

    如果运行后没有显示，那么你的处理器**不**支持硬件虚拟化

  - 检查kvm启用状况

    - bios里面查看是否开启虚拟化

    - `lsmod | grep kvm` 查看是否加载了kvm相关模组 有类似一下输出

      ```shell
      kvm_intel             225280  4
      kvm                   696320  1 kvm_intel
      ```

      一般在安装kvm后重启，系统会自动将这些模组进行加载。



- 启动安卓模拟器提示 /dev/kvm device permission denied

    将当前用户添加到kvm用户组即可，加入当前用户名为username

    ```shell
    usermod -aG kvm username
    newgrp  #立即生效 也可以重启系统或者注销登录后生效
    ```

- 启动安卓模拟器失败Emulator: Process finished with exit code 1

  打开log有类似：

  > libGL error: unable to load driver: i965_dri.so
  > libGL error: driver pointer missing
  > libGL error: failed to load driver: i965
  > libGL error: unable to load driver: swrast_dri.so
  > libGL error: failed to load driver: swrast

  ```shell
  ln -sf /usr/lib/libstdc++.so.6* $ANDROID_SDK_HOME/emulator/lib64/libstdc++/
  ```


---

# 单独启动虚拟机

对于react-native开发，大多时候并不需要开启android studio，只是希望快速开启android emulator中的某个虚拟机进行调试，这里对从命令行启动和创建虚拟机进行简要说明。

更多命令可使用`android -h`获取。

## 启动虚拟机

- 列出所有建立的虚拟机

  ```shell
  emulator -list-avds    
  ```

- `emulator @虚拟机名字`   可启动一个虚拟机

  例如某个虚拟机名为Nexus_5X_API_27_x86，执行以下命令启动：

  ```shell
  emulator @Nexus_5X_API_27_x86
  ```

  如果当前只有一个虚拟机，可以执行一下命令直接启动：

  ```shell
  emulator @`emulator -list-avds`
  ```

  ！错误：如果提示

  > [140698804799296]:ERROR:android/android-emu/android/qt/qt_setup.cpp:28:Qt library not found at ../emulator/lib64/qt/lib
  > Could not launch '/home/levin/../emulator/qemu/linux-x86_64/qemu-system-x86_64': No such file or directory

  可以使用`$ANDROID_HOME/tools/emulator`代替`emulator`：

  ```shell
  $ANDROID_HOME/tools/emulator @`emulator -list-avds`
  ```

  为了方便使用，可在`~/.bashrc`添加相关别名，例如：

  ```shell
  alias avds='emulator -list-avds'  #列出所有虚拟机
  alias emulator='$ANDROID_HOME/tools/emulator'  #emulator
  #启动虚拟机（适合只有一个时）
  alias avd='$ANDROID_HOME/tools/emulator @`emulator -list-avds`'
  ```


## 创建/删除虚拟机

- 列出所有sdk

  ```shell
  android list target
  ```

  会有类似以下内容：

  > id: 3 or "android-27"
  >
  >   Name: Android API 27
  >   Type: Platform
  >   API level: 27
  >   Revision: 1

  其中的id就是下面创建虚拟机需要的选项之一

- 创建虚拟机

  ```shell
  android create avd -n new_android -t 3
  ```

  其中-n后面指定虚拟机的名字，-t后面的数字指定上面列出的id值。

  使用`emulator @new_android`即可启动名为new_android的虚拟机。

- 删除虚拟机

  ```shell
  android delete new_android
  ```
