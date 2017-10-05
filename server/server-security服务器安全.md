# ssh
配置文件在`/etc/ssh/sshd_config`
- 更改默认的22端口
- 使用非对称加密密钥，客户机执行以下命令生成密钥：
```shell
ssh-keygen  #或者ssh-keygen -t rsa 4096  生成密钥
ssh-copy-d -p 23579 ip@8.8.8.8  #上传公钥（23579是端口号，8.8.8.8是ip地址）
```
- 用户控制

  - 禁用root登录

  - 限制用户登录shell
    例如为建立git仓库而使用的git用户，找到`/etc/passwd`文件中git所在行，将其中的`/bin/bash`(根据不同shell可能是/bin/zsh或者其他的)改为`/bin/git-shell`，使得git用户无法登录shell，但仍可通过命令行访问git仓库。

  - 完全禁止登录shell

     - 在`/etc/passwd`文件中找到该用户所在行，将`/bin/bash`字样改为`/sbin/nologin`。	

     - 在ssh配置文件中添加`DenyUsers username`（username即用户名，下同）。

     - 在`/etc/pam.d/sshd`文件中添加：

       > auth  required  pam_listfile.so  item=user  sense=allow  file=/etc/ssh/deny onerr=succeed

       在`/etc/ssh/deny`中加上要禁止的用户名

  - 只允许某些用户登录

    在ssh配置文件中内容：

    - 允许单用户：`AllowUsers username`
    - 允许用户组：`AllowGroups groupname`（groupname是组名）