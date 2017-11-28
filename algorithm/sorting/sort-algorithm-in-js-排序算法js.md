学习一下基本算法，以javascript手写一回，加个人理解。

主要学习参考

- 文档： [维基百科](https://zh.wikipedia.org/)    [義守大學资料-排序(sorting)](http://spaces.isu.edu.tw/upload/18833/3/web/sorting.htm)    [JS家的算法](http://www.jianshu.com/p/1b4068ccd505)
- 动画：[algomation.com](http://www.algomation.com/)   [visualgo.net-sorting](https://visualgo.net/zh/sorting)    [toptal-Nearlysort Initial order](https://www.toptal.com/developers/sorting-algorithms/nearly-sorted-initial-order)
- 其他……

注：以下均是从小到大的排序。

[TOC]

# 插入insertion

复杂度：平均$O(n^2)$ 最好$O(n)$ 最坏$O(n^2)$

![insertion](insertion.gif)

> 1. 从第一个元素开始，该元素可以认为已经被排序
> 2. 取出下一个元素，在已经排序的元素序列中从后向前扫描
> 3. 如果该元素（已排序）大于新元素，将该元素移到下一位置
> 4. 重复步骤3，直到找到已排序的元素小于或者等于新元素的位置
> 5. 将新元素插入到该位置后
> 6. 重复步骤2~5

```javascript
function insetion(arr) {
  for (let i = 1; i < arr.length; i++) {
    let temp = arr[i];//抽出本轮要排序的元素
    let insertIndex = i;//默认插入位置
    for (let j = i; j > 0; j--) {
      if (temp < arr[j - 1]) {
        arr[j] = arr[j - 1];//前一位后移一位
        insertIndex = j - 1;//更改插入位置
      } else { //如果前面的数字更小
        break; //停止本轮插入位置寻找
      }
    }
    arr[insertIndex] = temp;//插入正确位置
  }
  return arr;
}
```

插入排序类似打麻将/扑克拿牌阶段的排序思路：

1. 得到第一张牌（i=0）时不存在排序问题，得到第二张牌（i=1）时才进行插入排序

2. 每次新得到的牌的大小（temp，即arr[i]）与已经得到的牌中最后一张——即新得到牌的前一张进行对比（j-1，因为i=j，所以第一次对比就是i与i-1对比）

   - 如果新得到的牌更大，说明该牌位置不变（insertIndex还是i），停止插入排序，拿下一张牌进行排序

   - 如果新得到的牌更小：将上一张牌后移，空出位置，该位置可能是新牌的插入位置(insertIndex)

     ……继续将新得到的牌与上上一张对比（j--就是(i-1)--），符合就按上面移动规则操作，不符合就停止对比，将新得到的牌插入到指定位置(insertIndex)

# 选择selection

复杂度：平均$O(n^2)$  最好$O(n^2)$  最坏$O(n^2)$

![selection](selection.gif)

> 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置
>
> 再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾。
>
> 以此类推，直到所有元素均排序完毕。

```javascript
function selection(arr) {
  for (let i = 0; i < arr.length-1; i++) {
    let flag = i;//每轮给第i个元素立一个flag
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[j] < arr[flag]) {//从i+1(j)开始和flag对比
        flag = j;
      }
    }
    let temp = arr[i];
    arr[i] = arr[flag];
    arr[flag] = temp;
  }
  return arr;
}
```

比喻：夺旗——按报名顺序对参赛选手进行编号（队列），每个选手实力不同（数值），比赛目地是按实力顺序重新编号。

1. 第一轮将旗帜给一号选手（arr[flag] <- arr[i]，此时i=0），一号成为旗手(arr[flag])，二号（arr[j]，j=i+1，此时j=0+1=1)和旗手（一号）较量，胜者获取旗帜成为旗手（若一号获胜，旗手依然是一号），三号再和旗手（一号和二号中的胜者）较量，依次类推……

2. 所有选手都参与后，最终得旗者晋级，晋级者和原一号选手调换编号（当然如果晋级者就是原一号，则调换后还是一号），晋级者不再参与下一轮角逐，余者（二号到最后编号）继续下一轮；

   第二轮将旗帜给剩余参赛选手中的第一个——即二号位置选手(arr[flag]=arr[i]，此时i=1)，再按以上两点规则进行，直到某轮参赛选手只有旗手一人时结束（内层循环无法进行，因为i=arr.lengt，i=j，j+1不再比arr.length小，最后一位旗手i自动获胜，自己和自己换位置……）

---

也可以新建队列存储每轮最小（大）的元素。

j=i+1：每轮j++就是(i+1)++，即从i后面一个开始与i对比

# 冒泡bubble

复杂度：平均$O(n^2)$ 最好$O(n)$ 最坏$O(n^2)$

![bubble](bubble.gif)

> 1. 比较相邻的元素。如果第一个比第二个大，就交换他们两个。
> 2. 对**每一对相邻元素**作同样的工作，从开始第一对到结尾的最后一对。这步做完后，最后的元素会是最大的数。
> 3. 针对所有的元素重复以上的步骤，除了最后一个。
> 4. 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。

```javascript
function bubble(arr) {
  for (let i = 0; i < arr.length; i++) {
    for (let j = 0; j < arr.length - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        let temp = arr[j + 1];
        arr[j + 1] = arr[j];
        arr[j] = temp;
      }
    }
  }
  return arr;
}
```

第二个循环的`arr.length-i-1`：

- `-1`：对比大小时，最后一个arr[j+1]不能比数组长度arr.length更大，循环条件限制为arr.length-1后，最后一次对比时arr[j+1]就刚好是arr[arr.length]；
- `-i`：第1轮循环对比后，最大值就被移动到了队列尾部（倒数第1位置），第2轮循环对比后，次大值就被移动到了队列倒数第2位置……以此类推，故而第i轮循环中，不必再对比倒数第i个值与前面的值的大小。

# 快速quick

复杂度：平均$O(n log n)$ 最好$O(n log n)$ 最坏$O(n^2)$

> 快速排序应该算是在冒泡排序基础上的递归**分治**法。

![quick](quick.gif)

> 1. 从数列中挑出一个元素，称为"基准"（pivot），
> 2. 重新排序数列，所有比基准值小的元素摆放在基准前面，所有比基准值大的元素摆在基准后面（相同的数可以到任何一边）。在这个分区结束之后，该基准就处于数列的中间位置。这个称为**分区（partition）**操作。
> 3. [递归](https://zh.wikipedia.org/wiki/%E9%80%92%E5%BD%92)地（recursively）把小于基准值元素的子数列和大于基准值元素的子数列排序。

```javascript
function quickSort(arr) {
  if (arr.length <= 1) {
    return arr;
  }
  if (arr.length === 2) {
    if (arr[1] < arr[0]) {
      return [arr[1], arr[0]];
    }
    return arr;
  }
  let midIndex = Math.floor(arr.length / 2);
  let midVal = arr.splice(midIndex, 1)[0];
  const leftArr = [];
  const rightArr = [];
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] < midVal) {
      leftArr.push(arr[i]);
    } else {
      rightArr.push(arr[i]);
    }
  }
  return quickSort(leftArr).concat([midVal], quickSort(rightArr));
}
```

以上代码利用了外部空间（新建了数组）进行排序，并且选用了数组中间元素作为基准：

1. 将数组中间的元素(midIndex)取出来（splice），作为基准(midVal=arr[mideIndex])

2. 新建两个“左、右”数组（leftArr和rightArr）

3. 大于基准的元素放到“左边”数组中，小于基准的元素放到“右边”的数组中

   这样就有了三个小数组：左边数组、中间数组（就只有midValue一个元素）和右边数组

   在左右两个数组中重复前两步，左/右边数组也分成了三个更小的数组……按照这个方法拆分排序直到一每个数组都只有一个或两个元素为止……最后将所有部分组合在一起。

# 归并merge

复杂度：平均$O(n log n)$ 最好$O(n log n)$ 最坏$O(n log n)$

![merge](merge.gif)

> 迭代法
>
> > 申请空间，使其大小为两个已经排序序列之和，该空间用来存放合并后的序列
> > 设定两个指针，最初位置分别为两个已经排序序列的起始位置
> > 比较两个指针所指向的元素，选择相对小的元素放入到合并空间，并移动指针到下一位置
> > 重复步骤3直到某一指针到达序列尾
> > 将另一序列剩下的所有元素直接复制到合并序列尾
>
> 遞歸法（假设序列共有n个元素）
>
> > 将序列每相邻两个数字进行归并操作，形成 f l o o r ( n / 2 ) {\displaystyle floor(n/2)} floor(n/2)个序列，排序后每个序列包含两个元素
> > 将上述序列再次归并，形成 f l o o r ( n / 4 ) {\displaystyle floor(n/4)} floor(n/4)个序列，每个序列包含四个元素
> > 重复步骤2，直到所有元素排序完毕



# 基数counting

![counting](counting.gif)