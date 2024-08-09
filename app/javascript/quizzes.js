document.addEventListener("DOMContentLoaded", function () {
  // 地図の初期化
  const initMap = () => {
    // location1とlocation2にquizzes/newで取得したランダムの地点の緯度と軽度の情報を代入する
    const location1 = { lat: gon.location1.latitude, lng: gon.location1.longitude };
    const location2 = { lat: gon.location2.latitude, lng: gon.location2.longitude };

    service.getDistanceMatrix(
      {
        // 出発地点
        origin: location1,
        // 到着地点
        destination: location2,
        // 移動手段（運転モード）　道路網を使用した場合の移動距離を表示する
        travelMode: google.maps.TravelMode.DRIVING
      }
    );
  };

  initMap();
});