class QuizzesController < ApplicationController
  # ログインしている場合にのみユーザーをセットする
  before_action :set_user_if_logged_in

  def new
    # ランダムに並び替え、そのうち2件を取得する
    @locations = Location.order("RANDOM()").limit(2)

    # Javascriptに渡せるように設定
    gon.location1 = @locations[0]  # 地点1
    gon.location2 = @locations[1]  # 地点2

    # calculate_distanceのメソッドに対して上記で取得した2地点を引数として渡す
    @distance = calculate_distance(@locations[0], @locations[1])

    # generate_choicesメソッドにAPIで計算した正答な距離を引数として@choicesに代入
    @choices = generate_choices(@distance)

    # セッションに保存
    session[:locations] = @locations.map(&:id)
    session[:correct_answer] = @distance
    session[:choices] = @choices
  end

  def show
    # 各sessionの値を取得し、インスタンス変数に代入する
    @locations = Location.find(session[:locations])
    @correct_answer = session[:correct_answer].to_i
    @selected_choice = params[:selected_choice].to_i

    # JavaScriptに渡せるように設定
    ## 地点1
    gon.latitude1 = @locations[0].latitude
    gon.longitude1 = @locations[0].longitude

    ## 地点2
    gon.latitude2 = @locations[1].latitude
    gon.longitude2 = @locations[1].longitude

    # ログインしている場合にのみ回答履歴を保存
    if @current_user
      QuizHistory.create!(
        user_id: @current_user.id,
        location1_id: @locations[0].id,
        location2_id: @locations[1].id,
        user_answer: @selected_choice,
        correct_answer: @correct_answer,
        is_correct: @selected_choice == @correct_answer,
        answered_at: Time.current
      )
    end

    # ユーザーが選んだ回答が正解か判断し、その結果をインスタンス変数に代入する
    if @selected_choice == @correct_answer
      @result = t('quizzes.show.correct')
    else
      @result = t('quizzes.show.incorrect')
    end
  end

  private

  # ログイン中のユーザーをセット
  def set_user_if_logged_in
    @current_user = current_user if logged_in?
  end

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

end
