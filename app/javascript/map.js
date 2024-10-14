// 地図の初期化
function initMap(){
  // gonの値が存在しているかを確認
  if (!gon.latitude1 || !gon.longitude1 || !gon.latitude2 || !gon.longitude2) {
    console.error("gonオブジェクトの値が不足しています。");
    window.alert("地図の初期化に必要な情報が不足しています。");
    return;  // 処理を中断
  }
  const mapCenter = { lat: gon.latitude1, lng: gon.longitude1 }; // 地点1を地図の中心に設定
  const map = createMap(mapCenter);

  const directionsService = new google.maps.DirectionsService(); // 指定された出発地点から到着地点までの経路情報を取得する
  const directionsRenderer = new google.maps.DirectionsRenderer();  // 取得した経路情報を地図上に表示する
  directionsRenderer.setMap(map);

  displayRoute(directionsService, directionsRenderer, mapCenter, { lat: gon.latitude2, lng: gon.longitude2 });
}

// 地図を作成する関数
function createMap(center) {
  return new google.maps.Map(document.getElementById("map"), {
    zoom: 7,
    center: center,
  });
}

// 経路を計算して表示する関数
function displayRoute(directionsService, directionsRenderer, origin, destination) {
  directionsService.route({
    origin: origin,  // 出発地点
    destination: destination,  // 到着地点
    travelMode: google.maps.TravelMode.DRIVING,  // 移動手段
  })
  .then((response) => {
    directionsRenderer.setDirections(response);  // 経路を表示
  })
  .catch((e) => routeError(e));  // エラーハンドリング
}

// 経路リクエストのエラーを処理する関数
function routeError(error) {
  console.error("Directions request failed", error);  // エラーをコンソールに表示
  window.alert("経路の取得に失敗しました。もう一度お試しください。");  // ユーザー向けのアラート
}

// ページが完全にロードされたらinitMapを実行
window.onload = initMap;