class QuizzesController < ApplicationController

  def new
    # ランダムに並び替え、そのうち2件を取得する
    @locations = Location.order("RANDOM()").limit(2)
    # calculate_distanceのメソッドに対して上記で取得した2地点を引数として渡す
    @distance = calculate_distance(@locations[0], @locations[1])

    # Javascriptに渡せるように設定
    gon.location1 = @locations[0]
    gon.location2 = @locations[1]
  end

  def show;end

  private

  # 距離計算ロジック location1とlocation2は、newメソッドの@locations[0]と@locations[1]とイコール
  def calculate_distance(location1, location2)
    # 出発地点と到着地点の緯度経度をそれぞれoriginとdestinationに代入
    origin = "#{location1.latitude},#{location1.longitude}"
    destination = "#{location2.latitude},#{location2.longitude}"

    api_key = ENV['MAPS_JAVASCRIPT_API']

    # APIエンドポイントに対して2点間の距離を計算するための情報を渡す
    url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=#{origin}&destinations=#{destination}&key=#{api_key}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    # APIから帰ってきたdataから必要な情報を取り出し、単位kmに変換する
    distance_in_km = data["rows"][0]["elements"][0]["distance"]["value"] / 1000.0
    distance_in_km.round(1)
  end
end
