Git 是Linus Torvalds在2002年用C语言编写的一个**分布式版本控制系统**。

---

[TOC]

如未说明，尖括号<>内的内容表示其并非git命令参数，而是用户定义的内容（如具体仓库名、分支名、文件名等等）。

参考：[git-scm](https://git-scm.com/book/zh/v2)   [git简明指南](http://rogerdudler.github.io/git-guide/index.zh.html)    [图解git](http://marklodato.github.io/visual-git-guide/index-zh-cn.html)    [git参考手册](http://gitref.org/zh/creating/)    [archlinux-wiki:git](https://wiki.archlinux.org/index.php/Git_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)) [猴子都能看懂的git入门](http://backlogtool.com/git-guide/cn/) [廖雪峰：git教程](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)

---

# 安装和初始设定

- 安装git

  Linux：根据发行版不同，使用安装命令安装`git`包。

  Mac OS X：安装Xcode，自带git，或 `brew install git`。

  Windows：[Git for Windows](https://git-for-windows.github.io/)

  - 图形化git 例如：

    - gitk  命令行自带图形界面，在git仓库中执行`gitk`或在任何地方执行`git gui`启动。
    - [gitkraken](https://www.gitkraken.com/)
    - [source tree](https://www.sourcetreeapp.com/)
    - [github desktop](https://desktop.github.com/)
    - [git-cola](https://git-cola.github.io/)


- 初始设定

  设置用户名和邮箱，图形界面到其相关设置选项里设置，命令行：

  ```shell
  git config --global user.name "Your Name"
  git config --global user.email "email@example.com"
  ```

更多设置见后文--git[配置](#配置)

从本地仓库向远程仓库推送的基本操作流程：

在本地仓库内进行操作- > 在[本地仓库创建快照版本](#提交快照)-> 将本地仓库快照[推送到远程仓库](#推送和下载分支)

# 仓库创建和远程关联

- 创建（/初始化）仓库:`git init`

  仓库空间划分：

  - **工作区**（working directory）：存放当前工作文件

  - **暂存区**(stage)：存放通过`git add`添加的文件。

  - **版本库**（repository）：项目的各个版本（快照）。

    ​

## 远程关联

如果要使用服务器上的仓库进行存储，首先要关联上远程仓库。可以使用从远程仓库克隆和或者直接添加远程仓库将本地仓库和远程仓库关联。

- 从远程仓库克隆：`git clone <url/repo-name>`    几种不同的协议示例：

  ```shell
  git clone https://example.com/path/to/repo-nam.git
  git clone git@example.com:someone/path/to/repo-name.git
  git clone ssh://example.com/path/to/repo-name.git
  git clone git://example.com/path/to/repo-name.git
  ```

  此外还支持ftp、git、rsync等协议。

  克隆远程仓库的某个分支：`git clone <remote_repo> -b <branch>` 分支相关信息参看[分支管理](#分支管理)


- 添加远程仓库：`git remote add <host-name> <url>`

    host-name是远程主机名，默认使用`origin`。

- 删除关联：`git remote remove <repo-name>`

- 查看远程仓库信息：`git remote`
    - 查看远程仓库详细信息：`git remote -v`

- 关联远程分支：见下文[分支管理](#分支管理)下的”创建、切换、合并和删除分支”以及“推送和下载分支”。

# 快照基本操作
Git 保存数据是对文件系统的一组快照。 每次提交更新时，它主要对当时的全部文件制作一个**快照**。如果文件没有修改，Git 只保留一个链接指向之前存储的文件。一份快照就是备份的一个文件版本。Git 的工作就是创建和保存项目的快照及与之后的快照进行对比。

一个简单的快照生成流程：工作区文件--add-->进入暂存区--commit-->加入版本快照。

## 仓库状态

- 查看当前仓库状态：`git status`
  - 简略地显示：`git status -s`

- 查看仓库变动内容：`git diff`
  - 显示变动内容摘要：`git diff --stat`
    - 查看已暂存的改动：`git diff --cached`
  - 显示**最近**快照和工作区内容的差异：`git diff HEAD`
    - 显示指定文件的差异`git diff HEAD --<filename>`
- 查看历史操作：`git reflog`

## 提交快照

提交一个快照需要两步操作：

1. 添加文件到暂存区：`git add <file-name>`

2. 提交快照：`git commit`

每次提交都会生成一个哈希码，即是commit id。修改过的文件如果不添加到暂存区，就不会加入到快照中。

- 将**所有变动**添加到暂存区：`git add -A`

  变动包括（对文件的）新建、修改和删除，A是--all的缩写，相当于以下两条命令：

  - `git add .`    将所有**新建和修改（但不包括删除）**提交到暂存区

  - `git add -u`    将所有**修改和删除（但不包括新建）**提交到暂存区（u--update，只标记本地有改动的已追踪文件）



- 提交快照并添加注解：`git commit -m "about"`   about是注解内容

  `-m "about"`还可和其他操作（如merge 和tag等）合用。

- 存储**未添加到暂存区的变动**到快照并添加注解：`git commit -am "about"`

- 将**暂存区**的变动**追加**到上一份快照：`git commit --amend`

    在添加快照后又变动了部分内容，可以将这些变动添加到暂存区，然后执行该命令追加到上一份快照中，该命令会**生成的新的commit id并替换掉原commit id**； 如果暂存区没有内容, 可以利用该命令修改上一次提交的注解。


## 回退快照

即撤回到某次提交后的状态。

- 撤销文件的修改
  - **撤销工作区**修改：`git checkout -- <file-name>`

    此操作其实是用该文件在版本库里的版本替换工作区的版本。

  - **撤销暂存区**修改：`get reset HEAD <file-name>`

    将工作区中已经更改且添加到暂存区的文件还原到工作区中未更改前的状态，需要**先撤销暂存区修改，再撤销工作区修改**。

- 删除版本库中的文件：`git rm <file-name>`然后`git commit`提交快照。

  移动或改名版本库中的文件`git mv <file-name> <new-file-name>`同理，需要进行`git commit`快照提交才能生效。

  默认情况下`git rm <file-name>`也会将文件从暂存区和硬盘中（工作目录）删除。如果要在工作目录中留存该文件，可以使用`git rm --cached <file-name>`保留。

- 回退到指定版本：`git reset --hard <commit-id>` 

  commit id可以使用前文的`git reflog`命令在历史操作记录中查找。

  回退之后要推送到远程仓库使用`git push origin HEAD --force`

  - 回退到上一个版本：`git reset --hard HEAD^`

    ==`HEAD`、`^`和`~`==

    `HEAD`表示**当前分支的当前版本**；

    `^`（caret）表示父提交，当一个提交有多个父提交时，可以通过在`^`后面跟一个**数字**，该数字表示第几个父提交，`HEAD^`相当于`HEAD^1`（第一个父提交），；

    `～`（tilde）后跟一个数字n相当于**前面连续的**n个`^`，`HEAD～2`就相当于`HEAD^^`或`HEA^1^1`；

    上一个版本就是`HEAD^`或`HEAD^`，上两个版本就是`HEAD^^`。

    ====

# 分支管理
分支管理经验示例：

- master分支--用于稳定更新，同步到远程仓库；
- dev分支--用于开发，同步到远程仓库；
- bug分支--用于修复问题，不必同步;
- feature分支--用于添加新特性，根据情况同步；

……

## 分支查看

- 列出所有分支：`git branch`
  - 查看包含指定版本的分支：`git branch --contains <commmit-id>`
- 列出**当前**分支历史记录：`git log`
    - 查看指定的分支：`git log <branch-name>`
    - 显示拓扑图：`git log -- graph`
    - 简洁模式查看：`git log --oneline`
    - 显示所有的提交信息：`git --decorate`
    - 特定过滤：
        - 查找有特定内容的注释的分支：`git log --grep=<content>` 

        - 查找特定作者提交的分支：`git log --author="name"`（name是作者名字）

        - 按时间范围查看分支：`git log --since/befor/until/after={time-discription}`
            示例：`git log --oneline --before={3.weeks.ago} --after={2016-06-06} --no-merges` 

            `--no-merges`作用是隐藏合并提交的分支，`--oneline`是每个提交显示一行

## 创建、切换、合并和删除分支

- 创建并切换分支：`git checkout -b <branch-name>`
  相当于以下两条命令：
  - 创建分支：`git branch <branch-name>`

  - 切换分支：`git checkout <branch-name>`
  - 创建并切换分支，同时关联远程分支：`git checkout -b <branch-name> origin/<branch-name>`
  - 本地已有分支关联远程分支：`git branch --set-upstream <branch-name> <origin/branch-name>`



- 合并指定分支**到当前分支**：`git merge <branch-name>`

    如果合并分支时存在冲突则需要先解决冲突。

    合并分支时可在命令后面加上`-m "info"`来添加一个合并说明。

    - 普通方式合并分支：`git merge --no-off <branch-name>`

      通常合并分支时，如果可能，Git会用Fast forward模式，但这种模式下，删除分支后，会丢掉分支信息。加`--no-off`参数，可以用普通模式合并。

    - 合并指定分支到当前分支并**丢弃当前分支的历史快照**：`git rebase <branch-name>`

        将指定分支（branch-name）合并到**当前分支**，**合并后的版本**将“嫁接”到该指定分支上并取代该分支。而**当前分支的其余历史快照将会被丢弃**，这些历史快照将会**临时**保存为补丁(patch，补丁在`.git/rebase`目录中)。

- 删除分支：`git branch -d <branch-name>`
    强行删除**未被合并过**的分支：`git branch -D <branch-name>`

    这只是删除了本地的分支，如果要删除远程仓库的分支，参看[#推送和下载分支](推送和下载分支)有关推送的说明。

## 推送和获取分支

- 推送分支：`git push <repo-name> <local-branch-name>:<remote-branch-name>`  

    - 如果省略远程分支名，则表示远程分支名和本地分支名一致，如此远程分支名不存在，则会新建一个远程分支。

      示例：`git push origin dev`

    - 如果省略本地分支名，则表示**删除指定的远程分支**，因为这等同于推送一个空的本地分支到远程分支。

      示例：`git push origin :dev`

    - 如果本地分支名和远程分支名都省略，则表示将**当前分支**推送到远程的对应分支。

      示例：`git push origin`

    push命令最后加上`--tags`会推送未曾推送过的标签，参看[标签管理](#标签管理)。

    - 只推送当前分支：`git push`（如果当前分支**只有一个追踪分支**时可以使用）
    - 推送全部分支：`git push -all origin`
    - 推送并指定默认远程仓库：`git push -u <repo-name> <branch-name>`  
    - 强制推送：`git push --force origin` （使用本地快照版本强制覆盖到远程仓库）

- 获取分支

    - 获取当前分支新内容：`git fetch <repo-name>`  从远程仓库下载新内容
    - 拉取并合并到当前分支：`git pull <repo-name>`  从远程仓库下载新内容并尝试合并到本地当前分支（相当于先fetch获取新内容，然后merge）

## 工作区存储
可**暂存当前工作区**以操作新分支。

- 存储工作区：`git stash`
- 列出存储的工作区：`git stash list`
- 恢复存储的工作区
    - 恢复工作区且**保留**工作区内容：`git stash apply`

      - 恢复指定指定编号的工作区：`git stash apply stash@{number}`（number是一个数字）

        编号可用`git stash list`命令查看。

    - 恢复工作区并**删除**工作区内容：`git stash pop`
- 删除工作区：`git stash drop`


# 标签管理

提交快照时的commit id是一串数字+字母（hash code），难以记忆，使用相对不变，tag可以对提交打上容易记住的标签。

- 查看标签：
  - 列出所有标签：`git tag`
  - 查看指定标签信息：`git show <tag-name>`

- 添加标签

  可以在打标签命令后添加 `-m "about"`(about是标签注解)给标签添加注解。

  - 给当前分支打标签：`git tag <tag-name>`
  - 给指定快照打标签：`git tag <tag-name> <commit-id>`
  - 使用GPG签名打标签：`git tag -s <tag-name> `

- 推送标签

  创建的标签都只存储在本地，**不会自动推送**到远程仓库。

  - 推送一个本地标签：`git push <repository-name> <tag-name>`
  - 推送全部未推送过的本地标签：`git push <repository-name> --tags`

- 删除标签

  - 删除一个本地标签：`git tag -d <tag-name>`
  - 删除一个远程标签：`git push <repository-name> :refs/tags/<tag-name>`


# git配置

## 忽略规则

创建.gitignore文件，添加特定匹配规则就可以禁止相应的文件推送到远程仓库。
[github提供的.gitingore文件](https://github.com/github/gitignore)

windows下：在资源管理器里新建一个.gitignore文件，系统会提示必须输入文件名，可在文本编辑器里“保存”或者“另存为”就可以把文件保存为.gitignore了。

- 校验.gitingore文件：`git check-ignore`
- 校验指定规则：`git check-ignore -v <rule>`
- 强制添加被忽略的文件：`git add -f <file-name>`
- .gitingore编写：
  - `#`注释
  - 一行一条
  - 同名匹配
  - 可使用通配符

## 配置

git的配置文件在`~/.gitconfig`，仓库的配置文件是仓库内的`.git/config`。

可运行`git help` `git config`和`man git`查看更多帮助信息。

官方文档[git-config Manual Page](https://www.kernel.org/pub/software/scm/git/docs/git-config.html)e

部分设置命令：

加上`--globle`参数，则设置内容对当前用户生效，不加`--global`则对当前仓库生效。

- 检查配置情况：`git config --list`

- 设置默认编辑器，如nano： `git config --global core.editor nano`

- 设置默认对比工具，如meld：`git config --global merge.tool meld`

- 彩色输出：`git config --global color.ui true`

- 中文文件名显示：`git config --global core.quotepath false`（避免中文显示成数字）

- 显示历史记录时每个提交的信息显示一行： `git --global config format.pretty oneline`

- 设置用户名和电子邮箱

  ````shell
  git config --global user.name "your name"
  git config --global user.email "email@example.com
  ````

- 协议更换

  如https替代git协议

  ```shell
  git config --global url."https://".insteadof "git://"
  git config --global url."https://github.com/".insteadof "git@github.com:"
  ```

- 设置代理 

  如使用socks5，本地ip和端口是127.0.0.1:1080

  ```shell
  git config --global http.proxy socks5://127.0.0.1:1080
  git config --global https.proxy socks5://127.0.0.1:1080
  #取消设置的代理
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  ```

- 设置命令别名：`git config --global alias.<another name> status`

    ```shell
    git config --global alias.ci commit
    git config --global alias.br branch
    git config --global alias.unstage 'reset HEAD'
    git config --global alias.graph 'log --graph --oneline --decorate'
    ```
# git服务简易搭建
1. 安装git、openssh，开启ssh服务`systemctl start sshd && systemctl enable sshd`

2. 创建运行git服务的用户（可选）

3. 初始化Git仓库：`git init --bare <name.git>`（服务器上的Git仓库通常都以.git结尾）

   如果要从已经存在的仓库克隆一份作为新的裸仓库：`git clone --bare <repo-name> <new-repo-name>.git`  （注意：此命令会**只复制**出原仓库中的`.git`目录）

   也可以将原仓库的`.git`目录复制并改名成一个新仓库：`cp <repo-name>/.git <new-repo-name>.git`

   如果服务器的ssh服务更改了默认使用端口，参照前文“远程关联-从远程仓库克隆”中的使用方法。



4. 安全管理

- 非对称加密

   在客户机使用`ssh-keygen`生成非对称加密的公私钥，在服务器上运行git的用户的`~/.ssh/authorized_kesys`文件中，添加有客户机公钥。（注意：保证`.ssh`文件夹权限为700以及`authorized_kesys`文件权限为600，公钥一行一个。）

- git文件夹权限

  git仓库文件夹的权限设置为755（即`rwxr-xr-x` ），不允许其他用户更改（仅通过添加SSH公钥来添加允许更改的客户端，这些被允许的客户端是通过执行git服务的用户来获取写入权限的）。

- ssh权限

   ssh配置文件位于`/etc/ssh/sshd_config` ，如更改默认端口，使用白名单策略等等。

- shell权限

  假如git服务的执行用户名为`git`，编辑`/etc/passwd`文件，找到`git`所在行，将行中`/bin/bash`字样（根据不同shell，也可能是`bin/zsh`等等） 改为`bin/git-shell` 。

