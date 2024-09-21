// 地図の初期化
function initMap(){
  const directionsService = new google.maps.DirectionsService();  // 指定された出発地点から到着地点までの経路情報を取得するサービス
  const directionsRenderer = new google.maps.DirectionsRenderer();  // 取得した経路情報を地図上に表示するためのレンダラー
  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: 7,
    center: { lat: gon.latitude1, lng: gon.longitude1 }, // 地点1を地図の中心に設定
  });

  directionsRenderer.setMap(map);

  calculateAndDisplayRoute(directionsService, directionsRenderer);  // 出発地点と到着地点を設定して経路を表示する関数
}

function calculateAndDisplayRoute(directionsService, directionsRenderer) {
  directionsService  // 経路計算のリクエストを行うオブジェクト
    .route({  // 下記の条件に基づいて経路を計算するリクエストをAPIに送信するメソッド
      origin: {
        lat: gon.latitude1, // 地点1
        lng: gon.longitude1
      },
      destination: {
        lat: gon.latitude2, // 地点2
        lng: gon.longitude2
      },
      travelMode: google.maps.TravelMode.DRIVING,  // 移動手段
    })
    .then((response) => {  // 計算に成功したときに実行。地点1から地点2までの経路を地図上に表示
      directionsRenderer.setDirections(response);
    })
    .catch((e) => window.alert("Directions request failed due to " + e));  // 失敗した時にエラー内容をアラートで表示
}

initMap();
