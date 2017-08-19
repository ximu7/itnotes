前端发展日新月异，此文章写于2017年5月，随着浏览器的更新，该文讨论的内容可能不再合适。

----

**遇到的问题**
---

在某个scroll事件中进行了对滚动条滚动距离的判定，使用了`document.documentElement.scrollTop`判断，在firefox和chrome下均无效（值始终是0）。

**老生常谈的兼容**
---
以前的经验是再加上一条`document.body.scrollTop`用来兼容chrome，不过触发scroll后，chrome倒是正常了，firefox依然没反应。
- 在chrome控制台能得到`document.body.scrollTop`的值，`document.documentElement.scrollTop`始终为0；
- 在firefox下能得到`document.body.scrollTop`的值，而`document.documentElement.scrollTop`始终为0，firefox"似乎"跟着chrome学去了？（其实不是）

**原来是doctype**
---
于是进行“网络搜索引擎编程”（搜索……），看到不少文章（其实看看就知道是一两篇文章转来转去）提到了doctype，文中说道：
>查资料发现是DTD的问题。
>页面指定了DTD，即指定了DOCTYPE时，使用document.documentElement。
>页面没有DTD，即没指定DOCTYPE时，使用document.body。
>IE和Firefox都是如此。

我一查看html文件原来真没写上`<!DOCTYPE html>`，于是乎添加之，检验页面，scroll内代码运行正常。
**但是**，我在chrome和firefox的控制台分别获取`document.body.scrollTop`和`document.documentElement.scrollTop`，发现firefox的`document.body.scrollTop`依然为0（虽然它是给chrome兼容来用的）。
于是我分别尝试了带有`<!DOCTYPE html>`和不带有`<!DOCTYPE html>`的两种情况，发现：
- chrome的scrollTop是从来不理会你又没有doctype声明，反正只有body的scrollTop值会变化；
- firefox则是在有doctype时scrollTop会变化、body的scrollTop始终是0，在没有doctype时相反。

**总结**
---
1. 兼容性惹不起，**以后看到body或documentElement相关的宽高距离时都注意一下**，以防万一；
2. w3c标准：没有声明doctype时，document.body.scrollTop有效， document.documentElent.scrollTop无效（始终是0）。
    2.1 firefox遵从此标准，有doctype时取documentElement的scrollTop，没有doctype时取body的scrollTop；
    2.2 chrome只认body的scrollTop，无论是否声明doctype，documentElement的scrollTop都是0。

当然整篇文章下来，还是用开始的`document.body.scrollTop || document.documentElement.scrollTop`解决问题，不过这次更加清楚为什么要这么写了，以前的认知中只觉得是chrome有时候非要独树一帜吧（当然是胡言乱语啦）。