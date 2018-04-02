 //ajax 传参类似jquery的$.ajax()方法
  function ajax(info) {
    //1. 实例化xhr对象
    const xhr = new XMLHttpRequest();
    //如果要兼容ie 记得将const改成let
    //if (!window.XMLHttpRequest) {
    //  xhr = new ActiveXObject('Microsoft.XMLHTTP');
    //}

    //2. 建立请求
    xhr.open(info.type = 'get', info.url, info.async = true);

    //3. 发送请求
    if (info.data) {
      xhr.send(info.data);
    } else {
      xhr.send(null);
    }

    //回调方法
    const callback = {
      success: function (res) {
        if (info.success) {
          info.success(res);
        } else {
          //eslint-disable-next-line no-console
          console.log(
            '服务器成功响应，但是没有传入回调函数进行相关操作。\n你需要在ajax()传入的参数中添加一个success属性，其属性值是一个函数/方法的名字。该函数（方法）至少有一个参数，该参数即是ajax获取到的响应内容。\n示例：ajax({url:aUrl,success:fnName})'
          );
        }
      },
      error: function (status) {
        if (info.error) {
          info.error(status);
        } else {
          //eslint-disable-next-line no-console
          console.log('服务器错误：' + status);
        }
      }
    };

    //4. 获取回应
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          callback.success(xhr.responseText);
        } else {
          callback.error(xhr.status);
        }
      }
    };
  }
