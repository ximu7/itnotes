# 阶乘Factorialize a Number

```javascript
var factorialize=function f(num) {//新建立一函数f
    if(num===0){
		return 1;
    }else{
	return num*f(num-1);//factorialize改变不影响此处（更松散的代码耦合）
  // return num*arguments.callee(num-1);//严格模式无法使用agrument.callee
  }
};
```


# 杨辉三角



# 斐波那契数列Fibonacci number

[斐波拉契数列](https://zh.wikipedia.org/wiki/%E6%96%90%E6%B3%A2%E9%82%A3%E5%A5%91%E6%95%B0%E5%88%97)：该数列用0和1开始，之后的数字都是前两个数字之和。（0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233）

- 递归

  ```javascript
  function fibonacci(n) {
    if (n <= 2) {
      if (n === 0) {
        return 0;
      }
      return 1;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
  }
  ```


- 迭代

  ```javascript
  function fibonacci(n) {
    let n1 = 1; //斐波拉契第1项 注意：0是第0项
    let n2 = 1; //斐波拉契第2项
    let n3 = 0; //目标数
    for (let i = 0; i < n-2; i++) {
      n3 = n1 + n2;
      n1 = n2;
      n2 = n3;
    }
    return n3;
  }
  ```



# ROT13解密

[ROT13-维基百科](https://zh.wikipedia.org/wiki/ROT13)。

*

```javascript
function rot13(str) { // LBH QVQ VG!
	var arr=str.split("");
//A-N,O-Z;   a-m： +13  |  n-z： -13
//charA="A".charCodeAt();//A编码65
//charZ="Z".charCodeAt();//Z编码90
// middle=(charA+charZ)/2;//（90+65）/2=77.5 
	for(var i=0;i<arr.length;i++){
    	var index=str.charCodeAt(i);
		if(index<=77.5 && index>=65){
			arr[i]=String.fromCharCode(index+13);
    		}
		if(index>77.5 && index<=90){
			arr[i]=String.fromCharCode(index-13);
    	}
  	}
	return arr.join("");
}
```
