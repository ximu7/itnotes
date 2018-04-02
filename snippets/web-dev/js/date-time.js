// 格式化日期 connector是连接符 如- 示例 1999-09-09
function formDate(d=new Date(),connector='-') {
     let [year, month, date] = [d.getFullYear(), d.getMonth() + 1, d.getDate()]
  if (month < 10) {
    month = "0" + month;
  }
  if (date < 10) {
    date = "0" + date;
  }
  return `${year}${connector}${month}${connector}${date}`
}