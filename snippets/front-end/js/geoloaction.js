function success(pos) {
  console.log(pos.coords);
  //codes
}
function error(err) {
  console.log("定位失败");
}

navigator.geolocation.getCurrentPosition(success, error);