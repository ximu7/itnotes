//复制内容到剪切版
function copyFn(obj, content) {
  function copyText(ev,content) {
    let e = ev || event
    e.clipboardData.setData('text/plain', content)
    e.preventDefault()
  }
  obj.addEventListener('copy', copyText)
  document.execCommand('copy')
}
