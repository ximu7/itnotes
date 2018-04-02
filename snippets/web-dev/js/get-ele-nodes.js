function ele(...elesInfo){
    //正则 id选择器 和:nth-child() nth-last-child() :first-child :last-child 选择器返回单个节点
    const reg = /#[\w-]+$|:(first|last)-child$|:nth-(last-)?child\(\d+\)$/;

    //通过参数对象的键值（选择器）取得的节点对象
    let node = null;

    //如果传入的参数只有一个且只是一个选择器（字符串）
    if (elesInfo.length === 1 && typeof elesInfo[0] === 'string') {
      return getNode(elesInfo);
    }

    //存放节点对象（们）的对对象 传入参数列表 列表中每个参数都是一个对象 如：{objDiv1:'#div1'}
    const nodes = {};

    //参数对象的键名（给 选择器 取得的节点对象（/列表）起的名字） | 参数对象的键值（选择器）
    let [nodeName, selector] = [null, null];

    for (let item of elesInfo) {
      //参数对象的键名
      nodeName = Object.keys(item)[0];

      let index = null;
      //如果传入对象存在index
      if (item.index) {
        index = item.index;
      }

      //根据键名获取键值（选择器）
      selector = item[nodeName];

      //根据选择器获取节点对象（/列表）
      node = getNode(selector, index);

      //将获取的节点对象（/列表） 存到一个对象上 键名为传入的名字 键值为根据选择器获取的节点对象（/列表）
      nodes[nodeName] = node;
    }

    return nodes;

    function getNode(selector, index = null) {
      //符合正则条件的返回单个节点对象
      if (reg.test(selector)) {
        return document.querySelector(selector);
      }

      //如果不符合正则 返回节点对象列表
      const nodeList = document.querySelectorAll(selector);

      //如果传入了index
      if (index) {
        // 返回节点对象列表中第index个节点对象
        return nodeList[index];
      }
      // 否则返回整个节点对象列表
      return nodeList;
    }
  }
