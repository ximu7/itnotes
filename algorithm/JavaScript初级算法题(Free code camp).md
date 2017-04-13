JavaScript初级算法题(Free code camp)链接：[英文版](http://freecodecamp.com/challenges/get-set-for-our-algorithm-challenges)---[中文版](http://freecodecamp.cn/challenges/get-set-for-our-algorithm-challenges)

---

[TOC]

# Reverse a String翻转字符串

```javascript
function reverseString(str) {
	return str.split("").reverse().join("");
}
```

# Factorialize a Number阶乘

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

# Check for Palindromes回文检验

```javascript
function palindrome(str) {
     //去掉非字母数字、空白字符和下划线
    str = str.replace( /[\W\s_]/g,"").toLowerCase();
    return str === str.split("").reverse().join("");
}
```

# Find the Longest Word in a String寻找句中最长单词

*得到最长单词的长度。*

```javascript
function findLongestWord(str) {
	var arr=str.split(/\s/g);
	for(var i=0;i<arr.length-1;i++){
    	if(arr[i].length>arr[i+1].length){
			arr[i+1]=arr[i];
    	}
	}
 	return arr[arr.length-1].length;
}
```

# Title Case a Sentense句中单词首字母大写

```javascript
function titleCase(str) {
	var arr=str.toLowerCase().split(" ");
	var narr=[];
	for(var i=0;i<arr.length;i++){
		arr[i]=arr[i][0].toUpperCase()+arr[i].slice(1);
    	}//首字母大写+截取第二到最后一个字母
    return arr.join(" ");
}
```

# Return Largest Numbers in Arrays获得数组的每个**子数组**中最大的数字

```javascript
function largestOfFour(arr) {
	var narr=[];  
	for(var i=0;i<arr.length;i++){
		for(var j=0;j<arr[i].length;j++){//遍历每个子数组
			if(arr[i][j]>arr[i][j+1]){//后方元素数值大于前方元素数值
				arr[i][j+1]=arr[i][j];//大数值取代小数值
			}
		}//循环结束后，最后一个元素的值是数组中最大的值
		narr.push(arr[i][arr[i].length-1]);//arr[i].length-1是子数组末尾元素的索引值
	}
	return narr;
}
```

# Confirm the Ending检测一个字符串是否以另一个字符串结尾

```javascript
function confirmEnding(str, target) {
	//substr(start,end); str长度减去target长度=start,target长度=end
	return target===str.substr(str.length-target.length,target.length);
}

```

# Repeat a string重复字符串

```javascript
function repeat(str, num) {
	var strn="";
    var i=0;
    while(i<num){
    	strn+=str;
		i++;
	}
	return strn;
}
```

# Chunky Monkey将数组元素分成指定个数的子数组

*将数组元素（根据给定的元素个数（示例代码中的size））划分为若干个子数组，如果最后一组数组元素个数不够，也算成一组。*

```javascript
function chunk(arr, size) {
	var narr=[];
	for(var i=0;i<arr.length;i+=size){
		narr.push(arr.slice(i,i+size));
	}//隔size个元素划分一次（push到新数组中）
	return narr;
}
```

# Slasher Flick从数组中去掉指定个数元素

*从数组中去掉前n个元素，得的到新数组。*

```javascript
function slasher(arr, howMany) {
	return arr.slice(howMany);
	//或者	//return arr.splice(howMany);
}
```

# Mutations一个字符串中是否包含另一个字符串中的所有字符

*忽略顺序和大小写。示例代码中的两个字符串是一个数组的两个元素，如：["str1","str2"]*。题目见[fcc-mutations](http://freecodecamp.cn/challenges/mutations)

```javascript
function mutation(arr) {
	for(var i=0;i<arr[1].length;i++){
		if(arr[0].toLowerCase().indexOf(arr[1][i].toLowerCase())===-1){
    		return false;
		}//将字符串2中的每一个字符与字符串一的
	}
  return true;
}
```

# Falsy Bouncer去除数组中的**假值**元素

```javascript
function bouncer(arr) {
	arr=arr.filter(function(val){
    if (Boolean(val).valueOf()===true){
    	return val;
    }
	});
	return arr;
}
```

JavaScript中，假值有`false`、`null`、`0`、`""`、`undefined` 和 `NaN`。

# Seek and Destroy从数组中删除指定元素

*例如从数组[1,2,3]中删除1,2：`destoryer([1,2,3],2,3)`。*
```javascript
function destroyer(arr) {
	var narr = [];
	for(var i = 1; i < arguments.length; i++){
    	narr.push(arguments[i]);
	}
	narr = arr.filter(function(item,index,array){
    	return narr.indexOf(item) ===-1;//从narr中选出在arr中找不到的元素
	});
	return narr;
}
```

# Where do I belong判断一个数字在数组中的索引位置

*数组元素（此代码例子中为数字数组）要按数值进行从小到大排列，求得某个数字放入排列好的数组中后的索引位置（该数字遵循大小顺序放入数组中，该数字与数组中元素值一致则放在相同大小的元素前方）。如3放在数组[1,3,5,2,4,6]中的索引值是2。*题目见[where do I belong](http://freecodecamp.cn/challenges/where-do-i-belong)。

```javascript
function where(arr, num) {
   	arr=arr.sort(function(a,b){
		return a-b;
		});//从小到大排序
  
	for(var i=0;i<arr.length;i++){
    	if(arr[i]>=num){
      		return i;
		}//当第i个元素大于或等于num，就返回他自身的index值
	}
	return arr.length;//如果数组中元素数值都比num小，则num就放在末尾
}
```

# ROT13解密

[ROT13-维基百科](https://zh.wikipedia.org/wiki/ROT13)。

*为了使代码不那么冗长，直接用了查得的字母char code数值。*

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