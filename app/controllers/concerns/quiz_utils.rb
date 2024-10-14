module QuizUtils
  extend ActiveSupport::Concern # privateのメソッドをinclude先でもprivateにするために必要

  private

  # ログイン中のユーザーをセット
  def set_user_if_logged_in
    @current_user = current_user if logged_in?
  end


  # 距離計算ロジック
  def calculate_distance(location1, location2)
    origin = "#{location1.latitude},#{location1.longitude}"
    destination = "#{location2.latitude},#{location2.longitude}"
    api_key = ENV.fetch('MAPS_JAVASCRIPT_API', nil)

    # APIエンドポイントに対して2点間の距離を計算するための情報を渡す
    url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=#{origin}&destinations=#{destination}&key=#{api_key}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    # APIから帰ってきたdataから必要な情報を取り出し、単位kmに変換する
    distance_in_km = data['rows'][0]['elements'][0]['distance']['value'] / 1000.0
    distance_in_km.round.to_i
  end


  # 選択肢を生成するロジック
  def generate_choices(distance)
    # distanceに基づいてダミーデータの範囲を設定(±30%)
    variation = (distance * 0.3).round

    # distanceを基準としたダミーデータを4つ作成する。整数で出力。
    dummy_distances = [
      (distance + rand(variation..(variation * 2))).to_i,
      (distance + rand(variation..(variation * 2))).to_i,
      (distance - rand(variation..(variation * 2))).to_i,
      (distance - rand(variation..(variation * 2))).to_i
    ]

    # 上記のdummy_distanceから0以上の値を条件に取り出す
    valid_distances = dummy_distances.select { |d| d >= 0 }

    # 4つのダミーデータから2つをランダムで選択し正答と合わせてchoiceに代入する
    selected_dummies = valid_distances.sample(2)
    choices = [distance.to_i] + selected_dummies

    # 要素を並び替える
    choices.shuffle
  end


  # 地図表示のため、JavaScriptに渡せるように設定
  def set_gon_locations(locations)
    ## 地点1
    gon.latitude1 = @locations[0].latitude
    gon.longitude1 = @locations[0].longitude
    ## 地点2
    gon.latitude2 = @locations[1].latitude
    gon.longitude2 = @locations[1].longitude
  end


  # セッションに保存する
  def set_session_data(locations, distance, choices)
    session[:locations] = locations.map(&:id)
    session[:correct_answer] = distance.to_i
    session[:choices] = choices
  end


  # 回答履歴を保存する
  def save_quiz_history(mode)
    QuizHistory.create!(
      user_id: @current_user.id,
      location1_id: @locations[0].id,
      location2_id: @locations[1].id,
      user_answer: @selected_choice,
      correct_answer: @correct_answer,
      is_correct: @is_correct,
      mode: mode
    )
  end

end
