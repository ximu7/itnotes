# 词法作用域lexical scope

定义在词法阶段的作用域。词法作用域是变量和语句块在**定义时所处的位置**决定的。

×*ES6中大括号`{}`之间的区域就会定义一个作用域块。*

# 执行上下文execution context

当前代码执行时的环境。（执行上下文和执行环境只是两种不同的翻译称呼）

执行环境可分为：全局环境、函数环境和Eval。

解释器初始化时首先默认进入全局环境，后续函数的调用（即便是函数递归调用自身）都创建并进入一个新的函数执行环境。

> 这些执行上下文会构成了一个执行上下文栈（Execution context stack，ECS）。栈底永远都是全局上下文，而栈顶就是当前正在执行的上下文。

代码执行时，当前的作用域会被存储到执行环境中。

# this

（目前）**除箭头函数外，this的指向只有在函数执行的时候才能确定，this指向当前执行上下文中保存的作用域（即调用当前函数的对象）。**

- 箭头函数：x=>x*x

  ES6箭头函数中的`this`**总是**指向**词法作用域**（在函数声明就确定了下来），也就是外层调用者，**call/apply/bind也无法对其进行更改**(传入的第一个参数会被忽略)。

## 函数调用的形式

- 函数直接调用：fn()
- 对像方法调用：obj.fn()
- 使用call/apply方法指定：fn.call(context,param1,param2)

**每个函数其实都包含着apply/call方法**，this的指向即是该方法的第一个参数——调用函数时的执行环境（context）。

省略call/apply的写法实际相当于默认将函数前面对象作为apply/call的第一参数传入；`fn()`就相当于`fn.call(undefined)`，`obj.fn()`相当于`obj.fn(obj)`。

非严格模式下，在浏览器中：

> 如果传的 context 就 null 或者 undefined，那么 window 对象就是默认的 context。

nodejs的全局对象是global。

各种情况下的this指向
---

- 全局范围内--全局对象

- 函数调用--全局对象

- 方法调用--方法所属的对象

- 调用构造函数--新创建的实例对象

- 显式地设置this--call/apply/bind的第一个参数

  如果call和apply的第一个参数写的是null，那么this指向的是window对象。

- 箭头函数中的this--其定义时的外层对象

以全局对象为window的示例：

```javascript
let goo={};
goo.method = function() {
    console.log(this);
    function test() {
        console.log(this);
    }
    test();//函数直接调用
    test.apply(this);//指定test的作用域
}
goo.method();//会依次打印 goo window goo
let temp=goo.method;//goo.method并没有执行，只是赋给temp
temp();//window window window   | 相当于window.temp
temp.call(goo);//goo window goo
```

构造函数中的this与return：如果return值类型和null，那么对构造函数没有影响，实例化对象返回空对象；如果return引用类型（数组，函数，对象——除了null），那么实例化对象就会返回该引用类型。

```javascript
function fn() {
    this.user = "who";
    let obj = new Object;
    return obj;//如果return非对象或null,新实例对象的user依然是who
}
let a = new fn;
console.log(a.user);//undefined
```

×附：bind、call、apply区别

call传给函数的参数（第一个参数之后的参数）需要逐一**列出**：`fn.call(that,arg1,arg2,arg3)`

apply第二个参数是一个**数组**：`fn.apply(that,[arg1,arg2,arg3])`

bind方法**返回**的是一个修改过后的**函数**，call、apply返回的是函数执行的结果。因此使用是以一个变量接受bind返回的“新函数”，然后在调用这个变量；或者添加`()`使其执行

```javascript
fn.bind(that,arg1,arg2);      //并不会执行fn方法 因为返回的是函数
fn.bind(that,arg1,arg2)();    //这样就能执行新函数了
//或者
var test=fn.bind(that,arg1,arg2);    //用新变量接收bind返回的函数
test();   //现在调用就会执行了
```

# 闭包closure

> **闭包**（Closure），又称**词法闭包**（Lexical Closure）或**函数闭包**（function closures），是**引用了自由变量的函数。**

```javascript
 function A(){
    let hello="Hello Closure!"
    function B(){
       console.log(hello);
    }
    return B;
}
var c = A();
c();//Hello Closure!
```

​	函数内部定义了一个函数，然后这个函数调用到了父函数内的相关变量，相关父级变量就会存入闭包作用域里面。

- 闭包特性
  - 函数嵌套函数
  - 函数内部可以引用外部的参数和变量
  - 参数和变量不会被垃圾回收机制回收
- 闭包作用
  - 希望这个变量常驻在内存中
  - 避免“污染”全局的变量
  - 作为私有成员存在

 javascript中的垃圾回收(GC)机制：

> 如果一个对象不再被引用，那么这个对象就会被GC回收。
>
> 如果两个对象互相引用，而不再被第三者所引用，那么这两个互相引用的对象也会被回收。

- 闭包应用
  1. setTimeout/setInterval
  2. 回调函数（callback）
  3. 事件句柄（event handle）
  4. 模块化开发