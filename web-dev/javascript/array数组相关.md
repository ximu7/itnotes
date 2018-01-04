# 数组去重
- 排序后去重：先将原数组排序，在与相邻的进行比较，如果不同则存入新数组

  注意：影响数组元素顺序

  ```javascript
  function deleteRepeate(arr) {
    const result = [];
    arr = arr.sort();
    for (let i = 0; i < arr.length; i++){
      if (arr[i] != arr[i + 1]) {
        result.push(arr[i])
      }
    }
    return result;
  }
  ```

- 下标查询

  ```javascript
  function deleteRepeate(arr) {
    const result = [arr[0]];
    for (let i = 0; i < arr.length; i++){
      if (result.indexOf(arr[i])===-1) {
        result.push(arr[i])
      }
    }
    return result;
  }
  ```

- 组逐一对比去重：新建一个数组并存放原数组的第一个元素，然后将原数组元素和新数组的元素一一对比，若不同则存放在新数组中。

  ```javascript
  function deleteRepeate(arr) {
    const result = [arr[0]];
    for (let i = 1; i < arr.length; i++) {
      let isSame = false; //每次循环时对比
      for (let j = 0; j < result.length; j++) {
        if (result[j] === arr[i]) {
          isSame = true; //arr[i]和result中某个元素相同
          break; //直接中止arr[i]继续和result中各项的对比
        }
      }
      if (isSame === false) {//说明arr[i]和result中所有元素不同
        result.push(arr[i]);
      }
    }
    return result;
  }
  ```

- 使用set

  ```javascript
  const arr=[1,2,3,3,2]
  const list=new Set(arr) //转换成set 将自动去重
  arr=Array.from(list) //使用from方法将set转为数组
  ```



# 获得数组的每个子数组中最大的数字

Return Largest Numbers in Arrays

```javascript
function largestOfFour(arr) {
	var narr=[];  
	for(var i=0;i<arr.length;i++){
		for(var j=0;j<arr[i].length;j++){//遍历每个子数组
			if(arr[i][j]>arr[i][j+1]){//后方元素数值大于前方元素数值
				arr[i][j+1]=arr[i][j];//大数值取代小数值
			}
		}//循环结束后，最后一个元素的值是数组中最大的值
		narr.push(arr[i][arr[i].length-1]);
	}
	return narr;
}
```