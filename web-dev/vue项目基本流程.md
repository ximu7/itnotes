[vue中文文档](https://cn.vuejs.org/v2/guide/)

# 开发环境搭建

1. `vue init`
   - `vue init webpack`  使用webpack插件
2. `npm install`
3. 根据项目需求建立好各个文件目录层次和相关配置文件

## vue默认项目结构简介

- 一级目录和文件

  ├── build　　项目构建相关
  ├── config　　生产和开发环境配置
  ├── node_modules　　各种node包依赖
  ├── src　　源码
  ├── static　　第三方资源
  ├── .babelrc　　插件babel的配置文件 编译ES6及以后的语法为ES5
  ├── .editorconfig　　编码风格的配置文件
  ├── .eslintignore　　校验工具eslint要忽略的文件/文件夹的配置文件
  ├── .eslintrc.js　　校验工具eslint的配置文件
  ├── .gitignore　　版本控制工具git忽略的文件/文件夹的
  ├── index.html　　项目主页文件
  ├── package.json　　项目描述信息文件
  ├── package.json　　项目描述信息文件
  ├── package-lock.json　　记录当前安装的各个依赖的具体来源和版本号信息文件
  ├── .postcssrc.js　　插件post-loader的配置文件
  └── README.md　　项目说明文件

- 部分二级目录下的文件/文件夹

  - build 项目构建相关

    ├── build.js　　生产环境构建代码
    ├── check-versions.js　　检查node、npm等版本信息
    ├── dev-client.js　　热加载配置
    ├── dev-server.js　　本地服务器配置
    ├── utils.js　　构建项目的工具
    ├── vue-loader.conf.js　　插件vue-loader的配置
    ├── webpack.base.conf.js　　插件webpack的基本配置
    ├── webpack.dev.conf.js　　插件webpack的开发环境配置
    └── webpack.prod.conf.js　　插件webpack的生产环境配置

  - config 生产和开发环境配置

    ├── dev.env.js　　开发环境配置
    ├── index.js　　项目主配置
    └── prod.env.js　　生产环境配置

  - src 源码

    ├── assets　　资源文件夹（存放一些静态资源如css、字体等）
    ├── components　　组件文件夹（.vue）
    ├── router　　路由配置文件夹（.js）
    ├── App.vue　　项目入口vue组件
    └── main.js　　项目入口javascript文件

  - static 第三方资源

    .gitkeep 　如果空文件夹中有.gitkeep 则该空文件夹在使用git提交快照时会被忽略

# 使用vue渲染页面

数据－－[vue.js]－－页面

html中引用vue.js：vue.js  >  *.js  >  *.html

vue项目：main.js > *.vue >  *.html

使用路由的vue项目：component/*.vue > router/index.js  > main.js > App.vue > index.html

---

- index.html　　主页文件　入口组件App.vue内容渲染到该页面中id为app的元素内

- App.vue　　入口组件　其他组件内容渲染到入口组件的<router-view>标签内

- componets/　　组件目录

  ​

- router/index.js　　路由文件　引入vue、vue-router和各个组件　实例化一个路由对象并导出　该对象包含各个组件的路由配置信息

- main.js　　入口文件　引入vue、入口组件App.vue、路由配置导出的对象以及其他资源　实例化一个vue对象　使用App.vue为模板挂载到index.html中id为app的元素内

---

1. 页面文件index.html

   其中id为app的元素被用作App.vue组件渲染位置。（以下是部分html文件内容）

   ```html
   <div id="app">
     // App.vue的内容将会渲染在此处
   </div>
   ```

2. 其他组件

   除了入口组件（App.vue）的其他组件　这些组件内容被渲染到入口组件之中

3. 项目入口组件（App.vue）

   使用`<router-view />` 渲染其他组件

   ```vue
   <template>
     <div id="app">
       <!-- 其他组件内容将加载到router-view处-->
       <router-view/>
     </div>
   </template>

   <script>
   export default {
     name: 'app'
   }
   </script>

   <style>
   </style>
   ```

4. 路由文件 （router/index.js）

   1. **引入**vue、vue-router和其他组件

   2. **启用**vue-router（的实例对象）作为vue的插件

   3. **导出**一个路由对象实例（其包含了路由相关配置和各个子路由映射信息）

   ```javascript
   // 引入
   import Vue from 'vue'
   import Router from 'vue-router'
   import home from '@/components/home'

   // import xxx from 'xxx' //引用其他组件

   // 启用vue-router
   Vue.use(Router)

   // 导出路由对象实例
   export default new Router({
     routes: [　// 各个子路由
       {
         path: '/',
         name: 'home',
         component: home
       }
     ]
   })
   ```

5. 项目入口文件(main.js)

   1. **引入**vue、路由对象（router/index.js导出的对象）、入口组件（App.vue）和其他资源（如css文件）
   2. 挂载一个vue对象实例到主页面index.html（入口组件的内容将加载到主页文件index.html中对应的节点下）

   ```javascript
   // 引入vue、路由对象、入口组件和其他资源
   import Vue from 'vue'
   import App from './App'
   import router from './router'

   import './assets/style/app.css'

   // 挂载内容到入口组件
   new Vue({
     el: '#app',
     router, // 注入到实例中
     template: '<App/>',
     components: { App }
   })
   ```