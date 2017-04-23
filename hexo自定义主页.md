hexo自定义主页



---

禁止自动渲染首页

1. 删除hexo的`node_modules内`的`hexo-generator-index`文件夹（该文件夹内是hexo的主页生成插件）。

2. 在hexo的`source`文件夹（也就是内容文件夹）内新建一个主页文件index.html或index.md。

3. 在这个主页文件的**最前面**写上`layout: false`及3个`-`的分隔行，示例：
```
layout: false
---
```
layout:false会阻止hexo将该页面解析套上任何布局模板。



第3布也可以改成将index.html文件放到hexo的`theme`下当前主题文件夹内的source文件夹下。（因为每次生成页面，当前主题文件夹内的source文件会整个被复制到public文件夹下）

主页里面放上指向`archives/`的超链接可访问到最新文章页面。

---

另一种方法：使用两个仓库

1. 修改配置文件`_config.yml`的url和root的路径，置于根目下的子文件夹中，类似：

   ```
   # URL
   url: https://levinit.github.io/blog
   root: /blog/
   ```

2. 在github新建一个仓库名为`blog`。

3. 修改配置文件`_config.yml`的deploy地址，在仓库的地址后增加相同的路径：

```
   deploy:
       type: git
       repository: https://github.com/levinit/blog.git
       branch: master
```

4. 更改主题的_config.yml中的root地址，同1.
   ```
   root_url: /blog/
   ```

5. 在github的 pages仓库（即username.github.io仓库，username是github用户名，此仓库中的其他hexo内容可清空）中新建index.html页面，设置指向`blog/`的超链接就可以访问文章页面。